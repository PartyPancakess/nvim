local logo = require("partypancakes.resources.art.chuck1")

return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                -- hide = {
                --     statusline = false,
                -- },
                config = {
                    header = logo,
                    shortcut = {
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        { action = "ene | startinsert", desc = "New File", icon = " ", icon_hl = '@variable', group = 'Label', key = "n" },
                        { action = 'lua require("persistence").load()', desc = "Restore Session", icon = " ", icon_hl = '@variable', group = 'Label', key = "s" },
                    },
                    footer = {},
                },
            }
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }
}
