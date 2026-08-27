;;; init.el --- Emacs configuration entry point -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This is the main entry point for Emacs configuration.

;;; Code:

;; Set path to dependencies
(defvar site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory) "Directory for manually maintained packages.")
(defvar settings-dir (expand-file-name "settings" user-emacs-directory) "Directory for package specific settings.")

;; Set up load path
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)

;; Set up the package manager (straight.el)
(require 'setup-straight)

(require 'sane-defaults)
(require 'global)
(require 'default-packages)

;; Platform-specific settings
(when is-mac
  (require 'setup-mac))

;; TTY + GUI: self-guards so emacs -nw and Emacs.app share this config
(require 'setup-tty)

(when (and (boundp 'custom-file) (file-exists-p custom-file))
  (load custom-file nil 'nomessage))

(provide 'init)
;;; init.el ends here
