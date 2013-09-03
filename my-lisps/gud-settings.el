;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 18:01:52 Saturday by ahei>

(require 'util)

(eal-define-keys
 'c-mode-base-map
 `(("C-c g" gdb)
   ("C-c b" gud-break)
   ("C-c B" gud-remove)))

(defun gud-settings ()
  "Settings for `gud'."
  (eal-define-keys
   'gud-mode-map
   `(("C-c B" gud-remove)
     ("M-s"   view)
     ("M-m"   comint-previous-matching-input)
     ("M-M"   comint-next-matching-input)
     ("C-c r" gud-run)
     ("C-c f" gud-finish)
     ("M-j"   gud-next)
     ("M-k"   gud-step)
     ("M-c"   gud-cont)
     ("M-C"   capitalize-word)
     ("C-c m" make)))

  ;; 退出gdb的时候关闭gdb对应的buffer
  (add-hook 'gdb-mode-hook 'kill-buffer-when-shell-command-exit)

  ;; 显示gdb的鼠标提示
  (gud-tooltip-mode 1))

(eval-after-load "gdb-ui"
  `(gud-settings))

(provide 'gud-settings)
