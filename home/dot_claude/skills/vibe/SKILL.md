---
name: vibe
description: Orchestrate the GitHub Spec Kit workflow with a complexity-based short or full path, using grill-me for specification and a fresh subagent for every phase. Use when the user wants to run Spec Kit end to end or choose the right Spec Kit workflow for a feature.
---

Orchestrate GitHub Spec Kit from feature discovery through convergence. Keep the main context small: every workflow phase runs in a new subagent, and continuity comes from the Spec Kit artifacts written by each skill.

## Spec Kit context

GitHub Spec Kit is a specification-driven development workflow. It separates the user-facing problem and requirements from technical planning, task breakdown, implementation, and verification. The active feature is tracked by Spec Kit's feature state, not necessarily by the current Git branch.

The quickstart defines two common paths:

- **Short path**, for smaller features: `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`, `/speckit.converge`.
- **Full path**, for production features or features with meaningful risk: `/speckit.constitution`, `/speckit.specify`, `/speckit.clarify`, `/speckit.plan`, `/speckit.checklist`, `/speckit.tasks`, `/speckit.analyze`, `/speckit.implement`, `/speckit.converge`.

`/speckit.specify` captures what and why, `/speckit.plan` chooses implementation details, `/speckit.tasks` creates dependency-ordered work, `/speckit.implement` builds it, and `/speckit.converge` checks the result against the artifacts. The full path adds explicit quality gates before implementation.

## Operating rules

1. Do not run Spec Kit phases directly from this orchestrator. Launch one fresh `Agent` subagent per phase, except that the implementation phase may use up to three fresh subagents as described below.
2. Each subagent must read the relevant existing Spec Kit artifacts, run exactly its assigned phase, and rely only on those files rather than prior conversation context.
3. Do not create orchestrator-specific handoff or summary files. Spec Kit skills own the workflow artifacts and are the only persisted source of continuity.
4. Route every user-facing question, choice, confirmation, or clarification through Claude's `AskUserQuestion` tool. Never ask these questions in prose, in a subagent report, or through a different prompt mechanism.
5. If a phase reports a blocker, stop before launching the next phase and surface the blocker to the user.
6. Use the command form exposed by the configured agent. The quickstart shows `/speckit.*`; some agents expose `$speckit-*` or `/skill:speckit-*` instead.

## Workflow

### 1. Choose a path

Before launching any phase, use Claude's `AskUserQuestion` tool with one question and exactly these choices. Recommend the first choice when the feature is small, isolated, low-risk, and has straightforward requirements. Recommend the second when the feature is production-facing, cross-cutting, security-sensitive, ambiguous, or likely to benefit from explicit quality gates. Include the Spec Kit context above in the question's supporting message so the user can make an informed choice.

- **Short path (Recommended)**: specify through converge with the essential artifacts and fewer review gates.
- **Full path**: constitution, specification clarification, checklist, consistency analysis, implementation, and convergence.

The recommendation must reflect the feature's actual complexity. If the feature description is too vague to assess, recommend the full path and say that clarification is itself a risk signal. Do not ask the user to choose between implementation technologies here.

### 2. Run the specification phase through `grill-me`

Launch a fresh subagent for the specification phase. Instruct it to invoke the custom `grill-me` skill, not `/speckit.specify` directly. `grill-me` owns the user interview, AskUserQuestion rounds, alignment gate, and the eventual Spec Kit specification handoff.

If the full path was selected, run the constitution phase first in its own fresh subagent. The constitution subagent may invoke `/speckit.constitution`, but it must not interview the user about principles already present in `.specify/memory/constitution.md`.

Pass the feature request, selected path, and repository location to each subagent. The `grill-me` subagent must not write application code or a hand-written `spec.md`.

The subagent must preserve this interaction rule: if its assigned Spec Kit phase needs input from the user, it must call Claude's `AskUserQuestion` tool directly. The orchestrator must not translate questions into prose or answer on the user's behalf.

### 3. Continue one phase at a time

After each phase completes, launch a new subagent for the next phase. Give it only the phase command, feature directory, and relevant Spec Kit artifacts.

For the short path, run these fresh subagents in order:

1. `grill-me` in place of `/speckit.specify`
2. `/speckit.plan`
3. `/speckit.tasks`
4. `/speckit.implement`
5. `/speckit.converge`

For the full path, run these fresh subagents in order:

1. `/speckit.constitution`
2. `grill-me` in place of `/speckit.specify`
3. `/speckit.clarify`
4. `/speckit.plan`
5. `/speckit.checklist`
6. `/speckit.tasks`
7. `/speckit.analyze`
8. `/speckit.implement`
9. `/speckit.converge`

Each subagent must invoke only its assigned phase. For convergence, if new tasks are appended, launch another fresh `implement` subagent followed by another fresh `converge` subagent, repeating until convergence is reported or a blocker occurs.

#### Implementation exception

The `/speckit.implement` phase may be executed as a workflow of up to three fresh subagents when `tasks.md` contains independent phases, clear task groups, or enough work that one context would be strained. The orchestrator must:

1. Group the tasks into at most three dependency-ordered slices without changing their meaning or dependencies.
2. Launch one fresh implementation subagent per slice, sequentially, passing the active feature directory, the complete Spec Kit artifacts, and the slice's task scope.
3. Require each implementation subagent to inspect the current repository and task state before working, so later slices see the changes made by earlier slices.
4. Use one implementation subagent when splitting would create dependencies across slices, duplicate work, or leave a slice without a coherent deliverable.
5. Treat the complete implementation workflow as one `/speckit.implement` phase for path ordering; run `/speckit.converge` only after all selected implementation slices finish.

Never launch more than three implementation subagents for one implementation phase. If the work needs more subdivision, group it into three broader sequential slices.

#### Implementation subagent contract

Every implementation subagent is authorized to use the Claude workflows, skills, and tools available in its session to complete its assigned task slice. In particular, it must:

- Invoke the Claude Spec Kit workflow `/speckit.implement` for the active feature instead of only explaining the implementation.
- Use repository inspection, file editing, shell commands, tests, and other available skills when required by the generated tasks and existing project conventions.
- Read the active Spec Kit artifacts and inspect the current repository state before making changes. Later implementation subagents must build on changes made by earlier ones.
- Route every user-facing question, approval request, or clarification through Claude's `AskUserQuestion` tool.
- Respect the session's permission settings. A permission prompt or denied operation is a real blocker; do not bypass it or substitute an unapproved command.
- Report the task slice completed, files changed, checks run, and any blocker after the workflow finishes.

The implementation subagent may invoke supporting Claude skills when needed for its assigned implementation work, but it must not start another Spec Kit phase or launch additional implementation subagents. The orchestrator owns phase ordering and the maximum of three implementation subagents.

### 4. Finish

When convergence succeeds, report the selected path, the active feature directory, and the key Spec Kit artifacts. Include any unresolved issues reported by the final subagent. Do not paste the full artifacts into the response.

## Subagent prompt contract

Every phase subagent prompt must include:

```text
You are the fresh [PHASE] subagent in a GitHub Spec Kit workflow.
Run only [PHASE COMMAND] for the active feature in [FEATURE DIRECTORY].
Read these existing Spec Kit artifacts: [PATHS].
Do not rely on prior conversation context and do not redo completed phases.
When the phase finishes, return a brief report with the outcome, files changed, unresolved issues or blockers, and recommended next action. Do not create an extra summary or handoff file.
```

For the specification subagent, replace `[PHASE COMMAND]` with: `invoke the custom grill-me skill; grill-me handles the Spec Kit specification handoff`. For all other phases, use the corresponding Spec Kit command.

## Failure handling

- If `grill-me` cannot complete its alignment gate, stop and let the user continue that interview; do not invoke `/speckit.specify` as a fallback.
- If a required Spec Kit command is unavailable, stop and report the missing command and the last completed Spec Kit artifact.
- If a quality gate finds issues, the next subagent must repair the source artifact named by the gate before implementation continues.
- If implementation or convergence discovers missing work, preserve the generated task changes and repeat only the required fresh subagent phases.

## Source

Workflow guidance summarized from the GitHub Spec Kit quickstart:
https://github.github.com/spec-kit/quickstart.html