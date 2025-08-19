-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode" })
-- In your Lua config (e.g., `config/keymaps.lua` or similar)
-- Use H and L for buffer navigation (common vim convention)
vim.keymap.set("n", "<S-h>", function()
  vim.cmd("BufferLineCyclePrev")
end, { desc = "Previous buffer" })

vim.keymap.set("n", "<S-l>", function()
  vim.cmd("BufferLineCycleNext")
end, { desc = "Next buffer" })

-- Alternative: Use Tab and Shift-Tab
vim.keymap.set("n", "<Tab>", function()
  vim.cmd("BufferLineCycleNext")
end, { desc = "Next buffer" })

vim.keymap.set("n", "<S-Tab>", function()
  vim.cmd("BufferLineCyclePrev")
end, { desc = "Previous buffer" })

vim.api.nvim_create_user_command("CopyRelPath", function()
  local relative_path = vim.fn.expand("%:.")  -- Force relative to current working directory
  vim.fn.setreg("+", relative_path)
  vim.notify("Copied relative path: " .. relative_path)
end, {})

vim.keymap.set("n", "<leader>cf", ":CopyRelPath<CR>", { desc = "Copy relative file path" })
