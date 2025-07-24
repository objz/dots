return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls    = require("jdtls")
    local handlers = require("lsp.handlers")

    -- (default: ~/.local/share/nvim/mason)
    local mason_root = vim.env.MASON or vim.fn.stdpath("data") .. "/mason"

    local pkg_jdtls = mason_root .. "/packages/jdtls"
    local pkg_dbg   = mason_root .. "/packages/java-debug-adapter"
    local pkg_test  = mason_root .. "/packages/java-test"

    local launcher_jar = vim.fn.glob(pkg_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar", false, true)[1]
    assert(launcher_jar and #launcher_jar > 0,
           "JDTLS not found in: " .. pkg_jdtls)

    local config_dir = pkg_jdtls .. "/config_linux"
    assert(vim.fn.isdirectory(config_dir) == 1,
           "JDTLS config_linux not found in: " .. config_dir)

    local debug_jars = vim.fn.glob(
      pkg_dbg  .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
      false, true
    )
    local test_jars  = vim.fn.glob(
      pkg_test .. "/extension/server/*.jar",
      false, true
    )
    local bundles = vim.list_extend(debug_jars, test_jars)

    local java_cmd = "/usr/bin/java"

    -- workspace_dir
    local project      = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/eclipse/" .. project

    local config = {
      cmd = {
        java_cmd,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms512m", "-Xmx2048m",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_jar,
        "-configuration", config_dir,
        "-data", workspace_dir,
      },
      flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
      },
      root_dir = require("jdtls.setup").find_root({
        ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts"
      }),
      init_options  = { bundles = bundles },
      capabilities   = handlers.capabilities,
      on_init = function(client)
        if client.config.settings then
          client.notify("workspace/didChangeConfiguration", {
            settings = client.config.settings,
          })
        end
      end,
      on_attach = function(client, bufnr)
        handlers.on_attach(client, bufnr)
          if client.name == "jdtls" then
          require("which-key").add({
	        { "<leader>l", group = "LSP Actions" },
	        { "<leader>lo", "<cmd>lua require'jdtls'.organize_imports()<cr>", desc = "Organize Imports" },
	        { "<leader>ls", "<cmd>lua require'jdtls'.super_implementation()<cr>", desc = "Super Implementation" },
	        { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart Server" },
	        { "<leader>lu", "<cmd>JdtUpdateConfig<cr>", desc = "Update Config" },
	        { "<leader>r", group = "Run Configurations" },
            { "<leader>rd", "<cmd>9Multiterm ./gradlew dev<cr>", desc = "gradlew dev" },
            { "<leader>rb", "<cmd>9Multiterm ./gradlew build<cr>", desc = "gradlew build" },
            { "<leader>rs", "<cmd>9Multiterm ./gradlew shadowJar<cr>", desc = "gradlew shadowJar" },
            { "<leader>rm", "<cmd>9Multiterm ./gradlew modrinth<cr>", desc = "gradlew modrinth" },
          },
          {
            buffer = bufnr,
          })
        end
      end,
      settings = {
        java = {
          signatureHelp = { enabled = true },
          saveActions   = { organizeImports = false },
          completion    = {
            maxResults = 20,
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "org.mockito.Mockito.*",
            },
          },
          sources = {
            organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
          },
        },
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function() jdtls.start_or_attach(config) end,
      desc = "Start or attach JDTLS",
    })
  end,
}
