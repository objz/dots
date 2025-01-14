return {
	"mfussenegger/nvim-jdtls",
	config = function()
		jdtls = require("jdtls")
		handlers = require("lsp.handlers")

		share_dir = os.getenv("HOME") .. "/.local/share"
		project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		workspace_dir = share_dir .. "/eclipse/" .. project_name

		-- Set proper Java executable
		java_cmd = "/usr/lib/jvm/java-17-openjdk/bin/java"

        local function detect_java()
            if vim.fn.filereadable("build.gradle") == 1
                or vim.fn.filereadable("build.gradle.kts") == 1
                or vim.fn.filereadable("pom.xml") == 1
            then
                local output = vim.fn.system("grep -o 'java.toolchain.*17' build.gradle build.gradle.kts pom.xml | head -n 1")
                if output:match("17") then
                    return "/usr/lib/jvm/java-17-openjdk/bin/java"
                end
                local output21 = vim.fn.system("grep -o 'java.toolchain.*21' build.gradle build.gradle.kts pom.xml | head -n 1")
                if output21:match("21") then
                    return "/usr/lib/jvm/java-21-openjdk/bin/java"
                end
            end

            return "/usr/lib/jvm/java-21-openjdk/bin/java"
        end
		mason_registry = require("mason-registry")

		-- vim.fn.glob Is needed to set paths using wildcard (*)
		bundles = {
			vim.fn.glob(
				mason_registry.get_package("java-debug-adapter"):get_install_path()
					.. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
			),
		}

		vim.list_extend(
			bundles,
			vim.split(
				vim.fn.glob(mason_registry.get_package("java-test"):get_install_path() .. "/extension/server/*.jar"),
				"\n"
			)
		)

		jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

		config = {
            cmd = {
                detect_java(),
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms512m",
                "-Xmx2048m",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-jar",
                vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                "-configuration",
                jdtls_path .. "/config_linux",
                "-data",
                workspace_dir,
            },
			flags = {
				debounce_text_changes = 150,
				allow_incremental_sync = true,
			},
			--root_dir = require("jdtls.setup").find_root({"build.gradle", "pom.xml", ".git"}),
			root_dir = jdtls.setup.find_root({ ".metadata", ".git", "pom.xml", "build.gradle" }),

			on_init = function(client)
				if client.config.settings then
					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
			end,

			init_options = {
				bundles = bundles,
			},
			capabilities = handlers.capabilities,

			on_attach = function(client, bufnr)
				handlers.on_attach(client, bufnr)
				if client.name == "jdtls" then
					require("which-key").add({
						{ "<leader>de", "<cmd>DapContinue<cr>", desc = "[JDLTS] Show debug configurations" },
						{ "<leader>ro", "<cmd>lua require'jdtls'.organize_imports()<cr>", desc = "[JDLTS] Organize imports" },
						{ "<leader>cs", "<cmd>lua require'jdtls'.super_implementation()<cr>", desc = "[JDLTS] Go to super implementation" },
					})
					jdtls = require("jdtls")
					jdtls.setup_dap({ hotcodereplace = "auto" })
					jdtls.setup.add_commands()
					-- Auto-detect main and setup dap config
					require("jdtls.dap").setup_dap_main_class_configs({
						config_overrides = {
							vmArgs = "-Dspring.profiles.active=local",
						},
					})
				end
			end,
			settings = {
				java = {
					signatureHelp = {
						enabled = true,
					},
					saveActions = {
						organizeImports = false,
					},
					completion = {
						maxResults = 20,
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
							"org.mockito.Mockito.*",
						},
					},
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					codeGeneration = {
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
					},
				},
			},
		}
		-- jdtls.start_or_attach(config)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                jdtls.start_or_attach(config)
            end,
        })
	end,
}
