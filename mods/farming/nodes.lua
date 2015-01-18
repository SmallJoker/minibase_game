minetest.register_node("farming:soil", {
	description = "Soil",
	tiles = {"farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	freezemelt = "farming:soil_with_snow",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=2, can_freeze=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("farming:soil_wet", {
	description = "Wet Soil",
	tiles = {"farming_soil_wet.png", "farming_soil_wet_side.png"},
	drop = "default:dirt",
	freezemelt = "default:dirt_with_snow",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, can_freeze=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("farming:straw", {
	description = "Straw",
	tiles = {"farming_straw.png"},
	is_ground_content = false,
	groups = {snappy=3, flammable=4},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	nodenames = {"farming:soil", "farming:soil_wet"},
	interval = 8,
	chance = 8,
	action = function(pos, node)
		pos.y = pos.y + 1
		local plant = minetest.get_node(pos).name
		pos.y = pos.y - 1
		if minetest.registered_nodes[plant] and
				minetest.registered_nodes[plant].walkable and
				minetest.get_item_group(plant, "plant") == 0
		then
			minetest.set_node(pos, {name="default:dirt"})
		end
		-- check if there is water nearby
		if minetest.find_node_near(pos, 3, {"group:water"}) then
			-- if it is dry soil turn it into wet soil
			if node.name == "farming:soil" then
				minetest.set_node(pos, {name="farming:soil_wet"})
			end
		else
			-- turn it back into dirt if it is already dry
			if node.name == "farming:soil" then
				-- only turn it back if there is no plant on top of it
				if minetest.get_item_group(plant, "plant") == 0 then
					minetest.set_node(pos, {name="default:dirt"})
				end
				
			-- if its wet turn it back into dry soil
			elseif node.name == "farming:soil_wet" then
				minetest.set_node(pos, {name="farming:soil"})
			end
		end
	end,
})

--
-- Override grass for drops
--

for i = 1, 5 do
	minetest.override_item("default:grass_"..i, {
		drop = {
			max_items = 1,
			items = {
				{items = {"farming:seed_wheat"}, rarity = 5},
				{items = {"default:grass_1"}},
			}
		}
	})
end

minetest.override_item("default:junglegrass", {
	drop = {
		max_items = 1,
		items = {
			{items = {"farming:seed_cotton"}, rarity = 8},
			{items = {"default:junglegrass"}},
		}
	}
})