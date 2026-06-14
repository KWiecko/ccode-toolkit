# Dispatch heuristics (means — adapt freely via /reflect)

Task type → recipe. Pick the cheapest that fits. Refined over time from `decisions.jsonl`.

- one-sentence diff / typo / rename → main loop does it directly; no subagents; cheapest tier.
- standard change / feature → plan briefly → worker → black-box tester + reviewer.
- mechanical sweep across many files → `claude -p` fan-out, scoped `--allowedTools`, capped; test the prompt on 2–3 files first.
- novel / off-distribution / architectural / security-critical → human-led; low autonomy; agent assists, human decides.

Notes:
- Default the worker to a strong cheap tool-caller (sonnet-class); reserve a stronger or different model for review (decorrelation) and hard debugging.
- Escalate the lever before re-wording: prompt → different model → split the step. Don't reach for a bigger model first.
