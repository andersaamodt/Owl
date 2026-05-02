// Generated from ir/app.ir.yaml. Regenerate with scripts/render-native-desktop.sh.
import AppKit
import Foundation
import SwiftUI

private let canonicalIR = #"""
{
  "version": "native-desktop-ir/v1",
  "format": "yaml-1.2-json-compatible",
  "app": {
    "id": "owl-native",
    "name": "Owl Native",
    "targets": [
      "macos",
      "linux"
    ],
    "actions": [
      {
        "id": "refresh_snapshot",
        "title": "Refresh"
      },
      {
        "id": "focus_inbox",
        "title": "Inbox"
      },
      {
        "id": "focus_favorites",
        "title": "Favorites"
      },
      {
        "id": "focus_people",
        "title": "People"
      },
      {
        "id": "focus_groups",
        "title": "Groups"
      },
      {
        "id": "send_message",
        "title": "Send Message"
      },
      {
        "id": "archive_message",
        "title": "Remove From Inbox"
      },
      {
        "id": "delete_message",
        "title": "Delete"
      },
      {
        "id": "toggle_star",
        "title": "Star"
      },
      {
        "id": "mark_read",
        "title": "Mark Read"
      },
      {
        "id": "open_settings",
        "title": "Settings"
      },
      {
        "id": "choose_mail_root",
        "title": "Choose Mail Root"
      },
      {
        "id": "install_simplex_cli",
        "title": "Install SimpleX CLI"
      },
      {
        "id": "provision_simplex_identity",
        "title": "Provision SimpleX Identity"
      },
      {
        "id": "tick_simplex",
        "title": "Check SimpleX"
      },
      {
        "id": "bind_contact",
        "title": "Bind Contact"
      },
      {
        "id": "compose_simplex",
        "title": "Use SimpleX"
      },
      {
        "id": "compose_email",
        "title": "Use Email"
      },
      {
        "id": "quit_app",
        "title": "Quit"
      }
    ],
    "state": {
      "mailRoot": "~/mail",
      "selectedRoute": "inbox",
      "selectedTransport": "simplex"
    },
    "window": {
      "id": "window.main",
      "name": "mainWindow",
      "type": "Window",
      "title": "Owl Native",
      "width": 128,
      "minWidth": 96,
      "height": 82,
      "minHeight": 58,
      "menuBar": {
        "id": "menubar.main",
        "type": "MenuBar",
        "children": [
          {
            "id": "menu.app",
            "type": "Menu",
            "title": "Owl Native",
            "children": [
              {
                "id": "menuitem.refresh",
                "type": "MenuItem",
                "title": "Refresh",
                "action": "refresh_snapshot",
                "shortcut": "cmd+r"
              },
              {
                "id": "menuitem.settings",
                "type": "MenuItem",
                "title": "Settings",
                "action": "open_settings",
                "shortcut": "cmd+,"
              },
              {
                "id": "menuitem.quit",
                "type": "MenuItem",
                "title": "Quit",
                "action": "quit_app",
                "shortcut": "cmd+q"
              }
            ]
          },
          {
            "id": "menu.view",
            "type": "Menu",
            "title": "View",
            "children": [
              {
                "id": "menuitem.inbox",
                "type": "MenuItem",
                "title": "Inbox",
                "action": "focus_inbox",
                "shortcut": "cmd+1"
              },
              {
                "id": "menuitem.favorites",
                "type": "MenuItem",
                "title": "Favorites",
                "action": "focus_favorites",
                "shortcut": "cmd+2"
              },
              {
                "id": "menuitem.people",
                "type": "MenuItem",
                "title": "People",
                "action": "focus_people",
                "shortcut": "cmd+3"
              },
              {
                "id": "menuitem.groups",
                "type": "MenuItem",
                "title": "Groups",
                "action": "focus_groups",
                "shortcut": "cmd+4"
              }
            ]
          },
          {
            "id": "menu.transport",
            "type": "Menu",
            "title": "Transport",
            "children": [
              {
                "id": "menuitem.simplex",
                "type": "MenuItem",
                "title": "Compose With SimpleX",
                "action": "compose_simplex"
              },
              {
                "id": "menuitem.email",
                "type": "MenuItem",
                "title": "Compose With Email",
                "action": "compose_email"
              },
              {
                "id": "menuitem.tickSimplex",
                "type": "MenuItem",
                "title": "Check SimpleX",
                "action": "tick_simplex"
              }
            ]
          }
        ]
      },
      "toolbar": {
        "id": "toolbar.main",
        "type": "Toolbar",
        "children": [
          {
            "id": "toolbar.refresh",
            "type": "Button",
            "title": "Refresh",
            "action": "refresh_snapshot"
          },
          {
            "id": "toolbar.inbox",
            "type": "Button",
            "title": "Inbox",
            "action": "focus_inbox"
          },
          {
            "id": "toolbar.spacer",
            "type": "Spacer"
          },
          {
            "id": "toolbar.simplex",
            "type": "Button",
            "title": "Check SimpleX",
            "action": "tick_simplex"
          },
          {
            "id": "toolbar.settings",
            "type": "Button",
            "title": "Settings",
            "action": "open_settings"
          }
        ]
      },
      "content": {
        "id": "content.main",
        "type": "Content",
        "child": {
          "id": "split.messenger",
          "type": "Split",
          "children": [
            {
              "id": "sidebar.contacts",
              "type": "Sidebar",
              "children": [
                {
                  "id": "list.inbox",
                  "type": "List",
                  "title": "Inbox",
                  "action": "focus_inbox"
                },
                {
                  "id": "list.favorites",
                  "type": "List",
                  "title": "Favorites",
                  "action": "focus_favorites"
                },
                {
                  "id": "list.people",
                  "type": "List",
                  "title": "People",
                  "action": "focus_people"
                },
                {
                  "id": "list.groups",
                  "type": "List",
                  "title": "Groups",
                  "action": "focus_groups"
                }
              ]
            },
            {
              "id": "detail.timeline",
              "type": "Detail",
              "children": [
                {
                  "id": "section.timeline",
                  "type": "Section",
                  "title": "Timeline"
                },
                {
                  "id": "form.compose",
                  "type": "Form",
                  "title": "Compose"
                },
                {
                  "id": "select.transport",
                  "type": "Select",
                  "title": "Transport",
                  "action": "compose_simplex"
                },
                {
                  "id": "button.send",
                  "type": "Button",
                  "title": "Send",
                  "action": "send_message"
                }
              ]
            }
          ]
        }
      },
      "statusBar": {
        "id": "statusbar.main",
        "type": "StatusBar",
        "children": [
          {
            "id": "statusbar.backend",
            "type": "Text",
            "style": "caption",
            "value": "Owl mail root: ~/mail"
          },
          {
            "id": "statusbar.transport",
            "type": "Text",
            "style": "caption",
            "value": "SimpleX preferred when available"
          }
        ]
      }
    },
    "mock": {
      "contacts": [
        {
          "id": "alice-ledger",
          "kind": "person",
          "name": "Alice Ledger",
          "email": "alice@example.org",
          "simplex_address": "simplex://alice-ledger",
          "favorite": true
        },
        {
          "id": "river-stone",
          "kind": "group",
          "name": "River Stone",
          "email": "",
          "simplex_address": "simplex://river-stone",
          "favorite": true
        }
      ],
      "messages": [
        {
          "id": "seed-email-1",
          "thread_id": "alice-ledger",
          "transport": "email",
          "lock": "open",
          "subject": "Longer email-style note",
          "body": "This is a longer email-shaped message rendered in the same continuous contact timeline as short chat messages.",
          "received_at": "2026-04-20T10:00:00Z",
          "in_inbox": true,
          "from_self": false
        },
        {
          "id": "seed-simplex-1",
          "thread_id": "alice-ledger",
          "transport": "simplex",
          "lock": "closed",
          "subject": "",
          "body": "Short secure reply.",
          "received_at": "2026-04-20T10:03:00Z",
          "in_inbox": false,
          "from_self": true
        }
      ]
    }
  },
  "extensions": []
}
"""#

private let generatedAppName = "Owl Native"
private let generatedAppID = "owl-native"
private let generatedAppVersion = "0.1.0"

@main
private enum OwlNativeGeneratedApp {
  @MainActor private static var appDelegate: OwlNativeAppDelegate?

  @MainActor
  static func main() {
    let app = NSApplication.shared
    let delegate = OwlNativeAppDelegate()
    appDelegate = delegate
    app.delegate = delegate
    app.setActivationPolicy(.regular)
    app.run()
  }
}

@MainActor
private final class OwlNativeAppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
  private let session = OwlSession()
  private var window: NSWindow?
  private var settingsWindow: NSWindow?

  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.mainMenu = makeMainMenu()
    showMainWindow()
    activateApplication()
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    showMainWindow()
    return true
  }

  private func showMainWindow() {
    if let window {
      window.makeKeyAndOrderFront(nil)
      activateApplication()
      return
    }

    let rootView = RootView()
      .environmentObject(session)
      .frame(minWidth: 920, minHeight: 620)
    let hostingView = NSHostingView(rootView: rootView)
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 1180, height: 760),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )
    window.title = "Owl Native"
    window.contentView = hostingView
    window.isReleasedWhenClosed = false
    window.delegate = self
    window.center()
    window.makeKeyAndOrderFront(nil)
    self.window = window
  }

  @objc func showSettingsWindow(_ sender: Any?) {
    if let settingsWindow {
      settingsWindow.makeKeyAndOrderFront(nil)
      activateApplication()
      return
    }

    let settingsView = SettingsView()
      .environmentObject(session)
      .frame(width: 540)
      .padding(20)
    let hostingView = NSHostingView(rootView: settingsView)
    let settingsWindow = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 620, height: 520),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )
    settingsWindow.title = "Settings"
    settingsWindow.contentView = hostingView
    settingsWindow.isReleasedWhenClosed = false
    settingsWindow.delegate = self
    settingsWindow.center()
    settingsWindow.makeKeyAndOrderFront(nil)
    self.settingsWindow = settingsWindow
    activateApplication()
  }

  private func makeMainMenu() -> NSMenu {
    let mainMenu = NSMenu()

    let appMenuItem = NSMenuItem()
    let appMenu = NSMenu(title: generatedAppName)
    appMenu.addItem(NSMenuItem(title: "About \(generatedAppName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
    appMenu.addItem(.separator())
    appMenu.addItem(actionItem("Settings...", action: "open_settings", key: ",", modifiers: [.command]))
    appMenu.addItem(.separator())
    appMenu.addItem(actionItem("Quit \(generatedAppName)", action: "quit_app", key: "q", modifiers: [.command]))
    appMenuItem.submenu = appMenu
    mainMenu.addItem(appMenuItem)

    let owlMenuItem = NSMenuItem()
    let owlMenu = NSMenu(title: "Owl")
    owlMenu.addItem(actionItem("Refresh", action: "refresh_snapshot", key: "r", modifiers: [.command]))
    owlMenu.addItem(actionItem("Check SimpleX", action: "tick_simplex"))
    owlMenuItem.submenu = owlMenu
    mainMenu.addItem(owlMenuItem)

    let mailboxMenuItem = NSMenuItem()
    let mailboxMenu = NSMenu(title: "Mailbox")
    mailboxMenu.addItem(actionItem("Inbox", action: "focus_inbox", key: "1", modifiers: [.command]))
    mailboxMenu.addItem(actionItem("Favorites", action: "focus_favorites", key: "2", modifiers: [.command]))
    mailboxMenu.addItem(actionItem("People", action: "focus_people", key: "3", modifiers: [.command]))
    mailboxMenu.addItem(actionItem("Groups", action: "focus_groups", key: "4", modifiers: [.command]))
    mailboxMenuItem.submenu = mailboxMenu
    mainMenu.addItem(mailboxMenuItem)

    let transportMenuItem = NSMenuItem()
    let transportMenu = NSMenu(title: "Transport")
    transportMenu.addItem(actionItem("Use SimpleX", action: "compose_simplex"))
    transportMenu.addItem(actionItem("Use Email", action: "compose_email"))
    transportMenuItem.submenu = transportMenu
    mainMenu.addItem(transportMenuItem)

    return mainMenu
  }

  private func actionItem(_ title: String, action: String, key: String = "", modifiers: NSEvent.ModifierFlags = []) -> NSMenuItem {
    let item = NSMenuItem(title: title, action: #selector(performMenuAction(_:)), keyEquivalent: key)
    item.target = self
    item.representedObject = action
    item.keyEquivalentModifierMask = modifiers
    return item
  }

  @objc private func performMenuAction(_ sender: NSMenuItem) {
    if let action = sender.representedObject as? String {
      session.perform(action: action)
    }
  }

  func windowWillClose(_ notification: Notification) {
    guard let closedWindow = notification.object as? NSWindow else { return }
    if closedWindow == settingsWindow {
      settingsWindow = nil
    }
    if closedWindow == window {
      window = nil
    }
  }

  private func activateApplication() {
    NSRunningApplication.current.activate(options: [.activateAllWindows])
  }
}

private enum Transport: String, CaseIterable, Identifiable, Sendable {
  case simplex
  case email

  var id: String { rawValue }
  var label: String { self == .simplex ? "SimpleX" : "Email" }
  var symbol: String { self == .simplex ? "lock.fill" : "lock.open" }
}

private struct Snapshot: Decodable, Sendable {
  var ok: Bool
  var root: String
  var inbox: [MessageItem]
  var favorites: [ThreadItem]
  var individuals: [ThreadItem]
  var groups: [ThreadItem]
  var threads: [ThreadItem]
  var messages: [MessageItem]
  var overview: Overview
  var simplex: SimpleXSnapshot

  init(
    ok: Bool = true,
    root: String = "~/mail",
    inbox: [MessageItem] = [],
    favorites: [ThreadItem] = [],
    individuals: [ThreadItem] = [],
    groups: [ThreadItem] = [],
    threads: [ThreadItem] = [],
    messages: [MessageItem] = [],
    overview: Overview = Overview(),
    simplex: SimpleXSnapshot = SimpleXSnapshot()
  ) {
    self.ok = ok
    self.root = root
    self.inbox = inbox
    self.favorites = favorites
    self.individuals = individuals
    self.groups = groups
    self.threads = threads
    self.messages = messages
    self.overview = overview
    self.simplex = simplex
  }

  private enum CodingKeys: String, CodingKey {
    case ok, root, inbox, favorites, individuals, groups, threads, messages, overview, simplex
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    ok = try values.decodeIfPresent(Bool.self, forKey: .ok) ?? true
    root = try values.decodeIfPresent(String.self, forKey: .root) ?? "~/mail"
    inbox = try values.decodeIfPresent([MessageItem].self, forKey: .inbox) ?? []
    favorites = try values.decodeIfPresent([ThreadItem].self, forKey: .favorites) ?? []
    individuals = try values.decodeIfPresent([ThreadItem].self, forKey: .individuals) ?? []
    groups = try values.decodeIfPresent([ThreadItem].self, forKey: .groups) ?? []
    threads = try values.decodeIfPresent([ThreadItem].self, forKey: .threads) ?? []
    messages = try values.decodeIfPresent([MessageItem].self, forKey: .messages) ?? []
    overview = try values.decodeIfPresent(Overview.self, forKey: .overview) ?? Overview()
    simplex = try values.decodeIfPresent(SimpleXSnapshot.self, forKey: .simplex) ?? SimpleXSnapshot()
  }
}

private struct Overview: Decodable, Sendable {
  var counts: OverviewCounts

  init(counts: OverviewCounts = OverviewCounts()) {
    self.counts = counts
  }

  private enum CodingKeys: String, CodingKey { case counts }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    counts = try values.decodeIfPresent(OverviewCounts.self, forKey: .counts) ?? OverviewCounts()
  }
}

private struct OverviewCounts: Decodable, Sendable {
  var inbox_messages: Int = 0
  var new_messages: Int = 0
  var archive_messages: Int = 0
  var trash_messages: Int = 0
  var drafts: Int = 0
  var sent: Int = 0
}

private struct SimpleXSnapshot: Decodable, Sendable {
  var install_state: String
  var system_root: String
  var incoming_dir: String
  var outbox_dir: String

  init(install_state: String = "unknown", system_root: String = "", incoming_dir: String = "", outbox_dir: String = "") {
    self.install_state = install_state
    self.system_root = system_root
    self.incoming_dir = incoming_dir
    self.outbox_dir = outbox_dir
  }
}

private struct SimpleXBootstrap: Decodable, Sendable {
  var ok: Bool
  var supported: Bool
  var install_state: String
  var version: String
  var binary_path: String
  var profile_prefix: String
  var profile_ready: Bool
  var last_error: String

  init(
    ok: Bool = true,
    supported: Bool = false,
    install_state: String = "unknown",
    version: String = "",
    binary_path: String = "",
    profile_prefix: String = "",
    profile_ready: Bool = false,
    last_error: String = ""
  ) {
    self.ok = ok
    self.supported = supported
    self.install_state = install_state
    self.version = version
    self.binary_path = binary_path
    self.profile_prefix = profile_prefix
    self.profile_ready = profile_ready
    self.last_error = last_error
  }
}

private struct ThreadItem: Identifiable, Decodable, Hashable, Sendable {
  var id: String
  var kind: String
  var name: String
  var email: String
  var simplex_address: String
  var favorite: Bool
  var group: String
  var unread_count: Int
  var latest_at: String
  var messages: [MessageItem]

  var hasSimpleXPath: Bool { !simplex_address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
  var hasEmailPath: Bool { !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
  var displayName: String { name.isEmpty ? id : name }

  init(
    id: String,
    kind: String = "person",
    name: String,
    email: String = "",
    simplex_address: String = "",
    favorite: Bool = false,
    group: String = "",
    unread_count: Int = 0,
    latest_at: String = "",
    messages: [MessageItem] = []
  ) {
    self.id = id
    self.kind = kind
    self.name = name
    self.email = email
    self.simplex_address = simplex_address
    self.favorite = favorite
    self.group = group
    self.unread_count = unread_count
    self.latest_at = latest_at
    self.messages = messages
  }

  private enum CodingKeys: String, CodingKey {
    case id, kind, name, email, simplex_address, favorite, group, unread_count, latest_at, messages
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(String.self, forKey: .id) ?? "unknown"
    kind = try values.decodeIfPresent(String.self, forKey: .kind) ?? "person"
    name = try values.decodeIfPresent(String.self, forKey: .name) ?? id
    email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
    simplex_address = try values.decodeIfPresent(String.self, forKey: .simplex_address) ?? ""
    favorite = try values.decodeIfPresent(Bool.self, forKey: .favorite) ?? false
    group = try values.decodeIfPresent(String.self, forKey: .group) ?? ""
    unread_count = try values.decodeIfPresent(Int.self, forKey: .unread_count) ?? 0
    latest_at = try values.decodeIfPresent(String.self, forKey: .latest_at) ?? ""
    messages = try values.decodeIfPresent([MessageItem].self, forKey: .messages) ?? []
  }
}

private struct MessageItem: Identifiable, Decodable, Hashable, Sendable {
  var id: String
  var backend_kind: String
  var transport: String
  var lock: String
  var thread_id: String
  var contact_name: String
  var contact_kind: String
  var email: String
  var simplex_address: String
  var list: String
  var sender: String
  var ulid: String
  var subject: String
  var body: String
  var preview: String
  var received_at: String
  var from_self: Bool
  var in_inbox: Bool
  var read: Bool
  var starred: Bool
  var attachments: Int

  var isSimpleX: Bool { transport == "simplex" }
  var isEmail: Bool { transport == "email" }
  var isLongBlock: Bool { isEmail || body.count > 180 || subject.count > 0 }
  var displayBody: String { body.isEmpty ? preview : body }

  init(
    id: String,
    backend_kind: String,
    transport: String,
    lock: String,
    thread_id: String,
    contact_name: String,
    contact_kind: String = "person",
    email: String = "",
    simplex_address: String = "",
    list: String = "",
    sender: String = "",
    ulid: String = "",
    subject: String = "",
    body: String = "",
    preview: String = "",
    received_at: String = "",
    from_self: Bool = false,
    in_inbox: Bool = false,
    read: Bool = false,
    starred: Bool = false,
    attachments: Int = 0
  ) {
    self.id = id
    self.backend_kind = backend_kind
    self.transport = transport
    self.lock = lock
    self.thread_id = thread_id
    self.contact_name = contact_name
    self.contact_kind = contact_kind
    self.email = email
    self.simplex_address = simplex_address
    self.list = list
    self.sender = sender
    self.ulid = ulid
    self.subject = subject
    self.body = body
    self.preview = preview
    self.received_at = received_at
    self.from_self = from_self
    self.in_inbox = in_inbox
    self.read = read
    self.starred = starred
    self.attachments = attachments
  }

  private enum CodingKeys: String, CodingKey {
    case id, backend_kind, transport, lock, thread_id, contact_name, contact_kind, email, simplex_address
    case list, sender, ulid, subject, body, preview, received_at, from_self, in_inbox, read, starred, attachments
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
    backend_kind = try values.decodeIfPresent(String.self, forKey: .backend_kind) ?? ""
    transport = try values.decodeIfPresent(String.self, forKey: .transport) ?? "email"
    lock = try values.decodeIfPresent(String.self, forKey: .lock) ?? (transport == "simplex" ? "closed" : "open")
    thread_id = try values.decodeIfPresent(String.self, forKey: .thread_id) ?? "unknown"
    contact_name = try values.decodeIfPresent(String.self, forKey: .contact_name) ?? thread_id
    contact_kind = try values.decodeIfPresent(String.self, forKey: .contact_kind) ?? "person"
    email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
    simplex_address = try values.decodeIfPresent(String.self, forKey: .simplex_address) ?? ""
    list = try values.decodeIfPresent(String.self, forKey: .list) ?? ""
    sender = try values.decodeIfPresent(String.self, forKey: .sender) ?? ""
    ulid = try values.decodeIfPresent(String.self, forKey: .ulid) ?? ""
    subject = try values.decodeIfPresent(String.self, forKey: .subject) ?? ""
    body = try values.decodeIfPresent(String.self, forKey: .body) ?? ""
    preview = try values.decodeIfPresent(String.self, forKey: .preview) ?? ""
    received_at = try values.decodeIfPresent(String.self, forKey: .received_at) ?? ""
    from_self = try values.decodeIfPresent(Bool.self, forKey: .from_self) ?? false
    in_inbox = try values.decodeIfPresent(Bool.self, forKey: .in_inbox) ?? false
    read = try values.decodeIfPresent(Bool.self, forKey: .read) ?? false
    starred = try values.decodeIfPresent(Bool.self, forKey: .starred) ?? false
    attachments = try values.decodeIfPresent(Int.self, forKey: .attachments) ?? 0
  }
}

@MainActor
private final class OwlSession: ObservableObject {
  @Published var snapshot: Snapshot = SeedData.snapshot
  @Published var selectedRoute: String = "inbox"
  @Published var focusedMessageID: String?
  @Published var mailRoot: String = OwlPreferences.mailRoot
  @Published var selectedTransport: Transport = .simplex
  @Published var composeSubject: String = ""
  @Published var composeBody: String = ""
  @Published var statusText: String = "Ready"
  @Published var isBusy: Bool = false
  @Published var bootstrap: SimpleXBootstrap = SimpleXBootstrap()
  @Published var contactDraftName: String = ""
  @Published var contactDraftEmail: String = ""
  @Published var contactDraftSimpleX: String = ""
  @Published var contactDraftFavorite: Bool = false

  init() {
    snapshot = SeedData.snapshot
    mailRoot = OwlPreferences.mailRoot
    selectedRoute = "inbox"
    selectedTransport = .simplex
    Task { refresh() }
  }

  var inboxUnreadCount: Int {
    snapshot.inbox.filter { !$0.read }.count
  }

  var selectedThreadID: String? {
    guard selectedRoute.hasPrefix("thread:") else { return nil }
    return String(selectedRoute.dropFirst("thread:".count))
  }

  var selectedThread: ThreadItem? {
    guard let id = selectedThreadID else { return nil }
    return snapshot.threads.first(where: { $0.id == id })
  }

  var timelineMessages: [MessageItem] {
    selectedThread?.messages ?? []
  }

  var canSend: Bool {
    let bodyReady = !composeBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    guard bodyReady, let thread = selectedThread else { return false }
    switch selectedTransport {
    case .simplex:
      return thread.hasSimpleXPath
    case .email:
      return thread.hasEmailPath
    }
  }

  func refresh() {
    let root = mailRoot
    isBusy = true
    statusText = "Refreshing \(root)"
    Task {
      do {
        let next = try await OwlBackend.snapshot(root: root)
        self.apply(snapshot: next)
        self.statusText = "Loaded \(next.threads.count) conversations from \(next.root)"
        self.isBusy = false
      } catch {
        self.statusText = "Using seed state; backend unavailable: \(error.localizedDescription)"
        self.isBusy = false
      }
    }
    refreshBootstrapStatus()
  }

  func refreshBootstrapStatus() {
    let root = mailRoot
    Task {
      do {
        let next = try await OwlBackend.bootstrapStatus(root: root)
        self.bootstrap = next
      } catch {
        self.bootstrap = SimpleXBootstrap(install_state: "unknown", last_error: error.localizedDescription)
      }
    }
  }

  func apply(snapshot next: Snapshot) {
    snapshot = next
    mailRoot = next.root
    OwlPreferences.mailRoot = next.root
    if selectedRoute != "inbox", selectedThread == nil {
      selectedRoute = "inbox"
    }
    if let thread = selectedThread {
      syncTransportDefault(for: thread)
      loadContactDraft(from: thread)
    }
  }

  func selectThread(_ thread: ThreadItem) {
    selectedRoute = "thread:\(thread.id)"
    focusedMessageID = nil
    syncTransportDefault(for: thread)
    loadContactDraft(from: thread)
  }

  func openTimeline(for message: MessageItem) {
    selectedRoute = "thread:\(message.thread_id)"
    focusedMessageID = message.id
    if let thread = selectedThread {
      syncTransportDefault(for: thread)
      loadContactDraft(from: thread)
    }
  }

  func openInbox(focusing messageID: String?) {
    selectedRoute = "inbox"
    focusedMessageID = messageID
  }

  func syncTransportDefault(for thread: ThreadItem) {
    selectedTransport = thread.hasSimpleXPath ? .simplex : .email
  }

  func loadContactDraft(from thread: ThreadItem) {
    contactDraftName = thread.displayName
    contactDraftEmail = thread.email
    contactDraftSimpleX = thread.simplex_address
    contactDraftFavorite = thread.favorite
  }

  func sendComposedMessage() {
    guard let thread = selectedThread else { return }
    let subject = composeSubject
    let body = composeBody
    let transport = selectedTransport
    let root = mailRoot
    isBusy = true
    statusText = transport == .email ? "Sending by explicit email path..." : "Queueing SimpleX message..."
    Task {
      do {
        _ = try await OwlBackend.send(root: root, threadID: thread.id, transport: transport, subject: subject, body: body)
        self.composeSubject = ""
        self.composeBody = ""
        self.statusText = transport == .email ? "Email sent through Owl outbox." : "SimpleX message queued."
        self.isBusy = false
        self.refresh()
      } catch {
        self.statusText = error.localizedDescription
        self.isBusy = false
      }
    }
  }

  func archive(_ message: MessageItem) {
    let root = mailRoot
    runMessageAction(status: "Removed from Inbox") {
      try await OwlBackend.runJSON(action: "archive-message", root: root, args: [message.id])
    }
  }

  func delete(_ message: MessageItem) {
    let root = mailRoot
    runMessageAction(status: "Deleted message") {
      try await OwlBackend.runJSON(action: "delete-message", root: root, args: [message.id])
    }
  }

  func markRead(_ message: MessageItem, read: Bool) {
    let root = mailRoot
    runMessageAction(status: read ? "Marked read" : "Marked unread") {
      try await OwlBackend.runJSON(action: "mark-read", root: root, args: [message.id, read ? "true" : "false"])
    }
  }

  func runMessageAction(status: String, action: @escaping () async throws -> Data) {
    isBusy = true
    Task {
      do {
        _ = try await action()
        self.statusText = status
        self.isBusy = false
        self.refresh()
      } catch {
        self.statusText = error.localizedDescription
        self.isBusy = false
      }
    }
  }

  func saveContactBinding() {
    guard let thread = selectedThread else { return }
    let root = mailRoot
    let kind = thread.kind == "group" ? "group" : "person"
    let args = [
      thread.id,
      contactDraftName,
      kind,
      contactDraftEmail,
      contactDraftSimpleX,
      contactDraftFavorite ? "yes" : "no"
    ]
    runMessageAction(status: "Contact binding saved") {
      try await OwlBackend.runJSON(action: "bind-contact", root: root, args: args)
    }
  }

  func chooseMailRoot() {
    let panel = NSOpenPanel()
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.canCreateDirectories = true
    panel.allowsMultipleSelection = false
    panel.prompt = "Use Mail Root"
    if panel.runModal() == .OK, let url = panel.url {
      mailRoot = url.path
      OwlPreferences.mailRoot = url.path
      refresh()
    }
  }

  func installSimpleX() {
    let root = mailRoot
    runMessageAction(status: "SimpleX CLI install checked") {
      try await OwlBackend.runJSON(action: "install-simplex-cli", root: root, args: [])
    }
  }

  func provisionSimpleX() {
    let root = mailRoot
    runMessageAction(status: "SimpleX profile provisioned") {
      try await OwlBackend.runJSON(action: "provision-simplex-identity", root: root, args: ["default", "Owl", "Owl Native"])
    }
  }

  func tickSimpleX() {
    let root = mailRoot
    runMessageAction(status: "SimpleX incoming queue checked") {
      try await OwlBackend.runJSON(action: "tick-simplex", root: root, args: [])
    }
  }

  func perform(action: String) {
    switch action {
      case "refresh_snapshot":
        runSymbolicAction("refresh_snapshot")
      case "focus_inbox":
        runSymbolicAction("focus_inbox")
      case "focus_favorites":
        runSymbolicAction("focus_favorites")
      case "focus_people":
        runSymbolicAction("focus_people")
      case "focus_groups":
        runSymbolicAction("focus_groups")
      case "send_message":
        runSymbolicAction("send_message")
      case "archive_message":
        runSymbolicAction("archive_message")
      case "delete_message":
        runSymbolicAction("delete_message")
      case "toggle_star":
        runSymbolicAction("toggle_star")
      case "mark_read":
        runSymbolicAction("mark_read")
      case "open_settings":
        runSymbolicAction("open_settings")
      case "choose_mail_root":
        runSymbolicAction("choose_mail_root")
      case "install_simplex_cli":
        runSymbolicAction("install_simplex_cli")
      case "provision_simplex_identity":
        runSymbolicAction("provision_simplex_identity")
      case "tick_simplex":
        runSymbolicAction("tick_simplex")
      case "bind_contact":
        runSymbolicAction("bind_contact")
      case "compose_simplex":
        runSymbolicAction("compose_simplex")
      case "compose_email":
        runSymbolicAction("compose_email")
      case "quit_app":
        runSymbolicAction("quit_app")
      default:
        statusText = "Unsupported action: \(action)"
    }
  }

  private func runSymbolicAction(_ action: String) {
    switch action {
      case "refresh_snapshot":
        refresh()
      case "focus_inbox":
        selectedRoute = "inbox"
      case "focus_favorites":
        if let first = snapshot.favorites.first { selectThread(first) }
      case "focus_people":
        if let first = snapshot.individuals.first { selectThread(first) }
      case "focus_groups":
        if let first = snapshot.groups.first { selectThread(first) }
      case "open_settings":
        (NSApp.delegate as? OwlNativeAppDelegate)?.showSettingsWindow(nil)
      case "choose_mail_root":
        chooseMailRoot()
      case "compose_simplex":
        selectedTransport = .simplex
      case "compose_email":
        selectedTransport = .email
      case "send_message":
        sendComposedMessage()
      case "install_simplex_cli":
        installSimpleX()
      case "provision_simplex_identity":
        provisionSimpleX()
      case "tick_simplex":
        tickSimpleX()
      case "bind_contact":
        saveContactBinding()
      case "quit_app":
        NSApplication.shared.terminate(nil)
      default:
        statusText = action.replacingOccurrences(of: "_", with: " ").capitalized
    }
  }
}

private enum OwlBackend {
  static func snapshot(root: String) async throws -> Snapshot {
    let data = try await runJSON(action: "snapshot", root: root, args: [])
    return try JSONDecoder().decode(Snapshot.self, from: data)
  }

  static func bootstrapStatus(root: String) async throws -> SimpleXBootstrap {
    let data = try await runJSON(action: "bootstrap-status", root: root, args: ["default"])
    return try JSONDecoder().decode(SimpleXBootstrap.self, from: data)
  }

  static func send(root: String, threadID: String, transport: Transport, subject: String, body: String) async throws -> Data {
    let body64 = Data(body.utf8).base64EncodedString()
    return try await runJSON(action: "send-message", root: root, args: [threadID, transport.rawValue, subject, body64])
  }

  static func runJSON(action: String, root: String, args: [String]) async throws -> Data {
    try await Task.detached(priority: .userInitiated) {
      try run(action: action, root: root, args: args)
    }.value
  }

  private static func run(action: String, root: String, args: [String]) throws -> Data {
    guard let script = resolveBackendScript() else {
      throw NSError(domain: "OwlNativeBackend", code: 1, userInfo: [NSLocalizedDescriptionKey: "Owl Native backend script could not be resolved."])
    }
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/sh")
    process.arguments = [script.path, action, root] + args

    let fm = FileManager.default
    let temp = fm.temporaryDirectory
    let stdoutURL = temp.appendingPathComponent("owl-native-stdout-\(UUID().uuidString).json")
    let stderrURL = temp.appendingPathComponent("owl-native-stderr-\(UUID().uuidString).log")
    fm.createFile(atPath: stdoutURL.path, contents: nil)
    fm.createFile(atPath: stderrURL.path, contents: nil)
    let stdoutHandle = try FileHandle(forWritingTo: stdoutURL)
    let stderrHandle = try FileHandle(forWritingTo: stderrURL)
    defer {
      stdoutHandle.closeFile()
      stderrHandle.closeFile()
      try? fm.removeItem(at: stdoutURL)
      try? fm.removeItem(at: stderrURL)
    }
    process.standardOutput = stdoutHandle
    process.standardError = stderrHandle
    try process.run()
    process.waitUntilExit()

    let out = (try? Data(contentsOf: stdoutURL)) ?? Data()
    let err = (try? Data(contentsOf: stderrURL)) ?? Data()
    guard process.terminationStatus == 0 else {
      let message = String(data: err, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        ?? String(data: out, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        ?? "Backend command failed."
      throw NSError(domain: "OwlNativeBackend", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: message])
    }
    return out
  }

  private static func resolveBackendScript() -> URL? {
    let fm = FileManager.default
    var candidates: [URL] = []
    if let override = ProcessInfo.processInfo.environment["OWL_NATIVE_BACKEND"], !override.isEmpty {
      candidates.append(URL(fileURLWithPath: override))
    }
    if let resourceURL = Bundle.main.resourceURL {
      candidates.append(resourceURL.appendingPathComponent("scripts/owl-native-backend.sh"))
      candidates.append(resourceURL.appendingPathComponent("owl-native/scripts/owl-native-backend.sh"))
    }
    let cwd = URL(fileURLWithPath: fm.currentDirectoryPath)
    candidates.append(cwd.appendingPathComponent("../../scripts/owl-native-backend.sh").standardizedFileURL)
    candidates.append(cwd.appendingPathComponent("scripts/owl-native-backend.sh").standardizedFileURL)
    candidates.append(fm.homeDirectoryForCurrentUser.appendingPathComponent("git/owl-native/scripts/owl-native-backend.sh"))
    return candidates.first(where: { fm.isExecutableFile(atPath: $0.path) || fm.fileExists(atPath: $0.path) })
  }
}

private enum OwlPreferences {
  static var mailRoot: String {
    get {
      UserDefaults.standard.string(forKey: "mailRoot") ?? "\(FileManager.default.homeDirectoryForCurrentUser.path)/mail"
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "mailRoot")
    }
  }
}

private struct RootView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    NavigationSplitView {
      SidebarView()
        .navigationSplitViewColumnWidth(min: 230, ideal: 280, max: 360)
    } detail: {
      MainContentView()
    }
    .toolbar {
      ToolbarItemGroup(placement: .primaryAction) {
        Button { session.refresh() } label: {
          Label("Refresh", systemImage: "arrow.clockwise")
        }
        Button { session.tickSimpleX() } label: {
          Label("Check SimpleX", systemImage: "lock.fill")
        }
      }
    }
  }
}

private struct SidebarView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    List(selection: $session.selectedRoute) {
      Section {
        SidebarInboxRow()
          .tag("inbox")
      }
      if !session.snapshot.favorites.isEmpty {
        Section("Favorites") {
          ForEach(session.snapshot.favorites) { thread in
            SidebarThreadRow(thread: thread)
              .tag("thread:\(thread.id)")
              .onTapGesture { session.selectThread(thread) }
          }
        }
      }
      Section("Individuals") {
        ForEach(session.snapshot.individuals) { thread in
          SidebarThreadRow(thread: thread)
            .tag("thread:\(thread.id)")
            .onTapGesture { session.selectThread(thread) }
        }
      }
      Section {
        Divider()
      }
      Section("Groups") {
        ForEach(session.snapshot.groups) { thread in
          SidebarThreadRow(thread: thread)
            .tag("thread:\(thread.id)")
            .onTapGesture { session.selectThread(thread) }
        }
      }
    }
    .listStyle(.sidebar)
    .safeAreaInset(edge: .bottom) {
      StatusStrip()
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
  }
}

private struct SidebarInboxRow: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    HStack(spacing: 9) {
      Image(systemName: "tray.full")
      Text("Inbox")
      Spacer()
      CountBadge(count: session.inboxUnreadCount)
    }
    .contentShape(Rectangle())
    .onTapGesture { session.openInbox(focusing: nil) }
  }
}

private struct SidebarThreadRow: View {
  let thread: ThreadItem

  var body: some View {
    HStack(spacing: 9) {
      Image(systemName: thread.kind == "group" ? "person.3.fill" : "person.fill")
        .foregroundStyle(.secondary)
      VStack(alignment: .leading, spacing: 2) {
        Text(thread.displayName)
          .lineLimit(1)
        HStack(spacing: 5) {
          if thread.hasSimpleXPath {
            Image(systemName: "lock.fill")
          }
          if thread.hasEmailPath {
            Image(systemName: "lock.open")
          }
          Text(thread.latest_at.isEmpty ? "No messages" : thread.latest_at)
            .lineLimit(1)
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
      }
      Spacer()
      CountBadge(count: thread.unread_count)
    }
  }
}

private struct CountBadge: View {
  let count: Int

  var body: some View {
    if count > 0 {
      Text("\(count)")
        .font(.caption2.weight(.semibold))
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Capsule().fill(Color.accentColor.opacity(0.16)))
        .foregroundStyle(Color.accentColor)
    }
  }
}

private struct MainContentView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    Group {
      if session.selectedRoute == "inbox" {
        InboxView()
      } else if session.selectedThread != nil {
        TimelineView()
      } else {
        EmptyStateView(title: "No Conversation Selected", subtitle: "Choose Inbox, an individual, or a group.")
      }
    }
  }
}

private struct InboxView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HeaderView(title: "Inbox", subtitle: "\(session.snapshot.inbox.count) cards across email and SimpleX")
      Divider()
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 10) {
            if session.snapshot.inbox.isEmpty {
              EmptyStateView(title: "Inbox Is Clear", subtitle: "Inbox cards stay here while also remaining in their contact or group timelines.")
                .padding(.top, 80)
            } else {
              ForEach(session.snapshot.inbox) { message in
                InboxCard(message: message)
                  .id(message.id)
              }
            }
          }
          .padding(18)
        }
        .onChange(of: session.focusedMessageID) { target in
          if let target {
            withAnimation { proxy.scrollTo(target, anchor: .center) }
          }
        }
      }
    }
  }
}

private struct InboxCard: View {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem

  var body: some View {
    Button {
      session.openTimeline(for: message)
    } label: {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .firstTextBaseline) {
          TransportMark(message: message)
          Text(message.contact_name)
            .font(.headline)
          Spacer()
          Text(message.received_at)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        if !message.subject.isEmpty {
          Text(message.subject)
            .font(.subheadline.weight(.semibold))
        }
        Text(message.displayBody.isEmpty ? "No preview" : message.displayBody)
          .font(.body)
          .foregroundStyle(.primary)
          .lineLimit(message.isLongBlock ? 5 : 2)
        HStack {
          TransportPill(message: message)
          if message.attachments > 0 {
            Label("\(message.attachments)", systemImage: "paperclip")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button("Archive") { session.archive(message) }
            .buttonStyle(.borderless)
        }
      }
      .padding(14)
      .background(RoundedRectangle(cornerRadius: 8).fill(Color(nsColor: .controlBackgroundColor)))
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.18)))
    }
    .buttonStyle(.plain)
  }
}

private struct TimelineView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        if let thread = session.selectedThread {
          HeaderView(title: thread.displayName, subtitle: timelineSubtitle(thread))
        }
        Divider()
        ScrollViewReader { proxy in
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
              ForEach(session.timelineMessages) { message in
                MessageBubble(message: message)
                  .id(message.id)
              }
            }
            .padding(18)
          }
          .onAppear {
            if let target = session.focusedMessageID {
              proxy.scrollTo(target, anchor: .center)
            }
          }
          .onChange(of: session.focusedMessageID) { target in
            if let target {
              withAnimation { proxy.scrollTo(target, anchor: .center) }
            }
          }
        }
        Divider()
        ComposerView()
          .padding(14)
      }
      Divider()
      ContactInspectorView()
        .frame(width: 260)
        .background(.bar)
    }
  }

  private func timelineSubtitle(_ thread: ThreadItem) -> String {
    let count = thread.messages.count
    let paths = [
      thread.hasSimpleXPath ? "SimpleX" : nil,
      thread.hasEmailPath ? "email" : nil
    ].compactMap { $0 }.joined(separator: " + ")
    return "\(count) timeline item\(count == 1 ? "" : "s")" + (paths.isEmpty ? "" : " · \(paths)")
  }
}

private struct MessageBubble: View {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem

  var body: some View {
    HStack {
      if message.from_self { Spacer(minLength: 80) }
      VStack(alignment: .leading, spacing: 7) {
        HStack(spacing: 7) {
          TransportMark(message: message)
          Text(message.from_self ? "You" : message.contact_name)
            .font(.caption.weight(.semibold))
          Text(message.received_at)
            .font(.caption2)
            .foregroundStyle(.secondary)
          if message.in_inbox {
            Button {
              session.openInbox(focusing: message.id)
            } label: {
              Text("Inbox")
                .font(.caption.weight(.bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Capsule().fill(Color.accentColor.opacity(0.18)))
            }
            .buttonStyle(.plain)
          }
        }
        if !message.subject.isEmpty {
          Text(message.subject)
            .font(message.isLongBlock ? .headline : .subheadline.weight(.semibold))
        }
        Text(message.displayBody.isEmpty ? "No content" : message.displayBody)
          .font(message.isLongBlock ? .body : .callout)
          .textSelection(.enabled)
          .fixedSize(horizontal: false, vertical: true)
        HStack(spacing: 8) {
          TransportPill(message: message)
          if message.in_inbox {
            Button("Remove From Inbox") { session.archive(message) }
              .buttonStyle(.borderless)
          }
          Button(message.read ? "Unread" : "Read") { session.markRead(message, read: !message.read) }
            .buttonStyle(.borderless)
        }
      }
      .padding(message.isLongBlock ? 14 : 10)
      .frame(maxWidth: message.isLongBlock ? 620 : 430, alignment: .leading)
      .background(messageBackground)
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(message.in_inbox ? 0.12 : 0.2)))
      .opacity(message.in_inbox ? 0.62 : 1.0)
      if !message.from_self { Spacer(minLength: 80) }
    }
  }

  private var messageBackground: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(message.from_self ? Color.accentColor.opacity(0.12) : Color(nsColor: .controlBackgroundColor))
  }
}

private struct ComposerView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .center, spacing: 12) {
        Picker("Transport", selection: $session.selectedTransport) {
          ForEach(Transport.allCases) { transport in
            Text(transport.label).tag(transport)
          }
        }
        .pickerStyle(.segmented)
        .fixedSize()
        if session.selectedTransport == .email {
          Label("Open-lock email path", systemImage: "lock.open")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.red)
        } else {
          Label("Preferred secure path", systemImage: "lock.fill")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.green)
        }
        Spacer()
        Button {
          session.sendComposedMessage()
        } label: {
          Label(session.selectedTransport == .email ? "Send Email" : "Send", systemImage: session.selectedTransport.symbol)
        }
        .buttonStyle(.borderedProminent)
        .tint(session.selectedTransport == .email ? .red.opacity(0.86) : .accentColor)
        .disabled(!session.canSend || session.isBusy)
      }
      TextField("Subject", text: $session.composeSubject)
        .textFieldStyle(.roundedBorder)
      TextEditor(text: $session.composeBody)
        .font(.body)
        .frame(minHeight: 82, idealHeight: 110, maxHeight: 160)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.18)))
    }
  }
}

private struct ContactInspectorView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Identity")
        .font(.headline)
      TextField("Name", text: $session.contactDraftName)
        .textFieldStyle(.roundedBorder)
      TextField("Email", text: $session.contactDraftEmail)
        .textFieldStyle(.roundedBorder)
      TextField("SimpleX", text: $session.contactDraftSimpleX)
        .textFieldStyle(.roundedBorder)
      Toggle("Favorite", isOn: $session.contactDraftFavorite)
      Button {
        session.saveContactBinding()
      } label: {
        Label("Save Binding", systemImage: "person.crop.circle.badge.checkmark")
      }
      .buttonStyle(.bordered)
      Divider()
      if let thread = session.selectedThread {
        Label(thread.hasSimpleXPath ? "SimpleX bound" : "No SimpleX path", systemImage: thread.hasSimpleXPath ? "lock.fill" : "lock.slash")
          .foregroundStyle(thread.hasSimpleXPath ? .green : .secondary)
        Label(thread.hasEmailPath ? "Email bound" : "No email path", systemImage: thread.hasEmailPath ? "lock.open" : "envelope.badge")
          .foregroundStyle(thread.hasEmailPath ? .red : .secondary)
      }
      Spacer()
    }
    .padding(14)
  }
}

private struct HeaderView: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.title2.weight(.semibold))
      Text(subtitle)
        .font(.callout)
        .foregroundStyle(.secondary)
    }
    .padding(.horizontal, 18)
    .padding(.vertical, 14)
  }
}

private struct TransportMark: View {
  let message: MessageItem

  var body: some View {
    Image(systemName: message.isSimpleX ? "lock.fill" : "lock.open")
      .font(.caption.weight(.bold))
      .foregroundStyle(message.isSimpleX ? .green : .red)
      .help(message.isSimpleX ? "SimpleX secure transport" : "Email open-lock transport")
  }
}

private struct TransportPill: View {
  let message: MessageItem

  var body: some View {
    Label(message.isSimpleX ? "SimpleX" : "Email", systemImage: message.isSimpleX ? "lock.fill" : "lock.open")
      .font(.caption.weight(.semibold))
      .padding(.horizontal, 8)
      .padding(.vertical, 3)
      .background(Capsule().fill((message.isSimpleX ? Color.green : Color.red).opacity(0.12)))
      .foregroundStyle(message.isSimpleX ? .green : .red)
  }
}

private struct StatusStrip: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        if session.isBusy {
          ProgressView()
            .scaleEffect(0.6)
        }
        Text(session.statusText)
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(2)
      }
      Text("v\(generatedAppVersion) · \(generatedAppID)")
        .font(.caption2)
        .foregroundStyle(.tertiary)
    }
  }
}

private struct SettingsView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    Form {
      Section("Mail Root") {
        HStack {
          TextField("Mail root", text: $session.mailRoot)
            .textFieldStyle(.roundedBorder)
            .frame(width: 360)
          Button("Choose...") { session.chooseMailRoot() }
          Button("Refresh") { session.refresh() }
        }
      }
      Section("SimpleX") {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
          GridRow {
            Text("Install")
              .foregroundStyle(.secondary)
            Text(session.bootstrap.install_state)
          }
          GridRow {
            Text("Profile")
              .foregroundStyle(.secondary)
            Text(session.bootstrap.profile_ready ? "ready" : "missing")
          }
          GridRow {
            Text("Binary")
              .foregroundStyle(.secondary)
            Text(session.bootstrap.binary_path.isEmpty ? session.snapshot.simplex.system_root : session.bootstrap.binary_path)
              .lineLimit(2)
          }
        }
        HStack {
          Button("Install CLI") { session.installSimpleX() }
          Button("Provision Identity") { session.provisionSimpleX() }
          Button("Check Incoming") { session.tickSimpleX() }
        }
      }
      Section("Native Contract") {
        Text("Owl Native renders one contact or group timeline with email and SimpleX as message attributes.")
          .foregroundStyle(.secondary)
      }
    }
    .formStyle(.grouped)
  }
}

private struct EmptyStateView: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(spacing: 8) {
      Text(title)
        .font(.headline)
      Text(subtitle)
        .font(.callout)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

private enum SeedData {
  static let email = MessageItem(
    id: "seed-email-1",
    backend_kind: "email",
    transport: "email",
    lock: "open",
    thread_id: "alice-ledger",
    contact_name: "Alice Ledger",
    email: "alice@example.org",
    simplex_address: "simplex://alice-ledger",
    list: "accepted",
    subject: "Longer email-style note",
    body: "This longer email-style message is rendered in the same continuous contact timeline as short chat messages. It stays visible here while its Inbox pill points back to the Inbox card.",
    preview: "This longer email-style message is rendered in the same continuous contact timeline.",
    received_at: "2026-04-20T10:00:00Z",
    in_inbox: true
  )

  static let simplex = MessageItem(
    id: "seed-simplex-1",
    backend_kind: "simplex",
    transport: "simplex",
    lock: "closed",
    thread_id: "alice-ledger",
    contact_name: "Alice Ledger",
    email: "alice@example.org",
    simplex_address: "simplex://alice-ledger",
    body: "Short secure reply.",
    preview: "Short secure reply.",
    received_at: "2026-04-20T10:03:00Z",
    from_self: true
  )

  static let groupMessage = MessageItem(
    id: "seed-simplex-group",
    backend_kind: "simplex",
    transport: "simplex",
    lock: "closed",
    thread_id: "river-stone",
    contact_name: "River Stone",
    contact_kind: "group",
    simplex_address: "simplex://river-stone",
    body: "Group update landed over SimpleX.",
    preview: "Group update landed over SimpleX.",
    received_at: "2026-04-20T11:00:00Z",
    in_inbox: true
  )

  static let alice = ThreadItem(
    id: "alice-ledger",
    name: "Alice Ledger",
    email: "alice@example.org",
    simplex_address: "simplex://alice-ledger",
    favorite: true,
    unread_count: 1,
    latest_at: "2026-04-20T10:03:00Z",
    messages: [email, simplex]
  )

  static let river = ThreadItem(
    id: "river-stone",
    kind: "group",
    name: "River Stone",
    simplex_address: "simplex://river-stone",
    favorite: true,
    unread_count: 1,
    latest_at: "2026-04-20T11:00:00Z",
    messages: [groupMessage]
  )

  static let snapshot = Snapshot(
    root: OwlPreferences.mailRoot,
    inbox: [email, groupMessage],
    favorites: [alice, river],
    individuals: [alice],
    groups: [river],
    threads: [river, alice],
    messages: [email, simplex, groupMessage],
    overview: Overview(counts: OverviewCounts(inbox_messages: 2, new_messages: 0, archive_messages: 0, trash_messages: 0, drafts: 0, sent: 0)),
    simplex: SimpleXSnapshot(install_state: "missing")
  )
}
