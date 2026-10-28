---
name: implements-tests
description: Add tests where they bring value to a change: business rules in the domain first, then adapters that carry real risk. Follows the project's test conventions and runs the suite. Use as the third step of /implements, or when asked to add or complete tests for a change.
---

# Implements: tests

Cover the change with the tests that matter, not with tests for the sake of coverage.

Input: the validated scope (business rules, acceptance criteria) and the diff (`git diff <base>...HEAD` plus uncommitted changes). If there is no scope in the conversation, infer the rules from the diff and confirm them with the user before writing tests.

## 1. Learn the project's testing setup

Find the test framework, folder layout, naming and fixture conventions, and how tests are run (Makefile, package scripts, CI config). Follow them. If the project has no tests at all, propose a minimal setup to the user before adding one.

## 2. Decide what to test

Propose a short list to the user before writing, by priority:

1. **Business rules in the domain**: every rule from the scope gets unit tests, including its edge cases and the cases where it must refuse. They run without the framework, the database or the network: dependencies are the domain's interfaces, replaced by in-memory fakes or simple stubs.
2. **Acceptance criteria**: each testable criterion maps to at least one test, at the lowest level that proves it.
3. **Adapters with real risk**: queries, mappings, serialization, contracts with external APIs. Use integration tests only where a unit test can't catch the failure.

Don't test framework behaviour, trivial getters, or code with no logic. Say what you chose not to test and why.

## 3. Write the tests

- One behaviour per test, named after it in domain words (`it_refuses_to_cancel_a_shipped_order`), following the project's naming style.
- Arrange / act / assert made obvious by the structure and naming, not by comments: no comments in tests either.
- Test behaviour through the public API, not implementation details, so refactors don't break them.
- Check each new test can fail: it must break if the rule it covers is broken.

## 4. Run

Run the new tests, then the full suite, and report the real outcome, including failures. If a test reveals a bug in the implementation, say so and fix it with the user rather than adjusting the test to pass.
