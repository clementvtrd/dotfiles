# skills

Canonical source for my personal agent skills.

This directory is owned by the [`skills` CLI](https://github.com/vercel-labs/skills), **not by chezmoi**. It sits at the repo root, outside `home/`, so `chezmoi apply` never touches it. Installing these is a separate step from applying the dotfiles.

## Layout

One directory per skill, each containing a `SKILL.md`:

```
skills/
  commit/SKILL.md
  context7-mcp/SKILL.md
  grill-me/SKILL.md
  i-have-adhd/SKILL.md
  internal-audit/SKILL.md
```

`SKILL.md` starts with YAML frontmatter. `name` and `description` are required; anything else (`user-invocable`, `disable-model-invocation`, …) is passed through to the agent untouched.

```markdown
---
name: commit
description: Instructions to generate a clear and useful commit message. Use when the user ask a commit message or ask to commit changes.
---

<the skill body>
```

The CLI installs each skill under its frontmatter `name`, so **the directory name must equal the frontmatter `name`**. A mismatch installs the skill under a directory you did not expect.

## Install

From a checkout of this repo, `make skills`.

**It deletes every globally installed skill on the machine first.** It runs `skills remove -g --all` before installing, and that sweep is not scoped to this repo: it walks the canonical `~/.agents/skills` *and* every known agent's global skills directory, removing every directory that contains a `SKILL.md`, whatever installed it. This repo therefore owns the machine's global skill namespace — anything you installed globally from another source is gone after `make skills`, and the globally installed set becomes exactly the contents of this directory. Project-local skills are not touched.

The target needs Homebrew's nvm at `/opt/homebrew/opt/nvm/nvm.sh` (`brew install nvm`) to get an `npx`. Without it, `make skills` prints a warning, installs nothing, and still exits 0.

```bash
make skills
```

Anyone else, no checkout needed:

```bash
npx skills@1.7.0 add clementvtrd/dotfiles -g -a claude-code -a github-copilot -a codex -s '*' -y
```
`-a` must be repeated. `skills@1.7.0` does not split a comma-separated list and
rejects `-a claude-code,github-copilot,codex` as a single invalid agent name.

The CLI only symlinks agents whose *project* skills dir is not `.agents/skills`,
so in global mode it populates `~/.claude/skills` but not `~/.copilot/skills` or
`~/.codex/skills`. `make skills` runs a `skills-link` step afterwards to link the
canonical copies into both.


Pin the version — the repo pins 1.7.0 everywhere. Spell out `-a`: without it the CLI opens an interactive agent multiselect whose defaults are claude-code, opencode and codex, which is not the set below. This command only adds; it does not remove anything.

## Where they land

The CLI copies each skill into a canonical `~/.agents/skills/<name>/`, then symlinks the per-agent directories at it:

| Agent | Path |
|---|---|
| Claude Code | `~/.claude/skills/<name>` |
| GitHub Copilot | `~/.copilot/skills/<name>` |
| Codex | `~/.codex/skills/<name>` |

Only the Copilot path is hardcoded. The CLI derives the Claude Code path from `CLAUDE_CONFIG_DIR` and the Codex path from `CODEX_HOME` when those are set, so the table shows the defaults.

One copy on disk, three agents reading it.

## Adding a skill

1. `mkdir skills/<name>` and write `skills/<name>/SKILL.md` with `name: <name>` in the frontmatter.
2. `make skills`.

## Gotcha

**Skills must be agent-neutral.** The CLI has no templating — it ships one identical file to every agent. Do not write "Claude", "Copilot" or agent-specific tool names into a skill body; describe the behaviour instead.
