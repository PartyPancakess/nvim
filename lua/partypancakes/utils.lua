local function is_active_list_type_location()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
        if buf_type == 'quickfix' then
            local win_info = vim.fn.getwininfo(win)[1]
            return win_info.loclist == 1
        end
    end
    return nil
end

function Smart_quickfix_next()
    local active_type = is_active_list_type_location()

    if active_type then
        pcall(vim.cmd, "lnext")
    else
        pcall(vim.cmd, "cnext")
    end
    vim.cmd("normal! zz")
end

function Smart_quickfix_prev()
    local active_type = is_active_list_type_location()

    if active_type then
        pcall(vim.cmd, "lprev")
    else
        pcall(vim.cmd, "cprev")
    end
    vim.cmd("normal! zz")
end
