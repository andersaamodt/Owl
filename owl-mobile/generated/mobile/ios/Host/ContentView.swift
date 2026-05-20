import SwiftUI

struct ContentView: View {
    private let items = [
        "Inbox",
        "Timeline",
        "People",
        "Groups",
        "Settings",
    ]
    @State private var message = ""

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
            }
            .navigationTitle("Inbox")
        }
    }
}
