;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-21 12:01:23 Sunday by taoshanwen>

(require 'dired-lis)

;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/dired-lis-settings.el
;; Time-stamp: <2010-04-09 10:59:01 Friday by ahei>

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

(require 'dired-lis)

(eal-define-keys
 'isearch-mode-map
 `(("C-h" dired-lis-isearch-up-directory)))

(defun dired-lis-settings ()
  "Settings for `dired-lis'.")

(eval-after-load "dired-lis"
  `(dired-lis-settings))

(provide 'dired-lis-settings)
