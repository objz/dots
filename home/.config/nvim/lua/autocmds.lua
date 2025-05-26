local api = vim.api

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
})

-- go to last loc when opening a buffer
--[[ api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
}) ]]

vim.filetype.add({
	extension = {
		zsh = "sh",
		sh = "sh",
	},
	filename = {
		[".zshrc"] = "sh",
		["zshrc"] = "sh",
		[".zshenv"] = "sh",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    pcall(vim.api.nvim_buf_del_keymap, args.buf, "n", "K")
  end,
})

-- Command aliases for common typos
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('QA', 'qa', {})
vim.api.nvim_create_user_command('Qall', 'qall', {})
vim.api.nvim_create_user_command('QAll', 'qall', {})
vim.api.nvim_create_user_command('QALL', 'qall', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wqa', 'wqa', {})
vim.api.nvim_create_user_command('WQa', 'wqa', {})
vim.api.nvim_create_user_command('WQA', 'wqa', {})