-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>cx", function()
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r") -- without extension
  local cmd = string.format("g++ %s -o %s && %s", file, output, output)
  vim.cmd("vsplit | terminal " .. cmd)
end, { desc = "Compile and run C++ file" })

vim.keymap.set("n", "<leader>cX", function()
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r") -- without extension
  local cmd = string.format("g++ %s -o %s && %s < %s.in", file, output, output, output)
  -- vertically split terminal
  vim.cmd("vsplit | terminal " .. cmd)
end, { desc = "Compile and run C++ file With INPUT" })
