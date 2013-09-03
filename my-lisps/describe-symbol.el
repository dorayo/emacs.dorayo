;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-17 20:43:13 Saturday by ahei>

;; 使用
;; (require 'describe-symbol)
;; (dolist (map (list emacs-lisp-mode-map lisp-interaction-mode-map completion-list-mode-map help-mode-map))
;;   (define-key map (kbd "C-c /") 'describe-symbol-at-point)
;;   (define-key map (kbd "C-c v") 'describe-variable-at-point)
;;   (define-key map (kbd "C-c f") 'describe-function-at-point)
;;   (define-key map (kbd "C-c s") 'describe-face-at-point)
;;   (define-key map (kbd "C-c w") 'where-is-at-point))
;; (define-key global-map (kbd "C-x C-_") 'describe-symbol)

(defvar describe-symbol-last-symbol 0 "`describe-symbol'最后查看的symbol")

;;;###autoload
(defun valid-symbol-p (symbol)
  "符号SYMBOL是否是有效的符号"
  (or (fboundp symbol) (and (boundp symbol) (not (keywordp symbol))) (facep symbol)))

;;;###autoload
(defun describe-symbol (symbol &optional is-find)
  "查看符号SYMBOL的describe, 或者有\\[universal-argument]前缀的话, 将会跳到SYMBOL的源码处"
  (interactive
   (let* ((def-symbol (valid-symbol-at-point)) (input "") have-default)
     (setq have-default (symbolp def-symbol))
     (unless have-default
       (setq have-default (symbolp describe-symbol-last-symbol))
       (setq def-symbol describe-symbol-last-symbol))
     (while (string= input "")
       (setq input
             (completing-read
              (if current-prefix-arg
                  (if have-default (format "待查看源码的symbol(缺省为%s): " def-symbol) "待查看源码的symbol: ")
                (if have-default (format "待查看的symbol(缺省为%s): " def-symbol) "待查看的symbol: "))
              obarray 'valid-symbol-p t nil nil (if have-default (symbol-name def-symbol)))))
     (list (intern-soft input) current-prefix-arg)))
  (setq describe-symbol-last-symbol symbol)
  (assert (valid-symbol-p symbol))
  (let ((is-fun (fboundp symbol)) (is-var (boundp symbol)) (is-face (facep symbol)) (name (symbol-name symbol)) format c)
    (assert (or is-fun is-var is-face))
    (if is-fun
        (if is-var
            (if is-face
                (progn
                  (setq format (format "`%s'为function(f), variable(v), face(s), 请输入对应的字符, 你要查看的是(缺省为function): " name))
                  (setq c (read-char-exclusive format))
                  (while (not (member c '(?f ?v ?s ?\r 32)))
                    (setq format "请输入对应的字符, f - function, v - variable, s - face, 你要查看的是(缺省为function): " name)
                    (setq c (read-char-exclusive format)))
                  (funcall (char-to-fun c is-find (char-to-fun ?f is-find)) symbol))
              (setq format (format "`%s'为function(f), variable(v), 请输入对应的字符, 你要查看的是(缺省为function): " name))
              (setq c (read-char-exclusive format))
              (while (not (member c '(?f ?v ?\r 32)))
                (setq format "请输入对应的字符, f - function, v - variable, 你要查看的是(缺省为function): " name)
                (setq c (read-char-exclusive format)))
              (funcall (char-to-fun c is-find (char-to-fun ?f is-find)) symbol))
          (if (not is-face)
              (funcall (char-to-fun ?f is-find) symbol)
            (setq format (format "`%s'为function(f), face(s), 请输入对应的字符, 你要查看的是(缺省为function): " name))
            (setq c (read-char-exclusive format))
            (while (not (member c '(?f ?s ?\r 32)))
              (setq format "请输入对应的字符, f - function, s - face, 你要查看的是(缺省为function): " name)
              (setq c (read-char-exclusive format)))
            (funcall (char-to-fun c is-find (char-to-fun ?f is-find)) symbol)))
      (if is-var
          (if (not is-face)
              (funcall (char-to-fun ?v is-find) symbol)
            (setq format (format "`%s'为variable(v), face(s), 请输入对应的字符, 你要查看的是(缺省为variable): " name))
            (setq c (read-char-exclusive format))
            (while (not (member c '(?v ?s ?\r 32)))
              (setq format "请输入对应的字符, v - variable, s - face, 你要查看的是(缺省为variable): " name)
              (setq c (read-char-exclusive format)))
            (funcall (char-to-fun c is-find (char-to-fun ?v is-find)) symbol))
        (assert is-face)
        (funcall (char-to-fun ?s is-find) symbol)))))

;;;###autoload
(defun char-to-fun (c is-find &optional default)
  (cond
   ((member c '(?\r 32)) default)
   ((equal c ?f) (if is-find 'find-function 'describe-function))
   ((equal c ?v) (if is-find 'find-variable 'describe-variable))
   ((equal c ?s) (if is-find 'find-face-definition 'describe-face))
   nil))

;;;###autoload
(defun describe-symbol-at-point ()
  "查看当前光标附近的词的`describe-symbol'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是有效的symbol" word)))
      (describe-symbol symbol))))

;;;###autoload
(defun describe-variable-at-point ()
  "如果当前光标附近的词是variable的话,则查看其`describe-variable'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'boundp)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是variable" word)))
      (describe-variable symbol))))

;;;###autoload
(defun describe-function-at-point ()
  "如果当前光标附近的词是function的话,则查看其`describe-function'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'fboundp)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是function" word)))
      (describe-function symbol))))

;;;###autoload
(defun describe-face-at-point ()
  "如果当前光标附近的词是face的话,则查看其`describe-face'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'facep)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是face" word)))
      (describe-face symbol))))

;;;###autoload
(defun where-is-at-point ()
  "如果当前光标附近的词是function的话,则查看其`where-is'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'fboundp)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是function" word)))
      (where-is symbol))))

;;;###autoload
(defun valid-symbol-at-point (&optional predicate)
  "返回当前光标下有效的symbol.
当前光标下无单词返回0, 当前光标下的单词不是symbol返回1, 当前光标下的单词不是有效的symbol返回2"
  (unless predicate (setq predicate 'valid-symbol-p))
  (let* ((word (current-word)) (symbol (intern-soft word)))
    (if word
        (if (or symbol (equal word "nil"))
            (if (funcall predicate symbol) symbol 2)
          1)
      0)))

(require 'post-command-hook)

(dolist (command '(describe-symbol-at-point describe-symbol))
  (add-to-list 'commands-with-recenter command))

(provide 'describe-symbol)
