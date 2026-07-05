<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# lua

## Purpose
Root Lua source directory for the Neovim configuration. Contains two subdirectories that LazyVim loads automatically: `config/` for core settings and `plugins/` for plugin specs.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `config/` | Core Neovim settings loaded before plugins: options, keymaps, autocmds, lazy bootstrap (see `config/AGENTS.md`) |
| `plugins/` | Plugin specifications — each file returns a lazy.nvim spec table (see `plugins/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- `dot_DS_Store` files are macOS artifacts — safe to ignore, not deployed by chezmoi
- LazyVim auto-imports everything in `plugins/` — no manual registration needed when adding a new plugin file
- The load order is: `config/lazy.lua` → lazy.nvim → LazyVim defaults → `plugins/**` specs

<!-- MANUAL: -->
