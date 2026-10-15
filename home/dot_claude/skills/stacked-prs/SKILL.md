---
name: stacked-prs
description: Cut a large local diff into a stack of small, independently valid GitHub pull requests, ordered so reviewers follow the story. Use when the user has a huge diff (or branch) to split, asks for stacked / chained / split PRs, or says a change is too big to review.
---

# Stacked pull requests

Turn one huge local diff into a stack of small PRs. Each PR is reviewable on its own, **passes CI on its own**, and the order tells reviewers what was done so far and why.

You support the user, you don't decide for them: the goal, the split and anything that leaves the machine (push, PR creation) are confirmed with them first.

## 1. Back up the diff

Always first, before touching anything:

```sh
git add .
git stash push -m "{{ tiny message }}"
git stash apply
```

- `git add .` makes the stash include untracked files; `stash apply` (not `pop`) keeps the stash as a safety net.
- Pick a short message that identifies the work (e.g. `stacked-prs: checkout refactor`).
- Record the stash commit SHA right away (`git rev-parse stash@{0}`) and use the SHA from now on: stash indexes shift when other stashes are created.
- The stash tree is the **target**: the final top of the stack must reproduce it exactly (see step 6).
- If the branch already has commits ahead of the base, they are part of the work too. The target is "base → stash commit", not only the uncommitted part.

## 2. Understand the goal

Gather context on your own before asking anything:

- The diff itself (`git diff --stat <base> <stash-sha>`, then the relevant parts), the branch name, the commit log.
- Any ticket or issue linked from the branch / commits, or provided by the user (use the available MCP tools to read it, e.g. Trello, Linear, Jira, GitHub).
- The conversation so far.

Then **confirm the goal with the user** in a couple of sentences. The goal may be:

- a **business need** (what users or the product gain),
- a **technical improvement** (refactor, performance, migration, debt),
- or **both**. In that case state and confirm each of them separately, because they often land in different PRs.

Don't go further until the user validates (or corrects) the goal. Use AskUserQuestion when available.

## 3. Discover what "valid" means

A PR is valid when **every check CI runs for the files it touches passes**. Find them instead of guessing:

- `.github/workflows/*`, and any other CI config at the repo root.
- `Makefile`, `package.json` scripts, `composer.json`, pre-commit config…

List the checks (lint, static analysis, type-check, unit / integration tests, build…) and how to run them locally. If a check can't run locally, say so and ask how the user wants to handle it.

Also determine the **base branch** (default branch unless told otherwise). Ask if it is ambiguous.

## 4. Propose the stack

Group the target diff into small PRs. Guidelines, not dogma:

- **Valid alone**: a PR never relies on code that only arrives in a later PR, and never leaves the build, tests or types broken.
- **One reason to review**: each PR does one thing a reviewer can hold in their head. A few hundred changed lines is a good order of magnitude; a larger PR is fine if it is a single mechanical move or rename.
- **Tests travel with the code they cover**, not in a separate PR afterwards.
- **Order tells the story**, typically:
  1. preparation with no behavior change (renames, moves, extractions, refactors, config, dependencies),
  2. new building blocks (domain / data / API),
  3. the behavior change that uses them,
  4. the visible layer (UI, docs, cleanup of now-dead code).
- A file touched by several PRs is fine: split it by hunk. If a hunk can't be separated without a temporary shim, prefer merging the two PRs over writing throwaway code. If a shim is really worth it, flag it to the user.
- Avoid PRs that only make sense together (merge them) and PRs of a few lines that carry no meaning (fold them into a neighbor).

Present the plan as an ordered list. For each PR: a short title, what it contains (files / areas), why it comes at this position, and which checks you expect to be relevant. Mention the risks you see (a hard-to-split file, a PR that stays big on purpose).

**Wait for the user's approval** and adjust until they are happy. Two to seven PRs is usual; if you end up with more, say so and check it's what they want.

## 5. Build the stack locally

Once the plan is approved:

1. Make sure the backup is intact (`git diff --stat <stash-sha>` against the working tree is empty), then tell the user you are about to reset the working tree, which is safe because of the stash, and run `git reset --hard`.
2. For each PR, in order:
   - Create the branch from the previous one (the first one from the base): `git switch -c <prefix>/<n>-<slug> <previous-branch-or-base>`.
   - Bring in its content from the target:
     - whole files: `git restore --source=<stash-sha> --worktree --staged -- <paths>` (works for files deleted in the target too, with `git rm`),
     - partial files: write the wanted hunks to a patch file in the scratchpad and `git apply --index` it. Interactive tools (`git add -p`, `git checkout -p`) are not usable from here.
   - **Run the CI checks discovered in step 3.** Fix what fails in this PR, not in a later one. If a PR can't be made valid, go back to the user with a proposal (merge with a neighbor, reorder).
   - Commit with a clear message. Follow the repository's commit conventions.
3. If a later step reveals something that belongs in an earlier PR, fix it there and carry it up the stack (`git rebase --onto` / `git rebase --update-refs`), then re-run the checks of every PR above it.

## 6. Verify the stack

Before anything leaves the machine:

```sh
git diff <top-branch> <stash-sha>   # must be empty
```

An empty diff proves nothing was lost or added by the split. If it isn't empty, find out why and fix it. Also show the user the final summary: each branch, its size (`git diff --stat`) and the checks that passed.

## 7. Push and open the PRs

Pushing and opening PRs is visible to others: **ask the user before doing it**, and ask whether they want drafts.

- If the user works with a stacking tool (Graphite `gt`, `gh stack`…), use it for the branch / PR plumbing. Otherwise plain `git` + `gh` is enough.
- Push each branch, then open the PRs in order, each one **based on the previous branch** (the first one on the base branch):

  ```sh
  git push -u origin <branch>
  gh pr create --base <previous-branch-or-base> --head <branch> --title "<title>" --body-file <file>
  ```

- Write each description with the **`pr-description`** skill, one per PR. Keep its structure as is. Let the *Why?* say what the previous PRs of the stack brought and what this one adds, so a reviewer landing on it understands where they are in the story.
- Add the final stack order (titles and links) in your reply to the user, so they can review top to bottom.

Remind the user, once, how merging works: merge from the bottom of the stack up, and the next PR must be retargeted to the base branch if GitHub doesn't do it automatically (`gh pr edit <n> --base <base>`).

## 8. Wrap up

- Tell the user the backup stash still exists and give its message and SHA. Don't drop it yourself: let them do it once the stack is merged.
- Mention anything left out or compromised (a shim, a PR bigger than ideal, a check that couldn't run locally).
