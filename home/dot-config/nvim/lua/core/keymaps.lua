vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

vim.keymap.set('n', 'x', '"_x', opts)

vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)

