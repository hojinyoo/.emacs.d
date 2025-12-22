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
