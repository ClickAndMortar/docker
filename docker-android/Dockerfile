FROM budtmo/docker-android:emulator_14.0

LABEL maintainer="Click & Mortar <contact@clickandmortar.fr>"

# Real, modern mobile Chrome on the Android 14 emulator.
#
# The stock budtmo emulator_14.0 system image bundles a frozen Google Chrome
# 113 (May 2023). This image bakes in an authentic, Google-signed Chrome
# 150.0.7871.63 (x86_64) + its matching Trichrome Library so the emulator runs
# a current mobile Chrome. The emulator ABI is x86_64,arm64-v8a but arm64 Chrome
# crashes under NDK translation, so the x86_64 build is mandatory.
#
# The APKs are the build INPUT (see README.md — provenance + SHA-256 +
# signature-cert verification); they are gitignored, not committed. They are
# installed onto the emulator AFTER it boots (no adb device exists at build
# time) by install-chrome.sh, which the Kubernetes Deployment invokes via a
# postStart lifecycle hook.
COPY chrome/ /opt/chrome/
COPY install-chrome.sh /opt/install-chrome.sh
