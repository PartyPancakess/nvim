return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>Gs", vim.cmd.Git, { desc = "Git Status" })
        vim.keymap.set("n", "<leader>Gp", function()
            local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
            vim.cmd.Git("pull origin " .. branch)
        end, { desc = "Git pull" })
    end
}
