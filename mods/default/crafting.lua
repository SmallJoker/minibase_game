-- mods/default/crafting.lua

minetest.register_craft({
	output = "default:wood 4",
	recipe = {
		{"default:tree"},
	}
})

minetest.register_craft({
	output = "default:junglewood 4",
	recipe = {
		{"default:jungletree"},
	}
})

minetest.register_craft({
	output = "default:stick 4",
	recipe = {
		{"default:wood"},
	}
})

minetest.register_craft({
	output = "default:wood",
	recipe = {
		{"default:stick","default:stick"},
		{"default:stick","default:stick"},
	}
})

minetest.register_craft({
	output = "default:fence_wood 2",
	recipe = {
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
	}
})

minetest.register_craft({
	output = "default:sign_wall 2",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:torch 4",
	recipe = {
		{"default:coal_lump"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:pick_mese",
	recipe = {
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:shovel_mese",
	recipe = {
		{"default:mese_crystal"},
		{"group:stick"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:axe_mese",
	recipe = {
		{"default:mese_crystal", "default:mese_crystal"},
		{"default:mese_crystal", "group:stick"},
		{"", "group:stick"},
	}
})

minetest.register_craft({
	output = "default:sword_mese",
	recipe = {
		{"default:mese_crystal"},
		{"default:mese_crystal"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:rail 12",
	recipe = {
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
		{"default:steel_ingot", "group:stick", "default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "default:chest",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

minetest.register_craft({
	output = "default:chest_locked",
	recipe = {
		{"default:steel_ingot"},
		{"default:chest"}
	}
})

minetest.register_craft({
	output = "default:chest_locked",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "default:steel_ingot", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

minetest.register_craft({
	output = "default:furnace",
	recipe = {
		{"group:stone", "group:stone", "group:stone"},
		{"group:stone", "", "group:stone"},
		{"group:stone", "group:stone", "group:stone"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:bronze_ingot",
	recipe = {"default:steel_ingot", "default:copper_ingot"},
})

minetest.register_craft({
	output = "default:sandstone",
	recipe = {
		{"group:sand", "group:sand"},
		{"group:sand", "group:sand"},
	}
})

minetest.register_craft({
	output = "default:desert_stone",
	recipe = {
		{"group:stick", ""},
		{"group:sand", "group:sand"},
		{"group:sand", "group:sand"},
	}
})

minetest.register_craft({
	output = "default:sand 4",
	recipe = {
		{"default:sandstone"},
	}
})

minetest.register_craft({
	output = "default:sandstonebrick",
	recipe = {
		{"default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone"},
	}
})

minetest.register_craft({
	output = "default:clay",
	type = "shapeless",
	recipe = {
		"group:flora", "group:leaves",
		"default:dirt", "default:dirt",
		"default:gravel", "default:gravel",
	}
})

minetest.register_craft({
	output = "default:clay",
	recipe = {
		{"default:clay_lump", "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump"},
	}
})

minetest.register_craft({
	output = "default:brick",
	recipe = {
		{"default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick"},
	}
})

minetest.register_craft({
	output = "default:clay_brick 4",
	recipe = {
		{"default:brick"},
	}
})

minetest.register_craft({
	output = "default:paper",
	recipe = {
		{"default:papyrus", "default:papyrus", "default:papyrus"},
	}
})

minetest.register_craft({
	output = "default:book",
	recipe = {
		{"default:paper"},
		{"default:paper"},
		{"default:paper"},
	}
})

minetest.register_craft({
	output = "default:bookshelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"default:book", "default:book", "default:book"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

minetest.register_craft({
	output = "default:ladder 2",
	recipe = {
		{"group:stick", "", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "", "group:stick"},
	}
})

minetest.register_craft({
	output = "default:mese",
	recipe = {
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
	}
})

minetest.register_craft({
	output = "default:mese_crystal 9",
	recipe = {
		{"default:mese"},
	}
})

minetest.register_craft({
	output = "default:mese_crystal_fragment 9",
	recipe = {
		{"default:mese_crystal"},
	}
})

minetest.register_craft({
	output = "default:mese_crystal",
	recipe = {
		{"default:mese_crystal_fragment","default:mese_crystal_fragment","default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment","default:mese_crystal_fragment","default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment","default:mese_crystal_fragment","default:mese_crystal_fragment"},
	}
})

minetest.register_craft({
	output = "default:obsidian_shard 4",
	recipe = {
		{"default:obsidian"}
	}
})

minetest.register_craft({
	output = "default:obsidian",
	recipe = {
		{"default:obsidian_shard", "default:obsidian_shard"},
		{"default:obsidian_shard", "default:obsidian_shard"},
	}
})

minetest.register_craft({
	output = "default:stonebrick",
	recipe = {
		{"default:stone", "default:stone"},
		{"default:stone", "default:stone"},
	}
})

minetest.register_craft({
	output = "default:desert_stonebrick",
	recipe = {
		{"default:desert_stone", "default:desert_stone"},
		{"default:desert_stone", "default:desert_stone"},
	}
})

minetest.register_craft({
	output = "default:pick_wood",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:axe_wood",
	recipe = {
		{"group:wood", "group:wood"},
		{"group:wood", "group:stick"},
		{"", "group:stick"},
	}
})
	
minetest.register_craft({
	output = "default:shovel_wood",
	recipe = {
		{"group:wood"},
		{"group:stick"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:sword_wood",
	recipe = {
		{"group:wood"},
		{"group:wood"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:pick_stone",
	recipe = {
		{"group:stone", "group:stone", "group:stone"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:axe_stone",
	recipe = {
		{"group:stone", "group:stone"},
		{"group:stone", "group:stick"},
		{"", "group:stick"},
	}
})
	
minetest.register_craft({
	output = "default:shovel_stone",
	recipe = {
		{"group:stone"},
		{"group:stick"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:sword_stone",
	recipe = {
		{"group:stone"},
		{"group:stone"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "default:window_glass 15",
	recipe = {
		{"default:glass", "default:glass", "default:glass"}
	}
})

--
-- Crafting (tool repair)
--
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})

--
-- Cooking recipes
--

minetest.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "group:sand",
})

minetest.register_craft({
	type = "cooking",
	output = "default:obsidian_glass",
	recipe = "default:obsidian_shard",
})

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:cobble",
})

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "default:clay_lump",
})

--
-- Fuels
--

minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 35,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglegrass",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:cactus",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:papyrus",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bookshelf",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:fence_wood",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:ladder",
	burntime = 5,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:lava_source",
	burntime = 50,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:torch",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:sign_wall",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest_locked",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coal_lump",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:coalblock",
	burntime = 370,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:junglesapling",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:grass_1",
	burntime = 2,
})
