# Owl Mobile Build

Generated from `ir/mobile.ir.yaml`.

- Android output is a plain Gradle Android project with no Play Services dependency.
- Android direct distribution is the primary release route; Play upload is optional.
- iOS output is a SwiftUI project generated through XcodeGen.
- Remote Setup is generated as native Android and SwiftUI controls so mobile users can save the SSH target/auth details and follow the same deploy, verify, TLS, test, and sync workflow.
