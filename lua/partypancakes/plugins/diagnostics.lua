return {
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = {
            { "<leader>tT", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Trouble - All Diagnostics" },
            { "<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble - Buffer Diagnostics" },
        },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup({
                preset = "ghost",
                options = {
                    show_all_diags_on_cursorline = true,
                }
            })
            vim.diagnostic.config({ virtual_text = false })


            -- Toggle between current-line diagnostics to buffer-wide diagnostics
            vim.keymap.set("n", "<leader>td", function()
                if vim.diagnostic.config().virtual_text == false then
                    vim.diagnostic.config({
                        virtual_text = {
                            source = false,
                            prefix = '● ',
                            current_line = false,
                        },
                    })
                    require("tiny-inline-diagnostic").disable()
                else
                    vim.diagnostic.config({ virtual_text = false })
                    require("tiny-inline-diagnostic").toggle()
                end
            end, { desc = 'Toggle Diagnostics' })
        end
    }
}
