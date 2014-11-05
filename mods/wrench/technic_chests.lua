local INT, STRING, FLOAT  = 
	wrench.META_TYPE_INT,
	wrench.META_TYPE_STRING,
	wrench.META_TYPE_FLOAT

local chest_types = { "iron", "copper", "silver", "gold", "mithril" }
for i, k in ipairs(chest_types) do
	local normal_chest = {}
	local locked_chest = {
		infotext = STRING,
		owner = STRING
	}
	if k ~= "iron" and k ~= "copper" then
		normal_chest.infotext = STRING
		normal_chest.formspec = STRING
		locked_chest.formspec = STRING
	end
	wrench:register_node("technic:"..k.."_chest", {
		lists = {"main"},
		metas = normal_chest
	})
	wrench:register_node("technic:"..k.."_locked_chest", {
		lists = {"main"},
		metas = locked_chest,
		owned = true,
	})
end

local chest_mark_colors = {
	"_black",
	"_blue", 
	"_brown",
	"_cyan",
	"_dark_green",
	"_dark_grey",
	"_green",
	"_grey",
	"_magenta",
	"_orange",
	"_pink",
	"_red",
	"_violet",
	"_white",
	"_yellow",
	"",
}

for i = 1, 15 do
	wrench:register_node("technic:gold_chest"..chest_mark_colors[i], {
		lists = {"main"},
		metas = {
			infotext = STRING,
			formspec = STRING
		},
	})
	wrench:register_node("technic:gold_locked_chest"..chest_mark_colors[i], {
		lists = {"main"},
		metas = {
			infotext = STRING,
			owner = STRING,
			formspec = STRING
		},
		owned = true,
	})
end