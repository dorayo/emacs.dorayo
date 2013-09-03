;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-06 23:31:56 Tuesday by ahei>

(eval-after-load "debug"
  '(progn
     (require 'util)

     (apply-define-key
      debugger-mode-map
      `(("'" switch-to-other-buffer)
        ("o" other-window)))))

(provide 'debugger-settings)
