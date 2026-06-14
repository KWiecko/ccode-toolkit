# ccode-toolkit — a human-in-the-loop development framework for Claude Code

LLMs do the heavy lifting; you are the **protein tester** — one voter in a diverse test ensemble, not a dictator. The model is frozen, so the framework improves **in-context**: it adapts its *means* from feedback, never its *reward*.

## The idea in one screen

- **Roles** — orchestrator (the main session), worker (builds), tester (black-box), reviewer (diverse lens), and you (the uncorrelated human voter).
- **Reward** — "done" is real-data, black-box, behavioral, and reproducible by you. "Tests green" is necessary, not sufficient. It lives in `.claude/memory/reward/` and is **off-limits to the agents** — only you change what "done" means.
- **Argument contract** — discussion and bug reports are settled by *reproducible evidence*, not authority. The agent can convince you and win; you can be convinced. Reproducible evidence wins · honest hypotheses are free · rhetoric is penalized · fabricated evidence is penalized hardest.
- **Improvement** — every change to the *means* appends a line to `.claude/memory/decisions.jsonl` (`{when, trajectory, action, commit, mode}`); git holds the before/after. `/reflect` compacts the log and crystallizes recurring decisions into standing rules. Git is the immutable backstop.
- **Consent** — gradual/reversible changes happen automatically and are logged; a *revolutionary* change to the setup is proposed to you first.

## Use

- `/feature <request>` — run the dev loop (plan → build → black-box test → evidence verdict → commit).
- `/reflect` — improvement pass: mine feedback, adapt means, compact the decision log.

## Layout

```
CLAUDE.md                          framework notes (source of truth)
.claude/
  settings.json                    permissions — reward/ is deny-listed
  commands/{feature,reflect}.md    the two rituals
  agents/{worker,tester,reviewer}.md
  memory/
    decisions.jsonl                append-only decision log (RL transitions)
    dispatch.md                    task-type → recipe heuristics (means)
    reward/definition-of-done.md   what "done" means (human-owned, off-limits)
```

## Not yet wired (on purpose)

A fully-autonomous self-editing adapter (a cron/`/loop` that adapts means unattended) is **off** in v1. A self-editing loop on a noisy reward degrades itself — every such system in the literature got caught reward-hacking. Arm it only once your reward signal is trustworthy and you have a baseline to measure against. Build order: run real work through the loop, let `decisions.jsonl` accumulate, then consider arming it.
