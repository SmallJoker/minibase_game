minetest.register_abm({
	nodenames = {"default:dirt"},
	interval = 30,
	chance = 30,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if nodedef and (nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none"
				and (minetest.get_node_light(above) or 0) >= 13 then
			if name == "default:snow" or name == "default:snowblock" then
				minetest.set_node(pos, {name = "default:dirt_with_snow"})
			else
				minetest.set_node(pos, {name = "default:dirt_with_grass"})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	interval = 30,
	chance = 30,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef
				and not ((nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "default:dirt"})
		end
	end
})

minetest.register_abm({
	nodenames = {"group:freezes", "group:cold"},
	neighbors = {"group:hot"},
	interval = 5,
	chance = 10,
	action = function(pos, node)
		local melt = minetest.registered_nodes[node.name].freezemelt
		if not melt then return end
		minetest.set_node(pos, {name=melt})
		nodeupdate(pos)
	end,
})

minetest.register_abm({
	nodenames = {"group:can_freeze"},
	neighbors = {"group:freezes"},
	interval = 20,
	chance = 20,
	action = function(pos, node)
		if minetest.find_node_near(pos, 3, {"group:hot"}) then
			return
		end
		local freeze = minetest.registered_nodes[node.name].freezemelt
		if not freeze then return end
		minetest.set_node(pos, {name=freeze})
		nodeupdate(pos)
	end,
})

minetest.register_abm({
	nodenames = {"default:cobble"},
	neighbors = {"group:water"},
	interval = 80,
	chance = 80,
	action = function(pos)
		minetest.set_node(pos, {name="default:mossycobble"})
	end,
})