.PHONY: lint clean help

EMACS ?= emacs
EMACS_FLAGS = --batch --quick

# Directories to add to load-path
LOAD_PATH = -L settings -L site-lisp -L defuns

# All .el files tracked by git
GIT_EL_FILES = $(shell git ls-files '*.el')

# Temp directory for .elc files
TEMP_DIR := $(shell mktemp -d)

help:
	@echo "Emacs Configuration Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make lint   - Byte-compile all tracked .el files"
	@echo "  make clean  - Remove compiled .elc files"
	@echo ""

lint:
	@echo "Byte-compiling tracked .el files..."
	@echo "$(GIT_EL_FILES)" | tr ' ' '\n'
	@echo ""
	@$(EMACS) $(EMACS_FLAGS) \
		$(LOAD_PATH) \
		--eval "(setq byte-compile-dest-file-function (lambda (f) (expand-file-name (file-name-nondirectory (concat f \"c\")) \"$(TEMP_DIR)\")))" \
		-f batch-byte-compile \
		$(GIT_EL_FILES)
	@echo "✅ Lint passed!"

clean:
	@echo "Removing .elc files..."
	@find . -name "*.elc" -delete
	@echo "Done"
