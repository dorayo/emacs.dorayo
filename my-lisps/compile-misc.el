;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; Keywords: 
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/compile-settings-autoloads.el
;; Time-stamp: <2010-04-10 17:43:43 Saturday by ahei>

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

;;; Commentary:

;;; Installation:
;;
;; Copy compile-settings-autoloads.el to your load-path and add to your .emacs:
;;
;; (require 'compile-settings-autoloads)

;;; History:
;;
;; 2010-4-1
;;      * initial version 1.0.

;;; Code:

;;;###autoload
(defun compile-buffer ()
  "编译当前buffer文件"
  (interactive)
  (let ((file (buffer-file-name)) base-name)
    (if (not file)
        (message "此buffer不与任何文件关联")
      (setq base-name (file-name-nondirectory file))
      (let ((extension (file-name-extension file)))
        (cond
         ((equal extension "cpp")
          (compile (format "g++ -g %s -o %s" file (file-name-sans-extension base-name))))
         ((equal (downcase extension) "c")
          (compile (format "gcc -g %s -o %s" file (file-name-sans-extension base-name))))
         ((equal extension "java")
          (compile (format "javac -g %s" file)))
         ((equal extension "jj")
          (compile (format "javacc %s" file)))
         ((equal extension "sh")
          (compile (format "sh -n %s" file))))))))

;;;###autoload
(defun run-program (command)
  "以命令COMMAND运行当前源程序对应的程序"
  (interactive
   (let* ((file (buffer-file-name)) base-name default-command (input ""))
     (if (not file)
         (error "此buffer不与任何文件关联")
       (setq base-name (file-name-nondirectory file))
       (setq default-command 
             (let ((extension (file-name-extension file)))
               (if (not extension)
                   (setq extension ""))
               (cond
                ((or (equal extension "cpp") (equal (downcase extension) "c"))
                 (format "./%s" (file-name-sans-extension base-name)))
                ((equal extension "java")
                 (format "java %s" (file-name-sans-extension base-name)))
                ((or (equal extension "sh") (equal major-mode 'sh-mode))
                 (format "sh %s" base-name)))))
       (while (string= input "")
         (setq input (read-from-minibuffer "Command to run: " default-command nil nil 'shell-command-history default-command)))
       (list input))))
  (let ((buffer "*Shell Command Output*"))
    (shell-command command buffer)
    (sleep-for 1)
    (end-of-buffer-other-window buffer)))

;;;###autoload
(defun make ()
  "在当前目录下执行\"make\"命令"
  (interactive)
  (if (or (file-readable-p "Makefile") (file-readable-p "makefile") (file-readable-p "GNUmakefile"))
      (compile "make -k")
    (if (file-readable-p "build.xml")
        (compile "ant -e -k compile")
      (smart-compile))))

;;;###autoload
(defun ant ()
  "执行\"ant\"命令"
  (interactive)
  (compile "ant compile -e -k -s"))

;;;###autoload
(defun make-check ()
  "在当前目录下执行\"make check\"命令"
  (interactive)
  (if (or (file-readable-p "Makefile") (file-readable-p "makefile") (file-readable-p "GNUmakefile"))
      (compile "make -k check")
    (if (file-readable-p "build.xml")
        (compile "ant test -e -k"))))

;;;###autoload
(defun make-clean ()
  "在当前目录下执行\"make clean\"命令"
  (interactive)
  (if (or (file-readable-p "Makefile") (file-readable-p "makefile") (file-readable-p "GNUmakefile"))
      (compile "make -k clean")
    (if (file-readable-p "build.xml")
        (compile "ant clean -e -k"))))

;;;###autoload
(defun ant-clean ()
  "执行\"ant clean\"命令"
  (interactive)
  (compile "ant clean -e -k -s"))

;;;###autoload
(defun ant-test ()
  "执行\"ant test\"命令"
  (interactive)
  (compile "ant test -e -k -s"))

;;;###autoload
(defun make-install ()
  "在当前目录下执行\"make install\"命令"
  (interactive)
  (compile "make -k install"))

(provide 'compile-misc)

;;; compile-settings-autoloads.el ends here
