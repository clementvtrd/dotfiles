<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# nvim

## Purpose
Neovim configuration built on [LazyVim](https://www.lazyvim.org/). Deployed to `~/.config/nvim/` by chezmoi. LazyVim provides sensible defaults; local files extend or override them.

## Key Files

| File | Description |
|------|-------------|
| `init.lua` | Entry point — bootstraps lazy.nvim plugin manager |
| `lazy-lock.json` | Plugin version lockfile (auto-updated by lazy.nvim) |
| `lazyvim.json` | LazyVim extras enabled for this setup |
| `dot_neoconf.json` | Per-project LSP settings (neoconf.nvim integration) — deployed as `.neoconf.json` |
| `stylua.toml` | StyLua formatter config for Lua files |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `lua/` | All Lua source code for this config (see `lua/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Do not edit `lazy-lock.json` manually — run `:Lazy update` inside Neovim
- `lazyvim.json` controls which LazyVim extras (language packs, UI extras) are active
- The colorscheme is Catppuccin with `flavour = "auto"` (follows macOS dark/light mode via `auto-dark-mode.nvim`)
- Lua formatter is StyLua — run `stylua .` to format all Lua files in this directory

### Testing Requirements
- Launch Neovim to verify config loads without errors (`nvim --headless +qall` for quick check)
- After adding a new plugin, run `:Lazy sync` inside Neovim

### Common Patterns
- Plugin specs live in `lua/plugins/` — each file returns a table of plugin specs
- Config overrides (options, keymaps, autocmds) live in `lua/config/`

## Dependencies

### External
- `neovim` (≥0.9) — the editor itself
- `lazy.nvim` — plugin manager (auto-bootstrapped by `init.lua`)
- `LazyVim` — base configuration layer
- `git`, `ripgrep`, `fd`, `fzf`, `lazygit` — external tools required by various plugins
- `tree-sitter-cli` — for Tree-sitter grammar compilation

<!-- MANUAL: -->
