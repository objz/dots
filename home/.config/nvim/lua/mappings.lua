local ok, wk = pcall(require, "which-key")

if not ok then
    return
end

-- Space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window movement
wk.add({
    { "<C-k>", "<C-w>k", desc = "Move to window above" },
    { "<C-j>", "<C-w>j", desc = "Move to window below" },
    { "<C-h>", "<C-w>h", desc = "Move to window left" },
    { "<C-l>", "<C-w>l", desc = "Move to window right" },
}, { mode = "n" })

-- Edition
wk.add({
    { "<C-a>", "ggVG", desc = "Select all" },
    { "d",     '"_d',  desc = "Do not copy when deleting" },
    { "D",     '"_D',  desc = "Do not copy when deleting" },
    { "dd",    '"_dd', desc = "Do not copy when deleting" },
    { "c",     '"_c',  desc = "Do not copy when changing" },
    { "C",     '"_C',  desc = "Do not copy when changing" },
    { "cc",    '"_cc', desc = "Do not copy when changing" },

    { "H",     "^",    desc = "Move to first character of line" },
    { "L",     "$",    desc = "Move to last character of line" },
})

-- Utils
wk.add({
    { "<a-k>", ":m .-2<cr>==", desc = "Move line up" },
    { "<a-j>", ":m .+1<cr>==", desc = "Move line down" },
    { "<a-o>", "mao<ESC>`a",   desc = "New line in normal mode" },
    { "<a-O>", "maO<ESC>`a",   desc = "New line before in normal mode" },
})

-- Neoscroll and numToStr
wk.add({
    { "<s-j>", "<cmd>lua require('neoscroll').ctrl_d({ duration = 250, move_cursor = false })<cr>", desc = "Keep cursor in the middle while scrolling down" },
    { "<s-k>", "<cmd>lua require('neoscroll').ctrl_u({ duration = 250, move_cursor = true, })<cr>", desc = "Keep cursor in the middle while scrolling up" },
    { ".",     "<Plug>(comment_toggle_linewise_current)",                                           desc = "Toggle line comment" },
})

-- Buffer
wk.add({
    { "<a-left>",  "<cmd>BufferLineCyclePrev<cr>", desc = "Go previous buffer" },
    { "<a-right>", "<cmd>BufferLineCycleNext<cr>", desc = "Go next buffer" },
    { "<a-q>",     "<cmd>Bdelete!<cr>",            desc = "Close current buffer" },
    { "<C-s>",     "<cmd>wall<cr>",                desc = "Save all" },
})

-- Folds
wk.add({
    { "|", "za", desc = "Toggle folds" },
})

-- Find
wk.add({
    { "<leader>f",  group = "Find" },
    { "<leader>ff", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in current buffer" },
    { "<leader>fa", "<cmd>Telescope grep_string<cr>",               desc = "Search for files systemwide" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Search by content systemwide" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent files" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>",                       desc = "Find TODOs" },
    { "<leader>fc", "<cmd>Telescope command_history<cr>",           desc = "Command history" },
    { "<leader>fz", "<cmd>Telescope zoxide list<cr>",               desc = "Recent directories" },
})

-- Views
wk.add({
    { "<leader>v",  group = "Windows" },
    { "<leader>vf", "<cmd>Neotree toggle<cr>",       desc = "Toggle file tree view" },
    { "<leader>vt", "<cmd>ToggleTerm<cr>",           desc = "Open new terminal" },
    { "<leader>vg", "<cmd>LazyGit<cr>",              desc = "Open git view" },
    { "<leader>vo", "<cmd>Lspsaga outline<cr>",      desc = "Toggle LSP outline" },
    { "<leader>vm", "<cmd>Markview splitToggle<cr>", desc = "Toggle Markdown preview" },
    { "<leader>vd", "<cmd>Trouble todo toggle<cr>",          desc = "Toggle todo comment view" },
})


-- Debug
--[[ wk.add({
    { "<leader>d",  group = "Debug" },
    { "<leader>dR", "<cmd>lua require'dap'.run()<cr>",                                                         desc = "[DAP] Run" },
    { "<leader>de", "<cmd>lua require'dap'.run_last()<cr>",                                                    desc = "[DAP] Debug last" },
    { "<leader>dE", "<cmd>Telescope dap configurations<cr>",                                                   desc = "[DAP] Show debug configurations" },
    { "<leader>dk", "<cmd>DapTerminate<cr>",                                                                   desc = "[DAP] Terminate" },
    { "<leader>db", "<cmd>DapToggleBreakpoint<cr>",                                                            desc = "[DAP] Toggle breakpoint" },
    { "<leader>dB", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",        desc = "[DAP] Set conditional breakpoint", },
    { "<leader>dl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc = "[DAP] Set log point breakpoint", },
    { "<leader>dc", "<cmd>DapContinue<cr",                                                                     desc = "[DAP] Continue" },
    { "<leader>dv", "<cmd>DapStepOver<cr>",                                                                    desc = "[DAP] Step oVer" },
    { "<leader>di", "<cmd>DapStepInto<cr>",                                                                    desc = "[DAP] Step Into" },
    { "<leader>do", "<cmd>DapStepOut<cr>",                                                                     desc = "[DAP] Step Out" },
    { "<leader>dx", "<cmd>lua require('dapui').eval()<cr>",                                                    desc = "[DAPUI] eXecute}" },
    { "<leader>dp", "<cmd>DapToggleRepl<cr>",                                                                  desc = "[DAP] Repl open" },
    { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>",                                                    desc = "[DAPUI] Toggle debugging UI" },
    { "<leader>ds", "<cmd>Telescope dap list_breakpoints<cr>",                                                 desc = "[TELESCOPE DAP] Show all breakpoints" },
    { "<leader>dw", "<cmd>Telescope dap variables<cr>",                                                        desc = "[TELESCOPE DAP] Wariables" },
}) ]]

-- Code navigation
wk.add({
    { "<leader>c",  group = "Code" },
    { "<leader>ca", "<cmd>Lspsaga code_action<cr>",                                                  desc = "Code Action" },
    { "<leader>cd", "<cmd>Lspsaga peek_definition<cr>",                                              desc = "Peek definition" },
    { "<leader>cf", "<cmd>Lspsaga finder<cr>",                                                       desc = "LSP search references" },
    { "<leader>ch", "<cmd>Lspsaga hover_doc<cr>",                                                    desc = "Hover" },
    { "<leader>cc", "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>", desc = "Format code", },
    { "<leader>cr", "<cmd>Lspsaga rename<cr>",                                                       desc = "Rename" },
})

-- Diagnostics
wk.add({
    { "<leader>d",  group = "Diagnostics" },
    { "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump to next diagnostic" },
    { "<leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Jump to previous diagnostic" },
    { "<leader>df", "<cmd>Trouble quickfix toggle<cr>",      desc = "Toggle quick fixes view" },
    { "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>",   desc = "Toggle diagnostics view" },
})

-- Insert mode
wk.add({
    mode = { "i" },
    { "<a-b>", "<C-o>b",              desc = "Move to previous word" },
    { "<a-w>", "<C-o>w",              desc = "Move to next word" },
    { "<a-c>", '<C-o>"_ciw',          desc = "Change word" },
    { "<a-d>", '<C-o>"_diw',          desc = "Delete word" },
    { "<a-j>", "<ESC>:m .+1<cr>==gi", desc = "Move block down" },
    { "<a-k>", "<ESC>:m .-2<cr>==gi", desc = "Move block up" },
})

-- Visual mode
wk.add({
    mode = { "v" },
    { "v", "^o$",                                      desc = "Select current line" },
    { "<", "<gv",                                      desc = "[Indent] Indent left" },
    { ">", ">gv",                                      desc = "[Indent] Indent right" },
    { "x", '"+d',                                      desc = "Cut to system clipboard" },
    { "y", '"+y',                                      desc = "Copy to system clipboard" },
    { "p", '"+p',                                      desc = "Paste from system clipboard" },
    { ".", "<Plug>(comment_toggle_blockwise_current)", desc = "Toggle block comment" },
})

wk.setup({})
