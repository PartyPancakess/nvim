return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "giuxtaposition/blink-cmp-copilot",
        },
        version = "1.*",
        opts = {
            keymap = {
                preset = 'default',
                ['<C-k>'] = { 'select_prev', 'fallback' },
                ['<C-j>'] = { 'select_next', 'fallback' },
                ['<C-l>'] = { 'select_and_accept', 'fallback' },
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            cmdline = {
                keymap = {
                    preset = "inherit",
                },
                completion = { menu = { auto_show = true } },
            },
            completion = {
                accept = { auto_brackets = { enabled = false } },
                menu = {
                    border = "rounded",
                    draw = {
                        align_to = "label",
                        padding = 1,
                        gap = 4,
                        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
                        treesitter = { "lsp" },
                    },
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },
                },
                ghost_text = {
                    enabled = false,
                },
                list = {
                    selection = { preselect = true, auto_insert = false },
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
                providers = {
                    snippets = {
                        opts = {
                            search_paths = { "~/.config/nvim/lua/partypancakes/resources/snippets" },
                        }
                    },
                    lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
            signature = {
                enabled = true,
                trigger = {
                    enabled = true,
                    show_on_insert = true,
                },
                window = {
                    -- border = "rounded"
                }
            },
            fuzzy = {
                implementation = "prefer_rust",
                prebuilt_binaries = {
                    download = true,
                },
            },
        },
    },
}
