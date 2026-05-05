# Owl Native

Owl Native is the native-desktop conversion of Owl. It is not a Wizardry-hosted WebView app: the canonical UI source is [ir/app.ir.yaml](ir/app.ir.yaml), with generated SwiftUI/AppKit and GTK4 targets under [generated](generated).

## Current Shape

- Native macOS target generated as SwiftUI/AppKit.
- Native Linux target generated as GTK4 C.
- Shared backend bridge at [scripts/owl-native-backend.sh](scripts/owl-native-backend.sh).
- Email data is read through the existing Owl backend and the same Owl mail root, defaulting to `~/mail`.
- SimpleX data is file-first under the same mail root:
  - `~/mail/.owl-native/simplex/threads`
  - `~/mail/.owl-native/simplex/incoming`
  - `~/mail/.owl-native/simplex/outbox`
  - `~/mail/.system/simplex`
  - `~/mail/.transport/simplex`
- Owl Native ships a filesystem SimpleX transport hook at
  `scripts/owl-native-simplex-local-hook.sh`. It provides a concrete local
  adapter path for end-to-end queue/send/poll/import testing while preserving
  the same hook contract for a real SimpleX network adapter.
- For `new.andersaamodt.com` Secure Chat, Owl Native can use
  `scripts/owl-native-secure-chat-hook.sh`. It pulls website Secure Chat
  messages over SSH from the production daemon into Owl's file-backed SimpleX
  inbox and sends replies back through the same daemon-owned SimpleX identity.
  Configure it with:

```sh
sh scripts/owl-native-backend.sh configure-secure-chat-transport ~/mail default
```

## Unified Messenger Model

Owl Native renders one contact or group timeline. Email and SimpleX messages are interleaved chronologically and carry transport as a message attribute.

- SimpleX is shown as the preferred closed-lock transport.
- Email is shown as an explicit open-lock transport.
- Inbox cards remain separate while the same messages remain visible in their contact or group timeline.
- Timeline messages that are also in Inbox are decolored and show an `Inbox` pill.
- The composer defaults to SimpleX when a selected contact or group has a SimpleX path.
- Selecting email is explicit and changes the send treatment to the open-lock warning style.
- The backend rejects SimpleX sends when no SimpleX path is bound instead of falling back to email.

## Regeneration

Run:

```sh
sh scripts/render-native-desktop.sh
```

Validation is separate:

```sh
sh scripts/validate-native-desktop-ir.sh
```

## Build Notes

- macOS: `swift build` from [generated/macos](generated/macos).
- Linux: build [generated/linux](generated/linux) with Meson on a host with GTK4 development headers.

## Tests

```sh
sh .tests/native/run.sh
```

The suite covers the native backend contract, IR safety checks, renderer determinism, generated action coverage, argv-based backend spawning, and the key SimpleX/email UI invariants.

- Development context: native-desktop
- License: GNU AGPL-3.0-or-later
- Additional terms: see [WIZARDRY_ADDENDUM.md](WIZARDRY_ADDENDUM.md)
