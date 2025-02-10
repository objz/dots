return {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local presets = require("markview.presets")
        require("markview").setup({
            checkboxes = presets.checkboxes.nerd,
            markdown = {
                headings = presets.headings.glow_center,
                horizontal_rules = presets.horizontal_rules.dotted,
            },
            preview = {
                enable = false,
                filetypes = { "md", "rmd", "quarto" },
            },
            code_blocks = {
                style = "language",
                language_direction = "right",
                min_width = 60,
                pad_char = " ",
                pad_amount = 3,
                border_hl = "MarkviewCode",
                info_hl = "MarkviewCodeInfo",
                sign = true,
                sign_hl = nil,
                language_names = {
                    ["txt"] = "Text"
                },
            },
        })
    end,
}

