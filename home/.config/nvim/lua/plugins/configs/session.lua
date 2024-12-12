return {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup({
            log_level = "info",
            auto_restore_last_session = true,
            auto_save = true,
            auto_restore = true,
            suppress_dirs = { "~/", "/tmp/" },
        })
    end,
}
