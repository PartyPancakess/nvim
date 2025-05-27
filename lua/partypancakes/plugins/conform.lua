return {
    {                          -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' }, -- Run on just before writing to disk (format before saving)
        cmd = { 'ConformInfo' }, -- Run :ConformInfo to see info on current formatters
        keys = {
            {
                '<leader>F',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = 'Format buffer',
            },
            {
                '<leader>ls',
                function()
                    vim.g.format_on_save_enabled = not vim.g.format_on_save_enabled
                    local status = vim.g.format_on_save_enabled and "enabled" or "disabled"
                    local icon = vim.g.format_on_save_enabled and "✅" or "❌"
                    vim.notify(string.format("%s Format-on-save %s", icon, status), vim.log.levels.INFO)
                end,
                desc = 'Toggle format-on-save',
            },
            {
                '<leader>li', -- Show info about the formatters configured for the current buffer
                function()
                    local conform = require('conform')
                    local bufnr = vim.api.nvim_get_current_buf()
                    local filetype = vim.bo[bufnr].filetype
                    local filename = vim.fn.expand('%:t')
                    local filepath = vim.fn.expand('%:p')

                    -- Get LSP clients attached to this buffer
                    local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
                    local lsp_names = {}
                    local lsp_details = {}

                    if #lsp_clients > 0 then
                        for _, client in ipairs(lsp_clients) do
                            table.insert(lsp_names, client.name)
                            local supports_formatting = client.server_capabilities.documentFormattingProvider
                            local format_icon = supports_formatting and "✓" or "✗"
                            table.insert(lsp_details,
                                string.format("  %s %s %s", format_icon, client.name,
                                    supports_formatting and "(supports formatting)" or "(no formatting)"))
                        end
                    end

                    -- Get conform formatters
                    local formatters = conform.list_formatters(bufnr)
                    local formatter_details = {}
                    local formatter_names = {}

                    if #formatters > 0 then
                        for _, formatter in ipairs(formatters) do
                            table.insert(formatter_names, formatter.name)
                            local status = formatter.available and "✓" or "✗"
                            table.insert(formatter_details, string.format("  %s %s", status, formatter.name))
                        end
                    end

                    -- Get buffer info
                    local buf_info = {
                        size = vim.fn.getfsize(filepath),
                        lines = vim.api.nvim_buf_line_count(bufnr),
                        modified = vim.bo[bufnr].modified,
                        readonly = vim.bo[bufnr].readonly,
                        encoding = vim.bo[bufnr].fileencoding ~= "" and vim.bo[bufnr].fileencoding or vim.o.encoding,
                        format = vim.bo[bufnr].fileformat,
                        indent = vim.bo[bufnr].expandtab and (vim.bo[bufnr].shiftwidth .. " spaces") or "tabs",
                    }

                    -- Format file size
                    local size_str = "unknown"
                    if buf_info.size >= 0 then
                        if buf_info.size < 1024 then
                            size_str = buf_info.size .. " B"
                        elseif buf_info.size < 1024 * 1024 then
                            size_str = string.format("%.1f KB", buf_info.size / 1024)
                        else
                            size_str = string.format("%.1f MB", buf_info.size / 1024 / 1024)
                        end
                    end

                    -- Build the message
                    local sections = {}

                    -- File info section
                    table.insert(sections, string.format("📄 File: %s", filename))
                    table.insert(sections, string.format("📁 Path: %s", filepath))
                    table.insert(sections,
                        string.format("📊 Type: %s | Size: %s | Lines: %d", filetype, size_str, buf_info.lines))
                    table.insert(sections,
                        string.format("⚙️  Encoding: %s | Format: %s | Indent: %s", buf_info.encoding, buf_info.format,
                            buf_info.indent))

                    if buf_info.modified or buf_info.readonly then
                        local flags = {}
                        if buf_info.modified then table.insert(flags, "modified") end
                        if buf_info.readonly then table.insert(flags, "readonly") end
                        table.insert(sections, string.format("🏷️  Flags: %s", table.concat(flags, ", ")))
                    end

                    -- LSP section
                    if #lsp_clients > 0 then
                        table.insert(sections, "\n🔧 LSP Servers:")
                        for _, detail in ipairs(lsp_details) do
                            table.insert(sections, detail)
                        end
                    else
                        table.insert(sections, "\n🔧 LSP Servers: None attached")
                    end

                    -- Formatters section
                    if #formatters > 0 then
                        table.insert(sections, "\n📝 External Formatters:")
                        for _, detail in ipairs(formatter_details) do
                            table.insert(sections, detail)
                        end
                        table.insert(sections, string.format("\nActive: %s", table.concat(formatter_names, ", ")))
                    else
                        table.insert(sections, "\n📝 External Formatters: None configured")
                        if #lsp_clients > 0 then
                            table.insert(sections, "Will use LSP formatting if available")
                        end
                    end

                    -- Format-on-save status
                    table.insert(sections, string.format("\n💾 Format-on-save: %s %s\n ",
                        vim.g.format_on_save_enabled and "✅" or "❌",
                        vim.g.format_on_save_enabled and "enabled" or "disabled"
                    ))

                    local message = table.concat(sections, "\n")
                    vim.notify(message, vim.log.levels.INFO)
                end,
                desc = 'Show buffer and formatting info',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Check if format-on-save is globally disabled
                if not vim.g.format_on_save_enabled then
                    return nil
                end

                local disable_filetypes = { c = true, cpp = true } -- Disable on languages that might cause issues
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                go = { "gofmt" },
                javascript = { "biome", "biome-organize-imports" },
                typescript = { "biome", "biome-organize-imports" },
            },
        },
    }
}
