vim.g.ministatusline_disable = true

return {
    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - Visually select Around [)]paren
            --  - yinq - Yank Inside Next Quote
            --  - ci'  - Change Inside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - Surround Add Inner Word [)]Paren
            -- - sd'   - Surround Delete [']quotes
            -- - sr)'  - Surround Replace [)] [']
            require('mini.surround').setup({
                mappings = {
                    add = '<leader>sa', -- Add surrounding in Normal and Visual modes
                    delete = '<leader>sd', -- Delete surrounding
                    find = '<leader>sf', -- Find surrounding (to the right)
                    find_left = '<leader>sF', -- Find surrounding (to the left)
                    highlight = '<leader>sh', -- Highlight surrounding
                    replace = '<leader>sr', -- Replace surrounding
                    update_n_lines = '<leader>sn', -- Update `n_lines`

                    suffix_last = 'l', -- Suffix to search with "prev" method
                    suffix_next = 'n', -- Suffix to search with "next" method
                },

            })

            require('mini.diff').setup()
            require('mini.pairs').setup()

            require('mini.misc').setup()
            -- Set working directory to current buffer's project dir
            MiniMisc.setup_auto_root()

            -- ... and more.
            -- https://github.com/echasnovski/mini.nvim
        end,
    }
}
