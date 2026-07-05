<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# bin

## Purpose
Helper shell scripts used during bootstrap. Invoked by the Makefile targets — not deployed to `~` by chezmoi.

## Key Files

| File | Description |
|------|-------------|
| `install-cascadia-macos.sh` | Downloads and installs the Cascadia Code Nerd Font on macOS |

## For AI Agents

### Working In This Directory
- Scripts here are run during `make fonts-cascadia`, not by chezmoi
- Keep scripts idempotent — the Makefile may call them on already-provisioned machines

<!-- MANUAL: -->
