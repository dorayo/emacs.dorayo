;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-28 13:32:49 Wednesday by ahei>

(unless is-after-emacs-23
  (require 'linum "linum-for-22"))

(global-set-key (kbd "C-x N") 'linum-mode)

;; http://emacser.com/linum-plus.htm
(require 'linum+)

(am-add-hooks
 `(find-file-hook help-mode-hook Man-mode-hook log-view-mode-hook chart-mode-hook
                  compilation-mode-hook gdb-mode-hook lisp-interaction-mode-hook
                  browse-kill-ring-mode-hook completion-list-mode-hook hs-hide-hook
                  inferior-ruby-mode-hook custom-mode-hook Info-mode-hook svn-log-edit-mode-hook
                  package-menu-mode-hook dired-mode-hook apropos-mode-hook svn-log-view-mode-hook
                  diff-mode-hook emacs-lisp-mode-hook ibuffer-mode-hook html-mode-hook
                  w3m-mode-hook data-debug-hook debugger-mode-hook text-mode-hook color-theme-mode-hook
                  semantic-symref-results-mode-hook sh-mode-hook groovy-mode-hook)
 (lambda()
   (unless (eq major-mode 'image-mode)
     (linum-mode 1))))

(defun linum-settings ()
  "settings for `linum'.")

(eval-after-load 'linum
  '(linum-settings))

(provide 'linum-settings)
