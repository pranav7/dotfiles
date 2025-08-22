-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Set leader key (LazyVim already sets this to space by default)
vim.g.mapleader = " "

-- Escaping with jj
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- Suspend session
map("n", "bg", ":sus<CR>", { desc = "Suspend session" })

-- Folding
map("n", "<C-f>", "za", { desc = "Toggle fold" })

-- Tabs navigation (LazyVim uses buffers by default, but we can add tab support)
map("n", "<C-t>", ":tabnew<CR>", { desc = "New tab" })
map("n", "<C-]>", "gt", { desc = "Next tab" })
map("n", "<C-[>", "gT", { desc = "Previous tab" })
map("n", "<leader>1", "1gt", { desc = "Go to tab 1" })
map("n", "<leader>2", "2gt", { desc = "Go to tab 2" })
map("n", "<leader>3", "3gt", { desc = "Go to tab 3" })
map("n", "<leader>4", "4gt", { desc = "Go to tab 4" })
map("n", "<leader>5", "5gt", { desc = "Go to tab 5" })
map("n", "<leader>6", "6gt", { desc = "Go to tab 6" })
map("n", "<leader>7", "7gt", { desc = "Go to tab 7" })
map("n", "<leader>8", "8gt", { desc = "Go to tab 8" })
map("n", "<leader>9", "9gt", { desc = "Go to tab 9" })

-- Buffer navigation (in addition to LazyVim's defaults)
map("n", "bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- System clipboard copying
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- Splits creation (LazyVim already has good split navigation with <C-h/j/k/l>)
map("n", "<leader>s\\", ":leftabove vnew<CR>", { desc = "Split left" })
map("n", "<leader>s-", ":rightbelow new<CR>", { desc = "Split below" })
map("n", "<leader>s<left>", ":leftabove vnew<CR>", { desc = "Split left" })
map("n", "<leader>s<right>", ":rightbelow vnew<CR>", { desc = "Split right" })
map("n", "<leader>s<up>", ":leftabove new<CR>", { desc = "Split above" })
map("n", "<leader>s<down>", ":rightbelow new<CR>", { desc = "Split below" })

-- Window zoom
map("n", "<leader>-", ":wincmd _<CR>:wincmd |<CR>", { desc = "Zoom current pane" })
map("n", "<leader>=", ":wincmd =<CR>", { desc = "Balance windows" })

-- Clear search highlighting
map("n", "<C-c>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quick debugging snippets
map("n", "<leader>pdb", "oimport pdb; pdb.set_trace()<ESC>:w<CR>", { desc = "Insert Python debugger" })
map("n", "<leader>pry", "obinding.pry<ESC>:w<CR>", { desc = "Insert Ruby debugger" })
map("n", "<leader>log", "oconsole.log('');<left><left><left>", { desc = "Insert console.log" })

-- FZF-like mappings (LazyVim uses Telescope by default)
-- These override the default 't' and 'f' mappings, uncomment if you prefer these
-- map("n", "t", ":Telescope find_files<CR>", { desc = "Find files" })
-- map("n", "f", ":Telescope live_grep<CR>", { desc = "Live grep" })

-- NERDTree-like mappings for neo-tree (LazyVim's file explorer)
map("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>f", ":Neotree reveal<CR>", { desc = "Reveal current file in explorer" })