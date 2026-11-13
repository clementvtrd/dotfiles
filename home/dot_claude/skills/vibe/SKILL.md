---
name: vibe
description: Take an idea, an issue, a PR or a scratch file from need to finished change by chaining the grill-me, implement and test skills in order, asking the user for every required input through AskUserQuestion, and finishing with a docs-drift check. Use when the user runs /vibe [idea | issue URL | PR URL | file path] or wants the whole flow driven end to end.
argument-hint: '[idea | issue URL | PR URL | file path]'
---

# Vibe

Drive the whole flow, from need to checked documentation, in a fixed order:

1. **`grill-me`**: settle the business need (optional, see below).
2. **`implement`**: plan, validate, then make the minimal change.
3. **`test`**: write the unit, integration and end-to-end tests.
4. **`docs-drift`** (agent): check no documentation was left wrong by the change.

You coordinate; each stage does its own job. You support the user, you don't decide for them: nothing leaves the machine (commit, push, PR, comments) unless they ask.

## Asking the user

Every question to the user goes through the `AskUserQuestion` tool, never free text: required inputs, plan validations, choices between approaches, and decisions after a failure. Put your recommended answer first, suffixed with `(Recommended)`, with a one-line reason in its description. Ask only what you can't find out yourself: look up facts (the issue behind the current branch, recent scratch files, the project's commands) instead of asking for them.

When a stage's skill says to "wait for the user" or "ask", do it with `AskUserQuestion` too: for a plan, the options are to approve it, to change something, or to stop. A choice such as "Other" carries the free-text answer.

## 0. Required inputs

Before starting, make sure the skills and the agent below exist (`grill-me`, `implement`, `test`, `docs-drift`). If one is missing, say which and stop.

Ask for what is missing, one `AskUserQuestion` call for all of it:

- **Source** (only if no argument was given): an idea, a GitHub issue URL, a GitHub PR URL, or a path to a scratch file. Offer the candidates you found (the issue number in the current branch name, recent scratch files) as options, and let "Other" carry a URL, a path or the idea itself. If the argument is plain text that is neither a URL nor an existing file, it is an idea.
- **Grill first?** Whether to run `grill-me` before implementing. Recommend yes when the source is an idea or reads as vague, no when it is a clear issue, PR or file. Skip this question and don't grill when the user already said so.

Don't ask for anything a later stage already asks for on its own.

## 1. Grill (optional)

Run the `grill-me` skill on the source. It stays on the business need and uses `AskUserQuestion` itself.

When it ends and the user confirms the shared understanding, write its summary to a scratch file **outside the repository** (the session scratchpad if there is one, else a temporary directory), and tell the user the full path. That file is the source for the next stage. If the source was already an issue, a PR or a file, keep it as the source and pass the summary along as additional context.

## 2. Implement

Run the `implement` skill with the source: the issue URL, the PR URL or the scratch file path.

Don't skip its plan validation: the code starts only after the user approves the plan through `AskUserQuestion`. Don't commit, push or open anything.

## 3. Test

Run the `test` skill on the scope `implement` just changed (the branch against its default branch, plus uncommitted changes). Its list of tests is validated with the user before they are written.

## 4. Docs drift

Dispatch the **`docs-drift`** agent on the same scope: give it the repository root, the base and head (or "working tree"), and the list of changed files from `git diff --stat`. It is read-only.

Its report is a claim: open each cited location and check the documentation really is wrong or incomplete now. Drop what doesn't hold and say how many you dropped.

Present the confirmed findings, then ask through `AskUserQuestion` which to fix (multiple choice, all recommended). Apply the agreed fixes with the smallest possible edits to the docs, and nothing else. Don't loop back to the other stages, and don't run the agent a second time.

## When a stage fails or blocks

If a stage fails, or can't finish (missing tooling, untestable code, a check that fails for good reason), say so with the real output, and ask through `AskUserQuestion` what to do: retry, continue to the next stage with the gap noted, or stop. Never hide a failure to keep the flow going.

If the user stops or redirects at any point, follow them: they can resume with the stage's skill on its own.

## End

The process ends with the docs-drift check. Finish with a short summary: for each stage, what was done, what was verified and what was not (failures, skipped levels, drift left unfixed), and the path of the scratch file if one was written. State that nothing was committed or pushed.
