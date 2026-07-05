<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-05 | Updated: 2026-07-05 -->

# functions

## Purpose
Custom Zsh functions automatically sourced at login by `~/.zshrc` (`for f in "$HOME"/.zsh/functions/*; do source "$f"; done`). Each file defines one or more related shell functions.

## Key Files

| File | Description |
|------|-------------|
| `claude` | Launches a Claude Code sandbox for the current project via `sbx`, reusing an existing sandbox if one with the same name exists |
| `to` | Project navigator: `to <name>` changes directory to `~/Projects/*/<name>` with zsh tab-completion |
| `_sdx` | Zsh completion script for the `sbx` CLI (cobra-generated, handles flags and subcommands) |

## For AI Agents

### Working In This Directory
- All files are sourced unconditionally — avoid side effects at source time (no curl, no slow commands)
- Completion functions (`_sdx`) must be named with a leading underscore and registered via `compdef`
- The `claude` function depends on `sbx` being installed (from Brewfile) and the kit at `~/.sbx_kits/oh-my-claude.zip`
- The `to` function expects projects at `~/Projects/<org>/<name>` (two-level hierarchy)

### Common Patterns
- Completion functions pair with their command: `_sdx` completes `sbx`, `_to` completes `to`
- Use `compdef _fn cmd` to register completions after defining the `_fn` function

## Dependencies

### External
- `sbx` — required by `claude` function
- `~/Projects/` directory structure — required by `to` function

<!-- MANUAL: -->
