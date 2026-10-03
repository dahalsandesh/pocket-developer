#!/bin/bash
# ==============================================================================
# Hello Pocket — 1-Tap Zero-Gradle Native APK Compiler
# Compiles, packages, and signs hello-pocket.apk in ~5 seconds
# ==============================================================================
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$DIR/.build"
OUTPUT_APK="$DIR/hello-pocket.apk"
ANDROID_JAR="$DIR/.android_sdk/android.jar"

echo "=================================================="
echo "   ⚡ Hello Pocket — Zero-Gradle APK Compiler     "
echo "=================================================="

# 1. Verify build dependencies
MISSING_TOOLS=()
for tool in aapt zipalign apksigner javac; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "Error: Missing required build tools: ${MISSING_TOOLS[*]}"
    echo "Run setup.sh or execute: apt install -y aapt zipalign apksigner openjdk-17-jdk-headless libandroid-tools-android-dev"
    exit 1
fi

D8_CMD=""
if command -v d8 >/dev/null 2>&1; then
    D8_CMD="d8"
elif command -v dx >/dev/null 2>&1; then
    D8_CMD="dx"
else
    echo "Error: Neither 'd8' nor 'dx' found. Install libandroid-tools-android-dev."
    exit 1
fi

# 2. Check Android SDK Platform jar
if [ ! -f "$ANDROID_JAR" ]; then
    mkdir -p "$DIR/.android_sdk"
    # Check common local cache locations first
    if [ -f "/root/workspace/apps/haven/.android_sdk/android.jar" ]; then
        echo "Found local android.jar cache, linking..."
        cp "/root/workspace/apps/haven/.android_sdk/android.jar" "$ANDROID_JAR"
    else
        echo "Downloading android.jar (API 30)..."
        curl -fsSL -o "$ANDROID_JAR" "https://raw.githubusercontent.com/Sable/android-platforms/master/android-30/android.jar"
    fi
fi

# 3. Setup workspace
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/gen" "$BUILD_DIR/obj"

# 4. Generate R.java
echo "[1/5] Compiling resources with AAPT..."
aapt package -f -m \
    -J "$BUILD_DIR/gen" \
    -S res \
    -M AndroidManifest.xml \
    -I "$ANDROID_JAR"

# 5. Compile Java classes
echo "[2/5] Compiling Java classes..."
javac -source 8 -target 8 \
    -cp "$ANDROID_JAR" \
    -d "$BUILD_DIR/obj" \
    $(find "$BUILD_DIR/gen" src -name "*.java")

# 6. Convert bytecode to Dalvik DEX
echo "[3/5] Converting bytecode to Dalvik executable (DEX)..."
if [ "$D8_CMD" = "d8" ]; then
    d8 --output "$BUILD_DIR" $(find "$BUILD_DIR/obj" -name "*.class")
else
    dx --dex --output="$BUILD_DIR/classes.dex" "$BUILD_DIR/obj"
fi

# 7. Package assets & resources into unsigned APK
echo "[4/5] Packaging APK package..."
aapt package -f \
    -M AndroidManifest.xml \
    -S res \
    -A public \
    -I "$ANDROID_JAR" \
    -F "$BUILD_DIR/unsigned.apk"

cd "$BUILD_DIR" && aapt add unsigned.apk classes.dex && cd "$DIR"

# 8. Align and cryptographically sign (v2/v3 scheme)
echo "[5/5] Aligning and signing APK..."
zipalign -f 4 "$BUILD_DIR/unsigned.apk" "$BUILD_DIR/aligned.apk"

# Create self-signed debug keystore if not present
KEYSTORE="$DIR/.build/debug.keystore"
keytool -genkey -v \
    -keystore "$KEYSTORE" \
    -storepass android \
    -alias androiddebugkey \
    -keypass android \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=PocketDev, OU=Mobile, O=PocketDev, L=Kathmandu, C=NP" \
    >/dev/null 2>&1

apksigner sign \
    --ks "$KEYSTORE" \
    --ks-pass pass:android \
    --key-pass pass:android \
    --out "$OUTPUT_APK" \
    "$BUILD_DIR/aligned.apk"

# Clean temporary build directory
rm -rf "$BUILD_DIR"

echo "=================================================="
echo " ✅ SUCCESS! Signed APK created at:"
echo "    $OUTPUT_APK"
echo " Size: $(du -h "$OUTPUT_APK" | cut -f1)"
echo "=================================================="
