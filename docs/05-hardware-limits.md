# ⚡ Module 05: Hardware Limits & Mobile Optimization

> Practical techniques to maximize performance, prevent background app termination, and manage thermals on Android.

---

## 1. Disabling Android Background Killers

Modern Android skins (Xiaomi HyperOS / MIUI, Samsung OneUI, OnePlus OxygenOS, Oppo ColorOS) employ aggressive proprietary background task killers to artificially maximize battery life.

If not configured, Android will kill Termux after 10–15 minutes of inactivity.

### Step 1: Whitelist Termux in Battery Settings
- **Xiaomi HyperOS / MIUI:**  
  Open **Settings → Apps → Manage Apps → Termux → Battery Saver** → Select **No Restrictions**. Also toggle on **Autostart**.
- **Samsung OneUI:**  
  Open **Settings → Battery → Background usage limits → Never sleeping apps** → Tap `+` and add **Termux**.
- **Google Pixel / Stock Android (AOSP):**  
  Open **Settings → Apps → Termux → App battery usage** → Select **Unrestricted**.
- **OnePlus / Realme / Oppo:**  
  Open **Settings → Apps → App Management → Termux → Battery Usage** → Enable **Allow background activity** and **Allow auto-launch**.

### Step 2: Lock Termux in the App Switcher
1. Open the Android Multitasking / Recent Apps view.
2. Long-press on the **Termux** preview card (or tap the app icon).
3. Tap the **Lock 🔒** icon. This prevents the OS from killing Termux when you tap "Clear All".

### Step 3: Enable Termux Wake Lock
Inside Termux, pull down the Android notification shade and tap **"Acquire Wake Lock"**, or run:
```bash
termux-wake-lock
```
This tells Android's kernel not to put the CPU into deep sleep while background tasks are running.

---

## 2. Memory & Swap Management

Compiling large codebases or running heavy AI agents requires sufficient memory.

### Checking Available Memory
Inside Ubuntu:
```bash
free -h
```
Most modern phones have 8GB of physical RAM plus 4GB–8GB of Android virtual memory (zRAM / swap).

### Tips to Prevent Out-of-Memory (OOM) Errors:
1. **Never run Gradle or npm daemons:** Use standalone compilers (`javac`, `dx`) or lightweight bundle tools.
2. **Limit compiler thread pools:** When compiling C/C++ or native libraries, do not use `make -j8` (which uses all 8 cores simultaneously and spikes RAM). Instead, use `make -j4` or `make -j2`.
3. **Monitor with `htop`:** Keep an eye on memory usage by running `htop` in a split `tmux` pane.

---

## 3. Persistent Sessions with `tmux`

If you accidentally swipe Termux away or receive a phone call, your long-running script or dev server should not crash. Use **`tmux`** (Terminal Multiplexer):

### Basic `tmux` Workflow:
```bash
# Start a new named session
tmux new -s sangalo-dev

# Detach from session (leaves it running in background)
# Press Ctrl+B, then D

# Reattach anytime
tmux attach -t sangalo-dev

# List running sessions
tmux ls
```

---

## 4. Thermals and Long-Running Tasks

Modern mobile processors (e.g. MediaTek Dimensity, Snapdragon) are passively cooled. When running continuous compilation or heavy compute:
- Avoid fast-charging your phone while compiling heavy tasks to reduce heat build-up.
- Keep the phone on a flat, hard surface (like a desk or stand) rather than on a blanket or bed to allow natural heat dissipation.
