return {
	{
		-- plugin for nvim lua dev
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				config = function()
					local notification = require("fidget.notification")
					vim.keymap.set("n", "<leader>tf", notification.suppress, { desc = "Toggle Fidget notifications" })
				end,
			},
			"stevearc/conform.nvim",

			"saghen/blink.cmp",
		},

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities(nil, true)

			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"ts_ls",
				},
			})

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				settings = {
					typescript = { format = { enable = false } },
					javascript = { format = { enable = false } },
				},
			})

			vim.diagnostic.config({
				update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
			})
		end,
	},
}
