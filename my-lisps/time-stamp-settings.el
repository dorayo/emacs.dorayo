;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 21:15:42 Saturday by ahei>

(add-hook 'write-file-hooks 'time-stamp)

(eval-after-load "time-stamp"
  '(progn
     (setq time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S %:a by %u")))

(provide 'time-stamp-settings)
