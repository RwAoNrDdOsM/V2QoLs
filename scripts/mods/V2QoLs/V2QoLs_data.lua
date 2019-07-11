local mod = get_mod("V2QoLs")

return {
	name = "V2QoLs",
	description = mod:localize("mod_description"),
	is_togglable = true,
	custom_gui_textures = {
		ui_renderer_injections = {
            {
                "ingame_ui",
                "materials/mods/V2QoLs/rwaon_enemy_defense_indication_icon",
            },
		},
		atlases = {
			{
				"materials/mods/V2QoLs/rwaon_enemy_defense_indication_icon_atlas",
				"rwaon_enemy_defense_indication_icon",
			},
		},
	},
	options = {
		widgets = {
			{
				setting_id = "restart_level_hotkey",
				type = "keybind",
		  		keybind_trigger = "pressed",
		  		keybind_type = "function_call",
		  		function_name = "restart_level",
		  		default_value = {},
			},
			{
				setting_id    = "client_start_game",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "auto_blocking",
				type          = "checkbox",
				default_value = true,
				sub_widgets = {
					{
						setting_id    = "auto_blocking_delay",
						type          = "checkbox",
						default_value = false,
						sub_widgets = {
							{
								setting_id    = "auto_blocking_delay_t",
								type          = "numeric",
								range = {0.1, 3},
								unit_text = "seconds",
								decimals_number = 1,   
								default_value = 0.5,
							}
						}
					},
					
				},
			},
			{
				setting_id    = "outlines",
				type          = "dropdown",
				default_value = "VT2",
				options = {	
					{text = "outlines_vt1",   value = "VT1", show_widgets = {}},				
					{text = "outlines_vt2",   value = "VT2", show_widgets = {}},
					{text = "outlines_custom", value = "Custom", show_widgets = {1,2,3,4}},
				},
				sub_widgets = {
					{
						setting_id    = "ally",
						type          = "numeric",
						range = {1, 20},
						unit_text = "px",
						default_value = 7,
					},
					{
						setting_id    = "knocked_down",
						type          = "numeric",
						range = {1, 20},
						unit_text = "px",
						default_value = 7,
					},
					{
						setting_id    = "interactable",
						type          = "numeric",
						range = {1, 20},
						unit_text = "px",
						default_value = 4,
					},
					{
						setting_id    = "player_attention",
						type          = "numeric",
						range = {1, 20},
						unit_text = "px",
						default_value = 6,
					},
				},
			},
			{
				setting_id    = "loading_screen",
				type          = "group",
				sub_widgets = {
					{
						setting_id    = "loading_screen_audio",
						type          = "checkbox",
						default_value = true,
					},
					{
						setting_id    = "loading_screen_tips",
						type          = "checkbox",
						default_value = true,
					},
				},
			},
			{
				setting_id    = "tooltip_mission",
				type          = "group",
				sub_widgets = {
					{
						setting_id    = "no_mission_objective",
						type          = "checkbox",
						default_value = false,
					},
					{
						setting_id    = "unobtrusive_mission_tooltip",
						type          = "checkbox",
						default_value = false,
					},
					{
						setting_id    = "no_tutorial_ui",
						type          = "checkbox",
						default_value = false,
					},
					{
						setting_id    = "unobtrusive_floating_objective",
						type          = "checkbox",
						default_value = false,
					},
				},
			},
			{
				setting_id    = "lose_conditions",
				type          = "group",
				sub_widgets = {
					{
						setting_id    = "lose_condition_time",
						type          = "numeric",
						range = {1, 20},
						unit_text = "seconds",
						default_value = 4,
					},
					{
						setting_id    = "lose_condition_time_dead",
						type          = "numeric",
						range = {1, 20},
						unit_text = "seconds",
						default_value = 4,
					},
				},
			},
			{
				setting_id    = "overcharge_bar",
				type          = "dropdown",
				default_value = "both",
				options = {	
					{text = "disabled",   value = false, show_widgets = {}},
					{text = "overcharge_bar_high",   value = "high", show_widgets = {}},			
					{text = "overcharge_bar_med",   value = "med", show_widgets = {}},
					{text = "overcharge_bar_both", value = "both", show_widgets = {}},
				},
			},
			--[[{
				setting_id    = "hide_level",
				type          = "checkbox",
				default_value = false,
			},]]
		},
	},
}
