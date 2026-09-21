---
name: context7-mcp
description: This skill should be used when the user asks about libraries, frameworks, API references, or needs code examples. Activates for setup questions, code generation involving libraries, or mentions of specific frameworks like React, Vue, Next.js, Prisma, Supabase, etc.
---

When the user asks about libraries, frameworks, or needs code examples, use Context7 to fetch current documentation instead of relying on training data. Fetched documentation is cached on disk, so repeat questions cost nothing.

## When to Use This Skill

Activate this skill when the user:

- Asks setup or configuration questions ("How do I configure Next.js middleware?")
- Requests code involving libraries ("Write a Prisma query for...")
- Needs API references ("What are the Supabase auth methods?")
- Mentions specific frameworks (React, Vue, Svelte, Express, Tailwind, etc.)

## The Cache

Everything fetched from Context7 is stored under `~/.cache/context7/`, shared across every project and every agent on this machine.

```
~/.cache/context7/
├── _resolved.md                                 library name → ID, 90-day TTL
├── vercel/
│   └── next.js/
│       ├── middleware-matchers.2026-09-14.md
│       ├── app-router-caching.2026-09-08.md
│       └── v15/
│           └── server-actions.2026-09-01.md
└── prisma/
    └── docs/
        └── relation-queries.2026-09-12.md
```

A **directory** is one segment of a Context7 library ID; a **`.md` file** is one cached answer. They can never be confused, so `/vercel/next.js` and `/vercel/next.js/v15` coexist as a directory and its subdirectory. Names beginning with `_` at the root are metadata, not libraries. Nothing needs creating in advance — writing the first file creates the tree.

### Cache file format

```markdown
---
libraryId: /vercel/next.js/v15
query: how do I configure middleware matchers in Next.js 15?
fetched: 2026-09-14
---

<the query-docs response, verbatim and unmodified>
```

The date appears in both the filename and the frontmatter deliberately: the filename makes freshness readable from a directory listing without opening anything, while the frontmatter preserves the original question.

### Tool discipline — this part is not optional

The RTK `PreToolUse` hook rewrites shell commands, and three of those rewrites corrupt this workflow **silently** — no error, no warning, just missing or filtered content that looks exactly like the real thing.

| To do this | Use | Never use | What goes wrong |
|---|---|---|---|
| Read a cached answer | your file-reading tool | `cat`, `head` | rewritten to `rtk read`, which filters out ~60% of the content |
| List a library directory | your glob / file-search tool | `ls`, `find` | `rtk ls` prints only the top-level directory name — **filenames are hidden, so every lookup misses** |
| Inspect the cache by hand | `rtk proxy cat`, `rtk proxy ls` | — | `proxy` is the documented bypass for the hook |
| Delete expired files | `rm` | — | not rewritten; works normally |

## How to Fetch Documentation

### Step 1: Resolve the Library ID

Read `~/.cache/context7/_resolved.md` first. If an entry's `names` include what the user asked for and its `fetched` date is within **90 days**, use its `id` and skip the MCP call.

```markdown
---
resolved:
  - names: [next.js, nextjs, next]
    id: /vercel/next.js/v15
    fetched: 2026-09-14
---
```

Otherwise call `resolve-library-id` with:

- `libraryName`: The library name extracted from the user's question
- `query`: What to look up in the library's documentation (improves relevance ranking)

### Step 2: Select the Best Match

From the resolution results, choose based on:

- Exact or closest name match to what the user asked for
- Higher benchmark scores indicate better documentation quality
- If the user mentioned a version (e.g., "React 19"), prefer version-specific IDs

Then record it: re-read `_resolved.md` immediately before writing (another session may have added an entry since you last read it) and append the new name/ID pair. This is the only shared file in the cache — a lost write costs one future resolution call and nothing more.

### Step 3: Check the Cache

Glob the library's directory, mapping the ID to a path (`/vercel/next.js/v15` → `~/.cache/context7/vercel/next.js/v15/*.md`), and judge the filenames:

- **Hit** — a filename names this topic *and* its date is within **7 days**. Read that one file and go to Step 5.
- **Miss** — nothing names the topic, the match is 7+ days old, or it covers only part of what was asked.

Partial coverage is a miss, not a hit. A cached answer is used only when it answers the question completely; never blend a stale section with a fresh one to fill a gap.

### Step 4: Fetch the Documentation

Call `query-docs` with:

- `libraryId`: The selected Context7 library ID (e.g., `/vercel/next.js`)
- `query`: What to look up in the library's documentation, scoped to a single concept

If the user's question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic.

### Step 5: Use the Documentation

Incorporate the documentation into your response:

- Answer the user's question using current, accurate information
- Include relevant code examples from the docs
- Cite the library version when relevant

When the answer came from cache, close with a provenance line so the reader can weigh its age:

```
_cache: /vercel/next.js/v15 — fetched 2026-09-09 (5d ago)_
```

Fresh fetches say nothing — freshness is the assumed default. That asymmetry matters: if these lines stop appearing over time, the cache has quietly stopped working.

### Step 6: Write the Cache

After a fetch, and only after a real result:

1. **Prune.** In that library's directory, `rm` every `.md` dated 7+ days ago, plus any older file covering this same topic.
2. **Name the file** for the *topic*, two to four words, not the sentence the user typed — `middleware-matchers.md`, not `how-do-i-configure-middleware-matchers-in-next-js-15.md`. Short names are what make the next lookup's judgement reliable. If a file already names this topic, refresh that one rather than adding a near-duplicate.
3. **Write** `<topic>.<YYYY-MM-DD>.md` with the frontmatter above and the verbatim response body.

Never write a cache file for an empty response, an MCP error, or a library that failed to resolve. A cache that can hold "no documentation exists for X" will eventually assert that about a library documented last week.

## Guidelines

- **Check the cache first**: it is the cheapest possible answer, and it works across every project on this machine
- **Be specific**: Describe what to look up in the library's documentation, but keep each query to a single concept
- **One topic per query**: Split multi-topic questions into separate `query-docs` calls — resolve the library ID once, then query per concept, unless the question is about how the concepts interact
- **Version awareness**: When users mention versions ("Next.js 15", "React 19"), use version-specific library IDs if available from the resolution step
- **Prefer official sources**: When multiple matches exist, prefer official/primary packages over community forks
