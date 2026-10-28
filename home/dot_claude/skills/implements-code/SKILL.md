---
name: implements-code
description: Drive the technical implementation of a validated scope. Prepares the branch, plans, then writes code with business rules kept framework-agnostic in the domain and no comments. Use as the second step of /implements, or when asked to implement a scope or feature that is already agreed on.
---

# Implements: code

Implement the scope validated with the user.

Input: the scope agreed in the conversation (usually from `implements-scope`). If there is none, or it lacks the business rules and acceptance criteria, run `implements-scope` first.

You support the user, you don't decide for them: the plan and anything that leaves the machine (push, PR creation, comments) are confirmed with them first.

## 1. Prepare the workspace

If the work should land as a stacked PR (the scope is big enough to split, the user asks for it, or the current branch already belongs to a stack: check with `gh stack view --short`, never the bare `gh stack view` which is interactive), use the **`stacked-prs`** skill to create or continue the stack, and let it create the branches (via `gh stack`). Ask the user when it's unclear.

Otherwise, unless already on a fitting branch, create one from the up-to-date default branch, named after the repo's convention (look at `git branch -a` / recent history), defaulting to `<id>-short-slug`. Don't carry unrelated uncommitted changes onto it: if the tree is dirty, ask first.

## 2. Plan

1. Explore the code the change touches and follow the project's conventions (read its CLAUDE.md / README / contributing docs).
2. Propose a short plan: where each business rule lives, which ports (interfaces) and adapters are involved, the files touched, the order of steps. For a bug, start from the root cause and the fix the `debugger` proposed. For anything non-trivial, or if there are several valid approaches, give the trade-offs and let the user pick.

## 3. Implement

Work in small steps, keeping the diff focused on the scope. No unrelated refactors; mention them at the end instead.

### Business rules are framework-agnostic

- Business rules live in the domain: plain code with no dependency on the framework, the ORM, HTTP, the filesystem or any vendor SDK.
- What the domain needs from the outside world (persistence, clock, messaging, third-party APIs…) is expressed as an interface owned by the domain, named after the need (`OrderRepository`, `PaymentGateway`), not after the technology. Adapters in the infrastructure layer implement it.
- If the project already follows a hexagonal (or clean / layered) architecture, place the code in its existing layers. If it doesn't, don't restructure it: the minimum is a framework-free class or function holding the rule, with its dependencies behind an interface that clearly states the needs. Flag a larger restructuring as a follow-up rather than doing it.
- Controllers, commands, listeners and other framework entry points stay thin: they translate input, call the domain, translate output.

### No comments

The code must explain itself. Don't add comments, docblocks restating signatures, or commented-out code.

- Carry the intent in names: classes, methods, variables, constants and test names say what they do and why it matters in domain words.
- When something feels like it needs a comment, change the code instead: extract a well-named method or constant, introduce a value object, rename.
- The only exceptions are annotations a tool needs to work (static-analysis types the language can't express, lint suppressions, license headers the project requires). If a "why" truly can't be expressed in code, ask the user before adding a comment.

### Schema changes

When the scope flags a schema concern, run the **`migration-reviewer`** agent on the migration as soon as it is written, before building on it: a lock or an irreversible change is cheaper to fix now than after the code depends on it.

## 4. Verify

Run the project's linters, static analysis and type checks, plus the existing tests, and report the real outcome, including failures. If a failure's cause isn't obvious, dispatch the **`debugger`** agent rather than guessing. New tests are the job of `implements-tests`.
