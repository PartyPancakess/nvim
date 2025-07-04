return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				defaults = {
					path_display = { "truncate" },
					-- path_display = { "smart" },

					-- theme = "center",
					-- sorting_strategy = "ascending",
					-- layout_config = {
					--     horizontal = {
					--         prompt_position = "top",
					--         preview_width = 0.3,
					--     },
					-- },

					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension("file_browser"))
			local builtin = require("telescope.builtin")

			-- KEYMAPS

			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it.

			-- !! FILE NAVIGATION (File Name Searching) !! --

			-- Search All Files
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			-- Search Only Git Files
			vim.keymap.set("n", "<C-g>", builtin.git_files, { desc = "Find Git Files" })
			vim.keymap.set("n", "<leader>fe", builtin.buffers, { desc = "Find existing buffers" })

			-- !! FIND IN FILES (grep) !! --

			-- Search project with grep
			vim.keymap.set("n", "<leader>fp", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end, { desc = "Find in Project via Grep" })
			-- Search project with live grep
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find by live Grep" })

			-- Search current word under cursor
			vim.keymap.set("n", "<leader>fw", function()
				local word = vim.fn.expand("<cword>")
				builtin.grep_string({ search = word })
			end, { desc = "Find current Word in Project" })
			vim.keymap.set("n", "<leader>fW", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end, { desc = "Find current WORD in Project" })
			vim.keymap.set("n", "<leader>fc", function()
				local current_word = vim.fn.expand("<cword>")
				pcall(vim.cmd, "/" .. current_word)
			end, { desc = "Find Current word in the Current buffer" })

			-- !! NON-NAVIGATION SEARCHES !! --
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "find help" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "find keymaps" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "find diagnostics" })

			-- Extra mappings
			-- vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Find Resume old search' })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Find Recent Files by name" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find document symbols" })
			vim.keymap.set("n", "<leader>f/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "Find [/] in Open Files" })

			vim.keymap.set("n", "<leader>Tc", builtin.colorscheme, { desc = "Change Theme" })
		end,
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set(
				"n",
				"<space>fb",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>",
				{ desc = "File Browser" }
			)
		end,
	},
}
