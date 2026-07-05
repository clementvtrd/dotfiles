<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# dot_homebrew

## Purpose
Chezmoi source for `~/.homebrew/`. Contains the Homebrew bundle manifest and trust lockfiles. The Makefile runs `brew bundle --global install` to install all packages declared here.

## Key Files

| File | Description |
|------|-------------|
| `Brewfile` | Declarative list of all Homebrew formulae, casks, and taps to install |
| `private_trust.json` | Homebrew analytics trust settings (deployed with mode 600) |
| `private_empty_trust.json.lock` | Lockfile for Homebrew trust state (deployed with mode 600) |

## For AI Agents

### Working In This Directory
- When adding a new tool, add it to `Brewfile` with a section comment (`## SectionName`)
- Verify with `brew bundle check` before committing — confirms all packages resolve
- `private_` files are handled by chezmoi and should not be edited manually

### Common Patterns
- Casks that belong in `~/Applications` use `args: { appdir: "~/Applications" }`
- Taps are declared at the top with `tap` directives before their dependent packages

## Dependencies

### External
- `Homebrew` — macOS package manager
- `chezmoi` — deploys this directory to `~/.homebrew`

<!-- MANUAL: -->
