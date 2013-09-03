;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-17 20:42:39 Saturday by ahei>

;; 使用
;; (require 'find-symbol)
;; (dolist (map (list emacs-lisp-mode-map lisp-interaction-mode-map completion-list-mode-map help-mode-map))
;;   (define-key map (kbd "C-c .") 'find-symbol-at-point)
;;   (define-key map (kbd "C-c ,") 'find-symbol-go-back)
;;   (define-key map (kbd "C-c V") 'find-symbol-var-at-point)
;;   (define-key map (kbd "C-c F") 'find-symbol-fun-at-point)
;;   (define-key map (kbd "C-c S") 'find-symbol-face-at-point))
;; (define-key global-map (kbd "C-x .") 'find-symbol)
;; (define-key global-map (kbd "C-x K") 'find-symbol-fun-on-key)

(require 'find-func)
(require 'describe-symbol)

;; 可以使用recent-jump,这样就可以把`fs-is-record-point'设为nil了
(defvar fs-is-record-point t "是否记录`find-symbol'到过的位置")
(defvar fs-point-ring nil "存放`find-symbol'到过的位置的环")
(defvar fs-point-ring-size 200 "The size of ring `fs-point-ring'")
(defvar fs-last-symbol 0 "`find-symbol'最后查看的symbol")

;;;###autoload
(defun fs-push-point ()
  (if (eq (length fs-point-ring) fs-point-ring-size)
      (setq fs-point-ring (but fs-point-ring)))
  (let ((file (buffer-file-name)) element)
    (if file
        (setq element (list file -1 (point)))
      (setq element (list -1 (current-buffer) (point))))
    (push element fs-point-ring)))

;;;###autoload
(defun fs-pop-point ()
  (let ((val (pop fs-point-ring)))
    (if (not val)
        (message "reach buttom of ring")
      (let ((file (car val)) (buffer (nth 1 val)))
        (if (integerp file)
            (progn
              (assert (not (integerp buffer)))
              (switch-to-buffer buffer))
          (find-file file))
        (goto-char (nth 2 val))))))

;;;###autoload
(defun find-symbol (symbol)
  "查看symbol SYMBOL的源码"
  (interactive
   (let* ((def-symbol (valid-symbol-at-point)) (input "") second have-default)
     (setq have-default (symbolp def-symbol))
     (unless have-default
       (setq have-default (symbolp fs-last-symbol))
       (setq def-symbol fs-last-symbol))
     (while (string= input "")
       (setq input
             (completing-read
              (if have-default (format "待查看源码的symbol(缺省为%s): " def-symbol) "待查看源码的symbol: ")
              obarray 'valid-symbol-p t nil nil (if have-default (symbol-name def-symbol)))))
     (list (intern-soft input))))
  (setq fs-last-symbol symbol)
  (if fs-is-record-point (fs-push-point))
  (describe-symbol symbol t))

;;;###autoload
(defun find-symbol-at-point ()
  "对当前单词进行`find-symbol'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是有效的symbol" word)))
      (if fs-is-record-point (fs-push-point))
      (describe-symbol symbol t))))

;;;###autoload
(defun find-symbol-fun-at-point ()
  "对当前单词进行`find-function'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'fboundp)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是function" word)))
      (if fs-is-record-point (fs-push-point))
      (find-function symbol))))

;;;###autoload
(defun find-symbol-var-at-point ()
  "对当前单词进行`find-variable'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'boundp)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是variable" word)))
      (if fs-is-record-point (fs-push-point))
      (find-variable symbol))))

;;;###autoload
(defun find-symbol-face-at-point ()
  "对当前单词进行`find-face'"
  (interactive)
  (let ((word (current-word)) (symbol (valid-symbol-at-point 'facep)))
    (if (not (symbolp symbol))
        (cond
         ((equal symbol 0) (message "当前光标下无单词"))
         ((equal symbol 1) (message "`%s'不是symbol" word))
         ((equal symbol 2) (message "`%s'不是face" word)))
      (if fs-is-record-point (fs-push-point))
      (find-face-definition symbol))))

;;;###autoload
(defun find-symbol-go-back ()
  (interactive)
  (fs-pop-point))

;;;###autoload
(defun find-symbol-fun-on-key (key)
  "跳到按键KEY对应的命令的源码处"
  (interactive "kFind command on key: ")
  (let ((bind (key-binding key)) (key-desc (key-description key)))
    (if (or (null bind) (integerp bind))
        (message "没有任何命令绑定在按键`%s'上" key-desc)
      (if (consp bind)
          (message "按键`%s'运行`%s'" key-desc (prin1-to-string bind))
        (if fs-is-record-point (fs-push-point))
        (describe-symbol bind t)))))

(require 'post-command-hook)

(dolist (command '(find-symbol find-symbol-at-point find-symbol-fun-at-point
                               find-symbol-var-at-point find-symbol-face-at-point
                               find-symbol-fun-on-key))
  (add-to-list 'commands-with-recenter command))

(provide 'find-symbol)
