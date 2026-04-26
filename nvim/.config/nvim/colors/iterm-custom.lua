-- iTerm-inspired colorscheme
-- Sophisticated, muted palette for comfortable long coding sessions

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "iterm-custom"

-- Color palette extracted from iTerm configuration
local colors = {
    -- Base colors
    bg = "#1f1f1f",           -- Background
    fg = "#d9dce7",           -- Foreground
    selection = "#4d5367",    -- Visual selection

    -- UI elements
    gutter = "#3c404f",       -- Line numbers, sign column
    comment = "#888888",      -- Comments (medium gray for contrast)

    -- Syntax colors
    red = "#b1646a",          -- Errors, deletions, keywords
    green = "#a8bc8f",        -- Strings, additions
    yellow = "#e5cb92",       -- Warnings, constants
    blue = "#879fbc",         -- Functions, types
    magenta = "#b59db5",      -- Keywords, tags
    cyan = "#93bdcd",         -- Identifiers, special

    -- Bright variants
    bright_black = "#4d5467",
    bright_white = "#e5e7ee",

    -- Derived colors for UI
    bg_light = "#2a2a2a",     -- Slightly lighter than bg
    bg_dark = "#151515",      -- Slightly darker than bg
    fg_dim = "#a0a3ad",       -- Dimmed foreground
}

-- Helper function to set highlight
local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = colors.fg, bg = "NONE" })
hi("NormalNC", { fg = colors.fg, bg = "NONE" })
hi("EndOfBuffer", { bg = "NONE" })
hi("NormalFloat", { fg = colors.fg, bg = colors.bg_light })
hi("FloatBorder", { fg = colors.comment, bg = colors.bg_light })
hi("FloatTitle", { fg = colors.blue, bg = colors.bg_light, bold = true })

-- Line numbers and columns
hi("LineNr", { fg = colors.gutter })
hi("CursorLineNr", { fg = colors.yellow, bold = true })
hi("CursorLine", { bg = colors.bg_light })
hi("CursorColumn", { bg = colors.bg_light })
hi("ColorColumn", { bg = colors.bg_light })
hi("SignColumn", { fg = colors.gutter, bg = "NONE" })

-- Visual selection
hi("Visual", { bg = colors.selection })
hi("VisualNOS", { bg = colors.selection })

-- Search and matching
hi("Search", { fg = colors.bg, bg = colors.yellow })
hi("IncSearch", { fg = colors.bg, bg = colors.yellow, bold = true })
hi("CurSearch", { fg = colors.bg, bg = colors.yellow, bold = true })
hi("MatchParen", { fg = colors.yellow, bold = true })

-- Status and tab lines
hi("StatusLine", { fg = colors.fg, bg = colors.bg_light })
hi("StatusLineNC", { fg = colors.comment, bg = colors.bg_light })
hi("TabLine", { fg = colors.comment, bg = colors.bg_light })
hi("TabLineFill", { bg = colors.bg_light })
hi("TabLineSel", { fg = colors.fg, bg = colors.bg, bold = true })

-- Popups and menus
hi("Pmenu", { fg = colors.fg, bg = colors.bg_light })
hi("PmenuSel", { fg = colors.bg, bg = colors.blue })
hi("PmenuSbar", { bg = colors.bg_light })
hi("PmenuThumb", { bg = colors.comment })

-- Messages
hi("ErrorMsg", { fg = colors.red, bold = true })
hi("WarningMsg", { fg = colors.yellow, bold = true })
hi("ModeMsg", { fg = colors.green, bold = true })
hi("MoreMsg", { fg = colors.cyan })
hi("Question", { fg = colors.cyan })

-- Diff colors
hi("DiffAdd", { fg = colors.green, bg = colors.bg_light })
hi("DiffChange", { fg = colors.yellow, bg = colors.bg_light })
hi("DiffDelete", { fg = colors.red, bg = colors.bg_light })
hi("DiffText", { fg = colors.yellow, bg = colors.selection, bold = true })

-- Spell checking
hi("SpellBad", { undercurl = true, sp = colors.red })
hi("SpellCap", { undercurl = true, sp = colors.yellow })
hi("SpellRare", { undercurl = true, sp = colors.cyan })
hi("SpellLocal", { undercurl = true, sp = colors.cyan })

-- Syntax highlighting
hi("Comment", { fg = colors.comment, italic = true })
hi("Constant", { fg = colors.yellow })
hi("String", { fg = colors.green })
hi("Character", { fg = colors.green })
hi("Number", { fg = colors.yellow })
hi("Boolean", { fg = colors.yellow })
hi("Float", { fg = colors.yellow })

hi("Identifier", { fg = colors.cyan })
hi("Function", { fg = colors.blue })

hi("Statement", { fg = colors.magenta })
hi("Conditional", { fg = colors.magenta })
hi("Repeat", { fg = colors.magenta })
hi("Label", { fg = colors.magenta })
hi("Operator", { fg = colors.fg })
hi("Keyword", { fg = colors.magenta })
hi("Exception", { fg = colors.red })

hi("PreProc", { fg = colors.magenta })
hi("Include", { fg = colors.magenta })
hi("Define", { fg = colors.magenta })
hi("Macro", { fg = colors.magenta })
hi("PreCondit", { fg = colors.magenta })

hi("Type", { fg = colors.blue })
hi("StorageClass", { fg = colors.magenta })
hi("Structure", { fg = colors.blue })
hi("Typedef", { fg = colors.blue })

hi("Special", { fg = colors.cyan })
hi("SpecialChar", { fg = colors.cyan })
hi("Tag", { fg = colors.magenta })
hi("Delimiter", { fg = colors.fg })
hi("SpecialComment", { fg = colors.comment, italic = true })
hi("Debug", { fg = colors.red })

hi("Underlined", { underline = true })
hi("Ignore", { fg = colors.comment })
hi("Error", { fg = colors.red, bold = true })
hi("Todo", { fg = colors.bg, bg = colors.yellow, bold = true })

-- Treesitter highlights
hi("@comment", { link = "Comment" })
hi("@comment.documentation", { fg = colors.comment, italic = true })

hi("@constant", { link = "Constant" })
hi("@string", { link = "String" })
hi("@string.documentation", { fg = colors.comment, italic = true })
hi("@string.documentation.python", { fg = colors.comment, italic = true })
hi("@number", { link = "Number" })
hi("@boolean", { link = "Boolean" })

hi("@function", { link = "Function" })
hi("@function.builtin", { fg = colors.blue, italic = true })
hi("@method", { link = "Function" })

hi("@keyword", { link = "Keyword" })
hi("@keyword.function", { fg = colors.magenta })
hi("@keyword.return", { fg = colors.magenta, bold = true })

hi("@variable", { fg = colors.fg })
hi("@variable.builtin", { fg = colors.cyan, italic = true })
hi("@parameter", { fg = colors.fg_dim })

hi("@type", { link = "Type" })
hi("@type.builtin", { fg = colors.blue, italic = true })

hi("@operator", { link = "Operator" })
hi("@punctuation", { fg = colors.fg_dim })
hi("@punctuation.delimiter", { fg = colors.fg_dim })
hi("@punctuation.bracket", { fg = colors.fg })

hi("@tag", { fg = colors.magenta })
hi("@tag.attribute", { fg = colors.cyan })
hi("@tag.delimiter", { fg = colors.fg_dim })

-- LSP highlights
hi("DiagnosticError", { fg = colors.red })
hi("DiagnosticWarn", { fg = colors.yellow })
hi("DiagnosticInfo", { fg = colors.cyan })
hi("DiagnosticHint", { fg = colors.comment })

hi("DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.cyan })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = colors.comment })

-- Git signs
hi("GitSignsAdd", { fg = colors.green })
hi("GitSignsChange", { fg = colors.yellow })
hi("GitSignsDelete", { fg = colors.red })

-- Telescope
hi("TelescopeBorder", { fg = colors.comment, bg = colors.bg_light })
hi("TelescopeNormal", { fg = colors.fg, bg = colors.bg_light })
hi("TelescopeSelection", { fg = colors.fg, bg = colors.selection, bold = true })
hi("TelescopeMatching", { fg = colors.yellow, bold = true })

-- Which-key
hi("WhichKey", { fg = colors.blue })
hi("WhichKeyGroup", { fg = colors.magenta })
hi("WhichKeyDesc", { fg = colors.fg })
hi("WhichKeySeparator", { fg = colors.comment })

-- Neo-tree
hi("NeoTreeDirectoryIcon", { fg = colors.blue })
hi("NeoTreeDirectoryName", { fg = colors.fg })
hi("NeoTreeFileName", { fg = colors.fg })
hi("NeoTreeFileNameOpened", { fg = colors.green })
hi("NeoTreeGitAdded", { fg = colors.green })
hi("NeoTreeGitModified", { fg = colors.yellow })
hi("NeoTreeGitDeleted", { fg = colors.red })
hi("NeoTreeGitUntracked", { fg = colors.cyan })
