#!/usr/bin/env bash
# SessionStart hook: inject model-specific operating notes.
#
# Reads the hook JSON on stdin, matches the active model against note files in
# ~/.claude/model-notes/ (sonnet.md, opus.md, haiku.md, ...), and prints the
# matching file to stdout, which Claude Code adds to the session context.
#
# Fable sessions get nothing extra by design: ~/.claude/fable.md is already
# loaded for every model via CLAUDE.md, and these notes are per-model deltas.
#
# The `model` field is not guaranteed to be present (e.g. after /clear or a
# session restore). When it is missing we inject nothing rather than guess
# from the settings.json default, which may not match the running model.

set -euo pipefail

input=$(cat)
model=$(printf '%s' "$input" | jq -r '.model // ""')
[ -n "$model" ] || exit 0

notes_dir="$HOME/.claude/model-notes"
for family in sonnet opus haiku; do
  if [[ "$model" == *"$family"* ]] && [ -f "$notes_dir/$family.md" ]; then
    cat "$notes_dir/$family.md"
    break
  fi
done

exit 0
