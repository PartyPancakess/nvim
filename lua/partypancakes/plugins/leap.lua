return {
    {
        "ggandor/leap.nvim",
        enabled = true,
        config = function()
            vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap)', { desc = "Leap Forward to"} )
            vim.keymap.set('n', 'F', '<Plug>(leap-from-window)', { desc = "Leap from Windows"} )
        end,
    },
}
