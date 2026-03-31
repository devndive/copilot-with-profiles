PREFIX      ?= $(HOME)/.local
BINDIR      ?= $(PREFIX)/bin
CONFIG_BASE ?= $(or $(XDG_CONFIG_HOME),$(HOME)/.config)/copilot-with-profiles
PROFILES_DIR = $(CONFIG_BASE)/profiles
SRC          = $(CURDIR)/cwp

.PHONY: install uninstall help

help: ## Show this help
	@echo "cwp — Copilot With Profiles"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-z_-]+:.*##' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  make %-12s %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX       Install prefix      (default: ~/.local)"
	@echo "  BINDIR       Binary directory     (default: PREFIX/bin)"
	@echo ""
	@echo "Examples:"
	@echo "  make install                      # Install to ~/.local/bin"
	@echo "  make install PREFIX=/usr/local    # Install to /usr/local/bin (needs sudo)"
	@echo "  make uninstall                    # Remove cwp"

install: $(SRC) ## Install cwp and create config directories
	chmod +x $(SRC)
	mkdir -p $(BINDIR)
	ln -sf $(SRC) $(BINDIR)/cwp
	mkdir -p $(PROFILES_DIR)
	@echo ""
	@echo "✓ Installed cwp to $(BINDIR)/cwp"
	@echo "✓ Created config directory at $(PROFILES_DIR)/"
	@echo ""
	@echo "Get started:"
	@echo "  cwp init my-profile"
	@echo "  echo 'profile = \"my-profile\"' > .copilot-profile"
	@echo "  cwp"

uninstall: ## Remove cwp symlink
	rm -f $(BINDIR)/cwp
	@echo "✓ Removed $(BINDIR)/cwp"
