#!/bin/bash
#
# Claude Code status line — dual mode.
#
#   * Subscription (Pro/Max) sessions: shows session (5h) and weekly (7d) usage %,
#     color-coded green/yellow/red, with reset times.
#   * API key / gateway (e.g. Portkey) sessions: shows dollar cost per
#     session / day / week, tracked locally under COST_DIR.
#
# The mode is detected automatically from the JSON Claude Code pipes in: it only
# includes a "rate_limits" object on subscription sessions.
#
# Requirements: bash, jq. git and a POSIX `date` are used when available.
# Cross-platform: works with both BSD (macOS) and GNU (Linux) `date`.
#
# ── Customizing ───────────────────────────────────────────────────────────────
# Edit the CONFIG block below, or — to keep your changes when the script is
# updated — create an override file and set any of the variables/functions there:
#
#     ~/.claude/statusline.conf      (or point $CLAUDE_STATUSLINE_CONFIG at one)
#
# That file is sourced AFTER the defaults, so anything you set wins. Example:
#
#     THRESHOLD_YELLOW=50
#     ICON_PROJECT="dir:"
#     detect_site_url() { :; }   # disable the clickable site link entirely
#

input=$(cat)

# Degrade gracefully if jq is missing rather than spewing errors into the prompt.
if ! command -v jq >/dev/null 2>&1; then
  printf 'statusline: jq not found — install jq to enable the status line'
  exit 0
fi

# ── CONFIG (defaults) ──────────────────────────────────────────────────────────
# Usage/context color thresholds, in percent.
THRESHOLD_YELLOW=60          # >= this -> yellow (getting full)
THRESHOLD_RED=80             # >= this -> red (near limit, take a break)

# Context progress bar width, in characters.
BAR_WIDTH=10

# Where API-mode dollar cost is tracked (daily/weekly rollups, persistent).
COST_DIR="$HOME/.claude/cost-tracking"

# Set to 0 to never show the clickable local-site link on line 1.
SHOW_SITE_URL=1

# Glyphs. Replace with plain ASCII if your terminal/font lacks emoji support.
ICON_PROJECT="📁"
ICON_BRANCH="🌿"
ICON_DURATION="⏱"
ICON_LINK="🔗"
ICON_RESET="↻"

# ── Overridable functions ───────────────────────────────────────────────────────

# Format a Unix epoch with a date(1) format string, on BSD (macOS) or GNU (Linux).
fmt_epoch() {  # $1 = epoch seconds, $2 = strftime format
  date -r "$1" +"$2" 2>/dev/null || date -d "@$1" +"$2" 2>/dev/null
}

# Format a reset time: clock time if it's today, weekday + hour otherwise.
fmt_reset() {  # $1 = epoch seconds
  [ -z "$1" ] && return
  if [ "$(date +%Y-%m-%d)" = "$(fmt_epoch "$1" %Y-%m-%d)" ]; then
    fmt_epoch "$1" "%-I:%M%p"        # e.g. 3:00PM
  else
    fmt_epoch "$1" "%a %-I%p"        # e.g. Tue 8AM
  fi
}

# ANSI color for a usage percentage, by the thresholds above.
usage_color() {  # $1 = percent
  if [ "$1" -ge "$THRESHOLD_RED" ]; then
    echo '\033[31m'                  # red
  elif [ "$1" -ge "$THRESHOLD_YELLOW" ]; then
    echo '\033[33m'                  # yellow
  else
    echo '\033[32m'                  # green
  fi
}

# One labeled usage part: colored "Label NN%" plus a reset time if known.
usage_part() {  # $1 = label, $2 = percent, $3 = reset epoch
  local reset_fmt suffix=""
  reset_fmt=$(fmt_reset "$3")
  [ -n "$reset_fmt" ] && suffix=" ${ICON_RESET}${reset_fmt}"
  echo "$(usage_color "$2")${1} ${2}%\033[0m${suffix}"
}

# Detect a local site URL to show as a clickable link on line 1. Echo a URL or
# nothing. Default supports Lando/Drupal (.lando.local.yml); override for your
# own local-dev setup, or define as a no-op to disable.
detect_site_url() {  # $1 = current working dir
  local lando_file="${1}/.lando.local.yml"
  [ -f "$lando_file" ] || return
  grep 'DRUSH_OPTIONS_URI' "$lando_file" 2>/dev/null | head -1 \
    | sed 's/.*DRUSH_OPTIONS_URI: *//; s/^"//; s/"$//' | tr -d '[:space:]'
}

# ── User overrides (sourced last so they win) ────────────────────────────────────
_cfg="${CLAUDE_STATUSLINE_CONFIG:-$HOME/.claude/statusline.conf}"
[ -f "$_cfg" ] && source "$_cfg"

# ── Extract fields from the JSON input ───────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | round')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100 | round')
session_id=$(echo "$input" | jq -r '.session_id // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
# vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Auth mode: Claude Code only sends rate_limits on subscription (Pro/Max) sessions.
# Its presence -> subscription view; absence -> API/Portkey cost view.
sub_mode=$(echo "$input" | jq -r 'has("rate_limits")')
if [ "$sub_mode" = "true" ]; then
  sess_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0 | round')
  sess_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
  week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0 | round')
  week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
fi

# Project name (basename of project dir)
project=$(basename "$cwd" 2>/dev/null)

# Git branch
branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

  # Git status indicators
  status_dots=""
  if ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
    status_dots="${status_dots}\033[32m●\033[0m"
  fi
  if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null; then
    status_dots="${status_dots}\033[31m●\033[0m"
  fi
  if [ -n "$(git -C "$cwd" --no-optional-locks ls-files --exclude-standard --others 2>/dev/null | head -1)" ]; then
    status_dots="${status_dots}\033[34m●\033[0m"
  fi
fi

# Local cost tracking (persistent across reboots) — API/Portkey mode only.
# Skipped on subscription sessions, where dollar cost is meaningless.
if [ "$sub_mode" != "true" ]; then
  today=$(date +%Y-%m-%d)
  mkdir -p "${COST_DIR}/${today}"
  # Write this session's current cost
  if [ -n "$session_id" ]; then
    echo "$cost" > "${COST_DIR}/${today}/${session_id}"
  fi
  # Sum today's sessions
  daily_cost=$(awk '{ sum += $1 } END { printf "%.2f", sum }' "${COST_DIR}/${today}/"* 2>/dev/null)
  daily_cost_fmt=$(printf '$%s' "${daily_cost:-0.00}")
  # Sum from most recent Sunday 12 AM UTC to today
  weekly_cost=0
  dow=$(date -u +%w)  # 0=Sunday, 1=Monday, ..., 6=Saturday
  for i in $(seq 0 "$dow"); do
    day=$(date -v-${i}d +%Y-%m-%d 2>/dev/null || date -d "-${i} days" +%Y-%m-%d 2>/dev/null)
    if [ -d "${COST_DIR}/${day}" ]; then
      day_sum=$(awk '{ sum += $1 } END { printf "%.2f", sum }' "${COST_DIR}/${day}/"* 2>/dev/null)
      weekly_cost=$(awk "BEGIN { printf \"%.2f\", ${weekly_cost} + ${day_sum} }")
    fi
  done
  weekly_cost_fmt=$(printf '$%s' "$weekly_cost")
  # Clean up dirs older than 7 days
  find "$COST_DIR" -mindepth 1 -maxdepth 1 -type d -name '????-??-??' | while read -r dir; do
    dname=$(basename "$dir")
    cutoff=$(date -v-8d +%Y-%m-%d 2>/dev/null || date -d "-8 days" +%Y-%m-%d 2>/dev/null)
    [ "$dname" \< "$cutoff" ] && rm -rf "$dir"
  done
fi

# Format session cost
cost_fmt=$(printf '$%.2f' "$cost")

# Format duration (ms to Xm Ys)
total_secs=$((duration_ms / 1000))
mins=$((total_secs / 60))
secs=$((total_secs % 60))
if [ "$mins" -gt 0 ]; then
  duration_fmt="${mins}m ${secs}s"
else
  duration_fmt="${secs}s"
fi

# Progress bar grows as context fills (raw used percentage)
filled=$(( (used_pct * BAR_WIDTH + 50) / 100 ))
[ "$filled" -gt "$BAR_WIDTH" ] && filled=$BAR_WIDTH
empty=$((BAR_WIDTH - filled))
bar=""
for ((i=0; i<filled; i++)); do bar="${bar}█"; done
for ((i=0; i<empty; i++)); do bar="${bar}░"; done

# Color and compact warning based on usage
ctx_warning=""
if [ "$used_pct" -ge "$THRESHOLD_RED" ]; then
  bar_color="\033[31m"   # red: near limit
  ctx_warning="  \033[31m⚠ compact or hand off\033[0m"
elif [ "$used_pct" -ge "$THRESHOLD_YELLOW" ]; then
  bar_color="\033[33m"   # yellow: getting full
  ctx_warning="  \033[33m↯ consider compacting or handing off\033[0m"
else
  bar_color="\033[32m"   # green: plenty of space
fi

# Detect a local site URL for the clickable link (feature-toggled)
site_url=""
[ "$SHOW_SITE_URL" = "1" ] && site_url=$(detect_site_url "$cwd")

# Line 1: [Model]  📁 project  |  🌿 branch
line1="\033[33m[${model}]\033[0m  ${ICON_PROJECT} ${project}"
if [ -n "$branch" ]; then
  line1="${line1}  |  ${ICON_BRANCH} ${branch}"
  [ -n "$status_dots" ] && line1="${line1} ${status_dots}"
fi

# Lines changed
lines_fmt="\033[32m+${lines_added}\033[0m \033[31m-${lines_removed}\033[0m"

# Vim mode indicator (only shown when vim mode is enabled)
# vim_fmt=""
# if [ -n "$vim_mode" ]; then
#   if [ "$vim_mode" = "NORMAL" ]; then
#     vim_fmt="  \033[36m[N]\033[0m"
#   else
#     vim_fmt="  \033[32m[I]\033[0m"
#   fi
# fi

# Usage segment differs by auth mode
if [ "$sub_mode" = "true" ]; then
  # Subscription: session (5h) and weekly (7d) usage %, color-coded green/yellow/red
  # by how close each window is to its limit. Each window is shown only if present
  # in the data (a missing weekly limit is omitted entirely).
  usage_segment=""
  if [ "$(echo "$input" | jq -r '.rate_limits | has("five_hour")')" = "true" ]; then
    usage_segment="$(usage_part Sess "$sess_pct" "$sess_reset")"
  fi
  if [ "$(echo "$input" | jq -r '.rate_limits | has("seven_day")')" = "true" ]; then
    usage_segment="${usage_segment:+${usage_segment}  }$(usage_part Wk "$week_pct" "$week_reset")"
  fi
else
  # API/Portkey: dollar cost per session / day / week
  usage_segment="S:${cost_fmt}  D:${daily_cost_fmt}  W:${weekly_cost_fmt}"
fi

# Line 2: progress bar pct  |  usage segment  |  +/- lines  |  ⏱ duration
line2="${bar_color}${bar}\033[0m ${used_pct}%${ctx_warning}  |  ${usage_segment}  |  ${lines_fmt}  |  ${ICON_DURATION}  ${duration_fmt}${vim_fmt}"

# Output line 1 with optional clickable site link
if [ -n "$site_url" ]; then
  # OSC 8 format from docs: \e]8;;URL\a then TEXT then \e]8;;\a
  printf '%b\n' "${line1}  |  ${ICON_LINK} \e]8;;${site_url}\a${site_url}\e]8;;\a"
else
  printf '%b\n' "$line1"
fi
# Output line 2
printf '%b' "$line2"
