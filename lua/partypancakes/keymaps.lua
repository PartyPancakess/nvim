-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Do not copy removed chars to clipboard
vim.keymap.set("n", "x", '"_x', { noremap = true })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

-- Explorer
-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = 'Explorer' })
vim.keymap.set(
	"n",
	"<leader>e",
	":NvimTreeToggle<CR>",
	{ noremap = true, silent = true, desc = "Explorer Tree Sidebar" }
)

-- Text Manipulation / Navigation ----------------

-- Move selected line/block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- Take next line and append to the current line with a space
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line to current line" })

-- Half screen jump up/down and keep cursor in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in the middle of the screen when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over text without yanking it
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Put without yanking" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Copy text to system clipboard (Uncomment if system clipboard and vim are not synced)
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]]) -- yank whole line

-- Quickfix Navigation
vim.keymap.set("n", "<C-j>", Smart_quickfix_next, { desc = "Next in quickfix or loclist" })
vim.keymap.set("n", "<C-k>", Smart_quickfix_prev, { desc = "Prev in quickfix or loclist" })

-- Change complition navigation to use <C-j> and <C-k> instead of <C-n> and <C-p>
vim.keymap.set("i", "<C-j>", "<C-n>", { desc = "Next completion item" })
vim.keymap.set("i", "<C-k>", "<C-p>", { desc = "Previous completion item" })
vim.keymap.set("i", "<C-l>", "<C-y>", { desc = "Trigger completion" })

-- Replacte the word under cursor and other occurances
vim.keymap.set(
	"n",
	"<leader>rr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

vim.keymap.set("n", "<leader>Tn", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })

-- Useful Templates For Specific Languages -----------

-- Golang error handling templates
vim.keymap.set("n", "<leader>lgee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "Return Error" })

vim.keymap.set(
	"n",
	"<leader>lgel",
	'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i',
	{ desc = "Log Error" }
)

-- Random Useful Stuff ----------------------------

vim.keymap.set("n", "<leader><leader>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit Buffer" })

-- Reveal current file in finder
vim.api.nvim_create_user_command("Rfinder", function()
	local path = vim.api.nvim_buf_get_name(0)
	os.execute("open -R " .. path)
end, {})
