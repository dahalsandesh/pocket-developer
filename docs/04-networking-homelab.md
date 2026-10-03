# 🌐 Module 04: Networking, Wi-Fi Control & Mobile Home Lab

> Why a smartphone running Linux is far more than a code editor: turning your pocket device into a 24/7 network auditor, IoT gateway, and automation server.

---

## 1. Beyond App Development: The Pocket Server

Because your smartphone has a dedicated battery, always-on connectivity (Wi-Fi + 5G/4G cellular), and ultra-low idle power consumption (~0.5 to 1.5 Watts), it is the **ideal low-power micro-server**—consuming a fraction of the electricity of a Raspberry Pi or desktop PC!

Here is what you can run directly inside Termux Ubuntu:
- **Wi-Fi & Network Auditing:** Scan home networks, detect intruder devices, monitor latency, and diagnose routing issues.
- **Home IoT Controller:** Run lightweight MQTT brokers (`mosquitto`) to orchestrate smart home plugs, ESP32 microcontrollers, and smart bulbs.
- **24/7 Automation Bots:** Run Python/Node.js Telegram or Discord bots that notify you of price drops, website updates, or weather changes.
- **Offline Media & File Server:** Share files across your household using HTTP, WebDAV, or lightweight SFTP.

---

## 2. Network Scanning & Wi-Fi Auditing

Install network utilities inside Ubuntu:
```bash
apt install -y nmap iperf3 curl net-tools iproute2 dnsutils
```

### Scan Your Local Wi-Fi Network
Discover all active devices (phones, laptops, smart TVs, cameras) connected to your router:
```bash
# Find your subnet (e.g. 192.168.1.0/24)
ip route | grep default

# Scan for live hosts
nmap -sn 192.168.1.0/24
```

### Test Network Bandwidth & Latency
Run `iperf3` between your phone and a laptop to test real-world Wi-Fi throughput without relying on external internet speed tests:
```bash
# On phone (server mode)
iperf3 -s

# On laptop (client mode)
iperf3 -c 192.168.1.15
```

---

## 3. Home Automation & Headless Bots

### 1. Telegram / Discord Notification Bot
Create a background Python bot that notifies you whenever an event occurs:
```python
# bot.py
import requests
import time

BOT_TOKEN = "your_telegram_bot_token"
CHAT_ID = "your_chat_id"

def send_alert(message):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    requests.post(url, data={"chat_id": CHAT_ID, "text": message})

send_alert("🚀 Pocket Server is online and monitoring network!")
```

### 2. Lightweight MQTT Broker for Smart Home
```bash
apt install -y mosquitto mosquitto-clients
mosquitto -d -p 1883
```
Now your phone acts as the central command bridge for all ESP8266/ESP32 home automation nodes in your house!

---

## 4. Connecting with a Laptop or PC (Dual-Screen Setup)

If you have a laptop and want a full-sized mechanical keyboard, mouse, and 4K display while letting your phone do all the computing:

```mermaid
flowchart LR
    Phone["Android Smartphone\n(Termux OpenSSH :8022)"] <--- "Local Wi-Fi\n(SSH / HTTP)" ---> Laptop["Laptop / Desktop\n(VS Code Remote SSH / Browser)"]
```

### Method 1: VS Code Remote SSH
1. Install OpenSSH in Termux:
   ```bash
   pkg install openssh -y
   passwd
   sshd
   ```
2. On your laptop, open **Visual Studio Code**.
3. Install the **Remote - SSH** extension.
4. Press `F1` → **Connect to Host...** → `ssh -p 8022 <phone-ip>`
5. Open your workspace directory: `/data/data/com.termux/files/home/ubuntu/root/workspace/apps/`
6. You now have the full desktop VS Code UI, extensions, Git tree, and terminal running live against your smartphone!

### Method 2: Localhost Browser Pairing
Run your server on the phone:
```bash
python3 server.py  # listening on 0.0.0.0:8090
```
Open `http://<phone-ip>:8090` in your laptop browser to preview mobile UIs and inspect elements with Chrome DevTools on a big screen!
