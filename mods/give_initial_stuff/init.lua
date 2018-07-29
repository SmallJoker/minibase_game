if minetest.settings:get_bool("give_initial_stuff") then
	minetest.register_on_newplayer(function(player)
		local inv = player:get_inventory()
		inv:add_item("main", "default:pick_stone")
		inv:add_item("main", "default:torch 8")
		inv:add_item("main", "default:wood 10")
	end)
end