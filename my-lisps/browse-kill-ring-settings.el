;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-08 19:00:50 Thursday by ahei>

(require 'browse-kill-ring)

(browse-kill-ring-default-keybindings)

(defun browse-kill-ring-settings ()
  "settings for `browse-kill-ring'."
  
  (setq browse-kill-ring-maximum-display-length nil)
  (setq browse-kill-ring-highlight-current-entry t)
  (setq browse-kill-ring-separator "------------------------------------------------------------")
  (setq browse-kill-ring-display-duplicates nil)

  (add-hook 'browse-kill-ring-hook 'browse-kill-ring-my-keys)

  ;; browse-kill-ring navigation have bug when linum-mode is on
  (defmacro def-without-linum-mode (command)
    `(defun ,(am-intern command "-without-linum-mode") ()
       ,(concat "Before call " command " , turn off `linum-mode' first.")
       (interactive)
       (let ((displn linum-mode))
         (linum-mode -1)
         (call-interactively ',(am-intern command))
         (linum-mode (if displn 1 -1)))))

  (def-without-linum-mode "browse-kill-ring-forward")
  (def-without-linum-mode "browse-kill-ring-previous")

  (require 'util)

  (defun browse-kill-ring-my-keys ()
    (let ((map browse-kill-ring-mode-map))
      (define-key-list
       map
       `(("RET" browse-kill-ring-insert-and-quit)
         ("<"   beginning-of-buffer)
         (">"   end-of-buffer)
         ("j"   next-line)
         ("k"   previous-line)
         ("h"   backward-char)
         ("l"   forward-char)
         ("n"   browse-kill-ring-forward-without-linum-mode)
         ("p"   browse-kill-ring-previous-without-linum-mode)
         ("SPC" scroll-up)
         ("U"   scroll-down)
         ("u"   View-scroll-half-page-backward)
         ("o"   other-window))))))

(eval-after-load "browse-kill-ring"
  `(browse-kill-ring-settings))

(provide 'browse-kill-ring-settings)
