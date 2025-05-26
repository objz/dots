return {
    "folke/which-key.nvim",
    dependencies = {
        "echasnovski/mini.icons",
    },
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        
        wk.setup({
            preset = "modern",
            icons = {
                breadcrumb = "»",
                separator = "→",
                group = "",
                ellipsis = "…",
                mappings = true,
                rules = {
                    -- File operations
                    { pattern = "file", icon = "󰈙", color = "azure" },
                    { pattern = "find", icon = "󰍉", color = "green" },
                    { pattern = "search", icon = "󰍉", color = "green" },
                    { pattern = "grep", icon = "󰱼", color = "green" },
                    
                    -- Code operations
                    { pattern = "code", icon = "󰅩", color = "blue" },
                    { pattern = "lsp", icon = "󰒋", color = "orange" },
                    { pattern = "format", icon = "󰉶", color = "yellow" },
                    { pattern = "action", icon = "󰌹", color = "red" },
                    { pattern = "definition", icon = "󰳽", color = "blue" },
                    { pattern = "reference", icon = "󰌷", color = "cyan" },
                    { pattern = "rename", icon = "󰑕", color = "yellow" },
                    { pattern = "hover", icon = "󰋖", color = "blue" },
                    
                    -- Git operations
                    { pattern = "git", icon = "󰊢", color = "orange" },
                    { pattern = "branch", icon = "󰘬", color = "cyan" },
                    { pattern = "commit", icon = "󰜘", color = "green" },
                    { pattern = "status", icon = "󰦖", color = "blue" },
                    { pattern = "lazygit", icon = "󰊢", color = "orange" },
                    
                    -- Diagnostics
                    { pattern = "diagnostic", icon = "󰒡", color = "red" },
                    { pattern = "error", icon = "󰅚", color = "red" },
                    { pattern = "warning", icon = "󰀪", color = "yellow" },
                    { pattern = "trouble", icon = "󰔫", color = "red" },
                    { pattern = "todo", icon = "󰸞", color = "cyan" },
                    
                    -- Views and windows
                    { pattern = "view", icon = "󰋱", color = "purple" },
                    { pattern = "window", icon = "󱂬", color = "blue" },
                    { pattern = "terminal", icon = "󰆍", color = "green" },
                    { pattern = "explorer", icon = "󰙅", color = "blue" },
                    { pattern = "toggle", icon = "󰔡", color = "yellow" },
                    { pattern = "tree", icon = "󰙅", color = "green" },
                    
                    -- Plugin management 
                    { pattern = "plugin", icon = "󰒲", color = "purple" },  
                    { pattern = "lazy", icon = "󰒲", color = "cyan" }, 
                    { pattern = "mason", icon = "󰏗", color = "orange" }, 
                    { pattern = "install", icon = "󰏗", color = "green" },
                    { pattern = "update", icon = "󰚰", color = "blue" },
                    { pattern = "sync", icon = "󰓦", color = "cyan" },
                    
                    -- Session management  
                    { pattern = "session", icon = "󱂬", color = "yellow" },
                    { pattern = "save", icon = "󰆓", color = "green" },
                    { pattern = "restore", icon = "󰦛", color = "blue" },
                    
                    -- Buffer operations
                    { pattern = "buffer", icon = "󰓩", color = "blue" },
                    { pattern = "close", icon = "󰅖", color = "red" },
                    { pattern = "quit", icon = "󰗼", color = "red" },
                },
            },
            win = {
                border = "rounded",
                padding = { 1, 2 },
                title = true,
                title_pos = "center",
                zindex = 1000,
                wo = {
                    winblend = 10,
                },
            },
            layout = {
                height = { min = 4, max = 25 },
                width = { min = 20, max = 50 },
                spacing = 3,
                align = "left",
            },
            keys = {
                scroll_down = "<c-d>",
                scroll_up = "<c-u>",
            },
            sort = { "local", "order", "group", "alphanum", "mod" },
            expand = 0,
            replace = {
                ["<space>"] = "SPC",
                ["<cr>"] = "RET",
                ["<tab>"] = "TAB",
                ["<leader>"] = "SPC",
            },
        })
    end,
}