-- Colorscheme configuration - all themes in one place
-- To switch themes: change the ACTIVE_COLORSCHEME variable below

-- ============================================================================
-- CONFIGURATION: Set your active colorscheme here
-- ============================================================================
local ACTIVE_COLORSCHEME = 'iterm-custom'  -- Options: 'iterm-custom', 'hybrid', 'kanagawa', 'kanagawa-paper', 'alduin', 'rusty', 'iceberg', 'nordic'

-- ============================================================================
-- PLUGIN SPECS: Return external colorscheme plugins
-- ============================================================================
-- We return a list of plugin specs. Lazy.nvim will install all of them,
-- but only the one matching ACTIVE_COLORSCHEME will actually activate.

return {
  -- ITERM CUSTOM (Matches your iTerm color palette)
  {
    -- Custom colorscheme - lives in ~/.config/nvim-scratch/colors/
    dir = vim.fn.stdpath("config"),
    name = "iterm-custom",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'iterm-custom' then
        vim.cmd("colorscheme iterm-custom")
      end
    end,
  },

  -- HYBRID
  {
    "HoNamDuong/hybrid.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'hybrid' then
        require("hybrid").setup({
          transparent = false,
        })
        vim.cmd("colorscheme hybrid")
      end
    end,
  },

  -- KANAGAWA
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'kanagawa' then
        vim.cmd("colorscheme kanagawa-dragon")
      end
    end,
  },

  -- KANAGAWA PAPER (with custom background)
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'kanagawa-paper' then
        require("kanagawa-paper").setup({
          transparent = false,  -- Background set in highlights.lua
          overrides = function(colors)
            -- Consistent comment styling for all types
            local comment_style = { fg = "#888888", italic = true }

            return {
              -- Syntax highlighting adjustments
              Comment = comment_style,
              ["@comment"] = comment_style,
              ["@comment.line"] = comment_style,
              ["@comment.block"] = comment_style,
              ["@comment.documentation"] = comment_style,

              -- Python docstrings (technically strings, but treat as comments)
              ["@string.documentation"] = comment_style,
              ["@text.literal.block"] = comment_style,

              Function = { fg = "#6B8CAE" },
              ["@function"] = { fg = "#6B8CAE" },
            }
          end
        })
        vim.cmd("colorscheme kanagawa-paper")
      end
    end,
  },

  -- ALDUIN
  {
    "AlessandroYorba/Alduin",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'alduin' then
        vim.cmd('colorscheme alduin')
      end
    end,
  },

  -- RUSTY
  {
    "armannikoyan/rusty",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'rusty' then
        vim.cmd("colorscheme rusty")
      end
    end,
  },

  -- ICEBERG
  {
    "oahlen/iceberg.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'iceberg' then
        vim.cmd("colorscheme iceberg")
      end
    end,
  },

  -- NORDIC
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      if ACTIVE_COLORSCHEME == 'nordic' then
        require('nordic').setup({
          transparent = {
            bg = true,
            float = true
          },
        })
        require('nordic').load()
      end
    end,
  },
}

-- ============================================================================
-- HOW TO SWITCH COLORSCHEMES
-- ============================================================================
-- 1. Change ACTIVE_COLORSCHEME at the top of this file
-- 2. Restart NeoVim
-- 3. Only the active theme's config() runs, but all are available
--
-- Example:
--   local ACTIVE_COLORSCHEME = 'kanagawa'  -- Switch to kanagawa
--   local ACTIVE_COLORSCHEME = 'custom'    -- Switch back to custom
--
-- You can also manually switch at runtime:
--   :colorscheme hybrid      -- All themes autocomplete!
--   :colorscheme kanagawa-wave
--   :colorscheme custom
--
-- Benefits of this approach:
-- - All themes installed and in runtimepath (autocomplete works)
-- - Only active theme runs setup/config (no conflicts)
-- - Easy to switch without commenting/uncommenting
-- - Can try themes with :colorscheme command before changing config
-- - Single source of truth (ACTIVE_COLORSCHEME variable)
--
-- Technical details:
-- - lazy = false: Adds plugin to runtimepath immediately
-- - cond = ...: Conditionally runs config() based on ACTIVE_COLORSCHEME
-- - All plugins' colors/ directories are searchable
-- - Minimal startup impact (just adding to runtimepath, not running setup)
