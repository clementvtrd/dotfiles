<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# home

## Purpose
Chezmoi source root. Every file and directory here is deployed to the user's home directory (`~`) by `chezmoi apply`. Chezmoi maps filenames using these prefix conventions:

| Prefix | Mapped destination |
|--------|--------------------|
| `dot_` | `.` (e.g. `dot_zshrc` → `~/.zshrc`) |
| `private_` | deployed with mode 600 |
| `executable_` | deployed with +x |

## Key Files

| File | Description |
|------|-------------|
| `dot_zshrc` | Main Zsh configuration: NVM, Powerlevel10k, PATH, aliases, zsh function autoloading |
| `dot_zprofile` | Zsh login profile: OrbStack integration, rbenv initialization |
| `dot_p10k.zsh` | Powerlevel10k prompt theme configuration |
| `dot_aerospace.toml` | AeroSpace tiling window manager config (keybindings, workspaces, app assignments) |
| `dot_gitconfig` | Global Git config: aliases (`amend`, `undo`), user identity, push defaults |
| `dot_gitignore` | Global Git ignore rules |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `dot_config/` | XDG config dir (`~/.config`) — Neovim and GitHub CLI config (see `dot_config/AGENTS.md`) |
| `dot_homebrew/` | Homebrew bundle: `Brewfile` and trust lockfiles (see `dot_homebrew/AGENTS.md`) |
| `dot_sbx_kits/` | Sandbox kit specs for Claude Code sandbox environments (see `dot_sbx_kits/AGENTS.md`) |
| `dot_ssh/` | SSH client config (see `dot_ssh/AGENTS.md`) |
| `dot_zsh/` | Extra Zsh files: custom functions (see `dot_zsh/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Always use chezmoi prefix conventions when adding new files
- `private_` files (e.g. SSH keys, tokens) must never be committed in plaintext — chezmoi encrypts or excludes them
- `dot_zshrc` sources all files under `~/.zsh/functions/` at login — add new shell functions there, not inline in `.zshrc`

### Testing Requirements
- Run `chezmoi diff` to preview changes before `chezmoi apply`
- Source `~/.zshrc` in a new shell session to test Zsh config changes

### Common Patterns
- Powerlevel10k instant prompt must be sourced near the top of `.zshrc` before any output
- NVM auto-switching via `chpwd` hook on `.nvmrc` presence

## Dependencies

### External
- `chezmoi` — deploys these files to `~`
- `Homebrew` — packages defined in `dot_homebrew/Brewfile`
- `powerlevel10k` — Zsh prompt theme
- `nvm` — Node.js version manager
- `rbenv` — Ruby version manager (initialized in `.zprofile`)
- `OrbStack` — container/VM runtime (shell integration in `.zprofile`)

<!-- MANUAL: -->
