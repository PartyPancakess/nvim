return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs = {
                    -- add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
                current_line_blame = true,
                -- word_diff = true,

                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

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

                    -- Actions
                    map('n', '<leader>Gr', gitsigns.reset_hunk)
                end,
            }
        end,
    }
}
