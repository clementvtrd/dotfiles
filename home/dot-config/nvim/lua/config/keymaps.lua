-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Lazygit dans le dossier du fichier courant
map("n", "<leader>gg", function()
  local file_dir = vim.fn.expand("%:p:h")
  Snacks.lazygit({ cwd = file_dir })
end, { desc = "Lazygit (current dir)" })