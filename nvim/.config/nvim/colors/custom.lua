-- Custom colorscheme definition
-- This file follows the standard NeoVim colorscheme pattern
-- and lives in colors/ directory

-- Clear any existing syntax highlighting
vim.cmd('highlight clear')

-- Reset syntax if previously enabled
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

-- Name this colorscheme (what shows up in :colorscheme command)
vim.g.colors_name = 'custom'

-- Specify dark background mode
vim.o.background = 'dark'

-- ============================================================================
-- COLOR PALETTE
-- ============================================================================
-- Define all colors in one place for easy tweaking
local colors = {
  bg = '#1e1e1e',           -- Main background (dark gray)
  fg = '#d4d4d4',           -- Main text/foreground (light gray)
  comment = '#6a9955',      -- Comments (green)
  keyword = '#569cd6',      -- Keywords like 'local', 'function' (blue)
  string = '#ce9178',       -- String literals (orange)
  function_name = '#dcdcaa', -- Function names (yellow)
  line_number = '#858585',  -- Line numbers in gutter
  cursorline_bg = '#2d2d2d', -- Current line background
  visual_bg = '#264f78',    -- Selection background (dark blue)
}

-- ============================================================================
-- HELPER FUNCTION
-- ============================================================================
-- Helper to set highlight groups without repetitive vim.cmd strings
local function hi(group, opts)
  local cmd = 'highlight ' .. group
  if opts.fg then cmd = cmd .. ' guifg=' .. opts.fg end
  if opts.bg then cmd = cmd .. ' guibg=' .. opts.bg end
  if opts.style then cmd = cmd .. ' gui=' .. opts.style end
  vim.cmd(cmd)
end

-- ============================================================================
-- SYNTAX HIGHLIGHTING GROUPS
-- ============================================================================
-- Basic syntax groups used by TreeSitter and legacy syntax

hi('Normal', { fg = colors.fg, bg = colors.bg })
hi('Comment', { fg = colors.comment, style = 'italic' })
hi('Keyword', { fg = colors.keyword })
hi('String', { fg = colors.string })
hi('Function', { fg = colors.function_name })

-- ============================================================================
-- UI ELEMENTS
-- ============================================================================
-- Editor interface elements

hi('LineNr', { fg = colors.line_number, bg = colors.bg })
hi('CursorLine', { bg = colors.cursorline_bg })
hi('Visual', { bg = colors.visual_bg })

-- ============================================================================
-- EXTENDING THIS COLORSCHEME
-- ============================================================================
-- Common highlight groups to add:
--
-- Syntax groups:
--   - Identifier, Constant, Number, Boolean, Float
--   - Type, Structure, Typedef
--   - PreProc, Include, Define, Macro
--   - Special, SpecialChar, Tag, Delimiter
--   - Error, Warning, Todo
--
-- UI groups:
--   - StatusLine, StatusLineNC
--   - VertSplit, WinSeparator
--   - Pmenu, PmenuSel, PmenuSbar, PmenuThumb
--   - Search, IncSearch
--   - Directory, Title
--
-- TreeSitter groups (modern):
--   - @variable, @parameter, @property
--   - @type, @type.builtin
--   - @function.builtin, @method
--   - @keyword.return, @conditional, @repeat
--
-- LSP groups:
--   - DiagnosticError, DiagnosticWarn, DiagnosticInfo, DiagnosticHint
--   - LspReferenceText, LspReferenceRead, LspReferenceWrite
--
-- Git groups (for gitsigns.nvim):
--   - GitSignsAdd, GitSignsChange, GitSignsDelete
--
-- Use :Inspect to see what highlight group is under your cursor
-- Use :highlight to list all active highlight groups
