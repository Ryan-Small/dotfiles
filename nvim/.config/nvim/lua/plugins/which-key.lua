return {                -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.o.timeoutlen
        delay = 200,  -- 200ms prevents modal hangs while still feeling instant
        icons = {
            -- set icon mappings to true if you have a Nerd Font
            mappings = true,
            -- Empty table uses which-key's default Nerd Font icons
            keys = {},
        },
        win = {
            border = "rounded",  -- Rounded borders for which-key popup
            padding = { 1, 2 },  -- Add breathing room: 1 line vertical, 2 cols horizontal
            wo = {
                winblend = 15,  -- Enhanced transparency for floating feel
            },
        },

        -- Document existing key chains
        spec = {
            { '<leader>s', group = '[S]earch' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
    },
}
