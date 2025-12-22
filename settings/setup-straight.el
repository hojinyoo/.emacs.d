;;; setup-straight.el --- Bootstrap straight.el package manager -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This file bootstraps straight.el, a next-generation package manager for Emacs.
;; It also configures use-package integration.
;;
;; Reference: https://github.com/radian-software/straight.el

;;; Code:

(defvar bootstrap-version nil
  "Version number for straight.el bootstrap.")

(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package via straight.el
(straight-use-package 'use-package)

;; Make use-package use straight.el by default
(setq straight-use-package-by-default t)

(provide 'setup-straight)
;;; setup-straight.el ends here
