---
name: grill-me
description: Grill the user relentlessly about a feature until it is ready to hand to GitHub Spec Kit, asking each round through AskUserQuestion and then invoking /speckit-specify directly. Use when the user wants to stress-test their thinking, prepare a spec, or uses any 'grill' trigger phrase.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

The deliverable is **a `speckit-specify` invocation**, nothing else. Do not write code, do not write `spec.md`, do not plan the implementation. Spec Kit owns all of that; you own the quality of what goes into it.

Every question goes through the `AskUserQuestion` tool. Never ask a grilling question in prose.

## Why this matters

`/speckit-specify` fills the mandatory `spec.md` sections from whatever description it is handed, and it is allowed **at most 3 `[NEEDS CLARIFICATION]` markers**. Everything else it cannot answer it fills with an "informed guess" from industry defaults, silently, into requirements the user will later be held to. Every decision you fail to grill out becomes a default someone else chose.

So the goal of the session is a description that leaves Spec Kit nothing to guess.

## Before round 1

These are facts, so they are your job:

- Read `.specify/memory/constitution.md` if it exists. Its principles are already settled; never grill a decision the constitution has made.
- List `specs/` and skim any related existing spec. Reuse its vocabulary and do not re-litigate its decisions.
- Read enough of the codebase to know what already exists. A question the code answers is not a question.

## The design tree

Seed the tree's top-level branches from the sections `/speckit-specify` must fill. These are the branches that must not be left silently assumed:

| Branch | What you are grilling for |
| --- | --- |
| Problem and why now | The user-facing problem, who has it, what it costs today |
| User journeys | Prioritised P1/P2/P3, each one independently shippable |
| Independence of P1 | Whether P1 alone is genuinely a viable MVP, or a torso with no legs |
| Requirements | Observable behaviours, each one testable |
| Scope boundary | What is explicitly *not* in this feature |
| Edge cases | Boundaries and error paths the user actually cares about |
| Domain entities | The nouns, in the business's own vocabulary |
| Success criteria | Numbers the user commits to, with no technology in them |
| Assumptions | Defaults the user has explicitly accepted |

Branch outward from these as the answers demand. A branch is done when Spec Kit could write that section without guessing.

## Rounds and the frontier

The **frontier** is every decision whose prerequisites are already settled: the questions you can ask *now* without guessing at answers you have not heard yet. A **round** is one `AskUserQuestion` call carrying the frontier.

`AskUserQuestion` takes at most 4 questions per call. If the frontier is wider than 4, ask the 4 that unblock the most of the tree first, then call again with what is left before recomputing. A question whose answer depends on another question still open in this round belongs to a *later* round, not this one.

Each round's answers reshape the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. Between rounds, write at most one line naming what got settled and what it opened up. The tool already shows the user their own answers, so do not restate them.

## Shaping each question

- `header`: the decision's name, 12 characters or fewer. `P1 slice`, `Scope`, `Retention`, `SC target`.
- `question`: the full question, ending in a question mark. Put the stakes in it: why this decision matters, what it blocks downstream, and where Spec Kit would guess if the user does not answer. Several sentences is fine.
- `options`: 2 to 4 answers you actually believe someone could pick. `label` is 1 to 5 words; `description` says what picking it commits them to, including the trade-off you would flag if they did.
- The recommended answer is the **first** option, with `(Recommended)` appended to its label. Every question gets one. If you cannot recommend an answer, you have not thought about the question hard enough to ask it yet.
- `multiSelect: true` when the answers are not mutually exclusive, which is the normal case for scope and edge-case questions.

Never author an "Other" option. The tool always adds one, and that escape hatch is what lets you ask a genuinely open question having enumerated only your best two or three guesses. Do not pad to 4 with options you do not believe in: two sharp options beat four limp ones.

## Spec Kit specific rules

**WHAT and WHY only. Park every HOW.** Frameworks, schemas, APIs, libraries, hosting, migration mechanics: none of it belongs in a `/speckit-specify` prompt, and Spec Kit's own checklist fails a spec that contains it. When a technical decision surfaces mid-grilling, do not chase it and do not discard it: add it to a parked list for `/speckit-plan`, which is the phase that asks "I am building with...".

**Success criteria need real numbers from the user.** "Fast" and "reliable" are not criteria. Grill for the actual figure, and check it is technology-agnostic: `95% of searches return in under 1 second` is a criterion, `Redis hit rate above 80%` is a leaked implementation detail. If the user has no number, offer 2 to 3 concrete candidates as options rather than accepting a vague answer.

**Every story must survive alone.** For each journey, ask what shipping only that one gets the user. If P1 is not demonstrable on its own, the priorities are wrong and the split needs regrilling.

**Requirements must be falsifiable.** For each one, ask yourself what a tester would do to prove it wrong. If you cannot answer, it is not settled.

## Facts are your job

Finding *facts* is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, git history, an existing spec, how a dependency actually behaves), dispatch a background sub-agent with the `Agent` tool to find it.

Do not block on it. A running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now, in this round. Never hand the user a research task dressed up as a question. The *decisions* are the user's: put each one to them and wait.

## Free-text and annotated answers

An "Other" answer often reframes the question instead of answering it, and can invalidate branches you had already planned. Re-read the tree against it and prune what it kills before computing the next frontier. Notes the user attaches to a selection are part of the answer; treat them with the same weight as the selection itself.

## Done

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed.

Put one final `AskUserQuestion` offering `Aligned` and `Reopen a decision` and `Grill deeper`. `Aligned` is the only confirmation gate, because the handoff creates a branch and files.

## Handoff

On `Aligned`, hand off immediately: call the `Skill` tool with `skill: "speckit-specify"`, passing the composed feature description as `args`. Do not print the description for the user to copy, and do not ask a second time whether to run it. The user already approved every decision in it, round by round.

Compose `args` from the settled tree, in this shape:

```
## What and why
<the user-facing problem, who has it, what it costs today, why now>

## User journeys, in priority order
1. **<title>** (P1) - <the journey in plain language>. Shippable alone because <what a user can do with only this>. Done when: Given <state>, When <action>, Then <outcome>.
2. **<title>** (P2) - ...

## Must do
- <observable behaviour, phrased so a tester could disprove it>

## Out of scope
- <exclusion the user confirmed>

## Edge cases
- <boundary or error path> -> <expected behaviour>

## Domain vocabulary
- **<Entity>**: <what it represents to the business, key attributes, relationships>

## Success criteria
- <metric with the number the user committed to, no technology in it>

## Confirmed assumptions
- <default the user explicitly accepted>

Every open question above was settled directly with the user. Do not add [NEEDS CLARIFICATION] markers and do not substitute industry defaults: if you find a genuine gap, ask.
```

Drop any heading the feature genuinely has nothing under, rather than writing "N/A". Do not number the bullets as `FR-001` or `SC-001`; Spec Kit assigns those itself and will re-derive them from the prose.

If `speckit-specify` is not available in the session, say so and stop rather than improvising a spec by hand: Spec Kit is not installed in this project.

Once it returns, report where the spec landed and print the parked list, which is the one thing Spec Kit was not given:

```
Parked for /speckit-plan:
- <technical decision, plus the constraint from grilling that bears on it>
```

## Anti-patterns

- Asking one question at a time while the frontier holds four.
- Falling back to prose because a question felt too open-ended to enumerate options for.
- Bundling a dependent question into the current round and guessing at its prerequisite.
- Asking the user something a `grep`, the constitution, or an existing spec would have answered.
- Options with no recommendation, or a recommendation you do not hold.
- Letting tech-stack choices into the `speckit-specify` args instead of parking them for `/speckit-plan`.
- Accepting "fast", "secure", or "scalable" as a success criterion.
- Invoking `speckit-specify`, or writing `spec.md` yourself, before the user confirms alignment.
- Printing the composed description for the user to paste, or asking permission twice, instead of invoking `speckit-specify` on `Aligned`.
