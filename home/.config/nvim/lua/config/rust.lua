local dap = require("dap")
local fn  = vim.fn

local function get_codelldb()
    if fn.executable("codelldb") == 1 then
        return "codelldb"
    end
    local mason_bin = fn.stdpath("data") .. "/mason/bin/codelldb"
    if fn.executable(mason_bin) == 1 then
        return mason_bin
    end
    vim.notify("[dap][rust] codelldb not found in PATH or mason bin; please install or adjust path.",
        vim.log.levels.WARN)
    return "codelldb" -- allow visible failure downstream
end

dap.adapters.codelldb = {
    type = "executable",
    command = get_codelldb(),
}

local function get_binary()
    local cwd = fn.getcwd()
    local metadata_cmd = { "cargo", "metadata", "--no-deps", "--format-version", "1" }
    local metadata_raw = fn.systemlist(metadata_cmd, cwd)
    if vim.v.shell_error ~= 0 then
        return nil, "cargo metadata failed: " .. table.concat(metadata_raw, "\n")
    end

    local ok, metadata = pcall(vim.fn.json_decode, table.concat(metadata_raw, "\n"))
    if not ok or type(metadata) ~= "table" then
        return nil, "failed to parse cargo metadata"
    end

    local chosen_package
    for _, pkg in ipairs(metadata.packages or {}) do
        local manifest_dir = vim.fn.fnamemodify(pkg.manifest_path or "", ":h")
        if vim.startswith(fn.getcwd(), manifest_dir) then
            chosen_package = pkg
            break
        end
    end
    if not chosen_package and metadata.packages and #metadata.packages > 0 then
        chosen_package = metadata.packages[1]
    end
    if not chosen_package then
        return nil, "no package found in cargo metadata"
    end

    local bin_target
    for _, target in ipairs(chosen_package.targets or {}) do
        for _, kind in ipairs(target.kind or {}) do
            if kind == "bin" then
                bin_target = target
                break
            end
        end
        if bin_target then break end
    end
    if not bin_target then
        return nil, "no binary target in package " .. (chosen_package.name or "<unknown>")
    end

    local target_dir = metadata.target_directory or (fn.getcwd() .. "/target")
    local exe_name = bin_target.name
    local candidate = target_dir .. "/debug/" .. exe_name
    return candidate, nil
end

local function resolve_bin()
    local cwd = fn.getcwd()
    local build_cmd = { "cargo", "build" }
    local build_output = fn.systemlist(build_cmd, cwd)
    if vim.v.shell_error ~= 0 then
        vim.notify("[dap][rust] cargo build failed:\n" .. table.concat(build_output, "\n"), vim.log.levels.ERROR)
        return nil
    end

    do
        local metadata_cmd = { "cargo", "metadata", "--no-deps", "--format-version", "1" }
        local metadata_raw = fn.systemlist(metadata_cmd, cwd)
        if vim.v.shell_error == 0 then
            local ok, metadata = pcall(vim.fn.json_decode, table.concat(metadata_raw, "\n"))
            if ok and type(metadata) == "table" then
                local chosen_package
                for _, pkg in ipairs(metadata.packages or {}) do
                    local manifest_dir = vim.fn.fnamemodify(pkg.manifest_path or "", ":h")
                    if vim.startswith(fn.getcwd(), manifest_dir) then
                        chosen_package = pkg
                        break
                    end
                end
                if not chosen_package and metadata.packages and #metadata.packages > 0 then
                    chosen_package = metadata.packages[1]
                end
                if chosen_package then
                    local target_dir = metadata.target_directory or (fn.getcwd() .. "/target")
                    local candidates = {}
                    for _, target in ipairs(chosen_package.targets or {}) do
                        local is_bin = false
                        for _, kind in ipairs(target.kind or {}) do
                            if kind == "bin" then
                                is_bin = true
                                break
                            end
                        end
                        if is_bin then
                            local path = target_dir .. "/debug/" .. target.name
                            if fn.filereadable(path) == 1 then
                                table.insert(candidates, path)
                            end
                        end
                    end
                    if #candidates == 1 then
                        return candidates[1]
                    elseif #candidates > 1 then
                        local opts = { "Select executable to debug:" }
                        for i, exe in ipairs(candidates) do
                            table.insert(opts, string.format("%d. %s", i, exe))
                        end
                        local choice = fn.inputlist(opts)
                        if choice >= 1 and choice <= #candidates then
                            return candidates[choice]
                        end
                        return candidates[1]
                    end
                end
            end
        end
    end

    local exe_path, err = get_binary()
    if exe_path and vim.fn.filereadable(exe_path) == 1 then
        return exe_path
    end

    if err then
        vim.notify("[dap][rust] auto-resolve binary failed: " .. err .. "; falling back to manual input",
            vim.log.levels.WARN)
    else
        vim.notify("[dap][rust] expected binary missing; falling back to manual input: " .. tostring(exe_path),
            vim.log.levels.WARN)
    end

    local default = cwd .. "/target/debug/"
    local explicit = fn.input("Path to executable (built): ", default, "file")
    if explicit == "" then
        vim.notify("[dap][rust] no executable path provided.", vim.log.levels.ERROR)
        return nil
    end
    return explicit
end


local function get_binaries()
    local bins = {}
    local cwd = fn.getcwd()
    local metadata_cmd = { "cargo", "metadata", "--no-deps", "--format-version", "1" }
    local metadata_raw = fn.systemlist(metadata_cmd, cwd)
    if vim.v.shell_error ~= 0 then
        return bins
    end
    local ok, metadata = pcall(vim.fn.json_decode, table.concat(metadata_raw, "\n"))
    if not ok or type(metadata) ~= "table" then
        return bins
    end
    local chosen_package
    for _, pkg in ipairs(metadata.packages or {}) do
        local manifest_dir = vim.fn.fnamemodify(pkg.manifest_path or "", ":h")
        if vim.startswith(cwd, manifest_dir) then
            chosen_package = pkg
            break
        end
    end
    if not chosen_package and metadata.packages and #metadata.packages > 0 then
        chosen_package = metadata.packages[1]
    end
    if not chosen_package then
        return bins
    end
    local target_dir = metadata.target_directory or (cwd .. "/target")
    for _, target in ipairs(chosen_package.targets or {}) do
        local is_bin = false
        for _, kind in ipairs(target.kind or {}) do
            if kind == "bin" then
                is_bin = true
                break
            end
        end
        if is_bin then
            local path = target_dir .. "/debug/" .. target.name
            if fn.filereadable(path) == 1 then
                table.insert(bins, { name = target.name, path = path })
            end
        end
    end
    return bins
end

local function make_launch_config(bin)
    return {
        name = "Launch: " .. bin.name,
        type = "codelldb",
        request = "launch",
        program = function()
            local cwd = fn.getcwd()
            local build_cmd = { "cargo", "build" }
            local build_output = fn.systemlist(build_cmd, cwd)
            if vim.v.shell_error ~= 0 then
                vim.notify("[dap][rust] cargo build failed:\n" .. table.concat(build_output, "\n"), vim.log.levels.ERROR)
                return nil
            end
            return bin.path
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = false,
        env = {
            RUST_BACKTRACE = "1",
        },
        showDisassembly = "never",
        sourceLanguages = { "rust" },
    }
end

do
    local rust_configs = {}
    local bins = get_binaries()
    if #bins > 0 then
        for _, bin in ipairs(bins) do
            table.insert(rust_configs, make_launch_config(bin))
        end
    else
        table.insert(rust_configs, {
            name = "Launch: Current Project",
            type = "codelldb",
            request = "launch",
            program = function()
                local exe = resolve_bin()
                if not exe or exe == "" then
                    error("Failed to determine executable to launch.")
                end
                return exe
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            runInTerminal = false,
            env = {
                RUST_BACKTRACE = "1",
            },
            showDisassembly = "never",
            sourceLanguages = { "rust" },
        })
    end
    table.insert(rust_configs, {
        name = "Attach to Process (by PID)",
        type = "codelldb",
        request = "attach",
        pid = function()
            local input = fn.input("PID > ")
            return tonumber(input)
        end,
        program = function()
            local default = fn.getcwd() .. "/target/debug/"
            return fn.input("Path to executable (for symbol resolution): ", default, "file")
        end,
        cwd = "${workspaceFolder}",
        showDisassembly = "never",
        sourceLanguages = { "rust" },
    })
    table.insert(rust_configs, {
        name = "Attach to Process (by name)",
        type = "codelldb",
        request = "attach",
        pid = function()
            local default_name = vim.fn.fnamemodify(fn.getcwd(), ":t")
            local pname = fn.input("Process name to attach to: ", default_name)
            local matches = fn.systemlist({ "pgrep", "-f", pname })
            if #matches == 0 then
                vim.notify("[dap][rust] no process found matching: " .. pname, vim.log.levels.ERROR)
                return nil
            end
            return tonumber(matches[1])
        end,
        program = function()
            local default = fn.getcwd() .. "/target/debug/"
            return fn.input("Path to executable (for symbol resolution): ", default, "file")
        end,
        cwd = "${workspaceFolder}",
        showDisassembly = "never",
        sourceLanguages = { "rust" },
    })
    dap.configurations.rust = rust_configs
end

-- ===========================
-- LSP configuration (export)
-- ===========================
local M = {}

local function make_ra_config()
    local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
    local ra_bin = mason_root .. "/bin/rust-analyzer"
    if vim.fn.executable(ra_bin) ~= 1 then
        ra_bin = "rust-analyzer"
    end

    local util = require("lspconfig.util")
    local rooter = util.root_pattern("Cargo.toml", "rust-project.json", ".git")

    local settings = {
        ["rust-analyzer"] = {
            cargo = {
                allTargets = false,
                buildScripts = { enable = false },
            },
            check = {
                command = "check",
                allTargets = false,
            },
            procMacro = { enable = false },
            files = {
                watcher = "server",
                excludeDirs = { "target", ".git", ".cargo", ".rustup", "node_modules" },
            },
            diagnostics = {
                enable = true,
                experimental = { enable = false },
            },
            inlayHints = {
                typeHints = { enable = true },
                parameterHints = { enable = false },
                maxLength = 30,
            },
            completion = {
                autoimport = { enable = true },
            },
        },
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    pcall(function()
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    end)

    return {
        cmd = { ra_bin },
        root_dir = function(fname)
            return rooter(fname) or vim.loop.cwd()
        end,
        settings = settings,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
    }
end

M.get_config = make_ra_config

return M
