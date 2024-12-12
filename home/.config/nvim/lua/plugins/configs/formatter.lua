return {
    "mhartington/formatter.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("formatter").setup({
            filetype = {
                javascript = {
                    function()
                        return {
                            exe = "prettier",
                            args = {
                                "--stdin-filepath", vim.api.nvim_buf_get_name(0),
                                "--tab-width", "4", 
                            },
                            stdin = true,
                        }
                    end,
                },
                typescript = {
                    function()
                        return {
                            exe = "prettier",
                            args = {
                                "--stdin-filepath", vim.api.nvim_buf_get_name(0),
                                "--tab-width", "4", 
                            },
                            stdin = true,
                        }
                    end,
                },
                java = {
                    function()
                        return {
                            exe = "google-java-format",
                            args = {
                                "-", 
                            },
                            stdin = true,
                        }
                    end,
                },
                ["*"] = {
                    function()
                        local excluded_filetypes = { "java", "rust" }
                        if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
                            return nil
                        end

                        return {
                            exe = "prettier",
                            args = {
                                "--stdin-filepath", vim.api.nvim_buf_get_name(0),
                                "--tab-width", "4", 
                            },
                            stdin = true,
                        }
                    end,
                },
            },
        })

        vim.api.nvim_set_keymap("n", "<leader>p", ":Format<CR>", { noremap = true, silent = true })
    end,
}
