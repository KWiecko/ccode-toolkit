---
description: Read-only reward harvest — observe outputs + conversation, surface learning signals. Safe to fire periodically (e.g. /loop 1h /observe). Applies nothing.
---

Spawn the `observer` subagent (read-only) to harvest signals from recent transcripts + `.claude/memory/decisions.jsonl`, and surface its summary: completion/functionality success patterns, recurring friction, tier-difficulty signals, and candidate means-tweaks (proposals only).

Apply nothing — this only observes. Acting on the proposals is `/reflect` (human-paced). If something needs the human, say so.
