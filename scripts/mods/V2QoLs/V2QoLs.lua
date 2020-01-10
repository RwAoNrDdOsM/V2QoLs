local mod = get_mod("V2QoLs")

local settings = {
	game_request_amount = 3,
	game_request_delay = 60,
}

mod.game_request_delay = nil
mod.update = function(dt)

	-- Client game request
	if mod.game_request_amount >= settings.game_request_amount then
		mod.game_request_delay = settings.game_request_delay
	end
	if mod.game_request_delay then
		mod.game_request_delay = mod.game_request_delay - dt
		if mod.game_request_delay <= 0 then
			mod.game_request_delay = nil
			mod.game_request_amount = 0
		end
	end
end

--[[if Managers.world:has_world("level_world") then
	local world = Managers.world:world("level_world")

	local units = World.units(world)

	for _, unit in pairs(units) do
		local num_lights = Unit.num_lights(unit)
		
		if num_lights then
			for i = 1, num_lights, 1 do
				Light.set_enabled(Unit.light(unit, i - 1), true)
				Light.set_intensity(Unit.light(unit, i - 1), 100)
				Light.set_color(Unit.light(unit, i - 1), Vector3(1, 0, 0))
			end
		end
	end
end--]]
mod.pickups = {}

mod:hook(PickupSystem, "_spawn_pickup", function (func, self, pickup_settings, pickup_name, position, rotation, with_physics, spawn_type)
	if mod:get("pickups") then
		if pickup_name == "damage_boost_potion" then
			local next_index = self._next_index

			if self._taken[next_index] then
				return
			end

			local can_spawn_func = pickup_settings.can_spawn_func
			local pickup_params = {
				level_spawn = true,
				statistics_db = self.statistics_db
			}

			if can_spawn_func and not can_spawn_func(pickup_params, spawn_type == "debug") then
				return
			end

			local extension_init_data = {
				pickup_system = {
					pickup_name = pickup_name,
					has_physics = with_physics,
					spawn_type = spawn_type,
					spawn_index = next_index
				},
				projectile_locomotion_system = {
					network_position = AiAnimUtils.position_network_scale(position, true),
					network_rotation = AiAnimUtils.rotation_network_scale(rotation, true),
					network_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true),
					network_angular_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
				}
			}
			self._next_index = next_index + 1
			local unit_template_name = pickup_settings.unit_template_name or "pickup_unit"
			local additional_data_func = pickup_settings.additional_data_func

			if additional_data_func then
				local extra_extension_init_data = nil
				extra_extension_init_data = self[additional_data_func](self, pickup_settings, position, rotation)

				table.merge(extension_init_data, extra_extension_init_data)
			end

			local unit_name = pickup_settings.unit_name
			local pickup_unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, extension_init_data, position, rotation)
			
			local pickup_unit_2 = Managers.state.unit_spawner:spawn_network_unit("units/weapons/player/pup_torch/pup_torch", "pickup_torch_unit_init", extension_init_data, position, rotation)
			mod.pickups[pickup_unit] = pickup_unit_2
			
			local world = Managers.world:world("level_world")
			World.link_unit(world, pickup_unit_2, pickup_unit)
			Unit.set_unit_visibility(pickup_unit_2, false)
			local num_lights = Unit.num_lights(pickup_unit_2)
			--mod:echo(pickup_unit_2)
			if num_lights then
				for i = 1, num_lights, 1 do
					local unit_light = Unit.light(pickup_unit_2, i - 1)
					Light.set_enabled(unit_light, true)
					Light.set_intensity(unit_light, 0.10)
					Light.set_color(unit_light, Vector3(1, 0, 0))
				end
			end

			if self.is_server then
				self._spawned_pickups[#self._spawned_pickups + 1] = pickup_unit
				local amount_spawned = self._amount_spawned
				local amount = amount_spawned[pickup_name]

				if amount then
					amount_spawned[pickup_name] = amount + 1
				else
					amount_spawned[pickup_name] = 1
				end
			end

			return pickup_unit
		elseif pickup_name == "speed_boost_potion" then
			local next_index = self._next_index

			if self._taken[next_index] then
				return
			end

			local can_spawn_func = pickup_settings.can_spawn_func
			local pickup_params = {
				level_spawn = true,
				statistics_db = self.statistics_db
			}

			if can_spawn_func and not can_spawn_func(pickup_params, spawn_type == "debug") then
				return
			end

			local extension_init_data = {
				pickup_system = {
					pickup_name = pickup_name,
					has_physics = with_physics,
					spawn_type = spawn_type,
					spawn_index = next_index
				},
				projectile_locomotion_system = {
					network_position = AiAnimUtils.position_network_scale(position, true),
					network_rotation = AiAnimUtils.rotation_network_scale(rotation, true),
					network_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true),
					network_angular_velocity = AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
				}
			}
			self._next_index = next_index + 1
			local unit_template_name = pickup_settings.unit_template_name or "pickup_unit"
			local additional_data_func = pickup_settings.additional_data_func

			if additional_data_func then
				local extra_extension_init_data = nil
				extra_extension_init_data = self[additional_data_func](self, pickup_settings, position, rotation)

				table.merge(extension_init_data, extra_extension_init_data)
			end

			local unit_name = pickup_settings.unit_name
			local pickup_unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, extension_init_data, position, rotation)
			
			local pickup_unit_2 = Managers.state.unit_spawner:spawn_network_unit("units/weapons/player/pup_torch/pup_torch", "pickup_torch_unit_init", extension_init_data, position, rotation)
			mod.pickups[pickup_unit] = pickup_unit_2
			
			local world = Managers.world:world("level_world")
			--World.link_unit(world, pickup_unit_2, pickup_unit)
			Unit.set_unit_visibility(pickup_unit_2, false)
			local num_lights = Unit.num_lights(pickup_unit_2)
			--mod:echo(pickup_unit_2)
			if num_lights then
				for i = 1, num_lights, 1 do
					local unit_light = Unit.light(pickup_unit_2, i - 1)
					Light.set_enabled(unit_light, true)
					Light.set_intensity(unit_light, 0.15)
					Light.set_color(unit_light, Vector3(0, 0, 1))
				end
			end

			if self.is_server then
				self._spawned_pickups[#self._spawned_pickups + 1] = pickup_unit
				local amount_spawned = self._amount_spawned
				local amount = amount_spawned[pickup_name]

				if amount then
					amount_spawned[pickup_name] = amount + 1
				else
					amount_spawned[pickup_name] = 1
				end
			end

			return pickup_unit
		else
			return func(self, pickup_settings, pickup_name, position, rotation, with_physics, spawn_type)
		end
	else
		return func(self, pickup_settings, pickup_name, position, rotation, with_physics, spawn_type)
	end
end)

mod:hook(InteractionDefinitions.pickup_object.server, "stop", function (func, world, interactor_unit, interactable_unit, data, config, t, result)
	if mod.pickups[interactor_unit] then
		Managers.state.unit_spawner:mark_for_deletion(mod.pickups[interactor_unit])
	end
	if mod.pickups[interactable_unit] then
		Managers.state.unit_spawner:mark_for_deletion(mod.pickups[interactable_unit])
	end
	func(world, interactor_unit, interactable_unit, data, config, t, result)
end)


mod.reset_overcharge_bar = false

local widget_settings = {
	ally = {
		"OutlineSettings.colors.ally.outline_multiplier",
		function()
			if Managers.world:has_world("level_world") then
				local world = Managers.world:world("level_world")
			
				local units = World.units(world)
			
				for _, unit in pairs(units) do
					local outline_extension = ScriptUnit.extension(unit, "outline_system")

					if outline_extension then
						if outline_extension.update_override_outline_color then
							outline_extension.update_override_outline_color()
						end
					end
				end
			end
		end,
	},
	knocked_down = {
		"OutlineSettings.colors.knocked_down.outline_multiplier",
		function()
			if Managers.world:has_world("level_world") then
				local world = Managers.world:world("level_world")
			
				local units = World.units(world)
			
				for _, unit in pairs(units) do
					local outline_extension = ScriptUnit.extension(unit, "outline_system")

					if outline_extension then
						if outline_extension.update_override_outline_color then
							outline_extension.update_override_outline_color()
						end
					end
				end
			end
		end,
	},
	interactable = {
		"OutlineSettings.colors.interactable.outline_multiplier",
		function()
			if Managers.world:has_world("level_world") then
				local world = Managers.world:world("level_world")
			
				local units = World.units(world)
			
				for _, unit in pairs(units) do
					local outline_extension = ScriptUnit.extension(unit, "outline_system")

					if outline_extension then
						if outline_extension.update_override_outline_color then
							outline_extension.update_override_outline_color()
						end
					end
				end
			end
		end,
	},
	player_attention = {
		"OutlineSettings.colors.player_attention.outline_multiplier",
		function()
			if Managers.world:has_world("level_world") then
				local world = Managers.world:world("level_world")
			
				local units = World.units(world)
			
				for _, unit in pairs(units) do
					local outline_extension = ScriptUnit.extension(unit, "outline_system")

					if outline_extension then
						if outline_extension.update_override_outline_color then
							outline_extension.update_override_outline_color()
						end
					end
				end
			end
		end,
	},
	auto_blocking = {
		"InteractionDefinitions.revive.config.activate_block",
		"InteractionDefinitions.pull_up.config.activate_block",
		"InteractionDefinitions.release_from_hook.config.activate_block",
		"InteractionDefinitions.assisted_respawn.config.activate_block",
	},
	lose_condition_time = "GameModeSettings.adventure.lose_condition_time",
	lose_condition_time_dead = "GameModeSettings.adventure.lose_condition_time_dead",
	outlines = function()
		if mod:get("outlines") == "VT1" then
			mod:set("ally", 2, true)
			mod:set("knocked_down", 3, true)
			mod:set("interactable", 2, true)
			mod:set("player_attention", 3, true)
		elseif mod:get("outlines") == "VT2" then
			mod:set("ally", 7, true)
			mod:set("knocked_down", 7, true)
			mod:set("interactable", 4, true)
			mod:set("player_attention", 6, true)
		end
	end,
	overcharge_bar = function()
		mod.reset_overcharge_bar = true
	end
}

local function type_widget_setting(widget_setting, setting_id)
	if type(widget_setting) == "table" then
		if #widget_setting > 0 then
			for i=1, #widget_setting do
				local setting = widget_setting[i]
				type_widget_setting(setting)
			end
		else
			for widget, _widget in pairs(widget_setting) do
				type_widget_setting(widget_setting[widget])
			end
		end
	elseif type(widget_setting) == "string" then
		mod:pcall(function()
			widget_setting = mod:get(setting_id)
			return
		end)
	elseif type(widget_setting) == "function" then
		mod:pcall(function()
			widget_setting()
		end)
	end
end

mod.on_setting_changed = function(setting_id)
	if widget_settings[setting_id] then
		local widget_setting = widget_settings[setting_id]
		type_widget_setting(widget_setting, setting_id)
	end
end

mod.reload_hud = false
mod:hook_safe(StateInGameRunning, "update", function (self, dt, t)
	--[[if mod.reload_hud then
		self:create_ingame_ui(self.ingame_ui_context)
		mod.reload_hud = false
	end]]
end)

-- Overcharge on melee equipped + critical overcharge bar
local overcharge_bar_ui_definitions = require("scripts/ui/hud_ui/overcharge_bar_ui_definitions")
local passes = {}
overcharge_bar_ui_definitions.widget_definitions.charge_bar.style.black_divider_left_high = {
	angle = 0,
	scenegraph_id = "charge_bar_black_divider_start",
	color = {
		255,
		255,
		255,
		255
	},
	pivot = {
		4,
		4
	},
	offset = {
		0,
		0,
		0
	}		
}
overcharge_bar_ui_definitions.widget_definitions.charge_bar.style.black_divider_right_high = {
	angle = 0,
	scenegraph_id = "charge_bar_black_divider_start",
	color = {
		255,
		255,
		255,
		255
	},
	pivot = {
		4,
		4
	},
	offset = {
		0,
		0,
		0
	}
}
passes = {
	{
		pass_type = "rotated_texture",
		style_id = "black_divider_left_high",
		texture_id = "black_divider"
	},
	{
		pass_type = "rotated_texture",
		style_id = "black_divider_right_high",
		texture_id = "black_divider"
	},
}

if #passes > 0 then
	table.append(overcharge_bar_ui_definitions.widget_definitions.charge_bar.element.passes, passes)
end
local function get_overcharge_amount(left_hand_wielded_unit, right_hand_wielded_unit)
	local overcharge_extension = nil

	if right_hand_wielded_unit and ScriptUnit.has_extension(right_hand_wielded_unit, "overcharge_system") then
		overcharge_extension = ScriptUnit.extension(right_hand_wielded_unit, "overcharge_system")
	elseif left_hand_wielded_unit and ScriptUnit.has_extension(left_hand_wielded_unit, "overcharge_system") then
		overcharge_extension = ScriptUnit.extension(left_hand_wielded_unit, "overcharge_system")
	end

	if overcharge_extension then
		local overcharge_fraction = overcharge_extension:overcharge_fraction()
		local threshold_fraction = overcharge_extension:threshold_fraction()
		local anim_blend_overcharge = overcharge_extension:get_anim_blend_overcharge()
		local max_threshold_fraction = overcharge_extension:max_threshold_fraction()
		local mid_threshold_fraction = overcharge_extension:mid_threshold_fraction()

		return overcharge_fraction, threshold_fraction, mid_threshold_fraction, max_threshold_fraction, anim_blend_overcharge
	end
end
OverChargeExtension.max_threshold_fraction = function (self)
	return self.overcharge_critical_limit / self.max_value
end
OverChargeExtension.mid_threshold_fraction = function (self)
	return self.overcharge_limit / self.max_value
end
mod:hook_origin(OverchargeBarUI, "_update_overcharge", function (self, player, dt)
	if not player then
		return
	end

	local player_unit = player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
	local equipment = inventory_extension:equipment()

	if not equipment then
		return
	end

	local inventory_slots = InventorySettings.slots
	local slot_data = equipment.slots.slot_ranged

	if slot_data then
		local item_data = slot_data.item_data
		local item_name = item_data.name
		local overcharge_fraction, min_threshold_fraction, mid_threshold_fraction, max_threshold_fraction, anim_blend_overcharge = get_overcharge_amount(slot_data.left_unit_1p, slot_data.right_unit_1p)
		local has_overcharge = overcharge_fraction and overcharge_fraction > 0

		if has_overcharge then
			if not self.wielded_item_name or self.wielded_item_name ~= item_name or mod.reset_bar then
				self.wielded_item_name = item_name
				self:setup_charge_bar(min_threshold_fraction or 1, max_threshold_fraction, mid_threshold_fraction)
			end

			if mod.reset_overcharge_bar then
				self:setup_charge_bar(min_threshold_fraction or 1, max_threshold_fraction, mid_threshold_fraction)
				mod.reset_overcharge_bar = false
			end
			self:set_charge_bar_fraction(overcharge_fraction, min_threshold_fraction, anim_blend_overcharge)

			return true
		end
	end
end)
mod:hook_origin(OverchargeBarUI, "setup_charge_bar", function (self, threshold_fraction, threshold_critical_fraction, threshold_med_fraction)
	local widget = self.charge_bar
	local widget_style = widget.style
	local marker_fraction = threshold_fraction * 0.82
	local r = 265
	local x = r * math.sin(marker_fraction)
	local y = r * -math.cos(marker_fraction)
	widget_style.black_divider_left.offset[1] = -x
	widget_style.black_divider_left.offset[2] = y
	widget_style.black_divider_right.offset[1] = x
	widget_style.black_divider_right.offset[2] = y
	local one_side_max_angle = 45
	local current_angle = threshold_fraction * one_side_max_angle
	local radians = math.degrees_to_radians(current_angle)
	widget_style.black_divider_right.angle = -radians
	widget_style.black_divider_left.angle = radians

	if mod:get("overcharge_bar") then
		local marker_fraction_high = threshold_critical_fraction * 0.82
		local x = r * math.sin(marker_fraction_high)
		local y = r * -math.cos(marker_fraction_high)
		widget_style.black_divider_left_high.offset[1] = -x
		widget_style.black_divider_left_high.offset[2] = y
		widget_style.black_divider_right_high.offset[1] = x
		widget_style.black_divider_right_high.offset[2] = y
		local current_angle = threshold_critical_fraction * one_side_max_angle
		local radians = math.degrees_to_radians(current_angle)
		widget_style.black_divider_right_high.angle = -radians
		widget_style.black_divider_left_high.angle = radians
	else
		widget_style.black_divider_left_high.offset[1] = 0
		widget_style.black_divider_left_high.offset[2] = 0
		widget_style.black_divider_right_high.offset[1] = 0
		widget_style.black_divider_right_high.offset[2] = 0
		widget_style.black_divider_right_high.angle = 0
		widget_style.black_divider_left_high.angle = 0
	end
end)

-- Auto blocking on revive
InteractionDefinitions.revive.config.activate_block = mod:get("auto_blocking")
InteractionDefinitions.pull_up.config.activate_block = mod:get("auto_blocking") 
InteractionDefinitions.release_from_hook.config.activate_block = mod:get("auto_blocking") 
InteractionDefinitions.assisted_respawn.config.activate_block = mod:get("auto_blocking") 
mod:hook_safe(PlayerCharacterStateInteracting, "on_enter", function (self, unit, input, dt, context, t, previous_state, params)
	self.deactivate_block_on_exit = false

	if params.activate_block then
		self.activate_block = params.activate_block
		local status_extension = self.status_extension
		self.deactivate_block_on_exit = not status_extension:is_blocking()

		if Managers.state.network:game() then
			local game_object_id = Managers.state.unit_storage:go_id(unit)

			if self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", game_object_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", game_object_id, true)
			end
		end

		status_extension:set_blocking(true)
	end
end)
mod:hook_safe(PlayerCharacterStateInteracting, "on_exit", function (self, unit, input, dt, context, t, next_state)
    local status_extension = self.status_extension

	if self.deactivate_block_on_exit and mod:get("auto_blocking") then
		if Managers.state.network:game() then
			local game_object_id = Managers.state.unit_storage:go_id(unit)

			if self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", game_object_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", game_object_id, false)
			end
		end 

		status_extension:set_blocking(false)
	end
end)
mod:hook(PlayerCharacterStateFalling, "update", function (func, self, unit, input, dt, context, t)
    local velocity = self.locomotion_extension:current_velocity()
    local self_pos = POSITION_LOOKUP[unit]
    local world = self.world
    local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end
	if CharacterStateHelper.is_overcharge_exploding(status_extension) then
		return func(self, unit, input, dt, context, t)
	end
	if CharacterStateHelper.is_pushed(status_extension) then
		return func(self, unit, input, dt, context, t)
	end
	if CharacterStateHelper.is_block_broken(status_extension) then
		return func(self, unit, input, dt, context, t)
	end
	if not csm.state_next and CharacterStateHelper.is_colliding_down(unit) then
		return func(self, unit, input, dt, context, t)
	end

	local colliding_with_ladder, ladder_unit = CharacterStateHelper.is_colliding_with_gameplay_collision_box(world, unit, "filter_ladder_collision")
	local recently_left_ladder = CharacterStateHelper.recently_left_ladder(status_extension, t)

	if colliding_with_ladder and not recently_left_ladder and not self.ladder_shaking then
		local top_node = Unit.node(ladder_unit, "c_platform")
		local ladder_rot = Unit.local_rotation(ladder_unit, 0)
		local ladder_plane_inv_normal = Quaternion.forward(ladder_rot)
		local ladder_offset = Unit.local_position(ladder_unit, 0) - self_pos
		local distance = Vector3.dot(ladder_plane_inv_normal, ladder_offset)
		local epsilon = 0.02

		if self_pos.z < Vector3.z(Unit.world_position(ladder_unit, top_node)) and distance > 0 and distance < 0.7 + epsilon then
			return func(self, unit, input, dt, context, t)
		end
	end

	if CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		return func(self, unit, input, dt, context, t)
	end
	local interactor_extension = self.interactor_extension

	if CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local config = interactor_extension:interaction_config()

		interactor_extension:start_interaction("interacting")

		if not config.allow_movement then
			local params = self.temp_params
            params.swap_to_3p = config.swap_to_3p
            params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
	end

	if CharacterStateHelper.is_interacting(interactor_extension) then
		local config = interactor_extension:interaction_config()

		if not config.allow_movement then
			local params = self.temp_params
            params.swap_to_3p = config.swap_to_3p
            params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
    end
    return func(self, unit, input, dt, context, t)
end)
mod:hook(PlayerCharacterStateJumping, "update", function (func, self, unit, input, dt, context, t)
	local csm = self.csm
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local input_extension = self.input_extension
	local status_extension = self.status_extension

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_overcharge_exploding(status_extension) then
        return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_pushed(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_block_broken(status_extension) then
        return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_colliding_down(unit) and Mover.flying_frames(Unit.mover(unit)) == 0 then
		return func(self, unit, input, dt, context, t)
	end

	if not csm.state_next and not self.locomotion_extension:is_colliding_down() then
		return func(self, unit, input, dt, context, t)
    end
    
    local interactor_extension = self.interactor_extension

	if CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local config = interactor_extension:interaction_config()

		interactor_extension:start_interaction("interacting")

		if not config.allow_movement then
			local params = self.temp_params
            params.swap_to_3p = config.swap_to_3p
            params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
	end

	if CharacterStateHelper.is_interacting(interactor_extension) then
		local config = interactor_extension:interaction_config()

		if not config.allow_movement then
			local params = self.temp_params
            params.swap_to_3p = config.swap_to_3p
            params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
    end
    return func(self, unit, input, dt, context, t)
end)
mod:hook(PlayerCharacterStateStanding, "update", function (func, self, unit, input, dt, context, t)
	local csm = self.csm
	local world = self.world
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local CharacterStateHelper = CharacterStateHelper

	ScriptUnit.extension(unit, "whereabouts_system"):set_is_onground()

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_waiting_for_assisted_respawn(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_using_transport(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_overcharge_exploding(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_pushed(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_block_broken(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	local start_dodge, dodge_direction = CharacterStateHelper.check_to_start_dodge(unit, input_extension, status_extension, t)

	if start_dodge then
		return func(self, unit, input, dt, context, t)
	end

	if self.locomotion_extension:is_animation_driven() then
		return func(self, unit, input, dt, context, t)
	end

	local interactor_extension = self.interactor_extension

	if CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local config = interactor_extension:interaction_config()

		interactor_extension:start_interaction("interacting")

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block
			csm:change_state("interacting", params)
		end

		return
	end

	if CharacterStateHelper.is_interacting(interactor_extension) then
		local config = interactor_extension:interaction_config()
		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block
			csm:change_state("interacting", params)
		end

		return
	end
	return func(self, unit, input, dt, context, t)
end)
mod:hook(PlayerCharacterStateUsingTransport, "update",  function (func, self, unit, input, dt, context, t)
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local inventory_extension = self.inventory_extension
	local first_person_extension = self.first_person_extension

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	local interactor_extension = self.interactor_extension

	if CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local config = interactor_extension:interaction_config()

		interactor_extension:start_interaction("interacting")

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
	end

	if CharacterStateHelper.is_interacting(interactor_extension) then
		local config = interactor_extension:interaction_config()

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
    end

    return func(self, unit, input, dt, context, t)
end)
mod:hook(PlayerCharacterStateWalking, "update", function (func, self, unit, input, dt, context, t)
	local csm = self.csm
	local world = self.world
	local unit = self.unit
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension

	ScriptUnit.extension(unit, "whereabouts_system"):set_is_onground()

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_overcharge_exploding(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_using_transport(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_pushed(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if CharacterStateHelper.is_block_broken(status_extension) then
		return func(self, unit, input, dt, context, t)
	end

	if self.locomotion_extension:is_animation_driven() then
		return func(self, unit, input, dt, context, t)
	end

	CharacterStateHelper.update_dodge_lock(unit, self.input_extension, self.status_extension)

	local start_dodge, dodge_direction = CharacterStateHelper.check_to_start_dodge(unit, input_extension, status_extension, t)

	if start_dodge then
		return func(self, unit, input, dt, context, t)
	end

	local gamepad_active = Managers.input:is_device_active("gamepad")

	if not csm.state_next and input_extension:get("jump") and not status_extension:is_crouching() and self.locomotion_extension:jump_allowed() then
		local movement_input = CharacterStateHelper.get_movement_input(input_extension)

		if (not input_extension.dodge_on_jump_key and not gamepad_active) or status_extension:can_override_dodge_with_jump(t) or Vector3.y(movement_input) >= 0 or Vector3.length(movement_input) <= input_extension.minimum_dodge_input then
			return func(self, unit, input, dt, context, t)
		end
	end

	local is_moving = CharacterStateHelper.is_moving(input_extension)

	if not self.csm.state_next and not is_moving and self.movement_speed == 0 then
		return func(self, unit, input, dt, context, t)
	end

	if not self.csm.state_next and not self.locomotion_extension:is_colliding_down() then
		return func(self, unit, input, dt, context, t)
	end

	local colliding_with_ladder, ladder_unit = CharacterStateHelper.is_colliding_with_gameplay_collision_box(self.world, unit, "filter_ladder_collision")
	local looking_up = CharacterStateHelper.looking_up(first_person_extension, movement_settings_table.ladder.looking_up_threshold)
	local recently_left_ladder = CharacterStateHelper.recently_left_ladder(status_extension, t)
	local above_align_cube = false

	if colliding_with_ladder then
		local ladder_rot = Unit.local_rotation(ladder_unit, 0)
		local ladder_plane_inv_normal = Quaternion.forward(ladder_rot)
		local ladder_offset = Unit.local_position(ladder_unit, 0) - POSITION_LOOKUP[unit]
		local distance = Vector3.dot(ladder_plane_inv_normal, ladder_offset)
		local facing_correctly = false
		local close_enough = false
		local ladder_forward = Quaternion.forward(Unit.local_rotation(ladder_unit, 0))
		local facing = Quaternion.forward(first_person_extension:current_rotation())
		local facing_ladder = Vector3.dot(facing, ladder_forward) < 0
		local movement_in_ladder_direction = Vector3.dot(self.locomotion_extension.velocity_current:unbox(), ladder_forward)
		local top_node = Unit.node(ladder_unit, "c_platform")

		if Vector3.z(Unit.world_position(ladder_unit, top_node)) < POSITION_LOOKUP[unit].z then
			local player = Managers.player:owner(unit)
			local is_bot = player and player.bot_player
			local threshold = (is_bot and movement_settings_table.ladder.bot_looking_down_threshold) or movement_settings_table.ladder.looking_down_threshold
			local looking_down = not looking_up

			if looking_down and facing_ladder and movement_in_ladder_direction < 0 then
				close_enough = distance > 0.5
				facing_correctly = true
			elseif looking_down and distance > 0 and not facing_ladder and movement_in_ladder_direction > 0.5 then
				close_enough = distance > 0.25
				facing_correctly = true
			end

			above_align_cube = true
		else
			local epsilon = 0.02
			close_enough = distance < 0.7 + epsilon and distance > 0
			facing_correctly = looking_up and not facing_ladder and movement_in_ladder_direction > 0
		end

		if facing_correctly and not recently_left_ladder and close_enough then
			local params = self.temp_params
			params.ladder_unit = ladder_unit

			if above_align_cube then
				return func(self, unit, input, dt, context, t)
			else
				return func(self, unit, input, dt, context, t)
			end
		end
	end


	local interactor_extension = self.interactor_extension

	if CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local config = interactor_extension:interaction_config()

		interactor_extension:start_interaction("interacting")

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
    end
    
    if CharacterStateHelper.is_interacting(interactor_extension) then
		local config = interactor_extension:interaction_config()

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
            params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
	end
    return func(self, unit, input, dt, context, t)
end)

-- Pinging
OutlineSettings.colors.ally.outline_multiplier = mod:get("ally")
OutlineSettings.colors.knocked_down.outline_multiplier = mod:get("knocked_down")
OutlineSettings.colors.interactable.outline_multiplier = mod:get("interactable")
OutlineSettings.colors.player_attention.outline_multiplier = mod:get("player_attention")
--[[
mod:hook_origin(OutlineSystem, "on_add_extension", function (self, world, unit, extension_name)
	local extension = {}

	if extension_name == "PlayerOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.ally
		extension.method = "never"
		extension.flag = "outline_unit"
		extension.apply_method = "unit_and_childs"
	elseif extension_name == "PlayerHuskOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.ally
		extension.distance = OutlineSettings.ranges.player_husk
		extension.method = "outside_distance_or_not_visible"
		extension.last_set_method = extension.method
		extension.flag = "outline_unit"
		extension.apply_method = "unit_and_childs"

		extension.set_method_player_setting = function (method)
			if extension.override_method then
				extension.last_set_method = method
			else
				extension.method = method
				extension.last_set_method = method
			end
		end

		extension.update_override_method_player_setting = function ()
			local override_method = nil
			local player_outlines = Application.user_setting("player_outlines")

			if player_outlines == "off" then
				override_method = "never"
			elseif player_outlines == "always_on" then
				override_method = "always"
			end

			extension.override_method = override_method

			if override_method == nil then
				extension.method = extension.last_set_method
			else
				extension.method = override_method
			end
		end

		extension.update_override_method_player_setting()
	elseif extension_name == "PickupOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.pickup
		extension.method = "within_distance_and_not_in_dark"
		extension.pinged_method = "not_in_dark"
		extension.flag = "outline_unit_z"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "AIOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.player_husk
		extension.method = "never"
		extension.pinged_method = "not_in_dark"
		extension.flag = "outline_unit"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "DoorOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.doors
		extension.method = "within_distance_and_not_in_dark"
		extension.pinged_method = "not_in_dark"
		extension.flag = "outline_unit_z"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "ObjectiveOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.objective
		extension.method = "always"
		extension.pinged_method = "always"
		extension.flag = "outline_unit"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "ElevatorOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.elevators
		extension.method = "within_distance"
		extension.pinged_method = "not_in_dark"
		extension.flag = "outline_unit_z"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "ConditionalInteractOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.doors
		extension.method = "conditional_within_distance"
		extension.flag = "outline_unit_z"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "ConditionalPickupOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.interactable
		extension.distance = OutlineSettings.ranges.pickup
		extension.method = "conditional_within_distance"
		extension.flag = "outline_unit_z"
		extension.apply_method = "unit"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.interactable

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	elseif extension_name == "EnemyOutlineExtension" then
		extension.outline_color = OutlineSettings.colors.knocked_down
		extension.method = "never"
		extension.pinged_method = "not_in_dark"
		extension.flag = "outline_unit"
		extension.apply_method = "unit_and_childs"

		extension.update_override_outline_color = function ()
			local current_color = extension.outline_color
			local new_colour = OutlineSettings.colors.knocked_down

			if current_color ~= new_colour then
				current_color = new_colour
			end	
			extension.reapply = true
		end

		extension.update_override_outline_color()
	end

	extension.set_outline_color = function (color)
		extension.outline_color = OutlineSettings.colors[color]
		extension.new_color = true
	end

	extension.reapply_outline = function ()
		extension.reapply = true
	end

	extension.set_method = function (method)
		extension.method = method
	end

	extension.set_pinged = function (pinged)
		if pinged then
			if not extension.pinged then
				extension.previous_flag = extension.flag
			end

			local c = extension.outline_color.channel
			local channel = Color(c[1], c[2], c[3], c[4])

			self:outline_unit(unit, extension.previous_flag, channel, false, extension.apply_method, false)

			extension.flag = "outline_unit"
			local c = OutlineSettings.colors.player_attention.channel
			local channel = Color(c[1], c[2], c[3], c[4])

			self:outline_unit(unit, extension.flag, channel, true, extension.apply_method, false)

			extension.outlined = true
		else
			local c = OutlineSettings.colors.player_attention.channel
			local channel = Color(c[1], c[2], c[3], c[4])

			self:outline_unit(unit, extension.flag, channel, false, extension.apply_method, false)

			if extension.previous_flag then
				extension.flag = extension.previous_flag
			else
				error("ChestInfo mod caused outline crash, try updating the mod.")
			end

			extension.reapply = true
		end

		extension.pinged = pinged
	end

	extension.outlined = false
	extension.new_color = false

	ScriptUnit.set_extension(unit, "outline_system", extension, {})

	self.unit_extension_data[unit] = extension
	self.units[#self.units + 1] = unit

	return extension
end)

-- Hide Player Level
--[[mod:hook(UnitFrameUI, "draw", function (func, self, dt)
	if not self._is_visible then
		return
	end

	if not self._dirty then
		return
	end

	if mod:get("hide_level") then
		self._widgets.portait_static.style.player_level = ""
	end

	func(self, dt)
end)--]]

-- No mission objective
mod:hook(MissionObjectiveUI, "draw", function(func, self, dt)
	if mod:get("no_mission_objective") then
		return
	end

	return func(self, dt)
end)


--- Change size and transparency of floating objective icon.
mod:hook(TutorialUI, "update_objective_tooltip_widget", function(func, self, widget_holder, player_unit, dt)
	func(self, widget_holder, player_unit, dt)

	if mod:get("unobtrusive_floating_objective") then
		local widget = widget_holder.widget
		local icon_style = widget.style.texture_id
		icon_style.size = { 32, 32 }
		icon_style.offset = { 16, 16 }
		icon_style.color[1] = 75

		if widget.style.text.text_color[1] ~= 0 then
			widget.style.text.text_color[1] = 100
		end
	end
end)

--- Hide or make less obtrusive the floating mission marker.
--- Used for "Set Free" on respawned player.
mod:hook(TutorialUI, "update_mission_tooltip", function(func, self, ...)
	func(self, ...)

	if mod:get("unobtrusive_mission_tooltip") then
		mod:pcall(function()
			local widget = self.tooltip_mission_widget
			widget.style.texture_id.size = nil
			widget.style.texture_id.offset = { 0, 0 }
			if widget.style.text.text_color[1] ~= 0 then
				widget.style.texture_id.color[1] = 100
				widget.style.text.text_color[1] = 100
			else
				widget.style.texture_id.size = { 32, 32 }
				widget.style.texture_id.offset = { 16+16, 16 }
			end
		end)
	end
end)

-- Lohner Speaking
--- Disable level intro audio.
mod:hook(StateLoading, "_trigger_sound_events", function(func, self, level_key)
	if mod:get("loading_screen_audio") then
		return
	end

	return func(self, level_key)
end)

--- Disable loading screen tips.
mod:hook(LoadingView, "setup_tip_text", function(func, self, act_progression_index, game_mode)
	if mod:get("loading_screen_tips") then
		if self.widgets.tip_title_widget then
			self.widgets.tip_title_widget = nil
		end
		return
	end

	return func(self, act_progression_index, game_mode)
end)

--- Hide loading screen subtitles.
mod:hook(LoadingView, "create_ui_elements", function(func, ...)
	local definitions = local_require("scripts/ui/views/loading_view_definitions")

	if not mod.original_num_subtitle_rows then
		mod.original_num_subtitle_rows = definitions.NUM_SUBTITLE_ROWS
	end

	if mod:get("loading_screen_audio") then
		definitions.NUM_SUBTITLE_ROWS = 0
	else
		definitions.NUM_SUBTITLE_ROWS = mod.original_num_subtitle_rows
	end

	return func(...)
end)

-- Enable Client Map Interaction
mod:hook_safe(IngameUI, "init", function (self, ingame_ui_context)
	if self.is_in_inn then
		self.views.map_view:set_map_interaction_state(mod:get("client_start_game"))
	end
end)

mod:hook_safe(IngameUI, "update", function (self, dt, t, disable_ingame_ui, end_of_level_ui)
	if self.is_in_inn then
		self.views.map_view:set_map_interaction_state(mod:get("client_start_game"))
	end
end)

mod:network_register("client_find_game_request", function(sender, level_key, difficulty, private_game, random_level, game_mode, area, t, level_filter, user_name)
	if Managers.player.is_server then
		Managers.matchmaking:find_game(level_key, difficulty, private_game, random_level, game_mode, area, t, level_filter)
		mod:chat_broadcast("Game Requested By: " .. user_name)
	end
end)

mod.game_request_amount = 0
mod:hook(MatchmakingManager, "find_game", function (func, self, level_key, difficulty, private_game, random_level, game_mode, area, t, level_filter)
	if not self.is_server then
		local server_id = Managers.state.network._game_session_host
		if server_id  then --and mod.game_request_delay == nil
			local user_name = Steam.user_name()
			mod:network_send("client_find_game_request", server_id, level_key, difficulty, private_game, random_level, game_mode, area, t, level_filter, user_name)
	 		mod.game_request_amount = mod.game_request_amount + 1
		elseif mod.game_request_delay then
			mod:echo("You have made to many recent game requests.")
		else
			mod:echo("Unable to make client game request.")
		end
	else
		func(self, level_key, difficulty, private_game, random_level, game_mode, area, t, level_filter)
	end
end)

mod:hook_safe(MapView, "on_play_pressed", function (self, t)
	self:exit(true)
end)


mod.are_all_peers_ingame = false
mod:network_register("are_all_peers_ingame_cb", function(sender, result)
	mod.are_all_peers_ingame = result
end)
mod:network_register("are_all_peers_ingame", function(sender)
	local result = Managers.state.spawn._network_server:are_all_peers_ingame()
	mod:network_send("are_all_peers_ingame_cb", sender, result)
end)
mod:hook(MapView, "init", function(func, ...)
	local server_id = Managers.state.network._game_session_host
	mod:network_send("are_all_peers_ingame", server_id)
	func(...)
end)

local start_game_disable_tooltips = {
	players_joining = "map_confirm_button_disabled_tooltip_players_joining",
	wrong_level = "map_confirm_button_disabled_tooltip_level",
	difficulty = "map_confirm_button_disabled_tooltip"
}
mod:hook(MapView, "_update_play_button_description", function (func, self)
	if not self.is_server then
		local players_joined = mod.are_all_peers_ingame
		if not players_joined then
			local server_id = Managers.state.network._game_session_host
			mod:network_send("are_all_peers_ingame", server_id)
		end
		local is_difficulty_unlocked = self.difficulty_unlocked
		local is_level_selected = self.selected_level_index ~= nil
		local is_playable_level = self.playable_level
		local tooltip_text = nil

		if not players_joined then
			tooltip_text = start_game_disable_tooltips.players_joining
		elseif not is_playable_level or not is_level_selected then
			tooltip_text = start_game_disable_tooltips.wrong_level
		elseif not is_difficulty_unlocked then
			tooltip_text = start_game_disable_tooltips.difficulty
		end

		local can_play = players_joined and is_playable_level and is_difficulty_unlocked and is_level_selected
		self.confirm_button_widget.content.button_hotspot.disabled = not can_play

		if tooltip_text then
			self.confirm_button_disabled_tooltip_widget.content.tooltip_text = tooltip_text
		end
	else
		func(self)
	end
end)

-- Hit Markers
local CROSSHAIR_STYLE_FUNC_LOOKUP = {
	default = "draw_default_style_crosshair",
	circle = "draw_circle_style_crosshair",
	dot = "draw_dot_style_crosshair"
}
local CROSSHAIR_ENABLED_STYLES_LOOKUP = {
	default = true,
	circle = true,
	dot = true
}
mod:hook_safe(PlayerHud, "init", function (self, extension_init_context, unit, extension_init_data)
	self.hit_marker_data = {}
end)
local crosshair_ui_definitions = require("scripts/ui/views/crosshair_ui_definitions")
crosshair_ui_definitions.widget_definitions.crosshair_hit_armored_no_damage = {
		scenegraph_id = "crosshair_hit_armored",
		element = {
			passes = {
				{
					pass_type = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = "rwaon_enemy_defense_indication_icon"
		},
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				0,
				255,
				255,
				255
			},
			texture_size = {
				55,
				50
			}
		}
}
crosshair_ui_definitions.scenegraph_definition.crosshair_hit_armored = {
	vertical_alignment = "center",
	parent = "crosshair_root",
	horizontal_alignment = "center",
	size = {
		0,
		0
	},
	position = {
		0,
		-30,
		1
	}
}
mod:hook_safe(CrosshairUI,"create_ui_elements", function (self)
	self._hit_armored_marker = UIWidget.init(crosshair_ui_definitions.widget_definitions.crosshair_hit_armored_no_damage)
end)
mod:hook_origin(CrosshairUI, "update_hit_markers", function (self, dt)
	Profiler.start("update_hit_markers")

	local hit_markers = self.hit_markers
	local hit_markers_n = self.hit_markers_n
	local hit_marker_animations = self.hit_marker_animations
	local player_unit = self.local_player.player_unit
	local hud_extension = ScriptUnit.extension(player_unit, "hud_system")
	local hit_marker_data = hud_extension.hit_marker_data

	if hit_marker_data.hit_enemy then
		hit_marker_data.hit_enemy = nil

		for i = 1, hit_markers_n, 1 do
			local hit_marker = hit_markers[i]
			hit_marker_animations[i] = UIAnimation.init(UIAnimation.function_by_time, hit_marker.style.rotating_texture.color, 1, 255, 0, UISettings.crosshair.hit_marker_fade, math.easeInCubic)
			local additional_hit_icon = self:configure_hit_marker_color_and_size(hit_marker, hit_marker_data)

			if i == hit_markers_n and additional_hit_icon then
				hit_marker_animations[5] = UIAnimation.init(UIAnimation.function_by_time, additional_hit_icon.style.color, 1, 255, 0, UISettings.crosshair.hit_marker_fade, math.easeInCubic)
				self.hit_marker_armored = additional_hit_icon
			end
		end
	end

	if hit_marker_animations[1] then
		for i = 1, hit_markers_n, 1 do
			local animation = hit_marker_animations[i]

			UIAnimation.update(animation, dt)
		end

		if hit_marker_animations[5] then
			local animation = hit_marker_animations[5]
	
			UIAnimation.update(animation, dt)
		end

		if UIAnimation.completed(hit_marker_animations[1]) then
			for i = 1, hit_markers_n, 1 do
				hit_marker_animations[i] = nil
			end

			hit_marker_animations[5] = nil
		end
	end

	Profiler.stop("update_hit_markers")
end)
CrosshairUI.configure_hit_marker_color_and_size = function (self, hit_marker, hit_marker_data)
	local damage_amount = hit_marker_data.damage_amount
	local damage_type = hit_marker_data.damage_type
	local hit_zone = hit_marker_data.hit_zone
	local has_armor = hit_marker_data.has_armor
	local hit_player = hit_marker_data.hit_player
	local added_dot = hit_marker_data.added_dot
	local is_armored = false
	local friendly_fire = false
	local additional_hit_icon = nil

	if damage_amount <= 0 and has_armor and not added_dot then
		is_armored = true
	elseif hit_player then
		friendly_fire = true
	end

	if is_armored then
		additional_hit_icon = self._hit_armored_marker
	end

	return additional_hit_icon
end
mod:hook_origin(CrosshairUI, "draw", function (self, dt)
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt)

	local crosshair_style = self.crosshair_style

	if CROSSHAIR_ENABLED_STYLES_LOOKUP[crosshair_style] then
		local draw_func_name = CROSSHAIR_STYLE_FUNC_LOOKUP[crosshair_style]

		self[draw_func_name](self, ui_renderer)
	end

	Profiler.start("draw widgets")

	local hit_markers = self.hit_markers
	local hit_markers_n = self.hit_markers_n

	for i = 1, hit_markers_n, 1 do
		local hit_marker = hit_markers[i]

		UIRenderer.draw_widget(ui_renderer, hit_marker)
	end

	if self.hit_marker_armored then
		UIRenderer.draw_widget(ui_renderer, self.hit_marker_armored)
	end

	Profiler.stop("draw widgets")
	UIRenderer.end_pass(ui_renderer)
end)

-- added_dot implementation
mod:hook_origin(DamageUtils, "server_apply_hit", function (t, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, hit_ragdoll_actor, damage_source, attack_damage_value_type, backstab_multiplier, hawkeye_multiplier)
	local added_dot = nil
	if attack_template.dot_type then
		local dot_func = Dots[attack_template.dot_type]
		added_dot = true
		dot_func(attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value_type, damage_source)
	end

	if attack_template.attack_type then
		local attack_type = attack_template.attack_type
		local attack = Attacks[attack_type]
		local damage_amount = attack.get_damage_amount(damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value_type, hit_ragdoll_actor, backstab_multiplier, hawkeye_multiplier)

		attack.do_damage(damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value_type, hit_ragdoll_actor, damage_amount, added_dot)
	end

	if attack_template.stagger_type then
		local stagger_func = Staggers[attack_template.stagger_type]

		stagger_func(attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, t)
	end
end)
local victim_units = {}
mod:hook_origin(DamageUtils, "add_damage_network", function (attacked_unit, attacker_unit, original_damage_amount, hit_zone_name, damage_type, damage_direction, damage_source, hit_ragdoll_actor, damaging_unit, added_dot)
	local network_manager = Managers.state.network

	if not network_manager:game() then
		return
	end

	local player_manager = Managers.player
	local attacker_player = player_manager:owner(attacker_unit)
	local is_character, _ = DamageUtils.is_character(attacked_unit)
	local unit_id, is_level_unit = network_manager:game_object_or_level_id(attacked_unit)

	if attacker_player and attacker_player.bot_player and not is_character and not is_level_unit then
		return
	end

	if player_manager.is_server or LEVEL_EDITOR_TEST then
		table.clear(victim_units)

		local networkified_value = DamageUtils.networkify_damage(original_damage_amount)
		original_damage_amount = DamageUtils.apply_buffs_to_damage(networkified_value, attacked_unit, attacker_unit, damage_source, victim_units, damage_type)
	end

	local damage_amount = DamageUtils.networkify_damage(original_damage_amount)
	local attacker_unit_id, attacker_is_level_unit = network_manager:game_object_or_level_id(attacker_unit)
	local hit_zone_id = NetworkLookup.hit_zones[hit_zone_name]
	local damage_type_id = NetworkLookup.damage_types[damage_type]
	local damage_source_id = NetworkLookup.damage_sources[damage_source or "n/a"]

	if player_manager.is_server or LEVEL_EDITOR_TEST then
		local num_victim_units = #victim_units

		for i = 1, num_victim_units, 1 do
			local victim_unit = victim_units[i]
			unit_id, is_level_unit = network_manager:game_object_or_level_id(victim_unit)
			damage_type = (victim_unit == attacked_unit and damage_type) or "buff"
			damage_type_id = NetworkLookup.damage_types[damage_type]
			local damage_extension = ScriptUnit.extension(victim_unit, "damage_system")

			damage_extension:add_damage(attacker_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source, hit_ragdoll_actor, damaging_unit)

			if ScriptUnit.has_extension(attacker_unit, "hud_system") then
				local health_extension = ScriptUnit.extension(victim_unit, "health_system")
				local damage_source = NetworkLookup.damage_sources[damage_source_id]
				local should_indicate_hit = health_extension:is_alive() and attacker_unit ~= victim_unit and damage_source ~= "wounded_degen"

				if should_indicate_hit then
					local breed = Unit.get_data(victim_unit, "breed")
					local target_unit_armor = (breed and breed.armor_category) or 4
					local is_player = DamageUtils.is_player_unit(victim_unit)
					local hud_extension = ScriptUnit.extension(attacker_unit, "hud_system")
					local hit_marker_data = hud_extension.hit_marker_data

					hit_marker_data.hit_enemy = true
					hit_marker_data.hit_player = is_player
					hit_marker_data.damage_amount = damage_amount
					hit_marker_data.damage_type = damage_type
					hit_marker_data.hit_zone = hit_zone_name
					hit_marker_data.has_armor = target_unit_armor == 2
					hit_marker_data.added_dot = added_dot
				end
			end

			local owner = player_manager:owner(victim_unit)
			local breed = Unit.get_data(attacker_unit, "breed")

			if breed and owner then
				local has_inventory_extension = ScriptUnit.has_extension(attacker_unit, "ai_inventory_system")

				if has_inventory_extension then
					local inventory_extension = ScriptUnit.extension(attacker_unit, "ai_inventory_system")

					inventory_extension:play_hit_sound(victim_unit, damage_type)
				end
			end

			if not ScriptUnit.extension(attacked_unit, "health_system"):is_alive() then
				Managers.state.unit_spawner:prioritize_death_watch_unit(attacked_unit, Managers.time:time("game"))
			end

			local hit_ragdoll_actor_id = NetworkLookup.hit_ragdoll_actors[hit_ragdoll_actor or "n/a"]

			if not LEVEL_EDITOR_TEST then
				if is_level_unit then
					network_manager.network_transmit:send_rpc_clients("rpc_level_object_damage", unit_id, damage_amount, damage_direction, damage_source_id)
				else
					network_manager.network_transmit:send_rpc_clients("rpc_add_damage", unit_id, attacker_unit_id, attacker_is_level_unit, damage_amount, hit_zone_id, damage_type_id, damage_direction, damage_source_id, hit_ragdoll_actor_id)
				end
			end
		end
	elseif is_level_unit then
		network_manager.network_transmit:send_rpc_server("rpc_level_object_damage", unit_id, damage_amount, damage_direction, damage_source_id)
	else
		network_manager.network_transmit:send_rpc_server("rpc_add_damage_network", unit_id, attacker_unit_id, attacker_is_level_unit, damage_amount, hit_zone_id, damage_type_id, damage_direction, damage_source_id)
	end
end)
mod:hook_origin(DamageSystem, "rpc_add_damage", function (self, sender, victim_unit_go_id, attacker_unit_go_id, attacker_is_level_unit, damage_amount, hit_zone_id, damage_type_id, damage_direction, damage_source_id, hit_ragdoll_actor_id, added_dot)
	local victim_unit = self.unit_storage:unit(victim_unit_go_id)
	local attacker_unit = nil

	if attacker_is_level_unit then
		attacker_unit = LevelHelper:unit_by_index(self.world, attacker_unit_go_id)
	else
		attacker_unit = self.unit_storage:unit(attacker_unit_go_id)
	end

	local hit_zone_name = NetworkLookup.hit_zones[hit_zone_id]
	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local damage_source = NetworkLookup.damage_sources[damage_source_id]
	local hit_ragdoll_actor = NetworkLookup.hit_ragdoll_actors[hit_ragdoll_actor_id]

	if not Unit.alive(victim_unit) then
		return
	end

	local attacker_unit_alive = Unit.alive(attacker_unit)

	if attacker_unit_alive then
		local attacker_breed = Unit.get_data(attacker_unit, "breed")
		local victim_owner = Managers.player:owner(victim_unit)

		if attacker_breed and victim_owner then
			local has_inventory_extension = ScriptUnit.has_extension(attacker_unit, "ai_inventory_system")

			if has_inventory_extension then
				local inventory_extension = ScriptUnit.extension(attacker_unit, "ai_inventory_system")

				inventory_extension:play_hit_sound(victim_unit, damage_type)
			end
		end

		if ScriptUnit.has_extension(attacker_unit, "hud_system") then
			local health_extension = ScriptUnit.extension(victim_unit, "health_system")
			local damage_source = NetworkLookup.damage_sources[damage_source_id]
			local should_indicate_hit = health_extension:is_alive() and attacker_unit ~= victim_unit and damage_source ~= "wounded_degen"

			if should_indicate_hit then
				local breed = Unit.get_data(victim_unit, "breed")
				local target_unit_armor = (breed and breed.armor_category) or 4
				local is_player = DamageUtils.is_player_unit(victim_unit)
				local hud_extension = ScriptUnit.extension(attacker_unit, "hud_system")
				local hit_marker_data = hud_extension.hit_marker_data

				hit_marker_data.hit_enemy = true
				hit_marker_data.hit_player = is_player
				hit_marker_data.damage_amount = damage_amount
				hit_marker_data.damage_type = damage_type
				hit_marker_data.hit_zone = hit_zone_name
				hit_marker_data.has_armor = target_unit_armor == 2
				hit_marker_data.added_dot = added_dot
			end
		end
	end

	ScriptUnit.extension(victim_unit, "damage_system"):add_damage((attacker_unit_alive and attacker_unit) or victim_unit, damage_amount, hit_zone_name, damage_type, damage_direction, damage_source, hit_ragdoll_actor, added_dot)
end)
Attacks.damage.do_damage = function (damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value, hit_ragdoll_actor, damage_amount, added_dot)
	local damage_type = attack_template.damage_type

	DamageUtils.add_damage_network(hit_unit, attacker_unit, damage_amount, hit_zone_name, damage_type, attack_direction, damage_source, hit_ragdoll_actor, added_dot)
end
Attacks.damage_headshot.do_damage = function (damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value, hit_ragdoll_actor, damage_amount, added_dot)
	local damage_type = attack_template.damage_type

	DamageUtils.add_damage_network(hit_unit, attacker_unit, damage_amount, hit_zone_name, damage_type, attack_direction, damage_source, hit_ragdoll_actor, added_dot)
end
Attacks.hacky_damage_burn.do_damage = function (damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value, hit_ragdoll_actor, damage_amount, added_dot)
	local damage_type = attack_template.damage_type
	local hit_zone = hit_zone_name or "full"

	DamageUtils.add_damage_network(hit_unit, attacker_unit, damage_amount, hit_zone, damage_type, attack_direction, damage_source, nil, added_dot)
end
Attacks.damage_dropoff.do_damage = function (damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value, hit_ragdoll_actor, damage_amount, added_dot)
	local damage_type = attack_template.damage_type

	DamageUtils.add_damage_network(hit_unit, attacker_unit, damage_amount, hit_zone_name, damage_type, attack_direction, damage_source, nil, added_dot)
end
Attacks.grenade.do_damage = function (damage_source, attack_template, attacker_unit, hit_unit, hit_zone_name, attack_direction, attack_damage_value, hit_ragdoll_actor, damage_amount, added_dot)
	local damage_type = attack_template.damage_type

	DamageUtils.add_damage_network(hit_unit, attacker_unit, damage_amount, hit_zone_name, damage_type, attack_direction, damage_source, nil, added_dot)
end