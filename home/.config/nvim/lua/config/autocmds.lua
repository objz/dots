-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
})

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(args)
		local bufnr = args.buf

		for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
			if client.name == "jdtls" then
				return
			end
		end

		local java_conf = require("config.java").get_config()
		if not java_conf then
			return
		end

		require("jdtls").start_or_attach(java_conf)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name ~= "jdtls" then
			return
		end

		local bufnr = args.buf
		require("which-key").add({
			{ "<leader>co", "<cmd>lua require'jdtls'.organize_imports()<cr>",     desc = "[JDTLS] Organize Imports" },
			{ "<leader>cs", "<cmd>lua require'jdtls'.super_implementation()<cr>", desc = "[JDTLS] Super Implementation" },
			{ "<leader>r",  group = "Run Configurations" },
			{ "<leader>rd", "<cmd>9Multiterm ./gradlew dev<cr>",                  desc = "gradlew dev" },
			{ "<leader>rb", "<cmd>9Multiterm ./gradlew build<cr>",                desc = "gradlew build" },
			{ "<leader>rs", "<cmd>9Multiterm ./gradlew shadowJar<cr>",            desc = "gradlew shadowJar" },
			{ "<leader>rm", "<cmd>9Multiterm ./gradlew modrinth<cr>",             desc = "gradlew modrinth" },
		}, { buffer = bufnr })
	end,
})


vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name ~= "rust_analyzer" then
			return
		end

		local bufnr = args.buf
		require("which-key").add({
			{ "<leader>r",  group = "Run Configurations" },
			{ "<leader>rd", "<cmd>9Multiterm cargo build<cr>",  desc = "cargo build" },
			{ "<leader>rb", "<cmd>9Multiterm cargo run<cr>",    desc = "cargo run" },
			{ "<leader>rs", "<cmd>9Multiterm cargo test<cr>",   desc = "cargo test" },
			{ "<leader>rm", "<cmd>9Multiterm cargo update<cr>", desc = "cargo update" },
		}, { buffer = bufnr })
	end,
})



-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		pcall(vim.api.nvim_buf_del_keymap, args.buf, "n", "K")
-- 	end,
-- })

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
-- 	callback = function()
-- 		vim.defer_fn(function()
-- 			for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
-- 				if client.server_capabilities.codeLensProvider then
-- 					vim.lsp.codelens.refresh()
-- 					return
-- 				end
-- 			end
-- 		end, 100)
-- 	end,
-- })


-- Command aliases for common typos
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("QA", "qa", {})
vim.api.nvim_create_user_command("Qall", "qall", {})
vim.api.nvim_create_user_command("QAll", "qall", {})
vim.api.nvim_create_user_command("QALL", "qall", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wqa", "wqa", {})
vim.api.nvim_create_user_command("WQa", "wqa", {})
vim.api.nvim_create_user_command("WQA", "wqa", {})
