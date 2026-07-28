---
name: obs-memory
description: Mirror human-relevant facts from Claude's native memory system into human-readable Obsidian notes, per project and per reusable topic. Use immediately after saving or updating any native memory file, and when starting work in a project or when a topic it covers comes up in conversation.
---

Claude's native memory system (the one described under "auto memory" in these instructions) keeps working exactly as it always does — this skill does not replace or modify it. `obs-memory` sits alongside it as a **secondary, filtering mirror**: whenever that native system saves or updates a memory, this skill decides whether the fact is worth a human ever reading back, and if so, writes a curated, human-readable version of it into the **"Personal notes"** Obsidian vault.

## 0. Gate: is this project opted out?

Before doing anything, check whether the current project configures its own memory internally:

```bash
grep -qE '^#{1,2}[[:space:]]+Memory[[:space:]]*$' CLAUDE.md 2>/dev/null && echo "opted out"
```

If a `# Memory` or `## Memory` heading exists in the project's `CLAUDE.md`, **do nothing** — that project has its own scheme and `obs-memory` must not touch it. Otherwise, proceed.

## 1. Determine the project name

```bash
git rev-parse --show-toplevel 2>/dev/null | xargs -I{} basename {}
```

Fall back to the basename of the current directory if not inside a git repo.

## 2. When a native memory is saved or updated

Only `project`-type and `reference`-type native memories are candidates. `user` and `feedback` types are never mirrored — they're about the assistant/user relationship, not durable human-facing knowledge.

For each candidate, judge the actual content (not just its type label) against two destinations:

- **Project page** — anything that may affect a human in any way: business rules, infrastructure/tooling impact, design or code decisions, project-specific `reference` facts (e.g. "bugs tracked in Linear project X"), etc.
- **Topic page** — `reference` or `project` content that describes reusable knowledge about a technology or notion, applicable beyond this one project (e.g. a Symfony routing gotcha, a general API's behavior).

A single fact only goes to one destination. If it fits neither (pure scheduling noise, purely about how Claude should behave, etc.), skip it — don't force a write.

## 3. Writing to the project page

File: `projects/<project-name>.md` in the `"Personal notes"` vault (create silently on first write — this path is deterministic, so no confirmation needed for the file itself).

1. Read the current page (`obsidian vault="Personal notes" read path="projects/<project-name>.md"`, or empty if it doesn't exist yet — `read` errors on a missing file, that's expected on first write).
2. Find the right heading. Default top-level categories: `## Business rules`, `## Infrastructure`, `## Design decisions`, `## Other` (catch-all). Use `### ` sub-headings only to group a cluster of related bullets within one theme — never deeper than that.
3. **New top-level (`##`) category needed?** Propose it to the user and wait for confirmation before creating it. Adding to an existing heading never needs confirmation.
4. **Supersession check**: if the new fact replaces something already stated under that heading, replace that bullet entirely with one new self-contained bullet that folds in the reason for the change (e.g. "Auth was rewritten from JWT to sessions in 2026-03 to satisfy legal's compliance requirement on token storage") — never leave the old and new bullets side by side as a history.
5. Write the full updated content back with `obsidian vault="Personal notes" create path="projects/<project-name>.md" content="..." overwrite`. Use `path=`, not `name=` — `name=` resolves like a wikilink and rejects the `/` in a folder path.

## 4. Writing to a topic page

Path shape: `topics/<tech>/<subject>.md`, or just `topics/<tech>.md` when there isn't yet enough content to justify splitting by subject.

1. **Search first**: check existing files under `topics/` (e.g. `obsidian search query="<tech>"`, or list the vault folder) for a page that already covers this. Reuse it if found.
2. If nothing fits, propose the new path to the user (including whether it should be a flat `topics/<tech>.md` or a `topics/<tech>/<subject>.md` split) and wait for confirmation before creating it. This also applies when an existing flat `topics/<tech>.md` has grown enough to warrant splitting into a subject folder.
3. Once the target file is settled, apply the same heading rules, supersession rule, and write mechanics as the project page (steps 3.2–3.5), just with no pre-seeded default categories — headings emerge from the content.

## 5. After writing

Always tell the user, in the normal text response, what was written and where — e.g. "Updated `projects/defimedoc.md` — replaced the auth section with the sessions-based rewrite rationale." Never ask for confirmation before writing (only the two structural cases above — new top-level heading, new topic file/split — require confirmation).

## 6. Reading back

- When starting work in a project (that isn't opted out per step 0), read `projects/<project-name>.md` from Obsidian if it exists, and fold it into context.
- When a topic relevant to an existing topic page comes up in conversation, read that topic page too.

This is what makes the vault genuinely bidirectional: manual edits made directly in Obsidian feed back into what Claude knows, rather than the vault being a write-only export.
