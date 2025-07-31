return {
	{
		"igorlfs/nvim-dap-view",
		event = "VeryLazy",
		opts  = {
			winbar = {
				show = true,
				sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
				default_section = "scopes",
				windows = {},
				switchbuf = "usetab",
				auto_toggle = true,
			},
		}
	},
}
