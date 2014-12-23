dofile(minetest.get_modpath("mobs").."/api.lua")

mobs:register_mob("mobs:stone_monster", {
	type = "monster",
	hp_max = 10,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.8, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.x",
	textures = {"mobs_stone_monster.png"},
	visual_size = {x = 3, y = 2.6},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 0.8,
	damage = 3,
	drops = {
		{
			name = "default:stone",
			chance = 1,
			min = 4,
			max = 6
		}
	},
	armor = 50,
	drawtype = "front",
	light_damage = 3,
	attack_type = "dogfight",
	animation = {
		speed_normal = 8,
		speed_run = 40,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	}
})

mobs:register_mob("mobs:sheep", {
	type = "animal",
	hp_max = 15,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_sheep.png"},
	visual = "mesh",
	mesh = "mobs_sheep.x",
	walk_velocity = 1,
	armor = 60,
	drops = {
		{
			name = "mobs:meat_raw",
			chance = 1,
			min = 2,
			max = 6
		}
	},
	drawtype = "front",
	water_damage = 3,
	lava_damage = 8,
	animation = {
		speed_normal = 17,
		stand_start = 0,
		stand_end = 80,
		walk_start = 81,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 6,
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item:get_name() == "farming:wheat" then
			item:take_item()
			clicker:set_wielded_item(item)
			
			self.tamed = true
			self.food = (self.food or 0) + 1
			if self.food >= 8 and self.naked then
				self.food = 0
				self.naked = false
				self.object:set_properties({
					textures = {"mobs_sheep.png"},
					mesh = "mobs_sheep.x",
				})
			end
			
			local new_hp = self.object:get_hp() + 3
			if new_hp > 15 then new_hp = 15 end
			self.object:set_hp(new_hp)
			return
		end
		local inv = clicker:get_inventory()
		if inv and not self.naked then
			self.naked = true
			inv:add_item("main", ItemStack("wool:white "..math.random(2,4)))
			minetest.sound_play("default_snow_footstep", {object = self.object, gain = 0.5})
			
			self.object:set_properties({
				textures = {"mobs_sheep_shaved.png"},
				mesh = "mobs_sheep_shaved.x",
			})
		end
	end,
})

minetest.register_craftitem("mobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
})

minetest.register_craftitem("mobs:meat", {
	description = "Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 20,
})

-- mobs:register_spawn(name, description, nodes, 
--	max_light, min_light, chance, active_object_count, max_height)

mobs:register_spawn("mobs:sheep", "Sheep", {"default:dirt_with_grass"},
	16,	8,	15000,	2,	100)
mobs:register_spawn("mobs:stone_monster", "Stone monster", {"default:stone"},
	1,	-1,	5000,	2,	-10)
