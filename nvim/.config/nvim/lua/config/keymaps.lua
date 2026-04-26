-- Set leader keys BEFORE loading plugins
-- Leader: prefix for global custom shortcuts (works everywhere)
vim.g.mapleader = ' '

-- LocalLeader: prefix for filetype-specific shortcuts (Python, Markdown, etc.)
vim.g.maplocalleader = '\\'

-- Quick escape from insert mode without reaching for Esc key
-- Typing 'jj' quickly in insert mode returns to normal mode
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- Diagnostic navigation (works regardless of LSP plugin load state)
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })

vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })

vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[C]ode [D]iagnostic float' })
vim.keymap.set('n', '<leader>q', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Trouble)' })
