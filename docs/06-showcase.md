# 🏆 Module 06: Living Proof Showcase

> Real-world software built, compiled, and published entirely on mobile smartphones.

---

## 🌟 Flagship Project: सँगालो (Sangalo) 🇳🇵

**Sangalo** is a production-grade, 100% offline-first digital companion crafted specifically for Nepali households worldwide.

- **GitHub Repository:** [github.com/dahalsandesh/sangalo](https://github.com/dahalsandesh/sangalo)
- **Direct APK Download:** [Download Sangalo.apk (v1.0.0)](https://github.com/dahalsandesh/sangalo/releases/latest/download/Sangalo.apk) (~216 KB)
- **Creator:** [Sandesh Dahal](https://dahalsandesh.com.np) ([@dahalsandesh](https://github.com/dahalsandesh))
- **Host Device:** Xiaomi Redmi Note 15 Pro 5G (Dimensity 7300, 8GB RAM)

---

### What Was Engineered Entirely on Mobile:

#### 1. 📅 91-Year Authentic Bikram Sambat (BS) & Gregorian Calendar
- 91-year database spanning **BS 2000 to BS 2090** verified against Nepal Panchanga Nirnayak Samiti astronomical standards.
- Real-time lunar tithi calculations: Dashain, Tihar, Chhath, Janai Purnima, Teej, Maha Shivaratri, and Lhosar.
- Pinned native Android status bar date notification that automatically updates to the new day at midnight (`00:00:00`) via native Android `AlarmManager` even if the app has been closed for weeks.

#### 2. 💊 Routine Medicine Alarms & Adherence Tracker
- Custom exact time alarm scheduler (`HH:MM`).
- Native high-priority alarm ringtone audio (`RingtoneManager.TYPE_ALARM`) and hardware vibration.
- Interactive modal with "✅ खाएँ (Mark Taken)" adherence logging and "⏰ ५ मिनेट पछि (Snooze)" re-triggering.

#### 3. 🐕 Interactive Physics Pet Companion ("पुकु" / Puku)
- Real-time Verlet physics engine with drag momentum, elastic boundary bouncing, and backflip somersaults.
- Interactive tennis ball fetch mini-game (🎾).

#### 4. 💰 Fair Expense Splitter & Borrowing Ledger
- Split household bills and track borrowing/lending ("तिर्न बाँकी" / "पाउनु पर्ने").
- Structured 1-tap clipboard export formatted for instant sharing over WhatsApp, Viber, or SMS.

#### 5. 🔐 Encrypted Document & Photo Vault
- Offline local storage for Citizenship, Driving License, Bluebook, and Health Insurance cards using IndexedDB.

#### 6. 🐯 Authentic 5x5 Bagh-Chal Board Game
- Traditional Nepali strategic board game with Minimax AI engine and move undo.

---

### Build Stats & Performance:
- **Build Method:** Pure native ARM64 toolchain (`javac`, `dx`, `aapt`, `apksigner`, `zipalign`).
- **Build Time:** ~10 seconds directly on the phone.
- **APK Size:** **~216 KB** (Over 90% smaller than standard Flutter/React Native APKs which start at 30MB–60MB!).
- **Memory Consumption:** < 120MB RAM during runtime.
- **Dependencies:** **Zero NPM bloat.** 100% vanilla JavaScript, HTML5, and standard Android SDK.

---

## 🚀 Submit Your Project!

Have you built an application, network tool, Telegram bot, or micro-server entirely on your smartphone?

Open a Pull Request to feature your project in this showcase!
1. Project Name & GitHub link
2. Device model & specs
3. What it does
4. Why building it on mobile mattered to you
