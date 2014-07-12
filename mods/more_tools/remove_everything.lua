minetest.register_craftitem("more_tools:remove_everything", {
	description = "Remove everything tool",
	inventory_image = "remove_everything.png",
	stack_max = 1,
	range = 15,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" then
			local name = minetest.get_node(pointed_thing.under).name
			if name == "ignore" or name == "air" then
				return itemstack
			end
			minetest.remove_node(pointed_thing.under)
			minetest.chat_send_player(user:get_player_name(), "Removed "..name)
		elseif pointed_thing.type == "object" then
			pointed_thing.ref:set_hp(0)
			pointed_thing.ref:remove()
		end
		return itemstack
	end
})