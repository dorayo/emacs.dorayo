;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 18:53:41 Saturday by ahei>

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

(defun eldoc-face-settings ()
  "Face settings for `eldoc'."
  (custom-set-faces
   '(eldoc-highlight-function-argument
     ((((type tty)) :bold t :foreground "green")
      (t :bold nil :foreground "green")))))

(eval-after-load "eldoc"
  `(eldoc-face-settings))

(provide 'eldoc-face-settings)
