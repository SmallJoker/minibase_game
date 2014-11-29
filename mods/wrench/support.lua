--[[
supported_nodes
This table stores all nodes that are compatible with the wrench mod.
Syntax:
	[<node name>] = {
		lists = {"<inventory list name>"},
		metas = {["<meta name>"] = STRING,
			["<meta name>"] = INT,
			["<meta name>"] = FLOAT},
		owned = true,
		store_meta_always = true,
	}
	owned - nodes that are protected by owner requirements (Ex. locked chests)
	store_meta_always - when nodes are broken this ensures metadata and 
	inventory is always stored (Ex. active state for machines)
--]]

wrench.META_TYPE_INT = 0
wrench.META_TYPE_FLOAT = 1
wrench.META_TYPE_STRING = 2

local INT, STRING, FLOAT  = 
	wrench.META_TYPE_INT,
	wrench.META_TYPE_STRING,
	wrench.META_TYPE_FLOAT

wrench.registered_nodes = {
	["default:chest"] = {
		lists = {"main"},
	},
	["default:chest_locked"] = {
		lists = {"main"},
		metas = {
			owner = STRING,
			infotext = STRING
		},
		owned = true,
	},
	["default:furnace"] = {
		lists = {"fuel", "src", "dst"},
		metas = {
			infotext = STRING,
			fuel_totaltime = FLOAT,
			fuel_time = FLOAT,
			src_totaltime = FLOAT,
			src_time = FLOAT
		},
	},
	["default:furnace_active"] = {
		lists = {"fuel", "src", "dst"},
		metas = {infotext = STRING,
			fuel_totaltime = FLOAT,
			fuel_time = FLOAT,
			src_totaltime = FLOAT,
			src_time = FLOAT},
		store_meta_always = true,
	},
	["default:sign_wall"] = {
		metas = {
			infotext = STRING,
			formspec = STRING,
			text = STRING
		},
	},
}

function wrench:original_name(name)
	for key, value in pairs(self.registered_nodes) do
		if name == value.name then
			return key
		end
	end
end

function wrench:register_node(name, def)
	local olddef = minetest.registered_nodes[name]
	if not olddef then
		return
	end
	
	local newdef = {}
	for key, value in pairs(olddef) do
		newdef[key] = value
	end
	newdef.stack_max = 1
	newdef.description = S("%s with items"):format(newdef.description)
	newdef.groups = {}
	newdef.groups.not_in_creative_inventory = 1
	newdef.on_construct = nil
	newdef.on_destruct = nil
	newdef.after_place_node = restore
	
	self.registered_nodes[name] = def
	minetest.register_node(":"..wrench.get_pickup_name(name), newdef)
end

for k, v in pairs(wrench.registered_nodes) do
	wrench:register_node(k, v)
end
