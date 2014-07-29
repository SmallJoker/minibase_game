minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 2 or minp.y > 0 then
		return
	end
	
	local c_air = minetest.get_content_id("air")
	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	
	local n_flower = minetest.get_perlin(436, 3, 0.6, 100)
	local sidelen = maxp.x - minp.x + 1
	
	local vm = minetest.get_voxel_manip()
	local emin, emax = vm:read_from_map(minp, maxp)
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local rand = PseudoRandom(seed % 8000)
	for z = minp.z + 2, maxp.z - 2, 4 do
	for x = minp.x + 2, maxp.x - 2, 4 do
		local flower_amount = math.floor(n_flower:get2d({x=x, y=z}) * 6 - 4)
		for i = 1, flower_amount do
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
			
			if found and last == c_grass then
				p_pos.y = p_pos.y + 1
				local flower_choice = rand:next(1, 6)
				local flower = "viola"
				if flower_choice == 1 then
					flower = "tulip"
				elseif flower_choice == 2 then
					flower = "rose"
				elseif flower_choice == 3 then
					flower = "dandelion_yellow"
				elseif flower_choice == 4 then
					flower = "dandelion_white"
				elseif flower_choice == 5 then
					flower = "geranium"
				end
				minetest.set_node(p_pos, {name="flowers:"..flower})
			end
		end
	end
	end
end)