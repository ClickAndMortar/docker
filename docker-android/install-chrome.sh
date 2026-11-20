#!/bin/bash
# Install the baked, verified Google Chrome 150 (x86_64) + Trichrome Library onto
# the Android emulator once it has finished booting.
#
# Invoked by the Deployment's postStart lifecycle hook (fire-and-forget). The
# emulator only exists at container runtime, so this cannot run at image-build
# time. Idempotent: a no-op if Chrome 150 is already installed (e.g. hook re-run).
# Always exits 0 so a transient failure never kills the pod via a failing hook;
# progress is logged to /tmp/install-chrome.log.
set -u

ADB=/opt/android/platform-tools/adb
CHROME_DIR=/opt/chrome
WANT=150.0.7871.63
LOG=/tmp/install-chrome.log
exec >>"$LOG" 2>&1

log() { echo "[install-chrome $(date -u +%H:%M:%S)] $*"; }
version() { "$ADB" shell dumpsys package com.android.chrome 2>/dev/null | grep -m1 versionName | tr -d ' \r'; }

log "start (want $WANT)"

case "$(version)" in
    *"$WANT"*) log "Chrome $WANT already installed — nothing to do"; exit 0 ;;
esac

# Wait for the emulator to finish booting (cold boot can take a few minutes).
"$ADB" wait-for-device
for _ in $(seq 1 120); do
    [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d ' \r')" = "1" ] && break
    sleep 3
done
log "boot_completed=$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d ' \r')"

# Trichrome Library first (a versioned <static-library> Chrome depends on), then
# the Chrome app splits. -g grants runtime permissions.
if ! "$ADB" install -r -g "$CHROME_DIR/trichrome.apk"; then
    log "ERROR: Trichrome Library install failed"; exit 0
fi
if ! "$ADB" install-multiple -r -g \
    "$CHROME_DIR/base.apk" \
    "$CHROME_DIR/split_chrome.apk" \
    "$CHROME_DIR/split_config.en.apk" \
    "$CHROME_DIR/split_config.fr.apk" \
    "$CHROME_DIR/split_on_demand.apk"; then
    log "ERROR: Chrome splits install failed"; exit 0
fi

log "done — Chrome now $(version)"
exit 0
