return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>Gs", vim.cmd.Git, { desc = "Git Status"})
    end
}
