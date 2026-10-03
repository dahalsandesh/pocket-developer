# 📦 Module 03: Zero-Gradle Native Android APK Compilation

> How to compile production-grade native Android APKs in ~10 seconds on ARM64 Linux without Android Studio, Gradle daemons, or cloud build farms.

---

## 1. Why Traditional Gradle Fails on Phones

Standard Android development relies on **Gradle** and the **Android Gradle Plugin (AGP)**:
- Gradle launches background worker daemons that easily consume **4GB to 8GB of RAM**.
- On a mobile device with 6GB–8GB RAM, this triggers Android's aggressive Low Memory Killer (OOM killer), abruptly terminating the build.
- AGP downloads thousands of transient dependencies (`.pom`, `.jar`, `.aar`), demanding high-speed internet and wasting gigabytes of disk space.

### The Pure CLI Solution
Android apps do not inherently require Gradle to build! At its core, the Android build pipeline consists of 5 simple command-line tools provided directly by Google's Android SDK:
1. **`aapt` (Android Asset Packaging Tool):** Compiles XML resources into binary XML and packages assets.
2. **`javac` (Standard Java Compiler):** Compiles `.java` files into standard Java `.class` bytecode.
3. **`dx` or `d8` (Dalvik Compiler):** Translates standard Java bytecode into Android Dalvik executable bytecode (`classes.dex`).
4. **`zipalign`:** Aligns all uncompressed data in the ZIP archive to 4-byte boundaries for memory-mapped efficiency.
5. **`apksigner`:** Applies cryptographically secure APK Signature Scheme v2 and v3 signatures.

This entire pipeline runs natively on ARM64 Linux inside Termux PRoot in **less than 10 seconds** and consumes **less than 200MB of RAM**!

---

## 2. Directory Layout for a Pure CLI Android Project

A lightweight native Android project has a clean, readable layout:

```text
my-app/
├── AndroidManifest.xml       # App package, permissions, activities, receivers
├── build_apk.sh              # 1-click build pipeline script
├── res/                      # Android resources
│   ├── mipmap-hdpi/          # App launcher icons (PNG)
│   └── values/
│       └── strings.xml       # App name and strings
├── public/                   # Web application assets (HTML, CSS, JS, icons)
│   ├── index.html
│   ├── app.js
│   └── icon.svg
└── src/                      # Java source code
    └── com/example/app/
        ├── MainActivity.java # WebView host, JavascriptInterface bridge
        └── CalendarReceiver.java # Background BroadcastReceiver / AlarmManager
```

---

## 3. The 5-Step Build Pipeline in Bash

Here is the exact bash pipeline used in **सँगालो (Sangalo)**:

```bash
#!/bin/bash
set -e

DIR="$(pwd)"
BUILD_DIR="$DIR/.build"
ANDROID_JAR="$DIR/.android_sdk/android.jar"
OUTPUT_APK="/sdcard/Documents/Projects/MyApp.apk"

# 1. Compile Android resources & generate R.java
mkdir -p "$BUILD_DIR/gen" "$BUILD_DIR/obj"
aapt package -f -m \
    -J "$BUILD_DIR/gen" \
    -S res \
    -M AndroidManifest.xml \
    -I "$ANDROID_JAR"

# 2. Compile Java source files
javac -source 8 -target 8 \
    -cp "$ANDROID_JAR" \
    -d "$BUILD_DIR/obj" \
    $(find "$BUILD_DIR/gen" src -name "*.java")

# 3. Convert bytecode to Dalvik DEX
dx --dex --output="$BUILD_DIR/classes.dex" "$BUILD_DIR/obj"

# 4. Package resources and web assets into unsigned APK
aapt package -f \
    -M AndroidManifest.xml \
    -S res \
    -A public \
    -I "$ANDROID_JAR" \
    -F "$BUILD_DIR/unsigned.apk"

cd "$BUILD_DIR" && aapt add unsigned.apk classes.dex && cd "$DIR"

# 5. Align and cryptographically sign with v2/v3 scheme
zipalign -f 4 "$BUILD_DIR/unsigned.apk" "$BUILD_DIR/aligned.apk"

apksigner sign \
    --ks release.keystore \
    --ks-pass pass:android \
    --key-pass pass:android \
    --out "$OUTPUT_APK" \
    "$BUILD_DIR/aligned.apk"

echo "✅ SUCCESS! Native signed APK compiled: $OUTPUT_APK"
```

---

## 4. The JavaScript-to-Android Bridge

To give your web app native mobile superpowers (status bar notifications, exact alarms, system vibrations, native sharing), expose a `JavascriptInterface` in `MainActivity.java`:

```java
public class MainActivity extends Activity {
    private WebView webView;

    public class WebAppInterface {
        Context mContext;
        WebAppInterface(Context c) { mContext = c; }

        @JavascriptInterface
        public void showNativeToast(String message) {
            Toast.makeText(mContext, message, Toast.LENGTH_SHORT).show();
        }

        @JavascriptInterface
        public void openExternalUrl(String url) {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            mContext.startActivity(intent);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        webView = new WebView(this);
        setContentView(webView);

        webView.getSettings().setJavaScriptEnabled(true);
        webView.addJavascriptInterface(new WebAppInterface(this), "AndroidBridge");
        webView.loadUrl("file:///android_asset/index.html");
    }
}
```

Now in your frontend `app.js`, you can call native Android features with a simple one-liner:
```javascript
if (window.AndroidBridge) {
    window.AndroidBridge.showNativeToast("Namaste from Android!");
}
```
