;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-21 08:00:15 Wednesday by ahei>

(require 'wcy-desktop)

(wcy-desktop-init)
(add-hook 'emacs-startup-hook
          (lambda ()
            (ignore-errors
              (wcy-desktop-open-last-opened-files))))

(provide 'wcy-desktop-settings)
