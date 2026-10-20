---
name: stacked-prs
description: Cut a large local diff into a stack of small, independently valid GitHub pull requests, ordered so reviewers follow the story, or continue an existing stack. Branches are always created with the gh stack CLI. Use when the user has a huge diff (or branch) to split, asks for stacked / chained / split PRs, wants to continue a stack, or says a change is too big to review.
---

# Stacked pull requests

Turn one huge local diff into a stack of small PRs. Each PR is reviewable on its own, **passes CI on its own**, and the order tells reviewers what was done so far and why.

You support the user, you don't decide for them: the goal, the split and anything that leaves the machine (push, PR creation) are confirmed with them first.

## Running `gh stack` from here

Most `gh stack` commands open an interactive UI (editor, picker, prompt) when an argument is missing. The Bash tool can't answer it, so the command hangs until it times out. Follow these rules for **every** call:

- Always pass every argument explicitly, and use the non-interactive form:

  | Command | Use | Never |
  |---|---|---|
  | `init` | `gh stack init <branch> [--base <base>]` | `gh stack init` without a branch |
  | `add` | `gh stack add -m "<message>" <branch>` | `add` with `-A` / `-u` and no `-m` (opens the editor), or without a branch (auto-named) |
  | `view` | `gh stack view --short` (or `--json`) | `gh stack view` (interactive view) |
  | `checkout` | `gh stack checkout <pr-number \| pr-url \| branch>` | `gh stack checkout` alone (picker); a bare number is read as a *stack* number first, so prefer a PR URL or branch name |
  | `submit` | `gh stack submit --auto` | `gh stack submit` (single-screen editor) |
  | `rebase` | `gh stack rebase`, then `--continue` / `--abort` | |
  | `sync` | `gh stack sync` | |
  | `push` | `gh stack push` | |

- Set a timeout on the Bash call (60 s is plenty; `submit` and `sync` can take longer, use 180 s) and redirect stdin so a prompt can't wait for input: `GIT_EDITOR=true gh stack <cmd> </dev/null`.
- If a command times out or prints a prompt, **don't wait or retry the same call**. Stop, tell the user what it was asking, and either find the non-interactive flag in `gh stack <cmd> --help` or ask the user to run it themselves in their terminal.
- `gh stack sync` aborts when the local and remote stacks have diverged and there is no TTY. Report it to the user instead of forcing anything.
- A conflict in `gh stack rebase` leaves a rebase in progress: resolve the files, `git add` them, then `GIT_EDITOR=true gh stack rebase --continue </dev/null`. If it can't be resolved cleanly, `gh stack rebase --abort` and ask the user.

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
   - **Branches are created with the `gh stack` CLI, never with `git switch -c` / `git branch` / `git checkout -b`**, so the stack is tracked from the start.
   - Bring in its content from the target, **staged**:
     - whole files: `git restore --source=<stash-sha> --worktree --staged -- <paths>` (works for files deleted in the target too, with `git rm`),
     - partial files: write the wanted hunks to a patch file in the scratchpad and `git apply --index` it. Interactive tools (`git add -p`, `git checkout -p`) are not usable from here.
   - **Run the CI checks discovered in step 3.** Fix what fails in this PR, not in a later one (and `git add` the fixes). If a PR can't be made valid, go back to the user with a proposal (merge with a neighbor, reorder).
   - Create the branch and commit, always with `-m` (never open an editor), following the repository's commit conventions:
     - first PR: `gh stack init <prefix>/<n>-<slug>` (add `--base <base>` if the base isn't the default branch) *before* bringing the content in, then `git commit -m "<message>"`,
     - next PRs: `gh stack add -m "<message>" <prefix>/<n>-<slug>`. It creates the branch on top of the current one and commits what is staged, so the content must be staged first.
3. If a later step reveals something that belongs in an earlier PR, fix it there and carry it up the stack with `gh stack rebase`, then re-run the checks of every PR above it.

### Continuing an existing stack

If the current branch already belongs to a stack (`gh stack view --short`), or the user wants to extend one (`gh stack checkout <pr-url-or-branch>`), don't start over: skip the stash target logic of step 1 unless a large diff is being split, make sure you are on the top of the stack, and add each new PR with `gh stack add <branch>`. Steps 3 to 7 apply as is.

## 6. Verify the stack

Before anything leaves the machine:

```sh
git diff <top-branch> <stash-sha>   # must be empty
```

An empty diff proves nothing was lost or added by the split. If it isn't empty, find out why and fix it. Also show the user the final summary: each branch, its size (`git diff --stat`) and the checks that passed.

## 7. Push and open the PRs

Pushing and opening PRs is visible to others: **ask the user before doing it**, and ask whether they want drafts.

- The branches are tracked by `gh stack`, so use it to push and open the PRs: each PR is based on the previous branch (the first one on the base branch) and the stack is linked on GitHub.

  ```sh
  gh stack submit --auto   # new PRs are drafts by default; add --open for ready-for-review
  ```

  Never run `gh stack submit` without `--auto`: it opens an editor that would hang. `--auto` skips it, and generates placeholder titles and descriptions, so replace them right after with `gh pr edit <branch> --title "<title>" --body-file <file>`.
- Write each description with the **`pr-description`** skill, one per PR. Keep its structure as is. Let the *Why?* say what the previous PRs of the stack brought and what this one adds, so a reviewer landing on it understands where they are in the story.
- Add the final stack order (titles and links) in your reply to the user, so they can review top to bottom.

Remind the user, once, how merging works: merge from the bottom of the stack up, and the next PR must be retargeted to the base branch if GitHub doesn't do it automatically (`gh pr edit <n> --base <base>`).

## 8. Wrap up

- Tell the user the backup stash still exists and give its message and SHA. Don't drop it yourself: let them do it once the stack is merged.
- Mention anything left out or compromised (a shim, a PR bigger than ideal, a check that couldn't run locally).
