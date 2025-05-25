vim.cmd([[
  let g:tmux_navigator_no_mappings = 1
  let g:tmux_navigator_disable_when_zoomed = 0

  noremap <silent> <M-h> :<C-U>TmuxNavigateLeft<cr>
  noremap <silent> <M-j> :<C-U>TmuxNavigateDown<cr>
  noremap <silent> <M-k> :<C-U>TmuxNavigateUp<cr>
  noremap <silent> <M-l> :<C-U>TmuxNavigateRight<cr>
]])

return {
    {
        "christoomey/vim-tmux-navigator",
    }
}

