-- Diffview: side-by-side review of git diffs and file history
-- Useful when reviewing multi-file edits (e.g. from Claude Code) before staging.
return {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewFileHistory",
    },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<CR>",          desc = "[G]it [D]iffview (vs HEAD)" },
        { "<leader>gD", "<cmd>DiffviewClose<CR>",         desc = "[G]it [D]iffview close" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "[G]it file [H]istory" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<CR>",   desc = "[G]it project [H]istory" },
    },
    config = function()
        require("diffview").setup({
            enhanced_diff_hl = true,
            view = {
                default = { winbar_info = true },
                file_history = { winbar_info = true },
            },
        })
    end,
}
