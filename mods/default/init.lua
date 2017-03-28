-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

LAVA_VISC = 7
LIGHT_MAX = 14

-- Definitions made by this mod that other mods can use too
default = {}
default.LIGHT_MAX = LIGHT_MAX
default.player_attached = {}

-- Compatibility code for minetest_game
default.gui_bg = "bgcolor[#111C;]"
default.gui_bg_img = ""
-- slot BG ; slot hover ; slot border ; tooltip BG ; tooltip font color]
default.gui_slots = "listcolors[#555;#999;#444;#444;#FFF]"

function default.get_hotbar_bg(x,y)
	return ""
end

default.gui_suvival_form = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"list[current_player;craft;1.5,0.5;3,3;]"..
		"list[current_player;craftpreview;5.5,1.5;1,1;]"

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

minetest.register_on_joinplayer(function(player)
	player:set_inventory_formspec(default.gui_suvival_form)
end)