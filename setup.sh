#!/bin/bash
# ==============================================================================
# The Pocket Developer (PocketDev) — 1-Tap Workstation Bootstrap Script
# Turns any Android smartphone into an unprivileged Linux engineering workstation
# ==============================================================================
set -e

echo "=================================================="
echo "   📱 PocketDev — Mobile Workstation Setup        "
echo "=================================================="

# Check if running inside Termux
if [ -z "$TERMUX_VERSION" ]; then
    echo "Notice: Running outside Termux environment."
else
    echo "[1/4] Configuring Termux storage..."
    termux-setup-storage || true
    
    echo "[2/4] Updating Termux packages..."
    pkg update -y && pkg upgrade -y
    
    echo "[3/4] Installing proot-distro and utilities..."
    pkg install proot-distro git curl wget openssh tmux -y
    
    echo "[4/4] Installing Ubuntu PRoot..."
    if ! proot-distro list | grep -q "ubuntu.*installed"; then
        proot-distro install ubuntu
    fi
    
    echo ""
    echo "=================================================="
    echo " ✅ Termux setup complete!"
    echo " Log into Ubuntu via: proot-distro login ubuntu"
    echo "=================================================="
fi
