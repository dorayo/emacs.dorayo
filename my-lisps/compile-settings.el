;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-21 15:47:18 Sunday by taoshanwen>

(require 'util)

;; 智能编译
(require 'my-smart-compile)

(defalias 'cpl 'compile)

(defvar makefile-mode-map-list nil "the list of `makefile-mode-map'")
(if is-before-emacs-21
    (setq makefile-mode-map-list '(makefile-mode-map))
  (setq makefile-mode-map-list '(makefile-gmake-mode-map makefile-automake-mode-map)))

(eal-define-keys
 (append makefile-mode-map-list
         '(c-mode-base-map svn-status-mode-map sh-mode-map
                           compilation-mode-map ruby-mode-map))
 `(("C-c C-m"  make-sb)
   ("C-c m"    make-check-sb)
   ("C-c M"    make-clean-sb)
   ("C-c c"    compile-buffer-sb)
   ("C-c r"    run-program-sb)
   ("C-c C"    smart-compile-sb)))

(eal-define-keys
 'java-mode-map
 `(("C-c C-m" ant-sb)
   ("C-c M"	  ant-clean-sb)
   ("C-c m"	  ant-test-sb)))

(require 'compile-misc)

(eal-define-keys-commonly
 global-map
 `(("M-n" next-error)
   ("M-p" previous-error)))

(defun compile-settings ()
  "Settings for `compile'."
  ;; 设置编译命令
  (setq compile-command "make -k")

  (eal-define-keys
   makefile-mode-map-list
   `(("M-p"	  previous-error)
     ("M-n"	  next-error)
     ("C-c p" makefile-previous-dependency)
     ("C-c n" makefile-next-dependency)))

  (setq compilation-scroll-output t))

(eal-define-keys
 'compilation-mode-map
 `(("n" compilation-next-error)
   ("p" compilation-previous-error)
   ("'" switch-to-other-buffer)
   ("u" View-scroll-half-page-backward)
   ("f" am-forward-word-or-to-word)
   ("d" scroll-up)
   ("w" scroll-down)))

(eval-after-load "compile"
  '(compile-settings))

(provide 'compile-settings)
