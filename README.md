# Owl

Owl is a native mail and messaging app for people who want email and secure
chat in one calm timeline. It keeps your conversations arranged by person or
group, shows which transport each message used, and makes email an explicit
choice instead of an invisible fallback.

Owl is early software. The repository currently builds native macOS, Linux,
Android, and iOS targets, with Android direct distribution as the simplest
mobile path.

## What Owl Does

- Shows email and SimpleX-style secure messages in the same contact timeline.
- Keeps Inbox, People, Groups, Favorites, Archive, and New Senders as first-class
  views.
- Prefers secure SimpleX sending when a contact has a SimpleX path.
- Marks email as an open-lock transport and requires explicitly choosing it.
- Stores mail and messaging data under a local mail root, defaulting to
  `~/mail`.
- Includes remote mail server setup flows for provisioning, verifying, syncing,
  and sending a test message against an SSH target.

## Getting Owl

Release builds are produced by GitHub Actions and attached to tagged
[GitHub releases](https://github.com/andersaamodt/owl/releases):

- macOS: `Owl-macOS`
- Linux: `owl-linux-x86_64`
- Android: `owl-android-debug-apk` for sideloading, plus a release AAB
- iOS: generated Xcode project and unsigned simulator app

Android is direct-distribution first and does not require Google Play Services.
iPhone installation still requires normal Apple signing through TestFlight, ad
hoc, enterprise, or another signed distribution path.

## Data and Transports

Owl defaults to `~/mail` and keeps SimpleX-related files under:

```text
~/mail/.owl/simplex/
~/mail/.system/simplex/
~/mail/.transport/simplex/
```

The local SimpleX hook is `scripts/owl-simplex-local-hook.sh`. Owl can also sync
with a remote Secure Chat daemon over SSH through
`scripts/owl-secure-chat-hook.sh`; hosts and remote commands must be configured
explicitly and are not baked into the repository.

## For Developers

Owl is not a WebView app. The desktop UI is generated from
`app-blueprint/app.ir.yaml`; the mobile workspace is in `owl-mobile` and is generated from
`owl-mobile/app-blueprint/mobile.ir.yaml`.

Generate and validate desktop targets:

```sh
sh scripts/render-native-desktop.sh
sh scripts/validate-native-desktop-ir.sh
```

Generate and validate mobile targets:

```sh
cd owl-mobile
sh scripts/render-native-mobile.sh
sh scripts/validate-native-mobile-ir.sh
```

Run the native contract tests:

```sh
sh .tests/native/run.sh
```

GitHub Actions builds macOS, Linux, Android, and iOS artifacts in
`.github/workflows/native-release.yml`. See `docs/release.md` for release
details.

## License

Owl is dual-licensed under `OWL 3.0 OR AGPL-3.0-or-later`. AGPL use includes
the additional terms in `WIZARDRY_ADDENDUM.md`.
