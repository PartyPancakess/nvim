-- Theme configuration is done here as a variable instead of in the return,
-- so that it can be used in the function SetTheme() below, for toggling transparency.
local default_transparency = true -- Set Transparency off/on as default
local default_focus = false       -- true: Set Transparency off for out-of-focus windows only

local theme_opts = {
    catppuccin = {
        custom_highlights = function()
            return {
                LineNr = { fg = '#969696' }, -- Make line numbers more visible

                CursorLineNr = { bg = '#2F3447', style = { "bold" } },

                -- Blink Completion Menu
                BlinkCmpMenu = { bg = "#282c3d" },
                BlinkCmpDoc = { bg = "#282c3d" },
                BlinkCmpSignatureHelp = { bg = "#282c3d" },
            }
        end,
        transparent_background = default_transparency
    },
    gruvbox = {
        transparent_mode = default_transparency
    },
    tokyonight = {
        transparent = default_transparency,
    },
    ["rose-pine"] = {
        styles = {
            italic = false,
            transparency = default_transparency
        }
    }
}

function SetTheme(color)
    color = color or 0
    if color == 0 then
        vim.cmd.colorscheme("catppuccin-macchiato")
    elseif color == 1 then
        vim.cmd.colorscheme("rose-pine-moon")
    elseif color == 2 then
        vim.cmd.colorscheme("tokyonight-moon")
    else
        vim.cmd.colorscheme("gruvbox")
    end
end

local function toggle_theme_transparency()
    local scheme = vim.g.colors_name or ""

    theme_opts.catppuccin.transparent_background =
        not theme_opts.catppuccin.transparent_background
    require("catppuccin").setup(theme_opts.catppuccin)
    theme_opts.gruvbox.transparent_mode =
        not theme_opts.gruvbox.transparent_mode
    require("gruvbox").setup(theme_opts.gruvbox)
    theme_opts.tokyonight.transparent =
        not theme_opts.tokyonight.transparent
    require("tokyonight").setup(theme_opts.tokyonight)
    theme_opts["rose-pine"].styles.transparency =
        not theme_opts["rose-pine"].styles.transparency
    require("rose-pine").setup(theme_opts["rose-pine"])

    -- reapply exactly the same colorscheme + variant of current
    vim.cmd.colorscheme(scheme)
end

-- Make unfocused windows non-transparent / or / all windows' transparency are the same
local function toggle_focus_transparency()
    default_focus = not default_focus

    theme_opts.gruvbox.transparent_mode = not default_focus
    theme_opts["rose-pine"].styles.transparency = not default_focus
    theme_opts.tokyonight.transparent = not default_focus
    theme_opts.catppuccin.transparent_background = not default_focus

    require("catppuccin").setup(theme_opts.catppuccin)
    require("gruvbox").setup(theme_opts.gruvbox)
    require("tokyonight").setup(theme_opts.tokyonight)
    require("rose-pine").setup(theme_opts["rose-pine"])

    -- reapply exactly the same colorscheme + variant of current
    local scheme = vim.g.colors_name or ""
    vim.cmd.colorscheme(scheme)

    if default_focus then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end
end


-- Keymaps to switch themes

vim.keymap.set("n", "<leader>T0", function() SetTheme(0) end,
    { desc = "Set Catppuccin Macchiato", silent = true })

vim.keymap.set("n", "<leader>T1", function() SetTheme(1) end,
    { desc = "Set Rose Pine Moon", silent = true })

vim.keymap.set("n", "<leader>T2", function() SetTheme(2) end,
    { desc = "Set TokyoNight Moon", silent = true })

vim.keymap.set("n", "<leader>T3", function() SetTheme(3) end,
    { desc = "Set Gruvbox", silent = true })

-- Toggle Opaque/Transparent
vim.keymap.set("n", "<leader>TT", function() toggle_theme_transparency() end,
    { desc = "Toggle Opaque/Transparent", silent = true })

vim.keymap.set("n", "<leader>Tf", function() toggle_focus_transparency() end,
    { desc = "Toggle unfocused window transparency" })


return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup(theme_opts.catppuccin)
            SetTheme()
            if default_focus then
                default_focus = false
                toggle_focus_transparency()
            end
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function() require("gruvbox").setup(theme_opts.gruvbox) end
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup(theme_opts.tokyonight)
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup(theme_opts["rose-pine"])
        end
    }
}
