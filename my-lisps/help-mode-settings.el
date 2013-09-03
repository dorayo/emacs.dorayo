;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-21 13:58:15 Sunday by taoshanwen>

(require 'util)

(define-key global-map (kbd "C-x H") 'goto-help-buffer)

(defun help-mode-settings ()
  "settings of `help-mode'."
  (eal-define-keys
   'help-mode-map
   `(("B"   help-go-back)
     ("F"   help-go-forward)
     ("f"   am-forward-word-or-to-word)
     ("d"   scroll-up)
     ("w"   scroll-down)
     ("C-h" help-go-back)
     ("C-;" help-go-forward)
     ("n"   forward-button)
     ("p"   backward-button)
     ("q"   delete-current-window)
     ("'"   switch-to-other-buffer)
     ("u"   View-scroll-half-page-backward)
     ("SPC" scroll-up)
     ("."   find-symbol-at-point)
     ("/"   describe-symbol-at-point)))

  (defun goto-help-buffer ()
    "Goto *Help* buffer."
    (interactive)
    (let ((buffer (get-buffer "*Help*")))
      (if buffer
          (switch-to-buffer buffer)
        (message "*Help* buffer dose not exist!"))))

  (def-turn-on "view-mode" nil)
  (am-add-hooks 'help-mode-hook 'view-mode-off))

(eval-after-load "help-mode"
  `(help-mode-settings))

(provide 'help-mode-settings)
