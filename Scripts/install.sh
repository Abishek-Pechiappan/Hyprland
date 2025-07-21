#!/bin/bash

# --- Function to check for errors ---
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

echo "Starting the installation process..."

# --- 1. Install Git and base-devel using pacman ---
echo "Installing Git and base-devel..."
sudo pacman -S --needed git base-devel --noconfirm
check_error "Git and base-devel installation"

# --- 2. Install yay (AUR Helper) ---
echo "Cloning and installing yay..."
git clone https://aur.archlinux.org/yay.git
check_error "Cloning yay repository"

cd yay
check_error "Changing directory to yay"

makepkg -si --noconfirm
check_error "Building and installing yay"

cd ..
check_error "Returning to previous directory"

rm -rf yay
echo "yay installed successfully."

# --- 3. Install Neovim using pacman ---
echo "Installing Neovim..."
sudo pacman -S --needed neovim --noconfirm
check_error "Neovim installation"

# --- 4. Install Pacseek using yay ---
echo "Installing Pacseek using yay..."
yay -S --needed pacseek --noconfirm
check_error "Pacseek installation"

# --- 5. Install Visual Studio Code (visual-studio-code-bin) using yay ---
echo "Installing Visual Studio Code (visual-studio-code-bin) using yay..."
yay -S --needed visual-studio-code-bin --noconfirm
check_error "Visual Studio Code installation"

# --- 6. Install Free Download Manager using yay ---
echo "Installing Free Download Manager using yay..."
yay -S --needed freedownloadmanager --noconfirm
check_error "Free Download Manager installation"

# --- 7. Install Zen Browser using yay ---
echo "Installing Zen Browser using yay..."
yay -S --needed zen-browser --noconfirm
check_error "Zen Browser installation"

# --- 8. Install Waypaper and swww using yay ---
echo "Installing Waypaper and swww using yay..."
yay -S --needed waypaper swww --noconfirm
check_error "Waypaper and swww installation"

# --- 9. Install Rofi using pacman ---
echo "Installing Rofi..."
sudo pacman -S --needed rofi --noconfirm
check_error "Rofi installation"

# --- 10. Install KDE Connect using pacman ---
echo "Installing KDE Connect..."
sudo pacman -S --needed kdeconnect --noconfirm
check_error "KDE Connect installation"

# --- 11. Install LocalSend using yay ---
echo "Installing LocalSend..."
yay -S --needed localsend-bin --noconfirm
check_error "LocalSend installation"


echo "All specified packages have been installed successfully!"
echo "You might want to reboot your system for some changes to take full effect, especially for Wayland-related tools and services like KDE Connect."
