;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 21:13:24 Saturday by ahei>

(defun login-irc ()
  "Login to irc."
  (interactive)
  (erc :server "irc.oftc.net"))

(defun erc-settings ()
  "Settings of `erc'."
  (require 'erc-nicklist)
  (require 'erc-highlight-nicknames)

  (add-to-list 'erc-modules 'highlight-nicknames)
  (erc-update-modules)
  
  (setq erc-nick-uniquifier "2"))

(eval-after-load "erc"
  `(erc-settings))

(provide 'erc-settings)
