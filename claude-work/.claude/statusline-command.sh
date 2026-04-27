#!/bin/bash

input=$(cat)

# Extract fields from JSON
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

# Local cost tracking (persistent across reboots)
cost_dir="$HOME/.claude/cost-tracking"
today=$(date +%Y-%m-%d)
mkdir -p "${cost_dir}/${today}"
# Write this session's current cost
if [ -n "$session_id" ]; then
  echo "$cost" > "${cost_dir}/${today}/${session_id}"
fi
# Sum today's sessions
daily_cost=$(awk '{ sum += $1 } END { printf "%.2f", sum }' "${cost_dir}/${today}/"* 2>/dev/null)
daily_cost_fmt=$(printf '$%s' "${daily_cost:-0.00}")
# Sum from most recent Sunday 12 AM UTC to today
weekly_cost=0
dow=$(date -u +%w)  # 0=Sunday, 1=Monday, ..., 6=Saturday
for i in $(seq 0 "$dow"); do
  day=$(date -v-${i}d +%Y-%m-%d 2>/dev/null || date -d "-${i} days" +%Y-%m-%d 2>/dev/null)
  if [ -d "${cost_dir}/${day}" ]; then
    day_sum=$(awk '{ sum += $1 } END { printf "%.2f", sum }' "${cost_dir}/${day}/"* 2>/dev/null)
    weekly_cost=$(awk "BEGIN { printf \"%.2f\", ${weekly_cost} + ${day_sum} }")
  fi
done
weekly_cost_fmt=$(printf '$%s' "$weekly_cost")
# Clean up dirs older than 7 days
find "$cost_dir" -mindepth 1 -maxdepth 1 -type d -name '????-??-??' | while read -r dir; do
  dname=$(basename "$dir")
  cutoff=$(date -v-8d +%Y-%m-%d 2>/dev/null || date -d "-8 days" +%Y-%m-%d 2>/dev/null)
  [ "$dname" \< "$cutoff" ] && rm -rf "$dir"
done

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
bar_width=10
filled=$(( (used_pct * bar_width + 50) / 100 ))
[ "$filled" -gt "$bar_width" ] && filled=$bar_width
empty=$((bar_width - filled))
bar=""
for ((i=0; i<filled; i++)); do bar="${bar}█"; done
for ((i=0; i<empty; i++)); do bar="${bar}░"; done

# Color and compact warning based on usage
ctx_warning=""
if [ "$used_pct" -ge 80 ]; then
  bar_color="\033[31m"   # red: near limit
  ctx_warning="  \033[31m⚠ compact or hand off\033[0m"
elif [ "$used_pct" -ge 60 ]; then
  bar_color="\033[33m"   # yellow: getting full
  ctx_warning="  \033[33m↯ consider compacting or handing off\033[0m"
else
  bar_color="\033[32m"   # green: plenty of space
fi

# Detect local Drupal site URL from .lando.local.yml
site_url=""
lando_file="${cwd}/.lando.local.yml"
if [ -f "$lando_file" ]; then
  site_url=$(grep 'DRUSH_OPTIONS_URI' "$lando_file" 2>/dev/null | head -1 | sed 's/.*DRUSH_OPTIONS_URI: *//; s/^"//; s/"$//' | tr -d '[:space:]')
fi

# Line 1: [Model]  📁 project  |  🌿 branch
line1="\033[33m[${model}]\033[0m  📁 ${project}"
if [ -n "$branch" ]; then
  line1="${line1}  |  🌿 ${branch}"
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

# Line 2: progress bar pct  |  S: $session  D: $day  W: $week  |  +/- lines  |  ⏱ duration
line2="${bar_color}${bar}\033[0m ${used_pct}%${ctx_warning}  |  S:${cost_fmt}  D:${daily_cost_fmt}  W:${weekly_cost_fmt}  |  ${lines_fmt}  |  ⏱  ${duration_fmt}${vim_fmt}"

# Output line 1 with optional clickable site link
if [ -n "$site_url" ]; then
  # OSC 8 format from docs: \e]8;;URL\a then TEXT then \e]8;;\a
  printf '%b\n' "${line1}  |  🔗 \e]8;;${site_url}\a${site_url}\e]8;;\a"
else
  printf '%b\n' "$line1"
fi
# Output line 2
printf '%b' "$line2"
