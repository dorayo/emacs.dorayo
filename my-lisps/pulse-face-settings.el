;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-07 01:11:36 Tuesday by taoshanwen>

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

(defun pulse-face-settings ()
  "Face settings for `pulse'."
  (custom-set-faces '(pulse-highlight-start-face
                      ((((class color) (min-colors 88) (background dark)) :background "#AAAA33")
                       (((class color) (min-colors 88) (background light)) :background "#FFFFAA")
                       (((class color) (min-colors 8)) :background "blue" :foreground "red")))))

(eval-after-load "pulse"
  `(pulse-face-settings))

(provide 'pulse-face-settings)
