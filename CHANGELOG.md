# Changelog

## Unreleased

### Added
- `CLAUDE.md`: how to work on this repo with Claude Code
- CI runs `make check` on every PR, in an Arch container (current tmux; Ubuntu's 3.4 can't load the config)

### Fixed
- Plugins (resurrect, continuum, extrakto) were never installed or loaded: tpm reads the plugin list from
  the text of `tmux.conf` and couldn't follow `source-file -F`. The list now lives in `tmux.conf`, and missing
  plugins are installed on every start (in the background), not only when tpm itself is missing
- README and `make deps` said tmux 3.4+; the config needs 3.5+ (`extended-keys-format`)

### Changed
- Saved sessions no longer include the text on screen (`@resurrect-capture-pane-contents off`): it would put
  printed secrets on disk, unencrypted, every 15 min
