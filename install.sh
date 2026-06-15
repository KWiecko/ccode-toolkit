#!/usr/bin/env bash
# ccode-toolkit installer — non-destructively merge the framework into an existing project.
#
#   Usage:  bash install.sh [target-dir]      (default: current directory)
#
# Idempotent and safe to re-run: it never overwrites your files. It merges
# settings.json (union permissions, concatenate hooks), copies non-colliding
# agents/commands/hooks, seeds fresh per-project memory, appends .gitignore lines,
# and appends the framework CLAUDE.md under a marker for you to reconcile.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$(cd "${1:-$PWD}" && pwd)"
[ "$SRC" = "$TARGET" ] && { echo "Refusing to install into the toolkit itself."; exit 1; }
[ -f "$SRC/.claude/settings.json" ] || { echo "Run this from the ccode-toolkit repo."; exit 1; }

echo "ccode-toolkit -> $TARGET"
mkdir -p "$TARGET/.claude/agents" "$TARGET/.claude/commands" "$TARGET/.claude/hooks" "$TARGET/.claude/memory/reward"

copied=(); skipped=()
copy_if_absent() { if [ -e "$TARGET/$1" ]; then skipped+=("$1"); else cp "$SRC/$1" "$TARGET/$1"; copied+=("$1"); fi; }

for f in "$SRC"/.claude/agents/*.md;   do copy_if_absent ".claude/agents/$(basename "$f")"; done
for f in "$SRC"/.claude/commands/*.md; do copy_if_absent ".claude/commands/$(basename "$f")"; done
for f in "$SRC"/.claude/hooks/*;       do [ -f "$f" ] && copy_if_absent ".claude/hooks/$(basename "$f")"; done
chmod +x "$TARGET"/.claude/hooks/*.sh 2>/dev/null || true

# memory: reward shape + dispatch (copy if absent) + a FRESH per-project decision log
copy_if_absent ".claude/memory/reward/definition-of-done.md"
copy_if_absent ".claude/memory/dispatch.md"
if [ ! -e "$TARGET/.claude/memory/decisions.jsonl" ]; then
  echo "{\"when\":\"$(date +%F)\",\"trajectory\":\"installed ccode-toolkit into this project\",\"action\":\"merged framework; fill reward/definition-of-done.md for this app\",\"commit\":\"install\",\"mode\":\"asked\"}" > "$TARGET/.claude/memory/decisions.jsonl"
  copied+=(".claude/memory/decisions.jsonl (fresh)")
else skipped+=(".claude/memory/decisions.jsonl"); fi

# settings.json: deep-merge (target wins structure; permissions unioned; hooks concatenated per event)
if [ -e "$TARGET/.claude/settings.json" ]; then
  if command -v jq >/dev/null 2>&1; then
    tmp="$(mktemp)"
    jq -s '
      .[0] as $a | .[1] as $b | ($a * $b)
      | .permissions.allow = ((($a.permissions.allow // []) + ($b.permissions.allow // [])) | unique)
      | .permissions.deny  = ((($a.permissions.deny  // []) + ($b.permissions.deny  // [])) | unique)
      | .hooks = ( ([ (($a.hooks // {})|keys[]), (($b.hooks // {})|keys[]) ] | flatten | unique)
                   | reduce .[] as $k ({}; .[$k] = (((($a.hooks)[$k]) // []) + ((($b.hooks)[$k]) // []))) )
    ' "$TARGET/.claude/settings.json" "$SRC/.claude/settings.json" > "$tmp" && mv "$tmp" "$TARGET/.claude/settings.json"
    copied+=(".claude/settings.json (merged)")
  else skipped+=(".claude/settings.json (install jq to merge; left as-is)"); fi
else cp "$SRC/.claude/settings.json" "$TARGET/.claude/settings.json"; copied+=(".claude/settings.json"); fi

# CLAUDE.md: copy if absent; else append under a marker for reconciliation
MARK="ccode-toolkit framework (merged)"
if [ -e "$TARGET/CLAUDE.md" ]; then
  if grep -qF "$MARK" "$TARGET/CLAUDE.md"; then skipped+=("CLAUDE.md (framework already present)")
  else { printf '\n<!-- ===== %s — reconcile/dedup overlaps with your sections above ===== -->\n\n' "$MARK"; cat "$SRC/CLAUDE.md"; } >> "$TARGET/CLAUDE.md"; copied+=("CLAUDE.md (appended under marker — reconcile)"); fi
else cp "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"; copied+=("CLAUDE.md"); fi

# .gitignore
touch "$TARGET/.gitignore"
for line in ".claude/settings.local.json" "CLAUDE.local.md" ".claude/.observe-timer"; do
  grep -qxF "$line" "$TARGET/.gitignore" 2>/dev/null || echo "$line" >> "$TARGET/.gitignore"
done

echo; echo "merged/copied:"
if [ ${#copied[@]} -gt 0 ]; then printf '  + %s\n' "${copied[@]}"; else echo "  (none)"; fi
echo "kept existing / collisions:"
if [ ${#skipped[@]} -gt 0 ]; then printf '  ~ %s\n' "${skipped[@]}"; else echo "  (none)"; fi
cat <<'NEXT'

next:
  1. fill .claude/memory/reward/definition-of-done.md for THIS app (the per-project reward)
  2. if CLAUDE.md was appended, reconcile/dedup the merged section with your own
  3. resolve any agent/command collisions above (yours were kept untouched)
  4. start a FRESH session, set the dispatcher to max: opus + /effort xhigh
NEXT
