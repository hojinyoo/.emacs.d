;;; setup-tty.el --- Terminal (TTY) Emacs settings -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Make Emacs usable in a terminal. Safe to load in GUI sessions; TTY-only
;; bits run on non-graphic frames (including emacsclient -t under a daemon).

;;; Code:

(defvar xclip-method)
(declare-function xclip-mode "xclip" (&optional arg))

(defun setup-tty-frame (&optional frame)
  "Apply TTY settings to FRAME, or the selected frame."
  (with-selected-frame (or frame (selected-frame))
    (unless (or (display-graphic-p) noninteractive)
      (when (fboundp 'menu-bar-mode)
        (menu-bar-mode -1))
      (xterm-mouse-mode 1)
      ;; Dark default so theme faces pick TTY variants before truecolor kicks in.
      (setq frame-background-mode 'dark)
      (set-terminal-parameter nil 'background-mode 'dark))))

(add-hook 'tty-setup-hook #'setup-tty-frame)
(add-hook 'after-make-frame-functions #'setup-tty-frame)
(add-hook 'window-setup-hook #'setup-tty-frame)

;;;; Clipboard

;; GUI Emacs talks to the pasteboard by itself. A TTY needs a helper:
;; pbcopy on macOS, wl-copy/xclip on Linux, OSC 52 over SSH (tmux already
;; has set-clipboard on).
(use-package xclip
  :config
  (defun setup-tty--enable-clipboard ()
    "Enable `xclip-mode' on TTY frames."
    (unless (or (display-graphic-p) noninteractive)
      (unless (memq xclip-method '(pbpaste wl-copy xclip xsel powershell))
        (setq xclip-method 'osc52))
      (xclip-mode 1)))
  (add-hook 'tty-setup-hook #'setup-tty--enable-clipboard)
  (setup-tty--enable-clipboard))

(provide 'setup-tty)
;;; setup-tty.el ends here
