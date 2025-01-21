return {
	--- Improved terminal toggle
	"akinsho/toggleterm.nvim",
	version = "v2.*",
	config = function()
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
            float_opts = {
                border = "rounded",
            },
			open_mapping = [[<leader>vt]],
			insert_mappings = false,
			direction = "float",
			close_on_exit = true, -- close the terminal window when the process exits
			shell = "/usr/bin/zsh", -- change the default shell
		})
	end,
}
