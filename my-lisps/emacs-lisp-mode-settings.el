;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-08-07 11:10:51 Saturday by taoshanwen>

(eal-define-keys
 `emacs-lisp-mode-map
 `(("C-c M-a" beginning-of-defun)
   ("C-c M-e" end-of-defun)))

(defun emacs-lisp-mode-settings ()
  "Settings for `emacs-lisp-mode'."

  (defun emacs-lisp-mode-settings-4-emaci ()
    "`emacs-lisp-mode' settings for `emaci'."  
    (defvar lisp-modes '(emacs-lisp-mode lisp-mode lisp-interaction-mode) "*Lisp modes.")
    (emaci-add-key-definition
     "." 'find-symbol-at-point
     '(memq major-mode lisp-modes))
    (emaci-add-key-definition
     "," 'find-symbol-go-back
     '(memq major-mode lisp-modes)))

  (eval-after-load "emaci"
    `(emacs-lisp-mode-settings-4-emaci))

  (eal-define-keys
   'emaci-mode-map
   `(("." emaci-.)
     ("," emaci-\,)))

  (defun elisp-mode-hook-settings ()
    "Settings for `emacs-lisp-mode-hook'."
    (setq mode-name "Elisp"))

  (add-hook 'emacs-lisp-mode-hook 'elisp-mode-hook-settings))

(eval-after-load "lisp-mode"
  `(emacs-lisp-mode-settings))

(provide 'emacs-lisp-mode-settings)
