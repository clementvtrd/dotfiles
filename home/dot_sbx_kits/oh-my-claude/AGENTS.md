<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# oh-my-claude

## Purpose
Sandbox kit definition for [oh-my-claude](https://github.com/anthropics/oh-my-claude), a multi-agent orchestration layer for Claude Code. The kit is packed with `sbx kit pack` and launched via the `claude` zsh function, which creates or reuses a sandbox named after the current project directory.

## Key Files

| File | Description |
|------|-------------|
| `spec.yaml` | Sandbox specification: image, environment variables, install and startup commands |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `files/` | Files to inject into the sandbox environment at launch time |
| `files/home/` | Mapped to the sandbox user's home directory |

## Key Files (files/)

| File | Description |
|------|-------------|
| `files/home/.tmux.conf` | tmux configuration for the sandbox terminal: 256-color, mouse on, 50k history |

## For AI Agents

### Working In This Directory
- `spec.yaml` schema version 2 — refer to `sbx` documentation for field reference
- Install commands run once when the kit image is built; startup commands run on every sandbox launch
- The kit installs: `mattpocock/skills` (AI skill library), `rtk` (AI CLI tool), `tmux`, and the latest `oh-my-claude-sisyphus` npm package
- Environment variable `NAMEOMC_NOTIFY=0` disables oh-my-claude desktop notifications inside the sandbox

### Common Patterns
- The `claude` function in `dot_zsh/functions/claude` automates the pack+launch workflow
- Sandbox name matches the current directory basename — one sandbox per project

## Dependencies

### Internal
- `dot_zsh/functions/claude` — shell function that invokes this kit

### External
- `sbx` CLI — sandbox management tool (installed via Homebrew cask `docker/tap/sbx`)
- `oh-my-claude-sisyphus` npm package — installed inside the sandbox at kit install time

<!-- MANUAL: -->
