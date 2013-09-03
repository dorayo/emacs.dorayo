;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-10-20 18:08:04 Wednesday by taoshanwen>

(eal-define-keys
 'completion-list-mode-map
 `(("SPC" scroll-up)
   ("u"   scroll-down)
   ("n"   next-completion)
   ("p"   previous-completion)
   ("<"   beginning-of-buffer)
   (">"   end-of-buffer)
   ("."   set-mark-command)
   ("'"   switch-to-other-buffer)
   ("L"   count-brf-lines)))

(provide 'completion-list-mode-settings)
