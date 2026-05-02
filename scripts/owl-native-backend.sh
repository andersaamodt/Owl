#!/bin/sh

case "${1-}" in
--help|--usage|-h|help)
  cat <<'USAGE'
Usage: owl-native-backend.sh ACTION [ROOT] [ARGS...]

Actions:
  doctor [ROOT]
  prepare ROOT
  get-paths ROOT
  get-ui-prefs ROOT
  set-ui-pref ROOT KEY VALUE
  snapshot ROOT
  snapshot-lines ROOT
  overview ROOT
  settings-controls ROOT
  settings-browse-root ROOT [START_PATH]
  settings-set-test-recipient ROOT ADDRESS
  settings-verify-domain ROOT DOMAIN
  settings-set-domain ROOT DOMAIN
  settings-ssl-prereq-status ROOT
  settings-ssl-wizard-status ROOT
  settings-setup-ssl ROOT [MODE] [HOST] [SSH_KEY_PATH] [SSH_KEY_PASSWORD] [SSH_PORT]
  settings-set-daemon-installed ROOT on|off
  settings-set-daemon-running ROOT on|off
  settings-set-daemon-startup ROOT on|off
  settings-setup-folders ROOT
  settings-remote-set-target ROOT HOST SSH_KEY_PATH [SSH_PORT]
  settings-remote-set-auth ROOT SSH_KEY_HAS_PASSWORD SSH_KEY_SAVE_CHOICE SSH_KEY_PASSWORD [HOST] [SSH_KEY_PATH] [SSH_PORT]
  settings-remote-deploy ROOT [HOST] [SSH_KEY_PATH] [SSH_KEY_PASSWORD] [SSH_PORT]
  settings-remote-verify ROOT [HOST] [SSH_KEY_PATH] [SSH_KEY_PASSWORD] [SSH_PORT]
  settings-remote-send-test ROOT [HOST] [SSH_KEY_PATH] [SSH_KEY_PASSWORD] [SSH_PORT]
  settings-remote-sync ROOT [HOST] [SSH_KEY_PATH] [SSH_KEY_PASSWORD] [SSH_PORT]
  settings-llm-controls ROOT
  settings-llm-set ROOT ENABLED AUTO_INSTALL MODEL
  settings-llm-install-ollama ROOT
  settings-llm-set-daemon ROOT on|off
  settings-llm-install-model ROOT MODEL
  settings-llm-uninstall-model ROOT MODEL
  spam-classify ROOT [LIST] [SENDER] [LIMIT] [ALLOW_INSTALL]
  event-feed ROOT [LIMIT]
  bind-contact ROOT THREAD_ID NAME KIND EMAIL SIMPLEX_ADDRESS FAVORITE
  contact-get ROOT IDENTITY [FALLBACK_LABEL] [CONTACT_KEY]
  contact-save ROOT IDENTITY CONTACT_KEY NAME EMAIL PHONE ADDRESS URL NOTE
  import-simplex ROOT THREAD_ID BODY_B64 [FROM_SELF] [IN_INBOX] [SUBJECT]
  mark-inbox ROOT MESSAGE_ID in|out
  mark-read ROOT MESSAGE_ID true|false
  send-message ROOT THREAD_ID simplex|email SUBJECT BODY_B64
  message-detail ROOT MESSAGE_ID
  archive-message ROOT MESSAGE_ID
  delete-message ROOT MESSAGE_ID
  toggle-star ROOT MESSAGE_ID true|false
  list-senders ROOT LIST
  list-archive-bundle ROOT
  list-inbox-bundle-fast ROOT
  list-messages-fast ROOT LIST [SENDER]
  list-messages ROOT LIST [SENDER]
  get-message ROOT MESSAGE_ID
  get-message ROOT LIST SENDER ULID
  set-flag ROOT LIST SENDER ULID FIELD VALUE
  move-message ROOT FROM TO SENDER ULID
  move-sender ROOT FROM TO SENDER
  draft-list ROOT
  draft-get ROOT ULID
  draft-save ROOT ULID FROM TO_CSV CC_CSV BCC_CSV SUBJECT REPLY_TO BODY_B64
  draft-delete ROOT ULID
  draft-send ROOT ULID
  bootstrap-status ROOT [IDENTITY]
  install-simplex-cli ROOT
  provision-simplex-identity ROOT [IDENTITY] [DISPLAY_NAME] [FULL_NAME]
  set-simplex-transport-hook ROOT IDENTITY HOOK_PATH
  simplex-transport-status ROOT [IDENTITY]
  tick-simplex ROOT

Owl Native shares Owl's mail root. ROOT defaults to ~/mail.
USAGE
  exit 0
  ;;
esac

set -eu

action=${1-}
root_arg=${2-}
shift 2 >/dev/null 2>&1 || true

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
home=${HOME:?}
nl='
'
cr=$(printf '\r')

fail() {
  printf '%s\n' "owl-native-backend: $*" >&2
  exit 1
}

usage_error() {
  printf '%s\n' "owl-native-backend: $*" >&2
  exit 2
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "required tool not found: $1"
}

safe_output_value() {
  case "${1-}" in
    *"$nl"*|*"$cr"*)
      fail "unsafe output value"
      ;;
  esac
}

normalize_path() {
  input=${1-}
  if [ -z "$input" ]; then
    printf '%s\n' "$home/mail"
    return 0
  fi
  case "$input" in
    "~")
      printf '%s\n' "$home"
      ;;
    "~/"*)
      printf '%s\n' "$home/${input#\~/}"
      ;;
    /*)
      printf '%s\n' "$input"
      ;;
    *)
      printf '%s\n' "$(pwd -P)/$input"
      ;;
  esac
}

ROOT=$(normalize_path "$root_arg")
safe_output_value "$ROOT"

metadata_root() {
  printf '%s\n' "$ROOT/.owl-native"
}

ui_config_dir() {
  printf '%s\n' "${XDG_CONFIG_HOME:-$HOME/.config}/wizardry-apps/owl-native"
}

ui_prefs_file() {
  printf '%s\n' "$(ui_config_dir)/prefs.conf"
}

native_contacts_dir() {
  printf '%s\n' "$(metadata_root)/contacts"
}

simplex_state_root() {
  printf '%s\n' "$(metadata_root)/simplex"
}

simplex_threads_dir() {
  printf '%s\n' "$(simplex_state_root)/threads"
}

simplex_incoming_dir() {
  printf '%s\n' "$(simplex_state_root)/incoming"
}

simplex_outbox_dir() {
  printf '%s\n' "$(simplex_state_root)/outbox"
}

simplex_processed_dir() {
  printf '%s\n' "$(simplex_state_root)/processed"
}

simplex_system_root() {
  printf '%s\n' "$ROOT/.system/simplex"
}

simplex_install_file() {
  printf '%s\n' "$(simplex_system_root)/install.conf"
}

simplex_releases_dir() {
  printf '%s\n' "$(simplex_system_root)/releases"
}

simplex_current_dir() {
  printf '%s\n' "$(simplex_system_root)/current"
}

simplex_current_binary() {
  printf '%s\n' "$(simplex_current_dir)/simplex-chat"
}

wizardry_simplex_root() {
  if [ -n "${OWL_NATIVE_WIZARDRY_SIMPLEX_ROOT-}" ]; then
    printf '%s\n' "$OWL_NATIVE_WIZARDRY_SIMPLEX_ROOT"
    return 0
  fi
  if [ -n "${WIZARDRY_SIMPLEX_ROOT-}" ]; then
    printf '%s\n' "$WIZARDRY_SIMPLEX_ROOT"
    return 0
  fi
  printf '%s\n' "${XDG_STATE_HOME:-$HOME/.local/state}/wizardry/simplex"
}

wizardry_simplex_install_file() {
  printf '%s\n' "$(wizardry_simplex_root)/install.conf"
}

wizardry_simplex_current_binary() {
  printf '%s\n' "$(wizardry_simplex_root)/current/simplex-chat"
}

simplex_user_bin_path() {
  printf '%s\n' "${XDG_BIN_HOME:-$HOME/.local/bin}/simplex-chat"
}

simplex_transport_root() {
  printf '%s\n' "$ROOT/.transport/simplex"
}

simplex_identity_dir() {
  ident=$(safe_slug "${1:-default}")
  printf '%s\n' "$(simplex_transport_root)/$ident"
}

simplex_profile_prefix() {
  printf '%s\n' "$(simplex_identity_dir "${1:-default}")/profile"
}

simplex_profile_conf() {
  printf '%s\n' "$(simplex_identity_dir "${1:-default}")/profile.conf"
}

ensure_roots() {
  mkdir -p "$ROOT" "$(metadata_root)" "$(native_contacts_dir)"
  mkdir -p "$(simplex_threads_dir)" "$(simplex_incoming_dir)" "$(simplex_outbox_dir)" "$(simplex_processed_dir)"
  mkdir -p "$ROOT/quarantine" "$ROOT/accepted" "$ROOT/spam" "$ROOT/banned"
  mkdir -p "$ROOT/archive" "$ROOT/trash" "$ROOT/drafts" "$ROOT/outbox" "$ROOT/sent" "$ROOT/logs"
}

safe_slug() {
  raw=${1-}
  cleaned=$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._@-' '-')
  cleaned=$(printf '%s' "$cleaned" | sed 's/^-*//; s/-*$//; s/--*/-/g')
  if [ -z "$cleaned" ]; then
    cleaned=unknown
  fi
  printf '%s\n' "$cleaned"
}

now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

message_id() {
  rand=$(od -An -tx1 -N8 /dev/urandom 2>/dev/null | tr -d ' \n')
  [ -n "$rand" ] || rand=$$
  printf 'm-%s-%s\n' "$(date -u +%Y%m%dT%H%M%SZ)" "$rand"
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

config_set() {
  file=$1
  key=$2
  value=${3-}
  case "$key" in
    ''|*[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.-]*)
      usage_error "invalid config key: $key"
      ;;
  esac
  case "$value" in
    *"$nl"*|*"$cr"*)
      usage_error "config value for $key must be a single line"
      ;;
  esac
  mkdir -p "$(dirname "$file")"
  tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-conf.XXXXXX")
  if [ -f "$file" ]; then
    awk -F= -v wanted="$key" '$1 != wanted' "$file" >"$tmp"
  fi
  printf '%s=%s\n' "$key" "$value" >>"$tmp"
  mv "$tmp" "$file"
}

ui_pref_value() {
  key=$1
  case "$key" in
    mail_root)
      config_get "$(ui_prefs_file)" mail_root 2>/dev/null || printf '%s\n' "$ROOT"
      ;;
    selected_route)
      config_get "$(ui_prefs_file)" selected_route 2>/dev/null || printf '%s\n' new
      ;;
    *)
      return 1
      ;;
  esac
}

ui_prefs_action() {
  jq -n \
    --arg mail_root "$(ui_pref_value mail_root)" \
    --arg selected_route "$(ui_pref_value selected_route)" \
    '{ok:true,mail_root:$mail_root,selected_route:$selected_route}'
}

set_ui_pref_action() {
  key=${1-}
  value=${2-}
  case "$key" in
    mail_root|selected_route) ;;
    *) usage_error "unsupported UI preference: $key" ;;
  esac
  case "$value" in
    *"$nl"*|*"$cr"*) usage_error "UI preference values must be single-line" ;;
  esac
  config_set "$(ui_prefs_file)" "$key" "$value"
  ui_prefs_action
}

decode_b64_to_file() {
  payload=${1-}
  output=$2
  if printf '%s' "$payload" | base64 --decode >"$output" 2>/dev/null; then
    return 0
  fi
  if printf '%s' "$payload" | base64 -D >"$output" 2>/dev/null; then
    return 0
  fi
  return 1
}

resolve_owl_backend_script() {
  if [ -n "${OWL_DESKTOP_BACKEND-}" ] && [ -f "$OWL_DESKTOP_BACKEND" ]; then
    printf '%s\n' "$OWL_DESKTOP_BACKEND"
    return 0
  fi
  if [ -n "${OWL_SOURCE_ROOT-}" ] && [ -f "$OWL_SOURCE_ROOT/scripts/owl-desktop-backend.sh" ]; then
    printf '%s\n' "$OWL_SOURCE_ROOT/scripts/owl-desktop-backend.sh"
    return 0
  fi
  for candidate in \
    "$repo_dir/vendor/owl/scripts/owl-desktop-backend.sh" \
    "$repo_dir/../owl/scripts/owl-desktop-backend.sh" \
    "$home/git/owl/scripts/owl-desktop-backend.sh"
  do
    if [ -f "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

owl_backend_json() {
  owl_action=$1
  shift || true
  script=$(resolve_owl_backend_script || true)
  [ -n "$script" ] || return 127
  sh "$script" "$owl_action" "$ROOT" "$@"
}

owl_backend_json_or_empty() {
  owl_backend_json "$@" 2>/dev/null || jq -n '{ok:false,unavailable:true}'
}

owl_backend_array_field_or_empty() {
  field=$1
  shift
  owl_backend_json "$@" 2>/dev/null | jq -c --arg field "$field" '.[$field] // []' 2>/dev/null || printf '[]\n'
}

empty_owl_messages() {
  jq -n --arg list "${1:-}" '{ok:true,list:$list,messages:[]}'
}

empty_owl_overview() {
  jq -n --arg root "$ROOT" '{ok:true,root:$root,counts:{new_senders:0,new_messages:0,inbox_messages:0,spam_senders:0,spam_messages:0,archive_messages:0,trash_messages:0,drafts:0,outbox:0,sent:0}}'
}

owl_messages_for_list() {
  list=$1
  if out=$(owl_backend_json list-messages "$list" 2>/dev/null); then
    printf '%s\n' "$out"
  else
    empty_owl_messages "$list"
  fi
}

owl_overview() {
  if out=$(owl_backend_json overview 2>/dev/null); then
    printf '%s\n' "$out"
  else
    empty_owl_overview
  fi
}

native_contact_file() {
  thread_id=$(safe_slug "$1")
  printf '%s/%s.conf\n' "$(native_contacts_dir)" "$thread_id"
}

contact_conf_to_json() {
  file=$1
  [ -f "$file" ] || return 0
  id=$(config_get "$file" id 2>/dev/null || basename "$file" .conf)
  name=$(config_get "$file" name 2>/dev/null || printf '')
  kind=$(config_get "$file" kind 2>/dev/null || printf person)
  email=$(config_get "$file" email 2>/dev/null || printf '')
  simplex=$(config_get "$file" simplex_address 2>/dev/null || printf '')
  favorite=$(config_get "$file" favorite 2>/dev/null || printf no)
  group=$(config_get "$file" group 2>/dev/null || printf '')
  jq -cn \
    --arg id "$id" \
    --arg name "$name" \
    --arg kind "$kind" \
    --arg email "$email" \
    --arg simplex_address "$simplex" \
    --arg favorite "$favorite" \
    --arg group "$group" \
    '{id:$id,name:$name,kind:(if $kind == "group" then "group" else "person" end),email:$email,simplex_address:$simplex_address,favorite:($favorite=="yes" or $favorite=="true" or $favorite=="1"),group:$group}'
}

contacts_json_array() {
  tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-contacts.XXXXXX")
  dir=$(native_contacts_dir)
  if [ -d "$dir" ]; then
    for file in "$dir"/*.conf; do
      [ -f "$file" ] || continue
      contact_conf_to_json "$file" >>"$tmp"
    done
  fi
  jq -s '.' "$tmp"
  rm -f "$tmp"
}

save_contact_binding() {
  thread_id=$(safe_slug "${1-}")
  name=${2-}
  kind=${3-person}
  email=${4-}
  simplex=${5-}
  favorite=${6-no}
  case "$thread_id$name$kind$email$simplex$favorite" in
    *"$nl"*|*"$cr"*) usage_error "contact fields must be single-line values" ;;
  esac
  case "$kind" in
    group) ;;
    *) kind=person ;;
  esac
  case "$favorite" in
    yes|true|1|on) favorite=yes ;;
    *) favorite=no ;;
  esac
  [ -n "$thread_id" ] || usage_error "bind-contact requires THREAD_ID"
  file=$(native_contact_file "$thread_id")
  config_set "$file" id "$thread_id"
  config_set "$file" name "$name"
  config_set "$file" kind "$kind"
  config_set "$file" email "$email"
  config_set "$file" simplex_address "$simplex"
  config_set "$file" favorite "$favorite"
  contact_conf_to_json "$file"
}

simplex_thread_file() {
  thread_id=$(safe_slug "$1")
  printf '%s/%s.jsonl\n' "$(simplex_threads_dir)" "$thread_id"
}

append_simplex_message() {
  thread_id=$(safe_slug "$1")
  body=${2-}
  from_self=${3-false}
  in_inbox=${4-false}
  subject=${5-}
  at=${6-}
  [ -n "$at" ] || at=$(now_iso)
  case "$from_self" in true|1|yes|on) from_self=true ;; *) from_self=false ;; esac
  case "$in_inbox" in true|1|yes|on|in) in_inbox=true ;; *) in_inbox=false ;; esac
  id="simplex:$(message_id)"
  file=$(simplex_thread_file "$thread_id")
  mkdir -p "$(dirname "$file")"
  jq -cn \
    --arg id "$id" \
    --arg thread_id "$thread_id" \
    --arg subject "$subject" \
    --arg body "$body" \
    --arg received_at "$at" \
    --argjson from_self "$from_self" \
    --argjson in_inbox "$in_inbox" \
    '{schema:1,id:$id,thread_id:$thread_id,transport:"simplex",subject:$subject,body:$body,received_at:$received_at,from_self:$from_self,in_inbox:$in_inbox,read:false,status:"queued"}' >>"$file"
  jq -cn --arg id "$id" --arg thread_id "$thread_id" '{ok:true,id:$id,thread_id:$thread_id}'
}

collect_simplex_messages_jsonl() {
  dir=$(simplex_threads_dir)
  [ -d "$dir" ] || return 0
  for file in "$dir"/*.jsonl; do
    [ -f "$file" ] || continue
    jq -c 'select(type == "object")' "$file" 2>/dev/null || true
  done
}

rewrite_simplex_message_field() {
  message_id_value=$1
  field=$2
  value=$3
  dir=$(simplex_threads_dir)
  [ -d "$dir" ] || return 1
  found=0
  for file in "$dir"/*.jsonl; do
    [ -f "$file" ] || continue
    if jq -e --arg id "$message_id_value" 'select(.id == $id)' "$file" >/dev/null 2>&1; then
      tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-simplex.XXXXXX")
      case "$field" in
        in_inbox|read)
          jq -c --arg id "$message_id_value" --arg field "$field" --argjson value "$value" \
            'if .id == $id then .[$field] = $value else . end' "$file" >"$tmp"
          ;;
        status)
          jq -c --arg id "$message_id_value" --arg value "$value" \
            'if .id == $id then .status = $value else . end' "$file" >"$tmp"
          ;;
        *)
          rm -f "$tmp"
          usage_error "unsupported SimpleX field: $field"
          ;;
      esac
      mv "$tmp" "$file"
      found=1
    fi
  done
  [ "$found" -eq 1 ]
}

collect_email_messages_jsonl() {
  for list in accepted quarantine spam banned archive sent trash outbox spam-review; do
    owl_messages_for_list "$list" | jq -c --arg list "$list" '.messages[]? | . + {native_source_list:$list}'
  done
}

mailbox_summary_json() {
  tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-mailboxes.XXXXXX")
  for list in accepted quarantine spam banned archive sent outbox trash spam-review; do
    messages=$(owl_messages_for_list "$list")
    printf '%s\n' "$messages" | jq -c --arg id "$list" '
      def title:
        {
          accepted:"Accepted",
          quarantine:"Quarantine",
          spam:"Spam",
          banned:"Banned",
          archive:"Archive",
          sent:"Sent",
          outbox:"Outbox",
          trash:"Trash",
          "spam-review":"Spam Review"
        }[$id] // $id;
      {
        id:$id,
        title:title,
        count:(.messages | length),
        unread:(.messages | map(select((.read // false) | not)) | length)
      }' >>"$tmp"
  done
  jq -s '.' "$tmp"
  rm -f "$tmp"
}

snapshot_action() {
  ensure_roots
  contacts_json=$(contacts_json_array)
  overview_json=$(owl_overview)
  mailboxes_json=$(mailbox_summary_json)
  drafts_json=$(owl_backend_array_field_or_empty drafts draft-list)
  events_json=$(owl_backend_array_field_or_empty events event-feed 80)
  settings_json=$(owl_backend_json_or_empty settings-controls)
  prefs_json=$(ui_prefs_action)
  tmp_email=$(mktemp "${TMPDIR:-/tmp}/owl-native-email.XXXXXX")
  tmp_simplex=$(mktemp "${TMPDIR:-/tmp}/owl-native-simplex.XXXXXX")
  collect_email_messages_jsonl >"$tmp_email"
  collect_simplex_messages_jsonl >"$tmp_simplex"
  jq -n \
    --arg root "$ROOT" \
    --argjson contacts "$contacts_json" \
    --argjson overview "$overview_json" \
    --argjson mailboxes "$mailboxes_json" \
    --argjson drafts "$drafts_json" \
    --argjson events "$events_json" \
    --argjson settings "$settings_json" \
    --argjson prefs "$prefs_json" \
    --arg simplex_install_state "$(simplex_install_state)" \
    --slurpfile email_raw "$tmp_email" \
    --slurpfile simplex_raw "$tmp_simplex" '
    def clean_email:
      tostring as $raw
      | (try ($raw | capture("(?<addr>[A-Za-z0-9._%+\\-]+@[A-Za-z0-9.\\-]+)").addr) catch $raw)
      | ascii_downcase;
    def compact($s): ($s // "" | tostring | gsub("[\\r\\n\\t]+"; " ") | gsub("  +"; " ") | .[0:220]);
    def slug:
      tostring | ascii_downcase | gsub("[^a-z0-9._@-]+"; "-") | gsub("^-+"; "") | gsub("-+$"; "") | if length == 0 then "unknown" else . end;
    def name_from_email($email):
      ($email | split("@")[0] | gsub("[._-]+"; " ") | split(" ") | map(if length > 0 then (.[0:1]|ascii_upcase) + .[1:] else . end) | join(" "));
    def contact_for_email($email):
      first($contacts[]? | select((.email | ascii_downcase) == ($email | ascii_downcase))) // null;
    def contact_for_thread($thread):
      first($contacts[]? | select(.id == $thread)) // null;
    def contact_for_simplex($addr):
      first($contacts[]? | select((.simplex_address | ascii_downcase) == ($addr | ascii_downcase))) // null;
    def email_msg:
      . as $m
      | (($m.list // $m.native_source_list // "") | tostring) as $list
      | (if $list == "sent" then (($m.to // $m.sender // $m.from // "") | clean_email) else (($m.sender // $m.from // $m.to // "") | clean_email) end) as $email
      | (contact_for_email($email)) as $contact
      | (($contact.id // ("person-" + ($email | slug)))) as $thread_id
      | {
          id: ("email:" + $list + ":" + (($m.sender // "") | tostring | slug) + ":" + (($m.ulid // "") | tostring)),
          backend_kind: "email",
          transport: "email",
          lock: "open",
          thread_id: $thread_id,
          contact_name: ($contact.name // name_from_email($email)),
          contact_kind: ($contact.kind // "person"),
          email: ($contact.email // $email),
          simplex_address: ($contact.simplex_address // ""),
          favorite: ($contact.favorite // false),
          group: ($contact.group // ""),
          list: $list,
          sender: (($m.sender // "") | tostring),
          ulid: (($m.ulid // "") | tostring),
          subject: (($m.subject // "") | tostring),
          body: compact($m.preview),
          preview: compact($m.preview),
          received_at: (($m.received_at // "") | tostring),
          from_self: ($list == "sent"),
          in_inbox: ($list == "accepted" or $list == "quarantine"),
          read: (($m.read // false) == true),
          starred: (($m.starred // false) == true),
          attachments: (($m.attachments // 0) | tonumber? // 0),
          status: $list
        };
    def simplex_msg:
      . as $m
      | (($m.thread_id // "") | tostring | slug) as $seed_thread
      | (contact_for_thread($seed_thread)) as $thread_contact
      | (contact_for_simplex(($m.simplex_address // "") | tostring)) as $simplex_contact
      | (($thread_contact // $simplex_contact // {})) as $contact
      | (($contact.id // $seed_thread)) as $thread_id
      | {
          id: (($m.id // ("simplex:" + $thread_id + ":" + ($m.received_at // ""))) | tostring),
          backend_kind: "simplex",
          transport: "simplex",
          lock: "closed",
          thread_id: $thread_id,
          contact_name: ($contact.name // ($m.contact_name // $thread_id)),
          contact_kind: ($contact.kind // ($m.kind // "person")),
          email: ($contact.email // ""),
          simplex_address: ($contact.simplex_address // ($m.simplex_address // "")),
          favorite: ($contact.favorite // false),
          group: ($contact.group // ""),
          list: "simplex",
          sender: (($m.sender // "") | tostring),
          ulid: "",
          subject: (($m.subject // "") | tostring),
          body: (($m.body // "") | tostring),
          preview: compact($m.body),
          received_at: (($m.received_at // "") | tostring),
          from_self: (($m.from_self // false) == true),
          in_inbox: (($m.in_inbox // false) == true),
          read: (($m.read // false) == true),
          starred: false,
          attachments: 0,
          status: (($m.status // "queued") | tostring)
        };
    def thread_from_contact:
      {
        id: .id,
        kind: .kind,
        name: (if (.name // "") != "" then .name else (.email // .simplex_address // .id) end),
        email: (.email // ""),
        simplex_address: (.simplex_address // ""),
        favorite: (.favorite // false),
        group: (.group // ""),
        unread_count: 0,
        latest_at: "",
        messages: []
      };
    (($email_raw | map(email_msg)) + ($simplex_raw | map(select((.status // "") != "deleted") | simplex_msg))) as $messages
    | ($contacts | map(thread_from_contact)) as $contact_threads
    | ($messages | group_by(.thread_id) | map({
        id: .[0].thread_id,
        kind: (.[0].contact_kind // "person"),
        name: (.[0].contact_name // .[0].thread_id),
        email: (.[0].email // ""),
        simplex_address: (.[0].simplex_address // ""),
        favorite: (.[0].favorite // false),
        group: (.[0].group // ""),
        unread_count: (map(select(.in_inbox and (.read | not))) | length),
        latest_at: (map(.received_at) | max // ""),
        messages: (sort_by(.received_at))
      })) as $message_threads
    | (($contact_threads + $message_threads)
       | group_by(.id)
       | map(reduce .[] as $item ({}; . * $item | .messages = ((.messages // []) + ($item.messages // []))))
       | map(.messages = (.messages | unique_by(.id) | sort_by(.received_at)))
       | map(.latest_at = ((.messages | map(.received_at) | max) // .latest_at // ""))
       | map(.unread_count = ((.messages | map(select(.in_inbox and (.read | not))) | length) // 0))
      ) as $threads
    | {
        ok: true,
        root: $root,
        prefs: $prefs,
        overview: $overview,
        settings: $settings,
        mailboxes: $mailboxes,
        drafts: $drafts,
        events: $events,
        simplex: {
          install_state: $simplex_install_state,
          system_root: ($root + "/.system/simplex"),
          incoming_dir: ($root + "/.owl-native/simplex/incoming"),
          outbox_dir: ($root + "/.owl-native/simplex/outbox")
        },
        inbox: ($messages | map(select(.in_inbox)) | sort_by(.received_at) | reverse),
        favorites: ($threads | map(select(.favorite)) | sort_by(.name)),
        individuals: ($threads | map(select(.kind != "group")) | sort_by(.name)),
        groups: ($threads | map(select(.kind == "group")) | sort_by(.name)),
        threads: ($threads | sort_by(.latest_at) | reverse),
        messages: ($messages | sort_by(.received_at))
      }'
  rm -f "$tmp_email" "$tmp_simplex"
}

snapshot_lines_action() {
  snapshot_action | jq -r '
    def clean: tostring | gsub("[\r\n\t]+"; " ") | gsub("  +"; " ");
    . as $snapshot
    | (["root", ($snapshot.root | clean)] | @tsv),
      ($snapshot.mailboxes[]? | ["mailbox", (.id | clean), (.title | clean), ((.count // 0) | tostring), ((.unread // 0) | tostring)] | @tsv),
      ($snapshot.inbox[]? | ["inbox", (.id | clean), (.contact_name | clean), (.transport | clean), (.subject | clean), (.preview | clean), (.received_at | clean)] | @tsv),
      ($snapshot.threads[]? | ["thread", (.id | clean), (.name | clean), (.kind | clean), ((.unread_count // 0) | tostring), (.latest_at | clean), (if (.simplex_address // "") != "" then "simplex" else "" end), (if (.email // "") != "" then "email" else "" end)] | @tsv),
      ($snapshot.drafts[]? | ["draft", (.ulid | clean), (.to | clean), (.subject | clean), (.updated_at | clean)] | @tsv),
      ($snapshot.events[]? | ["event", (.id | clean), ((.kind // .label // "event") | clean), (.message | clean), ((.created_at // .at // "") | clean)] | @tsv)
  '
}

send_message_action() {
  thread_id=$(safe_slug "${1-}")
  transport=${2-}
  subject=${3-}
  body_b64=${4-}
  [ -n "$thread_id" ] || usage_error "send-message requires THREAD_ID"
  case "$transport" in
    simplex|email) ;;
    *) usage_error "send-message transport must be simplex or email" ;;
  esac
  body_tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-body.XXXXXX")
  decode_b64_to_file "$body_b64" "$body_tmp" || {
    rm -f "$body_tmp"
    usage_error "invalid base64 body payload"
  }
  body=$(cat "$body_tmp")
  rm -f "$body_tmp"

  contact_file=$(native_contact_file "$thread_id")
  email=$(config_get "$contact_file" email 2>/dev/null || printf '')
  simplex=$(config_get "$contact_file" simplex_address 2>/dev/null || printf '')
  name=$(config_get "$contact_file" name 2>/dev/null || printf "$thread_id")

  if [ "$transport" = "simplex" ]; then
    [ -n "$simplex" ] || usage_error "SimpleX transport selected but no SimpleX path is bound for $name"
    result=$(append_simplex_message "$thread_id" "$body" true false "$subject")
    outbox_file="$(simplex_outbox_dir)/$(printf '%s\n' "$result" | jq -r '.id').json"
    mkdir -p "$(dirname "$outbox_file")"
    printf '%s\n' "$result" | jq \
      --arg thread_id "$thread_id" \
      --arg simplex_address "$simplex" \
      --arg subject "$subject" \
      --arg body "$body" \
      '. + {transport:"simplex",thread_id:$thread_id,simplex_address:$simplex_address,subject:$subject,body:$body,queued_at:(now|todateiso8601)}' >"$outbox_file"
    printf '%s\n' "$result" | jq --arg outbox_path "$outbox_file" '. + {transport:"simplex",outbox_path:$outbox_path}'
    return 0
  fi

  [ -n "$email" ] || usage_error "Email transport selected but no email address is bound for $name"
  # Email is intentionally explicit. The SimpleX path never falls back here.
  saved=$(owl_backend_json draft-save new "Owl <owl@example.org>" "$email" "" "" "$subject" "" "$body_b64") || fail "could not save Owl draft for email transport"
  ulid=$(printf '%s\n' "$saved" | jq -r '.ulid // ""')
  [ -n "$ulid" ] || fail "Owl draft-save did not return a draft id"
  sent=$(owl_backend_json draft-send "$ulid") || fail "could not send Owl draft"
  jq -n --arg transport email --arg ulid "$ulid" --argjson draft "$saved" --argjson send "$sent" '{ok:true,transport:$transport,ulid:$ulid,draft:$draft,send:$send}'
}

email_message_parts_from_id() {
  message_id_value=$1
  case "$message_id_value" in
    email:*)
      rest=${message_id_value#email:}
      list=${rest%%:*}
      rest=${rest#*:}
      sender_slug=${rest%%:*}
      ulid=${rest#*:}
      printf '%s\n%s\n%s\n' "$list" "$sender_slug" "$ulid"
      return 0
      ;;
  esac
  return 1
}

email_message_lookup() {
  message_id_value=$1
  list=$(email_message_parts_from_id "$message_id_value" | sed -n '1p')
  sender_slug=$(email_message_parts_from_id "$message_id_value" | sed -n '2p')
  ulid=$(email_message_parts_from_id "$message_id_value" | sed -n '3p')
  [ -n "$list" ] && [ -n "$ulid" ] || return 1
  owl_messages_for_list "$list" | jq -r --arg id "$message_id_value" --arg fallback_list "$list" '
    def slug: tostring | ascii_downcase | gsub("[^a-z0-9._@-]+"; "-") | gsub("^-+"; "") | gsub("-+$"; "") | if length == 0 then "unknown" else . end;
    .messages[]?
    | select(("email:" + (.list // $fallback_list) + ":" + ((.sender // "") | slug) + ":" + (.ulid // "")) == $id)
    | [(.list // $fallback_list), (.sender // ""), (.ulid // "")] | @tsv
  ' | head -n 1
}

simplex_message_lookup() {
  message_id_value=$1
  dir=$(simplex_threads_dir)
  [ -d "$dir" ] || return 1
  for file in "$dir"/*.jsonl; do
    [ -f "$file" ] || continue
    row=$(jq -c --arg id "$message_id_value" 'select(.id == $id)' "$file" 2>/dev/null | head -n 1)
    if [ -n "$row" ]; then
      printf '%s\n' "$row"
      return 0
    fi
  done
  return 1
}

message_detail_action() {
  id=${1-}
  [ -n "$id" ] || usage_error "message-detail requires MESSAGE_ID"
  case "$id" in
    simplex:*)
      row=$(simplex_message_lookup "$id" || true)
      [ -n "$row" ] || usage_error "SimpleX message not found: $id"
      printf '%s\n' "$row" | jq --arg id "$id" '. + {ok:true,id:$id,transport:"simplex"}'
      ;;
    email:*)
      row=$(email_message_lookup "$id")
      [ -n "$row" ] || usage_error "email message not found: $id"
      list=$(printf '%s\n' "$row" | awk -F '\t' '{print $1}')
      sender=$(printf '%s\n' "$row" | awk -F '\t' '{print $2}')
      ulid=$(printf '%s\n' "$row" | awk -F '\t' '{print $3}')
      owl_backend_json get-message "$list" "$sender" "$ulid" | jq --arg id "$id" '. + {ok:true,id:$id,transport:"email"}'
      ;;
    *)
      usage_error "unsupported message id: $id"
      ;;
  esac
}

archive_message_action() {
  id=${1-}
  case "$id" in
    simplex:*)
      rewrite_simplex_message_field "$id" in_inbox false || usage_error "message not found: $id"
      jq -n --arg id "$id" '{ok:true,id:$id,in_inbox:false}'
      ;;
    email:*)
      row=$(email_message_lookup "$id")
      [ -n "$row" ] || usage_error "email message not found: $id"
      list=$(printf '%s\n' "$row" | awk -F '\t' '{print $1}')
      sender=$(printf '%s\n' "$row" | awk -F '\t' '{print $2}')
      ulid=$(printf '%s\n' "$row" | awk -F '\t' '{print $3}')
      case "$list" in
        accepted|quarantine)
          owl_backend_json move-message "$list" archive "$sender" "$ulid"
          ;;
        *)
          jq -n --arg id "$id" --arg list "$list" '{ok:true,id:$id,list:$list,already_archived:true}'
          ;;
      esac
      ;;
    *)
      usage_error "unsupported message id: $id"
      ;;
  esac
}

delete_message_action() {
  id=${1-}
  case "$id" in
    simplex:*)
      rewrite_simplex_message_field "$id" status deleted || usage_error "message not found: $id"
      rewrite_simplex_message_field "$id" in_inbox false || true
      jq -n --arg id "$id" '{ok:true,id:$id,deleted:true}'
      ;;
    email:*)
      row=$(email_message_lookup "$id")
      [ -n "$row" ] || usage_error "email message not found: $id"
      list=$(printf '%s\n' "$row" | awk -F '\t' '{print $1}')
      sender=$(printf '%s\n' "$row" | awk -F '\t' '{print $2}')
      ulid=$(printf '%s\n' "$row" | awk -F '\t' '{print $3}')
      owl_backend_json delete-message "$list" "$sender" "$ulid"
      ;;
    *)
      usage_error "unsupported message id: $id"
      ;;
  esac
}

toggle_star_action() {
  id=${1-}
  value=${2-false}
  case "$value" in true|1|yes|on) value=true ;; *) value=false ;; esac
  case "$id" in
    email:*)
      row=$(email_message_lookup "$id")
      [ -n "$row" ] || usage_error "email message not found: $id"
      list=$(printf '%s\n' "$row" | awk -F '\t' '{print $1}')
      sender=$(printf '%s\n' "$row" | awk -F '\t' '{print $2}')
      ulid=$(printf '%s\n' "$row" | awk -F '\t' '{print $3}')
      owl_backend_json set-flag "$list" "$sender" "$ulid" starred "$value"
      ;;
    *)
      jq -n --arg id "$id" --argjson value "$value" '{ok:true,id:$id,starred:$value,ignored:true}'
      ;;
  esac
}

simplex_release_api_url() {
  printf '%s\n' "${OWL_NATIVE_SIMPLEX_RELEASE_API_URL:-https://api.github.com/repos/simplex-chat/simplex-chat/releases/latest}"
}

simplex_platform_os() {
  printf '%s\n' "${OWL_NATIVE_SIMPLEX_PLATFORM_OS:-$(uname -s 2>/dev/null || printf unknown)}"
}

simplex_platform_arch() {
  printf '%s\n' "${OWL_NATIVE_SIMPLEX_PLATFORM_ARCH:-$(uname -m 2>/dev/null || printf unknown)}"
}

simplex_asset_name() {
  if [ -n "${OWL_NATIVE_SIMPLEX_ASSET_NAME-}" ]; then
    printf '%s\n' "$OWL_NATIVE_SIMPLEX_ASSET_NAME"
    return 0
  fi
  case "$(simplex_platform_os):$(simplex_platform_arch)" in
    Darwin:arm64|Darwin:aarch64)
      printf '%s\n' simplex-chat-macos-aarch64
      ;;
    Darwin:x86_64|Darwin:amd64)
      printf '%s\n' simplex-chat-macos-x86-64
      ;;
    Linux:x86_64|Linux:amd64)
      printf '%s\n' simplex-chat-ubuntu-22_04-x86_64
      ;;
    Linux:aarch64|Linux:arm64)
      printf '%s\n' simplex-chat-ubuntu-22_04-aarch64
      ;;
    *)
      return 1
      ;;
  esac
}

fetch_url_to_file() {
  url=$1
  output=$2
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$output"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$output" "$url"
    return
  fi
  fail "curl or wget is required to download SimpleX CLI"
}

sha256_file() {
  file=$1
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$file" | awk '{print $1}'
    return
  fi
  sha256sum "$file" | awk '{print $1}'
}

simplex_binary_candidate() {
  candidate=${1-}
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then
    printf '%s\n' "$candidate"
    return 0
  fi
  return 1
}

simplex_binary_resolved() {
  binary=$(config_get "$(simplex_install_file)" binary_path 2>/dev/null || printf '')
  if simplex_binary_candidate "$binary"; then
    return 0
  fi
  current=$(simplex_current_binary)
  if simplex_binary_candidate "$current"; then
    return 0
  fi
  binary=$(config_get "$(wizardry_simplex_install_file)" binary_path 2>/dev/null || printf '')
  if simplex_binary_candidate "$binary"; then
    return 0
  fi
  current=$(wizardry_simplex_current_binary)
  if simplex_binary_candidate "$current"; then
    return 0
  fi
  if simplex_binary_candidate "$(simplex_user_bin_path)"; then
    return 0
  fi
  path_binary=$(command -v simplex-chat 2>/dev/null || printf '')
  if simplex_binary_candidate "$path_binary"; then
    return 0
  fi
  for candidate in /usr/local/bin/simplex-chat /opt/homebrew/bin/simplex-chat /usr/bin/simplex-chat; do
    if simplex_binary_candidate "$candidate"; then
      return 0
    fi
  done
  return 1
}

simplex_install_file_for_binary() {
  binary=${1-}
  app_file=$(simplex_install_file)
  app_binary=$(config_get "$app_file" binary_path 2>/dev/null || printf '')
  if [ -n "$binary" ] && { [ "$binary" = "$app_binary" ] || [ "$binary" = "$(simplex_current_binary)" ]; }; then
    printf '%s\n' "$app_file"
    return 0
  fi

  wizardry_file=$(wizardry_simplex_install_file)
  wizardry_binary=$(config_get "$wizardry_file" binary_path 2>/dev/null || printf '')
  if [ -n "$binary" ] && { [ "$binary" = "$wizardry_binary" ] || [ "$binary" = "$(wizardry_simplex_current_binary)" ] || [ "$binary" = "$(simplex_user_bin_path)" ]; }; then
    printf '%s\n' "$wizardry_file"
    return 0
  fi

  if [ -f "$app_file" ]; then
    printf '%s\n' "$app_file"
    return 0
  fi
  if [ -f "$wizardry_file" ]; then
    printf '%s\n' "$wizardry_file"
    return 0
  fi
  return 1
}

simplex_validate_binary() {
  binary=$1
  install_conf=$(simplex_install_file)
  tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-simplex-validate.XXXXXX")
  if "$binary" -h >"$tmp" 2>&1; then
    config_set "$install_conf" validation_state ready
    config_set "$install_conf" last_error ''
    rm -f "$tmp"
    return 0
  fi
  error=$(head -n 4 "$tmp" | paste -sd ' ' -)
  config_set "$install_conf" validation_state error
  config_set "$install_conf" last_error "$error"
  rm -f "$tmp"
  return 1
}

simplex_install_state() {
  if ! simplex_asset_name >/dev/null 2>&1; then
    printf '%s\n' unsupported
    return 0
  fi
  if binary=$(simplex_binary_resolved 2>/dev/null); then
    install_file=$(simplex_install_file_for_binary "$binary" 2>/dev/null || printf '')
    validation=$(config_get "$install_file" validation_state 2>/dev/null || printf ready)
    if [ "$validation" = error ]; then
      printf '%s\n' broken
    else
      printf '%s\n' installed
    fi
    return 0
  fi
  if [ -f "$(simplex_install_file)" ] || [ -f "$(wizardry_simplex_install_file)" ]; then
    printf '%s\n' broken
  else
    printf '%s\n' missing
  fi
}

simplex_install_source() {
  install_file=${1-}
  if [ -z "$install_file" ]; then
    printf '%s\n' path
    return 0
  fi
  if [ "$install_file" = "$(simplex_install_file)" ]; then
    printf '%s\n' owl-native
    return 0
  fi
  if [ "$install_file" = "$(wizardry_simplex_install_file)" ]; then
    printf '%s\n' wizardry
    return 0
  fi
  printf '%s\n' path
}

append_path_dir() {
  path_dir=${1-}
  [ -d "$path_dir" ] || return 0
  case ":${wizardry_path_prefix-}:" in
    *":$path_dir:"*) return 0 ;;
  esac
  if [ -n "${wizardry_path_prefix-}" ]; then
    wizardry_path_prefix="$wizardry_path_prefix:$path_dir"
  else
    wizardry_path_prefix="$path_dir"
  fi
}

wizardry_command_path() {
  wizardry_dir=${WIZARDRY_DIR:-$HOME/.wizardry}
  wizardry_path_prefix=
  append_path_dir "$wizardry_dir/spells"
  append_path_dir "$wizardry_dir/spells/.imps"
  for path_dir in "$wizardry_dir"/spells/.imps/*; do
    append_path_dir "$path_dir"
    for nested_dir in "$path_dir"/*; do
      append_path_dir "$nested_dir"
    done
  done
  for path_dir in "$wizardry_dir"/spells/.arcana/* "$wizardry_dir"/spells/*; do
    append_path_dir "$path_dir"
  done
  if [ -n "$wizardry_path_prefix" ]; then
    printf '%s:%s\n' "$wizardry_path_prefix" "${PATH:-/usr/bin:/bin:/usr/sbin:/sbin}"
  else
    printf '%s\n' "${PATH:-/usr/bin:/bin:/usr/sbin:/sbin}"
  fi
}

wizardry_simplex_installer() {
  if [ -n "${OWL_NATIVE_SIMPLEX_INSTALLER-}" ] && [ -f "$OWL_NATIVE_SIMPLEX_INSTALLER" ]; then
    printf '%s\n' "$OWL_NATIVE_SIMPLEX_INSTALLER"
    return 0
  fi
  installer=$(command -v install-simplex-chat 2>/dev/null || printf '')
  if [ -n "$installer" ] && [ -f "$installer" ]; then
    printf '%s\n' "$installer"
    return 0
  fi
  for installer in \
    "${WIZARDRY_DIR:-$HOME/.wizardry}/spells/.arcana/simplex-chat/install-simplex-chat" \
    "$HOME/.wizardry/spells/.arcana/simplex-chat/install-simplex-chat"
  do
    if [ -f "$installer" ]; then
      printf '%s\n' "$installer"
      return 0
    fi
  done
  return 1
}

simplex_profile_ready_prefix() {
  prefix=$1
  if [ -f "${prefix}_v1_chat.db" ] && [ -f "${prefix}_v1_agent.db" ]; then
    return 0
  fi
  [ -f "${prefix}_chat.db" ] && [ -f "${prefix}_agent.db" ]
}

simplex_profile_ready() {
  simplex_profile_ready_prefix "$(simplex_profile_prefix "${1:-default}")"
}

bootstrap_status_action() {
  ident=${1:-default}
  state=$(simplex_install_state)
  asset=$(simplex_asset_name 2>/dev/null || printf '')
  binary=$(simplex_binary_resolved 2>/dev/null || printf '')
  install_file=$(simplex_install_file_for_binary "$binary" 2>/dev/null || printf '')
  version=$(config_get "$install_file" version 2>/dev/null || printf '')
  error=$(config_get "$install_file" last_error 2>/dev/null || printf '')
  source=$(simplex_install_source "$install_file")
  profile_prefix=$(simplex_profile_prefix "$ident")
  if simplex_profile_ready "$ident"; then
    profile_ready=true
  else
    profile_ready=false
  fi
  supported=true
  [ -n "$asset" ] || supported=false
  jq -n \
    --arg identity "$ident" \
    --arg install_state "$state" \
    --arg asset_name "$asset" \
    --arg version "$version" \
    --arg binary_path "$binary" \
    --arg install_source "$source" \
    --arg profile_prefix "$profile_prefix" \
    --arg last_error "$error" \
    --arg platform_os "$(simplex_platform_os)" \
    --arg platform_arch "$(simplex_platform_arch)" \
    --argjson supported "$supported" \
    --argjson profile_ready "$profile_ready" \
    '{ok:true,identity:$identity,supported:$supported,install_state:$install_state,install_source:$install_source,asset_name:$asset_name,version:$version,binary_path:$binary_path,profile_prefix:$profile_prefix,profile_ready:$profile_ready,last_error:$last_error,platform_os:$platform_os,platform_arch:$platform_arch}'
}

install_simplex_cli_action() {
  require_cmd jq
  wizardry_installer=$(wizardry_simplex_installer 2>/dev/null || printf '')
  if [ -n "$wizardry_installer" ]; then
    install_log=$(mktemp "${TMPDIR:-/tmp}/owl-native-simplex-wizardry-install.XXXXXX")
    if PATH=$(wizardry_command_path) sh "$wizardry_installer" >"$install_log" 2>&1; then
      binary=$(simplex_binary_resolved 2>/dev/null || printf '')
      [ -n "$binary" ] || {
        rm -f "$install_log"
        fail "Wizardry SimpleX installer completed without exposing simplex-chat"
      }
      install_file=$(simplex_install_file_for_binary "$binary" 2>/dev/null || printf '')
      version=$(config_get "$install_file" version 2>/dev/null || printf '')
      asset=$(config_get "$install_file" asset_name 2>/dev/null || simplex_asset_name 2>/dev/null || printf '')
      rm -f "$install_log"
      jq -n \
        --arg version "$version" \
        --arg asset_name "$asset" \
        --arg binary_path "$binary" \
        '{ok:true,action:"install-simplex-cli",install_source:"wizardry",version:$version,asset_name:$asset_name,binary_path:$binary_path}'
      return 0
    fi
    error=$(head -n 6 "$install_log" | paste -sd ' ' -)
    rm -f "$install_log"
    fail "Wizardry SimpleX installer failed: $error"
  fi

  asset=$(simplex_asset_name 2>/dev/null || true)
  [ -n "$asset" ] || usage_error "unsupported platform for SimpleX CLI: $(simplex_platform_os)/$(simplex_platform_arch)"
  tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/owl-native-simplex-install.XXXXXX")
  release_json="$tmp_dir/release.json"
  fetch_url_to_file "$(simplex_release_api_url)" "$release_json"
  tag=$(jq -r '.tag_name // ""' "$release_json")
  [ -n "$tag" ] || {
    rm -rf "$tmp_dir"
    fail "could not determine latest SimpleX release tag"
  }
  url=$(jq -r --arg asset "$asset" '.assets[]? | select(.name == $asset) | .browser_download_url // ""' "$release_json" | head -n 1)
  digest=$(jq -r --arg asset "$asset" '.assets[]? | select(.name == $asset) | .digest // ""' "$release_json" | head -n 1)
  digest=${digest#sha256:}
  [ -n "$url" ] || {
    rm -rf "$tmp_dir"
    fail "release asset missing for $asset"
  }
  version_dir="$(simplex_releases_dir)/$tag"
  version_file="$version_dir/$asset"
  mkdir -p "$version_dir" "$(simplex_current_dir)"
  if [ ! -f "$version_file" ] || { [ -n "$digest" ] && [ "$(sha256_file "$version_file" 2>/dev/null || printf invalid)" != "$digest" ]; }; then
    download="$tmp_dir/$asset"
    fetch_url_to_file "$url" "$download"
    if [ -n "$digest" ]; then
      actual=$(sha256_file "$download")
      [ "$actual" = "$digest" ] || {
        rm -rf "$tmp_dir"
        fail "sha256 mismatch for $asset"
      }
    fi
    chmod +x "$download" 2>/dev/null || true
    mv "$download" "$version_file"
  fi
  chmod +x "$version_file" 2>/dev/null || true
  current=$(simplex_current_binary)
  rm -f "$current"
  if ! ln -s "../releases/$tag/$asset" "$current" 2>/dev/null; then
    cp "$version_file" "$current"
    chmod +x "$current" 2>/dev/null || true
  fi
  install_conf=$(simplex_install_file)
  config_set "$install_conf" version "$tag"
  config_set "$install_conf" asset_name "$asset"
  config_set "$install_conf" asset_url "$url"
  config_set "$install_conf" sha256 "$digest"
  config_set "$install_conf" platform_os "$(simplex_platform_os)"
  config_set "$install_conf" platform_arch "$(simplex_platform_arch)"
  config_set "$install_conf" binary_path "$current"
  config_set "$install_conf" installed_at "$(now_iso)"
  config_set "$install_conf" validation_state pending
  config_set "$install_conf" last_error ''
  simplex_validate_binary "$current" || true
  rm -rf "$tmp_dir"
  jq -n --arg version "$tag" --arg asset_name "$asset" --arg binary_path "$current" '{ok:true,action:"install-simplex-cli",install_source:"owl-native",version:$version,asset_name:$asset_name,binary_path:$binary_path}'
}

simplex_initialize_profile() {
  binary=$1
  prefix=$2
  display_name=${3:-Owl}
  full_name=${4:-Owl Native}
  log_file=$5
  tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/owl-native-simplex-init.XXXXXX")
  input="$tmp_dir/input.txt"
  display_name=$(printf '%s' "$display_name" | tr '\r' '\n' | head -n 1)
  full_name=$(printf '%s' "$full_name" | tr '\r' '\n' | head -n 1)
  printf '%s\n%s\n/quit\n' "$display_name" "$full_name" >"$input"
  if "$binary" -d "$prefix" <"$input" >"$log_file" 2>&1; then
    rm -rf "$tmp_dir"
    return 0
  fi
  if simplex_profile_ready_prefix "$prefix"; then
    rm -rf "$tmp_dir"
    return 0
  fi
  if command -v script >/dev/null 2>&1; then
    if script -q "$log_file" "$binary" -d "$prefix" <"$input" >/dev/null 2>&1; then
      rm -rf "$tmp_dir"
      return 0
    fi
    if simplex_profile_ready_prefix "$prefix"; then
      rm -rf "$tmp_dir"
      return 0
    fi
  fi
  rm -rf "$tmp_dir"
  return 1
}

provision_simplex_identity_action() {
  ident=$(safe_slug "${1:-default}")
  display_name=${2:-Owl}
  full_name=${3:-Owl Native}
  binary=$(simplex_binary_resolved 2>/dev/null || true)
  [ -n "$binary" ] || usage_error "SimpleX CLI is not installed"
  simplex_validate_binary "$binary" || true
  dir=$(simplex_identity_dir "$ident")
  prefix=$(simplex_profile_prefix "$ident")
  log_file="$dir/init.log"
  mkdir -p "$dir"
  if ! simplex_profile_ready "$ident"; then
    simplex_initialize_profile "$binary" "$prefix" "$display_name" "$full_name" "$log_file" || fail "failed to initialize SimpleX profile for $ident"
  fi
  config_set "$dir/profile.conf" display_name "$display_name"
  config_set "$dir/profile.conf" full_name "$full_name"
  config_set "$dir/profile.conf" profile_prefix "$prefix"
  config_set "$dir/profile.conf" binary_path "$binary"
  if simplex_profile_ready "$ident"; then ready=true; else ready=false; fi
  jq -n --arg identity "$ident" --arg profile_prefix "$prefix" --arg binary_path "$binary" --argjson profile_ready "$ready" '{ok:true,action:"provision-simplex-identity",identity:$identity,profile_prefix:$profile_prefix,binary_path:$binary_path,profile_ready:$profile_ready}'
}

simplex_transport_hook_path() {
  ident=$(safe_slug "${1:-default}")
  if [ -n "${OWL_NATIVE_SIMPLEX_TRANSPORT_HOOK-}" ]; then
    printf '%s\n' "$OWL_NATIVE_SIMPLEX_TRANSPORT_HOOK"
    return 0
  fi
  config_get "$(simplex_profile_conf "$ident")" transport_hook 2>/dev/null || return 1
}

set_simplex_transport_hook_action() {
  ident=$(safe_slug "${1:-default}")
  hook_path=${2-}
  case "$hook_path" in
    *"$nl"*|*"$cr"*) usage_error "SimpleX hook path must be a single line" ;;
  esac
  if [ -n "$hook_path" ] && [ ! -x "$hook_path" ]; then
    usage_error "SimpleX hook is not executable: $hook_path"
  fi
  config_set "$(simplex_profile_conf "$ident")" transport_hook "$hook_path"
  simplex_transport_status_action "$ident"
}

simplex_transport_status_action() {
  ident=$(safe_slug "${1:-default}")
  hook=$(simplex_transport_hook_path "$ident" 2>/dev/null || printf '')
  if [ -n "$hook" ] && [ -x "$hook" ]; then
    hook_ready=true
  else
    hook_ready=false
  fi
  jq -n \
    --arg identity "$ident" \
    --arg hook_path "$hook" \
    --arg incoming_dir "$(simplex_incoming_dir)" \
    --arg outbox_dir "$(simplex_outbox_dir)" \
    --argjson hook_ready "$hook_ready" \
    '{ok:true,identity:$identity,hook_path:$hook_path,hook_ready:$hook_ready,incoming_dir:$incoming_dir,outbox_dir:$outbox_dir}'
}

run_simplex_poll_hook() {
  ident=$(safe_slug "${1:-default}")
  hook=$(simplex_transport_hook_path "$ident" 2>/dev/null || printf '')
  [ -n "$hook" ] && [ -x "$hook" ] || return 0
  "$hook" poll "$ident" "$ROOT" "$(simplex_incoming_dir)"
}

process_simplex_outbox() {
  ident=$(safe_slug "${1:-default}")
  hook=$(simplex_transport_hook_path "$ident" 2>/dev/null || printf '')
  processed_root="$(simplex_processed_dir)/outbox"
  mkdir -p "$processed_root"
  sent=0
  waiting=0
  failed=0
  for simplex_outbox_file in "$(simplex_outbox_dir)"/*.json; do
    [ -f "$simplex_outbox_file" ] || continue
    id=$(jq -r '.id // ""' "$simplex_outbox_file" 2>/dev/null | head -n 1)
    [ -n "$id" ] || {
      failed=$((failed + 1))
      continue
    }
    if [ -z "$hook" ] || [ ! -x "$hook" ]; then
      rewrite_simplex_message_field "$id" status waiting-adapter 2>/dev/null || true
      waiting=$((waiting + 1))
      continue
    fi
    if "$hook" send "$ident" "$ROOT" "$simplex_outbox_file"; then
      rewrite_simplex_message_field "$id" status sent 2>/dev/null || true
      mv "$simplex_outbox_file" "$processed_root/$(basename "$simplex_outbox_file").sent.$(date -u +%Y%m%dT%H%M%SZ)" 2>/dev/null || rm -f "$simplex_outbox_file"
      sent=$((sent + 1))
    else
      rewrite_simplex_message_field "$id" status error 2>/dev/null || true
      failed=$((failed + 1))
    fi
  done
  jq -n --argjson sent "$sent" --argjson waiting "$waiting" --argjson failed "$failed" '{sent:$sent,waiting:$waiting,failed:$failed}'
}

tick_simplex_action() {
  ensure_roots
  ident=${1:-default}
  poll_error=
  if ! run_simplex_poll_hook "$ident" 2>"$(simplex_processed_dir)/last-poll-error.log"; then
    poll_error=$(cat "$(simplex_processed_dir)/last-poll-error.log" 2>/dev/null | head -n 3 | paste -sd ' ' -)
  fi
  outbox_json=$(process_simplex_outbox "$ident")
  imported=0
  for simplex_incoming_file in "$(simplex_incoming_dir)"/*.json "$ROOT/.transport/incoming"/*.json; do
    [ -f "$simplex_incoming_file" ] || continue
    thread_id=$(jq -r '.thread_id // .contact_key // .contact // "unknown"' "$simplex_incoming_file" 2>/dev/null | head -n 1)
    body=$(jq -r '.body // .text // .message // ""' "$simplex_incoming_file" 2>/dev/null | head -n 1)
    subject=$(jq -r '.subject // ""' "$simplex_incoming_file" 2>/dev/null | head -n 1)
    from_self=$(jq -r '.from_self // false' "$simplex_incoming_file" 2>/dev/null | head -n 1)
    in_inbox=$(jq -r '.in_inbox // true' "$simplex_incoming_file" 2>/dev/null | head -n 1)
    [ -n "$body" ] || continue
    append_simplex_message "$thread_id" "$body" "$from_self" "$in_inbox" "$subject" >/dev/null
    mkdir -p "$(simplex_processed_dir)"
    mv "$simplex_incoming_file" "$(simplex_processed_dir)/$(basename "$simplex_incoming_file").$(date -u +%Y%m%dT%H%M%SZ)" 2>/dev/null || rm -f "$simplex_incoming_file"
    imported=$((imported + 1))
  done
  jq -n \
    --arg identity "$ident" \
    --arg poll_error "$poll_error" \
    --argjson imported "$imported" \
    --argjson outbox "$outbox_json" \
    '{ok:true,action:"tick-simplex",identity:$identity,imported:$imported,outbox:$outbox,poll_error:$poll_error}'
}

[ -n "$action" ] || usage_error "ACTION is required"
require_cmd jq

case "$action" in
  doctor)
    if resolve_owl_backend_script >/dev/null 2>&1; then owl_backend=ready; else owl_backend=missing; fi
    jq -n \
      --arg root "$ROOT" \
      --arg repo_root "$repo_dir" \
      --arg owl_backend "$owl_backend" \
      --arg simplex_state "$(simplex_install_state)" \
      '{ok:true,root:$root,repo_root:$repo_root,owl_backend:$owl_backend,simplex_install_state:$simplex_state}'
    ;;
  prepare)
    ensure_roots
    jq -n --arg root "$ROOT" --arg metadata_root "$(metadata_root)" '{ok:true,root:$root,metadata_root:$metadata_root}'
    ;;
  get-paths)
    jq -n \
      --arg root "$ROOT" \
      --arg metadata_root "$(metadata_root)" \
      --arg native_contacts "$(native_contacts_dir)" \
      --arg simplex_threads "$(simplex_threads_dir)" \
      --arg simplex_incoming "$(simplex_incoming_dir)" \
      --arg simplex_outbox "$(simplex_outbox_dir)" \
      --arg simplex_system "$(simplex_system_root)" \
      '{ok:true,root:$root,metadata_root:$metadata_root,native_contacts:$native_contacts,simplex_threads:$simplex_threads,simplex_incoming:$simplex_incoming,simplex_outbox:$simplex_outbox,simplex_system:$simplex_system}'
    ;;
  get-ui-prefs)
    ui_prefs_action
    ;;
  set-ui-pref)
    set_ui_pref_action "${1-}" "${2-}"
    ;;
  snapshot)
    snapshot_action
    ;;
  snapshot-lines)
    snapshot_lines_action
    ;;
  health|overview|settings-controls|settings-browse-root|settings-set-test-recipient|settings-verify-domain|settings-set-domain|settings-ssl-prereq-status|settings-ssl-wizard-status|settings-setup-ssl|settings-set-daemon-installed|settings-set-daemon-running|settings-set-daemon-startup|settings-setup-folders|settings-remote-set-target|settings-remote-set-auth|settings-remote-deploy|settings-remote-verify|settings-remote-send-test|settings-remote-sync|settings-llm-controls|settings-llm-set|settings-llm-install-ollama|settings-llm-set-daemon|settings-llm-install-model|settings-llm-uninstall-model|spam-classify|event-feed|contact-get|contact-save|list-senders|list-archive-bundle|list-inbox-bundle-fast|list-messages-fast|list-messages|set-flag|move-message|move-sender|draft-list|draft-get|draft-save|draft-delete|draft-send)
    owl_backend_json "$action" "$@"
    ;;
  bind-contact)
    ensure_roots
    save_contact_binding "${1-}" "${2-}" "${3-person}" "${4-}" "${5-}" "${6-no}" | jq '{ok:true,contact:.}'
    ;;
  import-simplex)
    ensure_roots
    thread_id=${1-}
    body_b64=${2-}
    from_self=${3-false}
    in_inbox=${4-true}
    subject=${5-}
    body_tmp=$(mktemp "${TMPDIR:-/tmp}/owl-native-simplex-body.XXXXXX")
    decode_b64_to_file "$body_b64" "$body_tmp" || {
      rm -f "$body_tmp"
      usage_error "invalid base64 body payload"
    }
    body=$(cat "$body_tmp")
    rm -f "$body_tmp"
    append_simplex_message "$thread_id" "$body" "$from_self" "$in_inbox" "$subject"
    ;;
  mark-inbox)
    id=${1-}
    mode=${2-}
    case "$id" in
      simplex:*)
        case "$mode" in in|true|1|yes|on) value=true ;; out|false|0|no|off) value=false ;; *) usage_error "mark-inbox requires in|out" ;; esac
        rewrite_simplex_message_field "$id" in_inbox "$value" || usage_error "message not found: $id"
        jq -n --arg id "$id" --argjson in_inbox "$value" '{ok:true,id:$id,in_inbox:$in_inbox}'
        ;;
      email:*)
        case "$mode" in
          in)
            jq -n --arg id "$id" '{ok:true,id:$id,note:"Email inbox state is represented by Owl list membership."}'
            ;;
          out)
            archive_message_action "$id"
            ;;
          *)
            usage_error "mark-inbox requires in|out"
            ;;
        esac
        ;;
      *)
        usage_error "unsupported message id: $id"
        ;;
    esac
    ;;
  mark-read)
    id=${1-}
    value=${2-true}
    case "$value" in true|1|yes|on) value=true ;; *) value=false ;; esac
    case "$id" in
      simplex:*)
        rewrite_simplex_message_field "$id" read "$value" || usage_error "message not found: $id"
        jq -n --arg id "$id" --argjson read "$value" '{ok:true,id:$id,read:$read}'
        ;;
      email:*)
        row=$(email_message_lookup "$id")
        [ -n "$row" ] || usage_error "email message not found: $id"
        list=$(printf '%s\n' "$row" | awk -F '\t' '{print $1}')
        sender=$(printf '%s\n' "$row" | awk -F '\t' '{print $2}')
        ulid=$(printf '%s\n' "$row" | awk -F '\t' '{print $3}')
        owl_backend_json set-flag "$list" "$sender" "$ulid" read "$value"
        ;;
      *)
        usage_error "unsupported message id: $id"
        ;;
    esac
    ;;
  send-message)
    ensure_roots
    send_message_action "${1-}" "${2-}" "${3-}" "${4-}"
    ;;
  message-detail)
    message_detail_action "${1-}"
    ;;
  archive-message)
    archive_message_action "${1-}"
    ;;
  delete-message)
    if [ "$#" -ge 3 ]; then
      owl_backend_json delete-message "$@"
    else
      delete_message_action "${1-}"
    fi
    ;;
  get-message)
    if [ "$#" -ge 3 ]; then
      owl_backend_json get-message "$@"
    else
      message_detail_action "${1-}"
    fi
    ;;
  toggle-star)
    toggle_star_action "${1-}" "${2-false}"
    ;;
  bootstrap-status)
    bootstrap_status_action "${1:-default}"
    ;;
  install-simplex-cli)
    ensure_roots
    install_simplex_cli_action
    ;;
  provision-simplex-identity)
    ensure_roots
    provision_simplex_identity_action "${1:-default}" "${2:-Owl}" "${3:-Owl Native}"
    ;;
  set-simplex-transport-hook)
    ensure_roots
    set_simplex_transport_hook_action "${1:-default}" "${2-}"
    ;;
  simplex-transport-status)
    ensure_roots
    simplex_transport_status_action "${1:-default}"
    ;;
  tick-simplex|tick-transport)
    tick_simplex_action "${1:-default}"
    ;;
  *)
    usage_error "unsupported action: $action"
    ;;
esac
