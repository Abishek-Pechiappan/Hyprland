#!/usr/bin/env bash

current=$(powerprofilesctl get 2>/dev/null || echo "balanced")

case "$current" in
  power-saver)  next="balanced"     ;;
  balanced)     next="performance"  ;;
  performance)  next="power-saver"  ;;
  *)            next="balanced"     ;;
esac

powerprofilesctl set "$next"
