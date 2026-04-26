-- trouble.nvim: pretty UI for diagnostics, references, quickfix, location list.
-- Pairs with the diagnostic keymaps in config/keymaps.lua.
return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
        focus = true,  -- Focus the Trouble window when opening
    },
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                         desc = "Diagnostics (project)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",            desc = "Diagnostics (buffer)" },
        { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",                 desc = "Document symbols" },
        { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",  desc = "LSP defs/refs/impls" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<CR>",                             desc = "Location list" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>",                              desc = "Quickfix list" },
    },
}
