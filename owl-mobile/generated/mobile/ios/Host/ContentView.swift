import SwiftUI

struct ContentView: View {
    private let items = [
        "Inbox",
        "Timeline",
        "People",
        "Groups",
        "Settings",
        "Remote Setup",
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
                    TextField("Message", text: $message, axis: .vertical)
                    Button("Send") { message = "" }
                }
                remoteSetupSection
            }
            .navigationTitle("Inbox")
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
                    TextField("user@203.0.113.8", text: $remoteHost)
                        .owlRemoteTargetContentType()
                        .autocorrectionDisabled(true)
                    TextField("~/.ssh/id_ed25519", text: $remoteKeyPath)
                        .autocorrectionDisabled(true)
                    TextField("SSH port", text: $remotePort)
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
                    Toggle("SSH key has password", isOn: $remoteKeyHasPassword)
                    if remoteKeyHasPassword {
                        SecureField("SSH key password", text: $remotePassword)
                        Toggle("Save on this device", isOn: $remoteSavePassword)
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
