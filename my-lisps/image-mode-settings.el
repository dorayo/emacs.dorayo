;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 18:45:19 Saturday by ahei>

(auto-image-file-mode 1)

(defun image-mode-settings ()
  "Settings for `image-mode'."
  (define-key image-mode-map (kbd "'") 'switch-to-other-buffer))

(eval-after-load "image-mode"
  `(image-mode-settings))

(provide 'image-mode-settings)
