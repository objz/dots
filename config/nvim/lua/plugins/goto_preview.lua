local function in_preview_window()
	local win = vim.api.nvim_get_current_win()
	local ok, is_preview = pcall(vim.api.nvim_win_get_var, win, "is-goto-preview-window")
	return ok and is_preview == 1, win
end

return {
	"rmagatti/goto-preview",
	dependencies = { "rmagatti/logger.nvim" },
	event = "BufEnter",
	config = true,

	vim.keymap.set("n", "<C-CR>", function()
        local ok, win = in_preview_window()
		if ok then
            local buf = vim.api.nvim_win_get_buf(win)
			local file = vim.api.nvim_buf_get_name(buf)
			local pos = vim.api.nvim_win_get_cursor(win)
			require("goto-preview").close_all_win()
			vim.cmd("edit " .. vim.fn.fnameescape(file))
			vim.api.nvim_win_set_cursor(0, pos)
		end
	end, { desc = "Promote preview window to real buffer", silent = true }),

	vim.keymap.set("n", "q", function()
        local ok = in_preview_window()
		if ok then
			require("goto-preview").close_all_win()
		end
	end, { desc = "Close preview window", silent = true }),
}

