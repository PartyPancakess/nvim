return {
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            local npairs = require('nvim-autopairs')
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')

            -- Fast Wrap: When typed an opening character like ( or {, in insert mode,
            -- if Meta-e is pressed, it will display a bunch of options (with below list of keys)
            -- When one of those options is selected, it will put a closing character there.
            npairs.setup({
                fast_wrap = {
                    map = '<M-e>',
                    chars = { '{', '[', '(', '"', "'" },
                    pattern = [=[[%'%"%>%]%)%}%,]]=],
                    end_key = '$',
                    before_key = 'h',
                    after_key = 'l',
                    cursor_pos_before = true,
                    keys = 'qwertyuiopzxcvbnmasdfghjkl',
                    manual_position = true,
                    highlight = 'Search',
                    highlight_grey = 'Comment'
                },
            })

            -- Add autopairs when completing with cmp
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    }
}
