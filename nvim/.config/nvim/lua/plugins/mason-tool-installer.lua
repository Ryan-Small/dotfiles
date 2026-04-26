-- mason-tool-installer: ensures formatters/linters listed here are installed
-- alongside Mason-managed LSPs. Without this, format-on-save silently no-ops
-- on a fresh machine until each tool is installed manually.
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                -- Formatters (referenced in conform.lua)
                "stylua",     -- Lua
                "ruff",       -- Python (formatter + linter)
                "prettier",   -- JS/TS/HTML/CSS/JSON/Markdown
                "gofumpt",    -- Go (stricter gofmt)
                "goimports",  -- Go (import management)

                -- Linters / shell tooling
                "shellcheck", -- Bash linting (consumed by bashls)
            },
            auto_update = false,
            run_on_start = true,
        })
    end,
}
