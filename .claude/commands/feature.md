---
description: Run the human-in-the-loop development loop — align, build, questionnaire, evidence + delta verdict, commit.
---

Feature request: $ARGUMENTS

1. **Alignment phase — tighten the metalanguage before dispatching (dispatcher-led, observer-assisted).** Not a literal negotiation; the point is to make the shared understanding *tight* at every level, so there's nothing ambiguous to diverge on later. *(If the premise is shaky or leans on existing/unfamiliar code, run `/sanity-check` first — read-only request-vs-reality — and fold its findings into this alignment.)*
   a. **Dispatcher** presents the anticipated work as a **diagram + short summary** (Directive 1.4): scope, the terms/vocabulary, what "done" means.
   b. **Observer assists** (no priors, read-only): flags where the metalanguage is still loose or ambiguous, and **sketches the E2E real-usage test flow** (Directive 3 — how the change will actually be used and checked). That sketch becomes the per-task check the worker builds toward and the observer later scores against. It proposes; it does not decide.
   c. **Go / no-go:** dispatch only once the metalanguage is tight AND the E2E real-usage flow is sketched. If still loose, keep tightening or ask the human on genuine forks (AskUserQuestion). Scale to the task — a one-sentence diff skips this.
   The agreed, tight understanding + E2E flow is the **Query** everything downstream is scored against; the human owns "done".
2. Dispatch the worker (cheapest recipe that fits — `.claude/memory/dispatch.md`). It builds *toward* the E2E real-usage check and fills the **living done-questionnaire** (`.claude/memory/questionnaire.md` — the observer keeps it adapted to this project's recurring shortcomings, incl. ones the user keeps raising), every claim backed by reproducible evidence.
3. Verify as a diverse ensemble (tester + reviewer run in **parallel** — both read-only, independent votes):
   - **tester** — runs the E2E flow black-box on real data → reproducible **evidence**;
   - **reviewer** — answers the *same* questionnaire **blind** (dispatch it without the worker's answers, so it doesn't anchor);
   - **observer** — scores against the Query: the worker↔reviewer **delta-digest** (divergences + agreed-open-risks + evidence pointers) + an evidence-grounded assessment. It *prepares*; it does not decide (aimer ≠ scorer).
   - **human** — the uncorrelated voter, brought in for the verdict, sparingly.
4. Decide on the digest + REPRODUCIBLE evidence (evidence > vote):
   - **big delta** → not done; iterate the *contested* items.
   - **small delta** → still require the tester's evidence + a human vote — **agreement is not evidence**; treat too-easy agreement on something novel as a reason to verify harder, not to pass.
5. On fail: carry the delta-digest forward so the worker focuses the disputed items. Cap 3 rounds; on oscillation (the same divergences recur), stop and escalate to the human with the digest.
6. On accept: commit.
7. If this run changed any *means* (a CLAUDE.md note, a dispatch heuristic, an agent prompt), append a decision to `.claude/memory/decisions.jsonl`. Never edit `.claude/memory/reward/**`.

Argument contract: reproducible evidence wins; honest hypotheses are free; rhetoric is penalized; fabricated evidence is penalized hardest.

Same loop serves an investigation or bug fix — just state the completion condition.
