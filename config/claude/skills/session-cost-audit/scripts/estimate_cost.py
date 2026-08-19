#!/usr/bin/env python3
"""Estimate USD cost of Claude Code usage from local session transcripts.

Reads ~/.claude/projects/<project-dir>/<session-uuid>.jsonl transcripts,
sums token usage per session (and per project), and estimates cost using
an approximate per-model price table (see PRICING below).

This is an approximation, not a bill. It cannot know which billing path
(first-party API, Claude Team/Pro, Bedrock, Vertex, etc.) actually priced
a given session, and third-party platforms (Bedrock, Vertex) may charge
different rates than Anthropic's first-party list price. Use --project-glob
to scope to repos known to bill through a specific path.

Usage:
    python3 estimate_cost.py [--project-glob PATTERN] [--start YYYY-MM-DD]
                             [--end YYYY-MM-DD] [--top N] [--json-out PATH]
                             [--claude-home PATH]

Examples:
    # All projects, all time, top 20 sessions by estimated cost
    python3 estimate_cost.py

    # Only repos under a specific ghq org (Bedrock-billed repos, say),
    # restricted to a date window, top 10, plus a full JSON dump
    python3 estimate_cost.py \\
        --project-glob '-Users-me-ghq-github-com-myorg-*' \\
        --start 2026-07-23 --end 2026-07-31 \\
        --top 10 --json-out /tmp/cost_report.json
"""

import argparse
import glob
import json
import os
import statistics
from collections import defaultdict
from datetime import datetime, timezone

# Approximate per-model pricing, USD per 1,000,000 tokens.
# "in"/"out" are base input/output rates. "cw5"/"cw1h" are prompt-cache
# *write* rates (5-minute / 1-hour TTL) and "cr" is the cache *read* rate.
# These mirror Anthropic's first-party API list pricing as a stand-in for
# providers (Bedrock, Vertex, Foundry) that don't expose a machine-readable
# price list here — see the notes in SKILL.md for how to refresh this table.
PRICING = {
    "claude-opus-5":     {"in": 5.00, "out": 25.00, "cw5": 6.25, "cw1h": 10.00, "cr": 0.50},
    "claude-opus-4-8":   {"in": 5.00, "out": 25.00, "cw5": 6.25, "cw1h": 10.00, "cr": 0.50},
    "claude-opus-4-7":   {"in": 5.00, "out": 25.00, "cw5": 6.25, "cw1h": 10.00, "cr": 0.50},
    "claude-opus-4-6":   {"in": 5.00, "out": 25.00, "cw5": 6.25, "cw1h": 10.00, "cr": 0.50},
    "claude-opus-4-5":   {"in": 5.00, "out": 25.00, "cw5": 6.25, "cw1h": 10.00, "cr": 0.50},
    "claude-opus-4-1":   {"in": 15.00, "out": 75.00, "cw5": 18.75, "cw1h": 30.00, "cr": 1.50},
    "claude-opus-4-0":   {"in": 15.00, "out": 75.00, "cw5": 18.75, "cw1h": 30.00, "cr": 1.50},
    "claude-sonnet-5":   {"in": 3.00, "out": 15.00, "cw5": 3.75, "cw1h": 6.00, "cr": 0.30},
    "claude-sonnet-4-6": {"in": 3.00, "out": 15.00, "cw5": 3.75, "cw1h": 6.00, "cr": 0.30},
    "claude-sonnet-4-5": {"in": 3.00, "out": 15.00, "cw5": 3.75, "cw1h": 6.00, "cr": 0.30},
    "claude-sonnet-4-0": {"in": 3.00, "out": 15.00, "cw5": 3.75, "cw1h": 6.00, "cr": 0.30},
    "claude-haiku-4-5":  {"in": 1.00, "out": 5.00, "cw5": 1.25, "cw1h": 2.00, "cr": 0.10},
    "claude-fable-5":    {"in": 10.00, "out": 50.00, "cw5": 12.50, "cw1h": 20.00, "cr": 1.00},
    "claude-mythos-5":   {"in": 10.00, "out": 50.00, "cw5": 12.50, "cw1h": 20.00, "cr": 1.00},
}
# Used for any model id not found in PRICING above (e.g. a brand-new model
# release, or a snapshot-dated id). Sonnet-tier is a reasonable midpoint.
DEFAULT_PRICE = {"in": 3.00, "out": 15.00, "cw5": 3.75, "cw1h": 6.00, "cr": 0.30}


def parse_ts(ts):
    if not ts:
        return None
    try:
        return datetime.fromisoformat(ts.replace("Z", "+00:00"))
    except Exception:
        return None


def parse_date_bound(s, end_of_day=False):
    if not s:
        return None
    d = datetime.strptime(s, "%Y-%m-%d").replace(tzinfo=timezone.utc)
    if end_of_day:
        d = d.replace(hour=23, minute=59, second=59, microsecond=999999)
    return d


def cost_for_usage(usage, model):
    price = PRICING.get(model, DEFAULT_PRICE)
    inp = usage.get("input_tokens", 0) or 0
    out = usage.get("output_tokens", 0) or 0
    cc = usage.get("cache_creation", {}) or {}
    cw5 = cc.get("ephemeral_5m_input_tokens", 0) or 0
    cw1h = cc.get("ephemeral_1h_input_tokens", 0) or 0
    cr = usage.get("cache_read_input_tokens", 0) or 0
    cost = (
        inp * price["in"]
        + out * price["out"]
        + cw5 * price["cw5"]
        + cw1h * price["cw1h"]
        + cr * price["cr"]
    ) / 1_000_000.0
    return cost, inp, out, cw5, cw1h, cr


def analyze(claude_home, project_glob, start, end, top_n):
    projects_root = os.path.join(claude_home, "projects")
    pattern = os.path.join(projects_root, project_glob or "*", "*.jsonl")
    files = sorted(glob.glob(pattern))

    sessions = []
    for fp in files:
        rel = os.path.relpath(fp, projects_root)
        project = rel.split(os.sep)[0]
        session_id = os.path.basename(fp)[: -len(".jsonl")]

        total_cost = 0.0
        totals = defaultdict(float)
        model_turns = defaultdict(int)
        first_ts = None
        last_ts = None
        touched = False

        with open(fp, "r", errors="ignore") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    d = json.loads(line)
                except Exception:
                    continue
                if d.get("type") != "assistant":
                    continue
                ts = parse_ts(d.get("timestamp"))
                if ts is None:
                    continue
                if start and ts < start:
                    continue
                if end and ts > end:
                    continue
                msg = d.get("message", {})
                usage = msg.get("usage")
                if not usage:
                    continue
                model = msg.get("model", "unknown")
                cost, inp, out, cw5, cw1h, cr = cost_for_usage(usage, model)

                total_cost += cost
                totals["input"] += inp
                totals["output"] += out
                totals["cache_write_5m"] += cw5
                totals["cache_write_1h"] += cw1h
                totals["cache_read"] += cr
                model_turns[model] += 1
                touched = True
                if first_ts is None or ts < first_ts:
                    first_ts = ts
                if last_ts is None or ts > last_ts:
                    last_ts = ts

        if touched:
            sessions.append({
                "project": project,
                "session": session_id,
                "cost_usd": total_cost,
                "input_tokens": totals["input"],
                "output_tokens": totals["output"],
                "cache_write_5m_tokens": totals["cache_write_5m"],
                "cache_write_1h_tokens": totals["cache_write_1h"],
                "cache_read_tokens": totals["cache_read"],
                "models": dict(model_turns),
                "first_ts": first_ts.isoformat() if first_ts else None,
                "last_ts": last_ts.isoformat() if last_ts else None,
            })

    sessions.sort(key=lambda r: r["cost_usd"], reverse=True)

    per_project = defaultdict(float)
    for s in sessions:
        per_project[s["project"]] += s["cost_usd"]
    projects_ranked = sorted(per_project.items(), key=lambda kv: kv[1], reverse=True)

    costs = [s["cost_usd"] for s in sessions]
    outliers = []
    if len(costs) >= 3:
        mean = statistics.mean(costs)
        stdev = statistics.pstdev(costs)
        if stdev > 0:
            threshold = mean + 2 * stdev
            outliers = [s for s in sessions if s["cost_usd"] > threshold]

    return {
        "sessions": sessions,
        "projects_ranked": projects_ranked,
        "outliers": outliers,
        "total_cost": sum(costs),
        "top_n": sessions[:top_n],
    }


def format_report(result, top_n):
    lines = []
    lines.append(f"Sessions analyzed: {len(result['sessions'])}")
    lines.append(f"Total estimated cost: ${result['total_cost']:.2f}")
    lines.append("")
    lines.append(f"=== Top {min(top_n, len(result['top_n']))} sessions by estimated cost ===")
    for i, r in enumerate(result["top_n"], 1):
        lines.append(
            f"{i}. ${r['cost_usd']:.2f}  {r['project']} / {r['session']}"
        )
        lines.append(
            f"   in={r['input_tokens']:.0f} out={r['output_tokens']:.0f} "
            f"cache_write_5m={r['cache_write_5m_tokens']:.0f} "
            f"cache_write_1h={r['cache_write_1h_tokens']:.0f} "
            f"cache_read={r['cache_read_tokens']:.0f}"
        )
        lines.append(
            f"   models={r['models']}  {r['first_ts']} ~ {r['last_ts']}"
        )
    lines.append("")
    lines.append("=== Top projects by estimated cost ===")
    for project, cost in result["projects_ranked"][:top_n]:
        lines.append(f"${cost:.2f}  {project}")
    if result["outliers"]:
        lines.append("")
        lines.append(
            f"=== Outlier sessions (cost > mean + 2*stdev, n={len(result['outliers'])}) ==="
        )
        for r in result["outliers"]:
            lines.append(f"${r['cost_usd']:.2f}  {r['project']} / {r['session']}")
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--claude-home", default=os.path.expanduser("~/.claude"),
                    help="Path to the Claude Code home dir (default: ~/.claude)")
    ap.add_argument("--project-glob", default="*",
                    help="Glob pattern (matched against project directory names under "
                         "<claude-home>/projects/) to scope analysis to specific repos, "
                         "e.g. '-Users-me-ghq-github-com-myorg-*'. Default: all projects.")
    ap.add_argument("--start", default=None, help="Start date, inclusive, YYYY-MM-DD (UTC)")
    ap.add_argument("--end", default=None, help="End date, inclusive, YYYY-MM-DD (UTC)")
    ap.add_argument("--top", type=int, default=20, help="How many top sessions/projects to show")
    ap.add_argument("--json-out", default=None, help="Optional path to write the full JSON report")
    args = ap.parse_args()

    start = parse_date_bound(args.start, end_of_day=False)
    end = parse_date_bound(args.end, end_of_day=True)

    result = analyze(args.claude_home, args.project_glob, start, end, args.top)
    print(format_report(result, args.top))

    if args.json_out:
        with open(args.json_out, "w") as f:
            json.dump(result, f, ensure_ascii=False, indent=2, default=str)
        print(f"\nFull report saved to {args.json_out}")


if __name__ == "__main__":
    main()
