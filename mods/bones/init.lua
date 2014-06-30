-- Minetest 0.4 mod: bones
-- See README.txt for licensing and other information.

local function is_owner(pos, name)
	local owner = minetest.get_meta(pos):get_string("owner")
	if owner == "" or owner == name then
	-- or minetest.get_player_privs(name).server
		return true
	end
	return false
end

minetest.register_node("bones:bones", {
	description = "Bones",
	tiles = {
		"bones_top.png",
		"bones_bottom.png",
		"bones_side.png",
		"bones_side.png",
		"bones_rear.png",
		"bones_front.png"
	},
	groups = {dig_immediate=2},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.5},
		dug = {name="default_gravel_footstep", gain=1.0},
	}),
	
	can_dig = function(pos, player)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("main")
	end,
	
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if is_owner(pos, player:get_player_name()) then
			return count
		end
		return 0
	end,
	
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return 0
	end,
	
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if is_owner(pos, player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,
	
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if meta:get_inventory():is_empty("main") then
			minetest.remove_node(pos)
		end
	end,
	
	on_punch = function (pos, node, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("main") then
			minetest.remove_node(pos)
			return
		end
		if(is_owner(pos, player:get_player_name())) then
			local player_inv = player:get_inventory()
			for i=1,inv:get_size("main") do
				local stk = inv:get_stack("main", i)
				if player_inv:room_for_item("main", stk) then
					player_inv:add_item("main", stk)
				else
					minetest.add_item(pos, stk)
				end
			end
			minetest.remove_node(pos)
		end
	end,
	
	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local dtime = meta:get_int("time")+elapsed
		
		if dtime >= 600 * 2 then
			meta:set_string("infotext", meta:get_string("owner").."'s old bones")
			meta:set_string("owner", "")
			return false
		end
		meta:set_int("time", dtime)
		return true
	end,
})

ondie_messages = {
	a1 = " hated the life.",
	a2 = " didn't look down before walking.",
	a3 = " walked into the fog. Never came back.",
	a4 = " liked every possible tick-tock sound.",
	a5 = " died.",
	a6 = "'s last words were: >What the nether are you doing?<",
	a7 = " did not believe the earth is a disk. - Sailed too far.",
	a8 = " laughed and died.",
	a9 = ": >Haha, I died faster than you!<",
	a10 = " cried, but that did not help to survive.",
	a11 = " tried to swim in lava. Failed somehow.",
	a12 = " thought they were inflammable.",
}

local spawnPos = minetest.setting_get_pos("static_spawnpoint")

minetest.register_on_dieplayer(function(player)
	if minetest.setting_getbool("creative_mode") then
		return
	end
	
	local pos = player:getpos()
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y+0.5)
	pos.z = math.floor(pos.z+0.5)
	
	if spawnPos then
		-- died at spawn?
		if vector.equals(spawnPos, pos) then
			return
		end
	end
	
	local pn = player:get_player_name()
	minetest.chat_send_all(pn..ondie_messages[("a"..(math.random(1,12)).."")])
    
	local player_inv = player:get_inventory()
	if player_inv:is_empty("main") then
		return
	end
	
	local bpos = minetest.find_node_near(pos, 2, {"air", "group:liquid"})
	
	if not bpos then
		for i=1,player_inv:get_size("main") do
			minetest.add_item(pos, player_inv:get_stack("main", i))
		end
		player_inv:set_list("main", {})
		
		minetest.chat_send_player(pn, "You died at "..minetest.pos_to_string(pos)..". There was no place for your bones.", true)
		return
	end
	
	minetest.set_node(bpos, {name="bones:bones"})
	
	local meta = minetest.get_meta(bpos)
	local inv = meta:get_inventory()
	inv:set_size("main", 8*4)
	
	inv:set_list("main", player_inv:get_list("main"))
	player_inv:set_list("main", {})
		
	meta:set_string("formspec", "size[8,9;]"..
			"list[current_name;main;0,0;8,4;]"..
			"list[current_player;main;0,5;8,4;]")
	meta:set_string("infotext", pn.."'s fresh bones")
	meta:set_string("owner", pn)
	meta:set_int("time", 0)
	minetest.chat_send_player(pn, "You died at "..minetest.pos_to_string(bpos)..". Your bones stay fresh for 20 minutes.", true)
	local timer = minetest.get_node_timer(bpos)
    timer:start(10)
end)