# tmux

tmux styled like the archminimal desktop (one cyan accent, transparent background), built to work together
with the [nvim](https://github.com/NobodyOne04/nvim) and [zsh](https://github.com/NobodyOne04/zsh) repos. Arch
Linux and macOS.

- **Alt + key for everything you do all day**, no prefix: move, split, zoom, switch windows and sessions.
- **One movement for nvim and tmux:** Alt-h/j/k/l crosses nvim splits and tmux panes without thinking about
  which is which (needs smart-splits.nvim, which the nvim repo has).
- **A session per project:** Alt-s, pick a project, you're in it; direnv loads its environment.
- **Popups:** lazygit, a scratch shell that keeps running, btop, a menu of every action.
- **Sessions survive reboots** (resurrect + continuum): windows, panes, folders and programs come back
  (not the text that was on screen: that would put printed secrets on disk).

## Install

```bash
git clone git@github.com:NobodyOne04/tmux.git ~/projects/tmux && cd ~/projects/tmux
make install     # tmux + tools, link ~/.config/tmux, install plugins
tmux             # or: tms   (pick a project straight from the shell)
```

`make link` moves an existing `~/.tmux.conf` to `~/.tmux.conf.bak-<date>`: tmux reads that file *instead of*
`~/.config/tmux/tmux.conf`. `make unlink` restores it. Plugins and saved sessions live in
`~/.local/share/tmux`, never in this repo.

macOS (Ghostty): Alt is the **left** Option key (`macos-option-as-alt = left`).

## Keys

No prefix needed:

| Keys | Action |
|---|---|
| `Alt-h/j/k/l` | move to the pane / nvim split on the left, below, above, right |
| `Alt-H/J/K/L` | resize (nvim splits too) |
| `Alt-\` / `Alt--` | split right / down, in the same folder |
| `Alt-z` | zoom the pane (toggle) |
| `Alt-c` | new window in the same folder |
| `Alt-1…9` / `Alt-n` / `Alt-p` | go to window 1…9 / next / previous |
| `Alt-s` | **sessions**: pick a project or an open session (`Ctrl-x` in the list kills one) |
| `Alt-g` | lazygit in a popup, in the pane's folder |
| `Alt-t` | scratch shell popup; `Alt-t` again hides it (it keeps running) |
| `Alt-v` | copy mode (scroll back) |

With the prefix (`Ctrl-b`):

| Keys | Action |
|---|---|
| `Space` | **menu** with everything (sessions, popups, layouts, sync, save/restore…) |
| `Tab` | extrakto: fuzzy-pick a path, URL or word from the screen, then copy or insert it |
| `\|` `\` `-` | split right / right / down |
| `s` | session tree |
| `S` | type into all panes at once (toggle; the session name turns red) |
| `<` `>` | move the window left / right |
| `b` / `K` | btop / k9s popup |
| `C-s` / `C-r` | save / restore sessions now (also automatic every 15 minutes, restored on start) |
| `C-l` | clear the screen and the scrollback |
| `X` | kill the session (asks first) |
| `r` | reload the config |

Copy mode (vi keys): `v` select, `C-v` block, `y` copy, `Y` copy the line, `H` / `L` line start / end, `/` `?`
search. Anything you copy, or select with the mouse, goes to the system clipboard through the terminal (OSC 52),
on macOS, Wayland and over ssh alike.

## Status bar

```text
 personal-ai │ 1 nvim  2 personal-ai  3 lazygit 󰊓         main │ personal-ai │ host │ 14:02
```

- **Left:** the session. Its colour shows the mode: cyan normally, **yellow** after the prefix, **purple** in copy
  mode, **red** while typing into all panes.
- **Windows:** number and program; when the program is the shell, the folder instead. `󰊓` zoomed, `󰂞` bell.
- **Right:** git branch of the active pane, its folder, host, time.
- On top, so it never meets nvim's status line at the bottom.

## Sessions: `tms`

`Alt-s` in tmux, or `tms` in any shell (it's linked into `~/.local/bin`):

- Lists open sessions (`●`, most recent first), then zoxide's frequent folders, then `~/projects/*`; the preview
  shows a session's screen or a folder's files.
- Picking a folder opens (or creates) a session named after it, starting in that folder, so direnv activates the
  project's `.env` and venv right away.
- `tms ~/some/dir` skips the picker. `TMS_PROJECTS=~/work tms` uses another projects folder.

## Layout

```text
tmux.conf            entry point (~/.config/tmux → this repo): loads conf/*
conf/options.conf    terminal features (true colour, undercurl, clipboard, extended keys, images), behaviour
conf/keys.conf       all key bindings and the menu
conf/theme.conf      status bar, borders, popups, menus
conf/plugins.conf    tpm, resurrect, continuum, extrakto (missing ones installed on every start)
bin/tms              the session picker
scripts/link.sh      link / unlink / status
```

## Makefile

| Target | What |
|---|---|
| `make install` | `deps` + `link` + `update` |
| `make deps` | tmux, fzf, zoxide, lazygit, btop, eza, python3 (brew or pacman) |
| `make link` / `unlink` / `status` | manage `~/.config/tmux` and `~/.local/bin/tms` |
| `make check` | load the config in a throwaway tmux server and fail on any error |
| `make reload` | reload the config in the running tmux |
| `make update` | install missing plugins, update all |
| `make clean` | delete the downloaded plugins (re-installed on next start) |

## Notes

- Needs tmux 3.5 or newer (`extended-keys-format`; also popup borders, `#{d:current_file}`). Ubuntu 24.04 ships
  3.4, which can't load this config.
- nvim inside tmux gets true colour, undercurl, `Esc` without delay, focus events (autoread) and images.
- The prefix stays `Ctrl-b`: `Ctrl-a` is zsh's beginning-of-line and `Ctrl-Space` is nvim completion; with the Alt
  keys you rarely need it. `Ctrl-h` / `Ctrl-l` stay nvim's side-scroll keys.
