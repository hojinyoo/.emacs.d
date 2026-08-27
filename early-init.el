;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This file is loaded before init.el.

;;; Code:

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

;; Suppress obsolete warnings from external packages not yet updated for Emacs 31
;; (when-let, if-let -> when-let*, if-let*)
(setq byte-compile-warnings '(not obsolete))

;; Suppress runtime warnings from external packages (declare vars for byte-compiler)
(defvar warning-suppress-log-types)
(defvar warning-suppress-types)
(setq warning-suppress-log-types '((obsolete)))
(setq warning-suppress-types '((obsolete)))

;; Prevent flash of unstyled UI elements by disabling them early
(setq inhibit-startup-message t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; TTY menu bar costs a whole screen line; off in GUI too.
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))

;; Disable cursor blinking
(blink-cursor-mode -1)

(provide 'early-init)
;;; early-init.el ends here
