;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 17:00:23 Monday by ahei>

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

(defun which-func-face-settings ()
  "Face settings for `which-func'."
  (if window-system
      (progn
        (unless is-before-emacs-21
          (set-face-foreground 'which-func "yellow2")
          (set-face-background 'which-func "dark magenta")))
    (unless is-before-emacs-21
      (set-face-foreground 'which-func "yellow")
      (set-face-background 'which-func "black"))))

(eval-after-load "which-func"
  `(which-func-face-settings))

(provide 'which-func-face-settings)
