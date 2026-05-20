#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
repo_dir=$(CDPATH= cd -- "$test_dir/../.." && pwd -P)
mobile_dir="$repo_dir/owl-mobile"

[ -f "$mobile_dir/wizardry.workspace.conf" ] || {
  printf '%s\n' "Owl Mobile workspace profile missing" >&2
  exit 1
}

grep -F "project_type=native-mobile" "$mobile_dir/wizardry.workspace.conf" >/dev/null
grep -F "targets=android,ios" "$mobile_dir/wizardry.workspace.conf" >/dev/null
grep -F "mobile_ir_path=ir/mobile.ir.yaml" "$mobile_dir/wizardry.workspace.conf" >/dev/null

sh "$mobile_dir/scripts/validate-native-mobile-ir.sh" \
  "$mobile_dir/ir/mobile.ir.yaml" \
  "$mobile_dir/schemas/native-mobile-ir-v1.json" >/dev/null

render_out=$(cd "$mobile_dir" && sh scripts/render-native-mobile.sh)
printf '%s\n' "$render_out" | grep -F "status=ok" >/dev/null

[ -f "$mobile_dir/generated/mobile/android/settings.gradle" ]
[ -f "$mobile_dir/generated/mobile/android/app/src/main/AndroidManifest.xml" ]
[ -f "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" ]
[ -f "$mobile_dir/generated/mobile/ios/project.yml" ]
[ -f "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" ]

grep -F "app.wizardry.owl" "$mobile_dir/generated/mobile/android/app/build.gradle" >/dev/null
grep -F 'android:label="Owl"' "$mobile_dir/generated/mobile/android/app/src/main/AndroidManifest.xml" >/dev/null
grep -F "Inbox" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Remote Setup" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Remote Mail Server" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Save Remote Target" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Deploy Remote Server" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Set Up Remote TLS" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "validPort(String port)" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "name: owl-mobile" "$mobile_dir/generated/mobile/ios/project.yml" >/dev/null
grep -F "PRODUCT_BUNDLE_IDENTIFIER: app.wizardry.owl" "$mobile_dir/generated/mobile/ios/project.yml" >/dev/null
grep -F "Timeline" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F "RemoteSetupStepView" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Section("Remote Mail Server")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Button("Deploy Remote Server")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Button("Set Up Remote TLS")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F "remotePortValid" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F '"deploy_remote_server"' "$mobile_dir/ir/mobile.ir.yaml" >/dev/null
grep -F '"setup_remote_tls"' "$mobile_dir/ir/mobile.ir.yaml" >/dev/null

if grep -R "com.google.android.gms\|play-services" "$mobile_dir/generated/mobile/android" >/dev/null 2>&1; then
  printf '%s\n' "Owl Mobile generated Android project must not depend on Play Services" >&2
  exit 1
fi

printf '%s\n' "native mobile tests passed"
