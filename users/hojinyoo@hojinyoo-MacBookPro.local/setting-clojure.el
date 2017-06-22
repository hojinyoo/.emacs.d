;; packages we want installed

(require 'ob-clojure)
(setq org-babel-clojure-backend 'cider)
(use-package cider :ensure t)
(use-package clojure-mode :ensure t)
;; (install-if 'auto-complete)
;; (install-if 'ac-cider)
(use-package popup :ensure)
(use-package rainbow-delimiters :ensure t)
(use-package rainbow-mode :ensure t)
(use-package company :ensure t)
(use-package autopair :ensure t)

(use-package clojure-cheatsheet :ensure t)

;; Cider &amp; nREPL
(add-hook 'cider-mode-hook #'eldoc-mode)
;; (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "<em>nrepl</em>")

;; Disable moving to error buffer
(setq cider-auto-select-error-buffer nil)

;; company mode
;; (add-hook 'cider-repl-mode-hook #'company-mode)
;; (add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
;; (global-set-key (kbd "TAB") #'company-indent-or-complete-common)
;; Instead of company mode
;; ac-cider (Auto-complete for the nREPL)
;; (require 'ac-cider)
;; (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
;; (add-hook 'cider-mode-hook 'ac-cider-setup)
;; (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
;; (eval-after-load "auto-complete"
;;   '(progn
;;      (add-to-list 'ac-modes 'cider-mode)
;;      (add-to-list 'ac-modes 'cider-repl-mode)))

;; Disable entries in the popup menu will also display the namespace that the symbol belongs to.
;; (setq ac-cider-show-ns nil)

;; rainbow delimiters
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; yasnippet
(use-package clojure-snippets :ensure t)

;; indentation
;; (set-face-background 'highlight-indentation-face "#262626")
;; (add-hook 'clojure-mode-hook 'highlight-indentation-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; clojure mode hook and helpers
(defun clojure-mode-custom-indent ()
  (put-clojure-indent 'fnk 'defun)
  (put-clojure-indent 'defnk 'defun)
  (put-clojure-indent 'for-map 1)
  (put-clojure-indent 'pfor-map 1)
  (put-clojure-indent 'instance 2)
  (put-clojure-indent 'inline 1)
  (put-clojure-indent 'letk 1))

(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun indent-whole-buffer-c ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max))
  )

;; (defun indent-or-expand (arg)
;;   "Either indent according to mode, or expand the word preceding
;; point."
;;   (interactive "*P")
;;   (if (and
;;        (or (bobp) (= ?w (char-syntax (char-before))))
;;        (or (eobp) (not (= ?w (char-syntax (char-after))))))
;;       (dabbrev-expand arg)
;;     (indent-according-to-mode)))

(defun my-tab-fix ()
  (local-set-key [tab] 'company-indent-or-complete-common))

(add-hook 'clojure-mode-hook
          #'(lambda ()
              (autopair-mode)
              (clojure-mode-custom-indent)
              (local-set-key (kbd "C-c C-i") 'indent-whole-buffer)
              (local-set-key (kbd "C-c C-/") 'cider-test-run-ns-tests)
              (setq c-basic-offset 4)
              (setq tab-width 4)
              (setq indent-tabs-mode nil)
              (setq cider-auto-select-error-buffer nil)
              ;; (my-tab-fix)

              (add-hook 'before-save-hook 'indent-whole-buffer nil t)
              (add-hook 'before-save-hook 'delete-trailing-whitespace)))

(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook
          #'(lambda () (my-tab-fix)))

;; let cider use the monorepo
(setq cider-lein-parameters "monolith with-all :select :default repl :headless :host ::")
; (setq cider-lein-parameters "monolith with-all :select :default with-profile dev repl :headless :host ::")


;; show nrepl server port
(setq nrepl-buffer-name-show-port t)

;; cider test mode - show report
(setq cider-test-show-report-on-success t)

;; retain history
(setq cider-repl-wrap-history t)
(setq cider-repl-history-size 10000)
(setq cider-repl-history-file (concat (getenv "HOME") "/.emacs.d/cider-history"))

;; line length limit indicator
(require 'fill-column-indicator)
(setq fci-rule-column 100)
(setq fci-rule-width 1)
;; (setq fci-rule-color "color-244")
(add-hook 'clojure-mode-hook 'fci-mode)

(add-to-list 'tramp-methods
              '("pod"
                (tramp-login-program "kubectl")
                (tramp-login-args
                 (("exec")
                  ("-it")
                  ("%h")
                  ("-n")
                  ("contour")
                  ("/bin/sh")))
                (tramp-login-env
                  (("SHELL")
                   ("/bin/sh")))
                (tramp-remote-shell "/bin/sh")))

(cider-add-to-alist 'cider-jack-in-lein-plugins "cider/cider-nrepl" (upcase "0.14.0"))

(use-package kubernetes
  :ensure t)
