return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true,
			use_icons = true,
			file_panel = {
				win_config = {
					position = "left",
					width = 35,
				},
			},
			keymaps = {
				view = {
					["D"] = function()
						require("diffview.actions").restore_entry()
					end,
				},
			},
		})

		-- Close current tab
		vim.keymap.set("n", "<leader>Gc", function()
			vim.cmd("tabclose")
		end, { desc = "Tab Close" })

		-- Toggle Diffview: open if closed, close if open
		vim.keymap.set("n", "<leader>Gt", function()
			local view = require("diffview.lib").get_current_view()
			if view then
				vim.cmd("DiffviewClose")
			else
				vim.cmd("DiffviewOpen")
			end
		end, { desc = "Toggle Diffview" })

		-- Open File History
		vim.keymap.set("n", "<leader>Gh", function()
			vim.cmd("DiffviewFileHistory")
		end, { desc = "Git History" })

		-- Open File History for only the current file
		vim.keymap.set("n", "<leader>Gf", function()
			vim.cmd("DiffviewFileHistory %")
		end, { desc = "Git current File History" })
	end,
}
