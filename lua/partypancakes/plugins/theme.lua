local current_transparency = true
local current_focus = false

-- Theme registry: Add new themes here!
local THEMES = {
	{
		name = "catppuccin-macchiato",
		plugin = "catppuccin",
		repo = "catppuccin/nvim",
		key = "<leader>T0",
		desc = "Catppuccin Macchiato",
		opts = function(transparent)
			return {
				custom_highlights = function(colors)
					return {
						LineNr = { fg = "#969696" },
						CursorLineNr = { bg = "#2F3447", style = { "bold" } },
						BlinkCmpMenu = { bg = "#282c3d" },
						BlinkCmpDoc = { bg = "#282c3d" },
						BlinkCmpSignatureHelp = { bg = "#282c3d" },
					}
				end,
				transparent_background = transparent,
			}
		end,
	},
	{
		name = "rose-pine-moon",
		plugin = "rose-pine",
		repo = "rose-pine/neovim",
		key = "<leader>T1",
		desc = "Rose Pine Moon",
		opts = function(transparent)
			return {
				variant = "moon",
				styles = {
					italic = false,
					transparency = transparent,
				},
			}
		end,
	},
	{
		name = "tokyonight-moon",
		plugin = "tokyonight",
		repo = "folke/tokyonight.nvim",
		key = "<leader>T2",
		desc = "TokyoNight Moon",
		opts = function(transparent)
			return {
				transparent = transparent,
				styles = {
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
			}
		end,
	},
	{
		name = "gruvbox",
		plugin = "gruvbox",
		repo = "ellisonleao/gruvbox.nvim",
		key = "<leader>T3",
		desc = "Gruvbox",
		opts = function(transparent)
			return {
				transparent_mode = transparent,
			}
		end,
	},
}

-- Get current theme config
local function get_current_theme()
	local scheme = vim.g.colors_name or ""
	for _, theme in ipairs(THEMES) do
		if theme.name == scheme then
			return theme
		end
	end
	return nil
end

-- Apply theme with current transparency settings
local function apply_theme(theme_name)
	for _, theme in ipairs(THEMES) do
		if theme.name == theme_name then
			local opts = theme.opts(current_transparency)
			require(theme.plugin).setup(opts)
			vim.cmd.colorscheme(theme.name)

			-- Apply floating window transparency if enabled
			if current_transparency then
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

				-- Rose-pine specific: manually clear backgrounds
				if theme.plugin == "rose-pine" then
					vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
					vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
				end
			end
			return
		end
	end
end

function SetTheme(theme_name)
	apply_theme(theme_name)
end

local function toggle_theme_transparency()
	local theme = get_current_theme()
	if not theme then
		return
	end

	current_transparency = not current_transparency

	-- Only reconfigure the current theme
	local opts = theme.opts(current_transparency)
	require(theme.plugin).setup(opts)
	vim.cmd.colorscheme(theme.name)

	-- Apply or remove floating window transparency
	if current_transparency then
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

		-- Rose-pine specific: manually clear backgrounds
		if theme.plugin == "rose-pine" then
			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
		end
	else
		vim.api.nvim_set_hl(0, "NormalFloat", {})
	end
end

local function toggle_focus_transparency()
	local theme = get_current_theme()
	if not theme then
		return
	end

	current_focus = not current_focus

	-- Only reconfigure the current theme
	local opts = theme.opts(not current_focus)
	require(theme.plugin).setup(opts)
	vim.cmd.colorscheme(theme.name)

	if current_focus then
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	end
end

-- Generate keymaps dynamically
for _, theme in ipairs(THEMES) do
	vim.keymap.set("n", theme.key, function()
		SetTheme(theme.name)
	end, { desc = "Set " .. theme.desc, silent = true })
end

-- Toggle Opaque/Transparent
vim.keymap.set("n", "<leader>TT", function()
	toggle_theme_transparency()
end, { desc = "Toggle Opaque/Transparent", silent = true })

vim.keymap.set("n", "<leader>Tf", function()
	toggle_focus_transparency()
end, { desc = "Toggle unfocused window transparency" })

-- Build plugin specs dynamically from THEMES
local plugins = {}
local default_theme = THEMES[1].name

for _, theme in ipairs(THEMES) do
	table.insert(plugins, {
		theme.repo,
		name = theme.plugin,
		config = function()
			local opts = theme.opts(current_transparency)
			require(theme.plugin).setup(opts)

			-- Apply default theme on first load
			if theme.name == default_theme then
				SetTheme(theme.name)
				if current_focus then
					current_focus = false
					toggle_focus_transparency()
				end
			end
		end,
	})
end

return plugins
