;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-05-21 18:27:09 Friday by ahei>

(defun font-lock-face-settings ()
  "Face settings for `font-lock'."
  ;; 语法着色
  (if use-black-background
      (progn
        (set-face-foreground 'font-lock-comment-face "red")
        (set-face-foreground 'font-lock-string-face "magenta"))
    (set-face-foreground 'font-lock-comment-face "darkgreen")
    (set-face-foreground 'font-lock-string-face "blue"))
  (custom-set-faces '(font-lock-function-name-face
                      ((((type tty)) :bold t :background "yellow" :foreground "blue")
                       (t :background "#45D463DD4FF8" :foreground "yellow"))))
  (custom-set-faces '(font-lock-constant-face
                      ((((type tty)) :bold t :background "white" :foreground "blue")
                       (t :background "darkslateblue" :foreground "chartreuse"))))
  (set-face-foreground 'font-lock-variable-name-face "#C892FFFF9957")
  (set-face-foreground 'font-lock-keyword-face "cyan")
  (custom-set-faces '(font-lock-comment-delimiter-face
                      ((((type tty)) :bold t :foreground "red")
                       (t :foreground "chocolate1"))))
  (custom-set-faces '(font-lock-warning-face ((t (:background "red" :foreground "white")))))
  (custom-set-faces '(font-lock-doc-face
                      ((((type tty)) :foreground "green")
                       (t (:foreground "maroon1")))))
  (custom-set-faces '(font-lock-type-face
                      ((((type tty)) :bold t :foreground "green")
                       (t (:foreground "green")))))
  (custom-set-faces '(font-lock-regexp-grouping-backslash
                      ((((type tty)) :foreground "red")
                       (t (:foreground "red")))))
  (custom-set-faces '(font-lock-regexp-grouping-construct
                      ((((type tty)) :foreground "yellow")
                       (t (:foreground "yellow"))))))

(eval-after-load "font-lock"
  `(font-lock-face-settings))

(provide 'font-lock-face-settings)
