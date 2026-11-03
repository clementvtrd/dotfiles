---
name: grill-me
description: Grill the user relentlessly on the business side of a plan, decision or idea (goal, users, rules, edge cases, priorities, scope, success criteria) until nothing is left assumed, using the AskUserQuestion tool. Never settles technical choices. Use when the user wants to stress-test their thinking, or says "grill me" or similar.
argument-hint: <plan | idea | decision>
---

# Grill me

Interview the user relentlessly until you reach a shared understanding of the **business need**. Map it as a **decision tree**: every decision branches into the decisions that hang off it.

Argument: the plan, idea or decision to stress-test. If none is given, ask for it with a plain question and stop.

You challenge the user's thinking, you don't decide for them.

## Business only

Stay on the *what* and the *why*, never the *how*:

- **In**: the problem and who has it, users and roles, goals and success measures, business rules, scenarios and edge cases from the user's point of view, priorities, trade-offs between value and cost or time, constraints (legal, budget, deadline, organisation), what is out of scope, risks to the business, rollout and communication.
- **Out**: technology, architecture, libraries, data model, APIs, hosting, performance tactics, implementation order. Don't ask about them, don't propose them, don't hide them in an option.
- If an answer needs a technical choice, leave it for the implementation and say so. If the user brings one up, note it and bring them back to the need behind it ("what is this meant to achieve?").
- Words in questions and options are the user's domain words, not jargon.

## Rounds

The **frontier** is every decision whose prerequisites are already settled: the questions you can ask *now* without guessing at answers you haven't heard yet. A question whose answer depends on another question still open belongs to a *later* round.

Ask the frontier through the `AskUserQuestion` tool, then wait for the answers before computing the next frontier.

`AskUserQuestion` takes 1 to 4 questions per call. If the frontier is bigger, ask the 4 that unblock the most other questions first, and put the rest in the next call: they stay in the same round, and the tree is recomputed once the whole frontier is answered.

For each question:

- **`question`**: one decision, phrased so that "yes" accepts your recommendation, ending with a question mark. Add the context needed to answer (the why, a concrete example) in a sentence, not a paragraph.
- **`header`**: a short label (12 characters max) naming the topic.
- **`options`**: 2 to 4 distinct business answers, each with a `description` giving its consequence for users or for the business. Don't pad with filler options: "Other" is added automatically.
- **Recommendation**: put your recommended answer first, suffixed with `(Recommended)`, and say in its description why you recommend it. Always take a position.
- **`multiSelect`**: `true` only when the answers aren't mutually exclusive.

Each answer reshapes the tree: settled decisions push the frontier outward and unblock the questions that depended on them. Recompute and ask the next round.

Answers are the user's words: when one contradicts an earlier answer, or leaves a gap or a risk, say so calmly and put the question again, differently. If the user picks "Other", take their text as the answer and keep grilling on its consequences.

## Facts

Finding *facts* is your job, never the user's. When a question needs a fact from the environment (an existing issue, document, current behaviour of the product, what already exists in the code), dispatch a sub-agent to find it instead of asking. Read the code only to learn what the product does today, never to pick a solution.

Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the report. Ask the rest of the frontier now. Check what the sub-agent reports before relying on it.

The *decisions* are the user's: put each to them and wait.

## Done

The session is done when the frontier is empty: every branch visited, nothing left silently assumed. Then summarize in a few lines, as business statements: the goal, the people concerned, the rules, the scope and what is out of scope, the success criteria, the risks that remain, and the decisions deliberately left for the implementation.

Do not act on any of it until the user confirms you have reached a shared understanding.
