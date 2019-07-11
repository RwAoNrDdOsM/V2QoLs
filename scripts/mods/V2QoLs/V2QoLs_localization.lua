return {
	mod_description = {
		en = "V2QoLs description",
	},

	-- Commands
	restart_level_command_description = {
		en = "Restart the level."
	},

	-- Options
	px = {
		en = "px"
	},
	seconds = {
		en = " seconds"
	},
	restart_level_hotkey = {
		en = "Restart Level Hotkey"
	},
	restart_level_hotkey_description = {
		en = "Restart the level hotkey."
	},

	client_start_game = {
		en = "Client Map Interaction & Game Starting"
	},
	client_start_game_description = {
		en = "Allow you as a client to interact with the map and start a game"
		.."\nHost need mod to start the game. "
		.."\nMax amount of requests are 3, with a 60 seconds cooldown before you can request again."
	},

	auto_blocking = {
		en = "Automatic Blocking"
	},
	auto_blocking_description = {
		en = "Enables Automatic Blocking when you revive a player, pull up a player or release a player from a hook."
	},
	auto_blocking_delay = {
		en = "Automatic Blocking Delay"
	},
	auto_blocking_delay_description = {
		en = "Keeps you blocking for the delayed amount of time, and unblocks you once the delay is over if you are still blocking."
	},
	auto_blocking_delay_t = {
		en = "Automatic Blocking Delay Time"
	},
	auto_blocking_delay_t_description = {
		en = "Default Value: 0.5"
	},

	outlines = {
		en = "Outlines"
	},
	outlines_description = {
		en = "Outline thickness for allies, items and pings."
		.."\nVT1: Sets the values to the default VT1 values."
		.."\nVT2: Sets the values to the default VT2 values (Thicker than VT1.)"
		.."\nCustom: Lets you customise the outline Values"
		.."\n\nMust reload level to take effect."
	},
	outlines_vt1 = {
		en = "VT1 Default Outlines"
	},
	outlines_vt2 = {
		en = "VT2 Default Outlines"
	},
	outlines_custom = {
		en = "Custom Outlines"
	},
	ally = {
		en = "Ally Outline Thickness"
	},
	ally_description = {
		en = "VT1 Default Value: 2"
		.."\nVT2 Default Value: 7"
	},
	knocked_down = {
		en = "Knocked Down Outline Thickness"
	},
	knocked_down_description = {
		en = "VT1 Default Value: 3"
		.."\nVT2 Default Value: 7"
	},
	interactable = {
		en = "Item Outline Thickness"
	},
	interactable_description = {
		en = "VT1 Default Value: 2"
		.."\nVT2 Default Value: 4"
	},
	player_attention = {
		en = "Ping Outline Thickness"
	},
	player_attention_description = {
		en = "VT1 Default Value: 3"
		.."\nVT2 Default Value: 6"
	},

	loading_screen = {
		en = "Loading Screen"
	},
	loading_screen_audio = {
		en = "Disable Level Intro Audio & Subtitles"
	},
	loading_screen_audio_description = {
		en = "Disable Lohner's level intro spiel."
	},
	loading_screen_tips = {
		en = "Hide Level Intro Tips"
	},
	loading_screen_tips_description = {
		en = "Hide the tips on the map loading screen."
	},

	tooltip_mission = {
		"Markers"
	},
	tooltip_mission = {
		en = "Mission and Objective Markers"
	},
	no_mission_objective = {
		en = "Hide Mission Marker"
	},
	no_mission_objective_description = {
		en = "Hide the mission objective on top of the screen."
	},
	unobtrusive_floating_objective = {
		en = "Unobtrusive Objective Marker"
	},
	unobtrusive_floating_objective_description = {
		en = "Make the floating objective marker smaller and always transparent."
	},
	unobtrusive_mission_tooltip = {
		en = "Unobtrusive Mission Marker"
	},
	unobtrusive_mission_tooltip_description = {
		en = "Make the floating mission marker smaller and always transparent."
			.."\nUsed for revive warning."
	},
	no_tutorial_ui = {
		en = "Hide Objective Marker"
	},
	no_tutorial_ui_description = {
		en = "Disable objective markers like \"Set Free\" for dead players."
	},

	lose_conditions = {
		en = "Lose Conditions"
	},
	lose_conditions_description = {
		en = "Modify Lose Conditions. Host only."
	},
	lose_condition_time = {
		en = "Lost Condition Time"
	},
	lose_condition_time_description = {
		en = "Time before level is failed."
		.."\nVT1 Default Value: 4"
		.."\nVT2 Default Value: 10"
	},
	lose_condition_time_dead = {
		en = "Lost Condition Time when Players Dead"
	},
	lose_condition_time_dead_description = {
		en = "Time before level is failed when all players are dead."
		.."\nVT1 Default Value: 4"
		.."\nVT2 Default Value: 4"
	},

	overcharge_bar = {
		en = "Overcharge Bar",
	},
	overcharge_bar_description = {
		en = "Adds more lines to the Overcharge Bar to signify Medium and High Overcharge."
		.."\n Must reload level to take effect."
	},
	disabled = {
		en = "Disabled"
	},
	overcharge_bar_high = {
		en = "High Line Only"
	},
	overcharge_bar_med = {
		en = "Medium Line Only"
	},
	overcharge_bar_both = {
		en = "Both High & Medium Lines"
	},
}
