<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# dot_ssh

## Purpose
Chezmoi source for `~/.ssh/`. Contains the SSH client configuration file. Private keys and credentials are NOT stored in this repository.

## Key Files

| File | Description |
|------|-------------|
| `config` | SSH client config — includes OrbStack SSH config and a glob include for `config.d/*` |

## For AI Agents

### Working In This Directory
- Never commit SSH private keys here
- `config` uses `Include` directives: OrbStack manages its own entries; per-host overrides go in `config.d/`
- chezmoi does not track `~/.ssh/` private keys — add those via chezmoi's secret management or manually

<!-- MANUAL: -->
