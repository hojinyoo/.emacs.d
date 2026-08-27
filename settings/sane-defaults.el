;;; sane-defaults.el --- Sensible default settings -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Sensible default behaviors for Emacs.
;; These are general settings that don't belong to any specific package.

;;; Code:

;;;; Clipboard & Selection

;; Allow pasting selection outside of Emacs
(setq select-enable-clipboard t)

;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Show active region
(transient-mark-mode 1)

;; Don't use shift to mark things
(setq shift-select-mode nil)

;;;; Bell & Notifications

;; Blink the modeline instead of audible bell
(setq visible-bell nil)
(setq ring-bell-function
      (lambda ()
        (invert-face 'mode-line)
        (run-with-timer 0.05 nil #'invert-face 'mode-line)))

;;;; Encoding

;; UTF-8 everywhere
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;;; File Handling

;; Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))

;; Transparently open compressed files
(auto-compression-mode 1)

;; Auto refresh buffers when files change on disk
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Offer to create parent directories if they do not exist
(defun sane-defaults--create-non-existent-directory ()
  "Create parent directory if it doesn't exist when visiting a new file."
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
               (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
      (make-directory parent-directory t))))

(add-to-list 'find-file-not-found-functions #'sane-defaults--create-non-existent-directory)

;;;; Editing Behavior

;; Never insert tabs
(setq-default indent-tabs-mode nil)

;; Lines should be 80 characters wide
(setq fill-column 80)

;; Sentences do not need double spaces to end
(setq-default sentence-end-double-space nil)

;; Easily navigate camelCase words
(global-subword-mode 1)

;; Wrap long lines at word boundaries instead of truncating them
(setq-default truncate-lines nil)

;; Allow recursive minibuffers
(setq enable-recursive-minibuffers t)

;; No electric indent
(setq electric-indent-mode nil)

;; Show me empty lines after buffer end
(setq-default indicate-empty-lines t)

;; Enable syntax highlighting
(global-font-lock-mode 1)

;;;; Display & UI

;; Show keystrokes in progress
(setq echo-keystrokes 0.1)

;; Always display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; Wrap long lines visually in all text buffers by default
(global-visual-line-mode 1)

;; Toggle visual line wrapping for the current buffer
(global-set-key (kbd "C-c w") #'visual-line-mode)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;;;; History & Persistence

;; Save recent files list
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Save minibuffer history
(savehist-mode 1)
(setq history-length 1000)

;; Save cursor position in files
(save-place-mode 1)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Don't save desktop (window layout)
(desktop-save-mode 0)

;;;; Buffer Management

;; Unique buffer names using directory
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Window configuration undo/redo
(winner-mode 1)

;; Navigate windows with Shift+Arrow (GUI). Terminals often swallow that
;; chord, so C-c C-<arrow> is the TTY-safe equivalent.
(windmove-default-keybindings)
(global-set-key (kbd "C-c C-<left>")  #'windmove-left)
(global-set-key (kbd "C-c C-<right>") #'windmove-right)
(global-set-key (kbd "C-c C-<up>")    #'windmove-up)
(global-set-key (kbd "C-c C-<down>")  #'windmove-down)

;;;; Diff & Ediff

(declare-function ediff-setup-windows-plain "ediff-wind" (&rest _))

(setq ediff-diff-options "-w")
(setq ediff-split-window-function #'split-window-horizontally)
(setq ediff-window-setup-function #'ediff-setup-windows-plain)

;; Make diff-mode buffers read-only
(add-hook 'diff-mode-hook #'read-only-mode)

;;;; Memory & Performance

;; Increase GC threshold for better performance
(setq gc-cons-threshold 20000000)

;;;; Evaluation

;; Show full results in eval-expression
(setq eval-expression-print-level nil)

;;;; Mark Navigation

;; When popping the mark, continue popping until the cursor actually moves
(define-advice pop-to-mark-command (:around (orig-fn) ensure-new-position)
  "Continue popping mark until cursor moves or limit reached."
  (let ((p (point)))
    (when (eq last-command 'save-region-or-current-line)
      (funcall orig-fn)
      (funcall orig-fn)
      (funcall orig-fn))
    (dotimes (_ 10)
      (when (= p (point))
        (funcall orig-fn)))))

(setq set-mark-command-repeat-pop t)

(provide 'sane-defaults)
;;; sane-defaults.el ends here
