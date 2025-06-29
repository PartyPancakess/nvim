return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },

                logger = {
                    print_log_level = vim.log.levels.OFF,
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
                copilot_model = "GPT-4.1",
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup({
            })
        end
    },


    {
        "olimorris/codecompanion.nvim",
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = {
            "CodeCompanion",
            "CodeCompanionActions",
            "CodeCompanionChat",
            "CodeCompanionCmd",
        },
        keys = {
            { "<leader>ap", "<cmd>CodeCompanionActions<cr>",       mode = { "n", "v" }, desc = "AI Action" },
            { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>",   mode = { "n", "v" }, desc = "AI Toggle Chat" },
            { "<leader>an", "<cmd>CodeCompanionChat<cr>",          mode = { "n", "v" }, desc = "AI New Chat" },
            -- prompts
            { "<leader>ad", "<cmd>CodeCompanionChat Add<CR>",      mode = { "v" },      desc = "AI Add to Chat" },
            { "<leader>ae", "<cmd>CodeCompanion /explain<cr>",     mode = { "v" },      desc = "AI Explain" },
            { "<leader>al", [[:<C-u>'<,'>CodeCompanion /buffer ]], mode = { "v" },      desc = "AI Inline command" },
        },
        config = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = "copilot",
                    },
                    inline = {
                        adapter = "copilot",
                    },
                },

                display = {
                    diff = {
                        enabled = true,
                        provider = "mini_diff",
                    },
                },
            })
        end
    },
}
