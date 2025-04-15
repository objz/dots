return {
    priority = 1100,
    --Smoot scrolling
    "karb94/neoscroll.nvim",
    config = function()
        require("neoscroll").setup({
            mappings = {
            },
        })
    end,
}
