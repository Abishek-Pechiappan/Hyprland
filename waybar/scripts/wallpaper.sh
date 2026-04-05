#!/bin/bash
# Apply pywal colors from current swww wallpaper
# Usage: wallpaper.sh           — generate new scheme from current swww wallpaper
#        wallpaper.sh --restore  — restore last wal scheme (for startup)

apply_colors() {
  source "$HOME/.cache/wal/colors.sh"
  hyprctl keyword general:col.active_border "rgba(${color4:1}ee)" 2>/dev/null
  hyprctl keyword general:col.inactive_border "rgba(${color8:1}44)" 2>/dev/null
  gen_rofi_spotlight
}

# Generate rofi spotlight color overrides with alpha transparency
gen_rofi_spotlight() {
  source "$HOME/.cache/wal/colors.sh"
  local BG="${background:1}" # strip leading #
  local ACCENT="${color4:1}"
  local BG_R=$((16#${BG:0:2}))
  local BG_G=$((16#${BG:2:2}))
  local BG_B=$((16#${BG:4:2}))
  cat >"$HOME/.cache/wal/colors-rofi-spotlight.rasi" <<EOF
* {
    /* Semi-transparent pywal background (88% opacity) */
    spotlight-bg:       rgba($BG_R, $BG_G, $BG_B, 0.88);
    /* Accent color for prompt icon */
    spotlight-accent:   #${ACCENT}ff;
    /* Subtle border using accent at 25% opacity */
    spotlight-border:   rgba($BG_R, $BG_G, $BG_B, 0.0);
    /* Selected item highlight at 35% opacity */
    spotlight-selected: #${ACCENT}59;
}
EOF
}

if [ "$1" = "--restore" ]; then
  # Restore last wal scheme on startup
  wal -R -q 2>/dev/null && apply_colors
  exit 0
fi

# Wait for swww transition to finish (waypaper transition_duration = 2s)
sleep 2.5

# Get current wallpaper path from swww
WALLPAPER=$(awww query | grep -oP 'image: \K[^,]+' | head -1)
[ -z "$WALLPAPER" ] && exit 1

# Generate color scheme (-n = don't re-set wallpaper, -q = quiet)
wal -i "$WALLPAPER" -n -q

apply_colors
