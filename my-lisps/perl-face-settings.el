;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-26 12:09:14 Friday by taoshanwen>

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

(defun perl-face-settings ()
  "Face settings for `perl'."
  (custom-set-faces
   `(cperl-array-face
     ((((class grayscale) (background light))
       (:background "Gray90"))
      (((class grayscale) (background dark))
       (:foreground "Gray80"))
      (((class color) (background light))
       (:foreground "Blue" :background "lightyellow2"))
      (((class color) (background dark))
       (:foreground "yellow" :background ,cperl-dark-background))))))

(eval-after-load "cperl-mode"
  `(perl-face-settings))

(provide 'perl-face-settings)
