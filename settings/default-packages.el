;;; default-packages.el --- Default package configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This file configures packages that are used across all environments.
;; Packages are installed via straight.el (configured in setup-straight.el).

;;; Code:

;;;; Completion Framework (Ivy/Counsel)

(use-package ivy
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel
  :diminish
  :after ivy
  :config
  (counsel-mode 1)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c C-r" . ivy-resume)))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper-backward)))

;;;; Project Management

(use-package projectile
  :diminish
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :after (counsel projectile)
  :config
  (counsel-projectile-mode 1))

;;;; Code Completion

(use-package company
  :diminish
  :config
  (global-company-mode 1)
  :bind (:map company-active-map
         ("TAB" . company-complete-common-or-cycle)
         ("<tab>" . company-complete-common-or-cycle)))

;;;; Editing Enhancements

(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :config
  (setq expand-region-fast-keys-enabled nil)
  (setq er--show-expansion-message t))

(use-package smartparens
  :diminish
  :config
  ;; Declare org-mode functions to suppress native-comp warnings
  (declare-function org-in-src-block-p "org" ())
  (declare-function org-element-at-point "org-element" ())
  (require 'smartparens-config)
  (smartparens-global-strict-mode 1)
  (sp-use-paredit-bindings))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package vundo
  :bind ("C-x u" . vundo)
  :config
  (setq vundo-compact-display t))

(use-package visual-regexp
  :after multiple-cursors
  :bind (("C-c q" . vr/query-replace)
         ("C-c r" . vr/replace)))

;;;; Syntax & Highlighting

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :diminish
  :hook (prog-mode . rainbow-mode))

(use-package highlight-escape-sequences
  :config
  (hes-mode 1)
  (put 'font-lock-regexp-grouping-backslash 'face-alias 'font-lock-builtin-face)
  (put 'hes-escape-backslash-face 'face-alias 'font-lock-builtin-face)
  (put 'hes-escape-sequence-face 'face-alias 'font-lock-builtin-face))

;;;; Snippets & Templates

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

;;;; Syntax Checking

(use-package flycheck
  :config
  (global-flycheck-mode 1))

;;;; Git Integration

(use-package git-link
  :bind (("C-M-;" . git-link-homepage)
         ("C-M-'" . git-link))
  :config
  (setq git-link-open-in-browser t))

;;;; Help & Discovery

(use-package which-key
  :diminish
  :config
  (which-key-mode 1))

;;;; Shell Integration

(use-package bash-completion
  :config
  (bash-completion-setup))

;;;; Theme

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t)
  (set-face-attribute 'region nil :background "#555"))

;;;; Code Navigation

(use-package ggtags
  :hook ((c-mode c++-mode java-mode) . ggtags-mode))

;;;; Whitespace & Formatting

(use-package whitespace-cleanup-mode
  :diminish
  :config
  (setq-default indent-tabs-mode nil)
  (global-whitespace-cleanup-mode 1))

(provide 'default-packages)
;;; default-packages.el ends here
