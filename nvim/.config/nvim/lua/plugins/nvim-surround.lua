-- Surround text objects with brackets, quotes, tags, etc.
-- Usage:
--   ys{motion}{char} - Add surround (e.g., ysiw" to surround word with quotes)
--   ds{char} - Delete surround (e.g., ds" to remove quotes)
--   cs{old}{new} - Change surround (e.g., cs"' to change " to ')
return {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Default keymaps:
            --   Normal mode: ys{motion}{char} - add surround
            --   Normal mode: ds{char} - delete surround
            --   Normal mode: cs{old}{new} - change surround
            --   Visual mode: S{char} - surround selection
        })
    end
}
