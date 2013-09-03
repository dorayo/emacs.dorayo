;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 22:34:30 Saturday by ahei>

(require 'recent-jump)
(require 'recent-jump-small)

(setq rj-mode-line-format nil)
(setq rjs-mode-line-format nil)

(recent-jump-mode)
(recent-jump-small-mode)

(let ((map global-map)
      (key-pairs
       `(("M-,"   recent-jump-backward)
         ("M-."   recent-jump-forward)
         ("C-x ," recent-jump-small-backward)
         ("C-x ." recent-jump-small-forward))))
  (apply-define-key map key-pairs))

(provide 'recent-jump-settings)
