---
description: Read-only investigation — confront a request (or plan) with the reality of the existing code before building. Surfaces wrong assumptions, mismatches, and whether the premise even holds.
---

Investigate, don't build — confront the request against the actual code/system: $ARGUMENTS

This is Directive 1's failsafes given teeth, grounded in REALITY (the code), not just the prompt. Use **plan mode / the Explore agent** for the read-only reading — don't reinvent investigation; `/sanity-check` only adds the skeptical premise-challenge framing and the go/refine/stop verdict that aren't native. Read the relevant code, entry points, callers, and data; **parallelize the reads** (read-only investigation fans out freely — see `dispatch.md`), then aggregate.

Check:
1. **Does the premise hold?** Is the request's assumption actually true in the code — does the target behave the way the request describes? Does what's asked already exist, partially exist, or conflict with what's there? (Directive 1.3 — catch hallucinated assumptions before they cost a build.)
2. **Right approach?** Is the prompted way the goto, or is there a simpler one (Directive 1.1 / 1.2)? For a non-trivial domain, scan prior-art (Directive 1.7).
3. **Real usage (Directive 3):** how is the target actually used — real entry points, callers, data? Does the request fit that reality?
4. **Forks:** name the ambiguities that would change the result.

Output a grounded **request-vs-reality** report: every finding cites real code (`file:line` / a real input→output), never assertion; label honest hypotheses "unverified" (rhetoric is penalized; fabricated evidence worst). End with a verdict — **go** (premise holds, approach sound) · **refine** (the mismatch to resolve first) · **stop** (premise is wrong — here's the evidence). Apply nothing; this only investigates.
