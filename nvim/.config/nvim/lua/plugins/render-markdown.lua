-- render-markdown.nvim: in-buffer rendering of markdown (rendered in normal mode,
-- raw source in insert mode). Replaces markview.nvim (incompatible with the
-- nvim-treesitter master branch on Neovim 0.12+).
return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- Render in normal/command/terminal modes; show raw source in insert/visual
        -- so editing isn't disrupted by virtual text.
        render_modes = { "n", "c", "t" },
        code = {
            style = "normal",  -- Background highlight only (no full language banner)
            border = "thin",
        },
        heading = {
            sign = false,      -- No sign-column heading icon
            position = "inline",
        },
    },
}
