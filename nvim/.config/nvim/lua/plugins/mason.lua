-- Mason: Package manager for LSP servers, formatters, and linters
-- Provides :Mason command to browse and install tools
return {
    "williamboman/mason.nvim",
    cmd = "Mason",  -- Lazy load until you run :Mason
    build = ":MasonUpdate",  -- Update registry on install
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
                border = "rounded",
            },
        })
    end,
}
