# Done-questionnaire — LIVING, observer-compiled, project-adapted

**This is not a fixed checklist.** It is the current self-interrogation prompt the **worker**
answers itself at hand-off and the **reviewer** answers **blind**. The **observer owns its
evolution**: each periodic harvest it mines three sources for *recurring shortcomings* —
worker+reviewer answers, `decisions.jsonl` outcomes, and **the USER's prompts/corrections**
(a thing the human keeps raising IS the loudest shortcoming) — and **converts each into a
sharp question** that, self-answered next time, steers the build away from repeating it.

It correlates two streams **bidirectionally**: the dispatcher's own track record (robust,
primary behavioral signal) and the user's sentiment (weak, corroborating only). A thing that
*recurs* and keeps drawing corrections → **add/sharpen** a question; a thing done
consistently with sustained positive/neutral response and no recurrence → **don't add, and
prune** the stale one. Sentiment only tunes *which questions to keep* — it is **never the
work's reward** (chasing it breeds sycophancy; the build is scored on behavioral evidence).

So the interrogation slowly **adapts to this project/setup** and becomes the self-improvement
signal (LLMs act on prompts). The observer *proposes* edits (it has no write tools); the
dispatcher writes this file. Scale to the task — a one-sentence diff skips this.

---

## Baseline (seed — every non-trivial task; the project's observer grows/prunes from here)

- **Feature** — the request, verbatim.
- **Built** — files changed, observable behavior, how to exercise with real data.
- **Did you run a live test? (Directive 3) — MANDATORY human-simulated env, not a state-check.**
  Show you drove the **real binary in a PTY**, fed it real input (add an inject seam if it's
  device-driven), and **asserted on the RENDERED SCREEN via an external emulator** (`pyte` /
  `tmux capture-pane` / `script`) — paste the captured frame. An object/widget-state check
  (`run_test().active`, `.lines`) does NOT count. Plus the **human live smoke** before "done."
  Long-running → exercise **past the limits / over time**.
- **Why does this work?** — the mechanism + reproducible evidence (command → output).
- **Which edge cases did you cover? Which did you *not*?**
- **Did you intentionally skip any code path / case — and why?**
- **What was most ambiguous, and how did you resolve it?**
- **How did you debug?** — what broke, how you diagnosed it.
- **Which tools/approaches seemed *good* for this task? Which *bad*?** (meta-learning — the
  observer harvests these to learn what fits this setup).
- **Requirements** — each → met? + evidence. No blanket "all met".
- **Weak spots / open / unverified** — labelled honestly; under-reporting here is the failure.

## Project-adapted (observer-compiled from THIS project's tracked shortcomings)

> Empty at install. The project's observer fills + prunes this from recurring worker/reviewer
> shortcomings and the user's recurring corrections — each entry citing the shortcoming it
> targets. This is where the questionnaire becomes specific to the project's failure modes.

*(none yet — the observer grows this)*
