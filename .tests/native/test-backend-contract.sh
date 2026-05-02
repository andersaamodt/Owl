#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
repo_dir=$(CDPATH= cd -- "$test_dir/../.." && pwd -P)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/owl-native-backend-test.XXXXXX")
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

backend() {
  HOME="$tmpdir/home" \
  XDG_STATE_HOME="$tmpdir/state" \
  XDG_CONFIG_HOME="$tmpdir/config" \
  sh "$repo_dir/scripts/owl-native-backend.sh" "$@"
}

backend_with_owl() {
  owl_backend=$1
  shift
  HOME="$tmpdir/home" \
  XDG_STATE_HOME="$tmpdir/state" \
  XDG_CONFIG_HOME="$tmpdir/config" \
  OWL_DESKTOP_BACKEND="$owl_backend" \
  sh "$repo_dir/scripts/owl-native-backend.sh" "$@"
}

b64() {
  printf '%s' "$1" | base64 | tr -d '\n'
}

write_fake_simplex_binary() {
  binary=$1
  cat >"$binary" <<'SH'
#!/bin/sh
[ "${1-}" = "-h" ] && exit 0
exit 0
SH
  chmod +x "$binary"
}

write_fake_owl_backend() {
  script=$1
  cat >"$script" <<'SH'
#!/bin/sh
set -eu
action=${1-}
root=${2-}
shift 2 >/dev/null 2>&1 || true
case "$action" in
  overview)
    jq -n --arg root "$root" '{ok:true,root:$root,counts:{inbox_messages:1,new_messages:1,archive_messages:1,trash_messages:1,drafts:1,outbox:1,sent:1}}'
    ;;
  settings-controls)
    jq -n '{ok:true,domain:"example.org",test_recipient:"test@example.org",daemon:{installed:false,running:false},llm:{enabled:false}}'
    ;;
  event-feed)
    jq -n '{ok:true,events:[{id:"evt-1",kind:"test",message:"fake event"}]}'
    ;;
  draft-list)
    jq -n '{ok:true,drafts:[{ulid:"draft-1",to:"alice@example.org",subject:"Draft note"}]}'
    ;;
  list-messages|list-messages-fast)
    list=${1-}
    case "$list" in
      accepted)
        jq -n --arg list "$list" '{ok:true,list:$list,messages:[{list:$list,sender:"Alice <alice@example.org>",ulid:"msg-1",subject:"Hello",preview:"Email preview",received_at:"2026-04-20T10:00:00Z",read:false,starred:true,attachments:1}]}'
        ;;
      archive)
        jq -n --arg list "$list" '{ok:true,list:$list,messages:[{list:$list,sender:"Bob <bob@example.org>",ulid:"msg-2",subject:"Archived",preview:"Archived preview",received_at:"2026-04-19T10:00:00Z",read:true}]}'
        ;;
      *)
        jq -n --arg list "$list" '{ok:true,list:$list,messages:[]}'
        ;;
    esac
    ;;
  get-message)
    list=${1-}
    sender=${2-}
    ulid=${3-}
    jq -n --arg list "$list" --arg sender "$sender" --arg ulid "$ulid" '{ok:true,list:$list,sender:$sender,ulid:$ulid,body:"Full fake body"}'
    ;;
  settings-set-domain)
    jq -n --arg domain "${1-}" '{ok:true,domain:$domain}'
    ;;
  *)
    jq -n --arg action "$action" --argjson argc "$#" '{ok:true,action:$action,argc:$argc}'
    ;;
esac
SH
  chmod +x "$script"
}

doctor_is_read_only() {
  root="$tmpdir/doctor/mail"
  mkdir -p "$tmpdir/home"
  output=$(backend doctor "$root")
  printf '%s\n' "$output" | jq -e '.ok == true and .root == "'"$root"'"' >/dev/null
  [ ! -e "$root" ]
}

prepare_creates_shared_roots() {
  root="$tmpdir/prepare/mail"
  mkdir -p "$tmpdir/home"
  backend prepare "$root" >/dev/null
  [ -d "$root/accepted" ] &&
    [ -d "$root/archive" ] &&
    [ -d "$root/.owl-native/simplex/threads" ] &&
    [ -d "$root/.owl-native/simplex/incoming" ] &&
    [ -d "$root/.owl-native/simplex/outbox" ]
}

simplex_messages_share_one_timeline_and_inbox() {
  root="$tmpdir/timeline/mail"
  mkdir -p "$tmpdir/home"
  backend prepare "$root" >/dev/null
  backend bind-contact "$root" alice "Alice Ledger" person alice@example.org simplex://alice yes >/dev/null
  backend import-simplex "$root" alice "$(b64 'Encrypted hello')" false true "SimpleX hello" >/dev/null
  snapshot=$(backend snapshot "$root")
  printf '%s\n' "$snapshot" | jq -e '
    .ok == true and
    (.inbox | length) == 1 and
    .inbox[0].transport == "simplex" and
    .inbox[0].lock == "closed" and
    .inbox[0].in_inbox == true and
    (.individuals | length) == 1 and
    .individuals[0].id == "alice" and
    .individuals[0].favorite == true and
    (.individuals[0].messages | length) == 1
  ' >/dev/null
}

simplex_send_queues_without_email_fallback() {
  root="$tmpdir/send/mail"
  mkdir -p "$tmpdir/home"
  backend prepare "$root" >/dev/null
  backend bind-contact "$root" bob "Bob Mail" person bob@example.org "" no >/dev/null
  if backend send-message "$root" bob simplex "No path" "$(b64 'do not fall back')" >"$tmpdir/send-no-simplex.out" 2>"$tmpdir/send-no-simplex.err"; then
    return 1
  fi
  grep -q 'no SimpleX path' "$tmpdir/send-no-simplex.err"
  ! find "$root/drafts" -type f -name '*.md' 2>/dev/null | grep -q .

  backend bind-contact "$root" bob "Bob Mail" person bob@example.org simplex://bob no >/dev/null
  send=$(backend send-message "$root" bob simplex "Secure path" "$(b64 'simplex first')")
  printf '%s\n' "$send" | jq -e '.ok == true and .transport == "simplex" and (.outbox_path | length > 0)' >/dev/null
  [ -f "$(printf '%s\n' "$send" | jq -r '.outbox_path')" ]
  snapshot=$(backend snapshot "$root")
  printf '%s\n' "$snapshot" | jq -e '
    [.threads[] | select(.id == "bob")][0].messages
    | map(select(.transport == "simplex" and .from_self == true and .in_inbox == false))
    | length == 1
  ' >/dev/null
}

simplex_inbox_state_is_metadata_not_thread_movement() {
  root="$tmpdir/inbox-state/mail"
  mkdir -p "$tmpdir/home"
  backend prepare "$root" >/dev/null
  backend bind-contact "$root" river "River Stone" group "" simplex://river yes >/dev/null
  backend import-simplex "$root" river "$(b64 'group update')" false true "" >/dev/null
  id=$(backend snapshot "$root" | jq -r '.inbox[0].id')
  backend mark-inbox "$root" "$id" out >/dev/null
  snapshot=$(backend snapshot "$root")
  printf '%s\n' "$snapshot" | jq -e '
    (.inbox | length) == 0 and
    ([.groups[] | select(.id == "river")][0].messages | length) == 1 and
    ([.groups[] | select(.id == "river")][0].messages[0].in_inbox == false)
  ' >/dev/null
}

bootstrap_status_is_structured() {
  root="$tmpdir/bootstrap/mail"
  mkdir -p "$tmpdir/home"
  backend prepare "$root" >/dev/null
  output=$(backend bootstrap-status "$root" default)
  printf '%s\n' "$output" | jq -e '.ok == true and (.install_state | type) == "string" and (.profile_prefix | contains("/.transport/simplex/default/profile"))' >/dev/null
}

bootstrap_status_detects_wizardry_simplex_install() {
  root="$tmpdir/bootstrap-wizardry/mail"
  global="$tmpdir/state/wizardry/simplex"
  mkdir -p "$tmpdir/home" "$global/current"
  write_fake_simplex_binary "$global/current/simplex-chat"
  cat >"$global/install.conf" <<EOF
version=vtest
asset_name=test-asset
binary_path=$global/current/simplex-chat
validation_state=ready
last_error=
EOF
  output=$(backend bootstrap-status "$root" default)
  printf '%s\n' "$output" | jq -e \
    --arg binary "$global/current/simplex-chat" \
    '.ok == true and .install_state == "installed" and .install_source == "wizardry" and .version == "vtest" and .binary_path == $binary' >/dev/null
}

snapshot_includes_owl_mailboxes_drafts_events_settings() {
  root="$tmpdir/snapshot-mail/mail"
  fake="$tmpdir/fake-owl-backend.sh"
  mkdir -p "$tmpdir/home"
  write_fake_owl_backend "$fake"
  backend_with_owl "$fake" prepare "$root" >/dev/null
  snapshot=$(backend_with_owl "$fake" snapshot "$root")
  printf '%s\n' "$snapshot" | jq -e '
    .ok == true and
    ([.mailboxes[] | select(.id == "accepted")][0].count == 1) and
    ([.mailboxes[] | select(.id == "archive")][0].count == 1) and
    (.drafts | length) == 1 and
    (.events | length) == 1 and
    .settings.domain == "example.org" and
    (.messages | map(select(.transport == "email")) | length) == 2
  ' >/dev/null
}

snapshot_lines_exposes_native_gtk_feed() {
  root="$tmpdir/snapshot-lines/mail"
  fake="$tmpdir/fake-owl-lines.sh"
  mkdir -p "$tmpdir/home"
  write_fake_owl_backend "$fake"
  backend_with_owl "$fake" prepare "$root" >/dev/null
  lines=$(backend_with_owl "$fake" snapshot-lines "$root")
  printf '%s\n' "$lines" | grep -q '^mailbox	accepted	Accepted	1	1$' &&
    printf '%s\n' "$lines" | grep -q '^inbox	.*	Alice	email	Hello	Email preview	2026-04-20T10:00:00Z$' &&
    printf '%s\n' "$lines" | grep -q '^draft	draft-1	alice@example.org	Draft note'
}

owl_actions_are_hard_allowlisted_and_passthrough() {
  root="$tmpdir/passthrough/mail"
  fake="$tmpdir/fake-owl-passthrough.sh"
  mkdir -p "$tmpdir/home"
  write_fake_owl_backend "$fake"
  output=$(backend_with_owl "$fake" settings-set-domain "$root" example.org)
  printf '%s\n' "$output" | jq -e '.ok == true and .domain == "example.org"' >/dev/null
  if backend_with_owl "$fake" arbitrary-shell "$root" >"$tmpdir/arbitrary.out" 2>"$tmpdir/arbitrary.err"; then
    return 1
  fi
  grep -q 'unsupported action' "$tmpdir/arbitrary.err"
}

ui_prefs_are_plaintext_xdg_state() {
  root="$tmpdir/prefs/mail"
  next_root="$tmpdir/prefs/other-mail"
  mkdir -p "$tmpdir/home"
  output=$(backend get-ui-prefs "$root")
  printf '%s\n' "$output" | jq -e --arg root "$root" '.ok == true and .mail_root == $root and .selected_route == "new"' >/dev/null
  backend set-ui-pref "$root" mail_root "$next_root" >/dev/null
  backend set-ui-pref "$root" selected_route "thread:alice" >/dev/null
  output=$(backend get-ui-prefs "$root")
  printf '%s\n' "$output" | jq -e --arg root "$next_root" '.mail_root == $root and .selected_route == "thread:alice"' >/dev/null
  grep -q "mail_root=$next_root" "$tmpdir/config/wizardry-apps/owl-native/prefs.conf"
}

message_detail_returns_simplex_and_email_messages() {
  root="$tmpdir/detail/mail"
  fake="$tmpdir/fake-owl-detail.sh"
  mkdir -p "$tmpdir/home"
  write_fake_owl_backend "$fake"
  backend_with_owl "$fake" prepare "$root" >/dev/null
  backend_with_owl "$fake" bind-contact "$root" alice "Alice Ledger" person alice@example.org simplex://alice yes >/dev/null
  backend_with_owl "$fake" import-simplex "$root" alice "$(b64 'Encrypted detail')" false true "SimpleX detail" >/dev/null
  simplex_id=$(backend_with_owl "$fake" snapshot "$root" | jq -r '.inbox[] | select(.transport == "simplex") | .id' | head -n 1)
  email_id=$(backend_with_owl "$fake" snapshot "$root" | jq -r '.inbox[] | select(.transport == "email") | .id' | head -n 1)
  backend_with_owl "$fake" message-detail "$root" "$simplex_id" | jq -e '.ok == true and .transport == "simplex" and .body == "Encrypted detail"' >/dev/null
  backend_with_owl "$fake" get-message "$root" "$email_id" | jq -e '.ok == true and .transport == "email" and .body == "Full fake body"' >/dev/null
}

simplex_tick_uses_transport_hook_for_poll_and_send() {
  root="$tmpdir/simplex-hook/mail"
  hook="$tmpdir/simplex-hook.sh"
  mkdir -p "$tmpdir/home"
  cat >"$hook" <<'SH'
#!/bin/sh
set -eu
mode=${1-}
identity=${2-}
root=${3-}
case "$mode" in
  poll)
    incoming=${4-}
    mkdir -p "$incoming"
    jq -n '{thread_id:"carol",body:"hook incoming",subject:"Hook",from_self:false,in_inbox:true}' >"$incoming/hook-message.json"
    ;;
  send)
    outbox_file=${4-}
    mkdir -p "$root/.hook-sent"
    cp "$outbox_file" "$root/.hook-sent/$identity.json"
    ;;
  *)
    exit 64
    ;;
esac
SH
  chmod +x "$hook"
  backend prepare "$root" >/dev/null
  backend bind-contact "$root" carol "Carol Cipher" person carol@example.org simplex://carol yes >/dev/null
  backend send-message "$root" carol simplex "Outbound" "$(b64 'hook outbound')" >/dev/null
  backend set-simplex-transport-hook "$root" default "$hook" | jq -e '.hook_ready == true' >/dev/null
  tick=$(backend tick-simplex "$root" default)
  printf '%s\n' "$tick" | jq -e '.ok == true and .imported == 1 and .outbox.sent == 1 and .outbox.failed == 0' >/dev/null
  [ -f "$root/.hook-sent/default.json" ] || return 1
  snapshot=$(backend snapshot "$root")
  printf '%s\n' "$snapshot" | jq -e '
    ([.threads[] | select(.id == "carol")][0].messages | map(select(.status == "sent")) | length) == 1 and
    ([.threads[] | select(.id == "carol")][0].messages | map(select(.body == "hook incoming" and .in_inbox == true)) | length) == 1
  ' >/dev/null
}

install_simplex_cli_delegates_to_wizardry_installer() {
  root="$tmpdir/install-wizardry/mail"
  fake_dir="$tmpdir/fake-wizardry"
  mkdir -p "$tmpdir/home" "$fake_dir"
  installer="$fake_dir/install-simplex-chat"
  cat >"$installer" <<'SH'
#!/bin/sh
set -eu
root="${WIZARDRY_SIMPLEX_ROOT:-${XDG_STATE_HOME:-$HOME/.local/state}/wizardry/simplex}"
mkdir -p "$root/current"
cat >"$root/current/simplex-chat" <<'BIN'
#!/bin/sh
[ "${1-}" = "-h" ] && exit 0
exit 0
BIN
chmod +x "$root/current/simplex-chat"
cat >"$root/install.conf" <<EOF
version=vtest
asset_name=test-asset
binary_path=$root/current/simplex-chat
validation_state=ready
last_error=
EOF
printf '%s\n' "installed fake SimpleX"
SH
  chmod +x "$installer"
  output=$(
    HOME="$tmpdir/home" \
    XDG_STATE_HOME="$tmpdir/state" \
    XDG_CONFIG_HOME="$tmpdir/config" \
    OWL_NATIVE_SIMPLEX_INSTALLER="$installer" \
    sh "$repo_dir/scripts/owl-native-backend.sh" install-simplex-cli "$root"
  )
  printf '%s\n' "$output" | jq -e \
    --arg binary "$tmpdir/state/wizardry/simplex/current/simplex-chat" \
    '.ok == true and .install_source == "wizardry" and .version == "vtest" and .binary_path == $binary' >/dev/null
}

invalid_action_fails() {
  root="$tmpdir/invalid/mail"
  mkdir -p "$tmpdir/home"
  if backend unknown "$root" >"$tmpdir/unknown.out" 2>"$tmpdir/unknown.err"; then
    return 1
  fi
  grep -q 'unsupported action' "$tmpdir/unknown.err"
}

run_case "doctor is read-only" doctor_is_read_only
run_case "prepare creates shared roots" prepare_creates_shared_roots
run_case "SimpleX messages share one timeline and inbox" simplex_messages_share_one_timeline_and_inbox
run_case "SimpleX send queues without email fallback" simplex_send_queues_without_email_fallback
run_case "SimpleX inbox state does not move timeline messages" simplex_inbox_state_is_metadata_not_thread_movement
run_case "bootstrap status is structured" bootstrap_status_is_structured
run_case "bootstrap status detects Wizardry SimpleX install" bootstrap_status_detects_wizardry_simplex_install
run_case "snapshot includes Owl mailboxes, drafts, events, and settings" snapshot_includes_owl_mailboxes_drafts_events_settings
run_case "snapshot lines exposes native GTK feed" snapshot_lines_exposes_native_gtk_feed
run_case "Owl actions are hard allowlisted and pass through" owl_actions_are_hard_allowlisted_and_passthrough
run_case "UI prefs are plaintext XDG state" ui_prefs_are_plaintext_xdg_state
run_case "message detail returns SimpleX and email messages" message_detail_returns_simplex_and_email_messages
run_case "SimpleX tick uses transport hook for poll and send" simplex_tick_uses_transport_hook_for_poll_and_send
run_case "install SimpleX CLI delegates to Wizardry installable" install_simplex_cli_delegates_to_wizardry_installer
run_case "invalid action fails" invalid_action_fails

if [ "$failures" -ne 0 ]; then
  printf '%s\n' "$failures test(s) failed" >&2
  exit 1
fi

printf '%s\n' "15/15 backend contract tests passed"
