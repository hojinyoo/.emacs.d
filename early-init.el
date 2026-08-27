;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This file is loaded before init.el.

;;; Code:

;; libgccjit drives Apple ld, which needs Homebrew gcc's libemutls_w.
;; Without this, every JIT compile fails: "library 'emutls_w' not found"
;; and *Warnings* fills with native-ice. Must run before any native-comp.
(when (eq system-type 'darwin)
  (let* ((brew (cond ((file-directory-p "/opt/homebrew") "/opt/homebrew")
                     ((file-directory-p "/usr/local") "/usr/local")))
         (gcc-lib (and brew (expand-file-name "opt/gcc/lib/gcc/current" brew)))
         (jit-lib (and brew (expand-file-name "opt/libgccjit/lib/gcc/current" brew)))
         (emutls-dir nil))
    (when (and gcc-lib (file-directory-p (expand-file-name "gcc" gcc-lib)))
      (dolist (triple (directory-files (expand-file-name "gcc" gcc-lib) t "\\`[^.]"))
        (when (file-directory-p triple)
          (dolist (ver (directory-files triple t "\\`[^.]"))
            (when (file-exists-p (expand-file-name "libemutls_w.a" ver))
              (setq emutls-dir ver))))))
    (when gcc-lib
      (setenv "LIBRARY_PATH"
              (mapconcat #'identity
                         (delq nil (list gcc-lib jit-lib emutls-dir
                                         (getenv "LIBRARY_PATH")))
                         ":")))))

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

;; Suppress obsolete warnings from external packages not yet updated for Emacs 31
;; (when-let, if-let -> when-let*, if-let*)
(setq byte-compile-warnings '(not obsolete))

;; Generated files are not worth JIT. Real sources compile via `make native`.
(defvar native-comp-jit-compilation-deny-list)
(setq native-comp-jit-compilation-deny-list
      '(".*-autoloads\\.el\\'"
        ".*-pkg\\.el\\'"
        "/loaddefs\\.el\\'"
        "/tests?/"
        ".*-tests?\\.el\\'"))

;; Suppress runtime warnings from external packages (declare vars for byte-compiler)
(defvar warning-suppress-log-types)
(defvar warning-suppress-types)
(setq warning-suppress-log-types '((obsolete)))
(setq warning-suppress-types '((obsolete)))

;; Keep Custom out of init.el so a Customize click cannot rewrite this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Prevent flash of unstyled UI elements by disabling them early
(setq inhibit-startup-message t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; TTY menu bar costs a whole screen line; off in GUI too.
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))

;; Disable cursor blinking
(blink-cursor-mode -1)

(provide 'early-init)
;;; early-init.el ends here
