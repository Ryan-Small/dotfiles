-- LSP (Language Server Protocol): Provides intelligent code features
-- Powers: autocomplete, go-to-definition, error checking, refactoring, etc.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
    },
    config = function()
        -- mason-lspconfig: Bridge between Mason and LSP
        -- Automatically installs LSP servers
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",         -- Lua (for NeoVim config)
                "pyright",        -- Python
                "ts_ls",          -- TypeScript/JavaScript
                "gopls",          -- Go
                "bashls",         -- Bash
                "jsonls",         -- JSON (with schema validation)
                "yamlls",         -- YAML (with schema validation)
            },
            automatic_installation = true,
        })

        -- Get default capabilities from nvim-cmp for better completion
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Configure LSP servers using new vim.lsp.config API (NeoVim 0.11+)

        -- Lua LSP (for editing NeoVim configs)
        -- Workspace library is managed by lazydev.nvim (loads types on demand)
        vim.lsp.config.lua_ls = {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    telemetry = { enable = false },
                },
            },
        }
        vim.lsp.enable('lua_ls')

        -- Python LSP
        vim.lsp.config.pyright = {
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    }
                }
            }
        }
        vim.lsp.enable('pyright')

        -- TypeScript/JavaScript LSP
        vim.lsp.config.ts_ls = {
            capabilities = capabilities,
        }
        vim.lsp.enable('ts_ls')

        -- Go LSP
        vim.lsp.config.gopls = {
            capabilities = capabilities,
            settings = {
                gopls = {
                    analyses = { unusedparams = true, shadow = true },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        }
        vim.lsp.enable('gopls')

        -- Bash LSP (uses shellcheck for diagnostics if installed)
        vim.lsp.config.bashls = {
            capabilities = capabilities,
        }
        vim.lsp.enable('bashls')

        -- JSON LSP
        vim.lsp.config.jsonls = {
            capabilities = capabilities,
        }
        vim.lsp.enable('jsonls')

        -- YAML LSP
        vim.lsp.config.yamlls = {
            capabilities = capabilities,
            settings = {
                yaml = {
                    keyOrdering = false,
                },
            },
        }
        vim.lsp.enable('yamlls')

        -- Configure LSP UI with rounded borders
        require('lspconfig.ui.windows').default_options.border = 'rounded'

        -- Hover/signature borders are handled globally via vim.o.winborder in options.lua
        -- (modern 0.11+ replacement for the deprecated vim.lsp.with handler wrapper)

        -- LSP Keymaps: Set up when LSP attaches to a buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Helper to set buffer-local keymaps
                local function map(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
                end

                -- Jump to definition/declaration
                map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

                -- Documentation
                map('K', vim.lsp.buf.hover, 'Hover Documentation')
                map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

                -- Code actions
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                -- Workspace management
                map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                map('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')

                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                -- Inlay hints: enable by default for servers that support them.
                -- Toggle per-buffer with <leader>th.
                if client and client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                    map('<leader>th', function()
                        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
                        vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
                    end, '[T]oggle Inlay [H]ints')
                end

                -- Highlight references under cursor
                if client and client.server_capabilities.documentHighlightProvider then
                    -- Create buffer-specific autogroup that clears on re-attach
                    local highlight_group = vim.api.nvim_create_augroup(
                        'lsp-highlight-' .. ev.buf,
                        { clear = true }
                    )

                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = ev.buf,
                        group = highlight_group,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = ev.buf,
                        group = highlight_group,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,      -- Add space before virtual text
                prefix = '●',     -- Icon before message
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✗",
                    [vim.diagnostic.severity.WARN] = "!",
                    [vim.diagnostic.severity.HINT] = "⚑",
                    [vim.diagnostic.severity.INFO] = "i",
                }
            },
            underline = true,     -- Underline errors
            update_in_insert = false,  -- Don't update while typing
            severity_sort = true,      -- Sort by severity
            float = {
                border = "rounded",  -- Rounded borders for floating diagnostic windows
                source = "always",   -- Show diagnostic source (LSP name)
                max_width = 80,      -- Constrain width for readability
                max_height = 20,     -- Prevent overly tall windows
                focusable = true,    -- Allow navigating in diagnostic float
                style = "minimal",   -- Clean appearance
            },
        })
    end,
}
