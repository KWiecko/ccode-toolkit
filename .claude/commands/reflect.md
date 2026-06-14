---
description: Improvement pass — mine feedback, adapt the framework's means, compact the decision log.
---

Reflect on how the framework itself is performing and improve its MEANS (never its reward).

1. Read `.claude/memory/decisions.jsonl` and recent session signals: where did the human correct, re-prompt, abandon, or repeat the same fix? Prefer these robust behavioral signals over sentiment (sentiment is a weak hint, never a target — it invites sycophancy).
2. Cluster the recurring friction. One-offs are noise; act on what recurs.
3. Adapt the means:
   - gradual / reversible (reword doctrine, adjust a dispatch heuristic, fix a prompt) → make it, then append a decision entry.
   - revolutionary / hard-to-reverse change to the setup → propose it to the human first, with evidence, and wait.
   - Never edit `.claude/memory/reward/**`. If the reward seems wrong, raise it with the human — you may not change it.
4. Compact `decisions.jsonl`: drop reverted/superseded/one-off entries; collapse recurring decisions into standing rules in `CLAUDE.md` or `dispatch.md`; keep a short active summary. Commit before and after so git retains the full pre-compaction history.

Each decision entry is one JSON object per line: `{"when","trajectory","action","commit","mode"}` where mode is `auto` or `asked`.
