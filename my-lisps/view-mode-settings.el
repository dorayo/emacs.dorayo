;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-04 16:52:45 Saturday by taoshanwen>

(eal-define-keys
 'view-mode-map
 `(("U"           View-scroll-page-backward)
   ("/"           describe-symbol-at-point)
   ("\C-j"        goto-line)
   ("'"           switch-to-other-buffer)
   ("m"           back-to-indentation)
   ("p"           previous-line-or-backward-button)
   ("Q"           delete-current-window)
   ("L"           count-brf-lines)
   ("1"           delete-other-windows)
   ("t"           sb-toggle-keep-buffer)
   ("<backspace>" c-electric-backspace)
   ("u"           View-scroll-half-page-backward)
   ("S-SPC"       View-scroll-half-page-backward)
   ("SPC"         View-scroll-half-page-forward)
   ("w"           scroll-down)
   ("d"           scroll-up)
   (","           find-symbol-go-back)
   ("1"           delete-other-windows)
   ("2"           split-window-vertically)
   ("3"           split-window-horizontally)
   ("B"           eval-buffer)))

(defun view-mode-settings ()
  "settings for `view-mode'."
  (defface view-mode-mode-line-face
    '((((type tty pc)) :bold t :background "red" :foreground "white") (t (:background "red" :foreground "white")))
    "Face used highlight `view-mode-line-format'.")

  (defvar view-mode-line-format
    (propertize "View"
                'local-map mode-line-minor-mode-keymap
                'help-echo "mouse-3: minor mode menu"
                'face 'view-mode-mode-line-face)
    "*Mode line format of `view-mode'.")

  (put 'view-mode-line-format 'risky-local-variable t)

  (setq minor-mode-alist
        (append
         `((view-mode " ") (view-mode ,view-mode-line-format))
         (delq (assq 'view-mode minor-mode-alist) minor-mode-alist) ))
  
  (defun previous-line-or-backward-button ()
    "`major-mode'为`help-mode'时, 执行`backward-button', 否则执行`previous-line'."
    (interactive)
    (if (equal major-mode 'help-mode)
        (call-interactively 'backward-button)
      (call-interactively 'previous-line))))

(eval-after-load "view"
  `(view-mode-settings))

(provide 'view-mode-settings)
