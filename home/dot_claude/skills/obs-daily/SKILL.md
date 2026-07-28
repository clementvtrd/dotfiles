---
name: obs-daily
description: Log a one-line summary of the current session's work into today's Obsidian daily note, grouped by project. Use when the user says things like "log this to obsidian", "log today's work", "add this to my daily note".
---

Logs a one-line bullet describing the current session's work into today's Obsidian daily note, in the **"Personal notes"** vault, grouped under a per-project section.

See [[obsidian-cli]] for general CLI background.

## Procedure

1. **Determine the project name** from the current working directory:
   ```bash
   git rev-parse --show-toplevel 2>/dev/null | xargs -I{} basename {}
   ```
   Fall back to the basename of the current directory if not inside a git repo.

2. **Draft a one-line summary** of what was actually accomplished in the current session — terse, no fluff, no trailing period-per-bullet-style padding. Show the drafted line to the user and wait for approval or edits. Do not write anything yet.

3. Once approved, **run the bundled merge script**:
   ```bash
   python3 ~/.claude/skills/obs-daily/scripts/log_day.py \
     --vault "Personal notes" \
     --project "<project-name>" \
     --bullet "<approved one-liner>"
   ```

4. Confirm to the user where it was written (the script prints the resolved file path).

## Structure this produces

Each project gets its own top-level section, headed by a wikilink to a project note of the same name (so Obsidian's graph shows relations between days and projects, even before that note exists):

```markdown
## [[defimedoc]]
- Fixed the pagination bug on the search results page.

## [[trainings]]
- Migrated the Symfony module's REST API docs.
- Wrote the Obsidian CLI skill and this obs-daily logging skill.
```

- Sections are kept sorted alphabetically by project name.
- Multiple invocations for the same project on the same day add more bullets under the existing section rather than creating a duplicate one.
- Anything else already in the daily note (manual notes, other headings) is left exactly as it was — the merge only ever touches `## [[ProjectName]]` sections, and always places that whole block after everything else in the file.
