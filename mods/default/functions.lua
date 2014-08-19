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
-- Legacy
--

function default.spawn_falling_node(p, nodename)
	spawn_falling_node(p, nodename)
end

-- Horrible crap to support old code
-- Don't use this and never do what this does, it's completely wrong!
-- (More specifically, the client and the C++ code doesn't get the group)
function default.register_falling_node(nodename, texture)
	minetest.log("error", debug.traceback())
	minetest.log('error', "WARNING: default.register_falling_node is deprecated")
	if minetest.registered_nodes[nodename] then
		minetest.registered_nodes[nodename].groups.falling_node = 1
	end
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
local function cool_wf_vm(pos, node1, node2)
	local minp = vector.subtract(pos, 6)
	local maxp = vector.add(pos, 6)
	local manip = minetest.get_voxel_manip()
	local epos1, epos2 = manip:read_from_map(minp, maxp)
	local area = VoxelArea:new({MinEdge=epos1, MaxEdge=epos2})
	local nodes = manip:get_data()

	local stone = minetest.get_content_id(node2)
	local lava = minetest.get_content_id(node1)

	for x = minp.x, maxp.x do
		for y = minp.y, maxp.y do
			for z = minp.z, maxp.z do
				local p = {x=x, y=y, z=z}
				local p_p = area:indexp(p)
				if nodes[p_p] == lava 
					and minetest.find_node_near(p, 1, {"group:water"}) then
					nodes[p_p] = stone
				end
			end
		end
	end
				
	manip:set_data(nodes)
	manip:write_to_map()
	minetest.log("action", "Lava cooling at ".. minetest.pos_to_string(pos))
	manip:update_map()
end

local lava_del1 = 0
local lava_count = 0

minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 2,
	action = function(pos, node)
		local lava_del2 = os.clock() - lava_del1
		if lava_del2 < 0.4 and lava_count > 2 then
			cool_wf_vm(pos, "default:lava_flowing", "default:stone")
			lava_count = 0
		else
			minetest.set_node(pos, {name="default:stone"})
			minetest.sound_play("default_cool_lava", {pos = pos, gain = 0.2})
			if lava_del2 < 0.4 then
				lava_count = lava_count + 1
			end
		end
		lava_del1 = os.clock()
	end,
})

minetest.register_abm({
	nodenames = {"default:lava_source"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 2,
	action = function(pos, node)
		local lava_del2 = os.clock() - lava_del1
		if lava_del2 < 0.4 and lava_count > 2 then
			cool_wf_vm(pos, "default:lava_source", "default:obsidian")
			lava_count = 0
		else
			minetest.set_node(pos, {name="default:obsidian"})
			minetest.sound_play("default_cool_lava", {pos = pos, gain = 0.2})
			if lava_del2 < 0.4 then
				lava_count = lava_count + 1
			end
		end
		lava_del1 = os.clock()
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
	interval = 8,
	chance = 8,

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