-- Minetest 0.4 mod: bucket
-- See README.txt for licensing and other information.

minetest.register_alias("bucket", "bucket:bucket_empty")
minetest.register_alias("bucket_water", "bucket:bucket_water")
minetest.register_alias("bucket_lava", "bucket:bucket_lava")

bucket = {}
bucket.liquids = {}

local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

-- Register a new liquid
--   source = name of the source node
--   flowing = name of the flowing node
--   itemname = name of the new bucket item (or nil if liquid is not takeable)
--   inventory_image = texture of the new bucket item (ignored if itemname == nil)
-- This function can be called from any mod (that depends on bucket).
function bucket.register_liquid(source, flowing, itemname, inventory_image, name)
	bucket.liquids[source] = {
		source = source,
		flowing = flowing,
		itemname = itemname,
	}
	bucket.liquids[flowing] = bucket.liquids[source]

	if not itemname then
		return
	end
	minetest.register_craftitem(itemname, {
		description = name,
		inventory_image = inventory_image,
		stack_max = 1,
		liquids_pointable = true,
		on_place = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			
			local node = minetest.get_node(pointed_thing.under)
			local ndef = minetest.registered_nodes[node.name]
			
			-- Call on_rightclick if the pointed node defines it
			if ndef.on_rightclick and not user:get_player_control().sneak then
				return ndef.on_rightclick(
					pointed_thing.under,
					node, user,
					itemstack) or itemstack
			end

			local place_at = nil
			if ndef.buildable_to then
				place_at = pointed_thing.under
			else
				-- not buildable to; place the liquid above
				-- check if the node above can be replaced
				node = minetest.get_node(pointed_thing.above)
				ndef = minetest.registered_nodes[node.name]
				if ndef.buildable_to then
					place_at = pointed_thing.above
				end
			end
			
			if not place_at then
				return
			end
			if check_protection(place_at, user:get_player_name()) then
				return
			end
			
			minetest.add_node(place_at, {name = source})
			return {name = "bucket:bucket_empty"}
		end
	})
end

minetest.register_craftitem("bucket:bucket_empty", {
	description = "Empty Bucket",
	inventory_image = "bucket.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		
		-- Check if pointing to a liquid source
		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		local ldef = bucket.liquids[node.name]
		
		if ldef and ldef.itemname and node.name == ldef.source then
			if check_protection(pos, user:get_player_name()) then
				return
			end

			minetest.remove_node(pos)
			return {name = ldef.itemname}
		end
	end,
})

minetest.register_craft({
	output = "bucket:bucket_empty",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
	}
})

bucket.register_liquid(
	"default:water_source",
	"",
	"bucket:bucket_water",
	"bucket_water.png",
	"Water Bucket"
)

bucket.register_liquid(
	"default:lava_source",
	"",
	"bucket:bucket_lava",
	"bucket_lava.png",
	"Lava Bucket"
)

minetest.register_craft({
	type = "fuel",
	recipe = "bucket:bucket_lava",
	burntime = 60,
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})