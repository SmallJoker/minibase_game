-- mods/default/functions.lua

--
-- Sounds
--

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=1.0}
	table.dug = table.dug or
			{name="default_dug_node", gain=0.25}
	table.place = table.place or
			{name="default_place_node_hard", gain=1.0}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_hard_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_hard_footstep", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_dirt_footstep", gain=1.0}
	table.dug = table.dug or
			{name="default_dirt_footstep", gain=1.5}
	table.place = table.place or
			{name="default_place_node", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_sand_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_sand_footstep", gain=1.0}
	table.place = table.place or
			{name="default_place_node", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_wood_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_wood_footstep", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_grass_footstep", gain=0.35}
	table.dug = table.dug or
			{name="default_grass_footstep", gain=0.85}
	table.dig = table.dig or
			{name="default_dig_crumbly", gain=0.5}
	table.place = table.place or
			{name="default_place_node", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="default_glass_footstep", gain=0.5}
	table.dug = table.dug or
			{name="default_break_glass", gain=1.0}
	default.node_sound_defaults(table)
	return table
end

-- Register crafts
function default.register_tools_block_craft(m, o, k, b)
	-- m = modname, o = crafting items ("foobar:pick_<this>"), k = used to craft, b = register blocks only
	if not b then
	minetest.register_craft({
		output = m..":pick_"..o,
		recipe = {
			{k, k, k},
			{"", "group:stick", ""},
			{"", "group:stick", ""},
		}
	})
	minetest.register_craft({
		output = m..":axe_"..o,
		recipe = {
			{k, k},
			{k, "group:stick"},
			{"", "group:stick"},
		}
	})
	minetest.register_craft({
		output = m..":shovel_"..o,
		recipe = {
			{k},
			{"group:stick"},
			{"group:stick"},
		}
	})
	minetest.register_craft({
		output = m..":sword_"..o,
		recipe = {
			{k},
			{k},
			{"group:stick"},
		}
	})
	end
	minetest.register_craft({
		output = m..":"..o.."block",
		recipe = {
			{k, k, k},
			{k, k, k},
			{k, k, k},
		}
	})
	minetest.register_craft({
		output = k.." 9",
		recipe = {
			{m..":"..o.."block"},
		}
	})
end

-- Dublicate a table
function default.copy_table(otable)
	local ntable = {}
	for k,v in pairs(otable) do
		if v ~= nil then
			if type(v) == "table" then
				ntable[k] = default.copy_table(v)
			else
				ntable[k] = v
			end
		end
	end
	return ntable
end

--
-- Grow trees
--

minetest.register_abm({
	nodenames = {"default:sapling"},
	interval = 40,
	chance = 40,
	action = function(pos, node)
		local nu = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		local is_soil = minetest.get_item_group(nu, "soil")
		if not is_soil or is_soil == 0 then
			return
		end
		
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-8, y=pos.y, z=pos.z-8}, {x=pos.x+8, y=pos.y+8, z=pos.z+8})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		default.grow_tree(data, a, pos, math.random(1, 4) == 1, math.random(1,100000))
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
	end
})

minetest.register_abm({
	nodenames = {"default:junglesapling"},
	interval = 50,
	chance = 50,
	action = function(pos, node)
		local nu = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		local is_soil = minetest.get_item_group(nu, "soil")
		if not is_soil or is_soil == 0 then
			return
		end
		
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-8, y=pos.y-1, z=pos.z-8}, {x=pos.x+8, y=pos.y+16, z=pos.z+8})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		default.grow_jungletree(data, a, pos, math.random(1,100000))
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
	end
})

--
-- Lavacooling
--

-- from game "Carbone", lavacooling by vmanip.

local function cool_lava_vm(pos, node1, node2)
	local minp = vector.subtract(pos, 6)
	local maxp = vector.add(pos, 6)
	local manip = minetest.get_voxel_manip()
	local emin, emax = manip:read_from_map(minp, maxp)
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
	local nodes = manip:get_data()

	local stone = minetest.get_content_id(node2)
	local lava = minetest.get_content_id(node1)

	for x = minp.x, maxp.x do
	for y = minp.y, maxp.y do
	for z = minp.z, maxp.z do
		local p = {x=x, y=y, z=z}
		local vi = area:indexp(p)
		if nodes[vi] == lava 
			and minetest.find_node_near(p, 1, {"group:water"}) then
			nodes[vi] = stone
		end
	end
	end
	end
				
	manip:set_data(nodes)
	manip:write_to_map()
	minetest.log("action", "Lava cooling at "..minetest.pos_to_string(pos))
	manip:update_map()
	manip:update_liquids()
end

local lava_time, lava_count = 0, 0
local function lava_cooling(pos, src, dst)
	local dtime = os.clock()
	if dtime - lava_time < 0.4 and lava_count > 2 then
		cool_lava_vm(pos, src, dst)
		lava_count = 0
	else
		minetest.set_node(pos, {name=dst})
		if dtime - lava_time < 0.4 then
			lava_count = lava_count + 1
		end
	end
	minetest.sound_play("default_cool_lava", {pos = pos, gain = 0.2})
	lava_time = dtime
end

function default.cool_lava_source(pos)
	lava_cooling(pos, "default:lava_source", "default:obsidian")
end

function default.cool_lava_flowing(pos)
	lava_cooling(pos, "default:lava_flowing", "default:stone")
end

minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 2,
	action = function(pos)
		default.cool_lava_flowing(pos, node, active_object_count, active_object_count_wider)
	end,
})

minetest.register_abm({
	nodenames = {"default:lava_source"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 2,
	action = function(pos)
		default.cool_lava_source(pos, node, active_object_count, active_object_count_wider)
	end,
})

--
-- Papyrus and cactus growing
--

minetest.register_abm({
	nodenames = {"default:cactus"},
	neighbors = {"group:sand"},
	interval = 50,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if minetest.get_item_group(name, "sand") ~= 0 then
			pos.y = pos.y + 1
			local height = 0
			while minetest.get_node(pos).name == "default:cactus" and height < 5 do
				height = height + 1
				pos.y = pos.y + 1
			end
			if height < 5 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:cactus"})
				end
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"default:papyrus"},
	neighbors = {"default:dirt", "default:dirt_with_grass"},
	interval = 50,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name == "default:dirt" or name == "default:dirt_with_grass" then
			if not minetest.find_node_near(pos, 3, {"group:water"}) then
				return
			end
			pos.y = pos.y + 1
			local height = 0
			while minetest.get_node(pos).name == "default:papyrus" and height < 4 do
				height = height + 1
				pos.y = pos.y + 1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:papyrus"})
				end
			end
		end
	end,
})

--
-- Leafdecay
--

minetest.register_abm({
	nodenames = {"group:leafdecay"},
	interval = 5,
	chance = 5,

	action = function(pos, node)
		local def = minetest.registered_nodes[node.name]
		local trunk = def.trunk or "default:tree"
		local range = def.groups.leafdecay
		
		if range == 0 then return end
		if minetest.find_node_near(pos, range, {"ignore", trunk}) then return end
		
		local drops = minetest.get_node_drops(node.name)
		for _, dropitem in ipairs(drops) do
			if dropitem ~= node.name then
				minetest.add_item(pos, dropitem)
			end
		end
		minetest.remove_node(pos)
		nodeupdate(pos)
	end
})