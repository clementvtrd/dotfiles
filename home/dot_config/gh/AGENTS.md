<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# gh

## Purpose
Chezmoi source for `~/.config/gh/`. Contains GitHub CLI configuration. Files use the `private_` prefix and are deployed with mode 600 to protect credentials.

## Key Files

| File | Description |
|------|-------------|
| `private_config.yml` | GitHub CLI preferences (editor, pager, protocol, aliases) |
| `private_hosts.yml` | GitHub authentication tokens per host — deployed with mode 600 |

## For AI Agents

### Working In This Directory
- Both files are `private_` prefixed — never log or echo their contents
- `private_hosts.yml` contains OAuth tokens; treat as secrets
- These files are managed by `gh auth login` — prefer using `gh` CLI to modify auth rather than editing directly

<!-- MANUAL: -->
