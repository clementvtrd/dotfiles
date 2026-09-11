---
name: internal-audit
description: Run the KnpLabs-style internal project audit against the current repository - open a GitHub issue with the audit checklist, then verify every item hands-on (actually installing, testing, linting, running the tools) rather than just eyeballing config files. Use when the user asks to audit the project, run an internal/quality/health audit, or check the repo against the standard KnpLabs checklist.
---

Audit the git repository in the current working directory against the standard checklist below. The point of this skill is **verification, not inspection**: for anything that happens on this machine, actually run it and see what happens instead of inferring from file presence. The only items you may answer from documentation alone are ones about environments other than the local machine (e.g. deploying to prod/preprod/staging).

## Prerequisites

- The current directory must be inside the project's git repository (not this dotfiles repo). If it isn't, ask the user which project directory to audit.
- `gh` must be authenticated and the repo must have a GitHub remote (`gh repo view`). If `gh` isn't available or isn't authenticated, skip straight to printing the checklist markdown (see step 1b) and continue the hands-on audit anyway - the issue can be created manually later.

## Step 1 - Create the audit issue

1. Fill in the template in the **Checklist template** section below verbatim - do not pre-check anything yet, this is the blank issue body.
2. Ask the user for confirmation before creating anything, using `AskUserQuestion`: "Create a GitHub issue titled 'Internal audit' with the checklist below?" Options: create it now / don't create it, just show me the markdown.
   - **If confirmed**: run `gh issue create --title "Internal audit" --body-file <tmp-file>` in the target repo. Keep the issue number - you'll edit it in step 3.
   - **If refused**: print the full checklist markdown in your response, in a fenced code block, so the user can paste it into an issue themselves. Do not create anything. Skip step 3 (there's no issue to update) but still perform steps 2 and 4.

## Step 2 - Investigate every item hands-on

Work through each checklist section. For every item, prefer *doing* over *reading*. Only fall back to documentation-review when the action would touch something other than this local machine (remote deploys, staging/prod infra, third-party services you can't safely reach).

### README.md

- **Project management board link** - grep the README for a link to Jira/Linear/Trello/GitHub Projects/Notion etc.
- **Short description of goal/context** - check the README has a real introductory paragraph, not just badges/title.
- **Install docs present** - look for an install/setup/getting-started section in the README (or linked docs).
- **Installed without help** - actually run the documented install command(s), verbatim, in this repo. Pass only if it completes using nothing but what's written down (no undocumented extra steps, missing env vars, tribal knowledge). Note what you ran and the outcome.
- **Test docs present** - look for a "running tests" section.
- **Ran tests without help** - actually run the documented test command(s) and confirm they execute using only the README's instructions (the tests don't need to be green, they need to *run* without extra undocumented steps).
- **Deploy docs present (any environment)** - this is the exception: deploying touches a non-local environment, so just verify the documentation exists and looks complete. Do not attempt an actual deploy.
- **Runs with Docker** - if a Dockerfile/compose file exists and local-dev docs point to it, actually bring it up locally (`docker compose config` to validate, then `up -d`, check it's healthy, then tear it down with `down`). Time-box this and clean up afterwards; if Docker isn't available or the build is prohibitively slow, say so explicitly instead of guessing.

### PHP (skip this whole section if there's no `composer.json`)

- **PHPStan** - check `composer.json` / `phpstan.neon` for it, then actually run it (`vendor/bin/phpstan analyse` or the documented composer script) and note the configured level (flag if below `max`).
- **Linter (PHP-CS-Fixer or similar)** - check config, then run it in dry-run mode.
- **Unit testing (phpspec/PHPUnit)** - check `composer.json`, then run the unit suite.
- **E2E testing (Behat/Pest)** - check `composer.json`, then run it if it's feasible locally.
- **Integration testing (Kahlan)** - check `composer.json`, then run it if feasible.

### Javascript (skip this whole section if there's no `package.json`)

- **Test policy documented** - look for a doc describing what's tested at which layer (CONTRIBUTING.md, docs/testing.md, README section).
- **Unit testing (Jest)** - check `package.json`, then actually run it.
- **Linter (ESLint)** - check config, then actually run it.
- **E2E testing (Playwright/Cypress)** - check config, then run it if fast and non-destructive; otherwise note why you didn't (e.g. needs a live environment).

### Docker

- **Hadolint on CI** - grep `.github/workflows/*.yml` (and any other CI config) for hadolint usage.

### Github

- **Branch protection configured** - `gh api repos/{owner}/{repo}/branches/{default_branch}/protection`. If this 403s (needs admin), say you couldn't verify it rather than guessing.
- **CI configured** - check for `.github/workflows/*.yml`, `.circleci/config.yml`, or `.travis.yml` with a workflow that actually triggers on push/PR.
- **Dependabot configured** - check for `.github/dependabot.yml`.
- **Dependabot PR limit set per ecosystem** - parse `dependabot.yml`: every `updates` entry must explicitly set `open-pull-requests-limit` (a missing key defaults to 5, which counts as *not* configured). Flag if any entry is missing it or sets it above a sane team limit (2 is the suggested default).

## Step 3 - Record results back into the issue

Skip this step if no issue was created in step 1.

Build the final checklist: check off (`- [x]`) every item that genuinely passed hands-on verification, and under each checked or unchecked item add a short italic note with the evidence (what you ran, what you found, or why it's unchecked). Then update the issue with `gh issue edit <number> --body-file <tmp-file>`.

## Step 4 - Report to the user

Summarize pass/fail counts per section and call out the items that are unchecked or that you couldn't verify (and why). Link the issue if one was created.

## Checklist template

```md
## README.md

- [ ]  A link to the project management board to provide a global understanding of the project
- [ ]  A short description about the project goal and context
- [ ]  A documentation to install the project
- [ ]  Were you able to install the project without help ?
- [ ]  A documentation to run tests locally
- [ ]  Were you able to run tests locally without help ?
- [ ]  A documentation to deploy the project on any environment (prod/preprod/staging/etc.)
- [ ]  Is the project run with docker ?

# PHP

- [ ]  Check whether [PHPStan](https://github.com/KnpLabs/continuous-quality/tree/master/phpstan) is used (`max` level recommended)
- [ ]  Is there a linter ? (The most common used is [PHP-CS-Fixer](https://packagist.org/packages/friendsofphp/php-cs-fixer) )
- [ ]  Is there a unit testing library ? ( [phpspec](https://packagist.org/packages/phpspec/phpspec) or [PHPUnit](https://packagist.org/packages/phpunit/phpunit) )
- [ ]  Is there a end-to-end testing library ? (Basically [Behat](https://packagist.org/packages/behat/behat), Pest)
- [ ]  Is there an integration testing library ? ( Kahlan )

# Javascript

- [ ]  Is there a test policy ? (What code is tested with what testing layer)
- [ ]  Is there a unit testing library ? ([Jest](https://jestjs.io/fr/))
- [ ]  Is there a linter ? (The most common used is [ESLint](https://www.npmjs.com/package/eslint))
- [ ]  Is there a end-to-end testing library ? (Playwright, Cypress)

# Docker

- [ ]  Check if [Hadolint](https://hub.docker.com/r/hadolint/hadolint) is configured and used on the CI

# Github

- [ ]  Are these branches protection configure ?

    ![](https://user-images.githubusercontent.com/1766827/90017700-35018880-dcac-11ea-8aef-d22c8854485d.png)

- [ ]  Is there a CI configured ([CircleCI](https://circleci.com/), [TravisCI](https://travis-ci.org/) or [Github Actions](https://github.com/features/actions)) ?
- [ ]  Is [dependabot](https://docs.github.com/en/github/visualizing-repository-data-with-graphs/exploring-the-dependencies-of-a-repository) configured ?
- [ ]  Does every configuration of dependabot has a limit of open PRs at the same time? Max has to be defined by the team. 2 would be a good choice.
```
