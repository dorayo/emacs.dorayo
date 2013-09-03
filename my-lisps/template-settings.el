;; -*- Emacs-Lisp -*-
;; Time-stamp: <2013-08-12 11:37:24 Monday by oa>

(require 'template)

(eal-define-keys
 '(emacs-lisp-mode-map c-mode-base-map makefile-mode-map makefile-automake-mode-map
                       sh-mode-map text-mode-map)
 `(("C-c T" my-template-expand-template)
   ("C-c C-t" template-expand-template)))

(defun template-settings ()
  "settings for `template'."
  (setq template-default-directories (list (concat my-emacs-path "/templates/")))

  (defvar last-template nil "最近使用的模版文件")

  (defun my-template-expand-template (template)
    "展开template的模版文件"
    (interactive
     (list
      (read-file-name
       (if last-template (format "请指定模版文件(缺省为%s): " last-template) "请指定模版文件: ")
       (concat my-emacs-path "templates") last-template t)))
    (template-expand-template template)
    (setq last-template template)))

(eval-after-load "template"
  `(template-settings))

(template-initialize)

(provide 'template-settings)
