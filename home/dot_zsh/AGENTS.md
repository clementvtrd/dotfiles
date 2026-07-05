<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# dot_zsh

## Purpose
Chezmoi source for `~/.zsh/`. Holds extra Zsh files that are sourced from `~/.zshrc`. Currently contains custom shell functions that are auto-loaded at login.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `functions/` | Custom Zsh functions — all files are sourced automatically by `.zshrc` at startup (see `functions/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- `.zshrc` contains `for f in "$HOME"/.zsh/functions/*; do source "$f"; done` — every file in `functions/` is sourced automatically
- Add new shell utilities as individual files in `functions/`, not inline in `.zshrc`

<!-- MANUAL: -->
