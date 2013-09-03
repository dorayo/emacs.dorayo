;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-17 20:39:20 Saturday by ahei>

(eal-define-keys
 'apropos-mode-map
 `(("u" scroll-down)
   ("1" delete-other-windows)
   ("n" forward-button)
   ("p" backward-button)))

(provide 'apropos-settings)
