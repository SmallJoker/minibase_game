mobs = {}
function mobs:register_mob(name, def)
	minetest.register_entity(name, {
		hp_max = def.hp_max,
		physical = true,
		collisionbox = def.collisionbox,
		collide_with_objects = def.collide_with_objects,
		visual = def.visual,
		visual_size = def.visual_size,
		mesh = def.mesh,
		textures = def.textures,
		makes_footstep_sound = def.makes_footstep_sound,
		view_range = def.view_range,
		walk_velocity = def.walk_velocity,
		run_velocity = def.run_velocity,
		damage = def.damage or 0,
		light_damage = def.light_damage or 0,
		water_damage = def.water_damage or 0,
		lava_damage = def.lava_damage or 0,
		drops = def.drops,
		armor = def.armor,
		drawtype = def.drawtype,
		on_rightclick = def.on_rightclick,
		type = def.type,
		attack_type = def.attack_type,
		sounds = def.sounds,
		animation = def.animation,
		follow = def.follow or "",
		
		punch_timer = 0,
		env_damage_timer = 0,
		state = "stand",
		v_start = false,
		to_player = nil,
		lifetimer = 600, --10 min
		tamed = false,
		
		set_velocity = function(self, v)
			local yaw = self.object:getyaw()
			if self.drawtype == "side" then
				yaw = yaw + (math.pi/2)
			end
			local x = math.sin(yaw) * -v
			local z = math.cos(yaw) * v
			self.object:setvelocity({x = x, y = self.object:getvelocity().y, z = z})
		end,
		
		get_velocity = function(self)
			local v = self.object:getvelocity()
			return (v.x^2 + v.z^2) ^ (0.5)
		end,
		
		get_speed = function(self, type)
			local vel = 0
			if type == "walk" then
				vel = self.walk_velocity
			elseif type == "run" then
				vel = self.run_velocity
			end
			return vel
		end,
		
		set_animation = function(self, type)
			self:set_velocity(self:get_speed(type))
			
			if not self.animation then return end
			if self.animation.current == type then
				return
			end
			
			local anim, speed = nil, 0
			if type == "stand" then
				anim = {x = self.animation.stand_start, y = self.animation.stand_end}
				speed = self.animation.speed_normal
			elseif type == "walk" then
				anim = {x = self.animation.walk_start, y = self.animation.walk_end}
				speed = self.animation.speed_normal
			elseif type == "run" then
				anim = {x = self.animation.run_start, y = self.animation.run_end}
				speed = self.animation.speed_run
			elseif type == "punch" then
				anim = {x = self.animation.punch_start, y = self.animation.punch_end}
				speed = self.animation.speed_normal
			else
				return
			end
			
			self.object:set_animation(anim, speed, 0)
			self.animation.current = type
			self.state = type
		end,
		
		on_step = function(self, dtime)
			self.lifetimer = self.lifetimer - dtime
			local my_pos = self.object:getpos()
			if self.lifetimer <= 0 and not self.tamed then
				local player_count = 0
				for _,obj in ipairs(minetest.get_objects_inside_radius(my_pos, 12)) do
					if obj:is_player() then
						player_count = player_count + 1
					end
				end
				if player_count == 0 then
					self.object:remove()
					return
				end
			end
			
			local vel = self.object:getvelocity()
			local node = minetest.get_node(my_pos).name
			local accel = {x = 0, y = 0, z = 0}
			if vel.y > 0.1 then
				local yaw = self.object:getyaw()
				if self.drawtype == "side" then
					yaw = yaw + (math.pi/2)
				end
				accel.x = math.sin(yaw) * -2
				accel.z = math.cos(yaw) * 2
			end
			if minetest.get_item_group(node, "water") ~= 0 then
				accel.y = 2.1
			else
				accel.y = -10
			end
			self.object:setacceleration(accel)
			
			self.punch_timer = self.punch_timer + dtime
			if self.punch_timer < 1.0 then
				return
			end
			self.punch_timer = 0
			
			local real_speed = self:get_speed(self.state)
			if self:get_velocity() < real_speed - 0.15 and vel.y == 0 then
				vel.y = 6
				self.object:setvelocity(vel)
			else
				self:set_velocity(real_speed)
			end
			
			-- Env damage
			local light = minetest.get_node_light(my_pos) or 16
			local damage = 0
			
			if self.light_damage ~= 0 and my_pos.y > -10 and light > 7 then
				damage = self.light_damage
			end
			if self.water_damage ~= 0 and minetest.get_item_group(node, "water") ~= 0 then
				damage = damage + self.water_damage
			end
			if self.lava_damage ~= 0 and minetest.get_item_group(node, "lava") ~= 0 then
				damage = damage + self.lava_damage
			end
			
			if damage ~= 0 then
				self.object:set_hp(self.object:get_hp() - damage)
			end
			
			if damage > 0 then
				minetest.sound_play("player_damage", {object = self.object, gain = 0.25})
				if self.object:get_hp() <= 0 then
					minetest.sound_play("player_death", {object = self.object, gain = 0.4})
					self.object:remove()
					return
				end
			end
			
			local p, vec, dist = false, false, false
			if self.type == "monster" and not self.to_player then
				for _,player in ipairs(minetest.get_connected_players()) do
					p = player:getpos()
					vec = vector.subtract(p, my_pos)
					dist = (vec.x^2 + vec.y^2 + vec.z^2) ^ 0.5
					
					if dist < self.view_range and player:get_hp() > 0 then
						self.to_player = player
						break
					end
				end
			end
			
			if self.follow ~= "" and not self.to_player then
				for _,player in ipairs(minetest.get_connected_players()) do
					p = player:getpos()
					vec = vector.subtract(p, my_pos)
					dist = (vec.x^2 + vec.y^2 + vec.z^2) ^ 0.5
					
					if dist < self.view_range and
							player:get_wielded_item():get_name() == self.follow then
						self.to_player = player
						break
					end
				end
			end
			
			if self.to_player and self.type ~= "monster" then
				if self.to_player:get_wielded_item():get_name() ~= self.follow then
					self.to_player = nil
					self:set_animation("stand")
					return
				end
			end
			
			if self.to_player then
				if not dist then
					p = self.to_player:getpos()
					if not p then
						self.to_player = nil
						self:set_animation("stand")
						return
					end
					vec = vector.subtract(p, my_pos)
					dist = (vec.x^2 + vec.y^2 + vec.z^2) ^ 0.5
				end
				
				if dist > self.view_range or self.to_player:get_hp() <= 0 then
					self.v_start = false
					self.to_player = nil
					self:set_animation("stand")
					return
				end
				
				-- Target reached
				if dist <= 2.2 then
					self.v_start = false
					if self.type == "monster" then
						self:set_animation("punch")
							minetest.sound_play("mobs_punch", {object = self.object, gain = 1})
							self.to_player:punch(self.object, 1.0,  {
								full_punch_interval = 1.0,
								damage_groups = {fleshy = self.damage}
							}, vec)
					else
						self:set_animation("stand")
					end
					return
				end
				
				if not self.v_start then
					self.v_start = true
				end
				
				local yaw = math.atan(vec.z / vec.x) + math.pi/2
				if self.drawtype == "side" then
					yaw = yaw + (math.pi / 2)
				end
				if p.x > my_pos.x then
					yaw = yaw + math.pi
				end
				self.object:setyaw(yaw)
				
				if self.type == "monster" then
					self:set_animation("run")
				else
					self:set_animation("walk")
				end
				return
			end
			
			if self.state == "stand" or self.state == "walk" then
				local other_state = "walk"
				if self.state == "walk" then
					other_state = "stand"
				end
				
				local r = math.random(30)
				if r == 1 then
					self:set_animation(other_state)
				elseif r == 2 or r == 3 then
					self.object:setyaw(self.object:getyaw() + (math.random(-90, 90) / 180 * math.pi))
				end
			end
		end,
		
		on_activate = function(self, staticdata, dtime_s)
			self.object:set_armor_groups({fleshy = self.armor})
			self.object:setacceleration({x = 0, y = -10, z = 0})
			self:set_animation("stand")
			self.object:setyaw(math.random(360) / 180 * math.pi)
			self.lifetimer = self.lifetimer - dtime_s
			if staticdata then
				local tmp = minetest.deserialize(staticdata)
				if tmp then
					if tmp.lifetimer then
						self.lifetimer = tmp.lifetimer - dtime_s
					end
					if tmp.tamed then
						self.tamed = tmp.tamed
					end
				end
			end
			if self.lifetimer <= 0 and not self.tamed then
				self.object:remove()
			end
		end,
		
		get_staticdata = function(self)
			local tmp = {
				lifetimer = self.lifetimer,
				tamed = self.tamed,
			}
			return minetest.serialize(tmp)
		end,
		
		on_punch = function(self, hitter)
			local hp = self.object:get_hp()
			if hp >= 1 then
				minetest.sound_play("player_damage", {object = self.object, gain = 0.25})
				minetest.sound_play("hit", {pos = hitter:getpos(), gain = 0.4})
			end
			local y = self.object:getvelocity().y
			if y == 0 and self.state == "walk" then
				self.object:setvelocity({x = 0, y = y + 4, z = 0})
				self:set_velocity(self.walk_velocity)
			end
			if hp > 0 then
				return
			end
			
			if hitter and hitter:is_player() and hitter:get_inventory() then
				minetest.sound_play("player_death", {object = self.object, gain = 0.4})
				minetest.sound_play("hit_death", {pos = hitter:getpos(), gain = 0.4})
				for _,drop in ipairs(self.drops) do
					if math.random(drop.chance) == 1 then
						hitter:get_inventory():add_item("main", ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
					end
				end
			end
		end,
		
	})
end

mobs.spawning_mobs = {}
function mobs:register_spawn(name, description, nodes, max_light, min_light, chance, active_object_count, max_height, spawn_func)
	mobs.spawning_mobs[name] = true
	minetest.register_abm({
		nodenames = nodes,
		neighbors = {"air"},
		interval = 20,
		chance = chance,
		action = function(pos, node, _, active_object_count_wider)
			if active_object_count_wider > active_object_count then return end
			if not mobs.spawning_mobs[name] then return end
			pos.y = pos.y + 1
			if minetest.get_node(pos).name ~= "air" then return end
			if pos.y > max_height then return end
			if not minetest.get_node_light(pos) then return end
			if minetest.get_node_light(pos) > max_light then return end
			if minetest.get_node_light(pos) < min_light then return end
			if spawn_func and not spawn_func(pos, node) then return end
			minetest.add_entity(pos, name)
		end
	})
end