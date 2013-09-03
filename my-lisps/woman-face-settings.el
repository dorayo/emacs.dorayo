;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-21 15:09:44 Sunday by taoshanwen>

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(defun woman-face-settings ()
  "Face settings for `woman'."
  (set-face-foreground 'woman-italic "green")
  (set-face-foreground 'woman-bold "red")
  (custom-set-faces
   '(woman-bold
     ((((class color)) :foreground "red" :bold nil))))
  (set-face-foreground 'woman-addition "yellow")
  (set-face-foreground 'woman-unknown "blue"))

(eval-after-load "woman"
  `(woman-face-settings))

(provide 'woman-face-settings)
