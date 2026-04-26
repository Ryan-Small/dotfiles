-- Custom highlight groups for aesthetic polish
-- Loads after plugins to ensure overrides take effect
-- Only applies overrides for non-custom colorschemes

-- Create autocommand to apply highlights after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Skip overrides for custom iTerm colorscheme (it handles everything)
        if vim.g.colors_name == "iterm-custom" then
            return
        end
        -- Get current Normal foreground to preserve theme colors
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        local custom_bg = 0x1f1f1f  -- Custom background (#1f1f1f in hex)

        -- Override main editor background to custom dark color
        vim.api.nvim_set_hl(0, "Normal", {
            fg = normal.fg,  -- Preserve theme's text color
            bg = custom_bg,  -- Custom dark charcoal background
        })
        vim.api.nvim_set_hl(0, "NormalNC", {
            fg = normal.fg,
            bg = custom_bg,  -- Non-current windows same background
        })
        vim.api.nvim_set_hl(0, "SignColumn", {
            bg = custom_bg,  -- Sign column matches
        })
        vim.api.nvim_set_hl(0, "LineNr", {
            fg = "#505050",  -- Subtle but readable gray for line numbers
            bg = custom_bg,  -- Line numbers background
        })
        vim.api.nvim_set_hl(0, "CursorLineNr", {
            fg = "#707070",  -- Brighter for current line
            bg = custom_bg,  -- Current line number background
            bold = false,    -- Remove bold styling
        })
        vim.api.nvim_set_hl(0, "CursorLine", {
            bg = custom_bg,  -- Current line background (no highlight)
        })
        vim.api.nvim_set_hl(0, "ColorColumn", {
            bg = "#242424",  -- Column guide slightly lighter for visibility
        })
        vim.api.nvim_set_hl(0, "StatusLine", {
            bg = custom_bg,  -- Status line background
        })
        vim.api.nvim_set_hl(0, "StatusLineNC", {
            bg = custom_bg,  -- Inactive status line background
        })
        vim.api.nvim_set_hl(0, "MsgArea", {
            bg = custom_bg,  -- Command/message area
        })
        vim.api.nvim_set_hl(0, "EndOfBuffer", {
            bg = custom_bg,  -- Empty lines below buffer (~)
        })
        vim.api.nvim_set_hl(0, "VertSplit", {
            bg = custom_bg,  -- Window separator background
        })

        -- Comments: Medium gray for contrast and distinction from strings
        -- Covers all comment types: single-line, block, doc comments, and docstrings
        local comment_style = { fg = "#888888", italic = true }

        vim.api.nvim_set_hl(0, "Comment", comment_style)
        vim.api.nvim_set_hl(0, "@comment", comment_style)
        vim.api.nvim_set_hl(0, "@comment.line", comment_style)
        vim.api.nvim_set_hl(0, "@comment.block", comment_style)
        vim.api.nvim_set_hl(0, "@comment.documentation", comment_style)

        -- Docstrings: Triple-quoted strings used as documentation
        -- Treesitter distinguishes these from regular strings, so we style them like comments
        -- for visual distinction (gray instead of green)
        vim.api.nvim_set_hl(0, "@string.documentation", comment_style)  -- Generic docstrings
        vim.api.nvim_set_hl(0, "@string.documentation.python", comment_style)  -- Python-specific
        vim.api.nvim_set_hl(0, "@text.literal.block", comment_style)  -- Block literals

        -- Enhanced floating window background for visual depth
        -- Slightly lighter than normal background to create elevation effect
        vim.api.nvim_set_hl(0, "NormalFloat", {
            bg = "#252931",  -- Elevated surface color
        })

        -- Enhanced floating window borders - more prominent
        vim.api.nvim_set_hl(0, "FloatBorder", {
            fg = "#7c8896",  -- Brighter, more visible gray
            bg = "#252931",  -- Match float background for cohesion
        })

        -- Telescope enhancements with depth
        vim.api.nvim_set_hl(0, "TelescopeNormal", {
            bg = "#252931",  -- Elevated background
        })
        vim.api.nvim_set_hl(0, "TelescopeBorder", {
            fg = "#7c8896",
            bg = "#252931",
        })
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", {
            bg = "#2d3139",  -- Slightly different for hierarchy
        })
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
            fg = "#8893a6",  -- Brighter for active input
            bg = "#2d3139",
        })
        vim.api.nvim_set_hl(0, "TelescopePromptTitle", {
            fg = "#61afef",
            bold = true,
        })
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", {
            fg = "#7c8896",
            bg = "#252931",
        })
        vim.api.nvim_set_hl(0, "TelescopePreviewBorder", {
            fg = "#7c8896",
            bg = "#252931",
        })

        -- Completion menu polish with enhanced depth
        vim.api.nvim_set_hl(0, "Pmenu", {
            bg = "#252931",  -- Elevated background
        })
        vim.api.nvim_set_hl(0, "PmenuSel", {
            bg = "#2d3139",  -- Selected item stands out
            fg = "NONE",
        })
        vim.api.nvim_set_hl(0, "PmenuBorder", {
            fg = "#7c8896",
            bg = "#252931",
        })
        vim.api.nvim_set_hl(0, "CmpItemMenu", {
            fg = "#7c8896",  -- Muted color for source labels
            italic = true,
        })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {
            fg = "#61afef",  -- Highlight matched characters
            bold = true,
        })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", {
            fg = "#61afef",
            bold = true,
        })

        -- Which-key enhancements
        vim.api.nvim_set_hl(0, "WhichKeyFloat", {
            bg = "#252931",
        })
        vim.api.nvim_set_hl(0, "WhichKeyBorder", {
            fg = "#7c8896",
            bg = "#252931",
        })

        -- LSP floating windows
        vim.api.nvim_set_hl(0, "LspInfoBorder", {
            fg = "#7c8896",
            bg = "#252931",
        })

        -- Diagnostic virtual text - softer colors with italics
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
            fg = "#e06c75",
            bg = "NONE",
            italic = true,
        })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
            fg = "#e5c07b",
            bg = "NONE",
            italic = true,
        })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
            fg = "#61afef",
            bg = "NONE",
            italic = true,
        })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
            fg = "#98c379",
            bg = "NONE",
            italic = true,
        })

        -- Subtle shadow effect simulation via dimmed text beneath
        -- (True shadows aren't possible, but we can enhance the illusion)
        vim.api.nvim_set_hl(0, "FloatTitle", {
            fg = "#8893a6",
            bg = "#252931",
            bold = true,
        })
    end,
})

-- Apply highlights immediately for current colorscheme
vim.schedule(function()
    vim.cmd("doautocmd ColorScheme")
end)

-- Manual command to reapply custom background (debugging tool)
vim.api.nvim_create_user_command("FixBackground", function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    local bg = 0x1a1a1a
    vim.api.nvim_set_hl(0, "Normal", { fg = normal.fg, bg = bg })
    vim.api.nvim_set_hl(0, "NormalNC", { fg = normal.fg, bg = bg })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
    vim.api.nvim_set_hl(0, "LineNr", { fg = 0x505050, bg = bg })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = 0x707070, bg = bg, bold = false })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = 0x242424 })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = bg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg })
    vim.api.nvim_set_hl(0, "MsgArea", { bg = bg })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = bg })
    vim.notify("Background color applied: #1a1a1a (all UI elements)", vim.log.levels.INFO)
end, {})
