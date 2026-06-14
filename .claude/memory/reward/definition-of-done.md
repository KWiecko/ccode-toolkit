# Definition of done — the reward (HUMAN-OWNED, off-limits to the loop)

This file defines what "done" MEANS. Agents must not edit it (enforced by `.claude/settings.json`). Only the human changes it. Concrete per-task criteria live in that task's spec, not here.

**"Done" = the original intent demonstrably satisfied on a REAL usage path, with reproducible evidence — not a proxy.**

A valid check (the reward) must be:
- **real-data / behavioral / black-box** — it exercises how the software is actually used, not how the implementation imagines it;
- **reproducible by the human** — the human can re-run it and see the result, not take the agent's word for it;
- **honest about its limits** — "tests green" is necessary, never sufficient; behavior on real usage is the bar.

The criteria are discovered, not fixed up front — expect to refine this as you see real outputs. That refinement is the human's pen, not the loop's.
