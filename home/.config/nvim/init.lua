vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.schedule(function()
            local messages = vim.api.nvim_exec("messages", true)
            if messages:match("Error") then
                vim.notify("Startup errors detected. Check :messages for details", vim.log.levels.WARN)
            end
        end)
    end
})

local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        local error_msg = string.format("Error loading module '%s': %s", module, result)
        vim.notify(error_msg, vim.log.levels.ERROR)
        print("DETAILED ERROR for " .. module .. ":")
        print(result)
        return nil
    else
        print("✓ Successfully loaded: " .. module)
    end
    return result
end


print("Loading settings...")
safe_require "settings"

print("Loading plugins...")
safe_require "plugins"

print("Loading mappings...")
safe_require "mappings"

print("Loading LSP...")
safe_require "lsp"

print("Loading autocmds...")
safe_require "autocmds"

print("Configuration loading complete!")

vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        vim.schedule(function()
            print("Lazy.nvim finished loading plugins")
            local messages = vim.api.nvim_exec("messages", true)
            if messages:match("Error") then
                vim.notify("Plugin loading errors detected. Run :messages to see details", vim.log.levels.WARN)
            end
        end)
    end
})

vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("SafeResizeDebug", { clear = true }),
    callback = function()
        local ok, err = pcall(function()
            vim.schedule(function()
                vim.cmd("tabdo wincmd =")
            end)
        end)
        if not ok then
            vim.notify("VimResized error: " .. tostring(err), vim.log.levels.ERROR)
        end
    end,
})