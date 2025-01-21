return {
    --Smoot scrolling
  "karb94/neoscroll.nvim",
  config = function()
        require("neoscroll").setup({
            mappings = {
                "zz",
                "zb",
            }
        })
    end,
}
