;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 20:47:54 Saturday by ahei>

(require 'linkd)

(am-add-hooks
 `(lisp-mode-hook emacs-lisp-mode-hook lisp-interaction-mode-hook)
 (lambda ()
   (linkd-mode 1)
   (linkd-enable)))

(defun linkd-settings ()
  "settings for `linkd'."
  (setq linkd-use-icons t)
  (setq linkd-icons-directory (concat my-emacs-lisps-path "linkd/icons"))

  (eal-define-keys
   'linkd-overlay-map
   `(("n"        linkd-next-link)
     ("p"        linkd-previous-link)
     ("<return>" linkd-follow-at-point)))

  (eal-define-keys
   'linkd-map
   `(("<mouse-4>" nil)
     ("C-c ," nil))))

(eval-after-load "linkd"
  `(linkd-settings))

(provide 'linkd-settings)
