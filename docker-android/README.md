# docker-android + modern Chrome

`clickandmortar/docker-android:emulator_14.0-chrome150`

Extends [`budtmo/docker-android:emulator_14.0`](https://hub.docker.com/r/budtmo/docker-android)
(Android 14 / API 34 emulator + Appium 2 + noVNC) by replacing the frozen
**Chrome 113** (May 2023) that ships in the system image with an authentic,
Google-signed **Chrome 150.0.7871.63 (x86_64)**.

Used by Pilot's real-mobile-Chrome automated-test target (Appium, `target=android`);
see the Pilot repo `kubernetes/android/`.

## Why x86_64, and why a separate Trichrome Library

The emulator ABI is `x86_64,arm64-v8a` (arm64 via NDK translation), but arm64
Chrome **crashes on launch** (SIGSEGV in v8/blink) under translation — the
**x86_64** build is mandatory. Modern Chrome uses the **Trichrome** model: the
Chrome `.apkm` bundle carries no native code (no `config.<abi>` split); all of it
lives in a separate, arch-specific **Trichrome Library** (`com.google.android.trichromelibrary`,
a versioned `<static-library>`). So both must be installed, arch-matched and same
version. The Chrome bundle's versionCode is arch-stamped (`787106338` = x86_64;
the arm64 pair is `787106333`).

## Payload provenance & verification (`chrome/`, gitignored)

Downloaded from APKMirror (both `.apkm`/`.apk` are ZIPs of split APKs):

| File in `chrome/` | Source file | versionCode | SHA-256 |
|---|---|---|---|
| `base.apk` + `split_chrome.apk` + `split_config.en.apk` + `split_config.fr.apk` + `split_on_demand.apk` | `com.android.chrome_150.0.7871.63-787106338_25lang_2feat_…apkmirror.com.apkm` | 787106338 | `72c7b86d5f96b2d69cb8af9f50cc26cc30b4f55d2c455cef253194005c6e1c11` |
| `trichrome.apk` | `com.google.android.trichromelibrary_150.0.7871.63-787106338_minAPI29(x86,x86_64)(nodpi)_…apkmirror.com.apk` | 787106338 | `2ed355038f1d301af09a347db40f34ae24657efb6dd54bd946948dc303a7d3b4` |

**Authenticity does not rely on trusting APKMirror.** Verified with `apksigner`
against the emulator's factory Chrome (which ships in Google's system image):

- Chrome `base.apk` signer cert SHA-256 = `f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83`
  (**identical to the factory Chrome**) + Google Play Source Stamp
  `3257d599a49d2c961a471ca9843f59d341a405884583fc087df4237b733bbd6d`.
- The verified Chrome declares `uses-static-library com.google.android.trichromelibrary`
  version `787106338`, certDigest `b6198a8d5689b62b96a0aa3829ce2cc67d59497f78c469f8792b2cd9255490a1`
  — which is exactly the Trichrome Library's signer cert. Chain closed, no external trust.

To re-obtain: download the two files above from APKMirror, then in a shell:

```bash
mkdir -p chrome && cd chrome
unzip -o <chrome-…-787106338…apkm> base.apk split_chrome.apk split_config.en.apk split_config.fr.apk split_on_demand.apk
cp <…trichromelibrary…787106338…(x86,x86_64)…apk> trichrome.apk
# verify signer certs match the digests above (apksigner from any Android build-tools):
apksigner verify --print-certs base.apk    # signer must be f0fd6c5b…60db83
apksigner verify --print-certs trichrome.apk  # signer must be b6198a8d…90a1
```

## Build & push

```bash
make build   # docker build --platform linux/amd64 -t clickandmortar/docker-android:emulator_14.0-chrome150 .
make push    # requires `docker login` as clickandmortar
```

The APKs are installed onto the emulator **after it boots** by `install-chrome.sh`
(the emulator has no adb device at build time). Pilot's Deployment triggers it via
a `postStart` lifecycle hook (fire-and-forget); the script is idempotent and logs
to `/tmp/install-chrome.log` in the pod.
