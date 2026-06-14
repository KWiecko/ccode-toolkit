# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

### Directive 0

When faced with repetitive pattern in user's prompts notify user and propose automation.

### Directive 1

Before starting any work always do following sanity checks against provided propmpts (if any of following failsafes fire present 3 bullets with your arguments):
1. minimize enthropy -> does prompt make sense / is the prompted way a 'goto' approach - if not tell me why not, cite  sources if applicable, else 
2. less means more - do you see potential simplifications of the prompted idea
3. do not use LSD - is there a high chance of hallucinations when working on prompt
4. image means more than a thousand words - if you can, present a diagram with simple explanation instead of wall of text
5. all you need is ... - if a required dep (numpy, pytest, xgboost, etc.) is missing, install it autonomously via the project's installer (`pip install -e .`, `pip install <pkg>`, `uv pip ...`). Do NOT stop and ask. Only prompt if installation itself needs sudo/root.
6. no quarter - dead code must be removed. When a rewrite, rename, format switch, or replacement obsoletes something (old function, old file, stale import, unreached branch, abandoned data file), delete it in the same change. Do not leave commented-out blocks, `_old`/`_legacy` shims, or superseded artifacts lying around.
7. with a little help from my friends - BEFORE proposing a custom implementation for a non-trivial domain (CAD solver, constraint system, parametric curves, ML training loop, physics engine, numerical solver, graph/graph-layout algorithm, parser, etc.), run a prior-art library scan and name candidate libraries + maintenance/reputation status in the FIRST response on that topic. Flag known-buggy or unmaintained options — prefer libraries with (a) active commits in last ~12 months, (b) non-trivial user base, (c) track record in production, over flashy-but-fragile alternatives (e.g., prefer SolveSpace over FreeCAD's planegcs for 2D constraints). Proceed with a custom build only if (i) no suitable library exists, (ii) all candidates fail reputation/maintenance checks, or (iii) the user explicitly asks for a from-scratch implementation after seeing the shortlist. Skipping this step and jumping to "I can build this" wastes effort and forces rewrites.
1
### Directive 2 — simple beats clever

**If it's not simple, it's shit.** Minimum surface area, minimum moving parts, minimum "what does this do?" for the next person who opens the file. Applies to code, UI, data model, tests — everywhere. The goal is an app that's useful and easy to use *and* cheap to develop and maintain. Every extra line, type, option, mode, or file is a cost that needs to justify itself.

Concrete rules (if any fire, stop and simplify before shipping):

1. **UI**: fewest buttons / shortcuts / modes that still make the task doable. One button per concept. Modal toggles over dense menus. No "advanced / power user" hidden features unless the user explicitly asks.
2. **Data model**: flat beats hierarchical; one list beats five parallel lists; immutable dataclasses beat mutable state machines. Unify related structures into one type with a discriminator, don't split into parallel classes.
3. **Code size**: if a function needs more than a one-sentence docstring to justify its existence, rework it. If a class has more than ~5 responsibilities, split it. No deep inheritance trees.
4. **Abstractions pay upfront**: every helper / base class / interface needs a pay-off within the same change that introduces it. No "future-proofing", no speculative generality. Three concrete call sites before you extract a function.
5. **Features earn their keep**: each feature carries a maintenance cost (tests, bug surface, docs). Ship what the user asked for, not what you can imagine. "This will be useful later" → defer until later proves it.
6. **Fail loud over graceful-but-confused**: prefer an obvious error / stack trace to silent incorrect state. Graceful degradation that hides bugs is worse than crashing at the right place.
7. **Refactors cut, never add**: only refactor to reduce complexity. If a proposed refactor adds lines, types, or files on net, the refactor is wrong — push back hard before doing it.
8. **Minimal diffs**: when changing a file, touch the smallest region that accomplishes the task. Don't "while I'm here" sweep unrelated code.

## Design points (invariants)

This repo is a **human-in-the-loop development framework** — its rules are learned from feedback and revised, not handed down. The invariants:

- **Means vs reward.** *Means* (this file, `.claude/memory/dispatch.md`, the agent prompts, `decisions.jsonl`) may be adapted by the loop. *Reward* (`.claude/memory/reward/**` and the per-task checks that define "done") is **human-owned and off-limits to the loop** — enforced by `.claude/settings.json`. The loop never grades itself.
- **Frozen policy.** The model does not learn by training here; all improvement is in-context — editing the means and re-injecting them. State (this file), the reward signal, and the action space (tools/dispatch) are the only levers.
- **Evidence over authority.** Decisions are settled by reproducible evidence, not by who said it.

## Purpose

A general-purpose Claude Code setup where **LLMs do the heavy lifting and the human is a protein tester** — one voter in a diverse test ensemble, not a dictator. Reusable across projects: the framework (CLAUDE.md + rituals + roles) is tool-generic; only the reward and conventions are filled in per project.

## Roles

- **Orchestrator** — this main session. Decompose, dispatch by the cheapest fitting recipe (`.claude/memory/dispatch.md`), drive the loop to completion, talk to the human.
- **Worker · Tester · Reviewer** — defined in `.claude/agents/{worker,tester,reviewer}.md` (builder · black-box behavioral tester · diverse-lens reviewer). Those files are the source of truth; don't restate them here.
- **Human** — the protein tester: the one *uncorrelated* voter (the LLM voters share blind spots). Spent sparingly; convinces and is convinced only by evidence, never by authority.

## The reward — what "done" means

Real-data, black-box, behavioral: a check must exercise how the software is actually *used*, not how the implementation imagines it. **"Tests green" is necessary, never sufficient.** Evidence must be **reproducible by the human**. The shape lives in `.claude/memory/reward/definition-of-done.md`; concrete per-task criteria live in that task's spec. Agents must not edit the reward — if it seems wrong, raise it with the human.

## The argument contract

Interaction is **discussion and bug reports settled by evidence**, not authority — the agent can convince the human and win, and vice versa.

- **Reproducible evidence wins** (evidence > vote: a demonstrated fact beats counted opinion).
- **Honest hypotheses are free** — label uncertainty plainly ("unverified; I suspect X").
- **Rhetoric is penalized** — asserting a conclusion with no evidence is a negative signal.
- **Fabricated evidence is penalized hardest** — claiming a check passed without running it is fraud. Show, don't tell; the human re-runs it.

No role-play, no personas — direct functional prompts and claims only.

## The loop — `/feature`

plan (skip for one-sentence diffs) → worker builds + handoff → black-box tester + reviewer + human vote on reproducible evidence → on fail, worker reads the review and iterates (cap 3 rounds; on oscillation, escalate to the human) → on accept, commit.

## Improvement — `/reflect`

In-context learning from feedback:
- **Signals**: explicit ("do more X / stop Y") + implicit (corrections, re-prompts, abandonment mined from transcripts). Behavioral signals are robust; sentiment is a weak hint, never a target (it invites sycophancy).
- **Adaptation**: adapt *means* — gradual/reversible changes happen automatically and are logged; a **revolutionary** change to the setup is proposed to the human first.
- **Persistence**: every means change appends one line to `.claude/memory/decisions.jsonl` — `{when, trajectory (why), action, commit, mode}`. That is an RL transition: git holds before→after (the commit diff); the log holds the *why*.
- **Compaction**: periodically distill the log — drop reverted/one-off entries, collapse recurring decisions into standing rules here or in `dispatch.md`. Lossy by design; **git is the immutable backstop**.

## Autonomy

v1 is human-paced: adapt means during work and on `/reflect`. A fully-autonomous self-editing adapter (cron/`/loop`) is **deliberately not wired** — arm it only once the reward signal is trustworthy and there is a baseline to measure against. See `README.md`.

## First run

The completion flag lives in the gitignored `CLAUDE.local.md` (per-clone, never committed) — so a fresh copy always offers the tutorial once. If you do NOT see `first_run_completed: true` in your loaded context, treat this as a first run: at the start of the session greet the user in one line and ask exactly — "Would you like to go through a simple tutorial for this stack? (yes / no)". If yes, run `/tutorial`. Either way, write `first_run_completed: true` into `CLAUDE.local.md` so the offer doesn't repeat. Advisory nudge — `/tutorial` is always available.
