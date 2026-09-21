# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A [chezmoi](https://chezmoi.io) source directory for a macOS workstation. There is no build, no test suite, and no application code — every file is either a managed dotfile template or bootstrap glue.

## Commands

```bash
make                  # full bootstrap: init, claude CLI, brew, brew bundle, chezmoi apply, node, skills, fonts, wallpaper
make chezmoi          # apply only (also writes ~/.config/chezmoi/chezmoi.toml if missing)
make node             # create ~/.nvm, then `nvm install --lts`; nvm itself comes from the Brewfile
make skills           # wipe every globally installed skill, then install skills/ to Claude Code, Copilot and Codex
chezmoi diff          # preview what an apply would change — run this before applying
chezmoi apply         # push source -> $HOME
chezmoi managed       # list every path chezmoi owns
chezmoi target-path home/dot_zshrc   # source path -> real $HOME path
```

`brew bundle --global` reads `home/dot_homebrew/Brewfile` (applied as `~/.homebrew/Brewfile`), so a new package must be added there, not installed ad hoc.

## Source layout / naming

`.chezmoiroot` is `home`, so **`home/` is the chezmoi source root** and everything above it (`Makefile`, `bin/`, `assets/`, `skills/`) is repo scaffolding that never lands in `$HOME`. Never landing is not the same as never being read: `.chezmoiroot` is chezmoi's own, and `home/private_dot_copilot/private_mcp-config.json.tmpl` does `include "../private/pass/ids.toml"`, so the root-level `private/` submodule is read at apply time (hence `make chezmoi` checks it out first). `skills/` also reaches `$HOME`, but by its own route; see [Skills](#skills).

chezmoi decodes filenames — the prefixes are meaningful, not cosmetic:

| Source | Applies to | Meaning |
|---|---|---|
| `home/dot_zshrc` | `~/.zshrc` | `dot_` → leading dot |
| `home/dot_claude/private_settings.json` | `~/.claude/settings.json` | `private_` → mode 0600 |
| `home/dot_config/nvim/lua/plugins/lsp.lua` | `~/.config/nvim/lua/plugins/lsp.lua` | directories pass through unchanged |

Renaming a file changes where it lands. When adding a dotfile, prefer `chezmoi add ~/.foo` over hand-crafting the name.

## Skills

Agent skills are not chezmoi-managed. `skills/` at the repo root is the canonical source — one `skills/<name>/SKILL.md` per skill — and the [`skills`](https://github.com/vercel-labs/skills) CLI owns distribution.

- `skills/` sits outside `home/`, so `.chezmoiroot` ignores it entirely. `chezmoi apply` and `chezmoi managed` know nothing about skills.
- `make skills` runs `skills remove -g --all` then `skills add ./skills`, and depends on `node`, so make bootstraps node itself. The remove is not scoped to this repo: it walks `~/.agents/skills` and every known agent's global skills dir and deletes every directory holding a `SKILL.md`, whatever installed it. That is the point — it makes the installed set equal `skills/` — but anything global you added by hand is gone too.
- The CLI is pinned to `skills@1.7.0`. It discards rather than migrates lock files written by an older version constant, so moving the pin makes the new CLI throw away the lock file 1.7.0 wrote. Do not bump it casually.
- The CLI copies each skill to `~/.agents/skills/<name>/`, then symlinks `~/.claude/skills/<name>`, `~/.copilot/skills/<name>` and `~/.codex/skills/<name>` at that copy. The symlinks point at the copy, not at this repo — editing `skills/` changes nothing live, you have to re-run `make skills`.
- A skill's directory name must equal its frontmatter `name`, because the CLI installs under the frontmatter name.
- Write skills agent-neutral. The CLI has no templating; one identical file ships to all three agents.

## Editing rules

- Edit files here, then `chezmoi apply`. Editing `~/.zshrc` directly puts the two out of sync — pull such changes back with `chezmoi re-add`.
- `home/dot_p10k.zsh`, `home/dot_config/nvim/lazy-lock.json`, and `home/dot_config/gh/private_hosts.yml` are tool-generated. Regenerate them with their own tool (`p10k configure`, `:Lazy update`, `gh auth login`) rather than editing by hand.
- Shell config is split: `dot_zshenv` (read by every zsh, interactive or not — it exports `DO_NOT_TRACK=1` to opt out of the `skills` CLI's default-on telemetry, which `dot_zshrc` could not cover), `dot_zprofile` (login-shell integrations: orbstack, rbenv), `dot_zshrc` (interactive: nvm, PATH, aliases, p10k), `dot_zsh/functions/*` (autoloaded one per file by the loop at the end of `dot_zshrc`).
- Neovim is a LazyVim install: `home/dot_config/nvim/lua/plugins/*.lua` for plugin specs, `lua/config/*.lua` for options/keymaps.
