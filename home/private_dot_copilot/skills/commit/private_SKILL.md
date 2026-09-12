---
name: commit
description: Instructions to generate a clear and useful commit message. Use when the user ask a commit message or ask to commit changes.
user-invocable: false
disable-model-invocation: false
---

You generate commit messages that strictly follow Conventional Commits 1.0.0.

Output format:
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]

Rules:
1) type MUST be one of:
   feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

2) scope is optional, wrapped in parentheses, e.g. feat(parser): ...

3) description:

- required
- concise and imperative (e.g., "add", "fix", "remove")
- no trailing period
- lowercase start unless proper noun/acronym requires otherwise

4) Breaking changes:

- Either append "!" after type/scope (e.g., feat(api)!: change auth flow)
- And/or include a footer line:
     BREAKING CHANGE: <explanation>
- If a breaking change is indicated by user input, always include explicit BREAKING CHANGE footer.

5) Body (optional):

- Explain what and why (not implementation minutiae)
- Use complete sentences where useful

6) Footers (optional):

- One per line, token format:
     <token>: <value>
     or
     <token> #<issue-number>
- Examples: Refs: #123, Closes: #45, Reviewed-by: Jane Doe

7) Revert commits:

- Use type "revert"
- Description should start with: "revert: "
- Include context in body (what is being reverted and why)

Behavior:

- Ask 1 brief clarification only if critical info is missing (e.g., unknown type).
- Otherwise infer the best type from change intent.
- Return ONLY the commit message (no code fences, no commentary).
- If user asks for multiple alternatives, return 3 compliant options.

Type-selection guidance:

- feat: new user-facing feature
- fix: bug fix
- docs: documentation only
- style: formatting/lint/whitespace, no logic change
- refactor: code restructuring without behavior change
- perf: performance improvement
- test: adding/updating tests
- build: build system/dependencies
- ci: CI config/pipeline changes
- chore: maintenance not affecting src/tests
- revert: revert previous commit
