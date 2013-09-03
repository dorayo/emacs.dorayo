;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-05-27 11:23:05 Thursday by ahei>

(eal-define-keys
 `(emacs-lisp-mode-map lisp-interaction-mode-map completion-list-mode-map help-mode-map
                       debugger-mode-map)
 `(("C-c /"   describe-symbol-at-point)
   ("C-c M-v" describe-variable-at-point)
   ("C-c M-f" describe-function-at-point)
   ("C-c M-s" describe-face-at-point)
   ("C-c C-j" find-symbol-at-point)
   ("C-c C-h" find-symbol-go-back)
   ("C-c M-V" find-symbol-var-at-point)
   ("C-c M-F" find-symbol-fun-at-point)
   ("C-c M-S" find-symbol-face-at-point)
   ("C-c w"   where-is-at-point)))

(eal-define-keys-commonly
 global-map
 `(("C-x C-k" describe-key-sb)
   ("C-x C-m" describe-mode)
   ("C-x / A" describe-face)
   ("C-x / a" apropos)
   ("C-x A"   apropos-command)
   ("C-x C-d" find-symbol-sb)
   ("C-x K"   find-symbol-fun-on-key-sb)
   (,(if window-system "C-x C-/" "C-x C-_") describe-symbol-sb)))

(defun find-symbol-settings ()
  "Settings for `find-symbol'.")

(defun describe-symbol-settings ()
  "Settings for `describe-symbol'.")

(eval-after-load "find-symbol"
  `(find-symbol-settings))

(eval-after-load "describe-symbol"
  `(describe-symbol-settings))

(provide 'describe-find-symbol-settings)
