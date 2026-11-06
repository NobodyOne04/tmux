# tmux config — run `make help`.

SHELL   := /bin/bash
.DEFAULT_GOAL := help
PLUGINS := $(HOME)/.local/share/tmux/plugins

.PHONY: help install deps link unlink status check reload update clean

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: deps link ## Packages + link + plugins (then start tmux)
	@$(MAKE) --no-print-directory update

deps: ## Install tmux and what the config uses (fzf, zoxide, lazygit, btop, python3 for extrakto)
	@if [ "$$(uname)" = Darwin ]; then \
		command -v brew >/dev/null || { echo "Homebrew is required"; exit 1; }; \
		brew install tmux fzf zoxide lazygit btop eza python3; \
	elif command -v pacman >/dev/null; then \
		sudo pacman -S --needed tmux fzf zoxide lazygit btop eza python git; \
	else echo "install yourself: tmux (3.4+) fzf zoxide lazygit btop eza python3"; fi

link: ## Link ~/.config/tmux and ~/.local/bin/tms (old files backed up)
	@./scripts/link.sh link

unlink: ## Remove the links and restore the newest backups
	@./scripts/link.sh unlink

status: ## Show the links and the tmux version
	@./scripts/link.sh status
	@echo "  $$(tmux -V)"

check: ## Load the config in a throwaway tmux server; fail on any error
	@bash -n bin/tms && bash -n scripts/link.sh
	@sock=tmux-check-$$$$; \
	out=$$(TMUX_CONFIG_CHECK=1 tmux -L $$sock -f /dev/null new-session -d \; source-file "$(CURDIR)/tmux.conf" 2>&1); rc=$$?; \
	tmux -L $$sock kill-server 2>/dev/null; \
	if [ $$rc -ne 0 ] || [ -n "$$out" ]; then echo "$$out"; exit 1; fi; echo "ok: config loads cleanly ($$(tmux -V))"

reload: ## Reload the config in the running tmux
	tmux source-file ~/.config/tmux/tmux.conf && tmux display '› config reloaded'

update: ## Install missing plugins and update all of them
	@[ -d "$(PLUGINS)/tpm" ] || git clone --depth=1 -q https://github.com/tmux-plugins/tpm "$(PLUGINS)/tpm"
	@TMUX_PLUGIN_MANAGER_PATH="$(PLUGINS)" "$(PLUGINS)/tpm/bin/install_plugins"
	@TMUX_PLUGIN_MANAGER_PATH="$(PLUGINS)" "$(PLUGINS)/tpm/bin/update_plugins" all

clean: ## Remove downloaded plugins (re-installed on next start)
	rm -rf "$(PLUGINS)"
