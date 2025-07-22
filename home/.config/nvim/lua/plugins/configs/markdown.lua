return {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local presets = require("markview.presets")
        require("markview").setup({
            experimental = {
                check_rtp = false,
            },
            markdown = {
                headings = presets.headings.glow_center,
                horizontal_rules = presets.horizontal_rules.dotted,
                code_blocks = {
                    border_hl = "MarkviewCode",
                    info_hl = "MarkviewCodeInfo",
                    language_direction = "right",
                    min_width = 60,
                    pad_amount = 3,
                    pad_char = " ",
                    sign = true,
                    style = "language"
                },
            },
            markdown_inline = {
                checkboxes = presets.checkboxes.nerd,
            },
            preview = {
                enable = false,
                filetypes = { "md", "rmd", "quarto" },
            },
        })
    end,
}

