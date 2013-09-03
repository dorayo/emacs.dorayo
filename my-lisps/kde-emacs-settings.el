;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/kde-emacs-settings.el
;; Time-stamp: <2010-04-13 07:54:09 Tuesday by ahei>

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

;; sourcepair,可以在cpp与h文件之间切换
(require 'sourcepair-settings)

;; 改包中定义了C-j 为goto-line, 还设置了c-style
(require 'kde-emacs-core)

(autoload 'agulbra-make-member "kde-emacs-utils"
  "make a skeleton member function in the .cpp or .cc file" t)

(eal-define-keys
 'c++-mode-map
 `(("C-c C-b" agulbra-make-member)))

(defun kde-emacs-settings ()
  "Settings for `kde-emacs'."
  (setq magic-keys-mode nil)
  (setq kde-tab-behavior 'indent)

  (am-add-hooks
   `(java-mode-hook)
   (lambda ()
     (c-set-style "kde-c++"))))

(eval-after-load "kde-emacs-core"
  `(kde-emacs-settings))

(provide 'kde-emacs-settings)
