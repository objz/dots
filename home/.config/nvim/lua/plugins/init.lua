local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")

if not ok then
    return
end

local theme = require("theme")

local plugins = {
    ---- UI
    theme.get_active_theme(),
    require("plugins.configs.alpha"),      --Start page
    require("plugins.configs.neotree"),    --File Explorer
    require("plugins.configs.lazygit"),    --Git UI
    require("plugins.configs.bufferline"), --Buffer tab view
    require("plugins.configs.neoscroll"),  --Smooth scrolling
    require("plugins.configs.trouble"),    --Diagnostics window
    require("plugins.configs.lualine"),    --Custom Staus bar
    require("plugins.configs.markdown"),   --Markdown preview
    require("plugins.configs.noice"),      --Notify plugin
    "onsails/lspkind.nvim",                --Code Popup icons
    "folke/which-key.nvim",                --Keymap viewer
    "rcarriga/nvim-notify",                --Popup notifications
    "folke/drop.nvim",                     --Screen saver
    "boltlessengineer/sense.nvim",         --UI sense

    ---- Utilities
    require("plugins.configs.telescope"),   --Fuzzy finder
    require("plugins.configs.autopairs"),   --Brackets close
    require("plugins.configs.toggleterm"),  --Terminal
    require("plugins.configs.comment"),     --Toggle comment
    require("plugins.configs.todo"),        -- Todo
    require("plugins.configs.bigfile"),     -- Big file management
    require("plugins.configs.suda"),        -- Sudo file reopen
    require("plugins.configs.autosession"), --Session restore
    -- require("plugins.configs.dooing"),      -- Todo Plugin
    "mg979/vim-visual-multi",               -- Multiply cursors
    "sitiom/nvim-numbertoggle",             -- Absolute line numbers
    "chrisgrieser/nvim-spider",             -- Motions

    ---- Code
    require("plugins.configs.lspsaga"),  -- LSP Gui
    require("plugins.configs.colorful"), -- Colorfull Blink.cmp
    require("plugins.configs.refactor"), -- Refactoring tools
    require("plugins.configs.conform"),  -- Formatting tool

    ---- LSP/DAP
    require("plugins.configs.mason"),     -- LSP installer
    require("plugins.configs.lspconfig"), -- LSP server
    -- custom dap servers

    -- require("lsp.configs.dap"),
    require("lsp.configs.java"),
    require("lsp.configs.rust"),

    ---- Snippets
    "L3MON4D3/LuaSnip",             -- Snippet engine
    "rafamadriz/friendly-snippets", -- Prebuilt snippets

    ---- Completion
    require("plugins.configs.lspsignature"), -- Function signature support
    require("plugins.configs.copilot"),      -- Copilot autocompletion
    require("plugins.configs.blink"),        -- Code Completion
}

lazy.setup(plugins)
