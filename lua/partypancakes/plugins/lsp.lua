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

			-- Suppress noisy TypeScript Server Error notifications
			vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
				if result.message:match("TypeScript Server Error") then
					return
				end
				vim.notify(result.message, vim.lsp.protocol.MessageType[result.type])
			end

			-- Configure LSP servers BEFORE mason-lspconfig (automatic_enable needs these)
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server_path,
							languages = { "vue" },
						},
					},
				},
				settings = {
					typescript = { format = { enable = false } },
					javascript = { format = { enable = false } },
				},
			})

			vim.lsp.config("vue_ls", {
				capabilities = capabilities,
				init_options = {
					typescript = {
						tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
					},
				},
			})

			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"ts_ls",
					"vue_ls",
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"eslint_d",
					"stylua",
					"biome",
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
