-- collect items (based on PilzAdam's item_drop mod)

local ttime = 0
minetest.register_globalstep(function(dtime)
	ttime = ttime + dtime
	if ttime < 1 then return end
	ttime = 0
	
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 and not player:get_player_control().LMB then
			local pos = player:getpos()
			local inv = nil
			local sound = false
			pos.y = pos.y + 0.5
			
			for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
				if not object:is_player() and object:get_luaentity().name == "__builtin:item" then
					local itemstring = object:get_luaentity().itemstring
					if not inv then
						inv = player:get_inventory()
					end
					if inv:room_for_item("main", itemstring) then
						object:get_luaentity().itemstring = ""
						object:remove()
						sound = true
						inv:add_item("main", itemstring)
					end
				end
			end
			if sound then
				minetest.sound_play("item_drop_pickup", {
					to_player = player:get_player_name(),
					gain = 0.4,
				})
			end
		end
	end
end)


-- drop item(s) (based on kaeza's codes)
function minetest.item_drop(itemstack, dropper, pos)
	if not dropper.get_player_name then
		minetest.add_item(pos, itemstack)
		return ItemStack("")
	end
	local drop = ""
	local item_name = itemstack:get_name()
	if dropper:get_player_control().sneak then
		local del = (itemstack:get_count() <= 1)
		drop = itemstack:take_item()
		if del then
			itemstack = ItemStack("")
		end
	else
		drop = itemstack
		itemstack = ItemStack("")
	end
	local dir = dropper:get_look_dir()
	local obj = minetest.add_item({x=pos.x+dir.x, y=pos.y+1.5+dir.y, z=pos.z+dir.z}, drop)
	if obj then
		dir = {x=dir.x*2, y=dir.y*2+1, z=dir.z*2}
		obj:setvelocity(dir)
	elseif item_name ~= "" then
		if not minetest.registered_items[item_name] then
			itemstack = ItemStack("")
		end
	end
	return itemstack
end

--override builtin item to 3d-view (beased on RealBadAngel's codes)
minetest.registered_entities["__builtin:item"].set_item = function(self, itemstring)
	local stack = ItemStack(itemstring)
	local count = stack:get_count()
	local itemname = stack:get_name()
	--if itemname == "" then
	--	self.object:remove()
	--	return
	--end
	local max_count = stack:get_stack_max()
	if count > max_count then
		count = max_count
		self.itemstring = itemname.." "..max_count
	else
		self.itemstring = itemstring
	end
	if max_count < 4 then
		max_count = 4
	end
	local a = 0.2 + 0.16*(count / max_count)
	prop = {
		is_visible = true,
		visual = "wielditem",
		textures = {itemname},
		visual_size = {x=a, y=a},
		collisionbox = {-0.8*a,-0.8*a,-0.8*a, 0.8*a,0.8*a,0.8*a},
		automatic_rotate = 3.14 * 0.2,
	}
	self.object:set_properties(prop)
end