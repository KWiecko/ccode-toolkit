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
   - **route by scope — LOCAL vs GENERIC.** A *project-LOCAL* change (this project's tier-data, conventions, reward) → apply here now. A *GENERIC, project-independent* change (a rule that would help ANY project — it belongs in ccode-toolkit, the shared source of truth) → do NOT edit the toolkit on a single project's observation; you can't assume the signal is data-independent. Instead the **dispatcher submits** it to the shared queue in the ccode-toolkit checkout, `.claude/memory/upstream-candidates.jsonl`: upsert a candidate `{id, rule, observations:[{when, project, evidence}], status}` (new candidate, or +1 observation to an existing `id`). The **observer flags** which candidates are generic during harvest (no-priors detector); the **dispatcher does the write** — the observer never writes, which is exactly what keeps it safe to auto-fire.
   - **promote on recurrence, not one shot.** Promote a queued candidate INTO the toolkit means only once it has **more than 2 independent observations (≥3) across distinct projects/chats** (same-session repeats are not independent — they don't add a vote). On promotion: apply the means edit in the toolkit, set the candidate `status:"promoted"`, and log it. This is the cross-project analogue of downgrade-slow — recurrence is the evidence that a rule is truly generic, not a one-project artifact. (Threshold is the current default; adjust here if needed.) NOTE: `upstream-candidates.jsonl` is toolkit-only (a shared vote-log, like decisions.jsonl) — it is NOT synced down into projects.
4. Compact `decisions.jsonl`: drop reverted/superseded/one-off entries; collapse recurring decisions into standing rules in `CLAUDE.md` or `dispatch.md`; keep a short active summary. Commit before and after so git retains the full pre-compaction history.

Each decision entry is one JSON object per line: `{"when","trajectory","action","commit","mode"}` where mode is `auto` or `asked`.
