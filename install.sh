#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "⚡ Starting VoltOS Customization Script ⚡"
echo "----------------------------------------"

# 1. Update the system using DNF5
echo "🔄 Updating system packages..."
sudo dnf upgrade -y

# 2. Install KDE Plasma Desktop Environment
echo "🖥️ Installing KDE Plasma Desktop..."
sudo dnf groupinstall -y "KDE Plasma Desktop"

# 3. Install core VoltOS software packages
echo "📦 Installing VoltOS default applications..."
sudo dnf install -y \
    fastfetch \
    git \
    htop \
    vlc \
    wget

# 4. Create custom system configurations
echo "⚙️ Applying VoltOS system tweaks..."
if ! grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads=5" | sudo tee -a /etc/dnf/dnf.conf
fi

# 5. Set SDDM (KDE Login Manager) as default
echo "🔒 Enabling KDE Login Manager (SDDM)..."
sudo systemctl enable sddm --force

# ==========================================
# OPTION 1: CUSTOM STYLING (THEMES & WALLPAPER)
# ==========================================
echo "🎨 Applying VoltOS Custom Styling..."
# Create a folder for the VoltOS wallpaper
sudo mkdir -p /usr/share/backgrounds/voltos
# Download a sleek neon/dark tech wallpaper
sudo wget -O /usr/share/backgrounds/voltos/default.jpg "https://unsplash.com"

# Force KDE to use Breeze Dark theme for new users
sudo mkdir -p /etc/xdg
sudo tee /etc/xdg/kdeglobals << 'KDEEOF'
[Theme]
Name=BreezeDark
KDEEOF

# ==========================================
# OPTION 2: FLATPAK & FLATHUB SUPPORT
# ==========================================
echo "🚀 Enabling Flathub App Store..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org

# ==========================================
# OPTION 3: WELCOME COMMAND (ASCII ART & FASTFETCH)
# ==========================================
echo "📟 Setting up VoltOS Terminal Welcome Screen..."
# Create a script that runs every time a user opens a terminal
sudo tee /etc/profile.d/voltos-welcome.sh << 'WELCOMEEOF'
#!/bin/bash
if [ -n "$PS1" ]; then
    echo -e "\e[1;34m"
    echo "  ⚡⚡⚡ VoltOS 44 ⚡⚡⚡  "
    echo "  Based on Fedora Linux  "
    echo -e "\e[0m"
    fastfetch --logo none
fi
WELCOMEEOF
sudo chmod +x /etc/profile.d/voltos-welcome.sh

echo "----------------------------------------"
echo "🎉 VoltOS Power-Up Installation Complete!"
echo "🔄 Please restart your PC and select Plasma/KDE at the login screen."
