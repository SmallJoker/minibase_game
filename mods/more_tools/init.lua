-- Add helpful tools, everything WTFPL

mtools = {}
local modpath = minetest.get_modpath("more_tools")

-- Enable or disable those tools in minetest.conf in this game folder
if minetest.setting_get("mtools_remove_everything") == true then
	-- A tool which removes every node
	dofile(modpath.."/remove_everything.lua")
end

if minetest.setting_get("mtools_craft_recipe_checker") == true then
	-- Craft recipe checker by rubenwardy
	dofile(modpath.."/craft_recipe_checker.lua")
end
