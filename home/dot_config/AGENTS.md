<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# dot_config

## Purpose
Chezmoi source for `~/.config/`. Contains XDG configuration directories for applications that follow the XDG Base Directory specification.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `gh/` | GitHub CLI configuration — auth hosts and preferences (see `gh/AGENTS.md`) |
| `nvim/` | Neovim configuration based on LazyVim (see `nvim/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Files with the `private_` prefix are deployed with mode 600 (user-readable only)
- New XDG-compliant app configs should be added here as subdirectories

<!-- MANUAL: -->
