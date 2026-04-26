-- nvim-cmp: Autocompletion engine
-- Shows completion suggestions as you type (powered by LSP, buffer, paths, etc.)
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",  -- Load when entering insert mode
    dependencies = {
        -- Completion sources
        "hrsh7th/cmp-nvim-lsp",    -- LSP completions
        "hrsh7th/cmp-buffer",      -- Buffer text completions
        "hrsh7th/cmp-path",        -- File path completions

        -- Snippet engine (required by nvim-cmp)
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- Icons in completion menu
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        cmp.setup({
            -- Snippet engine configuration
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            -- Completion window appearance with rounded borders and transparency
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel",
                    scrollbar = true,
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                }),
            },

            -- Formatting: Add icons and source names with enhanced presentation
            formatting = {
                fields = { "kind", "abbr", "menu" },  -- Order: icon, completion text, source
                format = lspkind.cmp_format({
                    mode = 'symbol',  -- Show only icon (text in menu field)
                    maxwidth = 50,
                    ellipsis_char = '...',
                    show_labelDetails = true,
                    before = function(entry, vim_item)
                        -- Add source name with styling
                        local source_names = {
                            nvim_lsp = '[LSP]',
                            luasnip = '[Snip]',
                            buffer = '[Buf]',
                            path = '[Path]',
                        }
                        vim_item.menu = source_names[entry.source.name] or '[' .. entry.source.name .. ']'
                        return vim_item
                    end,
                })
            },

            -- Keybindings
            mapping = cmp.mapping.preset.insert({
                -- Scroll documentation
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                -- Trigger completion
                ['<C-Space>'] = cmp.mapping.complete(),

                -- Close completion
                ['<C-e>'] = cmp.mapping.abort(),

                -- Confirm selection
                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                -- Navigate completions with Tab
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),

            -- Completion sources (order matters - first has priority)
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },   -- LSP completions (highest priority)
                { name = 'luasnip' },    -- Snippet completions
                { name = 'buffer' },     -- Buffer text
                { name = 'path' },       -- File paths
            }),
        })
    end,
}
