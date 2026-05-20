#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
project_dir=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
ir_path="$project_dir/ir/mobile.ir.yaml"
schema_path="$project_dir/schemas/native-mobile-ir-v1.json"
generated_root="$project_dir/generated/mobile"
android_dir="$generated_root/android"
ios_dir="$generated_root/ios"
version_file="$project_dir/VERSION"

"$script_dir/validate-native-mobile-ir.sh" "$ir_path" "$schema_path" >/dev/null

app_name=$(jq -r '.app.name' "$ir_path")
app_id=$(jq -r '.app.id' "$ir_path")
package_part=$(printf '%s' "$app_id" | tr '-' '_')
android_package=$(jq -r '.app.android.applicationId // ""' "$ir_path")
[ -n "$android_package" ] || android_package="app.wizardry.generated.$package_part"
android_compile_sdk=$(jq -r '.app.android.compileSdk // 35' "$ir_path")
android_min_sdk=$(jq -r '.app.android.minSdk // 23' "$ir_path")
android_target_sdk=$(jq -r '.app.android.targetSdk // 35' "$ir_path")
ios_bundle=$(jq -r '.app.ios.bundleId // ""' "$ir_path")
[ -n "$ios_bundle" ] || ios_bundle="app.wizardry.generated.$package_part"
ios_deployment_target=$(jq -r '.app.ios.deploymentTarget // "16.0"' "$ir_path")
if [ -f "$version_file" ]; then
  app_version=$(tr -d ' \t\r\n' <"$version_file")
else
  app_version=0.1.0
fi
version_code=$(printf '%s' "$app_version" | cksum | awk '{ print $1 }')
[ -n "$version_code" ] || version_code=1

mkdir -p "$android_dir/app/src/main/java/app/wizardry/generated/$package_part" "$ios_dir/Host"

screen_titles=$(jq -r '.app.screens[].title' "$ir_path")
primary_title=$(printf '%s\n' "$screen_titles" | sed -n '1p')
[ -n "$primary_title" ] || primary_title="$app_name"
android_items=$(jq -r '.app.screens[] | "        items.add(\"" + (.title | gsub("\\\\";"\\\\\\") | gsub("\"";"\\\"")) + "\");"' "$ir_path")
ios_items=$(jq -r '.app.screens[] | "        \"" + (.title | gsub("\\\\";"\\\\\\\\") | gsub("\"";"\\\"")) + "\","' "$ir_path")

cat >"$android_dir/settings.gradle" <<GRADLE
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement { repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS); repositories { google(); mavenCentral() } }
rootProject.name = "$app_id-mobile"
include ':app'
GRADLE

cat >"$android_dir/build.gradle" <<'GRADLE'
plugins {
    id 'com.android.application' version '8.5.2' apply false
}
GRADLE

cat >"$android_dir/app/build.gradle" <<GRADLE
plugins { id 'com.android.application' }

android {
    namespace '$android_package'
    compileSdk $android_compile_sdk

    defaultConfig {
        applicationId '$android_package'
        minSdk $android_min_sdk
        targetSdk $android_target_sdk
        versionCode $version_code
        versionName '$app_version'
    }

    def signingStorePath = System.getenv('ANDROID_SIGNING_KEYSTORE')
    def signingStoreBase64 = System.getenv('ANDROID_SIGNING_KEYSTORE_BASE64')
    if (signingStoreBase64 != null && signingStoreBase64.trim()) {
        def decodedStore = layout.buildDirectory.file('ci-release.keystore').get().asFile
        decodedStore.parentFile.mkdirs()
        decodedStore.bytes = signingStoreBase64.decodeBase64()
        signingStorePath = decodedStore.absolutePath
    }
    def signingStorePassword = System.getenv('ANDROID_SIGNING_STORE_PASSWORD')
    def signingKeyAlias = System.getenv('ANDROID_SIGNING_KEY_ALIAS')
    def signingKeyPassword = System.getenv('ANDROID_SIGNING_KEY_PASSWORD')
    def hasReleaseSigning = signingStorePath != null && signingStorePath.trim() &&
        signingStorePassword != null && signingStorePassword.trim() &&
        signingKeyAlias != null && signingKeyAlias.trim() &&
        signingKeyPassword != null && signingKeyPassword.trim()

    signingConfigs {
        release {
            if (hasReleaseSigning) {
                storeFile file(signingStorePath)
                storePassword signingStorePassword
                keyAlias signingKeyAlias
                keyPassword signingKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig signingConfigs.release
            }
        }
    }
}
GRADLE

cat >"$android_dir/app/src/main/AndroidManifest.xml" <<XML
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application android:theme="@style/AppTheme" android:label="$app_name" android:allowBackup="false" android:supportsRtl="true">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
XML

mkdir -p "$android_dir/app/src/main/res/values"
cat >"$android_dir/app/src/main/res/values/styles.xml" <<'XML'
<resources>
    <style name="AppTheme" parent="android:style/Theme.Material.Light.NoActionBar">
        <item name="android:fontFamily">sans</item>
        <item name="android:windowLightStatusBar">true</item>
        <item name="android:navigationBarColor">#F7F7F2</item>
        <item name="android:colorAccent">#2F6F6A</item>
    </style>
</resources>
XML

cat >"$android_dir/app/src/main/java/app/wizardry/generated/$package_part/MainActivity.java" <<JAVA
package $android_package;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.graphics.Color;
import android.text.InputType;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

public final class MainActivity extends Activity {
    private SharedPreferences prefs;
    private TextView remoteStatus;
    private EditText remoteHost;
    private EditText remoteKey;
    private EditText remotePort;
    private EditText remotePassword;
    private CheckBox remoteHasPassword;
    private CheckBox remoteSavePassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        prefs = getSharedPreferences("owl-mobile", MODE_PRIVATE);

        ScrollView scroll = new ScrollView(this);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(28, 28, 28, 28);
        root.setBackgroundColor(Color.rgb(247, 247, 242));
        scroll.addView(root);

        TextView title = new TextView(this);
        title.setText("$primary_title");
        title.setTextSize(24);
        title.setTextColor(Color.rgb(24, 33, 35));
        root.addView(title, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        TextView screenTitle = sectionTitle("Screens");
        root.addView(screenTitle);
        addScreenRow(root, "Inbox");
        addScreenRow(root, "Timeline");
        addScreenRow(root, "People");
        addScreenRow(root, "Groups");
        addScreenRow(root, "Settings");
        addScreenRow(root, "Remote Setup");

        EditText composer = new EditText(this);
        composer.setHint("Message");
        composer.setSingleLine(false);
        root.addView(composer, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        Button send = new Button(this);
        send.setText("Send");
        root.addView(send, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        addRemoteSetup(root);
        setContentView(scroll);
    }

    private TextView sectionTitle(String label) {
        TextView view = new TextView(this);
        view.setText(label);
        view.setTextSize(18);
        view.setTextColor(Color.rgb(35, 54, 54));
        view.setPadding(0, 28, 0, 8);
        return view;
    }

    private TextView bodyText(String label) {
        TextView view = new TextView(this);
        view.setText(label);
        view.setTextSize(14);
        view.setTextColor(Color.rgb(78, 86, 83));
        view.setPadding(0, 4, 0, 8);
        return view;
    }

    private void addScreenRow(LinearLayout root, String label) {
        TextView row = bodyText(label);
        row.setTextSize(16);
        root.addView(row, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    private EditText field(String hint, String key) {
        EditText edit = new EditText(this);
        edit.setHint(hint);
        edit.setSingleLine(true);
        edit.setText(prefs.getString(key, ""));
        edit.setPadding(0, 4, 0, 4);
        return edit;
    }

    private void addRemoteSetup(LinearLayout root) {
        root.addView(sectionTitle("Remote Mail Server"));
        root.addView(bodyText("Step through the same Owl remote setup flow: save SSH details, save authentication, deploy, verify, set up TLS, send a test email, then check remote mail."));

        remoteHost = field("user@203.0.113.8", "remote.host");
        remoteKey = field("~/.ssh/id_ed25519", "remote.key");
        remotePort = field("SSH port", "remote.port");
        root.addView(remoteHost, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(remoteKey, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(remotePort, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        Button saveTarget = new Button(this);
        saveTarget.setText("Save Remote Target");
        saveTarget.setOnClickListener(v -> saveRemoteTarget());
        root.addView(saveTarget, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        remoteHasPassword = new CheckBox(this);
        remoteHasPassword.setText("SSH key has password");
        remoteHasPassword.setChecked(prefs.getBoolean("remote.hasPassword", false));
        root.addView(remoteHasPassword);

        remotePassword = field("SSH key password", "remote.password");
        remotePassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        root.addView(remotePassword, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        remoteSavePassword = new CheckBox(this);
        remoteSavePassword.setText("Save password on this device");
        remoteSavePassword.setChecked(prefs.getBoolean("remote.savePassword", false));
        root.addView(remoteSavePassword);

        Button saveAuth = new Button(this);
        saveAuth.setText("Save Authentication");
        saveAuth.setOnClickListener(v -> saveRemoteAuth());
        root.addView(saveAuth, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        addWorkflowButton(root, "Deploy Remote Server", "Deploy starts from the saved SSH target. Use desktop Owl for the actual SSH deploy until the mobile backend bridge is available.");
        addWorkflowButton(root, "Verify Remote Setup", "Verification checks Owl binaries, daemon health, SMTP reachability, DNS, and mail folders on the saved target.");
        addWorkflowButton(root, "Set Up Remote TLS", "Remote TLS setup uses Owl's remote certificate flow after DNS points at the mail server.");
        addWorkflowButton(root, "Send Test Email", "The test email step confirms the public route reaches the remote Owl receiver.");
        addWorkflowButton(root, "Check Remote Mail", "Remote sync pulls server mail folders back into local Owl without deleting remote mail.");

        remoteStatus = bodyText(remoteSummary());
        root.addView(remoteStatus, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    private void addWorkflowButton(LinearLayout root, String title, String detail) {
        Button button = new Button(this);
        button.setText(title);
        button.setOnClickListener(v -> setRemoteStatus(title + ": " + detail));
        root.addView(button, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(bodyText(detail));
    }

    private void saveRemoteTarget() {
        String port = normalizedPort();
        if (!validPort(port)) {
            setRemoteStatus("SSH port must be 1-65535.");
            return;
        }
        prefs.edit()
            .putString("remote.host", remoteHost.getText().toString().trim())
            .putString("remote.key", remoteKey.getText().toString().trim())
            .putString("remote.port", port)
            .apply();
        setRemoteStatus("Remote target saved. " + remoteSummary());
    }

    private void saveRemoteAuth() {
        prefs.edit()
            .putBoolean("remote.hasPassword", remoteHasPassword.isChecked())
            .putBoolean("remote.savePassword", remoteSavePassword.isChecked())
            .putString("remote.password", remoteHasPassword.isChecked() ? remotePassword.getText().toString() : "")
            .apply();
        setRemoteStatus("Remote authentication saved. " + remoteSummary());
    }

    private String normalizedPort() {
        String port = remotePort.getText().toString().trim();
        if (port.startsWith(":")) {
            port = port.substring(1);
        }
        return port;
    }

    private boolean validPort(String port) {
        if (port.length() == 0) {
            return true;
        }
        try {
            int parsed = Integer.parseInt(port);
            return parsed >= 1 && parsed <= 65535;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    private String remoteSummary() {
        String host = prefs.getString("remote.host", "");
        String key = prefs.getString("remote.key", "");
        String port = prefs.getString("remote.port", "");
        if (host.length() == 0 || key.length() == 0) {
            return "Set host and SSH key, then deploy.";
        }
        return "Target: " + host + (port.length() == 0 ? "" : " - SSH port: " + port);
    }

    private void setRemoteStatus(String text) {
        if (remoteStatus != null) {
            remoteStatus.setText(text);
        }
    }
}
JAVA

cat >"$ios_dir/project.yml" <<YAML
name: $app_id-mobile
options:
  bundleIdPrefix: app.wizardry.generated
targets:
  $app_id:
    type: application
    platform: iOS
    deploymentTarget: "$ios_deployment_target"
    sources:
      - Host
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: $ios_bundle
      INFOPLIST_KEY_CFBundleDisplayName: "$app_name"
      CURRENT_PROJECT_VERSION: "$version_code"
      MARKETING_VERSION: "$app_version"
YAML

cat >"$ios_dir/Host/App.swift" <<SWIFT
import SwiftUI

@main
struct GeneratedNativeMobileApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
SWIFT

cat >"$ios_dir/Host/ContentView.swift" <<SWIFT
import SwiftUI

struct ContentView: View {
    private let items = [
$ios_items
    ]
    @State private var message = ""
    @State private var remoteStatus = "Set host and SSH key, then deploy."
    @AppStorage("remote.host") private var remoteHost = ""
    @AppStorage("remote.keyPath") private var remoteKeyPath = ""
    @AppStorage("remote.port") private var remotePort = ""
    @AppStorage("remote.keyHasPassword") private var remoteKeyHasPassword = false
    @AppStorage("remote.savePassword") private var remoteSavePassword = false
    @AppStorage("remote.password") private var remotePassword = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Screens") {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                }
                Section("Compose") {
                    TextField("Message", text: \$message, axis: .vertical)
                    Button("Send") { message = "" }
                }
                remoteSetupSection
            }
            .navigationTitle("$primary_title")
        }
    }

    private var remoteSetupSection: some View {
        Section("Remote Mail Server") {
            VStack(alignment: .leading, spacing: 10) {
                RemoteSetupStepView(
                    number: 1,
                    title: "SSH Target",
                    detail: remoteTargetReady ? "Remote login and key are ready to save." : "Enter the server login and SSH key.",
                    complete: remoteTargetReady && remotePortValid
                ) {
                    TextField("user@203.0.113.8", text: \$remoteHost)
                        .owlRemoteTargetContentType()
                        .autocorrectionDisabled(true)
                    TextField("~/.ssh/id_ed25519", text: \$remoteKeyPath)
                        .autocorrectionDisabled(true)
                    TextField("SSH port", text: \$remotePort)
                        .owlNumberPadKeyboard()
                    if !remotePortValid {
                        Text("SSH port must be 1-65535.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    Button("Save Remote Target") {
                        saveRemoteTarget()
                    }
                    .disabled(!remotePortValid)
                }

                RemoteSetupStepView(
                    number: 2,
                    title: "SSH Authentication",
                    detail: remoteAuthReady ? "SSH authentication is available for remote actions." : "Enter the SSH key password or use a passwordless key.",
                    complete: remoteAuthReady
                ) {
                    Toggle("SSH key has password", isOn: \$remoteKeyHasPassword)
                    if remoteKeyHasPassword {
                        SecureField("SSH key password", text: \$remotePassword)
                        Toggle("Save on this device", isOn: \$remoteSavePassword)
                    }
                    Button("Save Authentication") {
                        saveRemoteAuth()
                    }
                    .disabled(!remoteTargetReady || !remoteAuthReady)
                }

                RemoteSetupStepView(
                    number: 3,
                    title: "Deploy And Verify",
                    detail: "Deploy Owl to the saved server, then verify receiver health.",
                    complete: false
                ) {
                    Button("Deploy Remote Server") {
                        remoteStatus = "Deploy Remote Server: use the saved SSH target to install Owl, configure the receiver, and enable startup. Mobile stores the setup inputs; desktop Owl runs the SSH deploy bridge."
                    }
                    .disabled(!remoteReadyForActions)
                    Button("Verify Remote Setup") {
                        remoteStatus = "Verify Remote Setup: checks Owl binaries, daemon health, SMTP reachability, DNS, and mail folders for \(remoteSummary)."
                    }
                    .disabled(!remoteReadyForActions)
                }

                RemoteSetupStepView(
                    number: 4,
                    title: "TLS, Test, Sync",
                    detail: "Set up remote TLS, send a test email, then check remote mail.",
                    complete: false
                ) {
                    Button("Set Up Remote TLS") {
                        remoteStatus = "Set Up Remote TLS: uses Owl's remote certificate flow after DNS points at \(remoteHost)."
                    }
                    .disabled(!remoteReadyForActions)
                    Button("Send Test Email") {
                        remoteStatus = "Send Test Email: confirms public delivery reaches the remote Owl receiver."
                    }
                    .disabled(!remoteReadyForActions)
                    Button("Check Remote Mail") {
                        remoteStatus = "Check Remote Mail: pulls remote mail folders into local Owl without deleting remote mail."
                    }
                    .disabled(!remoteReadyForActions)
                }

                Text(remoteStatus)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
            .padding(.vertical, 4)
        }
    }

    private var normalizedRemotePort: String {
        var trimmed = remotePort.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix(":") {
            trimmed.removeFirst()
        }
        return trimmed
    }

    private var remotePortValid: Bool {
        let port = normalizedRemotePort
        guard !port.isEmpty else { return true }
        guard let parsed = Int(port) else { return false }
        return (1...65_535).contains(parsed)
    }

    private var remoteTargetReady: Bool {
        !remoteHost.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !remoteKeyPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var remoteAuthReady: Bool {
        !remoteKeyHasPassword || !remotePassword.isEmpty || remoteSavePassword
    }

    private var remoteReadyForActions: Bool {
        remoteTargetReady && remotePortValid && remoteAuthReady
    }

    private var remoteSummary: String {
        let host = remoteHost.trimmingCharacters(in: .whitespacesAndNewlines)
        let port = normalizedRemotePort
        guard !host.isEmpty else { return "the saved remote target" }
        return port.isEmpty ? host : "\(host) on SSH port \(port)"
    }

    private func saveRemoteTarget() {
        remotePort = normalizedRemotePort
        remoteStatus = "Remote target saved. Target: \(remoteSummary)."
    }

    private func saveRemoteAuth() {
        if !remoteKeyHasPassword {
            remotePassword = ""
            remoteSavePassword = false
        }
        remoteStatus = "Remote authentication saved."
    }
}

private struct RemoteSetupStepView<Content: View>: View {
    let number: Int
    let title: String
    let detail: String
    let complete: Bool
    let content: Content

    init(number: Int, title: String, detail: String, complete: Bool, @ViewBuilder content: () -> Content) {
        self.number = number
        self.title = title
        self.detail = detail
        self.complete = complete
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(number)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(complete ? .green : .accentColor)
                    .frame(width: 22, height: 22)
                    .background(Circle().fill((complete ? Color.green : Color.accentColor).opacity(0.12)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            content
                .padding(.leading, 30)
        }
        .padding(.vertical, 6)
    }
}

private extension View {
    @ViewBuilder
    func owlRemoteTargetContentType() -> some View {
#if os(iOS)
        self.textContentType(.URL)
#else
        if #available(macOS 14.0, *) {
            self.textContentType(.URL)
        } else {
            self
        }
#endif
    }

    @ViewBuilder
    func owlNumberPadKeyboard() -> some View {
#if os(iOS)
        self.keyboardType(.numberPad)
#else
        self
#endif
    }
}
SWIFT

cat >"$generated_root/README.md" <<README
# $app_name Mobile Build

Generated from \`ir/mobile.ir.yaml\`.

- Android output is a plain Gradle Android project with no Play Services dependency.
- Android direct distribution is the primary release route; Play upload is optional.
- iOS output is a SwiftUI project generated through XcodeGen.
- Remote Setup is generated as native Android and SwiftUI controls so mobile users can save the SSH target/auth details and follow the same deploy, verify, TLS, test, and sync workflow.
README

printf 'status=ok\n'
printf 'ir=%s\n' "$ir_path"
printf 'android=%s\n' "$android_dir"
printf 'ios=%s\n' "$ios_dir"
