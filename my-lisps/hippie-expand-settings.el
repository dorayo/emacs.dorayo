;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 18:07:41 Saturday by ahei>

(global-set-key (kbd "M-/") 'hippie-expand)

(defun hippie-expand-settings ()
  "Settings for `hippie-expand'."
  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-expand-dabbrev-visible
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-all-abbrevs
          try-expand-list
          try-expand-line
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol
          try-expand-whole-kill))

  (am-add-hooks
   `(emacs-lisp-mode-hook lisp-interaction-mode-hook)
   '(lambda ()
      (make-local-variable 'hippie-expand-try-functions-list)
      (setq hippie-expand-try-functions-list
            '(try-expand-dabbrev
              try-expand-dabbrev-visible
              try-expand-dabbrev-all-buffers
              try-expand-dabbrev-from-kill
              try-complete-file-name-partially
              try-complete-file-name
              try-expand-all-abbrevs
              try-expand-list
              try-expand-line
              try-expand-whole-kill)))))

(eval-after-load "hippie-exp"
  `(hippie-expand-settings))

(provide 'hippie-expand-settings)
