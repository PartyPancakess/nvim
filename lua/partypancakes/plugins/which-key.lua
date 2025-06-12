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
                { '<leader>T', group = 'Theme', icon = '🎨' },
                { '<leader>f', group = 'Find', icon = '🔍' }, -- Telescope
                { '<leader>g', group = 'GoTo', icon = '🔗' }, -- LSP
                { '<leader>G', group = 'Git', icon = '󰊢' },
                { "<leader>a", group = "AI", icon = '🤖', mode = { "n", "v" } },
                { '<leader>t', group = 'Toggle' },
                { '<leader>c', group = 'Code', icon = '⚙️' },
                { '<leader>h', group = 'Harpoon', icon = '📌' },
                { '<leader>b', group = 'Debug', icon = '🐞' },
                { '<leader>bu', group = 'Debug UI', icon = '🖥️' },
                { '<leader>s', group = 'Surround', icon = '🪄' },
                { '<leader>cd', group = 'Dashboard', icon = '🧭' },

                -- Language Templates
                { '<leader>l', group = 'Language', icon = '📜' },
                { '<leader>lg', group = 'Go' }, -- Golang
                { '<leader>lge', group = 'Error Handling', icon = '⚠️' },

                -- Fun Stuff
                { '<leader>.', group = 'Random Fun Stuff', icon = '🎉' },

                -- Non-Groups
                { '<leader>u', icon = '↩️' },
                { '<leader>e', icon = '🗂️' },
                { '<leader>d', icon = '🗑️', mode = { "n", "v" } },
                { '<leader>p', icon = '📥', mode = 'x' },
            },
        },
    }
}
