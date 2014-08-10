-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 14

-- Definitions made by this mod that other mods can use too
default = {}

-- Load files
dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafting.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/player.lua")
dofile(minetest.get_modpath("default").."/trees.lua")
dofile(minetest.get_modpath("default").."/nature.lua")
dofile(minetest.get_modpath("default").."/ores.lua")

-- Flags to detect functions/features of the current game

default.flags = {
--	Advanced leafdecay, for "trunk" and "trunk_range" in node defs
	"ALD"		= true,
--	Nature, freezemelt. Using "freezemelt" in node defs
--	and "can_freeze", "freezes" in groups
	"NFM"		= true,
	"c_coal"	= 2, -- 0 = exists minimal, 1 = exists, 2 = also as ore (generated)
	"c_iron"	= 2,
	"c_copper"	= 2,
	"c_diamond"	= 2,
	"c_mese"	= 2,
	"c_gold"	= 1,
	"c_bronze"	= 0,
--	Trees and naturals
	"t_normal"	= true,
	"t_jungle"	= true,
	"t_papyrus"	= true,
	"t_cactus"	= true,
}