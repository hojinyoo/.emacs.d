;;; setting-misc.el --- misc settings
;;; Commentary:
;;; Code:

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(global-set-key (kbd "C-;") 'switch-to-prev-buffer)

;; (set-default-font "Source Code Pro" nil t)
;; (set-face-attribute 'default nil :height 125)

(use-package wgrep)
(use-package git-link)

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config
  (setq dumb-jump-selector 'ivy)
  (setq dumb-jump-aggressive nil))


;; from https://www.emacswiki.org/emacs/DropBox
;; avoid to temporary files in Dropbox directiory
(add-to-list 'auto-save-file-name-transforms '("\\`.*/Dropbox/.*" "~/.emacs/backups" t))
(add-to-list 'backup-directory-alist '("\\`.*/Dropbox/.*" . "~/.emacs/backups"))

(use-package rjsx-mode)
;;; setting-misc.el ends here
