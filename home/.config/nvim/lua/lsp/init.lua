local capabilities = require("blink.cmp").get_lsp_capabilities()

local _lspconfig, lspconfig = pcall(require, "lspconfig")
if _lspconfig then
	-- Python
	lspconfig.pyright.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- LUA
	lspconfig.lua_ls.setup({
		autostart = false,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
	-- -- Rust
	-- lspconfig.rust_analyzer.setup({
	-- 	on_attach = function(client, bufnr)
	-- 		require("lsp.handlers").on_attach(client, bufnr)
	-- 		-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	-- 	end,
	-- 	-- capabilities = capabilities,
	-- 	settings = {
	-- 		["rust-analyzer"] = {
	-- 			diagnostics = {
	-- 				enable = true,
	-- 			},
	-- 			imports = {
	-- 				granularity = {
	-- 					group = "module",
	-- 				},
	-- 				prefix = "self",
	-- 			},
	-- 			cargo = {
	-- 				buildScripts = {
	-- 					enable = true,
	-- 				},
	-- 			},
	-- 			procMacro = {
	-- 				enable = true,
	-- 			},
	-- 		},
	-- 	},
	-- })

	-- Clangd (C++)
	lspconfig.clangd.setup({
        cmd = { "clangd", "--offset-encoding=utf-16"},
    })

	-- Bash
	lspconfig.bashls.setup({
		autostart = true,
	})

	-- Javascript/Typescript
	lspconfig.eslint.setup({
		autostart = false,
		capabilities = capabilities,
		settings = {
			packageManager = "npm",
		},
		on_attach = function(_, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end,
	})

	-- HTML
	lspconfig.html.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- CSS
	lspconfig.cssls.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- Dockerfile
	lspconfig.dockerls.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- Docker compose
	lspconfig.docker_compose_language_service.setup({
		autostart = false,
		capabilities = capabilities,
	})
	-- XML
	lspconfig.lemminx.setup({})


    -- Kotlin
    lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
        autostart = false,
        on_attach = function(client, bufnr)
            require("lsp.handlers").on_attach(client, bufnr)
        end,
        cmd = { "/home/consti/.local/share/nvim/mason/bin/kotlin-language-server"},
        root_dir = lspconfig.util.root_pattern("settings.gradle.kts", "build.gradle.kts", ".git"),
    })

    -- Gradle
    lspconfig.gradle_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            require("lsp.handlers").on_attach(client, bufnr)
        end,
        cmd = { "/home/consti/.local/share/nvim/mason/bin/gradle-language-server"},
        root_dir = lspconfig.util.root_pattern("settings.gradle.kts", "build.gradle.kts", ".git"),
    })

end
