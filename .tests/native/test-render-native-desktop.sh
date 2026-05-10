#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
repo_dir=$(CDPATH= cd -- "$test_dir/../.." && pwd -P)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/owl-native-render-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

failures=0

run_case() {
  name=$1
  shift
  if "$@"; then
    printf 'ok - %s\n' "$name"
  else
    printf 'not ok - %s\n' "$name" >&2
    failures=$((failures + 1))
  fi
}

render_is_deterministic() {
  cd "$repo_dir"
  sh scripts/render-native-desktop.sh >"$tmpdir/render.out"
  git diff --exit-code -- generated/macos/Package.swift generated/macos/Sources/App/App.swift generated/linux/meson.build generated/linux/src/main.c
}

generated_sources_have_no_template_tokens() {
  cd "$repo_dir"
  ! grep -E '__[A-Z0-9_]+__' generated/macos/Sources/App/App.swift generated/linux/src/main.c
}

swift_actions_cover_ir() {
  cd "$repo_dir"
  jq -r '.app.actions[].id' ir/app.ir.yaml | sort >"$tmpdir/ir-actions"
  sed -n 's/^[[:space:]]*case "\([^"]*\)":.*/\1/p' generated/macos/Sources/App/App.swift | sort -u >"$tmpdir/swift-actions"
  missing=$(comm -23 "$tmpdir/ir-actions" "$tmpdir/swift-actions")
  [ -z "$missing" ] || {
    printf 'missing Swift actions:\n%s\n' "$missing" >&2
    return 1
  }
}

linux_actions_cover_ir() {
  cd "$repo_dir"
  jq -r '.app.actions[].id | gsub("_"; "-")' ir/app.ir.yaml | sort >"$tmpdir/ir-actions-linux"
  sed -n 's/.*add_app_action(app, context, "\([^"]*\)").*/\1/p' generated/linux/src/main.c | sort -u >"$tmpdir/linux-actions"
  sed -n 's/.*g_strcmp0(action_name, "\([^"]*\)").*/\1/p' generated/linux/src/main.c | sort -u >"$tmpdir/linux-handlers"
  missing_registered=$(comm -23 "$tmpdir/ir-actions-linux" "$tmpdir/linux-actions")
  missing_handlers=$(comm -23 "$tmpdir/ir-actions-linux" "$tmpdir/linux-handlers")
  [ -z "$missing_registered" ] || {
    printf 'missing Linux registrations:\n%s\n' "$missing_registered" >&2
    return 1
  }
  [ -z "$missing_handlers" ] || {
    printf 'missing Linux handlers:\n%s\n' "$missing_handlers" >&2
    return 1
  }
}

swift_uses_native_desktop_idiom() {
  cd "$repo_dir"
  grep -q 'PrimaryTabBar' generated/macos/Sources/App/App.swift
  grep -q 'NSTitlebarAccessoryViewController' generated/macos/Sources/App/App.swift
  grep -q 'window.titleVisibility = .hidden' generated/macos/Sources/App/App.swift
  grep -q 'installTitlebarTabs(in: window)' generated/macos/Sources/App/App.swift
  grep -q 'NewSendersView' generated/macos/Sources/App/App.swift
  grep -q 'MailView' generated/macos/Sources/App/App.swift
  grep -q 'TabButton(title: "New Senders"' generated/macos/Sources/App/App.swift
  grep -q 'TabButton(title: "Inbox"' generated/macos/Sources/App/App.swift
  grep -q 'TabButton(title: "Mail"' generated/macos/Sources/App/App.swift
  grep -q 'ArchiveTabButton(selected: session.selectedRoute == "archive")' generated/macos/Sources/App/App.swift
  grep -q 'func openArchive()' generated/macos/Sources/App/App.swift
  grep -q 'case "focus_archive":' generated/macos/Sources/App/App.swift
  grep -q 'NSApplicationDelegate' generated/macos/Sources/App/App.swift
  grep -q 'NSWindow(' generated/macos/Sources/App/App.swift
  grep -q 'NSHostingView(rootView:' generated/macos/Sources/App/App.swift
  grep -q 'app.run()' generated/macos/Sources/App/App.swift
  grep -q 'NSOpenPanel' generated/macos/Sources/App/App.swift
  grep -q 'setActivationPolicy(.regular)' generated/macos/Sources/App/App.swift
  grep -q 'Process()' generated/macos/Sources/App/App.swift
  grep -q 'process.arguments = \\[script.path, action, root\\] + args' generated/macos/Sources/App/App.swift
  grep -q 'NSApp.windowsMenu = windowMenu' generated/macos/Sources/App/App.swift
  grep -q 'let editMenu = NSMenu(title: "Edit")' generated/macos/Sources/App/App.swift
  grep -q 'let messageMenu = NSMenu(title: "Message")' generated/macos/Sources/App/App.swift
  grep -q 'set-ui-pref' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct RootView/ { in_view = 1 }
    /private enum MessageDropAction/ { in_view = 0 }
    in_view && /PrimaryTabBar[(][)]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
  ! grep -q 'WKWebView' generated/macos/Sources/App/App.swift
  ! grep -q 'UserDefaults' generated/macos/Sources/App/App.swift
}

swift_unified_simplex_email_ui_exists() {
  cd "$repo_dir"
  grep -q 'selectedTransport = thread.hasSimpleXPath ? .simplex : .email' generated/macos/Sources/App/App.swift
  grep -q 'Open-lock email path' generated/macos/Sources/App/App.swift
  grep -q 'Preferred secure path' generated/macos/Sources/App/App.swift
  grep -q 'session.openInbox(focusing: message.id)' generated/macos/Sources/App/App.swift
  grep -q 'message.in_inbox ? 0.62 : 1.0' generated/macos/Sources/App/App.swift
  grep -q 'TransportPill(message: message)' generated/macos/Sources/App/App.swift
}

swift_new_and_inbox_use_card_stack_layout() {
  cd "$repo_dir"
  grep -q 'CardStackFrame' generated/macos/Sources/App/App.swift
  grep -q 'NewSenderStackCard' generated/macos/Sources/App/App.swift
  grep -q 'NewSenderMessageStackCard' generated/macos/Sources/App/App.swift
  grep -q 'InboxStackCard' generated/macos/Sources/App/App.swift
  grep -Fq 'if stage != .senders {' generated/macos/Sources/App/App.swift
  ! grep -Fq 'HeaderView(title: "Inbox"' generated/macos/Sources/App/App.swift
  ! grep -Fq 'HeaderView(title: "Mail"' generated/macos/Sources/App/App.swift
  grep -Fq 'private var stackBadgeText: String?' generated/macos/Sources/App/App.swift
  grep -Fq 'guard depth > 3, let badge, !badge.isEmpty else { return nil }' generated/macos/Sources/App/App.swift
  grep -Fq 'badge: quarantineMessages.count > 3 ? String(quarantineMessages.count) : nil' generated/macos/Sources/App/App.swift
  grep -Fq 'badge: stackDepth > 3 ? String(stackDepth) : nil' generated/macos/Sources/App/App.swift
  grep -Fq 'LazyVStack(spacing: 32)' generated/macos/Sources/App/App.swift
  grep -Fq 'ForEach(inboxStackCards)' generated/macos/Sources/App/App.swift
  grep -Fq 'private var inboxStackCards: [MessageItem]' generated/macos/Sources/App/App.swift
  grep -Fq 'let grouped = Dictionary(grouping: session.snapshot.inbox, by: { inboxStackKey(for: $0) })' generated/macos/Sources/App/App.swift
  grep -Fq '.id(inboxStackID(for: message))' generated/macos/Sources/App/App.swift
  grep -Fq 'SidebarMailboxRow(mailbox: trashMailbox)' generated/macos/Sources/App/App.swift
  grep -Fq 'private var trashMailbox: MailboxItem' generated/macos/Sources/App/App.swift
  grep -Fq 'session.selectedRoute == "archive"' generated/macos/Sources/App/App.swift
  grep -Fq '.frame(maxWidth: 560)' generated/macos/Sources/App/App.swift
  grep -Fq 'offset(x: stackOffsetX(index), y: -CGFloat(index + 1) * 5.4)' generated/macos/Sources/App/App.swift
  grep -Fq '.background(Capsule().fill(tint.opacity(0.86)))' generated/macos/Sources/App/App.swift
  grep -Fq 'private var latestMessage: MessageItem?' generated/macos/Sources/App/App.swift
  ! grep -Fq 'Label("\\(quarantineMessages.count) pending", systemImage: "tray")' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct NewSendersView/ { in_view = 1 }
    /private struct MailView/ { in_view = 0 }
    in_view && /List[[:space:]]*[(]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct InboxView/ { in_view = 1 }
    /private struct MailboxView/ { in_view = 0 }
    in_view && /List[[:space:]]*[(]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
}

swift_mail_favorites_move_between_sections() {
  cd "$repo_dir"
  grep -Fq 'func applyContactBinding(threadID: String, name: String, email: String, simplex: String, favorite: Bool)' generated/macos/Sources/App/App.swift
  grep -Fq 'withAnimation(.spring(response: 0.30, dampingFraction: 0.86))' generated/macos/Sources/App/App.swift
  grep -Fq 'snapshot.favorites.removeAll { $0.id == threadID }' generated/macos/Sources/App/App.swift
  grep -Fq 'snapshot.favorites.insert(updated, at: 0)' generated/macos/Sources/App/App.swift
  grep -Fq '@Namespace private var threadMoveNamespace' generated/macos/Sources/App/App.swift
  grep -Fq '@State private var contactFilter: MailContactFilter = .all' generated/macos/Sources/App/App.swift
  grep -Fq '@State private var contactSort: MailContactSort = .recent' generated/macos/Sources/App/App.swift
  grep -Fq 'private enum MailContactFilter: String, CaseIterable' generated/macos/Sources/App/App.swift
  grep -Fq 'private enum MailContactSort: String, CaseIterable' generated/macos/Sources/App/App.swift
  grep -Fq 'Label("Favorites", systemImage: "line.3.horizontal.decrease.circle")' generated/macos/Sources/App/App.swift
  grep -Fq 'FriendlyTime.sortTimestamp(lhs.latest_at)' generated/macos/Sources/App/App.swift
  grep -Fq 'if lhsTime != rhsTime { return lhsTime > rhsTime }' generated/macos/Sources/App/App.swift
  grep -Fq 'private func sortedThreads(_ threads: [ThreadItem]) -> [ThreadItem]' generated/macos/Sources/App/App.swift
  grep -Fq '.matchedGeometryEffect(id: thread.id, in: threadMoveNamespace, properties: .position)' generated/macos/Sources/App/App.swift
  grep -Fq 'private func mailThreadRow(_ thread: ThreadItem) -> some View' generated/macos/Sources/App/App.swift
  grep -Fq 'private var favoriteThreads: [ThreadItem]' generated/macos/Sources/App/App.swift
  grep -Fq 'uniqueThreads(session.snapshot.favorites + session.snapshot.individuals.filter { $0.favorite } + session.snapshot.groups.filter { $0.favorite })' generated/macos/Sources/App/App.swift
  grep -Fq 'session.snapshot.individuals.filter { !favoriteThreadIDs.contains($0.id) && !$0.favorite }' generated/macos/Sources/App/App.swift
  grep -Fq 'session.snapshot.groups.filter { !favoriteThreadIDs.contains($0.id) && !$0.favorite }' generated/macos/Sources/App/App.swift
  awk '
    /private struct ContactListView/ { in_view = 1 }
    /private struct MessageListRow/ { in_view = 0 }
    in_view && /ForEach[(]session[.]snapshot[.](favorites|individuals|groups)/ { found = 1 }
    END { exit found ? 1 : 0 }
  ' generated/macos/Sources/App/App.swift
}

swift_cards_have_horizontal_flick_actions() {
  cd "$repo_dir"
  grep -Fq 'func moveNewSender(_ thread: ThreadItem, to list: String)' generated/macos/Sources/App/App.swift
  grep -Fq 'private struct SenderDropDock: View' generated/macos/Sources/App/App.swift
  grep -Fq 'SenderDropTarget(action: .accept)' generated/macos/Sources/App/App.swift
  grep -Fq 'SenderDropTarget(action: .reject)' generated/macos/Sources/App/App.swift
  grep -Fq 'SenderDropTarget(action: .spam)' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct SenderDropTarget/ { in_view = 1 }
    /private struct MessageDropDock/ { in_view = 0 }
    in_view && /Text[(]action[.]label[)]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
  grep -Fq 'func handleSenderDrop(threadID: String, action: SenderDropAction)' generated/macos/Sources/App/App.swift
  grep -Fq 'private let senderDragPayloadPrefix = "owl-native-sender:"' generated/macos/Sources/App/App.swift
  grep -Fq 'return NSItemProvider(object: "\(senderDragPayloadPrefix)\(thread.id)" as NSString)' generated/macos/Sources/App/App.swift
  grep -Fq 'return NSItemProvider(object: "\(senderDragPayloadPrefix)\(message.thread_id)" as NSString)' generated/macos/Sources/App/App.swift
  grep -Fq '@State private var expandedSenderID: String?' generated/macos/Sources/App/App.swift
  grep -Fq 'NewSenderExpandedMessageRow(message: message)' generated/macos/Sources/App/App.swift
  grep -Fq '.transition(.opacity.combined(with: .move(edge: .top)))' generated/macos/Sources/App/App.swift
  grep -Fq 'private var newSenderFlickGesture: some Gesture' generated/macos/Sources/App/App.swift
  grep -Fq 'let destination = projected >= 0 ? "accepted" : "spam"' generated/macos/Sources/App/App.swift
  grep -Fq 'session.moveNewSender(thread, to: destination)' generated/macos/Sources/App/App.swift
  grep -Fq 'private var cardDragGesture: some Gesture' generated/macos/Sources/App/App.swift
  grep -Fq 'let shouldFlickArchive = message.in_inbox && (abs(projected) > 180 || abs(value.translation.width) > 130)' generated/macos/Sources/App/App.swift
  grep -Fq 'session.archive(message)' generated/macos/Sources/App/App.swift
  grep -Fq '.simultaneousGesture(newSenderFlickGesture)' generated/macos/Sources/App/App.swift
  grep -Fq '.simultaneousGesture(cardDragGesture)' generated/macos/Sources/App/App.swift
}

swift_message_cards_are_drag_droppable() {
  cd "$repo_dir"
  grep -q 'PrioritiesTrashIcon' generated/macos/Sources/App/App.swift
  grep -q 'MessageDropTarget(action: .trash)' generated/macos/Sources/App/App.swift
  grep -q 'MessageDropTarget(action: .archive)' generated/macos/Sources/App/App.swift
  grep -Fq 'private var showsMessageDropDock: Bool' generated/macos/Sources/App/App.swift
  grep -Fq 'session.selectedRoute == "inbox-message"' generated/macos/Sources/App/App.swift
  ! grep -Fq 'session.selectedRoute == "mail" ||' generated/macos/Sources/App/App.swift
  grep -Fq '.contentShape(Circle())' generated/macos/Sources/App/App.swift
  grep -Fq 'case .trash: return .white' generated/macos/Sources/App/App.swift
  grep -Fq 'Color.red.opacity(0.78)' generated/macos/Sources/App/App.swift
  grep -Fq 'Color.purple.opacity(0.15)' generated/macos/Sources/App/App.swift
  grep -q 'func draggableMessageCard(_ message: MessageItem)' generated/macos/Sources/App/App.swift
  grep -q '@Published var draggingMessageID: String?' generated/macos/Sources/App/App.swift
  grep -q 'session.beginDraggingMessage(message)' generated/macos/Sources/App/App.swift
  grep -q 'return session.draggingMessageID == message.id ? 0 : 1' generated/macos/Sources/App/App.swift
  grep -Fq '.offset(dragOffset)' generated/macos/Sources/App/App.swift
  grep -Fq '.zIndex(isPointerDragging ? 20 : 0)' generated/macos/Sources/App/App.swift
  grep -q 'endDraggingMessage(id)' generated/macos/Sources/App/App.swift
  grep -q 'onDrop(of: \[UTType.plainText\]' generated/macos/Sources/App/App.swift
  grep -q 'session.handleMessageDrop(id: messageID, action: action)' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct MailboxMessageRow/ { in_view = 1 }
    /private struct DraftsView/ { in_view = 0 }
    in_view && /draggableMessageCard/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
}

swift_message_timestamps_are_friendly() {
  cd "$repo_dir"
  grep -q 'private enum FriendlyTime' generated/macos/Sources/App/App.swift
  grep -Fq 'return "\(compactDuration(delta)) ago"' generated/macos/Sources/App/App.swift
  grep -Fq 'Text(friendlyTime(message.received_at))' generated/macos/Sources/App/App.swift
  grep -Fq 'Text(thread.latest_at.isEmpty ? "No messages" : friendlyTime(thread.latest_at))' generated/macos/Sources/App/App.swift
  grep -Fq 'HeaderView(title: message.subject.isEmpty ? message.contact_name : message.subject, subtitle: "\(message.contact_name) - \(friendlyTime(message.received_at))")' generated/macos/Sources/App/App.swift
  ! grep -Fq 'Text(message.received_at)' generated/macos/Sources/App/App.swift
  ! grep -Fq 'Text(thread.latest_at)' generated/macos/Sources/App/App.swift
}

swift_inbox_cards_open_reader_before_mail() {
  cd "$repo_dir"
  grep -Fq 'selectedRoute = "inbox-message"' generated/macos/Sources/App/App.swift
  grep -Fq 'MessageReaderView(message: session.activeMessage, emptyTitle: "No Inbox Message Selected")' generated/macos/Sources/App/App.swift
  grep -Fq '.onTapGesture { session.openInboxMessage(message) }' generated/macos/Sources/App/App.swift
  grep -Fq '.help("Show this message in Mail")' generated/macos/Sources/App/App.swift
  grep -Fq 'Image(systemName: "bubble.left.and.bubble.right")' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct InboxStackCard/ { in_view = 1 }
    /private struct TimelineView/ { in_view = 0 }
    in_view && /openTimeline[(]for: message[)]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
}

swift_message_surfaces_use_colored_backgrounds() {
  cd "$repo_dir"
  grep -Fq 'private struct MessageSurfaceBackground: View' generated/macos/Sources/App/App.swift
  grep -Fq 'private var cardBackground: some View' generated/macos/Sources/App/App.swift
  grep -Fq 'tintOpacity: isSelected ? 0.022 : 0.014' generated/macos/Sources/App/App.swift
  grep -Fq 'private var messageTint: Color' generated/macos/Sources/App/App.swift
  grep -Fq 'tintOpacity: message.from_self ? 0.030 : 0.020' generated/macos/Sources/App/App.swift
  grep -Fq 'tintOpacity: 0.110' generated/macos/Sources/App/App.swift
  grep -Fq 'edgeOpacity: 0.64' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct CardStackFrame/ { in_view = 1 }
    /private struct NewSendersView/ { in_view = 0 }
    in_view && /[.]stroke[(]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
  ! awk '
    /private struct MessageBubble/ { in_view = 1 }
    /private struct MessageContextMenu/ { in_view = 0 }
    in_view && /[.]stroke[(]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
}

swift_new_sender_actions_skip_full_refresh() {
  cd "$repo_dir"
  grep -Fq 'func applySenderMove(sender: String, to list: String)' generated/macos/Sources/App/App.swift
  grep -Fq 'runMessageAction(status: "Moved sender to \(list)", refreshAfter: false)' generated/macos/Sources/App/App.swift
  grep -Fq 'self.applySenderMove(sender: sender, to: list)' generated/macos/Sources/App/App.swift
  grep -Fq 'if refreshAfter {' generated/macos/Sources/App/App.swift
  ! awk '
    /func moveSelectedNewSender/ { in_view = 1 }
    /func applySenderMove/ { in_view = 0 }
    in_view && /self[.]refresh[(][)]|refresh[(][)]/ { found = 1 }
    END { exit found ? 0 : 1 }
  ' generated/macos/Sources/App/App.swift
}

native_ui_has_no_manual_refresh_controls() {
  cd "$repo_dir"
  grep -Fq 'func applicationDidBecomeActive' generated/macos/Sources/App/App.swift
  grep -Fq 'session.refreshIfStale()' generated/macos/Sources/App/App.swift
  grep -Fq 'session.refreshIfStale(force: true)' generated/macos/Sources/App/App.swift
  grep -Fq 'func windowDidBecomeKey' generated/macos/Sources/App/App.swift
  grep -Fq 'func refreshIfStale(force: Bool = false)' generated/macos/Sources/App/App.swift
  ! grep -Fq 'refresh_snapshot' generated/macos/Sources/App/App.swift generated/linux/src/main.c ir/app.ir.yaml
  ! grep -Fq 'toolbar.refresh' generated/macos/Sources/App/App.swift generated/linux/src/main.c ir/app.ir.yaml
  ! grep -Fq 'menuitem.refresh' generated/macos/Sources/App/App.swift generated/linux/src/main.c ir/app.ir.yaml
  ! grep -Fq 'Label("Refresh"' generated/macos/Sources/App/App.swift
  ! grep -Fq 'view-refresh-symbolic' generated/linux/src/main.c
}

swift_uses_toasts_not_status_bar() {
  cd "$repo_dir"
  grep -Fq 'private struct ToastOverlay' generated/macos/Sources/App/App.swift
  grep -Fq '@Published var toastMessage: String' generated/macos/Sources/App/App.swift
  grep -Fq 'showToast(statusText, busy: isBusy)' generated/macos/Sources/App/App.swift
  grep -Fq '.transition(.move(edge: .top).combined(with: .opacity))' generated/macos/Sources/App/App.swift
  ! grep -Fq 'private struct StatusStrip' generated/macos/Sources/App/App.swift
  ! grep -Fq 'StatusStrip()' generated/macos/Sources/App/App.swift
  ! grep -Fq 'v\\(generatedAppVersion)' generated/macos/Sources/App/App.swift
  ! grep -Fq '"type": "StatusBar"' generated/macos/Sources/App/App.swift generated/linux/src/main.c ir/app.ir.yaml
}

linux_uses_native_gtk_and_argv_backend() {
  cd "$repo_dir"
  grep -q 'gtk_header_bar_new' generated/linux/src/main.c
  grep -q 'gtk_search_entry_new' generated/linux/src/main.c
  grep -q 'gtk_list_box_new' generated/linux/src/main.c
  grep -q 'gtk_text_view_new' generated/linux/src/main.c
  grep -q 'g_spawn_sync' generated/linux/src/main.c
  grep -q 'g_ptr_array_add(argv, (char *)"/bin/sh");' generated/linux/src/main.c
  grep -q 'g_ptr_array_add(argv, script_path);' generated/linux/src/main.c
  grep -q 'run_backend(context, "snapshot-lines", NULL, NULL)' generated/linux/src/main.c
  grep -q 'populate_snapshot_lines' generated/linux/src/main.c
  grep -q 'context->mailbox_list = gtk_list_box_new' generated/linux/src/main.c
  ! grep -q '/bin/sh -c' generated/linux/src/main.c
}

run_case "render is deterministic" render_is_deterministic
run_case "generated sources have no template tokens" generated_sources_have_no_template_tokens
run_case "Swift actions cover IR" swift_actions_cover_ir
run_case "Linux actions cover IR" linux_actions_cover_ir
run_case "Swift uses native desktop idiom" swift_uses_native_desktop_idiom
run_case "Swift has unified SimpleX/email UI" swift_unified_simplex_email_ui_exists
run_case "Swift New Senders and Inbox use card-stack layout" swift_new_and_inbox_use_card_stack_layout
run_case "Swift Mail favorites move between sections" swift_mail_favorites_move_between_sections
run_case "Swift cards have horizontal flick actions" swift_cards_have_horizontal_flick_actions
run_case "Swift message cards are drag droppable" swift_message_cards_are_drag_droppable
run_case "Swift message timestamps are friendly" swift_message_timestamps_are_friendly
run_case "Swift Inbox cards open reader before Mail" swift_inbox_cards_open_reader_before_mail
run_case "Swift message surfaces use colored backgrounds" swift_message_surfaces_use_colored_backgrounds
run_case "Swift new sender actions skip full refresh" swift_new_sender_actions_skip_full_refresh
run_case "Native UI has no manual refresh controls" native_ui_has_no_manual_refresh_controls
run_case "Swift uses toasts not status bar" swift_uses_toasts_not_status_bar
run_case "Linux uses GTK native backend bridge" linux_uses_native_gtk_and_argv_backend

if [ "$failures" -ne 0 ]; then
  printf '%s\n' "$failures test(s) failed" >&2
  exit 1
fi

printf '%s\n' "17/17 native render tests passed"
