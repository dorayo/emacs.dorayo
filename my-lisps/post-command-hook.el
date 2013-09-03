;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-08 18:30:39 Thursday by ahei>

(defvar commands-with-recenter
  '(delete-other-windows
    sb-toggle-keep-buffer)
  "*运行命令后需要执行`recenter'的命令")

(defvar commands-with-displn
  '(comment
    comment-in-view
    kill-line
    backward-kill-word-or-kill-region
    yank
    yank-pop
    c-electric-backspace
    undo
    redo
    delete-indentation
    delete-other-windows)
  "*运行命令后需要执行`linum-mode'的命令")

(defun recenter-post-command ()
  (if (memq this-command commands-with-recenter) (recenter)))

(defun displn-post-command ()
  (if (memq this-command commands-with-displn)
      (linum-mode linum-mode)))

(add-hook 'post-command-hook 'recenter-post-command)
;; (add-hook 'post-command-hook 'displn-post-command)

(provide 'post-command-hook)

;; post-command-hook.el ends here
