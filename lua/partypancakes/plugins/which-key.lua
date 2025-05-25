return {
    { -- Show pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = {
            delay = 0,
            icons = {
                mappings = vim.g.have_nerd_font,
                keys = vim.g.have_nerd_font and {},
            },
            -- sort = { "group" },

            -- Document existing key chains/groups
            spec = {
                -- Groups

                -- Theme
                { '<leader>T', group = 'Theme', icon = '🎨' },

                -- Telescope
                { '<leader>f', group = 'Find', icon = '🔍' },

                -- LSP
                { '<leader>g', group = 'GoTo & Git', icon = '🔗' },
                { '<leader>gt', group = 'GoTo', icon = '🔗' },
                { '<leader>gs', icon = '🐙' },

                -- Language Templates
                { '<leader>l', group = 'Language', icon = '📜' },
                { '<leader>lg', group = 'Go' }, -- Golang
                { '<leader>lge', group = 'Error Handling', icon = '⚠️' },

                -- Fun Stuff
                { '<leader>.', group = 'Random Fun Stuff', icon = '🎉' },

                { '<leader>t', group = 'Toggle' },

                { '<leader>h', group = 'Harpoon', icon = '📌' },

                { '<leader>b', group = 'Debug', icon = '🐞' },
                { '<leader>bu', group = 'Debug UI', icon = '🖥️' },


                -- Non-Groups
                { '<leader>u', icon = '↩️' },
                { '<leader>e', icon = '🗂️' },
                { '<leader>d', icon = '🗑️', mode = { "n", "v" } },
                { '<leader>p', icon = '📥', mode = 'x' },
                { '<leader>s', icon = '🪄' },
            },
        },
    }
}
