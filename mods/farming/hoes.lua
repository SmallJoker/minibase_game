local hoes = {
	{"wood", "Wooden", 30, "group:wood"},
	{"stone", "Stone", 90, "group:stone"},
	{"steel", "Steel", 200, "default:steel_ingot"},
	{"mese", "Mese", 800, "default:mese_crystal"}
}

for i, v in ipairs(hoes) do
	minetest.register_tool("farming:hoe_"..v[1], {
		description = v[2].." hoe",
		inventory_image = "farming_tool_"..v[1].."hoe.png",
		
		on_use = function(itemstack, user, pointed_thing)
			return farming.hoe_on_use(itemstack, user, pointed_thing, v[3])
		end,
	})

	minetest.register_craft({
		output = "farming:hoe_"..v[1],
		recipe = {
			{v[4], v[4]},
			{"", "group:stick"},
			{"", "group:stick"},
		}
	})
end

minetest.register_alias("farming:hoe_bronze", "farming:hoe_steel")