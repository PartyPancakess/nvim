local logo = require("partypancakes.resources.art.chuck1")

-- Look for a dashboard-projects file which is a list of directories to be displayed in the 'Projects' section of dashboard,
-- replacing "recent projects".
local function get_project_dirs()
    local config_path = vim.fn.stdpath("config")
    local source_path = config_path .. "/lua/partypancakes/resources/dashboard-projects"
    local target_path = "~/.cache/nvim/dashboard/cache"

    -- Use vim.fn.expand to handle ~ expansion
    source_path = vim.fn.expand(source_path)
    target_path = vim.fn.expand(target_path)

    -- Check if source file exists, create if not
    if vim.fn.filereadable(source_path) == 0 then
        -- Create source directory if it doesn't exist
        local source_dir = vim.fn.fnamemodify(source_path, ":h")
        vim.fn.mkdir(source_dir, "p")

        -- Get home directory
        local home_dir = vim.fn.expand("~")

        -- Create default content
        local default_content = 'return { "' .. config_path .. '" }'

        -- Write default content to source file
        local result = vim.fn.writefile({ default_content }, source_path)
        if result ~= 0 then
            error("Could not create source file: " .. source_path)
        end
    end

    -- Create target directory if it doesn't exist
    local target_dir = vim.fn.fnamemodify(target_path, ":h")
    vim.fn.mkdir(target_dir, "p")

    -- Read source file content
    local content = vim.fn.readfile(source_path, "b")
    if not content then
        error("Could not read source file: " .. source_path)
    end

    -- Write to target file (overwrites if exists)
    local result = vim.fn.writefile(content, target_path, "b")
    if result ~= 0 then
        error("Could not write to target file: " .. target_path)
    end
end

return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        init = function()
            get_project_dirs() -- Comment out to use "recent projects" instead of custom project list
        end,
        config = function()
            require('dashboard').setup {
                shortcut_type = 'number',
                config = {
                    header = logo,
                    shortcut = {
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        { action = "ene | startinsert", desc = "New File", icon = " ", icon_hl = '@variable', group = 'Label', key = "n" },
                        { action = 'lua require("persistence").load()', desc = "Restore Session", icon = " ", icon_hl = '@variable', group = 'Label', key = "r" },
                    },
                    footer = {},

                    project = {
                        enable = true,
                        -- limit = 10,
                        icon = '󰉋 ',
                        label = 'Projects',
                        action = 'Telescope find_files cwd=',
                    },
                },
            }
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }
}
