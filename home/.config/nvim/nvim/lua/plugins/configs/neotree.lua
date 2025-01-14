return {
    -- Tree file explorer
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
    },

    config = function()
        require("neo-tree").setup({
            popup_border_style = "rounded",
            close_if_last_window = true,
            enable_git_status = true,

            buffers = {
                follow_current_file = true,
                group_empty_dirs = true,
                show_unloaded = true,

            },

            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = true,
                    hide_gitignored = true,
                },
                follow_current_file = true,
                group_empty_dirs = true,
                use_libuv_file_watcher = true,

                window = {
                    mappings = {
                        ["."] = "toggle_hidden",
                        ["/"] = "fuzzy_finder",
                    },
                },
            },
        })
    end,
}
