local dap = require("dap")
local wk  = require("which-key")
local fn  = vim.fn

require("mason").setup()
require("mason-nvim-dap").setup({
	ensure_installed       = { "codelldb", "java-debug-adapter" },
	automatic_installation = true,
})

pcall(function()
	require("config.rust") -- assumes rust.lua is at lua/rust.lua or otherwise in runtimepath as "rust"
end)

do
	local status_handler = vim.lsp.handlers["language/status"]
	vim.lsp.handlers["language/status"] = function(err, result, ctx, config)
		local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
		if client and client.name == "jdtls" and result and result.type == "ServiceReady" then
			local bufnr = ctx.bufnr or vim.api.nvim_get_current_buf()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
		end
		return status_handler(err, result, ctx, config)
	end
end

do
	local uri_mod = require("vim.uri")
	local orig_uri_from_bufnr = uri_mod.uri_from_bufnr
	local function safe_uri_from_bufnr(bufnr)
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return ""
		end
		return orig_uri_from_bufnr(bufnr)
	end
	uri_mod.uri_from_bufnr = safe_uri_from_bufnr
	vim.uri_from_bufnr = safe_uri_from_bufnr
end


local function java_project()
	local root = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", })
	if root and root ~= "" then
		return vim.fn.fnamemodify(root, ":t")
	end
	return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

dap.configurations.java = {
	{
		type        = "java",
		request     = "attach",
		name        = "Connect remote: 127.0.0.1:5005",
		hostName    = "127.0.0.1",
		port        = 5005,
		projectName = java_project(),
	},
}
-- dap.configurations.rust = {
-- 	{
-- 		name    = "Attach to Rust Process",
-- 		type    = "codelldb",
-- 		request = "attach",
-- 		pid     = function() return tonumber(fn.input("PID > ")) end,
-- 		program = function()
-- 			return fn.input("Path to executable > ", fn.getcwd() .. "/target/debug/", "file")
-- 		end,
-- 		cwd     = "${workspaceFolder}",
-- 	},
-- }

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "jdtls" then
			local jdtls = require("jdtls")
			jdtls.setup_dap({ hotcodereplace = "auto" })
			pcall(function()
				require("jdtls.dap").setup_dap_main_class_configs()
			end)
			local dap_ok, dap_mod = pcall(require, "dap")
			if dap_ok and dap_mod.providers and dap_mod.providers.configs then
				dap_mod.providers.configs["jdtls"] = nil
			end
		end
	end,
})

require("nvim-dap-virtual-text").setup()

do
	local ok, dapview = pcall(require, "dap-view")
	if ok then
		dapview.setup({ auto_toggle = true })
	end
end


wk.add({
	{ "<leader>d",  group = "Debug" },
	{ "<leader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
	{
		"<leader>dc",
		function()
			local session = dap.session()
			if session then
				dap.terminate()
				local ok, dapview = pcall(require, "dap-view")
				if ok then dapview.close() end
				vim.schedule(function() vim.cmd("wincmd =") end)
			else
				dap.continue()
			end
		end,
		desc = "Start/Continue or Close Debug",
	},
	{ "<leader>di", dap.step_into, desc = "Step Into" },
	{ "<leader>do", dap.step_over, desc = "Step Over" },
	{ "<leader>du", dap.step_out,  desc = "Step Out" },
	{ "<leader>dr", dap.repl.open, desc = "Open REPL" },
	{ "<leader>dl", dap.run_last,  desc = "Run Last Debug Config" },
	{ "<leader>dT", dap.terminate, desc = "Terminate Session" },
	{
		"<leader>dQ",
		function()
			dap.terminate()
			local ok, dapview = pcall(require, "dap-view")
			if ok then dapview.close() end
			vim.schedule(function() vim.cmd("wincmd =") end)
		end,
		desc = "Terminate & Close UI",
	},
	{
		"<leader>dU",
		function()
			local ok, dapview = pcall(require, "dap-view")
			if ok then dapview.toggle() end
		end,
		desc = "Toggle DAP View",
	},
})
