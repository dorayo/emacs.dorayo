;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 21:16:14 Saturday by ahei>

(if is-before-emacs-21
    (progn
      ;; gnuserv
      (require 'gnuserv-compat)
      (gnuserv-start)
      ;; 在当前frame打开
      (setq gnuserv-frame (selected-frame))
      ;; 打开后让emacs跳到前面来
      (setenv "GNUSERV_SHOW_EMACS" "1"))
  (if is-after-emacs-23
      (server-force-delete))
  (server-start))

(provide 'emacs-server-settings)
