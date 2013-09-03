;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 19:54:07 Saturday by ahei>

(require 'util)

(transient-mark-mode 1)

(defun mark-command (&optional no-record)
  "如果是CUA mode, 则执行`cua-set-mark', 否则执行`set-mark-command'.
if NO-RECORD is non-nil, do not record last-region."
  (interactive)
  (unless no-record
    (setq last-region-beg (point))
    (setq last-region-is-rect nil))
  (let ((command (if cua-mode 'cua-set-mark 'set-mark-command)))
    (if (interactive-p)
        (call-interactively command)
      (funcall command))))

(defmacro def-mark-move-command (command)
  "Make definition of command which first `mark-command' and then move."
  `(defun ,(am-intern "mark-and-" command) ()
     ,(concat "If no `mark-active', then `mark-command'. After do
that, execute `" command "'.")
     (interactive)
     (if (not mark-active) (call-interactively 'mark-command))
     (call-interactively (intern ,command))
     (setq last-region-end (point))))

(apply-args-list-to-fun
 'def-mark-move-command
 `("next-line" "previous-line" "end-of-buffer" "beginning-of-buffer"))

(defmacro def-remember-command (command)
  "Make definition of command which remember `poiint'."
  `(defun ,(am-intern command "-remember") ()
     ,(concat "When `" command "' remember `point'.")
     (interactive)
     (call-interactively (intern ,command))
     (if mark-active
         (setq last-region-end (point)))))

(apply-args-list-to-fun
 'def-remember-command
 `("previous-line" "next-line"
   "am-forward-word-or-to-word" "forward-word" "backward-word"
   "forward-char" "backward-char"))

(define-key-list
 global-map
 `(("C-n"     next-line-remember)
   ("C-p"     previous-line-remember)
   ("C-f"     forward-char-remember)
   ("C-b"     backward-char-remember)
   ("M-f"     am-forward-word-or-to-word-remember)
   ("M-b"     backward-word-remember)
   ("M-F"     forward-word-remember)
   ("C-x C-n" mark-and-next-line)
   ("C-x C-p" mark-and-previous-line)
   ("C-x M->" mark-and-end-of-buffer)
   ("C-x M-<" mark-and-beginning-of-buffer)))

(if window-system
    (define-key global-map (kbd "C-2") 'set-mark-command))

;; 这个功能就是根据光标的所在位置，智能的选择一块区域，也就
;; 是设置成为当前的point和mark。这样就可以方便的拷贝或者剪切，或者交换他们的位
;; 置。如果当前光标在一个单词上，那么区域就是这个单词的开始和结尾分别。
;; 如果当前光标在一个连字符上，那么就选择包含连字符的一个标识符。
;; 这个两个的是有区别的，而且根据不同的mode的语法定义，连字符和单词的定义也不一样。
;; 例如C mode下，abc_def_xxx, 如果光标停在abc上，那么就会选择abc这个单词。如果
;; 停在下划线上，那么就会选择abc_def_xxx。
;; 如果当前光标在一个双引号,单引号，一个花括号，方括号，圆括号，小于号，或者大于号，
;; 等等，那么就会选择他们对应的另一个括号之间的区域。引号中的escape字符也是可以
;; 自动识别的。嵌套关系也是可以识别的。这一点可以和VIM中的%的功能类比。
(require 'mouse)
(defun wcy-mark-some-thing-at-point()
  (interactive)
  (let* ((from (point))
         (a (mouse-start-end from from 1))
         (start (car a))
         (end (cadr a))
         (goto-point (if (= from start) end start)))
    (if (eq last-command 'wcy-mark-some-thing-at-point)
        (progn
          ;; exchange mark and point
          (goto-char (mark-marker))
          (set-marker (mark-marker) from))
      (push-mark (if (= goto-point start) end start) nil t)
      (when (and (interactive-p) (null transient-mark-mode))
        (goto-char (mark-marker))
        (sit-for 0 500 nil))
      (goto-char goto-point))))
(define-key global-map (kbd "M-C-l") 'wcy-mark-some-thing-at-point)

(provide 'mark-settings)
