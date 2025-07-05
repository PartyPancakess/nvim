return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            local ls = require("luasnip")
            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })

            -- load custom snippets
            require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/resources/snippets" })
            require("luasnip").config.setup({
                update_events = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })

            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                if ls.locally_jumpable(1) then
                    return "<cmd>lua require'luasnip'.jump(1)<CR>"
                else
                    return "<Tab>"
                end
            end, { expr = true, silent = true })
        end,
    },
}
