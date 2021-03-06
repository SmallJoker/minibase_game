base_mobs = {}
function base_mobs:register_mob(name, def)
	if (def.type == "monster" or def.type == "defensive") and (not def.damage or def.damage <= 0) then
		minetest.log("error", "The mob "..name.." with type '"..def.type.."' has no attack damage.")
	end
	
	minetest.register_entity(name, {
		hp_max = def.hp_max,
		physical = true,
		aggressive = false,
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
		fall_damage = def.fall_damage or 1,
		can_swim = def.can_swim or false,
		drops = def.drops,
		armor = def.armor,
		drawtype = def.drawtype,
		on_rightclick = def.on_rightclick,
		type = def.type,
		sounds = def.sounds,
		animation = def.animation,
		follow = def.follow or "",
		
		punch_timer = 0,
		state = "stand",
		to_player = nil,
		lifetimer = 600, --10 min
		tamed = false,
		old_y = nil,
		
		set_velocity = function(self, v)
			local yaw = self.object:get_yaw()
			if self.drawtype == "side" then
				yaw = yaw + (math.pi/2)
			end
			local x = math.sin(yaw) * -v
			local z = math.cos(yaw) * v
			self.object:set_velocity({x = x, y = self.object:get_velocity().y, z = z})
		end,
		
		get_velocity = function(self)
			local v = self.object:get_velocity()
			return (v.x^2 + v.z^2) ^ (0.5)
		end,
		
		get_speed = function(self, type)
			local vel = 0
			if type == "walk" then
				vel = self.walk_velocity
			elseif type == "run" then
				vel = self.run_velocity or self.walk_velocity
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
			local my_pos = self.object:get_pos()
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
			
			local vel = self.object:get_velocity()
			local node = minetest.get_node(my_pos).name
			local real_speed = self:get_speed(self.state)
			--[[local accel = {x = 0, y = 0, z = 0}
			if vel.y > 0.1 then
				local yaw = self.object:get_yaw()
				if self.drawtype == "side" then
					yaw = yaw + (math.pi/2)
				end
				accel.x = math.sin(yaw) * -2
				accel.z = math.cos(yaw) * 2
			end]]
			if self.can_swim then
				local accel = {x = 0, y = 0, z = 0}
				if minetest.get_item_group(node, "water") ~= 0 then
					accel.y = 2.1
				else
					accel.y = -10
				end
				self.object:set_acceleration(accel)
				if real_speed == 0 then
					self:set_animation("walk")
				end
			end
			
			-- Do the important things every second
			self.punch_timer = self.punch_timer + dtime
			if self.punch_timer < 1 then
				return
			end
			self.punch_timer = 0
			
			-- Jump
			if self:get_velocity() < real_speed - 0.05 and vel.y == 0 then
				vel.y = 6.5
				self.object:set_velocity(vel)
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
			if self.fall_damage ~= 0 and self.old_y then
				local d = self.old_y - my_pos.y
				if d > 5 then
					damage = damage + math.floor(d - 5)
				end
			end
			
			self.old_y = my_pos.y
			
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
			
			-- Footstep sound
			if (self.animation.current == "run" or self.animation.current == "walk") and
					self.makes_footstep_sound then
				node = minetest.get_node({x = my_pos.x, y = my_pos.y - 1, x = my_pos.z}).name
				local def = minetest.registered_nodes[node]
				if def and def.sounds and def.sounds.footstep and 
						def.sounds.footstep.name ~= "" then
					local sound_gain = def.sounds.footstep.gain or 1
					minetest.sound_play(sound_name, {
						pos = my_pos,
						gain = sound_gain
					})
				end
			end
			
			local p, vec, dist = false, false, false
			if self.aggressive and not self.to_player then
				for _,player in ipairs(minetest.get_connected_players()) do
					p = player:get_pos()
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
					p = player:get_pos()
					vec = vector.subtract(p, my_pos)
					dist = (vec.x^2 + vec.y^2 + vec.z^2) ^ 0.5
					
					if dist < self.view_range and
							player:get_wielded_item():get_name() == self.follow then
						self.to_player = player
						break
					end
				end
			end
			
			if self.to_player and not self.aggressive then
				if self.to_player:get_wielded_item():get_name() ~= self.follow then
					self.to_player = nil
					self:set_animation("stand")
					return
				end
			end
			
			if self.to_player then
				if not dist then
					p = self.to_player:get_pos()
					if not p then
						self.to_player = nil
						self:set_animation("stand")
						return
					end
					vec = vector.subtract(p, my_pos)
					dist = (vec.x^2 + vec.y^2 + vec.z^2) ^ 0.5
				end
				
				-- Out of view
				if dist > self.view_range or self.to_player:get_hp() <= 0 then
					self.to_player = nil
					self:set_animation("stand")
					return
				end
				
				-- Target reached
				if dist <= 2.2 then
					if not self.aggressive then
						self:set_animation("stand")
						return
					end
					
					self:set_animation("punch")
					minetest.sound_play("base_mobs_punch", {object = self.object, gain = 1})
					self.to_player:punch(self.object, 1.0,  {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = self.damage}
					}, vec)
					return
				end
				-- Else shoot.
				
				local yaw = math.atan(vec.z / vec.x) + math.pi/2
				if self.drawtype == "side" then
					yaw = yaw + (math.pi / 2)
				end
				if p.x > my_pos.x then
					yaw = yaw + math.pi
				end
				self.object:set_yaw(yaw)
				
				if self.aggressive then
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
				
				local r = math.random(60)
				if r == 10 or (r == 11 and other_state == "walk") then
					self:set_animation(other_state)
				elseif r <= 4 then
					self.object:set_yaw(self.object:get_yaw() + (math.random(-90, 90) / 180 * math.pi))
				end
			end
		end,
		
		on_activate = function(self, staticdata, dtime_s)
			if self.type == "monster" then
				self.aggressive = true
			end
			self.object:set_armor_groups({fleshy = self.armor})
			self.object:set_acceleration({x = 0, y = -10, z = 0})
			self:set_animation("stand")
			self.object:set_yaw(math.random(360) / 180 * math.pi)
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
				tamed = self.tamed
			}
			return minetest.serialize(tmp)
		end,
		
		on_punch = function(self, hitter)
			local hp = self.object:get_hp()
			local is_player = (hitter and hitter:is_player())
			
			if hp <= 0 then
				if not self.drops then
					return
				end
				local stack = nil
				minetest.sound_play("player_death", {object = self.object, gain = 0.4})
				minetest.sound_play("hit_death", {pos = hitter:get_pos(), gain = 0.4})
				for _,drop in ipairs(self.drops) do
					if math.random(drop.chance) == 1 then
						stack = ItemStack(drop.name.." "..math.random(drop.min, drop.max))
					end
				end
				if not stack then
					return
				end
				if is_player and hitter:get_inventory() then
					hitter:get_inventory():add_item("main", stack)
					return
				end
				local pos = self.object:get_pos()
				pos.y = pos.y + 0.4
				minetest.add_item(pos, stack)
			end
			
			local vel = self.object:get_velocity()
			if vel.y == 0 and (self.state == "stand" or self.state == "walk") then
				vel.y = 4
				self.object:set_velocity(vel)
				self:set_animation("walk")
			end
			
			minetest.sound_play("player_damage", {object = self.object, gain = 0.25})
			minetest.sound_play("hit", {pos = hitter:get_pos(), gain = 0.4})
			
			if self.type == "defensive" then
				if is_player then
					self.to_player = hitter
				end
				self.aggressive = true
			end
		end,
		
	})
end

base_mobs.spawning_mobs = {}
function base_mobs:register_spawn(name, description, nodes, max_light, min_light, chance, active_object_count, max_height, spawn_func)
	base_mobs.spawning_mobs[name] = true
	minetest.register_abm({
		nodenames = nodes,
		neighbors = {"air"},
		interval = 20,
		chance = chance,
		action = function(pos, node, _, active_object_count_wider)
			if active_object_count_wider > active_object_count then return end
			if not base_mobs.spawning_mobs[name] then return end
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