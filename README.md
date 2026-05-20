# Owl

Owl is the native app implementation of Owl. It is not a Wizardry-hosted WebView app: the canonical desktop UI source is [ir/app.ir.yaml](ir/app.ir.yaml), with generated SwiftUI/AppKit and GTK4 targets under [generated](generated).

## Current Shape

- Native macOS target generated as SwiftUI/AppKit.
- Native Linux target generated as GTK4 C.
- Owl Mobile lives in [owl-mobile](owl-mobile) as the same product's native-mobile
  workspace, with a shared mobile IR generating Android and iOS projects.
- Shared backend bridge at [scripts/owl-backend.sh](scripts/owl-backend.sh).
- Email data is read through the existing Owl backend and the same Owl mail root, defaulting to `~/mail`.
- SimpleX data is file-first under the same mail root:
  - `~/mail/.owl/simplex/threads`
  - `~/mail/.owl/simplex/incoming`
  - `~/mail/.owl/simplex/outbox`
  - `~/mail/.system/simplex`
  - `~/mail/.transport/simplex`
- Owl ships a filesystem SimpleX transport hook at
  `scripts/owl-simplex-local-hook.sh`. It provides a concrete local
  adapter path for end-to-end queue/send/poll/import testing while preserving
  the same hook contract for a real SimpleX network adapter.
- Owl can use `scripts/owl-secure-chat-hook.sh` to sync with a remote
  nostr-blog Secure Chat daemon over SSH. Hostnames and remote command paths
  are explicit configuration, not repository defaults:

```sh
sh scripts/owl-backend.sh configure-secure-chat-transport ~/mail default \
  example.org \
  /srv/example/site/cgi/blog-secure-chat-owl-export \
  /srv/example/site/cgi/blog-secure-chat-owl-send
```

- Remote web server setup is exposed through the native Settings walkthroughs
  and backend `settings-remote-*` actions so Owl can provision, verify, sync,
  and send a test message against an SSH target.

## Unified Messenger Model

Owl renders one contact or group timeline. Email and SimpleX messages are interleaved chronologically and carry transport as a message attribute.

- SimpleX is shown as the preferred closed-lock transport.
- Email is shown as an explicit open-lock transport.
- Inbox cards remain separate while the same messages remain visible in their contact or group timeline.
- Timeline messages that are also in Inbox are decolored and show an `Inbox` pill.
- The composer defaults to SimpleX when a selected contact or group has a SimpleX path.
- Selecting email is explicit and changes the send treatment to the open-lock warning style.
- The backend rejects SimpleX sends when no SimpleX path is bound instead of falling back to email.

## Regeneration

Desktop:

Run:

```sh
sh scripts/render-native-desktop.sh
```

Validation is separate:

```sh
sh scripts/validate-native-desktop-ir.sh
```

Mobile:

```sh
cd owl-mobile
sh scripts/render-native-mobile.sh
sh scripts/validate-native-mobile-ir.sh
```

## Build Notes

- GitHub Actions: `.github/workflows/native-release.yml` builds macOS, Linux,
  Android, and iOS artifacts. Android uploads a sideloadable debug APK and a
  release AAB; Play upload is manual and optional.
- macOS: `swift build` from [generated/macos](generated/macos).
- Linux: build [generated/linux](generated/linux) with Meson on a host with GTK4 development headers.
- Android: build [owl-mobile/generated/mobile/android](owl-mobile/generated/mobile/android)
  with Gradle. The generated app has no Play Services dependency; direct APK
  distribution is the primary path.
- iOS: generate/open [owl-mobile/generated/mobile/ios](owl-mobile/generated/mobile/ios)
  with XcodeGen/Xcode. Device installation still requires Apple signing.

## Tests

```sh
sh .tests/native/run.sh
```

The suite covers the native backend contract, IR safety checks, renderer determinism, generated action coverage, argv-based backend spawning, and the key SimpleX/email UI invariants.

- Development context: native-desktop
- License: pending release decision before the first public push.
