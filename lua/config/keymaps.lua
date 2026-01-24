-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>cx", function()
  local file = vim.fn.expand("%")
  local root = vim.fn.expand("%:r") -- without extension
  local ft = vim.bo.filetype
  local buf_name = "SmartRun_Output"

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

  -- find and close existing output window/buffer
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):find(buf_name) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  -- open a new split for output
  vim.cmd("botright vsplit")
  vim.cmd("terminal " .. with_input(cmd))
  local new_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(new_buf, buf_name)
  vim.bo[new_buf].buflisted = false
  vim.cmd("startinsert")
end, { desc = "DK: Compile and run C++ file With INPUT" })
