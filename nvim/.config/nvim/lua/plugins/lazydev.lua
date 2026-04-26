-- lazydev.nvim: configures lua_ls for editing Neovim config and plugins.
-- Replaces the manual workspace.library setup; types load on demand.
return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- Load luvit types when `vim.uv` is referenced
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
