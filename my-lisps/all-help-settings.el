;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-11 19:54:54 Sunday by ahei>

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

;; 重新定义`help-command',因为C-h已经绑定为删除前面的字符
(global-set-key (kbd "C-x /") 'help-command)

(require 'help-mode-settings)

;; Emacs中的info
(require 'info-settings)

;; Emacs中的man配置
(require 'man-settings)

;; 非常方便的查看emacs帮助的插件
(require 'describe-symbol)
(require 'find-symbol)
(require 'describe-find-symbol-settings)

(provide 'all-help-settings)
