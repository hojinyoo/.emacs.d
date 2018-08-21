;;; default-package.el --- Loading default packages

;;; Commentary:
;; Default packages

;;; Code:

(use-package rainbow-delimiters)
(use-package rainbow-mode)

;; expand region
(use-package expand-region
  :config
  (global-set-key (kbd "C-=") 'er/expand-region)
  ;; Don't use expand-region fast keys
  (setq expand-region-fast-keys-enabled nil)
  ;; Show expand-region command used
  (setq er--show-expansion-message t)
  (global-set-key (kbd "C-=") 'er/expand-region))

;; save places in files between sessions
(use-package saveplace
  :config
  (save-place-mode 1)
  (setq save-place-file (expand-file-name ".places" user-emacs-directory)))

;; code completion
(use-package company
  :config
  (global-company-mode)
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common))

;; bash completion
(use-package bash-completion
  :config
  (bash-completion-setup))

;; auto-complete commands
;; (use-package icicles
;;   :config
;;   (icy-mode 1))

;; dynamic abbrev expansion, similar to auto-completion
;; (use-package dabbrev
;;   :defer t
;;   :init (setf abbrev-file-name (locate-user-emacs-file "local/abbrev_defs"))
;;   :config (setf dabbrev-case-fold-search nil))

;; (autoload 'auto-complete-mode "auto-complete" nil t)

;; frame zoom in/out
;; (use-package zoom-frm :ensure t)

;; (use-package dired
;;   :defer t
;;   :config
;;   (progn
;;     (add-hook 'dired-mode-hook #'toggle-truncate-lines)
;;     (setf dired-listing-switches "-alhG"
;;           dired-guess-shell-alist-user
;;           '(("\\.pdf\\'" "evince")
;;             ("\\(\\.ods\\|\\.xlsx?\\|\\.docx?\\|\\.csv\\)\\'" "libreoffice")
;;             ("\\(\\.png\\|\\.jpe?g\\)\\'" "qiv")
;;             ("\\.gif\\'" "animate")))))

;; This option to reduce initial connection time by saving connection history in previous sessions
;; (use-package tramp
;;   :defer t
;;   :config
;;   (setf tramp-persistency-file-name
;;         (concat temporary-file-directory "tramp-" (user-login-name))))

;; (use-package framemove
;;   :ensure t
;;   :config
;;   (windmove-default-keybindings)
;;   (setq framemove-hook-into-windmove t))

;; FIXME : interesting package. Try this : Comint mode is a package that defines a general command-interpreter-in-a-buffer.
;; (use-package comint
;;   :defer t
;;   :config
;;   (progn
;;     (define-key comint-mode-map (kbd "<down>") #'comint-next-input)
;;     (define-key comint-mode-map (kbd "<up>") #'comint-previous-input)
;;     (define-key comint-mode-map (kbd "C-n") #'comint-next-input)
;;     (define-key comint-mode-map (kbd "C-p") #'comint-previous-input)
;;     (define-key comint-mode-map (kbd "C-r") #'comint-history-isearch-backward)
;;     (setf comint-prompt-read-only t
;;           comint-history-isearch t)))

;; give a unique for buffers
(require 'uniquify)
(setf uniquify-buffer-name-style 'post-forward-angle-brackets)

;; navigate frame configurations
(use-package winner
  :config
  (winner-mode 1)
  (windmove-default-keybindings))

;; shows the regexp result visually
(use-package visual-regexp
  :config
  (define-key global-map (kbd "C-c q") 'vr/query-replace)
  (define-key global-map (kbd "C-c r") 'vr/replace))

(use-package guide-key
  :config
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-x v" "C-x 8" "C-x +" "C-h" "C-c"))
  (guide-key-mode 1)
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/popup-window-position 'bottom))

;; highlight escape characters
(use-package highlight-escape-sequences
  :config
  (put 'font-lock-regexp-grouping-backslash 'face-alias 'font-lock-builtin-face)
  (put 'hes-escape-backslash-face 'face-alias 'font-lock-builtin-face)
  (put 'hes-escape-sequence-face 'face-alias 'font-lock-builtin-face))

(use-package ivy
  :init (ivy-mode 1)
  :bind (("C-c C-r" . ivy-resume)))

(use-package counsel)

;; smex should be later than ivy
(use-package smex
  :config
  (smex-initialize)
  :bind (("M-x" . smex) ("C-c C-c M-x" . execute-extended-command)))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-strict-mode t)
  (sp-use-paredit-bindings))

(use-package projectile
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

(use-package magit
  :config
  (projectile-global-mode)
  (setq magit-completing-read-function 'ivy-completing-read))

;; Represent undo-history as an actual tree (visualize with C-x u)
(use-package undo-tree
  :config
  (setq undo-tree-mode-lighter "")
  (global-undo-tree-mode))

(declare git-link-tree)
(use-package git-link
  :config (setq git-link-open-in-browser t)
  :bind (("C-M-;" . git-link-tree)
         ("C-M-'" . git-link)))

;;; stole from git-link
(defun git-link-tree (remote)
  "Create a URL for the current buffer's REMOTE repository homepage.
The URL will be added to the kill ring.  If `git-link-open-in-browser'
is non-nil also call `browse-url'."

  (interactive (list (git-link--select-remote)))
  (let* ((remote-url (git-link--remote-url remote))
         (remote-info (when remote-url (git-link--parse-remote remote-url)))
         (branch (git-link--branch)))
    (if remote-info
        ;;TODO: shouldn't assume https, need service specific handler like others
        (git-link--new (if (string= branch "master")
                           (format "https://%s/%s" (car remote-info) (cadr remote-info))
                           (format "https://%s/%s/tree/%s" (car remote-info) (cadr remote-info) branch)))
      (error  "Remote `%s' is unknown or contains an unsupported URL" remote))))

(use-package pdf-tools
  :config
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))

(use-package ivy-bibtex
  :config
  (autoload 'ivy-bibtex "ivy-bibtex" "" t)
  ;; ivy-bibtex requires ivy's `ivy--regex-ignore-order` regex builder, which
  ;; ignores the order of regexp tokens when searching for matching candidates.
  ;; Add something like this to your init file:
  (setq ivy-re-builders-alist
        '((ivy-bibtex . ivy--regex-ignore-order)
          (t . ivy--regex-plus)))
  (setq bibtex-bibliography "~/Dropbox/Bib/index.bib" ;; where your references are stored
        bibtex-library-path '("~/Dropbox/Bib/papers/" "~/Dropbox/Bib/books/") ;; where your pdfs etc are stored
        bibtex-notes-path "~/Dropbox/org/notes/" ;; where your notes are stored
        bibtex-completion-bibliography "~/Dropbox/Bib/index.bib" ;; writing completion
        bibtex-completion-notes-path "~/Dropbox/org/notes/"
        bibtex-completion-pdf-field "file"))

(use-package org-ref
  :config
  (setq reftex-default-bibliography '("~/Dropbox/Bib/index.bib"))
  (require 'org-ref-arxiv)
  (require 'org-ref-pdf)
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  ;; see org-ref for use of these variables
  (setq org-ref-bibliography-notes "~/Dropbox/org/notes/"
        org-ref-default-bibliography '("~/Dropbox/Bib/index.bib")
        org-ref-pdf-directory "~/Dropbox/Bib/lib"))

(use-package interleave)

(use-package org-cliplink
  :config
  (global-set-key (kbd "C-x p i") 'org-cliplink)
  (setq org-capture-templates
   '(("K" "Cliplink capture task" entry (file "")
      "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n" :empty-lines 1))))

(use-package org-download)

(require 'setup-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Visual Environment ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package zenburn-theme
  :config (load-theme 'zenburn t))
(set-face-attribute 'region nil :background "#555")

(use-package smart-mode-line
  :config
  ;; (setq powerline-arrow-shape 'curve)
  ;; (setq powerline-default-separator-dir '(right . left))
  ;; (setq sml/theme 'powerline)
  ;; (setq sml/mode-width 0)
  ;; (setq sml/name-width 20)
  ;; (rich-minority-mode 1)
  ;; (setf rm-blacklist "")
  ;; (setq sml/theme 'dark)
  ;; (setq sml/theme 'light)
  (setq sml/theme 'respectful)
  (setq sml/active-background-color "black")
  (sml/setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Language General ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package whitespace-cleanup-mode
  :init
  (progn
    (setq-default indent-tabs-mode nil)
    (global-whitespace-cleanup-mode)))

(use-package diff-mode
  :defer t
  :config (add-hook 'diff-mode-hook #'read-only-mode))

(use-package paren
  :config (show-paren-mode))

(use-package ggtags
  :defer t
  :init
  (progn
    (add-hook 'c-mode-common-hook
              (lambda ()
                (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                  (ggtags-mode 1))))))

(use-package yasnippet
  :config
  (require 'setup-yasnippet))

(use-package flycheck
  :init (global-flycheck-mode))

(provide 'default-packages)
;;; default-packages.el ends here
