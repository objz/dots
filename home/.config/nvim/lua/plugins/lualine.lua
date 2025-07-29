return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "sonokai",
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = true,
            },
        })
    end,
}
