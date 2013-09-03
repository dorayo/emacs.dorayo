;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/hide-region-settings.el
;; Time-stamp: <2010-04-10 18:09:58 Saturday by ahei>

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

(require 'hide-region)

(eal-define-keys-commonly
 global-map
 `(("C-x M-r" hide-region-hide)
   ("C-x M-R" hide-region-unhide)))

(defun hide-region-settings ()
  "Settings for `hide-region'."
  (setq hide-region-before-string "[======================该区域已")
  (setq hide-region-after-string "被折叠======================]\n"))

(eval-after-load "hide-region"
  `(hide-region-settings))

(provide 'hide-region-settings)
