<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# dotfiles

## Purpose
macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). Provides a reproducible developer environment including shell configuration, editor setup, window manager, package management, and AI sandbox tooling. Run `make` from the repo root to bootstrap a fresh machine.

## Key Files

| File | Description |
|------|-------------|
| `Makefile` | Bootstrap entry point — installs Homebrew, runs `brew bundle`, applies chezmoi, installs fonts, sets wallpaper |
| `README.md` | Quick-start installation instructions |
| `.chezmoiroot` | Tells chezmoi to treat `home/` as the source root (maps to `~`) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `home/` | Chezmoi source root — files here are deployed to `~` (see `home/AGENTS.md`) |
| `assets/` | Static assets: wallpapers, iTerm2 color schemes (see `assets/AGENTS.md`) |
| `bin/` | Helper installation scripts (see `bin/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Chezmoi naming conventions: `dot_` prefix → `.` in destination, `private_` prefix → mode 600, `executable_` → chmod +x
- Never edit files under `home/` without understanding their chezmoi-mapped destination in `~`
- The Makefile is the authoritative bootstrap sequence — preserve its idempotency
- `.claude/`, `.omc/`, `.vscode/` are tool-specific operational directories — do not document or modify unless explicitly asked

### Testing Requirements
- Run `chezmoi diff` to preview what would change before running `chezmoi apply`
- Verify Brewfile changes with `brew bundle check` before committing

### Common Patterns
- All dotfiles live under `home/` with chezmoi prefix conventions
- Secrets use the `private_` prefix to ensure restrictive file permissions

## Dependencies

### External
- `chezmoi` — dotfile manager
- `Homebrew` — macOS package manager (bootstrapped by Makefile)
- `make` — build orchestration (requires Xcode CLT)

<!-- MANUAL: -->
