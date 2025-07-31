local M            = {}

local mason_root   = vim.env.MASON or vim.fn.stdpath("data") .. "/mason"
local jdtls_pkg    = mason_root .. "/packages/jdtls"
local config_dir   = jdtls_pkg .. "/config_linux"
local launcher_jar = vim.fn.glob(jdtls_pkg .. "/plugins/org.eclipse.equinox.launcher_*.jar", false, true)[1]
local dbg_pkg      = mason_root .. "/packages/java-debug-adapter/extension/server"
local test_pkg     = mason_root .. "/packages/java-test/extension/server"

local function make_config()
	local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", })
	if not root_dir then
		vim.notify("jdtls: could not find project root; skipping start", vim.log.levels.WARN)
		return nil
	end

	local project_name  = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspace/" .. project_name

	assert(launcher_jar ~= "", "JDTLS launcher jar not found.")
	assert(vim.fn.isdirectory(config_dir) == 1, "JDTLS config directory not found: " .. config_dir)

	local bundles = {}
	local debug_bundles = vim.fn.glob(dbg_pkg .. "/com.microsoft.java.debug.plugin-*.jar", false, true)
	if type(debug_bundles) == "table" then
		for _, jar in ipairs(debug_bundles) do
			table.insert(bundles, jar)
		end
	elseif debug_bundles ~= "" then
		table.insert(bundles, debug_bundles)
	end
	local test_bundles = vim.fn.glob(test_pkg .. "/*.jar", false, true)
	if type(test_bundles) == "table" then
		for _, jar in ipairs(test_bundles) do
			table.insert(bundles, jar)
		end
	elseif test_bundles ~= "" then
		table.insert(bundles, test_bundles)
	end

	local config = {
		cmd = {
			"java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens", "java.base/java.util=ALL-UNNAMED",
			"--add-opens", "java.base/java.lang=ALL-UNNAMED",
			"-jar", launcher_jar,
			"-configuration", config_dir,
			"-data", workspace_dir,
		},
		root_dir = root_dir,
		settings = {
			java = {},
		},
		init_options = {
			bundles = bundles,
		},
	}

	return config
end

M.get_config = make_config

return M
