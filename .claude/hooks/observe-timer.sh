#!/usr/bin/env bash
# UserPromptSubmit hook: ~hourly nudge to run the read-only /observe harvest while
# actively coding. Fires at most once/hour, and only on real prompts — so idle time
# doesn't count (~active coding). It only SUGGESTS /observe; it changes nothing.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
state="$root/.claude/.observe-timer"
now=$(date +%s)
interval=3600
if [ ! -f "$state" ]; then echo "$now" > "$state"; exit 0; fi
last=$(cat "$state" 2>/dev/null || echo "$now")
case "$last" in ''|*[!0-9]*) last=$now;; esac
if [ $(( now - last )) -ge "$interval" ]; then
  echo "[ccode-toolkit] ~1h of active coding since the last reward harvest. Run /observe (read-only) to refresh the learning signal, then continue. Adapting the framework stays your call (/reflect)."
  echo "$now" > "$state"
fi
exit 0
