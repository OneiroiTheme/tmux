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

case "$(get @oneiroi_palette "melatonin")" in
melatonin) palette="melatonin" ;;
dream | *) palette="dream" ;;
esac

tmux source "$current_dir/themes/oneiroi_${palette}_tmux.conf"

foreground=$(get @oneiroi_on_surface "white") #fg
case "$(get @oneiroi_background "normal")" in #bg
transparent) background="default" ;;
dark) background=$(get @oneiroi_surface "black") ;;
normal | *) background=$(get @oneiroi_surface_container "black") ;;
esac
surface=$(get @oneiroi_surface "black")

primary=$(get @oneiroi_primary "red")
secondary=$(get @oneiroi_secondary "red")
tertiary=$(get @oneiroi_tertiary "yellow")

session=$(get @oneiroi_session "[#S] ")
widgets=$(get @oneiroi_widgets)
date_time=$(get @oneiroi_datetime "%Y-%m-%d %H:%M ")
user=$(get @oneiroi_user "#[fg=$tertiary]│ #[fg=$primary]#(whoami) ")

set pane-border-style "fg=$primary"
set pane-active-border-style "fg=$tertiary"

set status-justify "left"
set status-left-length "10"
set status-right-length "50"
set status-right-attr "none"

set status-style "bg=$background fg=$foreground"

set status-left-style "fg=$tertiary"
set status-left "#[fg=$tertiary]${session}"

set status-right-style "fg=$secondary"
set status-right "$widgets$date_time$user"

setw window-status-current-style "fg=$surface bg=$primary"
setw window-status-current-format " #I:#W#F "

setw window-status-style "fg=$primary"
setw window-status-format " #I#[fg=$foreground]:#W#[fg=$tertiary]#F "

setw window-status-bell-style "fg=$surface bg=$tertiary bold"

set message-style "fg=$surface bg=$tertiary bold"

setw clock-mode-colour "$secondary"
setw mode-style "fg=$surface bg=$secondary bold"
