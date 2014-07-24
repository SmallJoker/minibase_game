-- Minetest 0.4 mod: farming
-- See README.txt for licensing and other information.

farming = {}
farming.modpath = minetest.get_modpath("farming")
dofile(farming.modpath.."/nodes.lua")
dofile(farming.modpath.."/hoes.lua")

--
-- Hoes
--
-- turns nodes with group soil=1 into soil
function farming.hoe_on_use(itemstack, user, pointed_thing, uses)
	local pt = pointed_thing
	-- check if pointing at a node
	if pointed_thing.type ~= "node" then
		return
	end
	if minetest.is_protected(pointed_thing.above, user:get_player_name()) then
		minetest.chat_send_player(user:get_player_name(), "This area is protected, you can not use your hoe here.")
		return
	end
	local p = vector.new(pointed_thing.under)
	local under = minetest.get_node(p)
	p.y = p.y + 1
	local above = minetest.get_node(p)
	
	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] or
			not minetest.registered_nodes[above.name] then
		return
	end
	
	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end
	
	-- check if pointing at dirt
	if minetest.get_item_group(under.name, "soil") ~= 1 then
		return
	end
	
	-- turn the node into soil, wear out item and play sound
	minetest.set_node(pt.under, {name="farming:soil"})
	minetest.sound_play("default_dig_crumbly", {
		pos = pt.under,
		gain = 0.6,
	})
	itemstack:add_wear(65535/(uses-1))
	return itemstack
end

--
-- Place seeds
--

local function place_seed(itemstack, placer, pointed_thing, plantname)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	
	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)
	
	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	
	-- check if pointing at the top of the node
	if pt.above.y ~= pt.under.y+1 then
		return
	end
	
	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return
	end
	
	-- check if pointing at soil
	if minetest.get_item_group(under.name, "soil") <= 1 then
		return
	end
	
	-- add the node and remove 1 item from the itemstack
	minetest.add_node(pt.above, {name=plantname})
	itemstack:take_item()
	return itemstack
end

function farming.register_plant(modname, name, def)
	local item = string.lower(name)
	local item_group = "plant_"..modname.."_"..item
	def.image_seed = def.image_seed or "unknown_item.png"
	def.image_plant = def.image_plant or "unknown_node.png"
	def.drops = def.drops or "default:dirt"
	def.steps = def.steps or 4
	def.interval = def.interval or 20
	
	minetest.register_craftitem(":"..modname..":seed_"..item, {
		description = name.." seed",
		inventory_image = def.image_seed,
		on_place = function(itemstack, placer, pointed_thing)
			return place_seed(itemstack, placer, pointed_thing, modname..":"..item.."_1")
		end,
	})
	
	for i = 1, def.steps do
		local p_drops = {
			items = {
				{items = {def.drops}, rarity = 9-i},
				{items = {def.drops}, rarity = 18 - i*2},
				{items = {modname..":seed_"..item}, rarity = 9 - i},
				{items = {modname..":seed_"..item}, rarity = 18 - i*2},
			}
		}
		local p_groups = {snappy=3, flammable=2, plant=1, not_in_creative_inventory=1, attached_node=1}
		p_groups[item_group] = i
		local p_image = {}
		p_image[1] = string.gsub(def.image_plant, "?", i)
		
		local p_height = math.floor((i / (def.steps * 1.5)) * 100 + 0.5) / 100 - 0.5
		
		minetest.register_node(":"..modname..":"..item.."_"..i, {
			drawtype = "plantlike",
			paramtype = "light",
			tiles = p_image,
			walkable = false,
			buildable_to = true,
			is_ground_content = true,
			drop = p_drops,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, p_height, 0.5},
			},
			groups = p_groups,
			sounds = default.node_sound_leaves_defaults(),
		})
	end
	
	minetest.register_abm({
		nodenames = {"group:"..item_group},
		neighbors = {"group:soil"},
		interval = def.interval,
		chance = 10,
		action = function(pos, node)
			local current_step = minetest.get_item_group(node.name, item_group)
			-- Fully grown
			if current_step == def.steps then
				return
			end
			
			-- Is soil?
			pos.y = pos.y - 1
			local under = minetest.get_node(pos)
			if minetest.get_item_group(under.name, "soil") < 3 then
				return
			end
			pos.y = pos.y + 1
			
			-- Check light
			if minetest.get_node_light(pos) < 13 then
				return
			end
			
			minetest.set_node(pos, {name = modname..":"..item.."_"..(current_step + 1)})
		end
	})
end

--
-- Wheat
--

farming.register_plant("farming", "Wheat", {
	image_seed = "farming_wheat_seed.png",
	image_plant = "farming_wheat_?.png",
	drops = "farming:wheat",
	steps = 8,
	interval = 20
})

minetest.register_craftitem("farming:wheat", {
	description = "Wheat",
	inventory_image = "farming_wheat.png",
})

minetest.register_craftitem("farming:flour", {
	description = "Flour",
	inventory_image = "farming_flour.png",
})

minetest.register_craftitem("farming:bread", {
	description = "Bread",
	inventory_image = "farming_bread.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:flour",
	recipe = {"farming:wheat", "farming:wheat", "farming:wheat", "farming:wheat"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:bread",
	recipe = "farming:flour"
})

--
-- Cotton
--

farming.register_plant("farming", "Cotton", {
	image_seed = "farming_cotton_seed.png",
	image_plant = "farming_cotton_?.png",
	drops = "farming:string",
	steps = 8,
	interval = 20
})

minetest.register_craftitem("farming:string", {
	description = "String",
	inventory_image = "farming_string.png",
})

minetest.register_craft({
	output = "wool:white",
	recipe = {
		{"farming:string", "farming:string"},
		{"farming:string", "farming:string"},
	}
})
