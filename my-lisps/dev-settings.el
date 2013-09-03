;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-26 13:49:22 Friday by taoshanwen>

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

;; 语法高亮
(global-font-lock-mode t)

;; 增加自定义关键字
(dolist (mode '(c-mode c++-mode java-mode lisp-mode emacs-lisp-mode
                       lisp-interaction-mode sh-mode sgml-mode))
  (font-lock-add-keywords
   mode
   '(("\\<\\(FIXME\\|TODO\\|Todo\\|HACK\\):" 1 font-lock-warning-face prepend)
     ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face)
     ("(\\|)" . beautiful-blue-face)
     ("\\[\\|]" . yellow-face)
     ("<\\|>" . cyan-face)
     ("{\\|}" . green-face))))

(defun generate-tag-table ()
  "Generate tag tables under current directory(Linux)."
  (interactive)
  (let ((exp "") (dir ""))
    (setq dir (read-from-minibuffer "generate tags in: " default-directory)
          exp (read-from-minibuffer "suffix: "))
    (with-temp-buffer
      (shell-command
       (concat "find " dir " -name \"" exp "\" | xargs etags ")
       (buffer-name)))))

;; hs-minor-mode,折叠代码
(require 'hs-minor-mode-settings)

;; 输入左大花扩号自动补齐右大花括号
(eal-define-keys
 `(c-mode-base-map awk-mode-map)
 `(("{" skeleton-c-mode-left-brace)))

;; 动态检查语法错误
(require 'flymake-settings)

(defun skeleton-c-mode-left-brace (arg)
  (interactive "P")
  (if  (c-in-literal (c-most-enclosing-brace (c-parse-state)))
      (self-insert-command 1)
    ;; auto insert complex things.
    (let* ((current-line (delete-and-extract-region (line-beginning-position) (line-end-position)))
           (lines (and arg (mark t) (delete-and-extract-region (mark t) (point))))
           (after-point (make-marker)))
       ;;; delete extra blank begin and after the LINES
      (setq lines (and lines
                       (with-temp-buffer
                         (insert lines)
                         (beginning-of-buffer)
                         (delete-blank-lines)
                         (delete-blank-lines)
                         (end-of-buffer)
                         (delete-blank-lines)
                         (delete-blank-lines)
                         (buffer-string))))
      (save-excursion
        (let* ((old-point (point)))
          (insert (if current-line current-line "")  "{\n")
          (and lines (insert lines))
          (move-marker after-point (point))
          (insert "\n}")
          (indent-region old-point (point) nil)))
      (goto-char after-point)
      (c-indent-line))))

;; 所有关于括号的配置
(require 'all-paren-settings)

;; 用来显示当前光标在哪个函数
(require 'which-func-settings)

;; cedet 强大的开发工具, 包括代码浏览, 补全, 类图生成
;; 用CEDET浏览和编辑C++代码 http://emacser.com/cedet.htm
;; Emacs才是世界上最强大的IDE － cedet的安装 http://emacser.com/install-cedet.htm
;;(require 'cedet-settings)

;; ecb 代码浏览器
;;(require 'ecb-settings)

;; doxygen
;;(require 'doxymacs-settings)

(require 'autoconf-mode-settings)

;; 像Eclipse那样高亮光标处单词
(require 'highlight-symbol-settings)

;; `gdb'
(require 'gud-settings)

;; subversion
;;(require 'svn-settings)

;; 版本控制
;;(require 'vc-settings)

;; 所有的自动补全的配置
(require 'all-auto-complete-settings)

;; 所有关于lisp方面的配置
(require 'all-lisp-settings)

;; 开发shell程序的mode配置
(require 'sh-mode-settings)

;; xml mode配置
(require 'sgml-mode-settings)

(require 'html-mode-settings)

;; ruby
(require 'ruby-settings)

;; rails
;;(require 'rails-settings)

(require 'php-mode)

(require 'sql-settings)

(setq my-shebang-patterns
      (list "^#!\\s-*/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
            "^#!\\s-*/usr/.*/sh"
            "^#!\\s-*/usr/.*/bash"
            "^#!\\s-*/bin/sh"
            "^#!\\s-*/.*/perl"
            "^#!\\s-*/.*/awk"
            "^#!\\s-*/.*/sed"
            "^#!\\s-*/.*/tclsh$"
            "^#!\\s-*/.*/expect$"
            "^#!\\s-*/bin/bash"))
(add-hook
 'after-save-hook
 (lambda ()
   (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
       (progn
         ;; This puts message in *Message* twice, but minibuffer
         ;; output looks better.
         (message (concat "Wrote " (buffer-file-name)))
         (save-excursion
           (goto-char (point-min))
           ;; Always checks every pattern even after
           ;; match.  Inefficient but easy.
           (dolist (my-shebang-pat my-shebang-patterns)
             (if (looking-at my-shebang-pat)
                 (if (= (shell-command
                         (concat "chmod u+x " (buffer-file-name)))
                        0)
                     (message (concat
                               "Wrote and made executable "
                               (buffer-file-name))))))))
     ;; This puts message in *Message* twice, but minibuffer output
     ;; looks better.
     (message (concat "Wrote " (buffer-file-name))))))

;; 显示变量, 函数的声明
(require 'eldoc-settings)

;; 自动给你加上括号
(require 'autopair-settings)

;; 把Eclipse的功能带给Emacs
(require 'eclim-settings)

;; 方便开发c/c++的配置
(require 'c-settings)

;; 放在kde-emacs后面
(require 'compile-settings)

;; 回车后indent
(eal-define-keys
 `(lisp-mode-map emacs-lisp-mode-map lisp-interaction-mode-map sh-mode-map
                 ,(if (not is-before-emacs-21) 'awk-mode-map) java-mode-map
                 ruby-mode-map c-mode-base-map tcl-mode-map org-mode-map
                 python-mode-map perl-mode-map)
 `(("RET" newline-and-indent)))

(defun copy-current-fun-name ()
  "Copy current function name."
  (interactive)
  (kill-new (which-function)))

(mapc 'require '(;; hide region
                 hide-region-settings
                 ;; hide lines
                 hide-lines
                 ;; 把imenu以tree的形式显示出来
                 imenu-tree-settings
                 ;; 高亮引用的函数和变量
                 zjl-hl-settings
                 ;; 把speedbar放到当前frame里面
                 sr-speedbar-settings
                 codepilot-settings
                 ;; perl-settings
                 ;; 实现程序变量的自动对齐
                 align-settings))

(provide 'dev-settings)
