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

Run **xhigh by default** — deeper reasoning is mostly safe upside. Pinned via `settings.json` (`effortLevel: xhigh`); agents carry `effort:` in frontmatter.

**Max effort on signal-PRODUCERS — never trim it there.** The observer (its read *is* the meta-reward), the tester and reviewer (their verdicts *are* the reward signal) all run **xhigh**: a cheap mis-read corrupts the learning loop, the worst place to economize. Only trim effort on pure-*execution* work where a mistake is caught by the gate, not propagated as a corrupted signal.

Note: effort has **no per-invocation override** — vary it by agent role or session, not per spawn (unlike model tier, which the dispatcher overrides per task).

## Parallelization — structure decides *whether*, throughput decides *how much*

Never gate on a token estimate: it's ~30x noisy on the same task and systematically low (arXiv 2604.22750), and latency follows the **critical path**, not the token sum (LAMaS). The rule is **fan out reads, serialize writes.**

**WHETHER (task structure):**
- **Default serial for coding writes** — coding is a poor multi-agent fit; parallelism is a ~15x-token bet that pays only on breadth.
- **Parallelize reads freely** — research, code-understanding, review, audit, testing are read-only → no conflicting decisions. *Free win:* run the **tester and reviewer in parallel** on the worker's handoff (independent read-only votes, aggregated at the reward gate).
- **Parallelize writes only when** units have: (a) **disjoint write-sets** — enumerate the files/dirs each branch writes; if they intersect, serial; (b) **no result-dependency edge** (no "A makes a util B imports"); (c) **no shared mutable resource** (DB/port/cache — worktrees isolate files only); (d) **no improvised shared convention** — two writers making conflicting design choices in *different* files merge **clean** and ship **silently broken** (the failure git can't catch). If you can't list each unit's files up front, you don't understand it yet — plan first.
- **Engineer independence:** if units share a contract/interface, scaffold + commit it **serially first**, then fan out the consumers (highest-leverage move). Parallelize **wide-and-shallow** graphs; never a **deep chain**.

**HOW-MUCH (throughput — only after structure allows it):**
- width = min(16 workflow cap, OTPM-remaining ÷ per-agent, RPM-remaining). **Opus OTPM is the binding seat** → route parallel **width to sonnet/haiku**, keep opus for the dispatcher + synthesis; lean on prompt caching (cache_read is ~free against ITPM).
- Cap **writers at 2–4** (more only for pure independent-unit fan-out); stagger spawns (burst → 429).
- **Estimate-cheap, measure-live, cap-hard:** probe one slice for real tokens/unit → meter live (`/workflows`, `/usage`, rate-limit headers) → set width → hard token/$ cap. A measured slice beats any forecast.

**Mechanism ladder (cheapest/safest first — all native; don't bolt on LangGraph/CrewAI):** parallel read/research subagents → `claude -p` headless fan-out (mechanical per-file, capped) → worktree-per-unit or `/batch` (independent feature units) → agent-teams with a shared task-list lock-and-claim (off by default; only >2 writers). Each writer gets `isolation: worktree`.

**Integration is where parallel work fails — make it a single-threaded reduce:** merge **sequentially** (not all-at-once), **never auto-merge**, and run the **behavioral reward check even after a clean merge**. Per-branch green is necessary, never sufficient.

**Voting-by-competition** (hard/low-confidence task with a real reward): run N parallel worker attempts in separate worktrees, pick the winner at the reward gate.

## Task type → recipe

- one-sentence diff / typo / rename → main loop does it directly; no subagents.
- standard change / feature → plan briefly → worker → black-box tester + reviewer (opus default).
- mechanical sweep across many files → `claude -p` fan-out, scoped `--allowedTools`, capped; test the prompt on 2–3 files first.
- novel / off-distribution / architectural / security-critical → opus; human-led, low autonomy; agent assists, human decides.
- hard / breadth-first / repeated-struggle → main session escalates to **xhigh + a workflow** (ultracode), then the reward gate + human verdict still apply.

## Everything through the loop — keep the ensemble decorrelated

All non-trivial tasks go through the dispatched loop (worker → tester **∥** reviewer → observer), not inline dispatcher hand-coding; even small bugfixes get worker+tester. Keep **tester and reviewer DECORRELATED — never collapse to one** for TUI/terminal, failure-mode/concurrency, and long-running/stateful work: the blind code-reading reviewer reliably catches reproduced blockers the black-box happy-path tester *passes* (those bugs only surface under a fault / race / render / past-a-limit). Inline-coding skips the reviewer — exactly when blockers ship. Truly trivial one-line/mechanical edits may be inline, but **log them**.

## Real-life test for TUI/CLI (and human-perceived surfaces) — MANDATORY

A TUI's real behaviour is **frame-level**; widget/object-state assertions (e.g. a framework's `run_test()` Pilot reading `.active`/`.lines`) are **blind** to rendering, cropping, wrap, scroll, and over-time state. **You MUST always (when at all possible) build and run a HUMAN-SIMULATED test env**, not a state-check:

1. **Drive the real binary** in a real **PTY** at a realistic terminal size (not the object API).
2. **Prompt/inject real input** the way the user would (add a small test-only input seam — a fifo / stdin / `--inject` flag — if the live loop is driven by a device like a mic so it can't otherwise be fed).
3. **Capture and assert on the RENDERED SCREEN with an external terminal emulator** — `pyte` (Python, no sudo: feed it the PTY bytes, read `screen.display`), or `tmux capture-pane -p`, or `script`. Assert what is *visibly* on screen (the tab switched and is highlighted, the newest line shows, text wrapped not truncated).
4. Then a **human live smoke** before "done."

State-green / pilot-green is necessary, **never** sufficient — this project has repeatedly shipped TUI bugs (desync, head-vs-tail, wrap-as-slider, tabs-not-switching) that passed object-state checks and were caught only by a human running it. The human-simulated PTY+rendered-frame test is the standing requirement; build the harness once and reuse it. (Enforced as the "Real-usage test" done-questionnaire item; the observer keeps a compliance question on it because the user raises it repeatedly.)

## Escalate on oscillation — change the primitive, not the parameter

When a fix is hand-tuning a heuristic **parameter** (threshold/window/timeout/retry/sensitivity) and **≥2 rounds fail with the same failure mode**, STOP: treat non-convergence as a **wrong-primitive** signal, run the Directive-1.7 prior-art scan for a robust replacement, and escalate to `/feature` — don't keep patching the constant. The 2nd identical failure is the signal to switch the primitive, not tune it.

## Honor the harvest cadence — don't wait to be told

The periodic `/observe` nudge is a **do-it obligation, not advisory.** Run `/observe` at each natural break (a feature accepted/committed, a stopping point) where the cadence is due — **proactively**, don't wait for the human to invoke it — and `/reflect` on real signal. The harvest exists to catch inline-drift, testing-gaps, and recurring same-component rounds **early**. When a harvest reports "healthy," also audit **process adherence** (did the rituals run on cadence? is the done-questionnaire used + complete?) — a code-only harvest is blind to the dispatcher's own drift. The human paces *world-actions*, not the read-only harvest; the harvest is the dispatcher's standing job. Also **log task outcomes** (task-type / rounds / verdict, incl. struggles & out-of-loop work) — the tier table can only learn from a populated `decisions.jsonl`.

## Stale-build & multi-agent ops hygiene

- A long-running **daemon/TUI/server** reported as "hanging / odd" → **first suspect a STALE in-memory build** (the process doesn't reload edited files); verify the running PID started after the latest edit + check its log before debugging code.
- After a worker hands back, **verify the git branch before the dispatcher commits**; prefer `git checkout <sha> -- <files>` over a blind cherry-pick when a commit's parent already holds most of the change.
