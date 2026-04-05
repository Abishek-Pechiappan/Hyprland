#!/bin/bash

# --- Configuration ---
TARGET_DATE="2026-06-21 00:00:00"
RESOLUTION="1920x1080" # Ensure this matches your monitor
MAX_DAYS=100           # What the "Days" ring considers 100% full
# ---------------------

TARGET_EPOCH=$(date -d "$TARGET_DATE" +%s)

# Ensure swww daemon is running
awww query >/dev/null 2>&1 || awww-daemon &
sleep 1

FIRST_RUN=true

while true; do
  NOW=$(date +%s)

  # Pre-render logic: calculate for RIGHT NOW on first run, otherwise for NEXT minute
  if [ "$FIRST_RUN" = true ]; then
    TARGET_CALC=$NOW
  else
    TARGET_CALC=$(((NOW / 60 + 1) * 60))
  fi

  DIFF=$((TARGET_EPOCH - TARGET_CALC))

  if [ "$DIFF" -le 0 ]; then
    DAYS=0
    HOURS=0
    MINS=0
    DAY_END=-90
    HOUR_END=-90
    MIN_END=-90
  else
    # Calculate time values
    DAYS=$((DIFF / 86400))
    HOURS=$(((DIFF % 86400) / 3600))
    MINS=$(((DIFF % 3600) / 60))

    # Calculate arc angles
    DAY_PCT=$((DAYS > MAX_DAYS ? MAX_DAYS : DAYS))

    DAY_END=$(awk "BEGIN {printf \"%.2f\", -90 + ($DAY_PCT / $MAX_DAYS) * 360}")
    HOUR_END=$(awk "BEGIN {printf \"%.2f\", -90 + ($HOURS / 24) * 360}")
    MIN_END=$(awk "BEGIN {printf \"%.2f\", -90 + ($MINS / 60) * 360}")
  fi

  WALL_PATH="/tmp/cyber_rings_glow.png"

  magick -size "$RESOLUTION" xc:"#050708" \
    -gravity center -font "JetBrainsMono-NF-ExtraLight-Italic" \
    \
    `# --- 1. RING TRACKS (dim, per-color tint) ---` \
    -fill none -stroke "#0a1a0f" -strokewidth 12 \
    -draw "arc 410,490 710,790 0 360" \
    -stroke "#071520" \
    -draw "arc 810,490 1110,790 0 360" \
    -stroke "#0d0a1a" \
    -draw "arc 1210,490 1510,790 0 360" \
    \
    `# --- 2. COLORED RING ARCS (green / cyan / purple) ---` \
    -stroke "#00ff9c" -strokewidth 12 \
    -draw "arc 410,490 710,790 -90 $DAY_END" \
    -stroke "#00bcd4" \
    -draw "arc 810,490 1110,790 -90 $HOUR_END" \
    -stroke "#8b5cf6" \
    -draw "arc 1210,490 1510,790 -90 $MIN_END" \
    \
    `# --- 3. TEXT AMBIENT HALO ---` \
    -fill "#003320" -stroke "#003320" -strokewidth 20 \
    -pointsize 160 -annotate +0-350 "FULL RESET" \
    -pointsize 120 -annotate -400+80 "$DAYS" -annotate +0+80 "$HOURS" -annotate +400+80 "$MINS" \
    \
    `# --- 4. TEXT OUTER GLOW ---` \
    -fill "#009955" -stroke "#009955" -strokewidth 8 \
    -pointsize 160 -annotate +0-350 "FULL RESET" \
    -pointsize 120 -annotate -400+80 "$DAYS" -annotate +0+80 "$HOURS" -annotate +400+80 "$MINS" \
    \
    `# --- 5. TEXT INNER GLOW ---` \
    -fill "#00ff9c" -stroke "#00ff9c" -strokewidth 2 \
    -pointsize 160 -annotate +0-350 "FULL RESET" \
    -pointsize 120 -annotate -400+80 "$DAYS" -annotate +0+80 "$HOURS" -annotate +400+80 "$MINS" \
    \
    `# --- 6. TEXT CORE ---` \
    -stroke none -fill "#e6f1ff" \
    -pointsize 160 -annotate +0-350 "FULL RESET" \
    -pointsize 120 -annotate -400+80 "$DAYS" -annotate +0+80 "$HOURS" -annotate +400+80 "$MINS" \
    \
    `# --- 7. SUBTEXT ---` \
    -fill "#00bcd4" -pointsize 40 -annotate +0-160 "TIME REMAINING" \
    -fill "#9aa4af" -pointsize 30 -annotate -400+190 "DAYS" -annotate +0+190 "HOURS" -annotate +400+190 "MINUTES" \
    "$WALL_PATH"

  # --- SLEEP-AWARE SYNC & MICRO-POLLING ---
  if [ "$FIRST_RUN" = false ]; then
    # This loop checks the clock every 2 seconds.
    # If the PC wakes from sleep, it will notice the time within 2s and catch up.
    while [ "$(date +%S)" != "00" ]; do
      # If we are very close to the top of the minute, poll faster (0.1s)
      # Otherwise, sleep in 2s chunks to be energy efficient
      CURRENT_SEC=$(date +%S)
      if [ "$CURRENT_SEC" -eq 59 ]; then
        sleep 0.1
      else
        sleep 2
      fi
    done
  fi

  awww img "$WALL_PATH" --transition-type simple --transition-duration 1 --transition-fps 60

  FIRST_RUN=false
done
