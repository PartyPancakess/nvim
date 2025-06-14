return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        -- Custom Lualine component to show attached language server
        local clients_lsp = function()
            local clients = vim.lsp.get_clients()
            if next(clients) == nil then
                return ""
            end

            -- Get LSP clients attached to this buffer
            local bufnr = vim.api.nvim_get_current_buf()
            local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
            local lsp_names = {}

            if #lsp_clients > 0 then
                for _, client in ipairs(lsp_clients) do
                    if client.name ~= "copilot" and not vim.tbl_contains(lsp_names, client.name) then
                        table.insert(lsp_names, client.name)
                    end
                end
            end

            return " " .. table.concat(lsp_names, "|")
        end

        local custom_line_theme = require("lualine.themes.dracula")

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = custom_line_theme,
                component_separators = "",
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { 'dashboard' },
                },
            },
            sections = {
                lualine_a = {
                    { "mode", separator = { left = " ", right = "" }, icon = "" },
                },
                lualine_b = {
                    {
                        "filetype",
                        icon_only = true,
                        padding = { left = 1, right = 0 },
                    },
                    "filename",
                },
                lualine_c = {
                    {
                        "branch",
                        icon = "",
                        separator = { right = "" },
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = "  ", removed = "  " },
                        colored = true,
                        color = { bg = "#5d6b8e" },
                        separator = { right = "" },
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },
                        update_in_insert = true,
                    },
                },
                lualine_y = { clients_lsp },
                lualine_z = {
                    { "location", separator = { left = "", right = "" }, icon = "" },
                    {
                        function()
                            return "📄 " .. tostring(vim.fn.line('$'))
                        end,
                        separator = { left = "", right = " " }
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { "location" },
            },
            -- extensions = { "toggleterm", "trouble" },
        })
    end,
}
