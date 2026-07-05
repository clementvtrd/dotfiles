<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# plugins

## Purpose
Plugin specification files for lazy.nvim. Each file returns a Lua table of plugin specs that extend or override LazyVim defaults. All files here are auto-imported by LazyVim.

## Key Files

| File | Description |
|------|-------------|
| `catppuccin.lua` | Catppuccin colorscheme with `flavour = "auto"` (follows macOS dark/light mode); sets it as the active LazyVim colorscheme |
| `auto-dark-mode.lua` | `auto-dark-mode.nvim` — polls macOS appearance every second and switches `vim.opt.background` accordingly |
| `git.lua` | Git UI: `diffview.nvim` (diff/history viewer with keymaps) + `gitsigns.nvim` (gutter signs + inline blame with 500ms delay) |
| `lsp.lua` | Mason tool installer + `nvim-lspconfig` servers for TypeScript, Go, PHP, HTML/CSS/Tailwind/Emmet |
| `navigation.lua` | Navigation enhancements: Harpoon 2 (file bookmarks), Telescope tweaks (ignore patterns, projects key), Neo-tree (show hidden/dotfiles) |

## For AI Agents

### Working In This Directory
- Add a new plugin by creating a new `.lua` file returning a spec table — it is automatically picked up
- Override a LazyVim plugin by returning a spec with the same plugin name/URL and an `opts` table
- `dot_DS_Store` files are macOS artifacts — safe to ignore

### Common Patterns
- Use `opts = {}` for simple option overrides instead of `config = function() ... end`
- Lazy-load plugins with `cmd`, `keys`, or `ft` to keep startup fast
- Harpoon keymaps: `<leader>a` add, `<C-e>` menu, `<C-h/t/n/s>` select slots 1–4

## Dependencies

### External
- `catppuccin/nvim` — colorscheme
- `f-person/auto-dark-mode.nvim` — macOS dark mode detection
- `sindrets/diffview.nvim` — diff/history UI
- `lewis6991/gitsigns.nvim` — git gutter signs
- `mason-org/mason.nvim` — LSP/tool installer
- `neovim/nvim-lspconfig` — LSP client configuration
- `ThePrimeagen/harpoon` (harpoon2 branch) — file bookmarks
- `nvim-telescope/telescope.nvim` — fuzzy finder
- `nvim-neo-tree/neo-tree.nvim` — file explorer

<!-- MANUAL: -->
