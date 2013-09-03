;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 22:25:09 Monday by ahei>

(defun dired+-face-settings ()
  "Face settings for `dired+'."
  (custom-set-faces '(diredp-display-msg
                      ((((type tty)) :foreground "blue")
                       (t :foreground "cornflower blue"))))
  (custom-set-faces '(diredp-date-time
                      ((((type tty)) :foreground "yellow")
                       (t :foreground "goldenrod1"))))
  (custom-set-faces '(diredp-dir-heading
                      ((((type tty)) :background "yellow" :foreground "blue")
                       (t :background "Pink" :foreground "DarkOrchid1"))))
  (setq diredp-ignored-file-name 'green-face)
  (setq diredp-file-name 'darkred-face)
  (setq diredp-file-suffix 'magenta-face)
  (setq diredp-exec-priv 'darkred-face)
  (setq diredp-other-priv 'white-face)
  (setq diredp-no-priv 'darkmagenta-face)
  (setq diredp-write-priv 'darkcyan-face)
  (setq diredp-read-priv 'darkyellow-face)
  (setq diredp-link-priv 'lightblue-face)
  (setq diredp-symlink 'darkcyan-face)
  (setq diredp-rare-priv 'white-red-face)
  (setq diredp-dir-priv 'beautiful-blue-face)
  (setq diredp-compressed-file-suffix 'darkyellow-face))


(eval-after-load "dired+"
  `(dired+-face-settings))

(provide 'dired+-face-settings)
