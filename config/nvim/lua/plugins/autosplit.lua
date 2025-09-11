return {
    "yochem/autosplit.nvim",
    config = function()
        require('autosplit').setup({
            split = 'auto',
            min_win_width = 80
        })
    end,
}
