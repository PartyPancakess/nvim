-- Theme configuration is done here as a variable instead of in the return,
-- so that it can be used in the function SetTheme() below, for toggling transparency.
local current_transparency = true -- Set Transparency off/on as default
local current_focus = false -- true: Set Transparency off for out-of-focus windows only

local theme_opts = {
	catppuccin = {
		custom_highlights = function(colors)
			return {
				LineNr = { fg = "#969696" }, -- Make line numbers more visible

				CursorLineNr = { bg = "#2F3447", style = { "bold" } },

				-- Blink Completion Menu
				BlinkCmpMenu = { bg = "#282c3d" },
				BlinkCmpDoc = { bg = "#282c3d" },
				BlinkCmpSignatureHelp = { bg = "#282c3d" },
			}
		end,
		transparent_background = current_transparency,
	},
	gruvbox = {
		transparent_mode = current_transparency,
	},
	tokyonight = {
		transparent = current_transparency,
	},
	["rose-pine"] = {
		styles = {
			italic = false,
			transparency = current_transparency,
		},
	},
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

	-- Apply floating window transparency if enabled
	if current_transparency then
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	end
end

local function toggle_theme_transparency()
	local scheme = vim.g.colors_name or ""

	current_transparency = not current_transparency

	theme_opts.catppuccin.transparent_background = current_transparency
	theme_opts.gruvbox.transparent_mode = current_transparency
	theme_opts.tokyonight.transparent = current_transparency
	theme_opts["rose-pine"].styles.transparency = current_transparency

	require("catppuccin").setup(theme_opts.catppuccin)
	require("gruvbox").setup(theme_opts.gruvbox)
	require("tokyonight").setup(theme_opts.tokyonight)
	require("rose-pine").setup(theme_opts["rose-pine"])

	-- reapply exactly the same colorscheme + variant of current
	vim.cmd.colorscheme(scheme)

	-- Apply or remove floating window transparency based on new state
	if current_transparency then
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	else
		-- Reset to default when transparency is disabled (theme-specific defaults would apply)
		vim.api.nvim_set_hl(0, "NormalFloat", {})
	end
end

-- Make unfocused windows non-transparent / or / all windows' transparency are the same
local function toggle_focus_transparency()
	current_focus = not current_focus

	theme_opts.gruvbox.transparent_mode = not current_focus
	theme_opts["rose-pine"].styles.transparency = not current_focus
	theme_opts.tokyonight.transparent = not current_focus
	theme_opts.catppuccin.transparent_background = not current_focus

	require("catppuccin").setup(theme_opts.catppuccin)
	require("gruvbox").setup(theme_opts.gruvbox)
	require("tokyonight").setup(theme_opts.tokyonight)
	require("rose-pine").setup(theme_opts["rose-pine"])

	-- reapply exactly the same colorscheme + variant of current
	local scheme = vim.g.colors_name or ""
	vim.cmd.colorscheme(scheme)

	if current_focus then
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	end
end

-- Keymaps to switch themes

vim.keymap.set("n", "<leader>T0", function()
	SetTheme(0)
end, { desc = "Set Catppuccin Macchiato", silent = true })

vim.keymap.set("n", "<leader>T1", function()
	SetTheme(1)
end, { desc = "Set Rose Pine Moon", silent = true })

vim.keymap.set("n", "<leader>T2", function()
	SetTheme(2)
end, { desc = "Set TokyoNight Moon", silent = true })

vim.keymap.set("n", "<leader>T3", function()
	SetTheme(3)
end, { desc = "Set Gruvbox", silent = true })

-- Toggle Opaque/Transparent
vim.keymap.set("n", "<leader>TT", function()
	toggle_theme_transparency()
end, { desc = "Toggle Opaque/Transparent", silent = true })

vim.keymap.set("n", "<leader>Tf", function()
	toggle_focus_transparency()
end, { desc = "Toggle unfocused window transparency" })

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup(theme_opts.catppuccin)
			SetTheme()
			if current_focus then
				current_focus = false
				toggle_focus_transparency()
			end
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		config = function()
			require("gruvbox").setup(theme_opts.gruvbox)
		end,
	},
	{
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup(theme_opts.tokyonight)
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup(theme_opts["rose-pine"])
		end,
	},
}
