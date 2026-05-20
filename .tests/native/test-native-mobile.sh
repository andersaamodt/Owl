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
[ -f "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl_mobile/MainActivity.java" ]
[ -f "$mobile_dir/generated/mobile/ios/project.yml" ]
[ -f "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" ]

grep -F "Inbox" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl_mobile/MainActivity.java" >/dev/null
grep -F "Timeline" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null

if grep -R "com.google.android.gms\|play-services" "$mobile_dir/generated/mobile/android" >/dev/null 2>&1; then
  printf '%s\n' "Owl Mobile generated Android project must not depend on Play Services" >&2
  exit 1
fi

printf '%s\n' "native mobile tests passed"
