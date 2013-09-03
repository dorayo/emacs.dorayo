;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-06 23:25:37 Tuesday by ahei>

(eal-define-keys-commonly
 global-map
 `(("C-x M-E" toggle-debug-on-error)
   ("C-x Q"   toggle-debug-on-quit)))

(eval-after-load "edebug"
  '(progn
     (define-key edebug-mode-map (kbd "C-c C-d") nil)))

(defun edebug-clear-global-break-condition ()
  "Clear `edebug-global-break-condition'."
  (interactive)
  (setq edebug-global-break-condition nil))

(provide 'edebug-settings)
