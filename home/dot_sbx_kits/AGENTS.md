<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# dot_sbx_kits

## Purpose
Chezmoi source for `~/.sbx_kits/`. Contains sandbox kit definitions for the `sbx` CLI tool. Each kit packages a set of tools and configuration to be injected into a Claude Code sandbox environment.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `oh-my-claude/` | Sandbox kit for the oh-my-claude multi-agent orchestration layer (see `oh-my-claude/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Kits are packed with `sbx kit pack` and run with `sbx run --kit`
- The `claude` zsh function (in `dot_zsh/functions/`) automates kit packing and launching

<!-- MANUAL: -->
