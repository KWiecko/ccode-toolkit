---
description: Improvement pass — mine feedback, adapt the framework's means, compact the decision log.
---

Reflect on how the framework itself is performing and improve its MEANS (never its reward).

1. Harvest the signals — the read-only `/observe` step: from `.claude/memory/decisions.jsonl` + recent transcripts, where did the human correct, re-prompt, abandon, or repeat the same fix? Prefer these robust behavioral signals over sentiment (a weak hint, never a target — it invites sycophancy).
2. Cluster the recurring friction. One-offs are noise; act on what recurs.
3. Adapt the means:
   - gradual / reversible (reword a CLAUDE.md note, adjust a dispatch heuristic, fix a prompt) → make it, then append a decision entry.
   - keep changes **incremental, not revolutionary** — one small, logged, git-committed step at a time (a bad step is cleanly reverted); no big-bang rewrites. Ask forgiveness, not permission, for harness edits.
   - Never edit `.claude/memory/reward/**`. If the reward seems wrong, raise it with the human — you may not change it.
   - tune model tiers: per task-type, infer difficulty from outcomes (rounds-to-pass, tester failures, oscillation, escalations) and update dispatch.md's tier table — downgrade slow (≥3 clean cheap wins), upgrade fast (one struggle). This is how the dispatcher learns simple-vs-hard.
4. Compact `decisions.jsonl`: drop reverted/superseded/one-off entries; collapse recurring decisions into standing rules in `CLAUDE.md` or `dispatch.md`; keep a short active summary. Commit before and after so git retains the full pre-compaction history.

Each decision entry is one JSON object per line: `{"when","trajectory","action","commit","mode"}` where mode is `auto` or `asked`.
