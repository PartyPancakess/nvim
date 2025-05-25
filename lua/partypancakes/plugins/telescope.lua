return {
    { -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup {
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
                defaults = {
                    path_display = { "truncate" },
                    -- path_display = { "smart" },
                }
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
            local builtin = require 'telescope.builtin'

            -- KEYMAPS


            -- !! FILE NAVIGATION (File Name Searching) !! --

            -- Search All Files
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
            -- Search Only Git Files
            vim.keymap.set('n', '<C-g>', builtin.git_files, { desc = 'Find Git Files' })


            -- !! FIND IN FILES (grep) !! --

            -- Search project with grep
            vim.keymap.set('n', '<leader>fp', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end, { desc = 'Find in Project via Grep' })
            -- Search project with live grep
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find by live Grep' })

            -- Search current word under cursor
            vim.keymap.set('n', '<leader>fw', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end, { desc = 'Find current Word in Project' })
            vim.keymap.set('n', '<leader>fW', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end, { desc = 'Find current WORD in Project' })



            -- !! NON-NAVIGATION SEARCHES !! --
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'find help' })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'find keymaps' })
            vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'find diagnostics' })


            -- Extra mappings
            -- vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Find Resume old search' })
            -- vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = 'Find Select Telescope' })
            vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Find Recent Files by name' })
            -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            -- vim.keymap.set('n', '<leader>f/', function()
            --   builtin.live_grep {
            --     grep_open_files = true,
            --     prompt_title = 'Live Grep in Open Files',
            --   }
            -- end, { desc = 'Find [/] in Open Files' })
        end,
    }
}
