-- Minetest 0.4 mod: player
-- See README.txt for licensing and other information.

default.registered_player_models = {}

-- Local for speed.
local all_models = default.registered_player_models
local main_model = false

function default.player_register_model(name, def)
	def = def or {}
	def.animation_speed = def.animation_speed or 30
	def.textures = def.textures or {"character.png"}
	def.visual_size = def.visual_size or {x = 1, y = 1}
	if not def.animations then
		def.animations = {
			stand     = {x = 0, y = 79},
			lay       = {x = 162, y = 166},
			walk      = {x = 168, y = 187},
			mine      = {x = 189, y = 198},
			walk_mine = {x = 200, y = 219},
			sit       = {x = 81, y = 160},
		}
	end
	all_models[name] = def
	if not main_model then
		main_model = name
	end
end

default.player_register_model("character.b3d")

local players = {}

function default.player_get_animation(player)
	local name = player:get_player_name()
	return {
		model = players[name].model,
		textures = players[name].textures,
		animation = players[name].anim,
	}
end

function default.player_set_model(player, model_name)
	local name = player:get_player_name()
	if players[name].model == model_name then
		return
	end
	
	model_name = model_name or main_model
	local model = all_models[model_name]
	if not model then
		model_name = main_model
		model = all_models[main_model]
	end
	local anim = model.animations
	players[name].model = model_name
	players[name].textures = players[name].textures or model.textures
	
	player:set_properties({
		mesh = model_name,
		textures = players[name].textures,
		visual = "mesh",
		visual_size = model.visual_size,
	})
	player:set_local_animation(
		anim.stand, 
		anim.walk, 
		anim.mine, 
		anim.walk_mine,
		model.animation_speed
	)
	default.player_set_animation(player, "stand")
end

function default.player_set_textures(player, textures)
	local name = player:get_player_name()
	if players[name].textures == textures then
		return
	end
	if not textures then
		textures = all_models[players[name].model].textures
	end
	players[name].textures = textures
	player:set_properties({
		textures = textures
	})
end

function default.player_set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	local pl_model = players[name]
	if not pl_model then return end
	local model = all_models[pl_model.model]
	
	speed = speed or model.animation_speed
	
	if (players[name].anim == anim_name and
			players[name].speed == speed) then
		return
	end
	
	local anim = model.animations[anim_name]
	if not anim then return end
	
	players[name].anim = anim_name
	players[name].speed = speed
	player:set_animation(anim, speed, 0)
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	players[name] = {
		model = false,
		textures = false,
		anim = false,
		speed = false
	}
	default.player_set_model(player, nil)
end)

local player_attached = default.player_attached

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
	player_attached[name] = nil
end)

-- Localize for better performance.
local player_set_anim = default.player_set_animation

-- Check each player and apply animations
local ttime = 0
minetest.register_globalstep(function(dtime)
	if dtime < 0.3 then
		ttime = ttime + dtime
		if ttime < 0.2 then
			return
		end
		ttime = 0
	end
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local model = all_models[players[name].model]
		if model and not player_attached[name] then
			local controls = player:get_player_control()
			local walking = false
			local anim_speed = false
			local anim = "stand"

			-- Walks?
			if controls.up or controls.down or controls.left or controls.right then
				walking = true
			end

			-- Sneak = slower
			if controls.sneak and walking then
				anim_speed = model.animation_speed / 2
			end

			if player:get_hp() == 0 then
				-- Dead
				anim = "lay"
			else
				if walking then
					anim = "walk"
				end
				if controls.LMB then
					if walking then
						anim = "walk_mine"
					else
						anim = "mine"
					end
				end
			end
			player_set_anim(player, anim, anim_speed)
		end
	end
end)