# 🐧 Module 01: Linux Foundation on Android

> How to set up an unprivileged, sandboxed Ubuntu Linux environment on Android without root permissions.

---

## 1. The Core Architecture

Android is built on top of the Linux kernel, but its userland is fundamentally different from a standard desktop Linux distribution:
- Android uses **Bionic libc** instead of the standard GNU C Library (`glibc`).
- It has no standard `/bin`, `/usr/bin`, `/etc`, or package manager like `apt`.
- Security policies (SELinux) strictly prevent regular apps from executing arbitrary system binaries.

To turn Android into a true engineering workstation, we use a two-tiered layer:
1. **Termux:** An open-source terminal emulator and Linux environment for Android.
2. **PRoot-Distro:** A userland implementation of `chroot` that uses `ptrace` system call interception to simulate root access, filesystem hierarchies, and allow standard Linux distributions (like Ubuntu 26.04) to run without modifying the phone's operating system or voiding warranties.

---

## 2. Step 1: Install Termux

> [!CAUTION]
> **Never install Termux from Google Play Store.** The Play Store build was frozen in 2020 due to Google Play target API requirements. Trying to run `pkg update` on the Play Store version will immediately fail with repository 404 errors.

### Official Download Sources:
- **F-Droid (Recommended):** [f-droid.org/packages/com.termux/](https://f-droid.org/packages/com.termux/)
- **GitHub Releases:** [github.com/termux/termux-app/releases](https://github.com/termux/termux-app/releases)

### Initial Setup:
Open Termux and execute:
```bash
# Update Termux core package repositories
pkg update && pkg upgrade -y

# Grant storage access to Android internal storage (/sdcard)
termux-setup-storage
```
Tap **Allow** when the Android permission dialog appears. This creates a convenient symlink at `~/storage/shared/` pointing to your phone's storage.

---

## 3. Step 2: Install Ubuntu via PRoot-Distro

`proot-distro` is the official utility to install and manage complete Linux distributions inside Termux:

```bash
# Install proot-distro
pkg install proot-distro -y

# Install Ubuntu (aarch64)
proot-distro install ubuntu
```

### Logging Into Ubuntu
Whenever you want to enter your Linux development workspace:
```bash
proot-distro login ubuntu
```

Your shell prompt will change from `$` to `root@localhost:~#`. You now have a full Ubuntu environment running natively on your phone's ARM64 processor!

---

## 4. Step 3: Install the Essential Toolchain

Inside your Ubuntu container, update `apt` and install the core compilers and utilities:

```bash
apt update && apt upgrade -y

# Development Essentials
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
```

---

## 5. Storage Hierarchy & Organization

To avoid a messy filesystem and protect your code, follow this directory structure inside Ubuntu:

```text
/root/
├── workspace/
│   ├── apps/           <-- Ext4 filesystem! Keep all source code, node_modules, and git repos here
│   │   ├── sangalo/
│   │   └── my-new-project/
│   ├── tools/          <-- Helper scripts and global configs
│   └── phone_storage/  <-- Symlink to /sdcard/Documents/Projects/ (Export finished APKs here)
```

Create this workspace:
```bash
mkdir -p /root/workspace/apps
mkdir -p /root/workspace/tools
ln -s /sdcard/Documents/Projects /root/workspace/phone_storage
```

> [!IMPORTANT]
> **Storage Rule:** ALWAYS keep source code on `ext4` inside `/root/workspace/apps/`.  
> NEVER build directly inside `/sdcard/`. Android's internal storage uses a FUSE filesystem that lacks symlink support, file execution permissions (`chmod +x`), and causes compilation tools to fail.
