-- Theme configuration is done here as a variable instead of in the return,
-- so that it can be used in the function SetTheme() below, for toggling transparency.
local default_transparency = true -- Set Transparency off/on as default

local theme_opts = {
    catppuccin = {
        custom_highlights = function(colors)
            return {
                LineNr = { fg = '#969696' } -- Make line numbers more visible
            }
        end,
        transparent_background = default_transparency -- catppuccin.nvim’s toggle key
    },
    gruvbox = {
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = false,
        bold = true,
        italic = {
            strings = false,
            emphasis = false,
            comments = false,
            operators = false,
            folds = false
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "",  -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = default_transparency -- gruvbox.nvim’s toggle key
    },
    tokyonight = {
        style = "moon",                     -- default variant
        transparent = default_transparency, -- tokyonight.nvim’s toggle key
        terminal_colors = true,
        styles = {
            comments = { italic = false },
            keywords = { italic = false },
            sidebars = "dark", -- style for sidebars, see below
            floats = "dark"    -- style for floating windows
        }
    },
    ["rose-pine"] = {
        styles = {
            italic = false,
            transparency = default_transparency -- rose-pine’s toggle key
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
    if scheme:match("^catppuccin") then
        theme_opts.catppuccin.transparent_background =
            not theme_opts.catppuccin.transparent_background
        require("catppuccin").setup(theme_opts.catppuccin)
    elseif scheme:match("^gruvbox") then
        theme_opts.gruvbox.transparent_mode =
            not theme_opts.gruvbox.transparent_mode
        require("gruvbox").setup(theme_opts.gruvbox)
    elseif scheme:match("^tokyonight") then
        theme_opts.tokyonight.transparent =
            not theme_opts.tokyonight.transparent
        require("tokyonight").setup(theme_opts.tokyonight)
    elseif scheme:match("^rose[_-]pine") then
        theme_opts["rose-pine"].styles.transparency =
            not theme_opts["rose-pine"].styles.transparency
        require("rose-pine").setup(theme_opts["rose-pine"])
    else
        vim.notify("No transparency toggle configured for “" .. scheme ..
            "”", vim.log.levels.WARN)
        return
    end

    -- reapply exactly the same colorscheme + variant of current
    vim.cmd.colorscheme(scheme)
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

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup(theme_opts.catppuccin)
            SetTheme()
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
