# Owl Mobile

Owl Mobile is the Android/iOS native-mobile workspace for Owl. The
canonical mobile UI is [ir/mobile.ir.yaml](ir/mobile.ir.yaml), which generates
plain Android and SwiftUI iOS projects under [generated/mobile](generated/mobile).

Android is direct-distribution first. Play upload is optional and is not required
for local builds or release artifacts.

The generated mobile apps include a Remote Setup walkthrough for saving the SSH
target/auth details and stepping through deploy, verify, remote TLS, test email,
and remote mail sync.

- Development context: native-mobile
- License: dual `OWL 3.0 OR AGPL-3.0-or-later`; AGPL use includes the
  additional terms in ../WIZARDRY_ADDENDUM.md.
