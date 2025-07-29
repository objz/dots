return {
	"folke/which-key.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup({
			preset = "modern",
			icons = {
				breadcrumb = "»",
				separator = "→",
				group = "",
				ellipsis = "…",
				mappings = true,
			},
			win = {
				border = "rounded",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				zindex = 1000,
				wo = {
					winblend = 10,
				},
			},
			layout = {
				height = { min = 4, max = 25 },
				width = { min = 20, max = 50 },
				spacing = 3,
				align = "left",
			},
			keys = {
				scroll_down = "<c-d>",
				scroll_up = "<c-u>",
			},
			sort = { "local", "order", "group", "alphanum", "mod" },
			expand = 0,
			replace = {
				["<space>"] = "SPC",
				["<cr>"] = "RET",
				["<tab>"] = "TAB",
				["<leader>"] = "SPC",
			},
		})
	end,
}
