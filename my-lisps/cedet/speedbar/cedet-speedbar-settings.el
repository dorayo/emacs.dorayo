;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/cedet-speedbar-settings.el
;; Time-stamp: <2010-08-28 21:18:39 Saturday by taoshanwen>

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

(eal-define-keys
 `speedbar-key-map
 `(("j"   speedbar-next)
   ("k"   speedbar-prev)
   ("o"   other-window)
   ("m"   speedbar-toggle-line-expansion)
   ("SPC" View-scroll-half-page-forward)
   ("u"   View-scroll-half-page-backward)))

(eal-define-keys
 `speedbar-file-key-map
 `(("SPC" View-scroll-half-page-forward)))

(defun cedet-speedbar-settings ()
  "Settings for `speedbar'.")

(eval-after-load "speedbar"
  `(cedet-speedbar-settings))

(provide 'cedet-speedbar-settings)
