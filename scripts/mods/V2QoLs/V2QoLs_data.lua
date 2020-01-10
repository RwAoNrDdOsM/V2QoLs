local mod = get_mod("V2QoLs")

return {
	name = "VT2QoLs",
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
				setting_id    = "client_start_game",
				type          = "checkbox",
				default_value = true,
			},
			{
				setting_id    = "auto_blocking",
				type          = "checkbox",
				default_value = true,
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
					--[[{
						setting_id    = "no_mission_objective",
						type          = "checkbox",
						default_value = false,
					},--]]
					{
						setting_id    = "unobtrusive_mission_tooltip",
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
				setting_id    = "overcharge_bar",
				type          = "checkbox",
				default_value = false,
			},
			{
				setting_id    = "pickups",
				type          = "checkbox",
				default_value = false,
			},
			--[[{
				setting_id    = "hide_level",
				type          = "checkbox",
				default_value = false,
			},]]
		},
	},
}
