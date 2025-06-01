return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = false,
                    auto_refresh = false,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>"
                    },
                    layout = {
                        position = "bottom", -- | top | left | right | horizontal | vertical
                        ratio = 0.4
                    },
                },

                suggestion = {
                    enabled = true,
                    auto_trigger = false,
                    hide_during_completion = true,
                    debounce = 75,
                    trigger_on_accept = true,
                    keymap = {
                        accept = "<C-y>",
                        accept_word = false,
                        accept_line = false,
                        -- next = "<C-k>", -- maybe <C-f>
                        -- prev = "<C-j>", -- <C-b>
                        next = "<C-a>",
                        dismiss = "<C-x>",
                    },
                },
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
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            dependencies = {
                { "zbirenbaum/copilot.lua" },
                { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
            },
            build = "make tiktoken",
            opts = function()
                local user = vim.env.USER or "User"
                user = user:sub(1, 1):upper() .. user:sub(2)
                return {
                    auto_insert_mode = true,
                    question_header = "  " .. user .. " ",
                    answer_header = "  Copilot ",
                    window = {
                        width = 0.4,
                    },
                }
            end,

            keys = {
                {
                    "<leader>aa",
                    function()
                        return require("CopilotChat").toggle()
                    end,
                    desc = "Toggle (CopilotChat)",
                    mode = { "n", "v" },
                },
                {
                    "<leader>ax",
                    function()
                        return require("CopilotChat").reset()
                    end,
                    desc = "Clear (CopilotChat)",
                    mode = { "n", "v" },
                },
                {
                    "<leader>aq",
                    function()
                        vim.ui.input({
                            prompt = "Quick Chat: ",
                        }, function(input)
                            if input ~= "" then
                                require("CopilotChat").ask(input)
                            end
                        end)
                    end,
                    desc = "Quick Chat (CopilotChat)",
                    mode = { "n", "v" },
                },
                {
                    "<leader>ap",
                    function()
                        require("CopilotChat").select_prompt()
                    end,
                    desc = "Prompt Actions (CopilotChat)",
                    mode = { "n", "v" },
                },
            },

            config = function(_, opts)
                local chat = require("CopilotChat")

                vim.api.nvim_create_autocmd("BufEnter", {
                    pattern = "copilot-chat",
                    callback = function()
                        vim.opt_local.relativenumber = false
                        vim.opt_local.number = false
                    end,
                })

                chat.setup(opts)
            end,
        },
    }
}
