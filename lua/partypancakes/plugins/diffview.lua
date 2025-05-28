return {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("diffview").setup({
            enhanced_diff_hl = true,
            use_icons = true,
            file_panel = {
                win_config = {
                    position = "left",
                    width = 35,
                },
            },
        })

        -- Close current tab
        vim.keymap.set("n", "<leader>Dc", function()
            vim.cmd("tabclose")
        end, { desc = "Tab Close" })

        -- Toggle Diffview: open if closed, close if open
        vim.keymap.set("n", "<leader>Dt", function()
            local view = require("diffview.lib").get_current_view()
            if view then
                vim.cmd("DiffviewClose")
            else
                vim.cmd("DiffviewOpen")
            end
        end, { desc = "Toggle Diffview" })

        -- Open File History
        vim.keymap.set("n", "<leader>Dh", function()
            vim.cmd("DiffviewFileHistory")
        end, { desc = "Git History" })

        -- Open File History for only the current file
        vim.keymap.set("n", "<leader>Df", function()
            vim.cmd("DiffviewFileHistory %")
        end, { desc = "Git Current File History" })
    end,
}
