---
name: test
description: Write tests for a change or a part of the project, at three levels using the project's existing tools - unit tests on the domain classes and functions, one integration test per external service to catch breaking upgrades, and end-to-end tests of the nominal cases through a real HTTP client against a started stack. Use when asked to write, add or complete tests, or via /test [paths | PR | branch].
argument-hint: '[paths | PR | branch]'
---

# Test

Write the tests that protect the behaviour, at three levels, with the tools the project already has.

Argument (optional): files or directories, a PR, or a branch to cover. Without one, the scope is the current branch against its default branch, plus uncommitted changes (`git merge-base HEAD origin/main`, falling back to `main`, then `master`). If there is no diff and no argument, ask what to cover and stop.

You write tests, you don't change the code under test. If it can't be tested as it is (hidden dependency, no seam), say what blocks it and let the user decide.

## 1. Learn the existing tools

Find and follow what is already there: the test frameworks, runners and config, folder layout, naming, fixtures, factories and helpers, and how each level is run (Makefile, package scripts, CI config, docker compose files). Also read the project's guidelines (`CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING`, `docs/`).

- Never add a framework, runner or library. Reuse the HTTP client, the container setup and the fixtures the project has.
- If a level has no tooling at all (no integration setup, no way to start the stack), don't invent one: say so, skip that level, and let the user decide whether to set it up.
- If the project has no tests at all, propose a minimal setup using the language's standard tool and stop for the user's answer.

## 2. Decide what to test

Read the scope, then list per level what you will cover. Dispatch the `test-gap-reviewer` agent on the same scope to find the branches, edge cases and checks that nothing exercises. It only proposes, and its report is a claim: check its gaps against the code before adopting them.

### Unit: the domain, widely

Cover **most of the domain's classes and functions**: entities, value objects, domain services, policies, calculations, state transitions, validations.

- Every business rule, its boundaries, and the cases where it must refuse.
- Run with no framework, database, network, clock or filesystem: dependencies are the domain's own interfaces, replaced by in-memory fakes or simple stubs.
- Skip what holds no logic: trivial getters, plain data holders, framework glue.

### Integration: once per service

One integration test **per external service the code uses** (database, cache, queue, search, object storage, mailer, third-party API, and so on). Its job is to fail when an upgrade of that service, its driver or its client breaks what the project depends on.

- Exercise the adapter against the real service (a container or the project's test instance), not a mock.
- Pin the behaviours the project actually relies on: the queries and operations it runs, serialization round-trips, ordering, error codes it handles, features of the version it needs. Not the service's whole API.
- One focused test (or a small set when the service is used in clearly different ways) per service, not one per method. List the services you found and the behaviour each test pins.

### End-to-end: nominal cases only

Cover the **nominal path of each main feature** through a **real HTTP client** against the **stack started the way the project starts it** (docker compose, Makefile target, dev server).

- Use the HTTP client the project already uses in tests, or the language's standard one. No in-process shortcut, no mocked transport.
- Happy paths only: refusals, validation errors and edge cases belong to the unit level.
- Each test sets up its own data and doesn't depend on another test's. Use test configuration and test credentials only, never real secrets, and only a local or dedicated test stack: never a shared, staging or production URL.
- Wait for readiness by polling a health route or the equivalent, never with fixed sleeps.

Propose the list to the user, by level, with what you chose not to test and why, and **wait for their go** before writing.

## 3. Write

- One behaviour per test, named after it in the project's naming style and in domain words.
- Arrange, act and assert made obvious by structure and naming. Keep the comment density of the surrounding tests.
- Test through the public API, not implementation details, so refactors don't break them.
- Reuse the project's fixtures, factories and helpers before writing new ones.
- Put each test where the project puts that kind of test, and keep the levels separate so each one can run on its own.

## 4. Check and run

1. **Each new test can fail**: break the rule it covers (temporarily, then restore it) or check the assertion would not pass on wrong behaviour. A test that can't fail is removed.
2. **Run** the new tests level by level with the project's commands, then the full suite. For the end-to-end level, start the stack with the project's own command, run, then stop it.
3. **Report the real outcome**, including failures, flaky runs and levels skipped. If a test reveals a bug in the code, say so and fix it with the user rather than bending the test to pass. If a failure's cause isn't obvious, dispatch the `debugger` agent rather than guessing.

## 5. Wrap up

- Summarize per level: what is covered, what is not, and why.
- Name what blocked a level (missing tooling, untestable code) and what it would take.
- Commit and push **only when the user asks**.
