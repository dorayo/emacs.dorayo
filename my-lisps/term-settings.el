;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-05-13 14:36:22 Thursday by ahei>

(defun term-settings ()
  "Settings for `term'."
  (defun term-mode-hook-settings ()
    "Settings for `term-mode-hook'"
    ;; emacs gui版本如果不把scroll-margin设为0
    ;; 当光标最屏幕底部时，有可能使得屏幕发生抖动
    (make-local-variable 'scroll-margin)
    (setq scroll-margin 0)
    (kill-buffer-when-shell-command-exit))

  (add-hook 'term-mode-hook 'term-mode-hook-settings))

(eval-after-load "term"
  `(term-settings))

(provide 'term-settings)
