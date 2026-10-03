# ⚡ Hello Pocket (Zero-Gradle Native Android Demo)

A minimal, self-contained native Android project that compiles into a signed APK in ~5 seconds using pure Dalvik tooling (`javac`, `dx`/`d8`, `aapt`, `apksigner`).

---

## 🚀 How to Build on Your Phone

Inside your Termux Ubuntu PRoot environment:

```bash
cd examples/hello-pocket
bash build.sh
```

The script will automatically:
1. Detect or download `android.jar` (API 30).
2. Compile resources and Java code.
3. Translate bytecode to Dalvik executable (`classes.dex`).
4. Package web assets from `public/` into an APK.
5. Align and sign the APK with a local debug keystore.
6. Produce `hello-pocket.apk` (~16 KB).

---

## 📲 How to Install & Test

Copy the compiled APK to your Android internal storage:

```bash
cp hello-pocket.apk /sdcard/Documents/Projects/
```

Open your phone's file manager, navigate to `Documents/Projects`, tap `hello-pocket.apk`, and tap **Install**.

When launched:
- Renders a clean, high-signal dark mode dashboard.
- Displays device screen dimensions and runtime bridge status.
- Tap **"Trigger Native Android Toast"** to test the JavaScript-to-Android Java bridge in action!
