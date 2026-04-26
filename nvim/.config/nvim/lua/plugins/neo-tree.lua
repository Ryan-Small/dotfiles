-- Replacement for netrw
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        {
            "s1n7ax/nvim-window-picker",
            version = "2.*",
            config = function()
                require("window-picker").setup({
                    filter_rules = {
                        include_current_win = false,
                        autoselect_one = true,
                        bo = {
                            filetype = { "neo-tree", "neo-tree-popup", "notify" },
                            buftype = { "terminal", "quickfix" },
                        }
                    }
                })
            end
        }
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = false, -- Don't close if neo-tree is last window
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            default_component_configs = {
                indent = {
                    indent_size = 2,
                    padding = 1,
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "",
                    default = "",
                },
                git_status = {
                    symbols = {
                        added     = "✚",
                        modified  = "",
                        deleted   = "✖",
                        renamed   = "󰁕",
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = "",
                    }
                },
            },
            filesystem = {
                hijack_netrw_behavior = "open_current",
                filtered_items = {
                    visible = true, -- Show hidden files by default
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true, -- Highlight current file
                    leave_dirs_open = false,
                },
                use_libuv_file_watcher = true, -- Auto-refresh on file changes
            },
            window = {
                position = "left",
                width = 35,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
            }
        })

        -- Primary keymap: left sidebar toggle
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left toggle<CR>', { desc = 'Toggle file explorer' })
        -- Secondary: floating mode for quick access
        vim.keymap.set('n', '<leader>e', ':Neotree filesystem float<CR>', { desc = 'Float file explorer' })
        -- Buffers in left sidebar
        vim.keymap.set('n', '<leader>b', ':Neotree buffers left toggle<CR>', { desc = 'Toggle buffer list' })
    end
}
