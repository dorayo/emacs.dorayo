;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-05-10 17:05:30 Monday by ahei>

(eal-define-keys
 'html-mode-map
 `(("C-c C-w" w3m-browse-current-buffer)
   ("C-c M-a" add-target-to-link-sb)))

(defun html-mode-settings ()
  "settings for `html-mode'."
  (defun add-target-to-link ()
    "Add \"target=\"_blank\" to link."
    (interactive)
    (query-replace-regexp "<a\\s-+href=\\(\"[^\"#][^\"]*?\"\\)>\\(.*?\\)</a>" "<a href=\\1 target=\"_blank\">\\2</a>")))

(eval-after-load "sgml-mode"
  `(html-mode-settings))

(provide 'html-mode-settings)
