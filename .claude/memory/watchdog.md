# Watchdog — the dispatcher's self-check (this IS the scheduling)

Run this checklist at each **natural break** and whenever the `/observe` hook fires (a do-it
obligation, not advisory). **Running it on cadence replaces an autonomous scheduler** — no
cron/`/loop` is wired (see Autonomy); the self-interrogation *is* the schedule. **Append a run
entry to the log below each time**, so "when did I last …?" is answered by reading, not guessing.

## The self-check (answer honestly, with evidence)

1. **When did I last run `/observe` and `/reflect`?** (read the run-log below.) If it's been
   >~1 working hour / the hook has fired since → run `/observe` *now* before continuing;
   `/reflect` on real signal.
2. **Did I build a HUMAN-IN-THE-LOOP simulation test** for any UI/CLI/long-running work since
   the last check? — real binary in a **PTY**, **injected** real input, **rendered frame
   asserted** via `pyte`/`tmux`/`script` (NOT a widget/object-state check), + a human smoke.
   If it applied and I didn't, that's a gap to fix before "done."
3. **Did all non-trivial work go through the loop** (worker → tester ∥ reviewer → observer),
   reviewer kept decorrelated — not inline hand-coding?
4. **What is my current reward / compliance state, and WHY?** — healthy, or drifting on X?
   Name the evidence (reward-gate verdicts, recurring user corrections, open questionnaire
   gaps, tasks running long/opaque). A code-only "looks fine" is blind to dispatcher drift.
5. **Any recurring user correction or shortcoming to convert into a `questionnaire.md`
   question** (or prune a stale one)? — feed the living questionnaire.

If any check fails, act on it (run the ritual / build the test / route through the loop)
before continuing the task.

## Run log (append-only; newest last)

<!-- format: YYYY-MM-DD HH:MM | observe:<last> reflect:<last> | reward-state: <one line> | note -->
*(empty at install — the project's dispatcher appends a line each watchdog run)*
