;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-07 14:02:55 Wednesday by ahei>

(require 'mark-settings)

(setq use-cua t)

(defun cua-settings ()
  "settings for `cua'."
  (setq cua-rectangle-mark-key "")

  (when is-after-emacs-23
    (setq cua-remap-control-z nil)
    (setq cua-remap-control-v nil))

  (apply-args-list-to-fun
   'def-mark-move-command
   `("cua-resize-rectangle-down"
     "cua-resize-rectangle-up"
     "cua-resize-rectangle-right"
     "cua-resize-rectangle-left"
     "cua-resize-rectangle-top"
     "cua-resize-rectangle-page-up"
     "cua-resize-rectangle-page-down"
     "cua-resize-rectangle-bot"))

  (unless is-after-emacs-23
    (define-key cua--cua-keys-keymap [(control z)] nil)
    (define-key cua--cua-keys-keymap [(control v)] nil)
    (define-key cua--cua-keys-keymap [(meta v)] nil))

  (autoload 'cua--init-rectangles "cua-rect")

  (cua--init-rectangles)
  
  (eal-define-keys
   'cua--rectangle-keymap
   `(("M-f"     forward-word-remember)
     ("M-b"     backward-word-remember)
     ("C-c C-f" cua-fill-char-rectangle)
     ("'"       cua-insert-char-rectangle)
     ("<right>" cua-resize-rectangle-right)
     ("<left>"  cua-resize-rectangle-left)
     ("<down"   cua-resize-rectangle-down)
     ("<up>"    cua-resize-rectangle-up))))

(eval-after-load "cua-base"
  `(cua-settings))

(provide 'cua-settings)
