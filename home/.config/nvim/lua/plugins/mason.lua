return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"rust_analyzer",
					"lua_ls",
					"bashls",
					"clangd",
					"jdtls",
					"pyright",
					"ts_ls",
				},
				automatic_installation = true,
				automatic_enable = {
					exclude = { "jdtls" },
				},

			})
		end,
	}
}
