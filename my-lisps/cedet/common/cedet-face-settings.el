;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 16:05:28 Monday by ahei>

(defun semantic-util-modes-face-settings ()
  "Face settings for `semantic-util-modes'."
  (custom-set-faces
   '(semantic-highlight-func-current-tag-face
     ((((type tty)) nil)
      (((class color) (background dark))
       (:background "gray20"))
      (((class color) (background light))
       (:background "gray90"))))))

(defun semantic-tag-highlight-face-settings ()
  "Face settings for `semantic-tag-highlight'."
  (when (facep 'semantic-tag-highlight-face)
    (set-face-foreground 'semantic-tag-highlight-face "red")
    (set-face-background 'semantic-tag-highlight-face "blue")))

(defun cedet-face-settings ()
  "Face settings for `cedet'."
  (semantic-util-modes-face-settings)
  (semantic-tag-highlight-face-settings))

(eval-after-load "semantic-util-modes"
  `(cedet-face-settings))

(provide 'cedet-face-settings)
