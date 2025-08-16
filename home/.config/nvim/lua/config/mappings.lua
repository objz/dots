local ok, wk = pcall(require, "which-key")

if not ok then
	return
end

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<Right>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
vim.keymap.set("i", "<Space>", "<Space>", { noremap = true, silent = true })

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
	{ "d", '"_d', desc = "Do not copy when deleting" },
	{ "D", '"_D', desc = "Do not copy when deleting" },
	{ "dd", '"_dd', desc = "Do not copy when deleting" },
	{ "c", '"_c', desc = "Do not copy when changing" },
	{ "C", '"_C', desc = "Do not copy when changing" },
	{ "cc", '"_cc', desc = "Do not copy when changing" },
	{ "H", "^", desc = "Move to first character of line" },
	{ "L", "$", desc = "Move to last character of line" },
})

-- Utils
wk.add({
	{ "<a-k>", ":m .-2<cr>==", desc = "Move line up" },
	{ "<a-j>", ":m .+1<cr>==", desc = "Move line down" },
	{ "<a-o>", "mao<ESC>`a", desc = "New line in normal mode" },
	{ "<a-O>", "maO<ESC>`a", desc = "New line before in normal mode" },
})

-- Scrolling and commenting
wk.add({
	{ "<S-j>", "5j", desc = "Scroll 5 lines down" },
	{ "<S-k>", "5k", desc = "Scroll 5 lines up" },
	{ ".", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle line comment" },
})

-- Buffer management
wk.add({
	{ "<a-left>", "<cmd>BufferLineCyclePrev<cr>", desc = "Go previous buffer" },
	{ "<a-right>", "<cmd>BufferLineCycleNext<cr>", desc = "Go next buffer" },
	{ "<a-q>", "<cmd>Bdelete!<cr>", desc = "Close current buffer" },
	{ "<C-s>", "<cmd>wall<cr>", desc = "Save all" },
})

-- Folds
wk.add({
	{ "|", "za", desc = "Toggle folds" },
})

-- Find & Search
wk.add({
	{ "<leader>f", group = "Find & Search" },
	{ "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in current buffer" },
	{ "<leader>fa", "<cmd>Telescope grep_string<cr>", desc = "Search for word in system" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep in workspace" },
	-- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
	{ "<leader>fc", "<cmd>Telescope command_history<cr>", desc = "Command history" },
	-- { "<leader>fz", "<cmd>Telescope zoxide list<cr>", desc = "Recent directories" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Open buffers" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
})

-- Views & Windows
wk.add({
	{ "<leader>v", group = "Views & Windows" },
	{
		"<leader>vf",
		function()
			Snacks.explorer()
		end,
		desc = "Toggle file tree view",
	},
	-- { "<S-F6>", "<Plug>(MultitermList)<Plug>", desc = "List terminals" },
	-- { "<C-F6>", "<Plug>(MultitermKillCurrent)<Plug>", desc = "Kill terminal" },
	{ "<leader>vm", "<cmd>Markview splitToggle<cr>", desc = "Toggle Markdown preview" },
	{ "<leader>vs", "<cmd>Split<cr>", desc = "Split Window" },
	{ "<leader>vq", "<cmd>q<cr>", desc = "Quit current Window" },
})

-- code
wk.add({
	{ "<leader>c", group = "Code & LSP" },
	{
		"<leader>ca",
		require("actions-preview").code_actions,
		desc = "Code Action",
	},
	{
		"<leader>cd",
		require("goto-preview").goto_preview_definition,
		desc = "Go to Definition",
	},
	{
		"<leader>cf",
		require("goto-preview").goto_preview_references,
		desc = "Find References",
	},
	{
		"<leader>ch",
		vim.lsp.buf.hover,
		desc = "Hover Documentation",
	},
	{
		"<leader>cc",
		"<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>",
		desc = "Format Code",
	},
	{
		"<leader>cr",
		vim.lsp.buf.rename,
		desc = "Rename Symbol",
	},
	{
		"<leader>cw",
		vim.lsp.buf.workspace_symbol,
		desc = "Workspace Symbols",
	},
})

-- Diagnostics
wk.add({
	{ "<leader>x", group = "Diagnostics" },
	{ "<leader>xn", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
	{ "<leader>xp", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
	{ "<leader>xq", vim.diagnostic.setqflist, desc = "Diagnostics to Quickfix" },
	{ "<leader>xl", vim.diagnostic.setloclist, desc = "Diagnostics to Location List" },
})

-- Git operations (unified group)
wk.add({
	{ "<leader>g", group = "Git" },
	{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
	{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
	{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
	{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
	{ "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
})

-- Insert mode mappings
wk.add({
	mode = { "i" },
	{ "<a-b>", "<C-o>b", desc = "Move to previous word" },
	{ "<a-w>", "<C-o>w", desc = "Move to next word" },
	{ "<a-c>", '<C-o>"_ciw', desc = "Change word" },
	{ "<a-d>", '<C-o>"_diw', desc = "Delete word" },
	{ "<a-j>", "<ESC>:m .+1<cr>==gi", desc = "Move block down" },
	{ "<a-k>", "<ESC>:m .-2<cr>==gi", desc = "Move block up" },
})

-- Visual mode mappings
wk.add({
	mode = { "v" },
	{ "v", "^o$", desc = "Select current line" },
	{ "<", "<gv", desc = "Indent left" },
	{ ">", ">gv", desc = "Indent right" },
	{ "x", '"+d', desc = "Cut to system clipboard" },
	{ "y", '"+y', desc = "Copy to system clipboard" },
	{ "p", '"+p', desc = "Paste from system clipboard" },
	{ ".", "gc", desc = "Toggle block comment" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action (Range)" },
})
