return {
	"imranzero/multiterm.nvim",
	event = "VeryLazy",
	config = function()
		require("multiterm").setup({
			vim.keymap.set({ "n", "v", "i", "t" }, "<F6>", "<Plug>(Multiterm)",
				{ silent = true, desc = "Toggle Multiterm" }),
			vim.keymap.set({ "n", "v", "i", "t" }, "<leader><F6>", "<Plug>(MultitermList)",
				{ silent = true, desc = "List Multiterm" })


		})
	end,

	-- config = function()
	-- 	require("multiterm").setup({})
	--
	-- 	local function toggle_term(tag)
	-- 		if vim.fn.mode() == "t" then
	-- 			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
	-- 		end
	-- 		vim.cmd(tag .. "Multiterm")
	-- 	end
	--
	-- 	local function f6_handler()
	-- 		local mode = vim.fn.mode()
	-- 		local buftype = vim.bo.buftype
	--
	-- 		if mode == "t" or buftype == "terminal" then
	-- 			if mode == "t" then
	-- 				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
	-- 			end
	-- 			vim.cmd("Multiterm")
	-- 			return
	-- 		end
	--
	-- 		local c = vim.fn.getchar()
	-- 		local k = vim.fn.nr2char(c)
	--
	-- 		if k:match("[1-9]") then
	-- 			toggle_term(k)
	-- 		else
	-- 			toggle_term("1")
	-- 		end
	-- 	end
	--
	-- 	vim.keymap.set({ "n", "t", "i", "v" }, "<F6>", f6_handler, { desc = "F6 (+1-9) Toggle terminal" })
	-- end,
}
