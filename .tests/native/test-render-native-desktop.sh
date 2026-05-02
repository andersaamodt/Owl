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
  grep -q 'NavigationSplitView' generated/macos/Sources/App/App.swift
  grep -q 'NSApplicationDelegate' generated/macos/Sources/App/App.swift
  grep -q 'NSWindow(' generated/macos/Sources/App/App.swift
  grep -q 'NSHostingView(rootView:' generated/macos/Sources/App/App.swift
  grep -q 'app.run()' generated/macos/Sources/App/App.swift
  grep -q 'NSOpenPanel' generated/macos/Sources/App/App.swift
  grep -q 'setActivationPolicy(.regular)' generated/macos/Sources/App/App.swift
  grep -q 'Process()' generated/macos/Sources/App/App.swift
  grep -q 'process.arguments = \\[script.path, action, root\\] + args' generated/macos/Sources/App/App.swift
  ! grep -q 'WKWebView' generated/macos/Sources/App/App.swift
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

linux_uses_native_gtk_and_argv_backend() {
  cd "$repo_dir"
  grep -q 'gtk_header_bar_new' generated/linux/src/main.c
  grep -q 'gtk_search_entry_new' generated/linux/src/main.c
  grep -q 'gtk_list_box_new' generated/linux/src/main.c
  grep -q 'gtk_text_view_new' generated/linux/src/main.c
  grep -q 'g_spawn_sync' generated/linux/src/main.c
  grep -q 'g_ptr_array_add(argv, (char *)"/bin/sh");' generated/linux/src/main.c
  grep -q 'g_ptr_array_add(argv, script_path);' generated/linux/src/main.c
  ! grep -q '/bin/sh -c' generated/linux/src/main.c
}

run_case "render is deterministic" render_is_deterministic
run_case "generated sources have no template tokens" generated_sources_have_no_template_tokens
run_case "Swift actions cover IR" swift_actions_cover_ir
run_case "Linux actions cover IR" linux_actions_cover_ir
run_case "Swift uses native desktop idiom" swift_uses_native_desktop_idiom
run_case "Swift has unified SimpleX/email UI" swift_unified_simplex_email_ui_exists
run_case "Linux uses GTK native backend bridge" linux_uses_native_gtk_and_argv_backend

if [ "$failures" -ne 0 ]; then
  printf '%s\n' "$failures test(s) failed" >&2
  exit 1
fi

printf '%s\n' "7/7 native render tests passed"
