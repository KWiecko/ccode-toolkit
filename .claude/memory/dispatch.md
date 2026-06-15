# Dispatch heuristics (means — adapt freely via /reflect, refined from decisions.jsonl)

## Model tier — a dispatch parameter

Default: **opus** for all agents (set in each agent's frontmatter). The tier is **not fixed** — the orchestrator sets it per task at spawn via the Agent `model` override, which takes precedence over frontmatter.

Policy: the tier should track task **difficulty**, learned from real outcomes — not judged up front or self-declared. Read difficulty from behavioral signals (in transcripts / `decisions.jsonl`): rounds-to-pass, black-box-tester failures, oscillation, escalations to the human.

- **Downgrade slow** — lower a task-type's tier only after it has repeatedly (≥3) succeeded cheaply at the current tier (clean, few-round wins).
- **Upgrade fast** — raise it back on a *single* struggle at the lower tier (a failure, oscillation, or escalation).

Rationale: under-powering is asymmetric — it costs rework and risks a bad result slipping through; over-powering is just mild overspend. Bias toward caution. Before changing tier at all, prefer a sharper prompt or splitting the step.

Observed downgrades (start empty; `/reflect` fills this from real runs):
- (none yet)

## Orchestration tier — escalate to ultracode/workflow

Default every task to the cheap named pipeline (worker → black-box tester + reviewer + human vote). The orchestrator (main session — a subagent cannot launch a workflow) escalates a task to **ultracode / a workflow** only when one trips:

- **Risk floor (fixed, human-owned, checked up front):** irreversible / high-blast-radius / novel / architectural / security-critical → forces the high tier before any cheap attempt. NOT auto-learned — adjustable only by the human (consent-gated, like main-branch merges), so survivorship can't erode it.
- **Demonstrated struggle (learned):** the cheap tier fails the reward, oscillates, or hits the 3-round cap. Escalate-fast on one struggle; de-escalate a task-type only after ≥3 clean cheap wins.
- **Breadth-first structure:** the task genuinely splits into independent angles where parallel search helps (not tightly-coupled coding).

Both tiers terminate at the SAME reward gate + human verdict — escalation widens the search, never lowers the bar. Guardrails on every tier: single-writer only (never parallel writers); keep the external evidence gate (don't let a heavier tier self-certify).

Why cheap-by-default: more orchestration *adds* failure modes and cost (Agentless beat agentic scaffolds at far less cost; MAST: verification/coordination is the #1 failure). Over-orchestration is a harm, not a free hedge.

## Effort

Run **xhigh by default** — deeper reasoning is mostly safe upside. Set the session with `/effort xhigh` (the framework can't force it); agents carry `effort:` in frontmatter.

**Max effort on signal-PRODUCERS — never trim it there.** The observer (its read *is* the meta-reward), the tester and reviewer (their verdicts *are* the reward signal) all run **xhigh**: a cheap mis-read corrupts the learning loop, the worst place to economize. Only trim effort on pure-*execution* work where a mistake is caught by the gate, not propagated as a corrupted signal.

Note: effort has **no per-invocation override** — vary it by agent role or session, not per spawn (unlike model tier, which the dispatcher overrides per task).

## Task type → recipe

- one-sentence diff / typo / rename → main loop does it directly; no subagents.
- standard change / feature → plan briefly → worker → black-box tester + reviewer (opus default).
- mechanical sweep across many files → `claude -p` fan-out, scoped `--allowedTools`, capped; test the prompt on 2–3 files first.
- novel / off-distribution / architectural / security-critical → opus; human-led, low autonomy; agent assists, human decides.
- hard / breadth-first / repeated-struggle → main session escalates to **xhigh + a workflow** (ultracode), then the reward gate + human verdict still apply.
