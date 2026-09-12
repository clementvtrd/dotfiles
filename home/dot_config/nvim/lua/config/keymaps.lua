-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Find files (VS Code-style Cmd+P, sent by iTerm as Ctrl+P)
map("n", "<C-p>", LazyVim.pick("files"), { desc = "Find files" })

-- Toggle file explorer (VS Code-style Cmd+B, sent by iTerm as Ctrl+B)
map("n", "<C-b>", function()
  require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
end, { desc = "Explorer NeoTree (Root Dir)" })

-- Toggle floating terminal (VS Code-style Cmd+T, sent by iTerm as Ctrl+Y since
-- Ctrl+T is already taken by Harpoon)
map({ "n", "t" }, "<C-y>", function()
  Snacks.terminal.toggle(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

-- Lazygit dans le dossier du fichier courant
map("n", "<leader>gg", function()
  local file_dir = vim.fn.expand("%:p:h")
  Snacks.lazygit({ cwd = file_dir })
end, { desc = "Lazygit (current dir)" })