;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 21:48:09 Saturday by ahei>

(require 'util)

(eal-define-keys
 'sgml-mode-map
 `(("M-s"     emaci-mode-on)
   ("RET"     newline-and-indent)
   ("C-c m"   make)
   ("C-c C-c" comment)))

(provide 'sgml-mode-settings)
