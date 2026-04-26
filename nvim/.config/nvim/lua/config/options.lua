-- ============================================================================
-- DISPLAY / UI
-- ============================================================================

-- Line numbers
vim.opt.number = true           -- Show absolute line number on cursor line
vim.opt.relativenumber = true   -- Show relative line numbers for easier jumping (5j, 3k)

-- Visual guides
vim.opt.colorcolumn = '120'     -- Vertical line at column 120 (modern code width limit)
vim.opt.cursorline = true       -- Highlight the line where cursor is located
vim.opt.signcolumn = 'yes'      -- Always show sign column (prevents text shifting when signs appear)

-- Colors
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors (required for modern themes)

-- Floating window aesthetics
vim.opt.pumblend = 15           -- Enhanced transparency for popup menus (completion, etc.)
vim.o.winborder = 'rounded'     -- Default border style for all floating windows (LSP hover, signature, etc.)

-- Scrolling
vim.opt.scrolloff = 10          -- Keep 10 lines visible above/below cursor when scrolling
vim.opt.wrap = false            -- Don't wrap long lines (horizontal scrolling instead)
vim.opt.breakindent = true      -- Preserve indentation for wrapped lines (useful in markdown)

-- Whitespace visualization
vim.opt.list = true             -- Show invisible characters (tabs, trailing spaces)
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- ============================================================================
-- BEHAVIOR
-- ============================================================================

-- Mouse
vim.opt.mouse = 'a'             -- Enable mouse in all modes (n, v, i, c)

-- Clipboard
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard for yank/paste

-- Splits
vim.opt.splitbelow = true       -- Horizontal splits open below current window
vim.opt.splitright = true       -- Vertical splits open to the right

-- Undo/Backup
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'  -- Centralize undo files
vim.opt.undofile = true         -- Persist undo history between sessions
vim.opt.swapfile = false        -- Disable swap files (modern systems auto-save)

-- File watching
vim.opt.autoread = true         -- Allow auto-reload (requires autocmd calling checktime, see below)

-- Commands
vim.opt.inccommand = 'split'    -- Show live preview of substitute commands in split window
vim.opt.confirm = true          -- Confirm before quitting unsaved buffers (instead of error)

-- ============================================================================
-- SEARCH
-- ============================================================================

vim.opt.ignorecase = true       -- Case-insensitive search by default
vim.opt.smartcase = true        -- Override ignorecase if search contains uppercase
vim.opt.hlsearch = false        -- Don't highlight all search matches (can be distracting)

-- ============================================================================
-- INDENTATION
-- ============================================================================
-- Default: 4 spaces (override per-filetype with .editorconfig)

vim.opt.tabstop = 4             -- Width of a TAB character (in spaces)
vim.opt.shiftwidth = 4          -- Spaces to use for each step of (auto)indent
vim.opt.softtabstop = 4         -- Spaces to insert/delete when pressing TAB/Backspace
vim.opt.expandtab = true        -- Convert TAB key presses to spaces
vim.opt.shiftround = true       -- Round indent to multiple of shiftwidth (for << and >>)

-- ============================================================================
-- COMPLETION
-- ============================================================================

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

vim.opt.updatetime = 250        -- Faster completion and diagnostics (default: 4000ms)
vim.opt.timeoutlen = 300        -- Time to wait for mapped sequence to complete (ms)

-- ============================================================================
-- FILE TYPE SPECIFIC SETTINGS
-- ============================================================================

-- Markdown/text files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'md', 'text' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
  desc = 'Enable spell check and line wrap for markdown/text files',
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ============================================================================
-- AUTO-RELOAD FILES
-- ============================================================================

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'CursorHold' }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = '*',
  desc = 'Auto-reload files changed outside NeoVim (catches edits while sitting in buffer too)',
})

-- Notify when an external edit triggers a buffer reload (e.g. Claude Code edits)
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  callback = function()
    vim.notify('Reloaded: ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
  end,
  desc = 'Surface silent external-edit reloads',
})

-- ============================================================================
-- KEYMAPS
-- ============================================================================
-- Note: Most keymaps should go in lua/config/keymaps.lua
-- These are kept here for convenience

-- Clear search highlighting on Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
