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
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values

			local function live_grep_in_dir_picker(opts)
				opts = opts or {}
				local cwd = opts.cwd or vim.loop.cwd()

				-- Build a command to list directories
				local cmd
				if vim.fn.executable("fd") == 1 then
					cmd = {
						"fd",
						"--type",
						"d",
						"--hidden",
						"--follow",
						"--exclude",
						".git",
						".", -- search root
						cwd,
					}
				else
					-- mac/linux fallback
					cmd = {
						"find",
						cwd,
						"-type",
						"d",
						"-not",
						"-path",
						"*/.git/*",
					}
				end

				pickers
					.new(opts, {
						prompt_title = "Pick directory to Live Grep",
						finder = finders.new_oneshot_job(cmd, {
							cwd = cwd,
							entry_maker = function(line)
								-- Normalize to a nicer display: show paths relative to cwd
								local rel = vim.fn.fnamemodify(line, ":~:.")
								if vim.startswith(rel, cwd) then
									rel = rel:sub(#cwd + 2)
								end
								if rel == "" then
									rel = "."
								end

								return {
									value = line, -- absolute dir path from cmd
									display = rel, -- what you see in Telescope
									ordinal = rel, -- what Telescope matches on
								}
							end,
						}),
						sorter = conf.generic_sorter(opts),
						previewer = false,

						attach_mappings = function(prompt_bufnr, map)
							local function open_grep()
								local selection = action_state.get_selected_entry()
								if not selection then
									return
								end
								actions.close(prompt_bufnr)

								builtin.live_grep({
									cwd = selection.value, -- absolute dir
									prompt_title = "Live Grep in " .. selection.display,
								})
							end

							map("i", "<CR>", open_grep)
							map("n", "<CR>", open_grep)
							return true
						end,
					})
					:find()
			end

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
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Find Resume old search" })

			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Find Recent Files by name" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find document symbols" })
			vim.keymap.set("n", "<leader>f/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "Find [/] in Open Files" })

			vim.keymap.set("n", "<leader>Tc", builtin.colorscheme, { desc = "Change Theme" })

			vim.keymap.set("n", "<leader>fG", function()
				live_grep_in_dir_picker()
			end, { desc = "Live Grep (pick directory)" })
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
