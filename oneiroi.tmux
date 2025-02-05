#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get() {
  local option=$1
  local default_value=$2
  local option_value="$(tmux show-option -gqv "$option")"

  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

set() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

setw() {
  local option=$1
  local value=$2
  tmux set-window-option -gq "$option" "$value"
}

case "$(get @oneiroi_palette "dream")" in
melatonin) palette="melatonin" ;;
dream | *) palette="dream" ;;
esac

tmux source "$current_dir/themes/oneiroi_${palette}_tmux.conf"

fg=$(get @oneiroi_for_s "white")              #fg
case "$(get @oneiroi_background "normal")" in #bg
transparent) bg="default" ;;
dark) bg=$(get @oneiroi_bac2 "black") ;;
normal | *) bg=$(get @oneiroi_bg "black") ;;
esac
bac=$(get @oneiroi_bg "black")

prim=$(get @oneiroi_primary "red")
prims=$(get @oneiroi_primary_s "red")
seco=$(get @oneiroi_secondary "yellow")
secos=$(get @oneiroi_secondary_s "yellow")
tert=$(get @oneiroi_tertiary "green")
terts=$(get @oneiroi_tertiary_s "green")

session=$(get @oneiroi_session "[#S] ")
widgets=$(get @oneiroi_widgets)
date_time=$(get @oneiroi_datetime "%Y-%m-%d %H:%M ")
user=$(get @oneiroi_user "#[fg=$terts]│ #[fg=$prim]#(whoami) ")

set pane-border-style "fg=$prims"
set pane-active-border-style "fg=$seco"

set status-justify "left"
set status-left-length "10"
set status-right-length "50"
set status-right-attr "none"

set status-style "bg=$bg fg=$fg"

set status-left-style "fg=$tert"
set status-left "#[fg=$tert]${session}"

set status-right-style "fg=$prims"
set status-right "$widgets$date_time$user"

setw window-status-current-style "fg=$bac bg=$prims"
setw window-status-current-format " #I:#W#F "

setw window-status-style "fg=$prims"
setw window-status-format " #I#[fg=$fg]:#W#[fg=$secos]#F "

setw window-status-bell-style "fg=$bac bg=$secos bold"

set message-style "fg=$bac bg=$secos bold"

setw clock-mode-colour "$prims"
setw mode-style "fg=$bac bg=$prims bold"
