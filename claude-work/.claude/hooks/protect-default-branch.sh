#!/usr/bin/env bash
# PreToolUse hook (Bash matcher): guard git commit/push on protected branches
# and surface force-pushes for explicit confirmation.
#
# Dave's history is full of "don't forget to be on the right branch", "no
# don't commit! undo that!", and "do not force push". This hook does not block
# normal feature-branch work; it only escalates to an explicit permission
# prompt ("ask") when:
#   1. a `git commit` or `git push` runs while the working directory is on
#      develop, main, or master, or
#   2. any `git push` uses --force / --force-with-lease / -f.
#
# "ask" (not "deny") because both actions are occasionally legitimate: Dave
# rebases feature branches (force-push-with-lease updates the PR), and rare
# direct pushes to develop happen deliberately. The prompt makes them a
# conscious choice instead of a silent default.

set -euo pipefail

input=$(cat)
tool=$(printf '%s' "$input" | jq -r '.tool_name // ""')
[ "$tool" = "Bash" ] || exit 0

command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
cwd=$(printf '%s' "$input" | jq -r '.cwd // ""')

ask() {
  jq -cn --arg reason "$1" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $reason}}'
  exit 0
}

# Only care about actual git commit/push invocations.
if ! printf '%s' "$command" | grep -qE '(^|[;&|]|&&|\|\|)[[:space:]]*git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+(commit|push)\b'; then
  exit 0
fi

# Force-push always requires confirmation, regardless of branch.
if printf '%s' "$command" | grep -qE '\bgit\b[^;&|]*\bpush\b[^;&|]*([[:space:]]-f\b|--force(-with-lease|-if-includes)?\b)'; then
  ask "This command force-pushes. Confirm the remote branch is yours to overwrite (rebased feature branch: usually fine; shared branch: stop)."
fi

# Resolve the repo the command targets: honor `git -C <path>`, else hook cwd.
repo_dir="$cwd"
c_path=$(printf '%s' "$command" | grep -oE '\bgit[[:space:]]+-C[[:space:]]+[^[:space:]]+' | head -1 | awk '{print $3}' || true)
[ -n "$c_path" ] && repo_dir="$c_path"

branch=$(git -C "$repo_dir" branch --show-current 2>/dev/null || true)
case "$branch" in
  develop | main | master)
    ask "You are on '$branch', a protected branch. Committing or pushing here is almost never intended — create a feature branch first, or confirm this is deliberate."
    ;;
esac

exit 0
