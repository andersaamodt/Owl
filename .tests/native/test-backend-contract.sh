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

b64() {
  printf '%s' "$1" | base64 | tr -d '\n'
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
run_case "invalid action fails" invalid_action_fails

if [ "$failures" -ne 0 ]; then
  printf '%s\n' "$failures test(s) failed" >&2
  exit 1
fi

printf '%s\n' "7/7 backend contract tests passed"
