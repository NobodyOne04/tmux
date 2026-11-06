#!/usr/bin/env bash
# link.sh link|unlink|status
#   ~/.config/tmux      -> this repo
#   ~/.local/bin/tms    -> bin/tms (the session picker, usable outside tmux)
# An existing file is moved to <file>.bak-<date>; `unlink` restores the newest.
# ~/.tmux.conf is moved away too: tmux reads it INSTEAD of ~/.config/tmux.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
cfg=${XDG_CONFIG_HOME:-$HOME/.config}
stamp=$(date +%Y%m%d-%H%M%S)

links=(
  ".         $cfg/tmux"
  "bin/tms   $HOME/.local/bin/tms"
)

short() { echo "${1/#$HOME/\~}"; }

target_of() { [[ $1 == . ]] && echo "$repo" || echo "$repo/$1"; }

do_link() {
  local src; src=$(target_of "$1"); local dst=$2
  if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then echo "  ok      $(short "$dst")"; return; fi
  mkdir -p "$(dirname "$dst")"
  if [[ -e $dst || -L $dst ]]; then mv "$dst" "$dst.bak-$stamp"; echo "  backup  $(short "$dst") -> $(short "$dst").bak-$stamp"; fi
  ln -s "$src" "$dst"; echo "  linked  $(short "$dst")"
}

do_unlink() {
  local src; src=$(target_of "$1"); local dst=$2 last
  [[ -L $dst && $(readlink "$dst") == "$src" ]] || return 0
  rm "$dst"
  last=$(ls -d "$dst".bak-* 2>/dev/null | sort | tail -1 || true)
  if [[ -n $last ]]; then mv "$last" "$dst"; echo "  restored $(short "$dst")"; else echo "  removed  $(short "$dst")"; fi
}

do_status() {
  local src; src=$(target_of "$1"); local dst=$2
  if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then echo "  ok      $(short "$dst")"
  else echo "  missing $(short "$dst")  (make link)"; fi
}

action=${1:?usage: link.sh link|unlink|status}

# ~/.tmux.conf would shadow ~/.config/tmux/tmux.conf
if [[ $action == link && ( -e $HOME/.tmux.conf || -L $HOME/.tmux.conf ) ]]; then
  mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak-$stamp"
  echo "  moved   ~/.tmux.conf -> ~/.tmux.conf.bak-$stamp (it would override this config)"
fi
if [[ $action == status && ( -e $HOME/.tmux.conf || -L $HOME/.tmux.conf ) ]]; then
  echo "  warning ~/.tmux.conf exists and overrides this config (make link moves it away)"
fi

for entry in "${links[@]}"; do
  read -r src dst <<<"$entry"
  "do_$action" "$src" "$dst"
done
