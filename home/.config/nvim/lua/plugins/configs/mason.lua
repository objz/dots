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
                        package_uninstalled = "✗"
                    }
                }
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
            })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {
                    "stylua",
                    "rustfmt",
                    "clang-format",
                    "prettier",
                    "black",
                    "isort",
                    "eslint_d",
                },
                automatic_installation = true,
                handlers = {},
            })
        end,
    },
}
