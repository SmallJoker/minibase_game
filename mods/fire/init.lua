local fire = {}
function fire.flame_should_extinguish(x)
	return false
end

minetest.register_node("fire:basic_flame", {
	description = "Fire",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 14,
	groups = {dig_immediate=3, hot=3, not_in_creative_inventory=1},
	drop = "",
	pointable = false,
	walkable = false,
	damage_per_second = 3,
})

local playing_sounds = {}
minetest.register_abm({
	nodenames = {"group:flammable"},
	neighbors = {"group:igniter"},
	interval = 5,
	chance = 5,
	action = function(pos)
		if pos.y > 5 then
			return
		end
		if minetest.find_node_near(pos, 2, {"group:puts_out_fire", "group:freezes"}) then
			return
		end
		minetest.add_item(pos, "default:scorched_stuff")
		minetest.set_node(pos, {name="fire:basic_flame"})
		-- Play sound all 2*2*2 nodes
		local hashpos = vector.divide(pos, 2)
		local hash = minetest.hash_node_position(vector.round(hashpos))
		if not playing_sounds[hash] then
			playing_sounds[hash] = minetest.sound_play(
				{name="fire_small", gain=1.5}, 
				{pos = pos, max_hear_distance = 15, loop=true}
			)
		end
	end,
})

minetest.register_abm({
	nodenames = {"fire:basic_flame"},
	interval = 5,
	chance = 5,
	action = function(pos)
		-- Stop sound all 2*2*2 nodes
		local hashpos = vector.divide(pos, 2)
		local hash = minetest.hash_node_position(vector.round(hashpos))
		if playing_sounds[hash] then
			minetest.sound_stop(playing_sounds[hash])
		end
		minetest.remove_node(pos)
	end,
})