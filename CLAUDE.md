# tmux

My tmux config (Mac + Arch) and `tms`, the project session picker. `~/.config/tmux` is a symlink to this repo,
so the checked-out branch is the config the next tmux server loads. Keys and features: `README.md`.

## Commands
- `make check`: `bash -n` on the scripts, then loads the config in a throwaway server (`-L`); fails on any
  output. Skips `conf/plugins.conf` (no network), so it can't catch plugin problems.
- Full test, plugins included (uses the real plugin dir):
  `tmux -L test -f /dev/null new-session -d \; source-file "$PWD/tmux.conf"; tmux -L test list-keys | grep -E 'resurrect|extrakto'; tmux -L test kill-server`
- `make status`: links + tmux version. `make reload`: re-source in the running server.

## Layout
- `tmux.conf`: sources `conf/*.conf` by path relative to itself (`source-file -F '#{d:current_file}/…'`),
  and holds the `@plugin` list.
- `conf/options.conf` behaviour · `conf/keys.conf` bindings + the prefix-Space menu · `conf/theme.conf` look
  (palette in its header) · `conf/plugins.conf` plugin settings, tpm bootstrap.
- `bin/tms`: session picker (fzf over open sessions, zoxide, `~/projects`), also linked to `~/.local/bin/tms`.
- Plugins and saved sessions live outside the repo: `~/.local/share/tmux/{plugins,resurrect}`.

## Conventions
- The `@plugin` lines stay in `tmux.conf`: tpm finds plugins by reading that file's text and can't follow
  `source-file -F`. A plugin listed elsewhere is silently never installed or loaded.
- Needs tmux 3.5+ (`extended-keys-format`). GitHub's Ubuntu runners have 3.4, hence no CI.
- Alt-h/j/k/l and Alt-Shift-h/j/k/l are shared with nvim's smart-splits (`@pane-is-vim`); change both repos
  together. Before binding a key, check `conf/keys.conf`, nvim (`~/projects/nvim/CLAUDE.md`) and Ghostty.
  Alt-c/t/p/n are taken from zsh on purpose.
- Look: one cyan accent `#00e5ff`, transparent backgrounds, rounded popups; reuse the palette in `theme.conf`.
- Keep `@resurrect-capture-pane-contents` off: screen text would put printed secrets on disk.
- Changes go through `github-flow` (squash only). After pushing a branch, switch back to `main`; after a
  merge, `git pull` and `make reload` (or prefix r), and remind me to pull on the other machine.
- Ask before `make install`, `make deps`, `make link`/`unlink`, `make clean`.
