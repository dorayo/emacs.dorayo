;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 16:22:58 Monday by ahei>

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

(defun ido-face-settings ()
  "Face settings for `ido'."
  (require 'util)

  (if is-before-emacs-21
      (progn
        (custom-set-faces '(ido-first-match-face
                            ((((type tty pc)) :foreground "yellow")
                             (t :bold nil :foreground "yellow"))))
        (custom-set-faces '(ido-only-match
                            ((((class color)) (:bold nil :foreground "green"))))))
    (custom-set-faces '(ido-first-match
                        ((((type tty pc)) :foreground "yellow")
                         (t :bold nil :foreground "yellow"))))
    (custom-set-faces '(ido-only-match
                        ((((class color)) (:bold nil :foreground "green")))))))

(eval-after-load 'ido
  `(ido-face-settings))

(provide 'ido-face-settings)
