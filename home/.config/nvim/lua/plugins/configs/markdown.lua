return {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        local presets = require("markview.presets");
        require("markview").setup({
            checkboxes = presets.checkboxes.nerd,
            headings = presets.headings.glow_center,
            horizontal_rules = presets.horizontal_rules.dotted,
            preview = {
                enable = false,
                filetypes = { "md", "rmd", "quarto"},
            },
            code_blocks = {
                style = "language",

                language_direction = "right",
                min_width = 60,
                pad_char = " ",
                pad_amount = 3,

                language_names = {
                    ["txt"] = "Text"
                },

                hl = "MarkviewCode",
                info_hl = "MarkviewCodeInfo",

                sign = true,
                sign_hl = nil
            },
        })
    end,

}
