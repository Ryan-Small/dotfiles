-- Indent guides: Shows vertical lines to visualize indentation levels
-- Helpful for deeply nested code (Python, YAML, Lua, etc.)
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        -- Indent line characters
        indent = {
            char = "│",      -- Thin vertical line for indentation
            tab_char = "│",
        },

        -- Scope: Highlights the current indentation scope
        scope = {
            enabled = true,        -- Highlight current scope
            show_start = true,     -- Show scope start
            show_end = false,      -- Don't show scope end (less noisy)
            highlight = { "Function", "Label" },  -- Colors for scope
        },

        -- Exclude from specific filetypes where guides don't make sense
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
        },
    },
}
