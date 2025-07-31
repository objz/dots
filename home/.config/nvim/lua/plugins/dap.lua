return {
  {
    "mfussenegger/nvim-dap",
    event        = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("config.dap")
    end,
  },
}
