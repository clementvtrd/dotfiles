---
name: dailydev-tech-brief
description: Suggest daily.dev articles matching a project's tech stack or the user's day-to-day stack, as a one-off reading list or a weekly brief. Use for tech watch, reading suggestions, "what should I read", or setting up the weekly brief.
---

# daily.dev tech brief

Detect the technologies in play, query daily.dev, and return a short ranked reading list. Two scopes, one process:

- **Project**: stack of the current repo ("articles for this project").
- **Day to day** (default for the weekly brief): stack across the user's projects.

You support the user, you don't decide for them. Show the detected stack and planned queries in one line before fetching, and let them correct it.

## 1. Access: MCP first, REST as fallback

**Preferred: daily.dev MCP server** (`https://api.daily.dev/mcp`, sign in with daily.dev, no token to manage). If no `daily.dev` MCP tools are available, tell the user to add it, then continue with the fallback:

```sh
claude mcp add --transport http daily.dev https://api.daily.dev/mcp
```

Look at the tools the server actually exposes (feed by tag, post search, tag search, "for you" feed...) and use those; I did not verify their exact names or parameters, so never assume them.

**Fallback: public REST API** (beta, tied to a Plus plan). Needs `DAILY_DEV_TOKEN` (`dda_...`, daily.dev Settings > API). Never print, log or commit it, send it only to `api.daily.dev`. If it is unset, stop and say how to set it.

```sh
curl -sS --fail-with-body -H "Authorization: Bearer $DAILY_DEV_TOKEN" \
  "https://api.daily.dev/public/v1/feeds/tag/symfony?limit=12"
```

Endpoints: `GET /feeds/tag/{tag}`, `GET /search/posts?q=...`, `GET /feeds/popular`, `GET /feeds/foryou`, `GET /posts/{id}`. Only `limit` and `cursor` are confirmed parameters. Response: `{ data: [{id, title, url, summary, tags, readTime, numUpvotes, numComments, source, createdAt}], pagination: {hasNextPage, cursor} }`.

Quotas (shared by token, MCP and OAuth apps): free ~200 requests/month, 60/min per user. Budget ~15-22 requests per run. On 429 honour `retry-after`; if the monthly quota is gone, report it and stop. 401 = bad token, 403 = needs Plus.

## 2. Detect the stack

Read files, don't guess. Direct dependencies only; ignore tiny utility libs.

- Backend: `composer.json` (php, symfony, doctrine, twig, messenger...), `package.json`, `go.mod`, `Gemfile`, `pyproject.toml`.
- Infra: `Dockerfile`, `compose*.y*ml` (databases, traefik, rabbitmq, redis...), CI files, `*.tf`, nomad/ansible. Include Kubernetes only if manifests exist.
- Front: react, react-native, typescript, graphql, vue...

Scope **project**: current repo. Scope **day to day**: aggregate manifests (skip `node_modules`, `vendor`, `.git`) of the user's project folders (e.g. `~/Projects/KnpLabs`, `~/Projects/clementvtrd`, excluding `github`, which holds third-party clones). Rank technologies by number of projects using them; core = used in several projects.

Default day-to-day stack when no scan is possible (no Kubernetes):
- core: php, symfony, doctrine, docker, react, react-native, typescript
- related: mongodb, mysql, redis, rabbitmq, graphql, devops, testing, web-performance, security, observability
- searches: "symfony ux", "symfony messenger", "php static analysis phpstan", "traefik docker", "web eco-design"

Always add 2-4 related topics a developer on that stack benefits from, and respect what the user says they don't use.

## 3. Fetch, merge, rank

1. Per core/related tag: feed by tag, `limit` ~12. Per search term: keyword search, `limit` ~10.
2. Dedupe by `id`/`url`. Keep the last 7-10 days (fall back to 30 if too few).
3. Score = matched core tags (core > related) + log-scaled upvotes/comments + recency. Penalise clickbait and posts without a summary. Max ~3 per tag.
4. Only use fields the API returned; never invent articles or summaries.

## 4. Output

8-10 articles in two groups, **Core to your stack** and **Related / worth knowing**. Per article: title as markdown link, source, read time, upvotes/comments, one line on why it matters for this stack. Add a one-sentence "Trend of the week" only if several articles share a theme, and a last line listing queries that returned nothing useful. Output in the user's language.

## 5. Weekly brief (on request)

To automate it, create a **scheduled task** (not a local cron: it dies with the session) with the scheduled-tasks tools, standalone prompt that repeats sections 1-4 for scope "day to day", delivered as the run's final message. Defaults the user chose: Mondays ~8:30 Europe/Paris, result in the session, push notification.

Remind the user of the one blocker: scheduled runs happen in a fresh cloud session, so there is no MCP sign-in and `DAILY_DEV_TOKEN` must exist in that cloud environment (claude.ai/code > caret after the session title > Edit cloud environment > Environment variables, readable by anyone using that environment; a network secret on host `api.daily.dev` keeps the key out of the VM but requires a prompt that sends no explicit header). The prompt must stop with a clear message when the token is missing rather than improvising.
