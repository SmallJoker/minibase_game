--List of ores - name = {description, oreGroups, blockGroups, registerCrafts}
local ore_list = {
	coal	= {"Coal", {cracky=3}, {cracky=3}},
	iron	= {"Iron", {cracky=2}, {cracky=1, level=2}},
	copper	= {"Copper", {cracky=2}, {cracky=1, level=2}},
	gold	= {"Gold", {cracky=2}, {cracky=1}},
}

for name, def in pairs(ore_list) do
	local ndef = default.copy_table(def[2])
	ndef.not_in_creative_inventory = 1
	minetest.register_node("default:stone_with_"..name, {
		description = def[1].." Ore",
		tiles = {"default_stone.png^default_mineral_"..name..".png"},
		is_ground_content = true,
		groups = ndef,
		drop = "default:"..name.."_lump",
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_craftitem("default:"..name.."_lump", {
		description = def[1].." Lump",
		inventory_image = "default_"..name.."_lump.png",
	})
	
	local oldname = name
	if name == "iron" then
		name = "steel"
		def[1] = "Steel"
	end
	
	if name ~= "coal" then
		minetest.register_craftitem("default:"..name.."_ingot", {
			description = def[1].." Ingot",
			inventory_image = "default_"..name.."_ingot.png",
		})
		minetest.register_craft({
			type = "cooking",
			output = "default:"..name.."_ingot",
			recipe = "default:"..oldname.."_lump",
		})
	end
	
	minetest.register_node("default:"..name.."block", {
		description = def[1].." Block",
		tiles = {"default_"..name.."_block.png"},
		groups = def[3],
		sounds = default.node_sound_stone_defaults(),
	})
end

default.register_tools_block_craft("default", "snow", "default:snow", true)
default.register_tools_block_craft("default", "coal", "default:coal_lump", true)
default.register_tools_block_craft("default", "copper", "default:copper_ingot", true)
default.register_tools_block_craft("default", "gold", "default:gold_ingot", true)
default.register_tools_block_craft("default", "steel", "default:steel_ingot")
default.register_tools_block_craft("default", "diamond", "default:diamond")

minetest.register_node("default:stone_with_mese", {
	description = "Mese Ore",
	tiles = {"default_stone.png^default_mineral_mese.png"},
	is_ground_content = true,
	groups = {cracky=1,not_in_creative_inventory=1},
	drop = "default:mese_crystal",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mese", {
	description = "Mese Block",
	tiles = {"default_mese_block.png"},
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("default:mese_block", "default:mese")

minetest.register_alias("default:bronzeblock", "default:steelblock")
minetest.register_alias("default:pick_bronze", "default:pick_steel")
minetest.register_alias("default:shovel_bronze", "default:shovel_steel")
minetest.register_alias("default:axe_bronze", "default:axe_steel")
minetest.register_alias("default:sword_bronze", "default:sword_steel")

minetest.register_node("default:stone_with_diamond", {
	description = "Diamond Ore",
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	is_ground_content = true,
	groups = {cracky=1,not_in_creative_inventory=1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:diamondblock", {
	description = "Diamond Block",
	tiles = {"default_diamond_block.png"},
	is_ground_content = true,
	groups = {cracky=1,level=3},
	sounds = default.node_sound_stone_defaults(),
})