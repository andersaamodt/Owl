#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
repo_dir=$(CDPATH= cd -- "$test_dir/../.." && pwd -P)
mobile_dir="$repo_dir/owl-mobile"
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/owl-mobile-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
expected_version=$(tr -d ' \t\r\n' <"$mobile_dir/VERSION")

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
grep -F "versionName '$expected_version'" "$mobile_dir/generated/mobile/android/app/build.gradle" >/dev/null
grep -F "MARKETING_VERSION: \"$expected_version\"" "$mobile_dir/generated/mobile/ios/project.yml" >/dev/null
version_code=$(awk '/versionCode/ {print $2; exit}' "$mobile_dir/generated/mobile/android/app/build.gradle")
[ "$version_code" -gt 0 ] && [ "$version_code" -le 2100000000 ]
grep -F 'android:label="Owl"' "$mobile_dir/generated/mobile/android/app/src/main/AndroidManifest.xml" >/dev/null
grep -F "Inbox" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Remote Setup" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Remote Mail Server" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Save Backend Bridge" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Save Remote Target" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Deploy Remote Server" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "Set Up Remote TLS" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "HttpURLConnection" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "settings-remote-deploy" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "settings-remote-set-target" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "validPort(String port)" "$mobile_dir/generated/mobile/android/app/src/main/java/app/wizardry/generated/owl/MainActivity.java" >/dev/null
grep -F "name: owl-mobile" "$mobile_dir/generated/mobile/ios/project.yml" >/dev/null
grep -F "PRODUCT_BUNDLE_IDENTIFIER: app.wizardry.owl" "$mobile_dir/generated/mobile/ios/project.yml" >/dev/null
grep -F "Timeline" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F "RemoteSetupStepView" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Section("Remote Mail Server")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Button("Save Backend Bridge")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Button("Deploy Remote Server")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'Button("Set Up Remote TLS")' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F "URLSession.shared.data" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'action: "settings-remote-deploy"' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F 'action: "settings-remote-set-target"' "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F "remotePortValid" "$mobile_dir/generated/mobile/ios/Host/ContentView.swift" >/dev/null
grep -F '"save_remote_bridge"' "$mobile_dir/ir/mobile.ir.yaml" >/dev/null
grep -F '"deploy_remote_server"' "$mobile_dir/ir/mobile.ir.yaml" >/dev/null
grep -F '"setup_remote_tls"' "$mobile_dir/ir/mobile.ir.yaml" >/dev/null

[ -x "$repo_dir/scripts/owl-mobile-backend-bridge.sh" ]
grep -F "settings-remote-deploy" "$repo_dir/scripts/owl-mobile-backend-bridge.sh" >/dev/null
invalid_bridge_out=$(printf '%s\n' '{"action":"not-allowed","args":[]}' | "$repo_dir/scripts/owl-mobile-backend-bridge.sh")
printf '%s\n' "$invalid_bridge_out" | jq -e '.ok == false' >/dev/null
printf '%s\n' "$invalid_bridge_out" | grep -F 'unsupported mobile backend action' >/dev/null
fake_backend="$tmpdir/backend"
cat >"$fake_backend" <<'SH'
#!/bin/sh
set -eu
jq -n --arg action "$1" --arg root "$2" --arg a1 "${3-}" --arg a2 "${4-}" '{ok:true,action:$action,root:$root,args:[$a1,$a2]}'
SH
chmod +x "$fake_backend"
bridge_out=$(printf '%s\n' '{"action":"settings-remote-deploy","root":"/tmp/owl mail","args":["user@example.org","key path"]}' | OWL_NATIVE_BACKEND="$fake_backend" "$repo_dir/scripts/owl-mobile-backend-bridge.sh")
printf '%s\n' "$bridge_out" | jq -e '.ok == true and .action == "settings-remote-deploy" and .root == "/tmp/owl mail" and .args[0] == "user@example.org" and .args[1] == "key path"' >/dev/null

if grep -R "desktop Owl runs the SSH deploy bridge\\|Use desktop Owl" "$mobile_dir/generated/mobile" >/dev/null 2>&1; then
  printf '%s\n' "Owl Mobile remote setup must not delegate deploy capability back to desktop Owl" >&2
  exit 1
fi

if grep -R "com.google.android.gms\|play-services" "$mobile_dir/generated/mobile/android" >/dev/null 2>&1; then
  printf '%s\n' "Owl Mobile generated Android project must not depend on Play Services" >&2
  exit 1
fi

printf '%s\n' "native mobile tests passed"
