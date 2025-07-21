#!/bin/bash

# Define the source directory (where your Hyprland-main folder is located)
# This assumes the script is run from the directory containing 'Hyprland-main'
SOURCE_DIR="Hyprland-main"

# Create target directories if they don't exist
mkdir -p ~/.config/waybar/
mkdir -p ~/.config/hypr/
mkdir -p ~/.config/rofi/

echo "Moving configuration files..."

# Move .gitattributes
if [ -f "$SOURCE_DIR/.gitattributes" ]; then
    mv "$SOURCE_DIR/.gitattributes" ~/.gitattributes
    echo "Moved .gitattributes to ~/.gitattributes"
fi

# Move Waybar configuration files
if [ -f "$SOURCE_DIR/Waybar/macchiato.css" ]; then
    mv "$SOURCE_DIR/Waybar/macchiato.css" ~/.config/waybar/macchiato.css
    echo "Moved macchiato.css to ~/.config/waybar/"
fi
if [ -f "$SOURCE_DIR/Waybar/style.css" ]; then
    mv "$SOURCE_DIR/Waybar/style.css" ~/.config/waybar/style.css
    echo "Moved style.css to ~/.config/waybar/"
fi
if [ -f "$SOURCE_DIR/Waybar/config" ]; then
    mv "$SOURCE_DIR/Waybar/config" ~/.config/waybar/config
    echo "Moved config to ~/.config/waybar/"
fi

# Move Hyprland configuration file
if [ -f "$SOURCE_DIR/Hyprland/hyprland.conf" ]; then
    mv "$SOURCE_DIR/Hyprland/hyprland.conf" ~/.config/hypr/hyprland.conf
    echo "Moved hyprland.conf to ~/.config/hypr/"
fi

# Move Rofi configuration files
if [ -f "$SOURCE_DIR/Rofi/mac.rasi" ]; then
    mv "$SOURCE_DIR/Rofi/mac.rasi" ~/.config/rofi/mac.rasi
    echo "Moved mac.rasi to ~/.config/rofi/"
fi
if [ -f "$SOURCE_DIR/Rofi/ma.rasi" ]; then
    mv "$SOURCE_DIR/Rofi/ma.rasi" ~/.config/rofi/ma.rasi
    echo "Moved ma.rasi to ~/.config/rofi/"
fi

echo "Configuration file organization complete."
