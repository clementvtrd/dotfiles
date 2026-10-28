---
name: implements
description: Start the implementation of a GitHub issue from its ID. Chains scope, code, tests and review, calling the debugger and specialist reviewer agents the issue calls for. Use when the user runs /implements <id> or asks to start working on an issue by its number.
argument-hint: <id>
---

# Implements

Start the implementation of a GitHub issue, from scope to review.

Argument: `<id>`: the issue number (e.g. `123`, a leading `#` is fine). If it is missing or not a number, ask for it and stop.

You support the user, you don't decide for them: the scope, the plan and anything that leaves the machine (push, PR creation, comments) are confirmed with them first.

## Steps

Run each skill in order. Don't start a step until the previous one is done and, where it asks for it, confirmed by the user.

1. **`implements-scope <id>`**: fetch the issue, check existing work, agree on the goal, business rules, acceptance criteria, what is out of scope and which concerns the change touches.
2. **`implements-code`**: prepare the branch, plan, and implement the validated scope with framework-agnostic business rules and no comments.
3. **`implements-tests`**: add tests where they bring value, business rules first, and run the suite.
4. **Review**: run the specialist reviewers yourself, as described below. Agreed fixes go back through `implements-code` or `implements-tests`.

If the user stops or redirects at any step, follow them: they can resume later with the relevant skill on its own.

## Agents by issue

The issue's type and concerns, settled in the scope, decide which agents join in:

| When the issue… | Agent | Step |
|---|---|---|
| reports a bug, a regression or unexpected behaviour | `debugger` | scope, then code if a check fails for unclear reasons |
| changes a schema, a migration or an ORM mapping | `migration-reviewer` | code, as soon as the migration is written, then review |
| changes behaviour | `test-gap-reviewer` | tests |
| changes source code beyond config or docs | `architecture-reviewer` | review |
| has a security concern | `security-reviewer` | review |
| has a performance concern | `performance-reviewer` | review |
| has a documentation concern | `docs-drift` | review |

Agents are read-only and their reports are claims: check what they cite before acting on it.

## Review

Don't dispatch `full-reviewer` from here: a subagent can't dispatch other subagents, so it would review without its specialists. Do its job in this session instead, following the method in `~/.claude/agents/full-reviewer.md` (resolve the scope once, choose, dispatch in parallel, verify, merge, report), with two adjustments:

- **Choosing**: start from the table above. A specialist matching a concern from the scope always runs; the diff can add others the scope missed, never remove one the scope called for. Skip `test-gap-reviewer` if it already ran on the same diff during the tests step.
- **Reporting**: present the verdict and findings to the user and let them pick which ones to fix.

## Wrap up

- Summarize what was done, what was verified, and what was not.
- Commit, push, open a PR and comment on the issue **only when the user asks**. When opening a PR, reference the issue (`Closes #<id>`) and use the `pr-description` skill.
