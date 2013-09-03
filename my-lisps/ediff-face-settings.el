;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 17:09:23 Monday by ahei>

(defun ediff-face-settings ()
  "Face settings for `ediff'."
  (if is-before-emacs-21
      (progn
        (custom-set-faces
         '(ediff-current-diff-face-B
           ((((class color) (background dark)) (:background "yellow")))))
        (set-face-foreground 'ediff-fine-diff-face-A "white")
        (set-face-background 'ediff-fine-diff-face-A "blue")
        (set-face-foreground 'ediff-current-diff-face-B "red")
        (set-face-foreground 'ediff-fine-diff-face-B "red")
        (set-face-background 'ediff-fine-diff-face-B "blue"))
    (custom-set-faces '(ediff-current-diff-A
                        ((((type tty)) :background "yellow" :foreground "blue")
                         (t :background "DarkSeaGreen3" :foreground "blue violet"))))
    (custom-set-faces '(ediff-fine-diff-A
                        ((((type tty)) :background "blue" :foreground "white")
                         (t :background "gold1" :foreground "red"))))
    (custom-set-faces '(ediff-current-diff-B
                        ((((type tty)) :background "yellow" :foreground "black")
                         (t :background "DodgerBlue1" :foreground "gray11"))))
    (custom-set-faces '(ediff-fine-diff-B
                        ((((type tty)) :background "cyan" :foreground "red")
                         (t :background "chocolate2" :foreground "dark slate blue"))))))

(eval-after-load "ediff"
  `(ediff-face-settings))

(provide 'ediff-face-settings)
