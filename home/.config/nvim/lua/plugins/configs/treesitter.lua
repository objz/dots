return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "query",
                "markdown", "markdown_inline",
                "bash", "regex", "rust", "python",
                "javascript", "typescript", "java",
                "html", "css", "json"
            },
            ignore_install = {},
            modules = {},
            sync_install = false,
            parser_install_dir = nil,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
        })
    end,
}
