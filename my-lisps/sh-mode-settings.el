;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 20:21:13 Saturday by ahei>

(eal-define-keys
 'sh-mode-map
 `(("<"       self-insert-command)
   ("C-c M-c" sh-case)
   ("C-c C-c" comment)
   ("C-c g"   bashdb)))

(defun sh-mode-settings ()
  "settings for `sh-mode'."
  (font-lock-add-keywords 'sh-mode '(("\\<\\(local\\|let\\)\\>" . font-lock-keyword-face))))

(eval-after-load "sh-script"
  `(sh-mode-settings))

(provide 'sh-mode-settings)
