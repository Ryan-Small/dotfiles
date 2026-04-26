-- Treesitter (main branch / rewrite): syntax-aware parsing for highlighting,
-- indentation, and other language-aware features.
--
-- We use the new "main" branch because the legacy "master" branch crashes on
-- injection queries under Neovim 0.12+ (e.g. when rendering markdown). master
-- is in maintenance; main is the actively developed rewrite.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()

        -- Parsers to keep installed
        local parsers = {
            "lua", "vim", "vimdoc",
            "python",
            "markdown", "markdown_inline",
            "json", "yaml", "toml",
            "bash",
            "go",
            "typescript", "javascript", "tsx",
            "html", "css",
        }
        require("nvim-treesitter").install(parsers)

        -- Auto-start highlighting and treesitter-based indent for supported filetypes
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then return end

                pcall(vim.treesitter.start, args.buf, lang)

                if vim.treesitter.query.get(lang, "indents") then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
