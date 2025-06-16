return {
    {
        'AndrewRadev/switch.vim',
        config = function()
            -- Disable default mapping
            -- vim.g.switch_mapping = ''

            -- vim.g.switch_custom_definitions = {
            --     -- Boolean toggles
            --     ['True'] = 'False',
            --     ['true'] = 'false',
            --     ["TRUE"] = "FALSE",
            --     ['YES']  = 'NO',
            --     ['yes']  = 'no',
            --     ["Yes"]  = "No",
            --
            --     ['Left'] = 'Right',
            --     ['left'] = 'right',
            --     ['up']   = 'down',
            --     ['On']   = 'Off',
            --     ['on']   = 'off',
            --
            --     ["1"]    = "0",
            --     ["<"]    = ">",
            --     ["("]    = ")",
            --     ["["]    = "]",
            --     ["{"]    = "}",
            --     ['"']    = "'",
            --     ['""']   = "''",
            --     ["+"]    = "-",
            --     ["==="]  = "!==",
            --     ["=="]   = "!="
            -- }

            vim.keymap.set({ 'n', 'v', 'o' }, '<leader>cs', '<Cmd>Switch<CR>', {
                desc = 'Switch text under cursor',
                silent = true,
            })
        end,
    },
}
