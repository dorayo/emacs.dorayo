;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-12 11:33:24 Sunday by taoshanwen>

(define-key global-map (kbd "C-x M") 'woman)

(eal-define-keys
 'Man-mode-map
 `(("Q"     Man-kill)
   ("1"     delete-other-windows)
   ("2"     split-window-vertically)
   ("3"     split-window-horizontally)
   ("u"     View-scroll-half-page-backward)
   ("S-SPC" View-scroll-half-page-backward)
   ("SPC"   View-scroll-half-page-forward)
   ("w"     scroll-down)
   ("d"     scroll-up)
   ("f"     am-forward-word-or-to-word)
   ("b"     emaci-b)
   ("n"     emaci-n)
   ("p"     emaci-p)
   ("N"     Man-next-section)
   ("P"     Man-previous-section)
   ("m"     back-to-indentation)
   ("M-j"   Man-goto-section)
   ("."     set-mark-command)
   ("g"       emaci-g)
   ("'"     switch-to-other-buffer)))

(defun man-settings ()
  "settings for `man'.")

(eal-define-keys
  `(c-mode-base-map sh-mode-map)
  `(("C-c /" man-current-word)))

;;;###autoload
(defun man-current-word ()
  "查看当前光标所在的词的`man'"
  (interactive)
  (manual-entry (current-word)))

(eval-after-load "man"
  '(man-settings))

(require 'woman-settings)

(provide 'man-settings)
