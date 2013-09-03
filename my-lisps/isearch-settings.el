;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 19:44:16 Monday by ahei>

(defun isearch-settings ()
  "settings for `isearch'."
  ;; 在C-s进入incremental search的时候,按M-i,替换当前查找内容
  (defun isearch-query-replace-current ()
    "Replace current searching string."
    (interactive)
    (let ((case-fold-search isearch-case-fold-search)
          (from-string isearch-string))
      (if (string= from-string "")
          (isearch-update)
        (if (not isearch-success)
            (progn
              (message "Search string not found")
              (sleep-for 0.5)
              (isearch-update))
          (progn
            (isearch-done)
            (goto-char (min (point) isearch-other-end)))
          (perform-replace
           from-string
           (read-from-minibuffer
            (format "Query replace %s with: " from-string)
            "" nil nil query-replace-to-history-variable from-string t)
           t                                ; query flag
           isearch-regexp
           nil)))))

  ;; 搜索时不区分大小写
  (setq-default case-fold-search t)

  (defun toggle-case-fold-search-when-search ()
    "在搜索的时候执行`toggle-case-fold-search'."
    (interactive)
    (toggle-case-fold-search)
    (let ((str isearch-string))
      (goto-char isearch-opoint)
      (isearch-done)
      (let ((isearch-command
             (if isearch-forward
                 (if isearch-regexp 'isearch-forward-regexp 'isearch-forward)
               (if isearch-regexp 'isearch-backward-regexp 'isearch-backward))))
        (call-interactively isearch-command))
      (isearch-yank-string str)))

  (defun isearch-cur-word (fun)
    "ISearch current word use function FUN."
    (let ((cur-word (current-word)))
      (if (not cur-word)
          (message "No word under cursor.")
        (call-interactively fun)
        (isearch-yank-string cur-word))))

;;;###autoload
  (defun isearch-forward-cur-word (&optional backward)
    "`isearch-forward' current word."
    (interactive "P")
    (let ((fun (if backward 'isearch-backward 'isearch-forward)))
      (isearch-cur-word fun)))

  (define-key-list
    isearch-mode-map
    `(("M-i" isearch-query-replace-current-sb)
      ("M-k" isearch-clean)
      ("M-g" isearch-cancel)
      ("M-u" isearch-toggle-word)
      ("M-y" isearch-yank-line)
      ("C-y" isearch-yank-kill)
      ("M-h" isearch-del-char)
      ("M-H" ,(if is-after-emacs-23 isearch-help-map 'isearch-mode-help))))

  (defun isearch-clean ()
    "Clean string in `iserch-mode'."
    (interactive)
    (goto-char isearch-opoint)
    (let ((isearch-command
           (if isearch-forward
               (if isearch-regexp 'isearch-forward-regexp 'isearch-forward)
             (if isearch-regexp 'isearch-backward-regexp 'isearch-backward))))
      (call-interactively isearch-command))))

(define-key-list
    global-map
    `(("C-x M-s" isearch-forward-cur-word)))

(eval-after-load "isearch"
  '(isearch-settings))

(provide 'isearch-settings)
