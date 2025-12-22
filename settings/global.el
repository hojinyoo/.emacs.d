;;; global.el --- Global settings for all environments -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; General Emacs settings that apply across all modes and environments.

;;; Code:

;; Platform detection
(defvar is-mac (eq system-type 'darwin)
  "Non-nil if running on macOS.")

;; Backup settings
(setq vc-make-backup-files t)  ; Make backups even for version-controlled files

;; Display settings
(setq font-lock-maximum-decoration t)
(setq truncate-partial-width-windows nil)

;; Highlight current line
(global-hl-line-mode 1)

;; Highlight matching parentheses
(show-paren-mode 1)

;; Window system specific settings
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(provide 'global)
;;; global.el ends here
