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
    vlc

# 4. Create custom system configurations
echo "⚙️ Applying VoltOS system tweaks..."
# Speed up DNF by adding parallel downloads
if ! grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads=5" | sudo tee -a /etc/dnf/dnf.conf
fi

# 5. Set SDDM (KDE Login Manager) as default
echo "🔒 Enabling KDE Login Manager (SDDM)..."
sudo systemctl enable sddm --force

echo "----------------------------------------"
echo "🎉 VoltOS installation complete!"
echo "🔄 Please restart your PC and select Plasma/KDE at the login screen."
