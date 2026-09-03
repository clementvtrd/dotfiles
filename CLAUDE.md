# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A [chezmoi](https://chezmoi.io) source directory for a macOS workstation. There is no build, no test suite, and no application code — every file is either a managed dotfile template or bootstrap glue.

## Commands

```bash
make                  # full bootstrap: brew, claude CLI, brew bundle, chezmoi apply, fonts, wallpaper
make chezmoi          # apply only (also writes ~/.config/chezmoi/chezmoi.toml if missing)
chezmoi diff          # preview what an apply would change — run this before applying
chezmoi apply         # push source -> $HOME
chezmoi managed       # list every path chezmoi owns
chezmoi target-path home/dot_zshrc   # source path -> real $HOME path
```

`brew bundle --global` reads `home/dot_homebrew/Brewfile` (applied as `~/.homebrew/Brewfile`), so a new package must be added there, not installed ad hoc.

## Source layout / naming

`.chezmoiroot` is `home`, so **`home/` is the chezmoi source root** and everything above it (`Makefile`, `bin/`, `assets/`, `.claude/`) is repo scaffolding that never lands in `$HOME`.

chezmoi decodes filenames — the prefixes are meaningful, not cosmetic:

| Source | Applies to | Meaning |
|---|---|---|
| `home/dot_zshrc` | `~/.zshrc` | `dot_` → leading dot |
| `home/dot_claude/private_settings.json` | `~/.claude/settings.json` | `private_` → mode 0600 |
| `home/dot_claude/skills/grill-me/SKILL.md` | `~/.claude/skills/grill-me/SKILL.md` | directories pass through unchanged |

Renaming a file changes where it lands. When adding a dotfile, prefer `chezmoi add ~/.foo` over hand-crafting the name.

## Editing rules

- Edit files here, then `chezmoi apply`. Editing `~/.zshrc` directly puts the two out of sync — pull such changes back with `chezmoi re-add`.
- `home/dot_p10k.zsh`, `home/dot_config/nvim/lazy-lock.json`, and `home/dot_config/gh/private_hosts.yml` are tool-generated. Regenerate them with their own tool (`p10k configure`, `:Lazy update`, `gh auth login`) rather than editing by hand.
- Shell config is split: `dot_zprofile` (login-shell integrations: orbstack, rbenv), `dot_zshrc` (interactive: nvm, PATH, aliases, p10k), `dot_zsh/functions/*` (autoloaded one per file by the loop at the end of `dot_zshrc`).
- Neovim is a LazyVim install: `home/dot_config/nvim/lua/plugins/*.lua` for plugin specs, `lua/config/*.lua` for options/keymaps.
