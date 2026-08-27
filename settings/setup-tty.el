;;; setup-tty.el --- Terminal (TTY) Emacs settings -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Make Emacs usable in a terminal. Safe to load in GUI sessions; TTY-only
;; bits run on non-graphic frames (including emacsclient -t under a daemon).

;;; Code:

(defvar xclip-method)
(defvar xclip-program)
(declare-function xclip-mode "xclip" (&optional arg))

(defun setup-tty--copy-keys ()
  "Map Super (Command in Ghostty) to clipboard commands on a TTY.
GUI Emacs used Command as Meta, so Command-W was `M-w' (copy). Ghostty
already unbinds super+w; super+c/v still belong to the terminal so
mouse-select + Cmd-C/V keep working."
  (global-set-key (kbd "s-w") #'clipboard-kill-ring-save)
  (global-set-key (kbd "s-x") #'clipboard-kill-region))

(defun setup-tty-frame (&optional frame)
  "Apply TTY settings to FRAME, or the selected frame."
  (with-selected-frame (or frame (selected-frame))
    (unless (or (display-graphic-p) noninteractive)
      (when (fboundp 'menu-bar-mode)
        (menu-bar-mode -1))
      ;; Do not enable `xterm-mouse-mode': it steals drag-select from the
      ;; terminal, so Cmd-C copies nothing. Toggle with M-x xterm-mouse-mode.
      ;; Dark default so theme faces pick TTY variants before truecolor kicks in.
      (setq frame-background-mode 'dark)
      (set-terminal-parameter nil 'background-mode 'dark)
      (setup-tty--copy-keys))))

(add-hook 'tty-setup-hook #'setup-tty-frame)
(add-hook 'after-make-frame-functions #'setup-tty-frame)
(add-hook 'window-setup-hook #'setup-tty-frame)

;;;; Clipboard

;; GUI Emacs talks to the pasteboard by itself. A TTY needs a helper:
;; pbcopy on macOS, wl-copy/xclip on Linux. This xclip build has no OSC 52.
(use-package xclip
  :config
  (defun setup-tty--enable-clipboard ()
    "Enable `xclip-mode' on TTY frames."
    (unless (or (display-graphic-p) noninteractive)
      (setq xclip-method
            (cond ((eq system-type 'darwin) 'pbpaste)
                  ((executable-find "wl-copy") 'wl-copy)
                  ((executable-find "xclip") 'xclip)
                  ((executable-find "xsel") 'xsel)
                  (xclip-method)))
      (setq xclip-program (pcase xclip-method
                            ('pbpaste "pbpaste")
                            ('wl-copy "wl-copy")
                            ('xclip "xclip")
                            ('xsel "xsel")
                            (method (symbol-name method))))
      (xclip-mode 1)))
  (add-hook 'tty-setup-hook #'setup-tty--enable-clipboard)
  (setup-tty--enable-clipboard))

(provide 'setup-tty)
;;; setup-tty.el ends here
