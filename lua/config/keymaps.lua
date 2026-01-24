-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>cx", function()
  local file = vim.fn.expand("%")
  local root = vim.fn.expand("%:r") -- without extension
  local ft = vim.bo.filetype

  local function with_input(base_cmd)
    if vim.fn.filereadable(root .. ".in") == 0 then
      -- vim.notify("input file not found: " .. root .. ".in", vim.log.levels.WARN)
      return base_cmd
    end
    -- vim.notify("Using input file: " .. root .. ".in", vim.log.levels.INFO)
    return string.format("%s < %s.in", base_cmd, root)
  end

  local cmd = ""
  if ft == "cpp" then
    cmd = string.format("g++ %s -o %s && %s", file, root, root)
  elseif ft == "python" then
    cmd = string.format("python3 %s", file)
  else
    vim.notify("Unsupported file type for compilation with input", vim.log.levels.ERROR)
    return
  end

  -- vertically split terminal
  vim.cmd("vsplit | terminal " .. with_input(cmd))
end, { desc = "DK: Compile and run C++ file With INPUT" })
