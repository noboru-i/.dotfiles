---
name: session-cost-audit
description: Estimate the USD cost of Claude Code usage by scanning local session transcripts under ~/.claude/projects/*/*.jsonl, and find sessions or projects with unusually high token spend. Use this whenever the user asks things like "which session used the most tokens", "is any repo burning through cost", "find sessions with unusually high API cost", "estimate how much this session/project cost", or wants to distinguish spend on one billing path (e.g. Bedrock, Vertex, a specific org's API key) from another (e.g. Claude Team/Pro) by scoping to a subset of repos. Trigger this proactively for any request about auditing, estimating, or comparing Claude Code token/cost usage across sessions, repos, or time windows — don't wait for the user to name this skill or mention "JSONL" explicitly.
---

# Session Cost Audit

Claude Code writes one JSONL transcript per session to
`~/.claude/projects/<project-dir>/<session-uuid>.jsonl`. Each assistant turn
in that file carries a `usage` block (input tokens, output tokens, cache
read/write tokens) and the model that produced it. This skill turns those
transcripts into a cost estimate, so you can answer "which session/project
is costing the most?" without the user having to pull real billing data.

**This is always an estimate, never a bill.** Say so in your summary. Two
things it fundamentally cannot know:

- **Which billing path priced a session.** The transcripts don't record
  whether a session was billed via the first-party API, Claude Team/Pro
  seats, Amazon Bedrock, Google Vertex AI, or Microsoft Foundry — that's
  determined by account/repo configuration outside the transcript. If the
  user needs to isolate one billing path (e.g. "which repos bill through
  Bedrock, not the Team plan"), ask them for a filter — usually a glob or
  substring over project directory names — rather than guessing.
- **Third-party pricing.** Bedrock/Vertex/Foundry can price tokens
  differently from Anthropic's first-party list price. The script below
  approximates with first-party pricing as the best available stand-in;
  call this out as an approximation in your summary.

## How project directories map to repos

A project directory name is the repo's absolute path with every `/`
replaced by `-` (e.g. `/Users/me/ghq/github.com/myorg/myrepo` becomes
`-Users-me-ghq-github-com-myorg-myrepo`). Worktrees get their own project
directory too, usually with a `-worktrees-<branch>` suffix. When a user
wants to scope the analysis to a specific org, host, or set of repos, build
a glob against this naming convention — e.g.
`-Users-me-ghq-github-com-myorg-*` covers every repo (and worktree) under
that org.

If the user hasn't said which repos matter, or which billing path they
care about, ask before running — a wrong guess here silently mis-scopes
the entire analysis. If they just want a global "what's using the most
tokens" answer with no billing-path distinction, running with no filter
(the default) is the right call.

## Running the analysis

Use the bundled script rather than re-deriving this logic inline — it
already handles the transcript parsing, cost math, and outlier detection
correctly:

```bash
python3 scripts/estimate_cost.py \
  --project-glob='<pattern-or-omit-for-all>' \
  --start YYYY-MM-DD --end YYYY-MM-DD \
  --top 10 \
  --json-out /tmp/cost_report.json
```

All flags are optional. Notes on each:

- `--project-glob`: matched against directory names under
  `~/.claude/projects/`. **Pass it as `--project-glob=<pattern>`** (with the
  `=`) when the pattern starts with `-` — otherwise argparse mistakes it
  for a flag. Omit to scan every project.
- `--start` / `--end`: inclusive UTC date bounds (`--end` is treated as the
  end of that day). Omit either side to leave it open.
- `--top`: how many sessions and projects to show in the ranked lists
  (default 20).
- `--json-out`: writes the full per-session data (every session found, not
  just the top N) to a JSON file, useful if the user wants to dig further
  or you need to answer a follow-up question without re-scanning.

The script prints: total sessions analyzed, total estimated cost, a
top-N ranked list of sessions (with token breakdown and the model(s)
used), a top-N ranked list of projects (sessions summed per project), and
a list of statistical outliers (sessions whose cost exceeds mean +
2×stdev) — these are the ones worth calling out explicitly as "unusually
high," since a single top-of-list session isn't necessarily anomalous if
the whole distribution is just spread out.

## Reporting results

Summarize for the user, don't just paste the raw script output. A useful
structure:

1. Total estimated cost and session count for the scope/window asked
   about.
2. A short table of the top few sessions or projects, with enough context
   to identify the work (grep the session's first user-turn text for a
   one-line description if it helps — see below).
3. Explicitly flag the outlier sessions, if any, and what's distinctive
   about them (e.g. "these three all show cache_read in the millions of
   tokens, suggesting long, broad codebase exploration").
4. The approximation caveat from above, once, near the end — not repeated
   for every number.

### Getting context for a specific session

To see what a session was actually about, read its first `user` turn:

```bash
python3 -c "
import json
with open('<path-to-session>.jsonl') as f:
    for line in f:
        d = json.loads(line)
        if d.get('type') == 'user' and isinstance(d.get('message', {}).get('content'), str):
            print(d['message']['content'][:200])
            break
"
```

## Keeping the price table current

`scripts/estimate_cost.py` has a `PRICING` dict keyed by model ID (e.g.
`claude-sonnet-5`, `claude-opus-4-7`), each with per-1M-token rates for
input, output, 5-minute cache write, 1-hour cache write, and cache read.
Model pricing changes over time (new models ship, introductory pricing
expires). Before running this skill on a request where cost accuracy
matters, check whether the `claude-api` skill's cached model/pricing table
(`shared/models.md`) lists a model that isn't in `PRICING`, or a rate that
has visibly drifted from what's in the script — update the dict if so.
Models not in the table fall back to `DEFAULT_PRICE` (Sonnet-tier rates),
which is a reasonable default but worth flagging if the top sessions are
dominated by an unpriced model.
