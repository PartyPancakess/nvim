return {
    {
        "eandrju/cellular-automaton.nvim",
        config = function()
            vim.keymap.set("n", "<leader>.r", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "FML" })
        end
    },
    -- Other Stuff
}
