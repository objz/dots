return {
  "sainnhe/sonokai",
  name     = "sonokai",
  lazy     = false,
  priority = 1000,
  config = function()

    vim.g.sonokai_style                  = "default"
    vim.g.sonokai_enable_italic          = 1
    vim.g.sonokai_transparent_background = 1

    vim.g.sonokai_colors_override = {
      bg0     = "#1c1c1c",
      bg2     = "#1c1c1c",
    }

    vim.cmd("colorscheme sonokai")

    require("notify").setup({
      background_colour = "#1c1c1c",
    })
    -- vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1c1c1c" })
  end,
}
