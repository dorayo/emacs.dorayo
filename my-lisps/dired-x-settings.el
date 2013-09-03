;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-05-03 14:18:46 Monday by ahei>

;; dired-x, 忽略不感兴趣的文件

(autoload 'dired-omit-mode "dired-x"
  "Toggle Dired-Omit mode.
With numeric ARG, enable Dired-Omit mode if ARG is positive, disable
otherwise.  Enabling and disabling is buffer-local.
If enabled, \"uninteresting\" files are not listed.
Uninteresting files are those whose filenames match regexp `dired-omit-files',
plus those ending with extensions in `dired-omit-extensions'."
  t)

(am-add-hooks
 `(dired-mode-hook)
 'dired-omit-mode)

(defun dired-x-settings ()
  "Settings for `dired-x'."
  (unless is-before-emacs-21
    (setq dired-omit-files (concat dired-omit-files "\\|^\\.\\|^semantic.cache$\\|^CVS$"))
    (if mswin
        (setq dired-omit-files (concat dired-omit-files "\\|^_"))))
  (setq dired-omit-size-limit 1000000))

(eval-after-load "dired-x"
  `(dired-x-settings))

(provide 'dired-x-settings)
