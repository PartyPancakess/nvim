vim.g.enable_dashboard_mru = false

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

-- add the current git project to the list of projects
local function add_project()
    -- add the current project (if does not exist already), to the projects list file.

    local path = Get_Git_Root()
    if path == nil then
        return
    end

    local config_path = vim.fn.stdpath("config")
    local file_path = vim.fn.expand(config_path .. "/lua/partypancakes/resources/dashboard-projects")

    -- read the existing file (if it exists)
    local existing = {}
    local fh = io.open(file_path, "r")
    if fh then
        local chunk = fh:read("*a")
        fh:close()

        -- safely load() the chunk; it should return a table
        local ok, tbl = pcall(load(chunk))
        if ok and type(tbl) == "table" then
            existing = tbl
        else
            -- if load() fails or doesn't return a table, start fresh
            existing = {}
        end
    end

    -- check if path is already in 'existing'
    for _, v in ipairs(existing) do
        if v == path then
            return
        end
    end

    -- append and rewrite the file as a Lua table literal
    table.insert(existing, path)

    local outfh = assert(io.open(file_path, "w"), "Could not open file for writing: " .. file_path)
    outfh:write("return {\n")
    for _, v in ipairs(existing) do
        outfh:write(string.format("  %q,\n", v))
    end
    outfh:write("}\n")
    outfh:close()
end

local function refresh_dashboard()
    -- Find all dashboard buffers and delete them
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            local ok, ft = pcall(vim.api.nvim_buf_get_option, buf, "filetype")
            if ok and ft == "dashboard" then
                -- Close this buffer
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
    -- Open the dashboard in the current window
    vim.cmd("Dashboard")
end

local function remove_project_under_cursor()
    -- Get the current line (project path) under the cursor
    local line = vim.api.nvim_get_current_line()
    local path = line:match("^%s*[^%s]*%s+(.-)%s*$")
    if not path then
        return
    end
    path = vim.fn.expand(path)

    -- Load dashboard-projects file
    local config_path = vim.fn.stdpath("config")
    local file_path = vim.fn.expand(config_path .. "/lua/partypancakes/resources/dashboard-projects")

    -- Read existing projects
    local projects = {}
    local fh = io.open(file_path, "r")
    if fh then
        local chunk = fh:read("*a")
        fh:close()
        local ok, tbl = pcall(load(chunk))
        if ok and type(tbl) == "table" then
            projects = tbl
        end
    end

    -- Remove the selected path
    local new_projects = {}
    for _, v in ipairs(projects) do
        if v ~= path then
            table.insert(new_projects, v)
        end
    end

    -- Write back to file
    local outfh = assert(io.open(file_path, "w"), "Could not open file for writing: " .. file_path)
    outfh:write("return {\n")
    for _, v in ipairs(new_projects) do
        outfh:write(string.format('  "%s",\n', v))
    end
    outfh:write("}\n")
    outfh:close()

    get_project_dirs()

    refresh_dashboard()
end

-- Move the projects in the list (re-order)
local function move_in_list(direction)
    -- Get the current line (project path) under the cursor
    local line = vim.api.nvim_get_current_line()
    local path = line:match("^%s*[^%s]*%s+(.-)%s*$")
    if not path then
        return
    end
    path = vim.fn.expand(path)

    -- Load dashboard-projects file
    local config_path = vim.fn.stdpath("config")
    local file_path = vim.fn.expand(config_path .. "/lua/partypancakes/resources/dashboard-projects")

    -- Read existing projects
    local projects = {}
    local fh = io.open(file_path, "r")
    if fh then
        local chunk = fh:read("*a")
        fh:close()
        local ok, tbl = pcall(load(chunk))
        if ok and type(tbl) == "table" then
            projects = tbl
        end
    end

    if direction == "up" then
        -- Move the selected path one up in the list order
        for i, v in ipairs(projects) do
            if v == path and i < #projects then
                projects[i], projects[i + 1] = projects[i + 1], projects[i]
                break
            end
        end
    elseif direction == "down" then
        -- Move the selected path one down in the list order
        for i, v in ipairs(projects) do
            if v == path and i > 1 then
                projects[i], projects[i - 1] = projects[i - 1], projects[i]
                break
            end
        end
    end

    -- Write back to file
    local outfh = assert(io.open(file_path, "w"), "Could not open file for writing: " .. file_path)
    outfh:write("return {\n")
    for _, v in ipairs(projects) do
        outfh:write(string.format('  "%s",\n', v))
    end
    outfh:write("}\n")
    outfh:close()

    get_project_dirs()

    refresh_dashboard()
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
                        { action = 'lua require("persistence").load({ last = true })', desc = "Restore Session", icon = " ", icon_hl = '@variable', group = 'Label', key = "r" },

                        { action = remove_project_under_cursor, desc = "Remove Project From List", icon = "X ", icon_hl = '@variable', group = 'Label', key = "x" },
                    },
                    footer = {},

                    project = {
                        enable = true,
                        -- limit = 10,
                        icon = '󰉋 ',
                        label = 'Projects',
                        action = 'Telescope find_files cwd=',
                    },
                    mru = { enable = vim.g.enable_dashboard_mru },
                },
            }

            vim.keymap.set("n", "<leader>cda", add_project, { desc = "Dashboard - Add Project to List" })
            vim.keymap.set("n", "<leader>cdd", function () move_in_list("down") end, { desc = "Dashboard - Move Project Down" })
            vim.keymap.set("n", "<leader>cdu", function () move_in_list("up") end, { desc = "Dashboard - Move Project Up" })
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }
}
