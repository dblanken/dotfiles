# Claude Code mode-switching functions (Linux only)
# Requires llama-server running on port 8001 for claude-local.

claude-local() {
  cp ~/.claude/settings.local.json ~/.claude/settings.json
  export ANTHROPIC_BASE_URL="http://localhost:8001"
  export ANTHROPIC_API_KEY="sk-no-key-required"
  claude "$@"
}

claude-paid() {
  cp ~/.claude/settings.paid.json ~/.claude/settings.json
  unset ANTHROPIC_BASE_URL
  unset ANTHROPIC_API_KEY
  claude "$@"
}
