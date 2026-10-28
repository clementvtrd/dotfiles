---
name: implements
description: Start the implementation of a GitHub issue from its ID. Chains three steps: refine the scope, implement it, then add the relevant tests. Use when the user runs /implements <id> or asks to start working on an issue by its number.
argument-hint: <id>
---

# Implements

Start the implementation of a GitHub issue, from scope to tests.

Argument: `<id>`: the issue number (e.g. `123`, a leading `#` is fine). If it is missing or not a number, ask for it and stop.

You support the user, you don't decide for them: the scope, the plan and anything that leaves the machine (push, PR creation, comments) are confirmed with them first.

## Steps

Run each skill in order. Don't start a step until the previous one is done and, where it asks for it, confirmed by the user.

1. **`implements-scope <id>`**: fetch the issue, check existing work, agree on the goal, business rules, acceptance criteria and what is out of scope.
2. **`implements-code`**: prepare the branch, plan, and implement the validated scope with framework-agnostic business rules and no comments.
3. **`implements-tests`**: add tests where they bring value, business rules first, and run the suite.

If the user stops or redirects at any step, follow them: they can resume later with the relevant skill on its own.

## Wrap up

- Summarize what was done, what was verified, and what was not.
- Commit, push, open a PR and comment on the issue **only when the user asks**. When opening a PR, reference the issue (`Closes #<id>`) and use the `pr-description` skill.
