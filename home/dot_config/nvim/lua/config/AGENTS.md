<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# config

## Purpose
Core Neovim configuration files loaded by LazyVim at specific startup phases. These files extend or override LazyVim defaults rather than replacing them.

## Key Files

| File | Description |
|------|-------------|
| `lazy.lua` | Bootstraps lazy.nvim, sets up plugin specs (LazyVim + `plugins/`), and configures performance |
| `options.lua` | Vim options: enables `termguicolors`, disables `autochdir` |
| `keymaps.lua` | Custom keymaps: `<leader>gg` opens Lazygit scoped to the current file's directory |
| `autocmds.lua` | Custom autocommands (currently empty — placeholder for future use) |

## For AI Agents

### Working In This Directory
- LazyVim loads these files in order: `options.lua` → `lazy.lua` → `keymaps.lua` → `autocmds.lua` (on VeryLazy)
- Do not add `require()` calls for plugins here — use `plugins/` for plugin specs
- `lazy.lua` disables several built-in Vim plugins (`gzip`, `tarPlugin`, `tohtml`, `tutor`, `zipPlugin`) for startup performance
- The checker in `lazy.lua` auto-checks for plugin updates silently (no notification popup)

### Common Patterns
- Use `vim.keymap.set("n", ...)` with a `desc` field for all keymaps so which-key shows them
- Options that conflict with LazyVim defaults should be set in `options.lua`

## Dependencies

### Internal
- `../plugins/` — lazy.lua imports all plugin specs from this directory

<!-- MANUAL: -->
