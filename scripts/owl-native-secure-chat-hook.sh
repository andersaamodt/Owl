#!/bin/sh

set -eu

usage() {
  cat <<'USAGE'
Usage:
  owl-native-secure-chat-hook.sh send IDENTITY ROOT OUTBOX_FILE
  owl-native-secure-chat-hook.sh poll IDENTITY ROOT INCOMING_DIR

SSH-backed transport hook that syncs Owl Native with a nostr-blog Secure Chat
daemon. Configuration lives in ROOT/.transport/simplex/IDENTITY/profile.conf:

  secure_chat_ssh_host=andersaamodt.com
  secure_chat_export_command=/home/new_andersaamodt_com/site/cgi/blog-secure-chat-owl-export
  secure_chat_send_command=/home/new_andersaamodt_com/site/cgi/blog-secure-chat-owl-send
USAGE
}

case "${1-}" in
--help|-h|help)
  usage
  exit 0
  ;;
esac

action=${1-}
identity=${2-}
root=${3-}
arg4=${4-}

[ -n "$action" ] || { usage >&2; exit 2; }
[ -n "$identity" ] || { printf '%s\n' 'owl-native-secure-chat-hook: IDENTITY is required' >&2; exit 2; }
[ -n "$root" ] || { printf '%s\n' 'owl-native-secure-chat-hook: ROOT is required' >&2; exit 2; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf '%s\n' "owl-native-secure-chat-hook: required tool not found: $1" >&2
    exit 1
  }
}

safe_slug() {
  raw=${1-}
  cleaned=$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._@-' '-')
  cleaned=$(printf '%s' "$cleaned" | sed 's/^-*//; s/-*$//; s/--*/-/g')
  [ -n "$cleaned" ] || cleaned=unknown
  printf '%s\n' "$cleaned"
}

config_get() {
  file=$1
  key=$2
  [ -f "$file" ] || return 1
  awk -F= -v wanted="$key" '
    $1 == wanted {
      print substr($0, index($0, "=") + 1)
      found = 1
    }
    END { exit found ? 0 : 1 }
  ' "$file"
}

base64_one_line() {
  if base64 --help 2>/dev/null | grep -q -- '-w'; then
    base64 -w 0
    return
  fi
  base64 | tr -d '\n'
}

validate_remote_path() {
  path_value=${1-}
  case "$path_value" in
    /*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_./@+-]*|''|*..*|*' '*)
      printf '%s\n' "owl-native-secure-chat-hook: unsafe remote command path: $path_value" >&2
      exit 2
      ;;
    /*)
      printf '%s\n' "$path_value"
      ;;
    *)
      printf '%s\n' "owl-native-secure-chat-hook: remote command must be absolute: $path_value" >&2
      exit 2
      ;;
  esac
}

identity=$(safe_slug "$identity")
profile_conf="$root/.transport/simplex/$identity/profile.conf"
cursor_file="$root/.transport/simplex/$identity/secure-chat.cursor"

ssh_host=$(config_get "$profile_conf" secure_chat_ssh_host 2>/dev/null || printf '')
export_command=$(config_get "$profile_conf" secure_chat_export_command 2>/dev/null || printf '')
send_command=$(config_get "$profile_conf" secure_chat_send_command 2>/dev/null || printf '')

[ -n "$ssh_host" ] || { printf '%s\n' 'owl-native-secure-chat-hook: secure_chat_ssh_host is not configured' >&2; exit 2; }
export_command=$(validate_remote_path "$export_command")
send_command=$(validate_remote_path "$send_command")

require_cmd jq
require_cmd ssh

poll_messages() {
  incoming_dir=$1
  mkdir -p "$incoming_dir" "$(dirname "$cursor_file")"
  since=$(cat "$cursor_file" 2>/dev/null || printf '0')
  case "$since" in ''|*[!0123456789]*) since=0 ;; esac

  response=$(ssh "$ssh_host" "$export_command" "$since")
  printf '%s\n' "$response" | jq -e '.success == true' >/dev/null

  imported=0
  tmp_rows=$(mktemp "${TMPDIR:-/tmp}/owl-native-secure-chat-rows.XXXXXX")
  printf '%s\n' "$response" | jq -c '
    .messages[]?
    | select((.body // "") != "")
    | select(((.source // "") != "simplex-owner-direct") or ((.from_self // false) != true))
    | {
        thread_id:(.thread_id // .npub // "unknown"),
        contact_key:(.thread_id // .npub // "unknown"),
        body:(.body // ""),
        subject:(.subject // "Website Secure Chat"),
        from_self:((.from_self // false) == true),
        in_inbox:((.in_inbox // true) == true),
        simplex_address:(.simplex_address // ""),
        remote_id:(.id // ""),
        received_at:(.created_at // .updated_at // "")
      }
  ' >"$tmp_rows"
  while IFS= read -r row || [ -n "$row" ]; do
    [ -n "$row" ] || continue
    remote_id=$(printf '%s\n' "$row" | jq -r '.remote_id // ""' | tr -cs 'a-zA-Z0-9._@-' '-')
    [ -n "$remote_id" ] || remote_id="secure-chat-$imported"
    target="$incoming_dir/$remote_id.json"
    if [ ! -e "$target" ]; then
      printf '%s\n' "$row" >"$target"
      imported=$((imported + 1))
    fi
  done <"$tmp_rows"
  rm -f "$tmp_rows"

  cursor=$(printf '%s\n' "$response" | jq -r '.cursor_seq // 0')
  case "$cursor" in ''|*[!0123456789]*) cursor=$since ;; esac
  printf '%s\n' "$cursor" >"$cursor_file"
  printf '%s\n' 'transport=nostr-blog-secure-chat'
  printf '%s\n' "imported=$imported"
  printf '%s\n' "cursor_seq=$cursor"
}

send_message() {
  outbox_file=$1
  [ -f "$outbox_file" ] || {
    printf '%s\n' "owl-native-secure-chat-hook: outbox file not found: $outbox_file" >&2
    exit 1
  }
  target=$(jq -r '.thread_id // .contact_key // .simplex_address // ""' "$outbox_file" | head -n 1)
  case "$target" in
    npub1*|secure-chat:[0-9]*|secure-chat-contact-[0-9]*) ;;
    *) printf '%s\n' "owl-native-secure-chat-hook: outbox thread is not a Secure Chat target: $target" >&2; exit 2 ;;
  esac
  body_b64=$(jq -rj '.body // ""' "$outbox_file" | base64_one_line)
  response=$(ssh "$ssh_host" "$send_command" "$target" "$body_b64")
  printf '%s\n' "$response" | jq -e '.success == true' >/dev/null
  printf '%s\n' 'transport=nostr-blog-secure-chat'
  printf '%s\n' "remote_id=$target"
  printf '%s\n' 'message=sent through nostr-blog Secure Chat'
}

case "$action" in
poll)
  [ -n "$arg4" ] || { printf '%s\n' 'owl-native-secure-chat-hook: INCOMING_DIR is required for poll' >&2; exit 2; }
  poll_messages "$arg4"
  ;;
send)
  [ -n "$arg4" ] || { printf '%s\n' 'owl-native-secure-chat-hook: OUTBOX_FILE is required for send' >&2; exit 2; }
  send_message "$arg4"
  ;;
*)
  printf '%s\n' "owl-native-secure-chat-hook: unsupported action: $action" >&2
  exit 2
  ;;
esac
