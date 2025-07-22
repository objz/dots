return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },
	opts = {
		servers = {
			lua_ls = {}
		},
	},
	config = function(_, opts)
		local lspconfig = require('lspconfig')
		for server, config in pairs(opts.servers) do
			lspconfig[server].setup(config)
		end
	end,
}
