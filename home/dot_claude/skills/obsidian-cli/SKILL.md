---
name: obsidian-cli
description: Reference for reading, writing, and searching an Obsidian vault via the `obsidian` CLI. Use when the user wants to create, append to, read, or search Obsidian notes from the command line, or asks how the Obsidian CLI works.
---

Reference for the `obsidian` CLI (see `obsidian --help` for the full command list; this covers the commands actually needed day to day).

## Targeting a vault

Every command accepts a global `vault=<name>` option:

```bash
obsidian vault="Personal notes" daily:path
```

List known vaults (name and absolute filesystem path, tab-separated):

```bash
obsidian vaults verbose
```

If `vault=` is omitted, commands act on whichever vault/file is currently active in the Obsidian app.

## Reading and writing arbitrary notes

```bash
obsidian vault="<v>" read file="Note Name"          # print note contents
obsidian vault="<v>" append file="Note Name" content="text to add"
obsidian vault="<v>" create name="New Note" content="# Title" [overwrite]
```

- `file=` resolves like a wikilink (by name); `path=` is an exact vault-relative path (e.g. `Folder/Note.md`).
- `create` without `overwrite` will not clobber an existing file; pass `overwrite` to replace it.
- There is no dedicated "replace/update" command — updating a note's full content means `create ... overwrite` with the complete new content, or `append`/`prepend` to add to what's there.
- Multi-line content: the CLI's own convention is literal `\n` / `\t` escape sequences inside the `content=` string (per the [CLI docs](https://obsidian.md/help/cli)), not raw newline bytes, when typed at a shell. From a script invoking the CLI as a subprocess with an argv list (not a shell string), this matters less since you control the exact bytes passed — but stick to `\n`/`\t` escapes for consistency with how the CLI itself round-trips content.

## Daily notes

```bash
obsidian vault="<v>" daily:path              # relative path of today's daily note
obsidian vault="<v>" daily:read              # print today's daily note contents
obsidian vault="<v>" daily:append content="- did a thing"
obsidian vault="<v>" daily:prepend content="- did a thing"
```

Gotcha: `daily:path` and `daily:read` both **create today's daily note as an empty file if it doesn't exist yet** — calling either is enough to guarantee the file exists before you touch it directly on disk.

## Search / links (useful for building a note graph)

```bash
obsidian vault="<v>" search query="text"
obsidian vault="<v>" backlinks file="Note Name" counts
obsidian vault="<v>" unresolved                 # links pointing at notes that don't exist yet
```

A `[[Wikilink]]` to a note that doesn't exist yet is valid and shows up in Obsidian's graph as an unresolved link — you don't need to create the target note first.

## Related

[[obs-daily]] uses this CLI to log end-of-day work summaries into the daily note, grouped by project.
