return {
    {
        "simrat39/rust-tools.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        enabled = true,
        ft = { "rust", "toml" },
        config = function()
            local handlers = require("lsp.handlers")
            local rust_tools = require("rust-tools")

            rust_tools.setup({
                tools = {
                    executor = require("rust-tools.executors").termopen,
                    autoSetHints = true,
                    runnables = {
                        use_telescope = true,
                    },
                    reload_workspace_from_cargo_toml = true,
                    on_initialized = function()
                        vim.cmd([[
                  augroup RustLSP
                    autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                    autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                  augroup END
                ]])
                    end,
                    inlay_hints = {
                        auto = false,
                        only_current_line = false,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<- ",
                        other_hints_prefix = "=> ",
                        max_len_align = false,
                        max_len_align_padding = 1,
                        right_align = false,
                        right_align_padding = 7,
                        highlight = "Comment",
                    },
                    hover_actions = {
                        border = {
                            { "╭", "FloatBorder" },
                            { "─", "FloatBorder" },
                            { "╮", "FloatBorder" },
                            { "│", "FloatBorder" },
                            { "╯", "FloatBorder" },
                            { "─", "FloatBorder" },
                            { "╰", "FloatBorder" },
                            { "│", "FloatBorder" },
                        },
                        max_width = nil,
                        max_height = nil,
                        auto_focus = true,
                    },
                    crate_graph = {
                        backend = "x11",
                        output = nil,
                        full = true,
                        enabled_graphviz_backends = {
                            "bmp",
                            "cgimage",
                            "canon",
                            "dot",
                            "gv",
                            "xdot",
                            "xdot1.2",
                            "xdot1.4",
                            "eps",
                            "exr",
                            "fig",
                            "gd",
                            "gd2",
                            "gif",
                            "gtk",
                            "ico",
                            "cmap",
                            "ismap",
                            "imap",
                            "cmapx",
                            "imap_np",
                            "cmapx_np",
                            "jpg",
                            "jpeg",
                            "jpe",
                            "jp2",
                            "json",
                            "json0",
                            "dot_json",
                            "xdot_json",
                            "pdf",
                            "pic",
                            "pct",
                            "pict",
                            "plain",
                            "plain-ext",
                            "png",
                            "pov",
                            "ps",
                            "ps2",
                            "psd",
                            "sgi",
                            "svg",
                            "svgz",
                            "tga",
                            "tiff",
                            "tif",
                            "tk",
                            "vml",
                            "vmlz",
                            "wbmp",
                            "webp",
                            "xlib",
                            "wayland",
                        },
                    },
                },
                server = {
                    on_attach = function(client, bufnr)
                        handlers.on_attach(client, bufnr)
                        if client.name == "rust_analyzer" then
                          require("which-key").add({
	                        { "<leader>l", group = "LSP Actions" },
	                        { "<leader>le", "<cmd>RustExpand<cr>", desc = "Expand" },
	                        { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart Server" },
	                        { "<leader>r", group = "Run Configurations" },
                            { "<leader>rd", "<cmd>9Multiterm cargo build<cr>", desc = "cargo build" },
                            { "<leader>rb", "<cmd>9Multiterm cargo run<cr>", desc = "cargo run" },
                            { "<leader>rs", "<cmd>9Multiterm cargo test<cr>", desc = "cargo test" },
                            { "<leader>rm", "<cmd>9Multiterm cargo update<cr>", desc = "cargo update" },
                          },
                          {
                            buffer = bufnr,
                          })
                        end
                    end,
                    capabilities = handlers.capabilities,
                    standalone = false,
                },
                dap = {
                    -- adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
                },
            })
        end,
    },
    -- Crates
    {
        "saecki/crates.nvim",
        enabled = true,
        event = { "BufRead Cargo.toml" },
        tag = "v0.4.0",
        lazy = true,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup({
                src = {
                    --[[ 	coq = {
						enabled = true,
						name = "crates.nvim",
					}, ]]
                    cmp = {
                        enabled = true,
                    },
                },
                popup = {
                    border = "rounded",
                },
            })
        end,
    },
}
