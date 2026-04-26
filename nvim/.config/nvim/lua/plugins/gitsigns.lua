-- Git integration - shows git changes in sign column and provides hunk operations
return {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            current_line_blame = false,  -- Disabled: use <leader>tb to toggle or <leader>hb for full blame
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation between hunks
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr=true, desc = 'Next git hunk'})

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr=true, desc = 'Previous git hunk'})

                -- Hunk actions
                map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
                map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
                map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[H]unk [S]tage (visual)' })
                map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = '[H]unk [R]eset (visual)' })
                map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage buffer' })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk [U]ndo stage' })
                map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset buffer' })
                map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
                map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = '[H]unk [B]lame line' })
                map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle git [B]lame' })
                map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff this' })
                map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = '[H]unk [D]iff this ~' })
                map('n', '<leader>td', gs.toggle_deleted, { desc = '[T]oggle [D]eleted' })

                -- Text object for hunks
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
            end
        })
    end,
}
