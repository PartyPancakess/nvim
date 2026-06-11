return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					-- add = { text = '+' },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				current_line_blame = true,
				-- word_diff = true,

				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					-- map('n', ']c', function()
					--     if vim.wo.diff then
					--         vim.cmd.normal({ ']c', bang = true })
					--     else
					--         gitsigns.nav_hunk('next')
					--     end
					-- end)
					--
					-- map('n', '[c', function()
					--     if vim.wo.diff then
					--         vim.cmd.normal({ '[c', bang = true })
					--     else
					--         gitsigns.nav_hunk('prev')
					--     end
					-- end)

					map("n", "<leader>Gl", function()
						local blame = vim.b.gitsigns_blame_line_dict
						if not blame or not blame.sha or blame.sha == "0000000000000000000000000000000000000000" then
							vim.notify("No commit for this line", vim.log.levels.WARN)
							return
						end
						gitsigns.diffthis(blame.sha .. "^")
					end, { desc = "Diff against parent of blame commit" })
					-- map("n", "<leader>Gl", gitsigns.preview_hunk, { desc = "File history for the current (uncommitted) hunk" })
					map("n", "<leader>GL", function()
						local blame = vim.b.gitsigns_blame_line_dict
						if blame and blame.sha and blame.sha ~= "0000000000000000000000000000000000000000" then
							vim.cmd("DiffviewOpen " .. blame.sha .. "^.." .. blame.sha)
						else
							vim.notify("No commit for this line", vim.log.levels.WARN)
						end
					end, { desc = "View commit diff for current line" })

					-- Actions
					map("n", "<leader>Gr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
				end,
			})
		end,
	},
}
