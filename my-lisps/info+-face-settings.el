;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 22:22:24 Monday by ahei>

(defun info+-face-settings ()
  "Face settings for `info+'."
  (if use-black-background
      (progn
        (set-face-foreground 'info-string "magenta"))
    (set-face-foreground 'info-string "blue"))
  (custom-set-faces '(info-quoted-name
                      ((((type tty)) :bold t :foreground "green")
                       (t :foreground "cornflower blue"))))
  (set-face-background 'info-single-quote "red")
  (set-face-foreground 'info-single-quote "white")
  (custom-set-faces '(info-reference-item
                      ((((type tty pc)) :background "white" :foreground "black")
                       (t :background "white" :foreground "cornflower blue"))))
  (set-face-foreground 'info-function-ref-item "deeppink1"))

(eval-after-load "info+"
  `(info+-face-settings))

(provide 'info+-face-settings)
