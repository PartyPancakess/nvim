return {
    { -- Markdown Viewer
        "toppair/peek.nvim",
        enabled = false,
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                filetype = { 'markdown', 'conf' },
                auto_load = false,         -- do not auto load preview to prevent background process
                close_on_bdelete = true,   -- close preview on buffer delete
                app = 'browser',           -- use default browser instead of webview to reduce memory usage
            })
            -- ensure peek process is closed when Neovim exits
            -- vim.api.nvim_create_autocmd("VimLeavePre", {
            --     callback = function()
            --         require("peek").close()
            --     end,
            -- })
            -- vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            -- vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
}
