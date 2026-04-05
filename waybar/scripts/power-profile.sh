#!/usr/bin/env bash

profile=$(powerprofilesctl get 2>/dev/null || echo "balanced")

case "$profile" in
  power-saver)
    echo '{"text":"[ 󰌪 Eco ]","tooltip":"Power Profile: Eco (Power Saver)","class":"power-saver"}'
    ;;
  balanced)
    echo '{"text":"[  Stable ]","tooltip":"Power Profile: Stable (Balanced)","class":"balanced"}'
    ;;
  performance)
    echo '{"text":"[ 󱐋 Full ]","tooltip":"Power Profile: Full Capacity (Performance)","class":"performance"}'
    ;;
  *)
    echo '{"text":"[ 󰊦 ? ]","tooltip":"Power Profile: Unknown","class":"unknown"}'
    ;;
esac
