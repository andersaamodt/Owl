# Owl Mobile

Owl Mobile is the Android/iOS native-mobile workspace for Owl. The
canonical mobile UI is [app-blueprint/mobile.ir.yaml](app-blueprint/mobile.ir.yaml), which generates
plain Android and SwiftUI iOS projects under [generated/mobile](generated/mobile).

Android is direct-distribution first. Play upload is optional and is not required
for local builds or release artifacts.

The generated mobile apps include a Remote Setup walkthrough and backend bridge
client for saving the SSH target/auth details and running the same deploy,
verify, remote TLS, test email, and remote mail sync actions from mobile.
The bridge endpoint can be backed by [scripts/owl-mobile-backend-bridge.sh](../scripts/owl-mobile-backend-bridge.sh),
which dispatches the same allowlisted Owl backend actions used by the desktop app.

- Development context: native-mobile
- License: dual `OWL 3.1 OR AGPL-3.0-or-later`; AGPL use includes the
  additional terms in ../WIZARDRY_ADDENDUM.md.
