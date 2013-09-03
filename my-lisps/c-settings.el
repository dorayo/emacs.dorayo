;; -*- Emacs-Lisp -*-

;; Time-stamp: <2013-09-03 00:46:38 Tuesday by oa>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.

;; Xrefactory
(require 'xref-settings)

;; snavigator
(require 'sn)

(eal-define-keys
 `(c-mode-base-map)
 `(("C-h"     c-electric-backspace)
   ("C-c M-a" beginning-of-defun)
   ("C-c M-e" end-of-defun)
   ("C-c M-F" copy-current-fun-name)))

(defun cc-mode-settings ()
  "Settings for `cc-mode'."
  (defun c-mode-common-hook-settings ()
    "Settings for `c-mode-common-hook'."
    (c-set-style "awk")
    ;; 饥饿的删除键
    (c-toggle-hungry-state)
    ;; 对subword进行操作，而不是整个word
    (subword-mode t))

  (add-hook 'c-mode-common-hook 'c-mode-common-hook-settings)

  (add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

  ;; kde-emacs 一个方便开发c的工具
  (require 'kde-emacs-settings)

  ;; 高亮显示C/C++中的可能的错误(CWarn mode)
  (global-cwarn-mode 1)

  ;; 快速include一个系统/用户头文件
  (mapc
   (lambda (mode)
     (define-abbrev-table mode '(("incy" "" skeleton-include 1)))
     (define-abbrev-table mode '(("incz" "" skeleton-include-user 1))))
   '(c-mode-abbrev-table c++-mode-abbrev-table))

  ;; 输入incy,可以自动提示输入文件名称,可以自动补全.
  (define-skeleton skeleton-include
    "产生#include<>" "" > "#include <"
    (completing-read "包含系统头文件: "
                     (mapcar #'(lambda (f) (list f ))
                             (apply 'append (mapcar #'(lambda (dir) (directory-files dir))
                                                    system-head-file-dir)))) ">\n")
  (define-skeleton skeleton-include-user
    "产生#include\"\"" "" > "#include \""
    (completing-read "包含用户头文件: "
                     (mapcar #'(lambda (f) (list f ))
                             (apply 'append (mapcar #'(lambda (dir) (directory-files dir))
                                                    user-head-file-dir)))) "\"\n")

  (defvar c/c++-hightligh-included-files-key-map nil)
  (unless c/c++-hightligh-included-files-key-map
    (setq c/c++-hightligh-included-files-key-map (make-sparse-keymap))
    (define-key-list
      c/c++-hightligh-included-files-key-map
      `(("<RET>"    find-file-at-point)
        ("<return>" find-file-at-point))))

  (defun c/c++-hightligh-included-files ()
    (interactive)
    (when (or (eq major-mode 'c-mode)
              (eq major-mode 'c++-mode))
      (save-excursion
        (goto-char (point-min))
        ;; remove all overlay first
        (mapc (lambda (ov) (if (overlay-get ov 'c/c++-hightligh-included-files)
                               (delete-overlay ov)))
              (overlays-in (point-min) (point-max)))
        (while (re-search-forward "^[ \t]*#include[ \t]+[\"<]\\(.*\\)[\">]" nil t nil)
          (let* ((begin  (match-beginning 1))
                 (end (match-end 1))
                 (ov (make-overlay begin end)))
            (overlay-put ov 'c/c++-hightligh-included-files t)
            (overlay-put ov 'keymap c/c++-hightligh-included-files-key-map)
            (overlay-put ov 'face 'underline))))))
  ;; 这不是一个好办法，也可以把它加载到c-mode-hook or c++-mode-hook中
  (setq c/c++-hightligh-included-files-timer (run-with-idle-timer 0.5 t 'c/c++-hightligh-included-files))

  ;; c中隐藏ifdef
  (require 'hide-ifdef-settings)

  ;; 为不同层次的ifdef着色
  (require 'ifdef-settings)

  (defalias 'cpp-mode 'c++-mode))

(eval-after-load "cc-mode"
  `(cc-mode-settings))

(provide 'c-settings)
