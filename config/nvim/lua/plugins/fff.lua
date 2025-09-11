return {
	"dmtrKovalenko/fff.nvim",
	build = "cargo build --release",
	keys = {
		{
			"<leader>ff",
			function()
				require("fff").toggle()
			end,
			desc = "Toggle FFF",
		},
	},
}
