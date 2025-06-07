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
            require('mini.surround').setup()


            require('mini.misc').setup()
            -- Set working directory to current buffer's project dir
            MiniMisc.setup_auto_root()

            -- ... and more.
            -- https://github.com/echasnovski/mini.nvim
        end,
    }
}
