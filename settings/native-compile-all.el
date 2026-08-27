;;; native-compile-all.el --- Batch native-compile packages -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Loaded only by `make native`. Compiles real sources to .eln so JIT
;; does not run (and pop *Warnings*) on the next interactive start.

;;; Code:

(require 'comp)

(defvar settings-dir)

(defconst native-compile-all-skip
  "\\(?:-autoloads\\|-pkg\\|loaddefs\\)\\.el\\'\\|/tests?/\\|debug\\.el\\'"
  "Generated or test files that should not be native-compiled.")

(defun native-compile-all-file (file)
  "Native-compile FILE. Return `ok', `skip', or `fail'."
  (cond
   ((string-match-p native-compile-all-skip file) 'skip)
   (t
    (condition-case err
        (progn
          (native-compile file)
          'ok)
      (error
       (message "NATIVE-FAIL %s: %S" file err)
       'fail)))))

(defun native-compile-all--add-build-paths ()
  "Put every straight build dir on `load-path' so requires resolve."
  (let ((build (expand-file-name "straight/build" user-emacs-directory)))
    (when (file-directory-p build)
      (dolist (dir (directory-files build t "\\`[^.]"))
        (when (file-directory-p dir)
          (add-to-list 'load-path dir))))))

(defun native-compile-all ()
  "Native-compile this config and every straight build file."
  (native-compile-all--add-build-paths)
  (let ((ok 0)
        (fail 0)
        (skipped 0))
    (dolist (file (directory-files user-emacs-directory nil "\\`\\(early-init\\|init\\)\\.el\\'"))
      (pcase (native-compile-all-file (expand-file-name file user-emacs-directory))
        ('ok (setq ok (1+ ok)))
        ('fail (setq fail (1+ fail)))
        ('skip (setq skipped (1+ skipped)))))
    (dolist (root (list settings-dir
                        (expand-file-name "straight/build" user-emacs-directory)))
      (when (file-directory-p root)
        (dolist (file (directory-files-recursively root "\\.el$"))
          (pcase (native-compile-all-file file)
            ('ok (setq ok (1+ ok)))
            ('fail (setq fail (1+ fail)))
            ('skip (setq skipped (1+ skipped)))))))
    (message "native-compile: ok=%d fail=%d skipped=%d" ok fail skipped)
    (zerop fail)))

(provide 'native-compile-all)
;;; native-compile-all.el ends here
