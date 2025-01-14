return {
    -- Diagnostics and error window
    "folke/trouble.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("trouble").setup({
        })
    end,
}
