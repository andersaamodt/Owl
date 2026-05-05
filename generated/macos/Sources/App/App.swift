// Generated from ir/app.ir.yaml. Regenerate with scripts/render-native-desktop.sh.
import AppKit
import Foundation
import SwiftUI
import UniformTypeIdentifiers

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
        "id": "focus_new",
        "title": "New Senders"
      },
      {
        "id": "focus_inbox",
        "title": "Inbox"
      },
      {
        "id": "focus_mail",
        "title": "Mail"
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
        "id": "configure_simplex_local_transport",
        "title": "Enable Local SimpleX Transport"
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
private let messageDragPayloadPrefix = "owl-native-message:"

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
  private var titlebarTabsController: NSHostingController<AnyView>?
  private var titlebarTabsAccessory: NSTitlebarAccessoryViewController?

  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.mainMenu = makeMainMenu()
    showMainWindow()
    activateApplication()
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    session.refreshIfStale()
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    showMainWindow()
    session.refreshIfStale(force: true)
    return true
  }

  private func showMainWindow() {
    if let window {
      window.makeKeyAndOrderFront(nil)
      activateApplication()
      session.refreshIfStale()
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
    window.titleVisibility = .hidden
    window.contentView = hostingView
    window.isReleasedWhenClosed = false
    window.delegate = self
    installTitlebarTabs(in: window)
    window.center()
    window.makeKeyAndOrderFront(nil)
    self.window = window
  }

  func windowDidBecomeKey(_ notification: Notification) {
    session.refreshIfStale()
  }

  private func installTitlebarTabs(in window: NSWindow) {
    let tabsView = PrimaryTabBar()
      .environmentObject(session)
    let controller = NSHostingController(rootView: AnyView(tabsView))
    controller.view.frame = NSRect(x: 0, y: 0, width: 360, height: 34)
    let accessory = NSTitlebarAccessoryViewController()
    accessory.view = controller.view
    accessory.layoutAttribute = .left
    window.addTitlebarAccessoryViewController(accessory)
    titlebarTabsController = controller
    titlebarTabsAccessory = accessory
  }

  @objc func showSettingsWindow(_ sender: Any?) {
    if let settingsWindow {
      settingsWindow.makeKeyAndOrderFront(nil)
      activateApplication()
      return
    }

    let settingsView = SettingsView()
      .environmentObject(session)
      .frame(width: 720)
      .padding(20)
    let hostingView = NSHostingView(rootView: settingsView)
    let settingsWindow = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 780, height: 680),
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

    let fileMenuItem = NSMenuItem()
    let fileMenu = NSMenu(title: "File")
    fileMenu.addItem(actionItem("Send Message", action: "send_message", key: "\r", modifiers: [.command]))
    fileMenu.addItem(.separator())
    fileMenu.addItem(actionItem("Choose Mail Root...", action: "choose_mail_root"))
    fileMenu.addItem(actionItem("Setup Mail Folders", action: "setup_folders"))
    fileMenuItem.submenu = fileMenu
    mainMenu.addItem(fileMenuItem)

    let editMenuItem = NSMenuItem()
    let editMenu = NSMenu(title: "Edit")
    editMenu.addItem(standardItem("Undo", selector: Selector(("undo:")), key: "z"))
    editMenu.addItem(standardItem("Redo", selector: Selector(("redo:")), key: "Z"))
    editMenu.addItem(.separator())
    editMenu.addItem(standardItem("Cut", selector: #selector(NSText.cut(_:)), key: "x"))
    editMenu.addItem(standardItem("Copy", selector: #selector(NSText.copy(_:)), key: "c"))
    editMenu.addItem(standardItem("Paste", selector: #selector(NSText.paste(_:)), key: "v"))
    editMenu.addItem(.separator())
    editMenu.addItem(standardItem("Select All", selector: #selector(NSText.selectAll(_:)), key: "a"))
    editMenuItem.submenu = editMenu
    mainMenu.addItem(editMenuItem)

    let viewMenuItem = NSMenuItem()
    let viewMenu = NSMenu(title: "View")
    viewMenu.addItem(actionItem("New Senders", action: "focus_new", key: "1", modifiers: [.command]))
    viewMenu.addItem(actionItem("Inbox", action: "focus_inbox", key: "2", modifiers: [.command]))
    viewMenu.addItem(actionItem("Mail", action: "focus_mail", key: "3", modifiers: [.command]))
    viewMenuItem.submenu = viewMenu
    mainMenu.addItem(viewMenuItem)

    let messageMenuItem = NSMenuItem()
    let messageMenu = NSMenu(title: "Message")
    messageMenu.addItem(actionItem("Remove From Inbox", action: "archive_selected", key: "e", modifiers: [.command]))
    messageMenu.addItem(actionItem("Delete", action: "delete_selected", key: "\u{8}", modifiers: []))
    messageMenu.addItem(actionItem("Star", action: "star_selected", key: "l", modifiers: [.command]))
    messageMenu.addItem(.separator())
    messageMenu.addItem(actionItem("Mark Read", action: "mark_selected_read", key: "u", modifiers: [.command, .shift]))
    messageMenu.addItem(actionItem("Mark Unread", action: "mark_selected_unread", key: "u", modifiers: [.command]))
    messageMenuItem.submenu = messageMenu
    mainMenu.addItem(messageMenuItem)

    let transportMenuItem = NSMenuItem()
    let transportMenu = NSMenu(title: "Transport")
    transportMenu.addItem(actionItem("Use SimpleX", action: "compose_simplex"))
    transportMenu.addItem(actionItem("Use Email", action: "compose_email"))
    transportMenu.addItem(.separator())
    transportMenu.addItem(actionItem("Install SimpleX CLI", action: "install_simplex_cli"))
    transportMenu.addItem(actionItem("Provision SimpleX Identity", action: "provision_simplex_identity"))
    transportMenu.addItem(actionItem("Enable Local SimpleX Transport", action: "configure_simplex_local_transport"))
    transportMenu.addItem(actionItem("Check SimpleX", action: "tick_simplex"))
    transportMenuItem.submenu = transportMenu
    mainMenu.addItem(transportMenuItem)

    let windowMenuItem = NSMenuItem()
    let windowMenu = NSMenu(title: "Window")
    windowMenu.addItem(standardItem("Minimize", selector: #selector(NSWindow.miniaturize(_:)), key: "m"))
    windowMenu.addItem(standardItem("Zoom", selector: #selector(NSWindow.performZoom(_:)), key: ""))
    windowMenu.addItem(.separator())
    windowMenu.addItem(NSMenuItem(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: ""))
    windowMenuItem.submenu = windowMenu
    mainMenu.addItem(windowMenuItem)
    NSApp.windowsMenu = windowMenu

    let helpMenuItem = NSMenuItem()
    let helpMenu = NSMenu(title: "Help")
    helpMenu.addItem(actionItem("Show Events", action: "focus_events"))
    helpMenuItem.submenu = helpMenu
    mainMenu.addItem(helpMenuItem)
    NSApp.helpMenu = helpMenu

    return mainMenu
  }

  private func actionItem(_ title: String, action: String, key: String = "", modifiers: NSEvent.ModifierFlags = []) -> NSMenuItem {
    let item = NSMenuItem(title: title, action: #selector(performMenuAction(_:)), keyEquivalent: key)
    item.target = self
    item.representedObject = action
    item.keyEquivalentModifierMask = modifiers
    return item
  }

  private func standardItem(_ title: String, selector: Selector, key: String, modifiers: NSEvent.ModifierFlags = [.command]) -> NSMenuItem {
    let item = NSMenuItem(title: title, action: selector, keyEquivalent: key)
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
  var mailboxes: [MailboxItem]
  var drafts: [DraftItem]
  var events: [EventItem]
  var overview: Overview
  var prefs: UIPrefs
  var settings: SettingsSnapshot
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
    mailboxes: [MailboxItem] = [],
    drafts: [DraftItem] = [],
    events: [EventItem] = [],
    overview: Overview = Overview(),
    prefs: UIPrefs = UIPrefs(),
    settings: SettingsSnapshot = SettingsSnapshot(),
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
    self.mailboxes = mailboxes
    self.drafts = drafts
    self.events = events
    self.overview = overview
    self.prefs = prefs
    self.settings = settings
    self.simplex = simplex
  }

  private enum CodingKeys: String, CodingKey {
    case ok, root, inbox, favorites, individuals, groups, threads, messages, mailboxes, drafts, events, overview, prefs, settings, simplex
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
    mailboxes = try values.decodeIfPresent([MailboxItem].self, forKey: .mailboxes) ?? []
    drafts = try values.decodeIfPresent([DraftItem].self, forKey: .drafts) ?? []
    events = try values.decodeIfPresent([EventItem].self, forKey: .events) ?? []
    overview = try values.decodeIfPresent(Overview.self, forKey: .overview) ?? Overview()
    prefs = try values.decodeIfPresent(UIPrefs.self, forKey: .prefs) ?? UIPrefs()
    settings = try values.decodeIfPresent(SettingsSnapshot.self, forKey: .settings) ?? SettingsSnapshot()
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

private struct SettingsSnapshot: Decodable, Sendable {
  var ok: Bool
  var test_recipient: String
  var email_domain: String
  var domain_configured: Bool
  var ssl_ready: Bool
  var folders_ready: Bool
  var daemon: DaemonSettings
  var remote: RemoteSettings

  init(
    ok: Bool = false,
    test_recipient: String = "",
    email_domain: String = "",
    domain_configured: Bool = false,
    ssl_ready: Bool = false,
    folders_ready: Bool = false,
    daemon: DaemonSettings = DaemonSettings(),
    remote: RemoteSettings = RemoteSettings()
  ) {
    self.ok = ok
    self.test_recipient = test_recipient
    self.email_domain = email_domain
    self.domain_configured = domain_configured
    self.ssl_ready = ssl_ready
    self.folders_ready = folders_ready
    self.daemon = daemon
    self.remote = remote
  }
}

private struct DaemonSettings: Decodable, Sendable {
  var available: Bool = false
  var manager: String = ""
  var installed: Bool = false
  var running: Bool = false
  var startup_enabled: Bool = false
}

private struct RemoteSettings: Decodable, Sendable {
  var host: String = ""
  var key_path: String = ""
  var port: String = ""
  var last_deploy_status: String = ""
  var last_verify_status: String = ""
  var last_test_status: String = ""
  var last_sync_status: String = ""
}

private struct UIPrefs: Decodable, Sendable {
  var mail_root: String
  var selected_route: String

  init(mail_root: String = "", selected_route: String = "inbox") {
    self.mail_root = mail_root
    self.selected_route = selected_route
  }
}

private struct MailboxItem: Identifiable, Decodable, Hashable, Sendable {
  var id: String
  var title: String
  var count: Int
  var unread: Int

  init(id: String, title: String, count: Int = 0, unread: Int = 0) {
    self.id = id
    self.title = title
    self.count = count
    self.unread = unread
  }
}

private struct DraftItem: Identifiable, Decodable, Hashable, Sendable {
  var id: String { ulid }
  var ulid: String
  var to: String
  var subject: String
  var updated_at: String

  init(ulid: String = "", to: String = "", subject: String = "", updated_at: String = "") {
    self.ulid = ulid
    self.to = to
    self.subject = subject
    self.updated_at = updated_at
  }

  private enum CodingKeys: String, CodingKey { case ulid, to, subject, updated_at }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    ulid = try values.decodeIfPresent(String.self, forKey: .ulid) ?? UUID().uuidString
    to = try values.decodeIfPresent(String.self, forKey: .to) ?? ""
    subject = try values.decodeIfPresent(String.self, forKey: .subject) ?? ""
    updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at) ?? ""
  }
}

private struct EventItem: Identifiable, Decodable, Hashable, Sendable {
  var id: String
  var kind: String
  var message: String
  var created_at: String

  init(id: String = UUID().uuidString, kind: String = "", message: String = "", created_at: String = "") {
    self.id = id
    self.kind = kind
    self.message = message
    self.created_at = created_at
  }

  private enum CodingKeys: String, CodingKey { case id, kind, message, created_at, at, label }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
    let decodedKind = try values.decodeIfPresent(String.self, forKey: .kind)
    let decodedLabel = try values.decodeIfPresent(String.self, forKey: .label)
    kind = decodedKind ?? decodedLabel ?? ""
    message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
    let decodedCreatedAt = try values.decodeIfPresent(String.self, forKey: .created_at)
    let decodedAt = try values.decodeIfPresent(String.self, forKey: .at)
    created_at = decodedCreatedAt ?? decodedAt ?? ""
  }
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
  var hook_path: String
  var hook_ready: Bool
  var last_error: String

  init(
    ok: Bool = true,
    supported: Bool = false,
    install_state: String = "unknown",
    version: String = "",
    binary_path: String = "",
    profile_prefix: String = "",
    profile_ready: Bool = false,
    hook_path: String = "",
    hook_ready: Bool = false,
    last_error: String = ""
  ) {
    self.ok = ok
    self.supported = supported
    self.install_state = install_state
    self.version = version
    self.binary_path = binary_path
    self.profile_prefix = profile_prefix
    self.profile_ready = profile_ready
    self.hook_path = hook_path
    self.hook_ready = hook_ready
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
  var status: String

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
    attachments: Int = 0,
    status: String = ""
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
    self.status = status
  }

  private enum CodingKeys: String, CodingKey {
    case id, backend_kind, transport, lock, thread_id, contact_name, contact_kind, email, simplex_address
    case list, sender, ulid, subject, body, preview, received_at, from_self, in_inbox, read, starred, attachments, status
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
    status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
  }
}

private func defaultMailRoot() -> String {
  FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("mail").path
}

private enum FriendlyTime {
  static func relative(_ rawValue: String, now: Date = Date()) -> String {
    guard let date = parse(rawValue) else {
      return rawValue
    }
    let delta = Int(now.timeIntervalSince(date))
    if delta < -60 {
      return "in \(compactDuration(abs(delta)))"
    }
    if delta < 60 {
      return "now"
    }
    return "\(compactDuration(delta)) ago"
  }

  private static func compactDuration(_ seconds: Int) -> String {
    if seconds < 60 {
      return "\(max(1, seconds))s"
    }
    let minutes = seconds / 60
    if minutes < 60 {
      return "\(minutes)m"
    }
    let hours = minutes / 60
    if hours < 24 {
      return "\(hours)h"
    }
    let days = hours / 24
    if days < 7 {
      return "\(days)d"
    }
    let weeks = days / 7
    if weeks < 5 {
      return "\(weeks)w"
    }
    let months = days / 30
    if months < 12 {
      return "\(max(1, months))mo"
    }
    let years = days / 365
    return "\(max(1, years))y"
  }

  private static func parse(_ rawValue: String) -> Date? {
    let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = isoFormatter.date(from: trimmed) {
      return date
    }
    let isoFormatterWithoutFractionalSeconds = ISO8601DateFormatter()
    isoFormatterWithoutFractionalSeconds.formatOptions = [.withInternetDateTime]
    if let date = isoFormatterWithoutFractionalSeconds.date(from: trimmed) {
      return date
    }
    for format in ["yyyy-MM-dd'T'HH:mm:ssXXXXX", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"] {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = format
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      if let date = formatter.date(from: trimmed) {
        return date
      }
    }
    return nil
  }
}

private func friendlyTime(_ rawValue: String) -> String {
  FriendlyTime.relative(rawValue)
}

@MainActor
private final class OwlSession: ObservableObject {
  @Published var snapshot: Snapshot = SeedData.snapshot
  @Published var selectedRoute: String = "new"
  @Published var focusedMessageID: String?
  @Published var selectedMessageID: String?
  @Published var draggingMessageID: String?
  @Published var selectedNewSenderID: String?
  @Published var selectedMailThreadID: String?
  @Published var mailRoot: String = defaultMailRoot()
  @Published var selectedTransport: Transport = .simplex
  @Published var composeSubject: String = ""
  @Published var composeBody: String = ""
  @Published var statusText: String = "Ready" {
    didSet {
      if statusText != "Ready" {
        showToast(statusText, busy: isBusy)
      }
    }
  }
  @Published var isBusy: Bool = false {
    didSet {
      if isBusy {
        showToast(statusText, busy: true, autoDismiss: false)
      } else if statusText != "Ready" {
        showToast(statusText)
      }
    }
  }
  @Published var toastMessage: String = ""
  @Published var toastBusy: Bool = false
  @Published var toastVisible: Bool = false
  @Published var bootstrap: SimpleXBootstrap = SimpleXBootstrap()
  @Published var contactDraftName: String = ""
  @Published var contactDraftEmail: String = ""
  @Published var contactDraftSimpleX: String = ""
  @Published var contactDraftFavorite: Bool = false
  @Published var settingsDomainDraft: String = ""
  @Published var settingsTestRecipientDraft: String = ""
  @Published var remoteHostDraft: String = ""
  @Published var remoteKeyPathDraft: String = ""
  @Published var remotePortDraft: String = ""
  private var lastRefreshAt: Date?
  private let refreshStaleInterval: TimeInterval = 20
  private var toastGeneration = 0

  init() {
    snapshot = SeedData.snapshot
    mailRoot = defaultMailRoot()
    selectedRoute = "new"
    selectedTransport = .simplex
    Task { await loadPreferencesThenRefresh() }
  }

  var inboxUnreadCount: Int {
    snapshot.inbox.filter { !$0.read }.count
  }

  var selectedThreadID: String? {
    if let selectedMailThreadID {
      return selectedMailThreadID
    }
    guard selectedRoute.hasPrefix("thread:") else { return nil }
    return String(selectedRoute.dropFirst("thread:".count))
  }

  var selectedThread: ThreadItem? {
    guard let id = selectedThreadID else { return nil }
    return snapshot.threads.first(where: { $0.id == id })
  }

  var newSenderThreads: [ThreadItem] {
    snapshot.threads
      .filter { thread in thread.messages.contains(where: { $0.list == "quarantine" }) }
      .sorted { $0.latest_at > $1.latest_at }
  }

  var selectedNewSender: ThreadItem? {
    if let selectedNewSenderID {
      return newSenderThreads.first(where: { $0.id == selectedNewSenderID })
    }
    return newSenderThreads.first
  }

  var newSenderMessages: [MessageItem] {
    (selectedNewSender?.messages ?? [])
      .filter { $0.list == "quarantine" }
      .sorted { $0.received_at > $1.received_at }
  }

  var selectedMailboxID: String? {
    guard selectedRoute.hasPrefix("mailbox:") else { return nil }
    return String(selectedRoute.dropFirst("mailbox:".count))
  }

  var selectedMailbox: MailboxItem? {
    guard let id = selectedMailboxID else { return nil }
    return snapshot.mailboxes.first(where: { $0.id == id })
  }

  var mailboxMessages: [MessageItem] {
    guard let id = selectedMailboxID else { return [] }
    return snapshot.messages
      .filter { $0.list == id || $0.status == id }
      .sorted { $0.received_at > $1.received_at }
  }

  var timelineMessages: [MessageItem] {
    selectedThread?.messages ?? []
  }

  var activeMessage: MessageItem? {
    if let selectedMessageID {
      return message(withID: selectedMessageID)
    }
    if let focusedMessageID {
      return message(withID: focusedMessageID)
    }
    return nil
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

  func loadPreferencesThenRefresh() async {
    do {
      let prefs = try await OwlBackend.uiPrefs(root: mailRoot)
      if !prefs.mail_root.isEmpty {
        mailRoot = prefs.mail_root
      }
      selectedRoute = prefs.selected_route.isEmpty ? "new" : prefs.selected_route
    } catch {
      statusText = "Preferences unavailable: \(error.localizedDescription)"
    }
    refresh()
  }

  func refresh() {
    lastRefreshAt = Date()
    let root = mailRoot
    isBusy = true
    statusText = "Syncing \(root)"
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

  func refreshIfStale(force: Bool = false) {
    if isBusy && !force {
      return
    }
    if !force, let lastRefreshAt, Date().timeIntervalSince(lastRefreshAt) < refreshStaleInterval {
      return
    }
    refresh()
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

  func showToast(_ message: String, busy: Bool = false, autoDismiss: Bool = true) {
    guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    toastGeneration += 1
    let generation = toastGeneration
    toastMessage = message
    toastBusy = busy
    withAnimation(.easeOut(duration: 0.16)) {
      toastVisible = true
    }
    if autoDismiss && !busy {
      Task {
        try? await Task.sleep(nanoseconds: 3_200_000_000)
        if self.toastGeneration == generation {
          withAnimation(.easeIn(duration: 0.16)) {
            self.toastVisible = false
          }
        }
      }
    }
  }

  func apply(snapshot next: Snapshot) {
    snapshot = next
    mailRoot = next.root
    if selectedRoute.hasPrefix("thread:") {
      selectedMailThreadID = String(selectedRoute.dropFirst("thread:".count))
      selectedRoute = "mail"
    }
    if selectedRoute != "new" && selectedRoute != "inbox" && selectedRoute != "inbox-message" && selectedRoute != "mail" {
      selectedRoute = "new"
    }
    if selectedMailThreadID == nil {
      selectedMailThreadID = snapshot.threads.first?.id
    }
    if selectedNewSenderID == nil {
      selectedNewSenderID = newSenderThreads.first?.id
    }
    if let thread = selectedThread {
      syncTransportDefault(for: thread)
      loadContactDraft(from: thread)
    }
    settingsDomainDraft = next.settings.email_domain
    settingsTestRecipientDraft = next.settings.test_recipient
    remoteHostDraft = next.settings.remote.host
    remoteKeyPathDraft = next.settings.remote.key_path
    remotePortDraft = next.settings.remote.port
  }

  func openNewSenders() {
    selectedRoute = "new"
    if selectedNewSenderID == nil {
      selectedNewSenderID = newSenderThreads.first?.id
    }
    selectedMessageID = newSenderMessages.first?.id
    focusedMessageID = selectedMessageID
    persistSelectedRoute()
  }

  func selectThread(_ thread: ThreadItem) {
    selectedRoute = "mail"
    selectedMailThreadID = thread.id
    focusedMessageID = nil
    selectedMessageID = nil
    syncTransportDefault(for: thread)
    loadContactDraft(from: thread)
    persistSelectedRoute()
  }

  func openMail() {
    selectedRoute = "mail"
    if selectedMailThreadID == nil {
      selectedMailThreadID = snapshot.threads.first?.id
    }
    if let thread = selectedThread {
      syncTransportDefault(for: thread)
      loadContactDraft(from: thread)
    }
    persistSelectedRoute()
  }

  func openTimeline(for message: MessageItem) {
    selectedRoute = "mail"
    selectedMailThreadID = message.thread_id
    focusedMessageID = message.id
    selectedMessageID = message.id
    if let thread = selectedThread {
      syncTransportDefault(for: thread)
      loadContactDraft(from: thread)
    }
    persistSelectedRoute()
  }

  func openInbox(focusing messageID: String?) {
    selectedRoute = "inbox"
    focusedMessageID = messageID
    selectedMessageID = messageID
    persistSelectedRoute()
  }

  func openInboxMessage(_ message: MessageItem) {
    selectedRoute = "inbox-message"
    focusedMessageID = message.id
    selectedMessageID = message.id
    persistSelectedRoute()
  }

  func selectNewSender(_ thread: ThreadItem) {
    selectedRoute = "new"
    selectedNewSenderID = thread.id
    let firstMessage = thread.messages.filter { $0.list == "quarantine" }.sorted { $0.received_at > $1.received_at }.first
    selectedMessageID = firstMessage?.id
    focusedMessageID = firstMessage?.id
    persistSelectedRoute()
  }

  func moveSelectedNewSender(to list: String) {
    guard let message = newSenderMessages.first else { return }
    let root = mailRoot
    let sender = message.sender
    runMessageAction(status: "Moved sender to \(list)", refreshAfter: false) {
      try await OwlBackend.runJSON(action: "move-sender", root: root, args: ["quarantine", list, message.sender])
    } afterSuccess: {
      self.applySenderMove(sender: sender, to: list)
    }
  }

  func moveNewSender(_ thread: ThreadItem, to list: String) {
    guard let message = thread.messages.first(where: { $0.list == "quarantine" }) else { return }
    selectedNewSenderID = thread.id
    selectedMessageID = message.id
    focusedMessageID = message.id
    let root = mailRoot
    let sender = message.sender
    runMessageAction(status: "Moved sender to \(list)", refreshAfter: false) {
      try await OwlBackend.runJSON(action: "move-sender", root: root, args: ["quarantine", list, sender])
    } afterSuccess: {
      self.applySenderMove(sender: sender, to: list)
    }
  }

  func applySenderMove(sender: String, to list: String) {
    func movedMessage(_ message: MessageItem) -> MessageItem {
      guard message.sender == sender, message.list == "quarantine" else {
        return message
      }
      var moved = message
      moved.list = list
      moved.status = list
      return moved
    }

    func movedThread(_ thread: ThreadItem) -> ThreadItem {
      var moved = thread
      moved.messages = thread.messages.map(movedMessage)
      moved.unread_count = moved.messages.filter { !$0.read && $0.list != "archive" && $0.list != "trash" }.count
      return moved
    }

    let movedCount = snapshot.messages.filter { $0.sender == sender && $0.list == "quarantine" }.count
    snapshot.messages = snapshot.messages.map(movedMessage)
    snapshot.inbox = snapshot.inbox.map(movedMessage)
    snapshot.threads = snapshot.threads.map(movedThread)
    snapshot.favorites = snapshot.favorites.map(movedThread)
    snapshot.individuals = snapshot.individuals.map(movedThread)
    snapshot.groups = snapshot.groups.map(movedThread)
    snapshot.mailboxes = snapshot.mailboxes.map { mailbox in
      var updated = mailbox
      if updated.id == "quarantine" {
        updated.count = max(0, updated.count - movedCount)
      } else if updated.id == list {
        updated.count += movedCount
      }
      return updated
    }
    if selectedNewSenderID != nil, selectedNewSender?.messages.contains(where: { $0.list == "quarantine" }) != true {
      selectedNewSenderID = newSenderThreads.first?.id
    }
    let firstMessage = newSenderMessages.first
    selectedMessageID = firstMessage?.id
    focusedMessageID = firstMessage?.id
  }

  func openMailbox(_ mailbox: MailboxItem) {
    selectedRoute = "mailbox:\(mailbox.id)"
    focusedMessageID = nil
    selectedMessageID = nil
    persistSelectedRoute()
  }

  func openDrafts() {
    selectedRoute = "drafts"
    focusedMessageID = nil
    selectedMessageID = nil
    persistSelectedRoute()
  }

  func openEvents() {
    selectedRoute = "events"
    focusedMessageID = nil
    selectedMessageID = nil
    persistSelectedRoute()
  }

  func openSettingsRoute() {
    selectedRoute = "settings"
    focusedMessageID = nil
    selectedMessageID = nil
    persistSelectedRoute()
  }

  func selectMessage(_ message: MessageItem) {
    selectedMessageID = message.id
  }

  func persistSelectedRoute() {
    let route = selectedRoute
    let root = mailRoot
    Task {
      try? await OwlBackend.setUIPref(root: root, key: "selected_route", value: route)
    }
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

  func toggleStar(_ message: MessageItem) {
    let root = mailRoot
    runMessageAction(status: message.starred ? "Unstarred" : "Starred") {
      try await OwlBackend.runJSON(action: "toggle-star", root: root, args: [message.id, message.starred ? "false" : "true"])
    }
  }

  func markRead(_ message: MessageItem, read: Bool) {
    let root = mailRoot
    runMessageAction(status: read ? "Marked read" : "Marked unread") {
      try await OwlBackend.runJSON(action: "mark-read", root: root, args: [message.id, read ? "true" : "false"])
    }
  }

  func archiveSelectedMessage() {
    if let message = activeMessage { archive(message) }
  }

  func deleteSelectedMessage() {
    if let message = activeMessage { delete(message) }
  }

  func toggleSelectedStar() {
    if let message = activeMessage { toggleStar(message) }
  }

  func markSelectedRead() {
    if let message = activeMessage { markRead(message, read: true) }
  }

  func markSelectedUnread() {
    if let message = activeMessage { markRead(message, read: false) }
  }

  func message(withID id: String) -> MessageItem? {
    if let message = snapshot.messages.first(where: { $0.id == id }) {
      return message
    }
    if let message = snapshot.inbox.first(where: { $0.id == id }) {
      return message
    }
    for thread in snapshot.threads {
      if let message = thread.messages.first(where: { $0.id == id }) {
        return message
      }
    }
    return nil
  }

  func handleMessageDrop(id: String, action: MessageDropAction) {
    endDraggingMessage(id)
    guard let message = message(withID: id) else {
      statusText = "Dropped message is no longer available."
      return
    }
    selectedMessageID = message.id
    switch action {
    case .archive:
      archive(message)
    case .trash:
      delete(message)
    }
  }

  func beginDraggingMessage(_ message: MessageItem) {
    draggingMessageID = message.id
    let expectedID = message.id
    Task {
      try? await Task.sleep(nanoseconds: 30_000_000_000)
      if self.draggingMessageID == expectedID {
        self.draggingMessageID = nil
      }
    }
  }

  func endDraggingMessage(_ id: String? = nil) {
    guard id == nil || draggingMessageID == id else { return }
    draggingMessageID = nil
  }

  func runMessageAction(
    status: String,
    refreshAfter: Bool = true,
    action: @escaping () async throws -> Data,
    afterSuccess: @escaping () -> Void = {}
  ) {
    isBusy = true
    Task {
      do {
        _ = try await action()
        afterSuccess()
        self.statusText = status
        self.isBusy = false
        if refreshAfter {
          self.refresh()
        }
      } catch {
        self.statusText = error.localizedDescription
        self.isBusy = false
      }
    }
  }

  func runBackendAction(_ action: String, args: [String] = [], status: String) {
    let root = mailRoot
    runMessageAction(status: status) {
      try await OwlBackend.runJSON(action: action, root: root, args: args)
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

  func saveEmailDomain() {
    runBackendAction("settings-set-domain", args: [settingsDomainDraft], status: "Email domain saved")
  }

  func verifyEmailDomain() {
    runBackendAction("settings-verify-domain", args: [settingsDomainDraft], status: "Email domain verified")
  }

  func saveTestRecipient() {
    runBackendAction("settings-set-test-recipient", args: [settingsTestRecipientDraft], status: "Test recipient saved")
  }

  func setDaemonRunning(_ running: Bool) {
    runBackendAction("settings-set-daemon-running", args: [running ? "on" : "off"], status: running ? "Daemon started" : "Daemon stopped")
  }

  func setDaemonStartup(_ enabled: Bool) {
    runBackendAction("settings-set-daemon-startup", args: [enabled ? "on" : "off"], status: enabled ? "Startup enabled" : "Startup disabled")
  }

  func saveRemoteTarget() {
    var args = [remoteHostDraft, remoteKeyPathDraft]
    if !remotePortDraft.isEmpty {
      args.append(remotePortDraft)
    }
    runBackendAction("settings-remote-set-target", args: args, status: "Remote target saved")
  }

  func verifyRemote() {
    runBackendAction("settings-remote-verify", args: [], status: "Remote verification finished")
  }

  func syncRemote() {
    runBackendAction("settings-remote-sync", args: [], status: "Remote sync finished")
  }

  func classifySpam() {
    runBackendAction("spam-classify", args: ["quarantine", "", "25", "0"], status: "Spam classification finished")
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
      Task {
        try? await OwlBackend.setUIPref(root: url.path, key: "mail_root", value: url.path)
      }
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

  func configureSimpleXLocalTransport() {
    let root = mailRoot
    runMessageAction(status: "Local SimpleX transport enabled") {
      try await OwlBackend.runJSON(action: "configure-simplex-local-transport", root: root, args: ["default"])
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
      case "focus_new":
        runSymbolicAction("focus_new")
      case "focus_inbox":
        runSymbolicAction("focus_inbox")
      case "focus_mail":
        runSymbolicAction("focus_mail")
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
      case "configure_simplex_local_transport":
        runSymbolicAction("configure_simplex_local_transport")
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
      case "focus_new":
        openNewSenders()
      case "focus_inbox":
        openInbox(focusing: nil)
      case "focus_mail":
        openMail()
      case "focus_drafts":
        openDrafts()
      case "focus_events":
        openEvents()
      case "focus_settings":
        openSettingsRoute()
      case "focus_favorites":
        if let first = snapshot.favorites.first { selectThread(first) }
      case "focus_people":
        if let first = snapshot.individuals.first { selectThread(first) }
      case "focus_groups":
        if let first = snapshot.groups.first { selectThread(first) }
      case let mailboxAction where mailboxAction.hasPrefix("focus_mailbox_"):
        let suffix = String(mailboxAction.dropFirst("focus_mailbox_".count)).replacingOccurrences(of: "_", with: "-")
        if let mailbox = snapshot.mailboxes.first(where: { $0.id == suffix }) {
          openMailbox(mailbox)
        } else {
          selectedRoute = "mailbox:\(suffix)"
          persistSelectedRoute()
        }
      case "open_settings":
        (NSApp.delegate as? OwlNativeAppDelegate)?.showSettingsWindow(nil)
      case "choose_mail_root":
        chooseMailRoot()
      case "setup_folders":
        runBackendAction("settings-setup-folders", status: "Mail folders checked")
      case "compose_simplex":
        selectedTransport = .simplex
      case "compose_email":
        selectedTransport = .email
      case "send_message":
        sendComposedMessage()
      case "archive_selected":
        archiveSelectedMessage()
      case "delete_selected":
        deleteSelectedMessage()
      case "star_selected":
        toggleSelectedStar()
      case "mark_selected_read":
        markSelectedRead()
      case "mark_selected_unread":
        markSelectedUnread()
      case "install_simplex_cli":
        installSimpleX()
      case "provision_simplex_identity":
        provisionSimpleX()
      case "configure_simplex_local_transport":
        configureSimpleXLocalTransport()
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
  static func uiPrefs(root: String) async throws -> UIPrefs {
    let data = try await runJSON(action: "get-ui-prefs", root: root, args: [])
    return try JSONDecoder().decode(UIPrefs.self, from: data)
  }

  static func setUIPref(root: String, key: String, value: String) async throws {
    _ = try await runJSON(action: "set-ui-pref", root: root, args: [key, value])
  }

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

private struct RootView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(spacing: 0) {
      MainContentView()
    }
    .overlay(alignment: .topTrailing) {
      ToastOverlay()
        .padding(.top, 14)
        .padding(.trailing, 16)
    }
    .overlay(alignment: .bottom) {
      MessageDropDock()
        .padding(.bottom, 24)
    }
  }
}

private struct ToastOverlay: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    if session.toastVisible {
      HStack(spacing: 8) {
        if session.toastBusy {
          ProgressView()
            .scaleEffect(0.62)
        }
        Text(session.toastMessage)
          .font(.caption.weight(.semibold))
          .foregroundStyle(.primary)
          .lineLimit(2)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 9)
      .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
      .shadow(color: Color.black.opacity(0.14), radius: 10, x: 0, y: 5)
      .frame(maxWidth: 360, alignment: .trailing)
      .transition(.move(edge: .top).combined(with: .opacity))
    }
  }
}

private enum MessageDropAction {
  case trash
  case archive

  var label: String {
    switch self {
    case .trash: return "Trash"
    case .archive: return "Archive"
    }
  }

  var systemImage: String {
    switch self {
    case .trash: return "trash"
    case .archive: return "archivebox"
    }
  }
}

private struct MessageDropDock: View {
  var body: some View {
    HStack(alignment: .bottom) {
      MessageDropTarget(action: .trash)
      Spacer()
      MessageDropTarget(action: .archive)
    }
    .padding(.horizontal, 22)
    .frame(maxWidth: .infinity)
    .allowsHitTesting(true)
  }
}

private struct MessageDropTarget: View {
  @EnvironmentObject private var session: OwlSession
  let action: MessageDropAction
  @State private var isTargeted = false

  var body: some View {
    ZStack {
      Circle()
        .fill(backgroundColor)
      icon
        .font(.title3.weight(.semibold))
        .foregroundStyle(iconColor)
    }
    .frame(width: 54, height: 54)
    .contentShape(Circle())
    .shadow(color: iconColor.opacity(isTargeted ? 0.28 : 0.16), radius: isTargeted ? 9 : 5, x: 0, y: 3)
    .scaleEffect(isTargeted ? 1.10 : 1.0)
    .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isTargeted)
    .onDrop(of: [UTType.plainText], isTargeted: $isTargeted, perform: handleDrop(providers:))
    .help("Drop a message card to \(action.label.lowercased()) it")
    .accessibilityLabel(action.label)
  }

  @ViewBuilder
  private var icon: some View {
    switch action {
    case .trash:
      PrioritiesTrashIcon()
        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        .frame(width: 28, height: 28)
    case .archive:
      Image(systemName: action.systemImage)
    }
  }

  private var iconColor: Color {
    switch action {
    case .trash: return .white
    case .archive: return .purple
    }
  }

  private var backgroundColor: Color {
    switch action {
    case .trash:
      return isTargeted ? Color.red.opacity(0.92) : Color.red.opacity(0.78)
    case .archive:
      return isTargeted ? Color.purple.opacity(0.24) : Color.purple.opacity(0.15)
    }
  }

  private func handleDrop(providers: [NSItemProvider]) -> Bool {
    guard let provider = providers.first(where: { $0.canLoadObject(ofClass: NSString.self) }) else {
      return false
    }
    provider.loadObject(ofClass: NSString.self) { object, _ in
      guard let rawValue = object as? String else { return }
      let messageID: String
      if rawValue.hasPrefix(messageDragPayloadPrefix) {
        messageID = String(rawValue.dropFirst(messageDragPayloadPrefix.count))
      } else {
        messageID = rawValue
      }
      Task { @MainActor in
        session.handleMessageDrop(id: messageID, action: action)
      }
    }
    return true
  }
}

private struct PrioritiesTrashIcon: Shape {
  func path(in rect: CGRect) -> Path {
    func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
      CGPoint(x: rect.minX + (x / 24.0) * rect.width, y: rect.minY + (y / 24.0) * rect.height)
    }

    var path = Path()
    path.move(to: point(4, 7))
    path.addLine(to: point(20, 7))
    path.move(to: point(10, 11))
    path.addLine(to: point(10, 17))
    path.move(to: point(14, 11))
    path.addLine(to: point(14, 17))
    path.move(to: point(5, 7))
    path.addLine(to: point(6, 19))
    path.addQuadCurve(to: point(8, 21), control: point(6, 21))
    path.addLine(to: point(16, 21))
    path.addQuadCurve(to: point(18, 19), control: point(18, 21))
    path.addLine(to: point(19, 7))
    path.move(to: point(9, 7))
    path.addLine(to: point(9, 4))
    path.addQuadCurve(to: point(10, 3), control: point(9, 3))
    path.addLine(to: point(14, 3))
    path.addQuadCurve(to: point(15, 4), control: point(15, 3))
    path.addLine(to: point(15, 7))
    return path
  }
}

private struct DraggableMessageCardModifier: ViewModifier {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem

  func body(content: Content) -> some View {
    content
      .opacity(session.draggingMessageID == message.id ? 0 : 1)
      .animation(.easeOut(duration: 0.12), value: session.draggingMessageID)
      .onDrag {
        session.beginDraggingMessage(message)
        return NSItemProvider(object: "\(messageDragPayloadPrefix)\(message.id)" as NSString)
      }
  }
}

private extension View {
  func draggableMessageCard(_ message: MessageItem) -> some View {
    modifier(DraggableMessageCardModifier(message: message))
  }
}

private struct PrimaryTabBar: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    HStack(spacing: 8) {
      TabButton(title: "New Senders", count: session.newSenderThreads.count, selected: session.selectedRoute == "new") {
        session.openNewSenders()
      }
      TabButton(title: "Inbox", count: session.snapshot.inbox.count, selected: session.selectedRoute == "inbox" || session.selectedRoute == "inbox-message") {
        session.openInbox(focusing: nil)
      }
      TabButton(title: "Mail", count: session.snapshot.threads.count, selected: session.selectedRoute == "mail") {
        session.openMail()
      }
    }
    .padding(.horizontal, 6)
    .frame(height: 34)
  }
}

private struct TabButton: View {
  let title: String
  let count: Int
  let selected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 7) {
        Text(title)
          .font(.callout.weight(selected ? .semibold : .regular))
        CountBadge(count: count)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(Capsule().fill(selected ? Color.accentColor.opacity(0.16) : Color.clear))
    }
    .buttonStyle(.plain)
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
      Section("Mailboxes") {
        ForEach(session.snapshot.mailboxes) { mailbox in
          SidebarMailboxRow(mailbox: mailbox)
            .tag("mailbox:\(mailbox.id)")
            .onTapGesture { session.openMailbox(mailbox) }
        }
        SidebarUtilityRow(title: "Drafts", systemImage: "square.and.pencil", count: session.snapshot.drafts.count)
          .tag("drafts")
          .onTapGesture { session.openDrafts() }
        SidebarUtilityRow(title: "Events", systemImage: "waveform.path.ecg", count: session.snapshot.events.count)
          .tag("events")
          .onTapGesture { session.openEvents() }
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
      Section {
        SidebarUtilityRow(title: "Settings", systemImage: "gearshape", count: 0)
          .tag("settings")
          .onTapGesture { session.openSettingsRoute() }
      }
    }
    .listStyle(.sidebar)
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
          Text(thread.latest_at.isEmpty ? "No messages" : friendlyTime(thread.latest_at))
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

private struct SidebarMailboxRow: View {
  let mailbox: MailboxItem

  var body: some View {
    HStack(spacing: 9) {
      Image(systemName: mailboxIcon)
        .foregroundStyle(.secondary)
      VStack(alignment: .leading, spacing: 2) {
        Text(mailbox.title)
          .lineLimit(1)
        Text("\(mailbox.count) message\(mailbox.count == 1 ? "" : "s")")
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
      Spacer()
      CountBadge(count: mailbox.unread)
    }
  }

  private var mailboxIcon: String {
    switch mailbox.id {
    case "accepted": return "tray"
    case "quarantine": return "tray.and.arrow.down"
    case "spam": return "exclamationmark.octagon"
    case "banned": return "hand.raised"
    case "archive": return "archivebox"
    case "sent": return "paperplane"
    case "outbox": return "tray.and.arrow.up"
    case "trash": return "trash"
    default: return "folder"
    }
  }
}

private struct SidebarUtilityRow: View {
  let title: String
  let systemImage: String
  let count: Int

  var body: some View {
    HStack(spacing: 9) {
      Image(systemName: systemImage)
        .foregroundStyle(.secondary)
      Text(title)
      Spacer()
      CountBadge(count: count)
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
      if session.selectedRoute == "new" {
        NewSendersView()
      } else if session.selectedRoute == "inbox" {
        InboxView()
      } else if session.selectedRoute == "inbox-message" {
        MessageReaderView(message: session.activeMessage, emptyTitle: "No Inbox Message Selected")
      } else if session.selectedRoute == "mail" {
        MailView()
      } else {
        NewSendersView()
      }
    }
  }
}

private enum NewSendersFlowStage {
  case senders
  case messages
  case reader
}

private struct MessageSurfaceBackground: View {
  let tint: Color
  let tintOpacity: Double
  let edgeOpacity: Double
  let edge: Alignment
  let edgeWidth: CGFloat
  let controlOpacity: Double

  init(
    tint: Color,
    tintOpacity: Double,
    edgeOpacity: Double,
    edge: Alignment = .leading,
    edgeWidth: CGFloat = 5,
    controlOpacity: Double = 0.94
  ) {
    self.tint = tint
    self.tintOpacity = tintOpacity
    self.edgeOpacity = edgeOpacity
    self.edge = edge
    self.edgeWidth = edgeWidth
    self.controlOpacity = controlOpacity
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color(nsColor: .controlBackgroundColor).opacity(controlOpacity))
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .fill(tint.opacity(tintOpacity))
      }
      .overlay(alignment: edge) {
        RoundedRectangle(cornerRadius: 8)
          .fill(tint.opacity(edgeOpacity))
          .frame(width: edgeWidth)
      }
  }
}

private struct CardStackFrame<Content: View>: View {
  let depth: Int
  let badge: String?
  let tint: Color
  let isSelected: Bool
  let content: Content

  init(
    depth: Int = 1,
    badge: String? = nil,
    tint: Color = .accentColor,
    isSelected: Bool = false,
    @ViewBuilder content: () -> Content
  ) {
    self.depth = depth
    self.badge = badge
    self.tint = tint
    self.isSelected = isSelected
    self.content = content()
  }

  private var backCount: Int {
    min(max(depth - 1, 0), 4)
  }

  private var stackBadgeText: String? {
    guard depth > 3, let badge, !badge.isEmpty else { return nil }
    return badge
  }

  private var cardBackground: some View {
    MessageSurfaceBackground(
      tint: tint,
      tintOpacity: isSelected ? 0.022 : 0.014,
      edgeOpacity: isSelected ? 0.72 : 0.58,
      controlOpacity: isSelected ? 0.98 : 0.94
    )
  }

  private func stackedFill(_ index: Int) -> LinearGradient {
    LinearGradient(
      colors: [
        tint.opacity(0.055 - Double(index) * 0.006),
        Color(nsColor: .controlBackgroundColor).opacity(0.98)
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  var body: some View {
    content
      .padding(14)
      .background(
        cardBackground
      )
      .background {
        ZStack {
          ForEach(0..<backCount, id: \.self) { index in
            RoundedRectangle(cornerRadius: 8)
              .fill(stackedFill(index))
              .shadow(color: Color.black.opacity(0.13), radius: 5, x: 0, y: 2)
              .offset(x: stackOffsetX(index), y: -CGFloat(index + 1) * 5.4)
              .rotationEffect(.degrees(stackRotation(index)))
          }
        }
      }
      .overlay(alignment: .topTrailing) {
        if let badge = stackBadgeText {
          Text(badge)
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Capsule().fill(tint.opacity(0.86)))
            .shadow(color: Color.black.opacity(0.18), radius: 2, x: 0, y: 1)
            .offset(x: 8, y: -8)
        }
      }
      .shadow(color: tint.opacity(isSelected ? 0.10 : 0.05), radius: isSelected ? 10 : 7, x: 0, y: 4)
      .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
  }

  private func stackRotation(_ index: Int) -> Double {
    [-4.2, 3.6, -3.0, 2.4][index % 4]
  }

  private func stackOffsetX(_ index: Int) -> CGFloat {
    [-8.0, 6.0, -5.0, 4.0][index % 4]
  }
}

private struct NewSendersView: View {
  @EnvironmentObject private var session: OwlSession
  @State private var stage: NewSendersFlowStage = .senders

  var selectedMessage: MessageItem? {
    if let id = session.selectedMessageID, let match = session.newSenderMessages.first(where: { $0.id == id }) {
      return match
    }
    return session.newSenderMessages.first
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      newSendersHeader
      Divider()
      Group {
        switch stage {
        case .senders:
          NewSenderStackSurface(stage: $stage)
        case .messages:
          NewSenderMessageStackSurface(stage: $stage)
        case .reader:
          NewSenderReaderSurface(message: selectedMessage)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  private var newSendersHeader: some View {
    HStack(alignment: .center, spacing: 12) {
      if stage != .senders {
        Button {
          stage = stage == .reader ? .messages : .senders
        } label: {
          Label("Back", systemImage: "chevron.left")
        }
        .fixedSize()
      }
      VStack(alignment: .leading, spacing: 4) {
        Text(headerTitle)
          .font(.title2.weight(.semibold))
        Text(headerSubtitle)
          .font(.callout)
          .foregroundStyle(.secondary)
      }
      Spacer()
      if stage != .senders, session.selectedNewSender != nil {
        Button { session.moveSelectedNewSender(to: "accepted") } label: {
          Label("Accept", systemImage: "checkmark.circle")
        }
        .fixedSize()
        Button { session.moveSelectedNewSender(to: "spam") } label: {
          Label("Spam", systemImage: "exclamationmark.octagon")
        }
        .fixedSize()
        Button { session.moveSelectedNewSender(to: "banned") } label: {
          Label("Ban", systemImage: "hand.raised")
        }
        .fixedSize()
      }
    }
    .padding(.horizontal, 18)
    .padding(.vertical, 14)
  }

  private var headerTitle: String {
    switch stage {
    case .senders:
      return "New Senders"
    case .messages:
      return session.selectedNewSender?.displayName ?? "Messages"
    case .reader:
      return selectedMessage?.subject.isEmpty == false ? selectedMessage?.subject ?? "Message" : "Message"
    }
  }

  private var headerSubtitle: String {
    switch stage {
    case .senders:
      return "\(session.newSenderThreads.count) sender\(session.newSenderThreads.count == 1 ? "" : "s")"
    case .messages:
      return "\(session.newSenderMessages.count) quarantined message\(session.newSenderMessages.count == 1 ? "" : "s")"
    case .reader:
      return selectedMessage.map { "\($0.contact_name) - \(friendlyTime($0.received_at))" } ?? "No message selected"
    }
  }
}

private struct NewSenderStackSurface: View {
  @EnvironmentObject private var session: OwlSession
  @Binding var stage: NewSendersFlowStage

  var body: some View {
    ScrollView {
      if session.newSenderThreads.isEmpty {
        EmptyStateView(title: "No New Senders", subtitle: "New sender cards will appear here.")
          .frame(maxWidth: .infinity, minHeight: 360)
      } else {
        LazyVStack(spacing: 30) {
          ForEach(session.newSenderThreads) { thread in
            NewSenderStackCard(thread: thread, isSelected: session.selectedNewSenderID == thread.id) {
              session.selectNewSender(thread)
              stage = .messages
            }
            .frame(maxWidth: 500)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
      }
    }
  }
}

private struct NewSenderStackCard: View {
  @EnvironmentObject private var session: OwlSession
  @State private var flickOffset: CGFloat = 0
  let thread: ThreadItem
  let isSelected: Bool
  let action: () -> Void

  private var quarantineMessages: [MessageItem] {
    thread.messages.filter { $0.list == "quarantine" }
  }

  private var latestMessage: MessageItem? {
    quarantineMessages.sorted(by: { $0.received_at > $1.received_at }).first
  }

  var body: some View {
    Button(action: action) {
      CardStackFrame(
        depth: max(1, quarantineMessages.count),
        badge: quarantineMessages.count > 3 ? String(quarantineMessages.count) : nil,
        tint: .orange,
        isSelected: isSelected
      ) {
        VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .firstTextBaseline, spacing: 9) {
            Image(systemName: thread.kind == "group" ? "person.3.fill" : "person.crop.circle.badge.questionmark")
              .foregroundStyle(.orange)
            Text(thread.displayName)
              .font(.headline)
            Spacer()
            Text(friendlyTime(thread.latest_at))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          if let latest = latestMessage {
            Text(latest.subject.isEmpty ? "(no subject)" : latest.subject)
              .font(.subheadline.weight(.semibold))
              .lineLimit(1)
            Text(latest.displayBody.isEmpty ? latest.preview : latest.displayBody)
              .font(.callout)
              .foregroundStyle(.secondary)
              .lineLimit(2)
          }
          HStack {
            Spacer()
            if let latest = latestMessage {
              TransportPill(message: latest)
            }
          }
        }
      }
    }
    .buttonStyle(.plain)
    .offset(x: flickOffset)
    .rotationEffect(.degrees(Double(flickOffset / 28)))
    .opacity(flickOffset == 0 ? 1 : max(0.58, 1.0 - Double(abs(flickOffset) / 520.0)))
    .simultaneousGesture(newSenderFlickGesture)
    .animation(.spring(response: 0.24, dampingFraction: 0.82), value: flickOffset)
  }

  private var newSenderFlickGesture: some Gesture {
    DragGesture(minimumDistance: 18)
      .onChanged { value in
        guard abs(value.translation.width) > abs(value.translation.height) else { return }
        flickOffset = value.translation.width
      }
      .onEnded { value in
        let projected = value.predictedEndTranslation.width
        guard abs(projected) > 170 || abs(value.translation.width) > 120 else {
          flickOffset = 0
          return
        }
        let destination = projected >= 0 ? "accepted" : "spam"
        flickOffset = projected >= 0 ? 900 : -900
        session.moveNewSender(thread, to: destination)
        Task {
          try? await Task.sleep(nanoseconds: 260_000_000)
          flickOffset = 0
        }
      }
  }
}

private struct NewSenderMessageStackSurface: View {
  @EnvironmentObject private var session: OwlSession
  @Binding var stage: NewSendersFlowStage

  var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        if session.newSenderMessages.isEmpty {
          EmptyStateView(title: "No Messages", subtitle: "This sender has no pending messages.")
            .frame(maxWidth: .infinity, minHeight: 360)
        } else {
          LazyVStack(spacing: 30) {
            ForEach(session.newSenderMessages) { message in
              NewSenderMessageStackCard(message: message, isSelected: session.selectedMessageID == message.id) {
                session.selectMessage(message)
                stage = .reader
              }
              .id(message.id)
              .frame(maxWidth: 540)
            }
          }
          .frame(maxWidth: .infinity)
          .padding(24)
        }
      }
      .onAppear {
        if let target = session.selectedMessageID {
          proxy.scrollTo(target, anchor: .center)
        }
      }
    }
  }
}

private struct NewSenderMessageStackCard: View {
  let message: MessageItem
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      CardStackFrame(depth: 1, tint: message.isSimpleX ? .green : .red, isSelected: isSelected) {
        VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .firstTextBaseline, spacing: 8) {
            TransportMark(message: message)
            Text(message.subject.isEmpty ? "(no subject)" : message.subject)
              .font(.headline)
              .lineLimit(1)
            Spacer()
            Text(friendlyTime(message.received_at))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Text(message.contact_name)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
          Text(message.displayBody.isEmpty ? "No preview" : message.displayBody)
            .font(.body)
            .lineLimit(message.isLongBlock ? 5 : 3)
          HStack {
            TransportPill(message: message)
            if message.attachments > 0 {
              Label("\(message.attachments)", systemImage: "paperclip")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }
        }
      }
    }
    .buttonStyle(.plain)
    .draggableMessageCard(message)
    .contextMenu { MessageContextMenu(message: message) }
  }
}

private struct NewSenderReaderSurface: View {
  let message: MessageItem?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        if let message {
          MessageReaderCard(message: message)
            .frame(maxWidth: 760)
        } else {
          EmptyStateView(title: "No Message Selected", subtitle: "Choose a message card.")
            .frame(maxWidth: .infinity, minHeight: 360)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(24)
    }
  }
}

private struct MailView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    HStack(spacing: 0) {
      ContactListView()
        .frame(minWidth: 240, idealWidth: 290, maxWidth: 360)
      Divider()
      if session.selectedThread != nil {
        TimelineView()
      } else {
        EmptyStateView(title: "No Contact Selected", subtitle: "Choose a contact or group.")
      }
    }
  }
}

private struct ContactListView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HeaderView(title: "Mail", subtitle: "\(session.snapshot.threads.count) contacts")
      Divider()
      List(selection: $session.selectedMailThreadID) {
        if !session.snapshot.favorites.isEmpty {
          Section("Favorites") {
            ForEach(session.snapshot.favorites) { thread in
              SidebarThreadRow(thread: thread)
                .tag(thread.id)
                .onTapGesture { session.selectThread(thread) }
            }
          }
        }
        Section("Individuals") {
          ForEach(session.snapshot.individuals) { thread in
            SidebarThreadRow(thread: thread)
              .tag(thread.id)
              .onTapGesture { session.selectThread(thread) }
          }
        }
        Section("Groups") {
          ForEach(session.snapshot.groups) { thread in
            SidebarThreadRow(thread: thread)
              .tag(thread.id)
              .onTapGesture { session.selectThread(thread) }
          }
        }
      }
      .listStyle(.sidebar)
    }
  }
}

private struct MessageListRow: View {
  let message: MessageItem

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 10) {
      TransportMark(message: message)
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(message.contact_name)
            .font(.body.weight(message.read ? .regular : .semibold))
          if message.in_inbox {
            Text("Inbox")
              .font(.caption2.weight(.semibold))
              .padding(.horizontal, 6)
              .padding(.vertical, 1)
              .background(Capsule().fill(Color.accentColor.opacity(0.15)))
          }
          Spacer()
          Text(friendlyTime(message.received_at))
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        Text(message.subject.isEmpty ? message.preview : message.subject)
          .lineLimit(1)
        Text(message.displayBody)
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(2)
      }
    }
    .padding(.vertical, 4)
  }
}

private struct MessageReaderView: View {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem?
  let emptyTitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if let message {
        HStack(alignment: .center, spacing: 12) {
          Button { session.openInbox(focusing: message.id) } label: {
            Image(systemName: "chevron.left")
          }
          .buttonStyle(.borderless)
          .help("Back to Inbox")
          VStack(alignment: .leading, spacing: 4) {
            Text(message.subject.isEmpty ? message.contact_name : message.subject)
              .font(.title2.weight(.semibold))
              .lineLimit(1)
            Text("\(message.contact_name) - \(friendlyTime(message.received_at))")
              .font(.callout)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button { session.openTimeline(for: message) } label: {
            Image(systemName: "bubble.left.and.bubble.right")
          }
          .buttonStyle(.borderless)
          .help("Show this message in Mail")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        Divider()
        ScrollView {
          VStack(alignment: .leading, spacing: 14) {
            HStack {
              TransportPill(message: message)
              if message.in_inbox {
                Button { session.openInbox(focusing: message.id) } label: {
                  Label("Inbox", systemImage: "tray.full")
                }
                .buttonStyle(.borderless)
              }
            }
            Text(message.displayBody.isEmpty ? "No content" : message.displayBody)
              .font(.body)
              .textSelection(.enabled)
              .fixedSize(horizontal: false, vertical: true)
            HStack {
              Button { session.archive(message) } label: {
                Label("Remove From Inbox", systemImage: "archivebox")
              }
              Button { session.markRead(message, read: !message.read) } label: {
                Label(message.read ? "Mark Unread" : "Mark Read", systemImage: message.read ? "envelope.badge" : "envelope.open")
              }
              Button(role: .destructive) { session.delete(message) } label: {
                Label("Delete", systemImage: "trash")
              }
            }
          }
          .padding(18)
          .frame(maxWidth: 760, alignment: .leading)
          .background(
            MessageSurfaceBackground(
              tint: message.isSimpleX ? .green : .red,
              tintOpacity: 0.110,
              edgeOpacity: 0.64,
              edgeWidth: 4,
              controlOpacity: 0.98
            )
          )
          .shadow(color: (message.isSimpleX ? Color.green : Color.red).opacity(0.05), radius: 8, x: 0, y: 3)
          .padding(18)
        }
      } else {
        EmptyStateView(title: emptyTitle, subtitle: "Select a message.")
      }
    }
  }
}

private struct InboxView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HeaderView(title: "Inbox", subtitle: "\(session.snapshot.inbox.count) item\(session.snapshot.inbox.count == 1 ? "" : "s")")
      Divider()
      ScrollViewReader { proxy in
        ScrollView {
          if session.snapshot.inbox.isEmpty {
            EmptyStateView(title: "Inbox Is Clear", subtitle: "Inbox cards will appear here.")
              .frame(maxWidth: .infinity, minHeight: 420)
          } else {
            LazyVStack(spacing: 32) {
              ForEach(inboxStackCards) { message in
                InboxStackCard(
                  message: message,
                  stackDepth: inboxStackDepth(for: message),
                  isFocused: isFocusedStack(message)
                )
                .id(inboxStackID(for: message))
                .frame(maxWidth: 560)
              }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
          }
        }
        .onAppear {
          if let target = focusedStackID {
            proxy.scrollTo(target, anchor: .center)
          }
        }
        .onChange(of: session.focusedMessageID) { target in
          if target != nil, let stackID = focusedStackID {
            withAnimation { proxy.scrollTo(stackID, anchor: .center) }
          }
        }
      }
    }
  }

  private var inboxStackCards: [MessageItem] {
    let grouped = Dictionary(grouping: session.snapshot.inbox, by: { inboxStackKey(for: $0) })
    return grouped.values.compactMap { messages in
      messages.sorted { $0.received_at > $1.received_at }.first
    }
    .sorted { $0.received_at > $1.received_at }
  }

  private var focusedStackID: String? {
    guard let focusedMessage = session.activeMessage else { return nil }
    return inboxStackID(for: focusedMessage)
  }

  private func inboxStackDepth(for message: MessageItem) -> Int {
    let key = inboxStackKey(for: message)
    let peerCount = session.snapshot.inbox.filter { inboxStackKey(for: $0) == key }.count
    return max(1, peerCount)
  }

  private func isFocusedStack(_ message: MessageItem) -> Bool {
    guard let focusedMessage = session.activeMessage else { return false }
    return inboxStackKey(for: focusedMessage) == inboxStackKey(for: message)
  }

  private func inboxStackID(for message: MessageItem) -> String {
    "inbox-stack:\(inboxStackKey(for: message))"
  }

  private func inboxStackKey(for message: MessageItem) -> String {
    message.thread_id.isEmpty ? message.id : message.thread_id
  }
}

private struct MailboxView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HeaderView(title: session.selectedMailbox?.title ?? session.selectedMailboxID?.capitalized ?? "Mailbox", subtitle: "\(session.mailboxMessages.count) messages")
      Divider()
      List(session.mailboxMessages) { message in
        MailboxMessageRow(message: message)
          .tag(message.id)
      }
      .listStyle(.inset)
    }
  }
}

private struct MailboxMessageRow: View {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem

  var body: some View {
    Button {
      session.selectMessage(message)
      session.openTimeline(for: message)
    } label: {
      HStack(alignment: .firstTextBaseline, spacing: 10) {
        TransportMark(message: message)
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text(message.contact_name)
              .font(.body.weight(message.read ? .regular : .semibold))
            if message.starred {
              Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            }
            Spacer()
            Text(friendlyTime(message.received_at))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Text(message.subject.isEmpty ? message.preview : message.subject)
            .lineLimit(1)
          Text(message.displayBody)
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(2)
        }
      }
      .padding(.vertical, 4)
    }
    .buttonStyle(.plain)
    .contextMenu { MessageContextMenu(message: message) }
  }
}

private struct DraftsView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HeaderView(title: "Drafts", subtitle: "\(session.snapshot.drafts.count) saved drafts")
      Divider()
      List(session.snapshot.drafts) { draft in
        VStack(alignment: .leading, spacing: 5) {
          HStack {
            Text(draft.subject.isEmpty ? "Untitled Draft" : draft.subject)
              .font(.body.weight(.semibold))
            Spacer()
            Text(friendlyTime(draft.updated_at))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Text(draft.to)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
      }
      .listStyle(.inset)
    }
  }
}

private struct EventsView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HeaderView(title: "Events", subtitle: "\(session.snapshot.events.count) backend events")
      Divider()
      List(session.snapshot.events) { event in
        VStack(alignment: .leading, spacing: 5) {
          HStack {
            Text(event.kind.isEmpty ? "Event" : event.kind)
              .font(.body.weight(.semibold))
            Spacer()
            Text(friendlyTime(event.created_at))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Text(event.message)
            .font(.callout)
            .textSelection(.enabled)
        }
        .padding(.vertical, 5)
      }
      .listStyle(.inset)
    }
  }
}

private struct MessageReaderCard: View {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem

  var body: some View {
    CardStackFrame(depth: 1, tint: message.isSimpleX ? .green : .red, isSelected: true) {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .firstTextBaseline) {
          TransportMark(message: message)
          Text(message.contact_name)
            .font(.headline)
          Spacer()
          Text(friendlyTime(message.received_at))
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
          Button { session.archive(message) } label: {
            Label("Remove From Inbox", systemImage: "archivebox")
          }
            .buttonStyle(.borderless)
        }
      }
    }
    .draggableMessageCard(message)
    .contextMenu { MessageContextMenu(message: message) }
  }
}

private struct InboxStackCard: View {
  @EnvironmentObject private var session: OwlSession
  @State private var flickOffset: CGFloat = 0
  let message: MessageItem
  let stackDepth: Int
  let isFocused: Bool

  var body: some View {
    CardStackFrame(
      depth: stackDepth,
      badge: stackDepth > 3 ? String(stackDepth) : nil,
      tint: message.isSimpleX ? .green : .red,
      isSelected: isFocused
    ) {
      VStack(alignment: .leading, spacing: 10) {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
          TransportMark(message: message)
          Text(message.contact_name)
            .font(.headline)
          if message.starred {
            Image(systemName: "star.fill")
              .font(.caption)
              .foregroundStyle(.yellow)
          }
          Spacer()
          Text(friendlyTime(message.received_at))
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        if !message.subject.isEmpty {
          Text(message.subject)
            .font(.subheadline.weight(.semibold))
            .lineLimit(2)
        }
        Text(message.displayBody.isEmpty ? "No preview" : message.displayBody)
          .font(message.isLongBlock ? .body : .callout)
          .foregroundStyle(.primary)
          .lineLimit(message.isLongBlock ? 6 : 3)
        HStack(spacing: 8) {
          TransportPill(message: message)
          if message.attachments > 0 {
            Label("\(message.attachments)", systemImage: "paperclip")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button { session.markRead(message, read: !message.read) } label: {
            Label(message.read ? "Mark Unread" : "Mark Read", systemImage: message.read ? "envelope.badge" : "envelope.open")
          }
          .buttonStyle(.borderless)
          Button { session.archive(message) } label: {
            Label("Remove From Inbox", systemImage: "archivebox")
          }
          .buttonStyle(.borderless)
        }
      }
    }
    .contentShape(RoundedRectangle(cornerRadius: 8))
    .draggableMessageCard(message)
    .offset(x: flickOffset)
    .rotationEffect(.degrees(Double(flickOffset / 34)))
    .opacity(flickOffset == 0 ? 1 : max(0.62, 1.0 - Double(abs(flickOffset) / 560.0)))
    .simultaneousGesture(inboxArchiveFlickGesture)
    .onTapGesture { session.openInboxMessage(message) }
    .contextMenu { MessageContextMenu(message: message) }
    .animation(.spring(response: 0.24, dampingFraction: 0.82), value: flickOffset)
  }

  private var inboxArchiveFlickGesture: some Gesture {
    DragGesture(minimumDistance: 18)
      .onChanged { value in
        guard abs(value.translation.width) > abs(value.translation.height) else { return }
        flickOffset = value.translation.width
      }
      .onEnded { value in
        let projected = value.predictedEndTranslation.width
        guard abs(projected) > 170 || abs(value.translation.width) > 120 else {
          flickOffset = 0
          return
        }
        flickOffset = projected >= 0 ? 900 : -900
        session.archive(message)
        Task {
          try? await Task.sleep(nanoseconds: 260_000_000)
          flickOffset = 0
        }
      }
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
    return "\(count) timeline item\(count == 1 ? "" : "s")" + (paths.isEmpty ? "" : " - \(paths)")
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
          Text(friendlyTime(message.received_at))
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
            Button { session.archive(message) } label: {
              Label("Remove From Inbox", systemImage: "archivebox")
            }
              .buttonStyle(.borderless)
          }
          Button { session.markRead(message, read: !message.read) } label: {
            Label(message.read ? "Mark Unread" : "Mark Read", systemImage: message.read ? "envelope.badge" : "envelope.open")
          }
            .buttonStyle(.borderless)
        }
      }
      .padding(message.isLongBlock ? 14 : 10)
      .frame(maxWidth: message.isLongBlock ? 620 : 430, alignment: .leading)
      .background(messageBackground)
      .opacity(message.in_inbox ? 0.62 : 1.0)
      .shadow(color: messageTint.opacity(message.from_self ? 0.10 : 0.07), radius: 6, x: 0, y: 2)
      .contextMenu { MessageContextMenu(message: message) }
      .onTapGesture { session.selectMessage(message) }
      if !message.from_self { Spacer(minLength: 80) }
    }
    .draggableMessageCard(message)
  }

  private var messageBackground: some View {
    MessageSurfaceBackground(
      tint: messageTint,
      tintOpacity: message.from_self ? 0.030 : 0.020,
      edgeOpacity: message.from_self ? 0.70 : 0.58,
      edge: message.from_self ? .trailing : .leading,
      edgeWidth: 4,
      controlOpacity: message.from_self ? 0.97 : 0.93
    )
  }

  private var messageTint: Color {
    if message.from_self {
      return .accentColor
    }
    return message.isSimpleX ? .green : .red
  }
}

private struct MessageContextMenu: View {
  @EnvironmentObject private var session: OwlSession
  let message: MessageItem

  var body: some View {
    Button { session.archive(message) } label: {
      Label("Remove From Inbox", systemImage: "archivebox")
    }
    Button { session.markRead(message, read: !message.read) } label: {
      Label(message.read ? "Mark Unread" : "Mark Read", systemImage: message.read ? "envelope.badge" : "envelope.open")
    }
    Button { session.toggleStar(message) } label: {
      Label(message.starred ? "Unstar" : "Star", systemImage: message.starred ? "star.slash" : "star")
    }
    Divider()
    Button(role: .destructive) { session.delete(message) } label: {
      Label("Delete", systemImage: "trash")
    }
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

private struct SettingsView: View {
  @EnvironmentObject private var session: OwlSession

  var body: some View {
    Form {
      Section("Mail Root") {
        HStack {
          TextField("Mail root", text: $session.mailRoot)
            .textFieldStyle(.roundedBorder)
            .frame(width: 360)
          Button { session.chooseMailRoot() } label: {
            Label("Choose", systemImage: "folder")
          }
        }
      }
      Section("Email") {
        HStack {
          TextField("Domain", text: $session.settingsDomainDraft)
            .textFieldStyle(.roundedBorder)
            .frame(width: 220)
          Button { session.saveEmailDomain() } label: {
            Label("Save", systemImage: "checkmark")
          }
          Button { session.verifyEmailDomain() } label: {
            Label("Verify", systemImage: "checkmark.seal")
          }
        }
        HStack {
          TextField("Test recipient", text: $session.settingsTestRecipientDraft)
            .textFieldStyle(.roundedBorder)
            .frame(width: 260)
          Button { session.saveTestRecipient() } label: {
            Label("Save", systemImage: "person.crop.circle.badge.checkmark")
          }
        }
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
          GridRow {
            Text("Domain")
              .foregroundStyle(.secondary)
            Text(session.snapshot.settings.domain_configured ? "configured" : "missing")
          }
          GridRow {
            Text("TLS")
              .foregroundStyle(.secondary)
            Text(session.snapshot.settings.ssl_ready ? "ready" : "not ready")
          }
          GridRow {
            Text("Folders")
              .foregroundStyle(.secondary)
            Text(session.snapshot.settings.folders_ready ? "ready" : "missing")
          }
        }
        HStack {
          Button { session.runBackendAction("settings-setup-folders", status: "Mail folders checked") } label: {
            Label("Setup Folders", systemImage: "folder.badge.gearshape")
          }
          Button { session.runBackendAction("settings-setup-ssl", args: ["auto"], status: "TLS setup finished") } label: {
            Label("Setup TLS", systemImage: "lock.shield")
          }
        }
      }
      Section("Daemon") {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
          GridRow {
            Text("Manager")
              .foregroundStyle(.secondary)
            Text(session.snapshot.settings.daemon.manager.isEmpty ? "unknown" : session.snapshot.settings.daemon.manager)
          }
          GridRow {
            Text("Installed")
              .foregroundStyle(.secondary)
            Text(session.snapshot.settings.daemon.installed ? "yes" : "no")
          }
          GridRow {
            Text("Running")
              .foregroundStyle(.secondary)
            Text(session.snapshot.settings.daemon.running ? "yes" : "no")
          }
        }
        HStack {
          Button { session.runBackendAction("settings-set-daemon-installed", args: ["on"], status: "Daemon installed") } label: {
            Label("Install", systemImage: "square.and.arrow.down")
          }
          Button { session.setDaemonRunning(true) } label: {
            Label("Start", systemImage: "play.fill")
          }
          Button { session.setDaemonRunning(false) } label: {
            Label("Stop", systemImage: "stop.fill")
          }
          Toggle("Launch at Login", isOn: Binding(
            get: { session.snapshot.settings.daemon.startup_enabled },
            set: { session.setDaemonStartup($0) }
          ))
          .fixedSize()
        }
      }
      Section("Remote") {
        HStack {
          TextField("Host", text: $session.remoteHostDraft)
            .textFieldStyle(.roundedBorder)
            .frame(width: 180)
          TextField("SSH key", text: $session.remoteKeyPathDraft)
            .textFieldStyle(.roundedBorder)
            .frame(width: 220)
          TextField("Port", text: $session.remotePortDraft)
            .textFieldStyle(.roundedBorder)
            .frame(width: 70)
        }
        HStack {
          Button { session.saveRemoteTarget() } label: {
            Label("Save", systemImage: "checkmark")
          }
          Button { session.verifyRemote() } label: {
            Label("Verify", systemImage: "network")
          }
          Button { session.syncRemote() } label: {
            Label("Sync", systemImage: "arrow.triangle.2.circlepath")
          }
        }
      }
      Section("Filtering") {
        HStack {
          Button { session.classifySpam() } label: {
            Label("Classify Spam", systemImage: "line.3.horizontal.decrease.circle")
          }
          Button { session.openEvents() } label: {
            Label("Events", systemImage: "waveform.path.ecg")
          }
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
            Text("Transport")
              .foregroundStyle(.secondary)
            Text(session.bootstrap.hook_ready ? "ready" : "not configured")
          }
          GridRow {
            Text("Binary")
              .foregroundStyle(.secondary)
            Text(session.bootstrap.binary_path.isEmpty ? session.snapshot.simplex.system_root : session.bootstrap.binary_path)
              .lineLimit(2)
          }
          GridRow {
            Text("Hook")
              .foregroundStyle(.secondary)
            Text(session.bootstrap.hook_path.isEmpty ? "none" : session.bootstrap.hook_path)
              .lineLimit(2)
          }
        }
        HStack {
          Button { session.installSimpleX() } label: {
            Label("Install CLI", systemImage: "square.and.arrow.down")
          }
          Button { session.provisionSimpleX() } label: {
            Label("Provision Identity", systemImage: "person.badge.key")
          }
          Button { session.configureSimpleXLocalTransport() } label: {
            Label("Enable Local Transport", systemImage: "externaldrive.connected.to.line.below")
          }
          Button { session.tickSimpleX() } label: {
            Label("Check", systemImage: "arrow.clockwise")
          }
        }
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
    root: defaultMailRoot(),
    inbox: [email, groupMessage],
    favorites: [alice, river],
    individuals: [alice],
    groups: [river],
    threads: [river, alice],
    messages: [email, simplex, groupMessage],
    mailboxes: [
      MailboxItem(id: "accepted", title: "Accepted", count: 1, unread: 1),
      MailboxItem(id: "archive", title: "Archive"),
      MailboxItem(id: "sent", title: "Sent")
    ],
    drafts: [],
    events: [],
    overview: Overview(counts: OverviewCounts(inbox_messages: 2, new_messages: 0, archive_messages: 0, trash_messages: 0, drafts: 0, sent: 0)),
    simplex: SimpleXSnapshot(install_state: "missing")
  )
}
