# Emacs Configuration

Personal Emacs configuration using [straight.el](https://github.com/radian-software/straight.el) for package management.

## Requirements

- Emacs 29+
- Git

## Installation

```bash
git clone <repo-url> ~/.emacs.d
```

Packages are installed automatically on first launch.

## Terminal Emacs

This config is meant to run as `emacs -nw`. GUI Emacs.app still works; NS-only
settings (Command-as-Meta, exec-path-from-shell) stay behind `display-graphic-p`.

```bash
emacs -nw
# or, with the shell wrapper: `emacs` (TTY) / `emacs --gui` (window)
```

Ghostty already sends left Option as Alt, so Meta chords work. Tmux needs
24-bit color (`terminal-features RGB`) or zenburn falls back to 256-color.

TTY-safe keys (the GUI chords are kept; terminals often never send them):

| Command | GUI | Terminal |
| --- | --- | --- |
| expand-region | `C-=` | `C-c =` |
| mc/edit-lines | `C-S-c C-S-c` | `C-c m e` |
| mc/mark-next-like-this | `C->` | `C-c m n` |
| mc/mark-previous-like-this | `C-<` | `C-c m p` |
| mc/mark-all-like-this | `C-c C-<` | `C-c m a` |
| windmove | `S-<arrow>` | `C-c C-<arrow>` |
| git-link | `C-M-'` / `C-M-;` | `C-c g l` / `C-c g h` |

## Package Management

This config bootstraps `straight.el` in `settings/setup-straight.el` and enables `use-package` integration by default.

Most packages live in `settings/default-packages.el`. The usual workflow is:

1. Add or edit a `use-package` form in `settings/default-packages.el` or another file under `settings/`.
2. Restart Emacs, or run `M-x eval-buffer` on the file you changed.
3. Let `straight.el` clone and build the package on first load.

For quick one-off installs from inside Emacs:

- `M-x straight-use-package RET package-name RET`

Useful `straight.el` commands:

- `M-x straight-check-all` to see package status.
- `M-x straight-pull-package RET package-name RET` to update one package repo.
- `M-x straight-pull-all` to update every package repo.
- `M-x straight-rebuild-package RET package-name RET` to rebuild one package after an update.
- `M-x straight-rebuild-all` to rebuild everything if compiled artifacts get out of sync.
- `M-x straight-prune-build` to remove stale build artifacts.
- `M-x straight-prune-all` to remove unused repositories and build output.

## Upgrading Packages

For routine upgrades:

1. Run `M-x straight-pull-all`.
2. Run `M-x straight-rebuild-all` if a package fails to load, native compilation changes, or APIs moved.
3. Restart Emacs.
4. Run `make lint` from `~/.emacs.d` before committing config changes.

For a targeted package upgrade:

1. Run `M-x straight-pull-package RET package-name RET`.
2. Run `M-x straight-rebuild-package RET package-name RET`.
3. Restart Emacs and confirm the affected workflow still works.

If an updated package breaks, use `git log` inside `straight/repos/<package>` to inspect what changed, or temporarily pin/revert that repo until the config is updated.

## Version Locking

This repo does not currently track a `versions/default.el` lockfile. That keeps updates simple, but it also means fresh clones follow the latest upstream package revisions.

If you want reproducible package versions later:

1. Run `M-x straight-freeze-versions`.
2. Commit `versions/default.el`.
3. Run `M-x straight-thaw-versions` on another machine after cloning.

## Key Packages

- **Completion**: Ivy, Counsel, Swiper
- **Project**: Projectile
- **Editing**: Smartparens, Expand-region, Multiple-cursors
- **Git**: Git-link
- **Theme**: Zenburn

## Development

```bash
make lint    # Byte-compile all tracked .el files
make clean   # Remove .elc files
```

## License

MIT
