---
name: pr-description
description: Write a clean, concise pull request description using the Why / How / Preview structure. Use when asked to write, draft or improve a PR description.
---

# Pull request description

Write a short, clear PR description that helps a reviewer understand **why** the change exists and **how** it was approached — not a changelog of files.

## 1. Gather context

Before writing anything, collect what you can on your own:

- The diff against the base branch (`git diff <base>...HEAD`) and the commit messages (`git log <base>..HEAD`).
- The branch name and any linked issue / ticket reference.
- Anything the user already said about the change.

From this, identify:

- **The need**: the business or technical problem the PR solves.
- **The strategy**: the approach chosen to solve it (and, if visible, why this approach over another).
- **Frontend impact**: whether the PR changes anything a user can see (templates, styles, components, UI behavior).

## 2. Clarify before writing

Never write a description that contains guesses or vague statements. If any of the following is unclear, **stop and ask the user first** (use the AskUserQuestion tool when available, otherwise ask in plain text), with specific questions:

- The need is not obvious from the code, commits or ticket (e.g. you can see *what* changed but not *why*).
- The diff mixes several unrelated changes and it's unclear which one is the point of the PR (or whether it should be split).
- The strategy involves a trade-off or a choice whose reasoning you can't infer.
- You can't tell whether the change has a visible frontend impact.
- Something in the diff looks unintended (debug code, unrelated file, commented-out block).

Ask only what you genuinely can't determine. Don't ask about things the diff answers.

## 3. Write the description

Always use exactly this structure:

```md
## Why?

{{ The business OR technical need that introduces this PR }}

## How?

{{ A brief on which strategy has been used to resolve the need }}

## Preview?

**Before:**

{{ Screenshots if the PR updates the frontend }}

**After:**

{{ Screenshots if the PR updates the frontend }}
```

### Why?

- 1 to 3 sentences. State the problem or need, not the solution.
- Prefer the business framing when there is one ("Editors can't schedule a post…"); otherwise the technical one ("The import job times out on catalogs over 10k products…").
- Reference the ticket/issue if there is one.

### How?

- Describe the **strategy**, not the implementation inventory.
- **Never list changed files**, classes or methods one by one. Explain the approach: the idea, the key decision, and the trade-off if relevant.
  - Bad: "Updated `ProductImporter.php`, added `BatchHandler.php`, modified `services.yaml`."
  - Good: "The import is now split into batches of 500 products dispatched to Messenger, so each batch runs in its own worker and a failure only retries that batch."
- A short paragraph or a few bullets at most. Mention anything the reviewer should pay particular attention to (migration, breaking change, config to set).

### Preview?

- If the PR changes the frontend: keep **Before** / **After** and leave clear placeholders for the developer to drop screenshots in (e.g. `<!-- Screenshot: product page before -->`), unless screenshots were provided — then use them.
- If the PR has no visible frontend impact: keep the `## Preview?` heading and write `No visual change.` instead of the Before/After blocks.

## 4. Style rules

- Concise: a reviewer should get the point in under 30 seconds.
- Plain, concrete wording. No filler ("This PR aims to…"), no marketing tone.
- Write in the language the user / repository uses for PRs (ask if unsure).
- Output the description in a single markdown block ready to paste, unless the user asked you to set it directly on the PR (e.g. via `gh pr edit --body`).
