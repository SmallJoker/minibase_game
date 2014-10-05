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
local modpath = minetest.get_modpath("default")
dofile(modpath.."/functions.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/tools.lua")
dofile(modpath.."/craftitems.lua")
dofile(modpath.."/crafting.lua")
dofile(modpath.."/mapgen.lua")
if not minetest.setting_getbool("disable_player_model") then
	dofile(modpath.."/player.lua")
end
dofile(modpath.."/trees.lua")
dofile(modpath.."/nature.lua")
dofile(modpath.."/ores.lua")

-- Flags to detect functions/features of the current game

default.flags = {
--	Advanced leafdecay, for "trunk" in node defs
	["ALD"]			= true,
--	Nature, freezemelt. Using "freezemelt" in node defs
--	and "can_freeze", "freezes" in groups
	["NFM"]			= true,
	["c_coal"]		= 2, -- 0 = exists minimal, 1 = exists, 2 = also as ore (generated)
	["c_iron"]		= 2,
	["c_copper"]	= 2,
	["c_diamond"]	= 2,
	["c_mese"]		= 2,
	["c_gold"]		= 1,
	["c_bronze"]	= 0,
--	Trees and naturals
	["t_normal"]	= true,
	["t_jungle"]	= true,
	["t_papyrus"]	= true,
	["t_cactus"]	= true,
}