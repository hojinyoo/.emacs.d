;;; setup-mac.el --- macOS-specific settings -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Configuration specific to macOS.
;; This file should only be loaded on macOS systems.

;;; Code:

;; Silence byte-compiler warnings
(defvar ispell-program-name)
(declare-function exec-path-from-shell-initialize "exec-path-from-shell" ())

;;;; Modifier Keys

;; NS/macOS GUI only. In a terminal, Meta comes from the emulator
;; (Ghostty: left Option as Alt) and Command is not an Emacs modifier.
(when (display-graphic-p)
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta)
  (setq ns-function-modifier 'hyper)
  ;; Don't open files from Finder in a new frame
  (setq ns-pop-up-frames nil))

;;;; Environment Variables

;; GUI Emacs.app does not inherit the shell PATH. `emacs -nw` already does.
(when (display-graphic-p)
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

;; Use macOS trash
(setq trash-directory "~/.Trash/emacs")

;;;; Spell Checking

;; Use aspell for spell checking (brew install aspell)
(when-let* ((aspell-path (or (executable-find "aspell")
                             (and (file-exists-p "/opt/homebrew/bin/aspell")
                                  "/opt/homebrew/bin/aspell")
                             (and (file-exists-p "/usr/local/bin/aspell")
                                  "/usr/local/bin/aspell"))))
  (setq ispell-program-name aspell-path))

;;;; Utility Functions

(defun mac-open-current-file ()
  "Open the current file with macOS `open` command."
  (interactive)
  (if buffer-file-name
      (shell-command (concat "open " (shell-quote-argument buffer-file-name)))
    (user-error "Buffer is not visiting a file")))

(global-set-key (kbd "C-c C-S-o") #'mac-open-current-file)

(defun mac-reveal-in-finder ()
  "Reveal the current file in Finder."
  (interactive)
  (if buffer-file-name
      (shell-command (concat "open -R " (shell-quote-argument buffer-file-name)))
    (user-error "Buffer is not visiting a file")))

(global-set-key (kbd "C-c C-S-r") #'mac-reveal-in-finder)

(provide 'setup-mac)
;;; setup-mac.el ends here
