-- Statusline to give us valuable information.
return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function()
        -- Custom lualine theme matching iterm-custom colorscheme
        local colors = {
            bg = '#1f1f1f',       -- Matches editor background
            fg = '#d9dce7',       -- Foreground
            bg_light = '#2a2a2a', -- Slightly lighter for contrast

            -- Mode colors from iTerm palette
            normal = '#879fbc',   -- Blue
            insert = '#a8bc8f',   -- Green
            visual = '#b59db5',   -- Magenta
            replace = '#b1646a',  -- Red
            command = '#e5cb92',  -- Yellow

            -- UI colors
            inactive = '#4d5367', -- Dimmed sections
            text = '#d9dce7',     -- Text on colored backgrounds
        }

        local custom_theme = {
            normal = {
                a = { bg = colors.normal, fg = colors.bg, gui = 'bold' },
                b = { bg = colors.bg_light, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
                a = { bg = colors.insert, fg = colors.bg, gui = 'bold' },
            },
            visual = {
                a = { bg = colors.visual, fg = colors.bg, gui = 'bold' },
            },
            replace = {
                a = { bg = colors.replace, fg = colors.bg, gui = 'bold' },
            },
            command = {
                a = { bg = colors.command, fg = colors.bg, gui = 'bold' },
            },
            inactive = {
                a = { bg = colors.bg, fg = colors.inactive },
                b = { bg = colors.bg, fg = colors.inactive },
                c = { bg = colors.bg, fg = colors.inactive },
            },
        }

        -- Powerline separator characters (using Neovim's nr2char)
        local separators = {
            component = {
                left = vim.fn.nr2char(0xe0b1),   -- Powerline right angle
                right = vim.fn.nr2char(0xe0b3)   -- Powerline left angle
            },
            section = {
                left = vim.fn.nr2char(0xe0b0),   -- Powerline right triangle
                right = vim.fn.nr2char(0xe0b2)   -- Powerline left triangle
            },
        }

        require('lualine').setup({
            options = {
                theme = custom_theme,
                globalstatus = true,  -- Single statusline for all windows
                component_separators = separators.component,
                section_separators = separators.section,
            }
        })

        vim.opt.showmode = false -- lualine will display the mode for us
    end
}
