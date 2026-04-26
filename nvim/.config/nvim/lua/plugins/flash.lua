-- flash.nvim: 2-keystroke jumps anywhere on screen via labels.
-- Note: `s` in normal mode normally means "substitute character" — flash takes
-- that key. Use `cl` for the same effect if needed.
return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter search" },
        { "<C-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle flash search" },
    },
}
