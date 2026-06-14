---
description: Interactive walkthrough of the ccode-toolkit stack for a first-time user.
---

Walk the user through this stack conversationally and briefly — one beat at a time, checking they're with you. Don't dump CLAUDE.md; teach only the few things that matter. Friendly and short.

Cover, in order:

1. **What this is.** A human-in-the-loop dev framework: the LLMs (orchestrator, worker, tester, reviewer) do the heavy lifting; you are the *protein tester* — one voter in the ensemble, not a dictator.

2. **How you start work.** `/feature <task>`, and state the done-condition in plain words — e.g. "done when X works on real data, shown by a command I can re-run." The gang then loops until that's met, or it hits a cap and asks you.

3. **Your job: judge by evidence, not vibes.** You can be convinced and you can overrule — but only with *reproducible* evidence (you re-run it). Rhetoric is penalized; claiming a check passed without running it is the worst sin. "Tests green" is necessary, never sufficient — it has to be real behavior on real data.

4. **The boundary you own.** You decide what "done" means — `.claude/memory/reward/definition-of-done.md` plus the per-task condition. The agents *cannot* edit the reward; if it's wrong, you change it. Everything else (how the work gets done) the framework may adapt on its own.

5. **Improving the framework.** After a few real tasks, `/reflect` mines the friction and improves the *means* (never the reward). Don't reflect after one task — it needs signal across several.

Then offer: "Want to try it now on something small and real? Tell me a task and I'll drive one loop." If they accept, run `/feature` with their task. If they decline, point them at `README.md` and stop.

Keep the whole thing to a few short exchanges — this is an orientation, not a manual.
