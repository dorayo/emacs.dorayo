;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 22:41:23 Saturday by ahei>

(ignore-errors (require 'eclim))

(setq eclim-auto-save t)

(dolist (hook (list 'c-mode-common-hook 'lisp-mode-hook 'emacs-lisp-mode-hook 'java-mode-hook))
  (add-hook hook 'eclim-mode))

(provide 'eclim-settings)
