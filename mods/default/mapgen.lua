-- mods/default/mapgen.lua

--
-- Aliases for map generator outputs
--

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_clay", "default:clay")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_stone_with_coal", "default:stone_with_coal")
minetest.register_alias("mapgen_stone_with_iron", "default:stone_with_iron")
minetest.register_alias("mapgen_mese", "default:mese")
minetest.register_alias("mapgen_desert_sand", "default:desert_sand")
minetest.register_alias("mapgen_desert_stone", "default:desert_stone")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")

--
-- Ore generation
--

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_coal",
	wherein			= "default:stone",
	clust_scarcity	= 8*8*8,
	clust_num_ores	= 8,
	clust_size		= 3,
	height_min		= -31000,
	height_max		= 64,
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_coal",
	wherein			= "default:stone",
	clust_scarcity	= 24*24*24,
	clust_num_ores	= 27,
	clust_size		= 6,
	height_min		= -31000,
	height_max		= 0,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_iron",
	wherein			= "default:stone",
	clust_scarcity	= 12*12*12,
	clust_num_ores	= 3,
	clust_size		= 2,
	height_min		= -15,
	height_max		= 2,
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_iron",
	wherein			= "default:stone",
	clust_scarcity	= 9*9*9,
	clust_num_ores	= 5,
	clust_size		= 3,
	height_min		= -63,
	height_max		= -16,
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_iron",
	wherein			= "default:stone",
	clust_scarcity	= 7*7*7,
	clust_num_ores	= 5,
	clust_size		= 3,
	height_min		= -31000,
	height_max		= -64,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_iron",
	wherein			= "default:stone",
	clust_scarcity	= 24*24*24,
	clust_num_ores	= 27,
	clust_size		= 6,
	height_min		= -31000,
	height_max		= -64,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_mese",
	wherein			= "default:stone",
	clust_scarcity	= 18*18*18,
	clust_num_ores	= 3,
	clust_size		= 2,
	height_min		= -255,
	height_max		= -64,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_mese",
	wherein			= "default:stone",
	clust_scarcity	= 14*14*14,
	clust_num_ores	= 5,
	clust_size		= 3,
	height_min		= -31000,
	height_max		= -256,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:mese",
	wherein			= "default:stone",
	clust_scarcity	= 36*36*36,
	clust_num_ores	= 3,
	clust_size		= 2,
	height_min		= -31000,
	height_max		= -1024,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_gold",
	wherein			= "default:stone",
	clust_scarcity	= 15*15*15,
	clust_num_ores	= 3,
	clust_size		= 2,
	height_min		= -255,
	height_max		= -64,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_gold",
	wherein			= "default:stone",
	clust_scarcity	= 13*13*13,
	clust_num_ores	= 5,
	clust_size		= 3,
	height_min		= -31000,
	height_max		= -256,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_diamond",
	wherein			= "default:stone",
	clust_scarcity	= 17*17*17,
	clust_num_ores	= 4,
	clust_size		= 3,
	height_min		= -255,
	height_max		= -128,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_diamond",
	wherein			= "default:stone",
	clust_scarcity	= 15*15*15,
	clust_num_ores	= 4,
	clust_size		= 3,
	height_min		= -31000,
	height_max		= -256,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_copper",
	wherein			= "default:stone",
	clust_scarcity	= 12*12*12,
	clust_num_ores	= 4,
	clust_size		= 3,
	height_min		= -63,
	height_max		= -16,
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:stone_with_copper",
	wherein			= "default:stone",
	clust_scarcity	= 9*9*9,
	clust_num_ores	= 5,
	clust_size		= 3,
	height_min		= -31000,
	height_max		= -64,
	flags			= "absheight",
})

minetest.register_ore({
	ore_type		= "scatter",
	ore				= "default:clay",
	wherein			= "default:sand",
	clust_scarcity	= 15*15*15,
	clust_num_ores	= 64,
	clust_size		= 5,
	height_max		= 0,
	height_min		= -10,
})

function default.generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, chunk_size, ore_per_chunk, height_min, height_max)
	minetest.log('action', "WARNING: default.generate_ore is deprecated")

	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	if chunk_size >= y_max - y_min + 1 then
		return
	end
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	--print("generate_ore num_chunks: "..dump(num_chunks))
	for i=1,num_chunks do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= height_min and y0 <= height_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			for x1=0,chunk_size-1 do
			for y1=0,chunk_size-1 do
			for z1=0,chunk_size-1 do
				if pr:next(1,inverse_chance) == 1 then
					local x2 = x0+x1
					local y2 = y0+y1
					local z2 = z0+z1
					local p2 = {x=x2, y=y2, z=z2}
					if minetest.get_node(p2).name == wherein then
						minetest.set_node(p2, {name=name})
					end
				end
			end
			end
			end
		end
	end
	--print("generate_ore done")
end

function default.make_papyrus(pos, size)
	for y=0,size-1 do
		local p = {x=pos.x, y=pos.y+y, z=pos.z}
		local nn = minetest.get_node(p).name
		if nn ~= "air" then
			return
		end
		minetest.set_node(p, {name="default:papyrus"})
	end
end

function default.make_cactus(pos, size)
	for y=0,size-1 do
		local p = {x=pos.x, y=pos.y+y, z=pos.z}
		local nn = minetest.get_node(p).name
		if nn ~= "air" then
			return
		end
		minetest.set_node(p, {name="default:cactus"})
	end
end

-- facedir: 0/1/2/3 (head node facedir value)
-- length: length of rainbow tail
function default.make_nyancat(pos, facedir, length)
	local tailvec = {x=0, y=0, z=0}
	if facedir == 0 then
		tailvec.z = 1
	elseif facedir == 1 then
		tailvec.x = 1
	elseif facedir == 2 then
		tailvec.z = -1
	elseif facedir == 3 then
		tailvec.x = -1
	else
		facedir = 0
		tailvec.z = 1
	end
	local p = {x=pos.x, y=pos.y, z=pos.z}
	minetest.set_node(p, {name="default:nyancat", param2=facedir})
	for i=1, length do
		p.x = p.x + tailvec.x
		p.z = p.z + tailvec.z
		minetest.set_node(p, {name="default:nyancat_rainbow", param2=facedir})
	end
end

function generate_nyancats(seed, minp, maxp)
	local height_min = -31000
	local height_max = 31000
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local pr = PseudoRandom(seed + 9324342)
	if pr:next(0, 1200) ~= 0 then
		return
	end
	
	local x0 = pr:next(minp.x, maxp.x)
	local y0 = pr:next(minp.y, maxp.y)
	local z0 = pr:next(minp.z, maxp.z)
	local p0 = {x=x0, y=y0, z=z0}
	default.make_nyancat(p0, pr:next(0,3), pr:next(3,15))
end

minetest.register_on_generated(function(minp, maxp, seed)
	-- Generate nyan cats
	generate_nyancats(seed, minp, maxp)
	
	if maxp.y < 2 and minp.y > 0 then
		return
	end
	
	local c_air = minetest.get_content_id("air")
	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	local c_sand = minetest.get_content_id("default:desert_sand")
	
	local n_papyrus = minetest.get_perlin(354, 3, 0.7, 100)
	local n_cactus = minetest.get_perlin(230, 3, 0.6, 100)
	
	local vm = minetest.get_voxel_manip()
	local emin, emax = vm:read_from_map(minp, maxp)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local rand = PseudoRandom(seed % 8000)
	for z = minp.z + 2, maxp.z - 2, 4 do
	for x = minp.x + 2, maxp.x - 2, 4 do
		local papyrus_amount = math.floor(n_papyrus:get2d({x=x, y=z}) * 6 - 2)
		for i = 1, papyrus_amount do
			local p_pos = {
				x = rand:next(x - 2, x + 2), 
				y = 0, 
				z = rand:next(z - 2, z + 2)
			}
			if data[area:index(p_pos.x, p_pos.y, p_pos.z)] == c_grass and
					minetest.find_node_near(p_pos, 1, "default:water_source") then
				p_pos.y = 1
				default.make_papyrus(p_pos, rand:next(2, 4))
			end
		end
		
		local cactus_amount = math.floor(n_cactus:get2d({x=x, y=z}) * 3)
		for i = 1, cactus_amount do
			local p_pos = {
				x = rand:next(x - 2, x + 2), 
				y = -1, 
				z = rand:next(z - 2, z + 2)
			}
			-- Find ground level (0...15)
			local found = false
			local last = -1
			for y = 30, 0, -1 do
				p_pos.y = y
				last = data[area:index(p_pos.x, p_pos.y, p_pos.z)]
				if last ~= c_air then
					found = true
					break
				end
			end
			if found then
				p_pos.y = p_pos.y + 1
				if last == c_grass then
					minetest.set_node(p_pos, {name="default:grass_"..rand:next(1, 5)})
				elseif last == c_sand then
					if rand:next(1, 5) >= 4 then
						default.make_cactus(p_pos, rand:next(3, 4))
					else
						minetest.set_node(p_pos, {name="default:dry_shrub"})
					end
				end
			end
		end
	end
	end
end)

-- Simple V7 for Minetest Game in Mapgen v7 by MTDad
-- https://github.com/MTDad/simplev7

minetest.register_biome({
	name = "forest",
	node_top = "default:dirt_with_grass",		depth_top = 1,
	node_filler = "default:dirt",			depth_filler = 3,
	height_min = 2,					height_max = 40,
	heat_point = 50,				humidity_point = 80,
})

minetest.register_biome({
	name = "meadow",
	node_top = "default:dirt_with_grass",		depth_top = 1,
	node_filler = "default:dirt",			depth_filler = 3,
	height_min = 2,					height_max = 40,
	heat_point = 50,				humidity_point = 30,
})

minetest.register_biome({
	name = "beach",
	node_top = "default:sand",			depth_top = 2,
	height_min = -500,				height_max = 2,
	heat_point = 40,				humidity_point = 50,
})

minetest.register_biome({
	name = "tropical_beach",
	node_top = "default:sand",			depth_top = 5,
	height_min = -500, 				height_max = 3,
	heat_point = 80,				humidity_point = 50,
})

minetest.register_biome({
	name = "jungle",
	node_top = "default:dirt_with_grass",		depth_top = 1,
	node_filler = "default:dirt",			depth_filler = 3,
	height_min = 2,					height_max = 40,
	heat_point = 80,				humidity_point = 80,
})

minetest.register_biome({
	name = "desert",
	node_top = "default:desert_sand",		depth_top = 3,
	node_filler = "default:desert_stone",		depth_filler = 57,
	height_min = 2,					height_max = 40,
	heat_point = 80,				humidity_point = 20,
})

minetest.register_biome({
	name = "mountain",
	node_top = "default:dirt_with_snow",			depth_top = 1,
	node_filler = "default:dirt",		depth_filler = 2,
	height_min = 41,				height_max = 60,
})

minetest.register_biome({
	name = "alpine",
	node_top = "default:snowblock",			depth_top = 1,
	node_filler = "default:dirt_with_snow",		depth_filler = 1,
	height_min = 61,				height_max = 300,
})

minetest.register_biome({
	name = "dune",
	node_top = "default:sand",			depth_top = 3,
	node_filler = "default:dirt",			depth_filler = 2,
	height_min = 1,					height_max = 30,
	heat_point = 10,				humidity_point = 10,
})

minetest.register_biome({
	name = "prairie",
	node_top = "default:dirt_with_grass",		depth_top = 1,
	node_filler = "default:dirt",			depth_filler = 4,
	height_min = 10,				height_max = 40,
	heat_point = 40,				humidity_point = 20,
})

minetest.register_biome({
	name = "papyrus",
	node_top = "default:dirt_with_grass",		depth_top = 1,
	node_filler = "default:dirt",			depth_filler = 2,
	height_min = 1,					height_max = 1,
	heat_point = 60,				humidity_point = 50,
})

-- Decorations

local schematic_path = minetest.get_modpath("default").."/schematics/"
minetest.register_decoration({
	deco_type = "schematic",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.037,
	biomes = {"forest"},
	flags = "place_center_x, place_center_z",
	schematic = schematic_path.."appletree.mts",
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},
	sidelen = 80,
	fill_ratio = 0.003,
	biomes = {"meadow"},
	flags = "place_center_x, place_center_z",
	schematic = schematic_path.."appletree.mts",
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.057,
	biomes = {"jungle"},
	flags = "place_center_x, place_center_z",
	schematic = schematic_path.."jungletree.mts",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.17,
	biomes = {"jungle"},
	decoration = {"default:junglegrass"},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = "default:sand",
	sidelen = 16,
	noise_params = {offset = 0, scale = 1, spread = {x = 80, y = 80, z = 80}, seed = 983240, octaves = 4, persist = 0.55},
	biomes = {"dune"},
	decoration = "default:grass_5",
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = "default:dirt_with_grass",
	sidelen = 16,
	fill_ratio = 0.17,
	biomes = {"papyrus"},
	schematic = schematic_path.."papyrus.mts",
})