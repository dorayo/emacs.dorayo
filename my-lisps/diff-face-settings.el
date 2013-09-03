;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 17:08:46 Monday by ahei>

(defun diff-face-settings ()
  "Face settings for `diff'."
  (custom-set-faces '(diff-header ((((class color)) :foreground "green"))))
  (custom-set-faces '(diff-hunk-header ((((type tty pc)) :bold t :foreground "green")
                                        (t :foreground "OliveDrab1"))))
  (custom-set-faces '(diff-index ((((class color)) :foreground "cyan"))))
  (custom-set-faces '(diff-file-header ((((class color)) :foreground "magenta"))))
  (custom-set-faces '(diff-removed ((((class color)) :foreground "red"))))
  (custom-set-faces '(diff-indicator-removed ((((type tty pc)) :foreground "yellow" :background "red")
                                              (t :foreground "yellow" :background "red"))))
  (custom-set-faces '(diff-added ((((type tty pc)) :foreground "yellow")
                                  ;; (t :foreground "deep pink"))))
                                  (t :foreground "aquamarine"))))
  (custom-set-faces '(diff-indicator-added ((((type tty pc)) :foreground "red" :background "white")
                                            (t :foreground "red" :background "white"))))
  (custom-set-faces '(diff-changed ((((type tty pc)) :foreground "red" :background "blue")
                                    (t :foreground "deep pink"))))
  (custom-set-faces '(diff-refine-change ((((type tty pc)) :foreground "white" :background "blue")
                                          (t :foreground "dark orchid"))))
  (custom-set-faces '(diff-context
                      ((((class grayscale) (background light)) (:foreground "LightGray" :weight bold))
                       (((class grayscale) (background dark)) (:foreground "DimGray" :weight bold))
                       (((class color) (min-colors 88) (background light)) (:foreground "Orchid"))
                       (((class color) (min-colors 88) (background dark)) (:foreground "cornflower blue"))
                       (((class color) (min-colors 16) (background light)) (:foreground "Orchid"))
                       (((class color) (min-colors 16) (background dark)) (:foreground "LightSteelBlue"))
                       (((class color) (min-colors 8)) (:foreground "blue" :weight bold))
                       (t (:weight bold))))))

(eval-after-load "diff-mode"
  `(diff-face-settings))

(provide 'diff-face-settings)
