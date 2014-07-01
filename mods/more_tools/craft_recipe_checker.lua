local checker = {}
checker.recipes = {}
checker.aliases = {}
 
local register_craft = minetest.register_craft
local register_alias = minetest.register_alias
 
local function group_exists(groupname)
	local flags = groupname:split(",")
	for name, def in pairs(minetest.registered_items) do
		local flag = true
		for k, v in pairs(flags) do
			local g = def.groups and def.groups[v:gsub('%group:', '')] or 0
			if not g or g <= 0 then
				flag = false
				break
			end
		end
		if flag then
			return true
		end
	end
	return false
end
 
minetest.register_craft = function(recipe)
	register_craft(recipe)
 
	if checker.strip_name(recipe.output) then
		table.insert(checker.recipes,recipe)
	end
end
 
minetest.register_alias = function(new,old)
	register_alias (new,old)
	
	local name = checker.strip_name(new)
	local name2 = checker.strip_name(old)
	if name and name2 then
		checker.aliases[new] = old
	end
end
 
function checker.assert(_name,output)
	local name = checker.strip_name(_name)
	if not name then
		print("[RECIPE ERROR] nil in recipe for "..checker.strip_name(output))
		return
	end
	
	if checker.aliases[name] then
		name = checker.aliases[name]
	end
 
	if not minetest.registered_items[name] and not group_exists(name) then
		print("[RECIPE ERROR] "..name.." in recipe for "..checker.strip_name(output))
	end
end
 
function checker.strip_name(name)
	if not name then return end
 
	res = name:gsub('%"', '')
 
	if res:sub(1,1) == ":" then
    	res = table.concat{res:sub(1,1-1), "", res:sub(1+1)}
	end
 
	for str in string.gmatch(res, "([^ ]+)") do
		if str and str ~= " " then
			res = str
			break
		end
	end
	
	if not res then
		res = ""
	end
 
	return res
end
 
-- Recursion method
function checker.check_recipe(table,output)
	if type(table) == "table" then
		for i=1,# table do
			checker.check_recipe(table[i],output)
		end
	else
		checker.assert(table,output)
	end
end
 
 
minetest.after(1, function()
	print("[DEBUG] checking recipes")
	for i=1,# checker.recipes do
		if checker.recipes[i] and checker.recipes[i].output then
			checker.assert(checker.recipes[i].output,checker.recipes[i].output)
			if type(checker.recipes[i].recipe) == "table" then
				for a=1,# checker.recipes[i].recipe do
					checker.check_recipe(checker.recipes[i].recipe[a],checker.recipes[i].output)
				end
			else
				checker.assert(checker.recipes[i].recipe,checker.recipes[i].output)
			end
		end
	end
end)