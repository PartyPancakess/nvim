return {
    {
        "ggandor/leap.nvim",
        enabled = true,
        config = function()
            vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = "Leap Forward to"} )
            vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = "Leap from Windows"} )
        end,
    },
}
