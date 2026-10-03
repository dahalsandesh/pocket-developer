#!/bin/bash
# ==============================================================================
# The Pocket Developer (PocketDev) — Smart Dual-Mode Bootstrap Script
# Turns any Android smartphone into an unprivileged Linux engineering workstation
# ==============================================================================
set -e

echo "=================================================="
echo "   📱 PocketDev — Mobile Workstation Setup        "
echo "=================================================="

if [ -n "$TERMUX_VERSION" ]; then
    echo "[Mode: Termux Host]"
    echo "[1/4] Configuring Termux storage access..."
    termux-setup-storage || true
    
    echo "[2/4] Updating Termux packages..."
    pkg update -y && pkg upgrade -y
    
    echo "[3/4] Installing PRoot-distro and essentials..."
    pkg install proot-distro git curl wget openssh tmux -y
    
    echo "[4/4] Setting up Ubuntu Linux container..."
    if ! proot-distro list | grep -q "ubuntu.*installed"; then
        proot-distro install ubuntu
    fi
    
    # Add pocket alias to ~/.bashrc for easy 1-command login
    if ! grep -q "alias pocket=" "$HOME/.bashrc" 2>/dev/null; then
        echo "alias pocket='proot-distro login ubuntu'" >> "$HOME/.bashrc"
    fi

    echo ""
    echo "=================================================="
    echo " ✅ Termux setup complete!"
    echo " Enter your Linux workstation anytime via:"
    echo "   pocket   (or: proot-distro login ubuntu)"
    echo " Inside Ubuntu, run ./setup.sh to configure SDKs!"
    echo "=================================================="

elif [ -f /etc/os-release ] && grep -qi "ubuntu\|debian" /etc/os-release; then
    echo "[Mode: Linux PRoot Container]"
    echo "[1/3] Updating package repositories..."
    apt update && apt upgrade -y

    echo "[2/3] Installing native ARM64 Android compilers and dev tools..."
    apt install -y \
        git \
        curl \
        wget \
        build-essential \
        python3 \
        python3-pip \
        python3-venv \
        openjdk-17-jdk-headless \
        aapt \
        zipalign \
        apksigner \
        libandroid-tools-android-dev \
        tmux \
        htop \
        nano

    echo "[3/3] Initializing clean workspace structure..."
    mkdir -p /root/workspace/apps
    mkdir -p /root/workspace/tools
    if [ -d "/sdcard/Documents/Projects" ] && [ ! -e "/root/workspace/phone_storage" ]; then
        ln -s /sdcard/Documents/Projects /root/workspace/phone_storage
    fi

    echo ""
    echo "=================================================="
    echo " ✅ PRoot Ubuntu toolchain configured successfully!"
    echo " Workspace: /root/workspace/apps/"
    echo " Test compiling: cd examples/hello-pocket && bash build.sh"
    echo "=================================================="

else
    echo "Notice: Unrecognized environment. PocketDev supports Termux and Ubuntu/Debian PRoot."
fi
