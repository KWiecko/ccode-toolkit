---
description: Run the human-in-the-loop development loop — plan, build, questionnaire, evidence + delta verdict, commit.
---

Feature request: $ARGUMENTS

1. Clarify intent. If the request is ambiguous in a way that changes the result, ask (AskUserQuestion) first. Propose the success criteria; the human owns them.
2. **Real-usage first** (before building, per Directive 3): understand how the change will actually be used and pin the **real-usage check** that defines done — real data / real entry points, reproducible by the human. This is the per-task reward; the human owns it; the worker builds *toward* it, never authors it to fit the code. Scale to the task (a one-sentence diff's usage is obvious; a feature earns a real-usage harness). Plan briefly here if multi-file or unfamiliar.
3. Dispatch the worker (cheapest recipe that fits — `.claude/memory/dispatch.md`). It builds and fills the **done-questionnaire** (see worker.md), every claim backed by reproducible evidence.
4. Verify as a diverse ensemble:
   - **tester** — black-box, real data → reproducible **evidence**;
   - **reviewer** — answers the *same* questionnaire **blind** (dispatch it without the worker's answers, so it doesn't anchor);
   - **observer** — scores: the worker↔reviewer **delta-digest** (divergences + agreed-open-risks + evidence pointers) + an evidence-grounded assessment. It *prepares*; it does not decide (aimer ≠ scorer).
   - **human** — the uncorrelated voter, brought in for the verdict, sparingly.
5. Decide on the digest + REPRODUCIBLE evidence (evidence > vote):
   - **big delta** → not done; iterate the *contested* items.
   - **small delta** → still require the tester's evidence + a human vote — **agreement is not evidence**; treat too-easy agreement on something novel as a reason to verify harder, not to pass.
6. On fail: carry the delta-digest forward so the worker focuses the disputed items. Cap 3 rounds; on oscillation (the same divergences recur), stop and escalate to the human with the digest.
7. On accept: commit.
8. If this run changed any *means* (a CLAUDE.md note, a dispatch heuristic, an agent prompt), append a decision to `.claude/memory/decisions.jsonl`. Never edit `.claude/memory/reward/**`.

Argument contract: reproducible evidence wins; honest hypotheses are free; rhetoric is penalized; fabricated evidence is penalized hardest.

Same loop serves an investigation or bug fix — just state the completion condition.
