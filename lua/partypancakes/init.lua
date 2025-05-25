require("partypancakes.options")
require("partypancakes.keymaps")
require("partypancakes.lazy")


local augroup = vim.api.nvim_create_augroup
local PartyPancakesGroup = augroup('PartyPancakes', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = PartyPancakesGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = PartyPancakesGroup,
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')

        map('K', vim.lsp.buf.hover, 'Hover Documentation')


        -- GOTO MAPPINGS

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
        -- map('gd', vim.lsp.buf.definition, 'Goto Definition')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('<leader>gti', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

        map('<leader>gd', vim.diagnostic.open_float, 'Goto Diagnostic')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('<leader>gtD', vim.lsp.buf.declaration, 'Goto Declaration')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>gta', vim.lsp.buf.code_action, 'Goto Code Action')

        -- Find references for the word under your cursor.
        map('<leader>gtr', require('telescope.builtin').lsp_references, 'Goto References')
        -- map('<leader>grr', vim.lsp.buf.references, 'Goto References')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>gtt', require('telescope.builtin').lsp_type_definitions, 'Goto Type Definition')


        -- OTHER MAPPINGS

        -- Fuzzy find all the symbols in your current document.
        -- Symbols are things like variables, functions, types, etc.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        -- Similar to document symbols, except searches over your entire project.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        -- map('<leader>gws', vim.lsp.buf.workspace_symbol, 'Open/Goto Workspace Symbols')


        map('[d', vim.diagnostic.goto_next, 'Next Diagnostic')
        map(']d', vim.diagnostic.goto_prev, 'Previous Diagnostic')

        map('<C-h>', vim.lsp.buf.signature_help, 'Signiture Help', 'i')


        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --
        -- When the cursor is moved, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in the
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of the code
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, 'Toggle Inlay Hints')
        end
          
    end
})


autocmd('BufEnter', {
    group = PartyPancakesGroup,
    callback = function()
      SetTheme(0)
      -- Change theme based on file type
      --  if vim.bo.filetype == "zig" then
      --     vim.cmd.colorscheme("tokyonight-night")
      --  else
      --     vim.cmd.colorscheme("catppuccin-macchiato")
      --  end

      -- Set format on save
      vim.g.format_on_save_enabled = false
    end
})
