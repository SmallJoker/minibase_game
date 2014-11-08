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
		damage = def.damage,
		light_damage = def.light_damage,
		water_damage = def.water_damage,
		lava_damage = def.lava_damage,
		disable_fall_damage = def.disable_fall_damage,
		drops = def.drops,
		armor = def.armor,
		drawtype = def.drawtype,
		on_rightclick = def.on_rightclick,
		type = def.type,
		attack_type = def.attack_type,
		arrow = def.arrow,
		shoot_interval = def.shoot_interval,
		sounds = def.sounds,
		animation = def.animation,
		follow = def.follow,
		jump = def.jump or true,
		
		timer = 0,
		env_damage_timer = 0, -- only if state = "attack"
		attack = nil,
		state = "stand",
		v_start = false,
		old_y = nil,
		lifetimer = 600, --10 min
		tamed = false,
		
		set_velocity = function(self, v)
			local yaw = self.object:getyaw()
			if self.drawtype == "side" then
				yaw = yaw+(math.pi/2)
			end
			local x = math.sin(yaw) * -v
			local z = math.cos(yaw) * v
			self.object:setvelocity({x = x, y = self.object:getvelocity().y, z = z})
		end,
		
		get_velocity = function(self)
			local v = self.object:getvelocity()
			return (v.x^ 2 + v.z^ 2) ^(0.5)
		end,
		
		set_animation = function(self, type)
			if not self.animation then
				return
			end
			if not self.animation.current then
				self.animation.current = ""
			end
			if self.animation.current == type then
				return
			end
			
			if type == "stand" then
				if self.animation.stand_start
						and self.animation.stand_end
						and self.animation.speed_normal then
					self.object:set_animation(
						{x = self.animation.stand_start, y = self.animation.stand_end},
						self.animation.speed_normal, 0
					)
					self.animation.current = "stand"
				end
			elseif type == "walk" then
				if self.animation.walk_start
						and self.animation.walk_end
						and self.animation.speed_normal then
					self.object:set_animation(
						{x = self.animation.walk_start, y = self.animation.walk_end},
						self.animation.speed_normal, 0
					)
					self.animation.current = "walk"
				end
			elseif type == "run" then
				if self.animation.run_start
						and self.animation.run_end
						and self.animation.speed_run then
					self.object:set_animation(
						{x = self.animation.run_start, y = self.animation.run_end},
						self.animation.speed_run, 0
					)
					self.animation.current = "run"
				end
			elseif type == "punch" then
				if self.animation.punch_start
						and self.animation.punch_end
						and self.animation.speed_normal then
					self.object:set_animation(
						{x = self.animation.punch_start, y = self.animation.punch_end},
						self.animation.speed_normal, 0
					)
					self.animation.current = "punch"
				end
			end
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
				if player_count == 0 and self.state ~= "attack" then
					self.object:remove()
					return
				end
			end
			
			local accel = {x = 0, y = 0, z = 0}
			if self.object:getvelocity().y > 0.1 then
				local yaw = self.object:getyaw()
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
				accel.x = math.sin(yaw) * -2
				accel.z = math.cos(yaw) * 2
			else
				if minetest.get_item_group(minetest.get_node(self.object:getpos()).name, "water") ~= 0 then
					self.object:setacceleration({x = 0, y = 1.5, z = 0})
				else
					self.object:setacceleration({x = 0, y = -10, z = 0})
				end
			end
			if minetest.get_item_group(minetest.get_node(my_pos).name, "water") ~= 0 then
				accel.y = 1.1
			else
				accel.y = -10
			end
			self.object:setacceleration(accel)
			
			self.timer = self.timer + dtime
			if self.state ~= "attack" then
				if self.timer < 1.0 then return end
				self.timer = 0
			end
			
			local do_env_damage = function(self)
				local pos = self.object:getpos()
				local n = minetest.get_node(pos)
				
				local light = minetest.get_node_light(pos) or 16
				if self.light_damage and self.light_damage ~= 0
						and pos.y > -10
						and light > 7 then
					
					self.object:set_hp(self.object:get_hp()-self.light_damage)
					minetest.sound_play("player_damage", {object = self.object, gain = 0.25})
					if self.object:get_hp() <= 0 then
						minetest.sound_play("player_death", {object = self.object, gain = 0.4})
						self.object:remove()
					end
				end
				
				if self.water_damage and self.water_damage ~= 0 and
						minetest.get_item_group(n.name, "water") ~= 0 then
					
					self.object:set_hp(self.object:get_hp()-self.water_damage)
					minetest.sound_play("player_damage", {object = self.object, gain = 0.25})
					if self.object:get_hp() <= 0 then
						minetest.sound_play("player_death", {object = self.object, gain = 0.4})
						self.object:remove()
					end
				end
				
				if self.lava_damage and self.lava_damage ~= 0 and
					minetest.get_item_group(n.name, "lava") ~= 0
				then
					self.object:set_hp(self.object:get_hp()-self.lava_damage)
					minetest.sound_play("player_damage", {object = self.object, gain = 0.25})
					if self.object:get_hp() <= 0 then
						minetest.sound_play("player_death", {object = self.object, gain = 0.4})
						self.object:remove()
					end
				end
			end
			
			self.env_damage_timer = self.env_damage_timer + dtime
			if self.state == "attack" and self.env_damage_timer > 0.9 then
				self.env_damage_timer = 0
				do_env_damage(self)
			elseif self.state ~= "attack" then
				do_env_damage(self)
			end
			
			local s = self.object:getpos()
			local p, vec, dist = false, false, false
			if self.type == "monster" and not self.attack then
				for _,player in ipairs(minetest.get_connected_players()) do
					if not dist then
						p = player:getpos()
						vec = vector.subtract(p, s)
						dist = (vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2) ^ 0.5
					end
					if dist < self.view_range then
						self.state = "attack"
						self.attack = player
						break
					else
						dist = false
					end
				end
			end
			
			if self.follow ~= "" and not self.following then
				for _,player in ipairs(minetest.get_connected_players()) do
					if not dist then
						p = player:getpos()
						vec = vector.subtract(p, s)
						dist = (vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2) ^ 0.5
					end
					if dist < self.view_range then
						self.following = player
						break
					else
						dist = false
					end
				end
			end
			
			if self.following then
				if self.following:get_wielded_item():get_name() ~= self.follow then
					self.following = nil
				else
					if not dist then
						p = self.following:getpos()
						if not p then
							self.following = nil
							return
						end
						vec = vector.subtract(p, s)
						dist = (vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2) ^ 0.5
					end
					if dist > self.view_range then
						self.following = nil
						self.v_start = false
					else
						local yaw = math.atan(vec.z/vec.x)+math.pi/2
						if self.drawtype == "side" then
							yaw = yaw + (math.pi/2)
						end
						if p.x > s.x then
							yaw = yaw + math.pi
						end
						self.object:setyaw(yaw)
						if dist <= 2.2 then
							self.v_start = false
							self:set_velocity(0)
							self:set_animation("stand")
							return
						end
						
						if not self.v_start then
							self.v_start = true
							self:set_velocity(self.walk_velocity)
						else
							if self:get_velocity() <= 0.5 and self.object:getvelocity().y == 0 then
								local v = self.object:getvelocity()
								v.y = 5.1
								self.object:setvelocity(v)
							end
							self:set_velocity(self.walk_velocity)
						end
						self:set_animation("walk")
						return
					end
				end
			end
			
			if self.state == "stand" then
				if math.random(1, 4) == 1 then
					self.object:setyaw(self.object:getyaw()+((math.random(0,360)- 14.50)/180*math.pi))
				end
				self:set_velocity(0)
				self:set_animation("stand")
				if math.random(1, 100) <= 50 then
					self:set_velocity(self.walk_velocity)
					self.state = "walk"
					self:set_animation( "walk")
				end
			elseif self.state == "walk" then
				if math.random(1, 100) <= 30 then
					self.object:setyaw(self.object:getyaw()+((math.random(0,360)- 14.50)/180*math.pi))
				end
				if self:get_velocity() < 0.5 and self.object:getvelocity().y == 0 then
					local v = self.object:getvelocity()
					v.y = 5.1
					self.object:setvelocity(v)
				end
				self:set_animation("walk")
				self:set_velocity(self.walk_velocity)
				if math.random(1, 100) <= 30 then
					self:set_velocity(0)
					self.state = "stand"
					self:set_animation("stand")
				end
			elseif self.state == "attack" then
				if not self.attack then
					self.state = "stand"
					self:set_animation("stand")
					return
				end
				if not dist then
					p = self.attack:getpos()
					if not p then
						self.attack = nil
						return
					end
					vec = vector.subtract(p, s)
					dist = (vec.x ^ 2 + vec.y ^ 2 + vec.z ^ 2) ^ 0.5
				end
				if dist > self.view_range or self.attack:get_hp() <= 0 then
					self.state = "stand"
					self.v_start = false
					self:set_velocity(0)
					self.attack = nil
					self:set_animation("stand")
					return
				end
				
				local yaw = math.atan(vec.z/vec.x)+math.pi/2
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
				if p.x > s.x then
					yaw = yaw+math.pi
				end
				self.object:setyaw(yaw)
				if dist <= 2.2 then
					self:set_velocity(0)
					self:set_animation("punch")
					self.v_start = false
					if self.timer > 1.0 then
						self.timer = 0
						minetest.sound_play("mobs_punch", {object = self.object, gain = 1})
						self.attack:punch(self.object, 1.0,  {
							full_punch_interval = 1.0,
							damage_groups = {fleshy = self.damage}
						}, vec)
					end
					return
				end
				
				if not self.v_start then
					self.v_start = true
					self:set_velocity(self.run_velocity)
				else
					if self:get_velocity() < 0.5 and self.object:getvelocity().y == 0 then
						local v = self.object:getvelocity()
						v.y = 5.1
						self.object:setvelocity(v)
					end
					self:set_velocity(self.run_velocity)
				end
				self:set_animation("run")
			end
		end,
		
		on_activate = function(self, staticdata, dtime_s)
			self.object:set_armor_groups({fleshy = self.armor})
			self.object:setacceleration({x = 0, y = -14.5, z = 0})
			self.state = "stand"
			self.object:setvelocity({x = 0, y = self.object:getvelocity().y, z = 0})
			self.object:setyaw(math.random(1, 360) / 180 *  math.pi)
			self.lifetimer = self.lifetimer - dtime_s
			if staticdata then
				local tmp = minetest.deserialize(staticdata)
				if tmp and tmp.lifetimer then
					self.lifetimer = tmp.lifetimer - dtime_s
				end
				if tmp and tmp.tamed then
					self.tamed = tmp.tamed
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
			if y <= 0 then
				self.object:setvelocity({x = 0, y = y + 4.5, z = 0})
			end
			if hp <= 0 then
				if hitter and hitter:is_player() and hitter:get_inventory() then
					local pos = self.object:getpos()
					minetest.sound_play("player_death", {object = self.object, gain = 0.4})
					minetest.sound_play("hit_death", {pos = hitter:getpos(), gain = 0.4})
					for _,drop in ipairs(self.drops) do
						if math.random(1, drop.chance) == 1 then
							hitter:get_inventory():add_item("main", ItemStack(drop.name .. " " .. math.random(drop.min, drop.max)))
						end
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