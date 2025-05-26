local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
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
    require("plugins.configs.snacks"),
    require("plugins.configs.lazygit"),    -- Git UI
    require("plugins.configs.bufferline"), -- Buffer tab view
    require("plugins.configs.lualine"),    -- Custom Status bar
    require("plugins.configs.markdown"),   -- Markdown preview
    require("plugins.configs.noice"),      -- Notify plugin
    require("plugins.configs.split"),

    ---- Core UI
    "onsails/lspkind.nvim",                -- Code popup icons
    require("plugins.configs.which-key"),                -- Keymap viewer
    "boltlessengineer/sense.nvim",         -- UI sense

    ---- Utilities
    require("plugins.configs.telescope"),   -- Fuzzy finder
    require("plugins.configs.autopairs"),   -- Brackets close
    require("plugins.configs.toggleterm"),  -- Terminal
    require("plugins.configs.autosession"), -- Session restore
    require("plugins.configs.mini-icons"),  -- Icons
    require("plugins.configs.surround"),    -- Surround operations
    "mg979/vim-visual-multi",               -- Multiple cursors
    "sitiom/nvim-numbertoggle",             -- Absolute line numbers

    ---- LSP/DAP
    require("plugins.configs.mason"),       -- LSP installer
    require("plugins.configs.treesitter"),  -- Syntax highlighting

    ---- Completion (nvim-cmp stack)
    require("plugins.configs.cmp"),

    ---- Formatting / Linting
    "nvimtools/none-ls.nvim",
    "jay-babu/mason-null-ls.nvim",

    ---- LSP Core
    "neovim/nvim-lspconfig",
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require("lspsaga").setup({
                ui = {
                    border = "rounded",
                    code_action = "",
                },
                lightbulb = {
                    enable = false,
                },
            })
        end,
    },

    ---- Extras
    "xzbdmw/colorful-menu.nvim",
    "numToStr/Comment.nvim",
    "ray-x/lsp_signature.nvim",
    "lambdalisue/suda.vim",
    "folke/todo-comments.nvim",
    "folke/trouble.nvim",
    
    ---- Enhanced formatting
    require("plugins.configs.conform"),
}

lazy.setup(plugins)