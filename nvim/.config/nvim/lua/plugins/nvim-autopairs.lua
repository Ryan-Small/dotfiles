-- Auto-insert closing brackets, quotes, etc.
return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true,  -- Enable treesitter integration
            ts_config = {
                lua = {'string'},         -- Don't add pairs in lua string nodes
                javascript = {'template_string'},
            }
        })

        -- Integration with nvim-cmp
        -- Auto-insert closing bracket after selecting completion item
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
}
