return {
    "atiladefreitas/dooing",
    config = function()
        require("dooing").setup({
            keymaps = {
                toggle_window = "<leader>vd",
            }
        })
    end,
}
