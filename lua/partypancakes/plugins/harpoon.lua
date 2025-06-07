function HarpoonChangeData()
    -- Change Plugin Behavior
    -- Replace     local h = hash(filename(config)) to local h = "myfiles"
    -- in harpoon/lua/harpoon/data.lua to save all data in a singe file.
    local plugin_path = vim.fn.stdpath("data") .. "/lazy/harpoon/lua/harpoon/data.lua"

    local lines = {}
    for line in io.lines(plugin_path) do
        if line:match("^%s*local%s+h%s*=%s*hash%s*%(%s*filename%s*%(%s*config%s*%)%s*%)%s*$") then
            table.insert(lines, 'local h = "myfiles"')
        else
            table.insert(lines, line)
        end
    end

    local file = io.open(plugin_path, "w")
    if file ~= nil then
        file:write(table.concat(lines, "\n"))
        file:close()
    end
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "echasnovski/mini.nvim",
    },
    build = function()
        HarpoonChangeData()
    end,
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

        -- Ctrl + p/n is already used by conform (autocompletion), but only in insert mode.
        vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon Previous" })
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon Next" })
    end
}
