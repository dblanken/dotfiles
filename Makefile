.PHONY: help install update stow-all unstow-all restow-all clean
.PHONY: stow-% unstow-% restow-%
.PHONY: stow-core stow-optional stow-linux
.PHONY: validate check-platform install-linux-extras

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

# Dotfiles directory
DOTFILES := $(HOME)/.dotfiles

# Core packages
CORE_PACKAGES := zsh git tmux scripts

# Linux-specific packages
LINUX_PACKAGES := autostart mise


# Optional packages
OPTIONAL_PACKAGES := alacritty lazyvim hammerspoon karabiner

# All packages
ALL_PACKAGES := $(CORE_PACKAGES) $(LINUX_PACKAGES) $(OPTIONAL_PACKAGES) nvim vim asdf

help: ## Show this help message
	@echo "$(BLUE)Dotfiles Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Package-specific targets:$(NC)"
	@echo "  $(BLUE)stow-<package>$(NC)       Stow a specific package"
	@echo "  $(BLUE)unstow-<package>$(NC)     Unstow a specific package"
	@echo "  $(BLUE)restow-<package>$(NC)     Restow a specific package"
	@echo ""
	@echo "$(GREEN)Available packages:$(NC)"
	@echo "  Core:     $(CORE_PACKAGES)"
	@echo "  Linux:    $(LINUX_PACKAGES)"
	@echo "  Optional: $(OPTIONAL_PACKAGES)"
	@echo "  Other:    nvim vim asdf"

install: ## Run the interactive installation script
	@./install.sh

update: ## Update git submodules (zsh plugins)
	@echo "$(BLUE)==>$(NC) Updating git submodules..."
	@git submodule update --remote --recursive
	@echo "$(GREEN)✓$(NC) Submodules updated"
	@echo "$(YELLOW)⚠$(NC) Remember to commit changes if desired"

stow-all: ## Stow all packages
	@echo "$(BLUE)==>$(NC) Stowing all packages..."
	@for package in $(ALL_PACKAGES); do \
		if [ -d "$$package" ]; then \
			echo "  Stowing $$package..."; \
			stow -d $(DOTFILES) -t $(HOME) $$package 2>/dev/null || \
				echo "$(YELLOW)⚠$(NC) Conflict stowing $$package (use restow-$$package to force)"; \
		fi \
	done
	@echo "$(GREEN)✓$(NC) Done"

unstow-all: ## Unstow all packages
	@echo "$(BLUE)==>$(NC) Unstowing all packages..."
	@for package in $(ALL_PACKAGES); do \
		if [ -d "$$package" ]; then \
			echo "  Unstowing $$package..."; \
			stow -D -d $(DOTFILES) -t $(HOME) $$package 2>/dev/null || true; \
		fi \
	done
	@echo "$(GREEN)✓$(NC) Done"

restow-all: ## Restow all packages (unstow then stow)
	@echo "$(BLUE)==>$(NC) Restowing all packages..."
	@for package in $(ALL_PACKAGES); do \
		if [ -d "$$package" ]; then \
			echo "  Restowing $$package..."; \
			stow -R -d $(DOTFILES) -t $(HOME) $$package 2>/dev/null || \
				echo "$(YELLOW)⚠$(NC) Failed to restow $$package"; \
		fi \
	done
	@echo "$(GREEN)✓$(NC) Done"

stow-core: ## Stow core packages (zsh, git, tmux, scripts)
	@echo "$(BLUE)==>$(NC) Stowing core packages..."
	@for package in $(CORE_PACKAGES); do \
		echo "  Stowing $$package..."; \
		stow -d $(DOTFILES) -t $(HOME) $$package || \
			echo "$(YELLOW)⚠$(NC) Conflict stowing $$package"; \
	done
	@echo "$(GREEN)✓$(NC) Core packages stowed"

stow-optional: ## Stow optional packages (alacritty, lazyvim, etc.)
	@echo "$(BLUE)==>$(NC) Stowing optional packages..."
	@for package in $(OPTIONAL_PACKAGES); do \
		echo "  Stowing $$package..."; \
		stow -d $(DOTFILES) -t $(HOME) $$package 2>/dev/null || \
			echo "$(YELLOW)⚠$(NC) Conflict stowing $$package"; \
	done
	@echo "$(GREEN)✓$(NC) Optional packages stowed"

stow-linux: ## Stow Linux-specific packages (autostart, mise)
	@echo "$(BLUE)==>$(NC) Stowing Linux-specific packages..."
	@for package in $(LINUX_PACKAGES); do \
		echo "  Stowing $$package..."; \
		stow -d $(DOTFILES) -t $(HOME) $$package 2>/dev/null || \
			echo "$(YELLOW)⚠$(NC) Conflict stowing $$package"; \
	done
	@echo "$(GREEN)✓$(NC) Linux packages stowed"


stow-%: ## Stow a specific package
	@if [ -d "$*" ]; then \
		echo "$(BLUE)==>$(NC) Stowing $*..."; \
		stow -d $(DOTFILES) -t $(HOME) $* && \
			echo "$(GREEN)✓$(NC) Stowed $*" || \
			echo "$(YELLOW)⚠$(NC) Failed to stow $* (conflicts exist, use restow-$* to force)"; \
	else \
		echo "$(YELLOW)⚠$(NC) Package $* does not exist"; \
		exit 1; \
	fi

unstow-%: ## Unstow a specific package
	@if [ -d "$*" ]; then \
		echo "$(BLUE)==>$(NC) Unstowing $*..."; \
		stow -D -d $(DOTFILES) -t $(HOME) $* && \
			echo "$(GREEN)✓$(NC) Unstowed $*" || \
			echo "$(YELLOW)⚠$(NC) Failed to unstow $*"; \
	else \
		echo "$(YELLOW)⚠$(NC) Package $* does not exist"; \
		exit 1; \
	fi

restow-%: ## Restow a specific package (unstow then stow)
	@if [ -d "$*" ]; then \
		echo "$(BLUE)==>$(NC) Restowing $*..."; \
		stow -R -d $(DOTFILES) -t $(HOME) $* && \
			echo "$(GREEN)✓$(NC) Restowed $*" || \
			echo "$(YELLOW)⚠$(NC) Failed to restow $*"; \
	else \
		echo "$(YELLOW)⚠$(NC) Package $* does not exist"; \
		exit 1; \
	fi

clean: ## Remove broken symlinks in home directory
	@echo "$(BLUE)==>$(NC) Finding broken symlinks in ~..."
	@find $(HOME) -maxdepth 1 -type l ! -exec test -e {} \; -print 2>/dev/null | while read link; do \
		if [ -L "$$link" ]; then \
			target=$$(readlink "$$link"); \
			if echo "$$target" | grep -q ".dotfiles"; then \
				echo "  Removing broken link: $$link -> $$target"; \
				rm "$$link"; \
			fi \
		fi \
	done
	@echo "$(GREEN)✓$(NC) Cleanup complete"

status: ## Show stow package status
	@echo "$(BLUE)==>$(NC) Checking package status..."
	@echo ""
	@for package in $(ALL_PACKAGES); do \
		if [ -d "$$package" ]; then \
			echo -n "  $$package: "; \
			if stow -n -d $(DOTFILES) -t $(HOME) $$package 2>&1 | grep -q "already exists"; then \
				echo "$(GREEN)stowed$(NC)"; \
			else \
				echo "$(YELLOW)not stowed$(NC)"; \
			fi \
		fi \
	done

check: ## Check for prerequisites
	@echo "$(BLUE)==>$(NC) Checking prerequisites..."
	@command -v stow >/dev/null 2>&1 && echo "$(GREEN)✓$(NC) GNU Stow installed" || \
		echo "$(YELLOW)✗$(NC) GNU Stow not installed (brew install stow)"
	@command -v git >/dev/null 2>&1 && echo "$(GREEN)✓$(NC) Git installed" || \
		echo "$(YELLOW)✗$(NC) Git not installed"
	@[ -d "$(DOTFILES)/.git" ] && echo "$(GREEN)✓$(NC) In git repository" || \
		echo "$(YELLOW)✗$(NC) Not a git repository"
	@git submodule status 2>/dev/null | grep -q "^-" && \
		echo "$(YELLOW)⚠$(NC) Submodules not initialized (run: make update)" || \
		echo "$(GREEN)✓$(NC) Submodules initialized"

validate: ## Run comprehensive dotfiles health check
	@if [ -x "$(HOME)/.local/bin/dotfiles-check" ]; then \
		$(HOME)/.local/bin/dotfiles-check; \
	elif [ -x "scripts/.local/bin/dotfiles-check" ]; then \
		scripts/.local/bin/dotfiles-check; \
	else \
		echo "$(YELLOW)✗$(NC) dotfiles-check script not found"; \
		echo "$(BLUE)ℹ$(NC) Run: make stow-scripts"; \
		exit 1; \
	fi

check-platform: ## Display platform and environment information
	@echo "$(BLUE)==>$(NC) Platform Information"
	@echo ""
	@echo "  OS Type: $$(uname -s)"
	@echo "  Kernel Version: $$(uname -r)"
	@echo "  Machine Architecture: $$(uname -m)"
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		echo "  macOS Version: $$(sw_vers -productVersion 2>/dev/null || echo 'Unknown')"; \
		echo "  Homebrew: $$(command -v brew >/dev/null && echo 'installed' || echo 'not installed')"; \
	elif [ "$$(uname -s)" = "Linux" ]; then \
		if [ -f /etc/os-release ]; then \
			. /etc/os-release; \
			echo "  Distribution: $$NAME $$VERSION_ID"; \
			echo "  ID: $$ID"; \
		fi; \
		echo "  apt: $$(command -v apt >/dev/null && echo 'available' || echo 'not available')"; \
	fi
	@echo ""
	@echo "$(BLUE)==>$(NC) Dotfiles Environment"
	@echo ""
	@echo "  Dotfiles Directory: $(DOTFILES)"
	@echo "  Git Repository: $$([ -d $(DOTFILES)/.git ] && echo 'yes' || echo 'no')"
	@echo "  Stowed Packages: $$(for p in $(ALL_PACKAGES); do [ -L $(HOME)/.$$p ] || [ -L $(HOME)/.config/$$p ] && echo -n "$$p "; done)"

install-linux-extras: ## Install Linux-specific packages requiring manual installation
	@if [ "$$(uname -s)" != "Linux" ]; then \
		echo "$(YELLOW)⚠$(NC) This target is for Linux only"; \
		echo "$(BLUE)ℹ$(NC) Use 'brew bundle' on macOS"; \
		exit 1; \
	fi
	@if [ -x "$(DOTFILES)/install-linux-extras.sh" ]; then \
		$(DOTFILES)/install-linux-extras.sh --all; \
	else \
		echo "$(YELLOW)✗$(NC) install-linux-extras.sh not found or not executable"; \
		exit 1; \
	fi
