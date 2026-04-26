-- Code formatting with conform.nvim
-- Automatically formats code on save using language-specific formatters
return {
    "stevearc/conform.nvim",
    event = "BufWritePre",  -- Load only when you're about to save (lazy loading)
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        local conform = require("conform")

        conform.setup({
            -- Define formatters for each language
            formatters_by_ft = {
                -- Lua
                lua = { "stylua" },

                -- Python
                python = { "ruff_format" },  -- Fast, modern Python formatter

                -- Web (JavaScript, TypeScript, HTML, CSS, JSON)
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },

                -- Markdown
                markdown = { "prettier" },

                -- Go
                go = { "goimports", "gofumpt" },  -- Import sorting + formatting
            },

            -- Format on save
            format_on_save = {
                timeout_ms = 1000,
                lsp_fallback = true,  -- Use LSP formatting if no formatter configured
            },
        })

        -- Manual format keybinding (works in normal and visual mode)
        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "[C]ode [F]ormat" })

        -- Note: formatters are auto-installed by mason-tool-installer.nvim.
    end,
}
