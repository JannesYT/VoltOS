# VoltOS 44 Kickstart File
# Based on Fedora 44 KDE Live

# 1. Use the official Fedora 44 repositories
url --url=https://fedoraproject.org
repo --name=fedora --mirrorlist=https://fedoraproject.org
repo --name=updates --mirrorlist=https://fedoraproject.org

# 2. Basic installation settings
lang en_US.UTF-8
keyboard us
timezone UTC
authselect --useshadow --usemd5
selinux --disabled
firewall --enabled --service=ssh
bootloader --location=mbr

# 3. Define packages to install inside the ISO
%packages
@kde-desktop
fastfetch
git
htop
vlc
wget
flatpak
%end

# 4. Post-installation customization script (Runs inside the ISO build environment)
%post --log=/root/voltos-build.log
echo "⚡ Tuning ISO into VoltOS ⚡"

# Speed up DNF inside the system
if ! grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads=5" >> /etc/dnf/dnf.conf
fi

# Set up SDDM Login Manager
systemctl enable sddm --force

# Apply VoltOS Styling & Wallpaper
mkdir -p /usr/share/backgrounds/voltos
wget -O /usr/share/backgrounds/voltos/default.jpg "https://unsplash.com"

mkdir -p /etc/xdg
cat << 'KDEEOF' > /etc/xdg/kdeglobals
[Theme]
Name=BreezeDark
KDEEOF

# Enable Flathub App Store
flatpak remote-add --if-not-exists flathub https://flathub.org

# Terminal Welcome Screen
cat << 'WELCOMEEOF' > /etc/profile.d/voltos-welcome.sh
#!/bin/bash
if [ -n "$PS1" ]; then
    echo -e "\e[1;34m"
    echo "  ⚡⚡⚡ VoltOS 44 ⚡⚡⚡  "
    echo "  Based on Fedora Linux  "
    echo -e "\e[0m"
    fastfetch --logo none
fi
WELCOMEEOF
chmod +x /etc/profile.d/voltos-welcome.sh
%end
