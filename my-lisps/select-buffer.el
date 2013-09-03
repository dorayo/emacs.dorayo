;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-08-13 13:56:44 Friday by taoshanwen>

;;; selecte-buffer.el --- Select buffer like Alt-tab on linux system

;; Copyright (C) 2009 ahei

;; Author: ahei <ahei0802@126.com>
;; Keywords: select, buffer

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; 可以像linux下Alt-tab那样切换窗口
;; select-buffer-forward(M-N)下一个窗口
;; select-buffer-backward(M-P)上一个窗口
;; 当确定一个窗口后,按C-g取消选择这个窗口,回到以前的窗口,
;; 按其他键进入这个窗口, 这个窗口会成功当前窗口

;; 使用
;; (require 'select-buffer)
;; TODO: 如果出现bug, C-x t不显示`sb-buffer-name'buffer

;; Bug
;; 使用这个扩展时如果遇到问题, M-x sb-toggle-keep-buffer(C-x t)暂时关掉
;; 该扩展, 然后再M-x sb-toggle-keep-buffer(C-x t)打开该扩展

(require 'util)
(require 'ahei-face)
(require 'diff-mode)

(apply-define-key
 global-map
 `(("M-N"   select-buffer-forward)
   ("M-P"   select-buffer-backward)
   ("C-x t" sb-toggle-keep-buffer)
   ("M-'"   switch-to-other-buffer)))

(apply-define-key
 diff-mode-map
 `(("M-N" select-buffer-forward)
   ("M-P" select-buffer-backward)))

(defvar sb-active-buffer-face   'red-face   "default face for active buffer")
(defvar sb-inactive-buffer-face 'white-face "default face for inactive buffer")
(defvar sb-indicator-face       'green-face "the face of select buffer indicator")

(defvar sb-cur-buffer-index 0 "当前选择的buffer的索引")
(defvar sb-buffer-name "*select buffer*" "select buffer的名字")
(defvar sb-buffer-min-height 2 "`sb-buffer-name'buffer最小的高度")
(defvar sb-keep-buffer t "是否始终显示`sb-buffer-name'window")
(defvar sb-disp-buf-list-timer nil "显示`sb-buffer-name'buffer的timer")

(defvar sb-indicator " | " "*indicator of select buffer")
(defvar sb-buffer-exclude-regexps
  (list "^ .*" (regexp-quote sb-buffer-name) (regexp-quote "*svn-process*")
        (regexp-quote "*Ediff Registry*") (regexp-quote "*svn-log-edit*"))
  "*if buffer name match the regexp, ignore it.")
(defvar sb-auto-adjust-buffer nil "*Non-nil means automatically adjust the height of `sb-buffer-name'window")

(defadvice other-window (after sb-other-window)
    (when (sb-window-p (selected-window))
      (other-window
       (if (and (number-or-marker-p (ad-get-arg 0)) (< (ad-get-arg 0) 0)) -1 1) (ad-get-arg 1))))

(defadvice one-window-p (after sb-one-window-p)
  "Advice for `one-window-p' in `select-buffer'."
  (let ((win (selected-window))
        one)
    (save-window-excursion
      (save-excursion
        (call-interactively 'other-window)
        (setq one (eq win (selected-window)))))
    (setq ad-return-value one)))

(defun sb-window-p (window)
  "window WINDOW是否是`sb-buffer-name'window"
  (string= (buffer-name (window-buffer window)) sb-buffer-name))

(defun sb-buffer-visible-p ()
  "`sb-buffer-name'buffer是否存在于当前frame"
  (let ((list (window-list)) exist)
    (while (and list (not exist))
      (setq exist (string= (buffer-name (window-buffer (car list))) sb-buffer-name))
      (setq list (cdr list)))
    exist))

(defun sb-keep-buffer (keep)
  "控制是否始终显示`sb-buffer-name'buffer, KEEP为t则显示, 否则不显示"
  (interactive "P")
  (setq sb-keep-buffer keep)
  (sb-toggle-timer keep)
  (let ((activate-fun (if keep 'ad-activate 'ad-deactivate))
        (buffer (get-buffer sb-buffer-name)))
    (mapc activate-fun `(other-window one-window-p))
    (if (and (not keep) buffer)
        (delete-windows-on buffer)
      (kill-buffer buffer))))

(defun sb-toggle-timer (enable)
  "toggle `sb-disp-buf-list-timer'"
  (if enable
      (unless sb-disp-buf-list-timer
          (setq sb-disp-buf-list-timer (run-with-idle-timer 0.1 t 'sb-update-buffer)))
    (when sb-disp-buf-list-timer
      (cancel-timer sb-disp-buf-list-timer)
      (setq sb-disp-buf-list-timer nil))))

(defun sb-buffer-forward(buffer-list)
  (let ((len (length buffer-list)))
  (setq sb-cur-buffer-index (% (1+ sb-cur-buffer-index) len))))

(defun sb-buffer-backword(buffer-list)
  (let ((len (length buffer-list)))
    (setq sb-cur-buffer-index (1- sb-cur-buffer-index))
    (if (< sb-cur-buffer-index 0)
        (setq sb-cur-buffer-index (% (+ len sb-cur-buffer-index) len)))))

(defun sb-buffer-list ()
  "根据`sb-buffer-exclude-regexps'过滤不需要的buffer得到buffer list"
  (if (null sb-buffer-exclude-regexps)
      (buffer-list)
    (let ((regexp (mapconcat 'identity sb-buffer-exclude-regexps "\\|"))
          (buffer-list nil))
      (dolist (buffer (buffer-list))
        (if (not (string-match regexp (buffer-name buffer)))
            (setq buffer-list (append buffer-list (list buffer) nil))))
      buffer-list)))

(defun sb-buffer-name (buffer)
  (propertize (buffer-name buffer) 'face sb-inactive-buffer-face))

(defun sb-create-buffer ()
  "创建名字为`sb-buffer-name'的buffer"
  (unless (sb-buffer-visible-p)
    (let ((obuffer (current-buffer))
          (window (window-at 0 0))
          (owindow (selected-window))
          (buffer (get-buffer-create sb-buffer-name))
          (height (max window-min-height sb-buffer-min-height))
          nwindow result)
      (setq nwindow (split-window window height))
      (setq result (equal window owindow))
      (if result (setq owindow nwindow))
      (set-window-buffer window buffer)
      (if (= height window-min-height)
          (with-current-buffer buffer
            (make-local-variable 'window-min-height)
            (setq window-min-height sb-buffer-min-height)
            (shrink-window (- height window-min-height))))
      (select-window owindow))))

(defun sb-disp-buf-list (buffer-list)
  "在`sb-buffer-name'buffer显示BUFFER-LIST"
  (let* ((len (length buffer-list))
         (index sb-cur-buffer-index)
         (indicator (propertize sb-indicator 'face sb-indicator-face))
         (left-buffers-name (mapconcat 'sb-buffer-name (butlast buffer-list (- len index)) indicator))
         (right-buffers-name (mapconcat 'sb-buffer-name (nthcdr (1+ index) buffer-list) indicator))
         string)
    (setq string
          (format "%s"
                  (concat
                   left-buffers-name
                   (if (not (string= left-buffers-name "")) indicator)
                   (propertize (buffer-name (nth index buffer-list)) 'face sb-active-buffer-face)
                   (if (not (string= right-buffers-name "")) indicator)
                   right-buffers-name)))
    (if (not sb-keep-buffer)
        (message string)
      (sb-create-buffer)
      (let ((buffer (get-buffer sb-buffer-name)))
        (set-buffer buffer)
        (setq buffer-read-only nil)
        (erase-buffer)
        (insert string)
        (setq buffer-read-only t)
        (let* ((window (get-buffer-window buffer))
               (oheight (window-height window))
               (len (length string))
               (width (window-width))
               height)
          (setq height (1+ (/ len width)))
          (if (/= (% len width) 0) (setq height (1+ height)))
          ;; TODO: with-selected-window会改变buffer顺序
          ;; 怎样不改变buffer顺序enlarge-window
          (when sb-auto-adjust-buffer
            (with-selected-window window
              (enlarge-window (- height oheight)))))))))

(defun sb-update-buffer ()
  (sb-disp-buf-list (sb-buffer-list)))

(defun sb-disp-buf-list-with-switch (buffer-list)
  (sb-disp-buf-list buffer-list)
  (switch-to-buffer (nth sb-cur-buffer-index buffer-list) t))

(defun select-buffer (&optional arg)
  "像windows中Alt+Tab那样选择buffer, 如果ARG为nil, 则向前选择buffer, 否则向后选择buffer"
  (let* ((select-function (if arg 'sb-buffer-backword 'sb-buffer-forward))
         (buffer-list (sb-buffer-list))
         (exit-flag nil)
         key fun)
    (sb-toggle-timer nil)
    (funcall select-function buffer-list)
    (sb-disp-buf-list-with-switch buffer-list)
    (while (not exit-flag)
      (setq key (read-key-sequence-vector nil))
      (setq fun (key-binding key))
      (setq last-command-event (aref key (1- (length key))))
      (cond
       ((equal fun 'select-buffer-forward)
        (sb-buffer-forward buffer-list)
        (sb-disp-buf-list-with-switch buffer-list))
       ((equal fun 'select-buffer-backward)
        (sb-buffer-backword buffer-list)
        (sb-disp-buf-list-with-switch buffer-list))
       ((equal fun 'keyboard-quit)
        (setq sb-cur-buffer-index 0)
        (setq exit-flag 1)
        (sb-update))
       (t (setq exit-flag 2))))
    ;; 切换到选择的buffer
    (let ((selected-buffer (nth sb-cur-buffer-index buffer-list)))
      (setq sb-cur-buffer-index 0)
      (when (buffer-name selected-buffer)
        (switch-to-buffer selected-buffer)))
    ;; 执行最后一个按键对应的命令
    (when (= exit-flag 2)
      (when fun
        (call-interactively fun)
        (if (eq fun 'gdb) (sb-keep-buffer nil))))
    (sb-update)
    (sb-toggle-timer sb-keep-buffer)))

(defun select-buffer-forward ()
  "向前选择buffer"
  (interactive)
  (select-buffer))

(defun select-buffer-backward ()
  "向后选择buffer"
  (interactive)
  (select-buffer t))

(defun sb-toggle-keep-buffer ()
  "toggle `sb-keep-buffer'"
  (interactive)
  (setq sb-keep-buffer (not sb-keep-buffer))
  (sb-keep-buffer sb-keep-buffer))

(defun sb-toggle-auto-just-buffer ()
  "toggle `sb-auto-just-buffer'"
  (interactive)
  (setq sb-auto-adjust-buffer (not sb-auto-adjust-buffer)))

(defun sb-update ()
  (if sb-keep-buffer (sb-update-buffer)))

(defun switch-to-other-buffer ()
  "切换到最近访问的buffer"
  (interactive)
  (unless (minibufferp)
    (switch-to-buffer (other-buffer))))

(sb-keep-buffer sb-keep-buffer)
(sb-update)

;; TODO: 怎样可以不要以下的小patch
(require 'ediff)

(defvar sb-state-ediff nil "select-buffer的状态")

(add-hook 'ediff-startup-hook
          '(lambda ()
             (setq sb-state-ediff sb-keep-buffer)
             (sb-keep-buffer nil)))
(add-hook 'ediff-quit-hook '(lambda () (sb-keep-buffer sb-state-ediff)))

(defvar command-with-sb
  '(kill-buffer
    kill-this-buffer
    switch-to-other-buffer
    ido-switch-buffer
    find-file
    ido-find-file
    ido-exit-minibuffer
    other-window
    delete-other-windows
    visit-.emacs
    recentf-open-files-complete
    svn-status-this-dir-hide
    svn-status-hide
    svn)
  "*运行命令后需要执行`sb-update'的命令")

(defvar command-with-sb-kill
  '(gdb artist-mode)
  "*运行命令后需要执行`sb-keep-buffer'的命令")

(defun sb-post-command ()
  (if (memq this-command command-with-sb)
      (sb-update)))

(defun sb-kill-pre-command ()
  (if (memq this-command command-with-sb-kill)
      (sb-keep-buffer nil)))

(add-hook 'post-command-hook 'sb-post-command)
(add-hook 'pre-command-hook 'sb-kill-pre-command)

(defmacro def-command-sb (command)
  "有些命令在`sb-buffer-name'存在的时候不能正确的执行, 可以用这个宏重新定义下这些命令"
  `(defun ,(am-intern command "-sb") ()
     (interactive)
     (let ((state sb-keep-buffer))
       (sb-toggle-timer nil)
       (call-interactively (quote ,(intern command)))
       (sb-toggle-timer state))))

(apply-args-list-to-fun
 'def-command-sb
  `("query-replace"
    "query-replace-regexp"
    "describe-key"
    "describe-symbol"
    "find-symbol"
    "find-symbol-fun-on-key"
    "recentf-open-files-complete"
    "zap-to-char"
    "save-buffer"
    "quoted-insert"
    "do-command-on-current-file"
    "isearch-query-replace-current"
    "make"
    "run-program"
    "make-check"
    "make-clean"
    "make-install"
    "compile-buffer"
    "smart-compile"
    "ant"
    "ant-clean"
    "ant-test"
    "w3m-save-current-buffer"
    "w3m-download"
    "w3m-download-this-url"
    "icicle-download-wizard"
    "repeat-complex-command"
    "add-target-to-link"
    "mouse-drag-region"
    "dired-do-query-replace-regexp"
    "revert-buffer-with-coding-system"
    "revert-buffer-with-coding-system-no-confirm"
    "org-priority"
    "org-columns-edit-value"
    "svn-status-resolved"
    "svn-status-revert"
    "svn-status-rm"
    "svn-delete-files"
    "svn-revert-current-file"
    "svn-update-current-file"))

(provide 'select-buffer)
