;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-21 13:46:01 Sunday by taoshanwen>

(auto-insert-mode 1)

(defun auto-insert-settings ()
  "Settings for `auto-insert'."
  (setq auto-insert-query nil)
  (setq auto-insert-directory my-emacs-templates-path)
  (define-auto-insert "build.properties" "build.properties.tpl")

  (defun expand-template (template)
    "Expand template."
    (template-expand-template (concat my-emacs-templates-path template)))

  ;; (define-auto-insert
  ;;   '("\\.\\([Hh]\\|hh\\|hxx\\|hpp\\)$" . "C/C++ header")
  ;;   (lambda ()
  ;;     (expand-template "h.tpl")))
  ;; (define-auto-insert
  ;;   '("\\.c$" . "C")
  ;;   (lambda ()
  ;;     (expand-template "c.tpl")))
  ;; (define-auto-insert
  ;;   '("\\.cpp$" . "Cpp")
  ;;   (lambda ()
  ;;     (expand-template "cpp.tpl")))

  (defun insert-headx-snippet ()
    "Insert headx snippet."
    (insert-snippet "headx"))

  (defun insert-abbrev (abbrev-name)
    "Insert abbrev ABBREV-NAME"
    (interactive "s")
    (insert abbrev-name)
    (expand-abbrev))

  (defun insert-snippet (snippet)
    "Insert snippet SNIPPET."
    (interactive "s")
    (insert snippet)
    (yas/expand))

  (mapc
   (lambda (suffix)
     (define-auto-insert (concat "\\." suffix "$") 'insert-headx-snippet))
   '("el" "sh" "org" "pl" "py" "htm\\(l\\)?")))

(eval-after-load "autoinsert"
  `(auto-insert-settings))

(provide 'auto-insert-settings)
