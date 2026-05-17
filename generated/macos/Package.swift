// Generated from ir/app.ir.yaml. Regenerate with scripts/render-native-desktop.sh.
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "owl-native",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(name: "Owl", targets: ["App"])
  ],
  targets: [
    .executableTarget(
      name: "App",
      path: "Sources/App",
      linkerSettings: [
        .linkedFramework("AVKit")
      ]
    )
  ]
)
