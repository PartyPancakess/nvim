return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local harpoon_extensions = require("harpoon.extensions")

        harpoon:setup()
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

        -- Configure For Use with Telescope as another option to default UI
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        -- Open Harpoon Window
        vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Toggle the Harpoon quick menu" })
        vim.keymap.set("n", "<leader>ht", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open Harpoon with Telescope" })

        -- Navigate Between Buffers
        vim.keymap.set("n", "<leader>hA", function() harpoon:list():prepend() end,
            { desc = "Prepend an item to the Harpoon list" })
        vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end,
            { desc = "Add an item to the Harpoon list" })
        -- Toggle previous & next buffers stored within Harpoon list

        -- 2 Options: Either use Ctrl + p/n or Meta + Shift + p/n
        -- Meta is reserved for TMUX operations, but Meta + Shift + p/n is unused, so viable.
        -- Ctrl + p/n is already used by conform (autocompletion), but only in insert mode.

        -- vim.keymap.set("n", "<M-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon Previous" })
        -- vim.keymap.set("n", "<M-S-N>", function() harpoon:list():next() end, { desc = "Harpoon Next" })

        vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon Previous" })
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon Next" })
    end
}
