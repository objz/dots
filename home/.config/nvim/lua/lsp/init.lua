local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("LSP: Failed to load " .. module, vim.log.levels.WARN)
        return nil
    end
    return result
end

local mason_lspconfig = safe_require("mason-lspconfig")
local lspconfig = safe_require("lspconfig")
local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")

if not mason_lspconfig or not lspconfig or not cmp_nvim_lsp then
    vim.notify("LSP: Required modules not available, skipping LSP setup", vim.log.levels.WARN)
    return
end

local capabilities = cmp_nvim_lsp.default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
}

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local ok, lsp_signature = pcall(require, "lsp_signature")
    if ok then
        lsp_signature.on_attach({
            bind = true,
            handler_opts = {
                border = "rounded"
            }
        }, bufnr)
    end
end

local servers = {
    -- Rust
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
            },
        },
    },
    
    -- C/C++
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
        },
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
        },
    },
    
    -- Lua
    lua_ls = {
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
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "4",
                    }
                },
            },
        },
    },
    
    -- Bash
    bashls = {
        filetypes = { "sh", "bash", "zsh" },
    },
    
    -- Python
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        },
    },
    
    -- TypeScript/JavaScript
    ts_ls = {
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
}

local function setup_lsp_servers()
    if mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
            function(server_name)
                local server_config = servers[server_name] or {}
                server_config.capabilities = capabilities
                server_config.on_attach = on_attach
                lspconfig[server_name].setup(server_config)
            end,
        })
    else
        vim.notify("LSP: Using fallback server setup", vim.log.levels.INFO)
        for server_name, server_config in pairs(servers) do
            if vim.fn.executable(server_name:gsub("_", "-")) == 1 then
                server_config.capabilities = capabilities
                server_config.on_attach = on_attach
                lspconfig[server_name].setup(server_config)
            end
        end
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        vim.schedule(function()
            setup_lsp_servers()
        end)
    end,
})

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        source = "if_many",
    },
    float = {
        source = "always",
        border = "rounded",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end