#!/usr/bin/env bash
# Claude Code Statusline
# 3-line display: session info, 5h usage, 7d usage

set -euo pipefail

input=$(cat)

# ── Debug log ──
# Uncomment to debug: tail -f /tmp/statusline-debug.log
# echo "$input" >> /tmp/statusline-debug.log

# ── Colors ──
GRAY="\033[38;2;74;88;92m"
RESET="\033[0m"

gradient_color() {
  local pct=$1
  local r g b
  if (( pct < 50 )); then
    r=$(( pct * 51 / 10 ))
    g=200; b=80
  else
    g=$(( 200 - (pct - 50) * 4 ))
    if (( g < 0 )); then g=0; fi
    r=255; b=60
  fi
  printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b"
}

block_char() {
  case $1 in
    0) printf ' ' ;; 1) printf '▏' ;; 2) printf '▎' ;;
    3) printf '▍' ;; 4) printf '▌' ;; 5) printf '▋' ;;
    6) printf '▊' ;; 7) printf '▉' ;; *) printf '█' ;;
  esac
}

# ── Progress bar (10 segments, fine-grained) ──
# Usage: progress_bar <pct> <color_escape>
progress_bar() {
  local pct=$1
  local color=$2
  local width=10
  local full frac
  read -r full frac < <(awk -v pct="$pct" -v w="$width" 'BEGIN {
    filled = pct * w / 100
    full = int(filled)
    frac = int((filled - full) * 8)
    print full, frac
  }')
  local bar="${color}"
  for ((i=0; i<full; i++)); do bar+="█"; done
  bar+=$(block_char "$frac")
  bar+="${RESET}"
  if (( full < width )); then
    local empty=$(( width - full - 1 ))
    for ((i=0; i<empty; i++)); do bar+="░"; done
  fi
  printf '%s' "$bar"
}

# ── Line 1: Session info ──
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')

# Context percentage (integer)
ctx_int=0
if [ -n "$used_pct" ]; then
  printf -v ctx_int "%.0f" "$used_pct" 2>/dev/null || ctx_int="${used_pct%%.*}"
fi
ctx_color=$(gradient_color "$ctx_int")
ctx_bar=$(progress_bar "$ctx_int" "$ctx_color")
printf -v ctx_pct "%3d" "$ctx_int"

# Git branch
git_branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

sep="${GRAY} │ ${RESET}"
line1="${ctx_color}📊 ctx${RESET} ${ctx_bar} ${ctx_color}${ctx_pct}%${RESET}"
if [ -n "$git_branch" ]; then
  line1+="${sep}🔀 ${git_branch}"
fi
line1+="${sep}🤖 ${model}"

# ── Rate limits from stdin ──
line2=""
line3=""

five_util=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty' 2>/dev/null)
seven_util=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty' 2>/dev/null)

# Format reset time for 5h window: "Resets 5pm (Asia/Tokyo)"
format_5h_reset() {
  local epoch=$1
  [ -z "$epoch" ] && return
  TZ="Asia/Tokyo" /bin/date -r "$epoch" +"(until %m/%d %H:%M)" 2>/dev/null
}

# Format reset time for 7d window: "Resets Mar 6 at 12pm (Asia/Tokyo)"
format_7d_reset() {
  local epoch=$1
  [ -z "$epoch" ] && return
  TZ="Asia/Tokyo" /bin/date -r "$epoch" +"(until %m/%d %H:%M)" 2>/dev/null
}

if [ -n "$five_util" ]; then
  # ── Subscription mode: 5h/7d rate limit bars ──
  printf -v five_int "%.0f" "$five_util" 2>/dev/null || five_int="${five_util%%.*}"
  five_color=$(gradient_color "$five_int")
  five_bar=$(progress_bar "$five_int" "$five_color")
  printf -v five_pct "%3d" "$five_int"
  line2="${five_color}⏰ 5h ${RESET} ${five_bar} ${five_color}${five_pct}%${RESET}"
  if [ -n "$five_reset" ]; then
    five_reset_str=$(format_5h_reset "$five_reset")
    [ -n "$five_reset_str" ] && line2+=" ${GRAY}${five_reset_str}${RESET}"
  fi

  if [ -n "$seven_util" ]; then
    printf -v seven_int "%.0f" "$seven_util" 2>/dev/null || seven_int="${seven_util%%.*}"
    seven_color=$(gradient_color "$seven_int")
    seven_bar=$(progress_bar "$seven_int" "$seven_color")
    printf -v seven_pct "%3d" "$seven_int"
    line3="${seven_color}📅 7d ${RESET} ${seven_bar} ${seven_color}${seven_pct}%${RESET}"
    if [ -n "$seven_reset" ]; then
      seven_reset_str=$(format_7d_reset "$seven_reset")
      [ -n "$seven_reset_str" ] && line3+=" ${GRAY}${seven_reset_str}${RESET}"
    fi
  fi
fi

# ── Session cost ──
line4=""
session_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty' 2>/dev/null)
if [ -n "$session_cost" ] && awk -v c="$session_cost" 'BEGIN { exit !(c+0 != 0) }'; then
  cost_fmt=$(awk -v c="$session_cost" 'BEGIN { printf "$%.4f", c }')
  line4="${GRAY}💰 Session${RESET} ${cost_fmt}"
fi

# ── Output ──
output="$line1"
if [ -n "$line2" ]; then output+=$'\n'"$line2"; fi
if [ -n "$line3" ]; then output+=$'\n'"$line3"; fi
if [ -n "$line4" ]; then output+=$'\n'"$line4"; fi
printf '%b' "$output"
