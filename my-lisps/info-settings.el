;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-24 18:32:51 Friday by taoshanwen>

(require 'util)

(eal-define-keys-commonly
 global-map
 `(("C-x I" info-max-window)))

(apply-args-list-to-fun
 'def-command-max-window
 `("info"))

(defun info-settings ()
  "settings for `info'."
  (require 'info+))

(eval-after-load "info"
  `(info-settings))

(eal-define-keys
 'Info-mode-map
 `(("j"         next-line)
   ("k"         previous-line)
   ("h"         backward-char)
   ("l"         forward-char)
   ("J"         emaci-roll-down)
   ("K"         emaci-roll-up)
   ("f"         am-forward-word-or-to-word)
   ("/"         describe-symbol-at-point)
   ("U"         Info-up)
   ("u"         View-scroll-half-page-backward)
   ("Q"         kill-this-buffer)
   ("o"         other-window)
   ("S-SPC"     View-scroll-half-page-backward)
   ("SPC"       View-scroll-half-page-forward)
   ("C-h"       Info-up)
   ("N"         Info-next-reference)
   ("P"         Info-prev-reference)
   ("'"         switch-to-other-buffer)
   ("."         find-symbol-at-point)
   ("<mouse-4>" mwheel-scroll)
   ("<mouse-5>" mwheel-scroll)
   ("C-c ,"     Info-history-back)
   ("C-c ."     Info-history-forward)))

(provide 'info-settings)
