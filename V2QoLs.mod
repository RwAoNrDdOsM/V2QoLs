return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`V2QoLs` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("V2QoLs", {
			mod_script       = "scripts/mods/V2QoLs/V2QoLs",
			mod_data         = "scripts/mods/V2QoLs/V2QoLs_data",
			mod_localization = "scripts/mods/V2QoLs/V2QoLs_localization",
		})
	end,
	packages = {
		"resource_packages/V2QoLs/V2QoLs",
	},
}
