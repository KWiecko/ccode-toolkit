---
description: Run the human-in-the-loop development loop for a change — plan, build, black-box test, evidence-based verdict, commit.
---

Feature request: $ARGUMENTS

1. Clarify intent. If the request is ambiguous in a way that changes the result, ask (AskUserQuestion) before building. Propose the success criteria; the human owns them.
2. Plan briefly — skip if you could describe the diff in one sentence. For multi-file or unfamiliar work, write a short plan first.
3. Dispatch the worker (cheapest recipe that fits — see `.claude/memory/dispatch.md`) to implement. It returns a handoff doc.
4. Verify as a diverse ensemble, on REPRODUCIBLE evidence:
   - black-box tester (handoff + spec + real data),
   - reviewer (correctness / requirement gaps),
   - the human protein tester — bring them in for the verdict, sparingly.
   Evidence > vote: a demonstrated fact outweighs opinions.
5. On fail: hand the worker the review; it fixes the root cause and re-verifies. Cap at 3 rounds; if the same failures recur (oscillation), stop and escalate to the human.
6. On accept: commit with a clear message.
7. If this run changed any *means* (doctrine, dispatch heuristic, a prompt), append a decision line to `.claude/memory/decisions.jsonl`. Never edit `.claude/memory/reward/**`.

Argument contract: reproducible evidence wins; honest hypotheses are free; rhetoric is penalized; fabricated evidence is penalized hardest.
