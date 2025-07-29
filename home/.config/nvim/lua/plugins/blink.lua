return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
        keymap = {
            preset = "enter",

            -- ["<Up>"] = { "select_prev", "fallback" },
            -- ["<Down>"] = { "select_next", "fallback" },
            -- ["<Tab>"] = { "accept_and_enter", "fallback" },
            -- ["<CR>"] = { "accept", "fallback" },
            -- ["<S-d>"] = { "show_documentation", "hide_documentation", "fallback" },
            -- ["<S-k>"] = { "show_signature", "hide_signature", "fallback" },
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        completion = { documentation = { auto_show = false } },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
