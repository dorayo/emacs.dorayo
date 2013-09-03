;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-21 15:45:05 Sunday by taoshanwen>

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

(defun compile-face-settings ()
  "Face settings for `compile'."
  (custom-set-faces '(compilation-info
                      ((((type tty)) :bold t :foreground "green")
                       (t :foreground "green"))))
  (setq compilation-message-face nil)
  (custom-set-faces '(compilation-warning
                      ((((class color)) :foreground "red" :bold nil))))
  (custom-set-faces '(compilation-info
                      ((((type tty pc)) :foreground "magenta") (t (:foreground "magenta")))))
  (setq compilation-enter-directory-face 'beautiful-blue-face)
  (setq compilation-leave-directory-face 'magenta-face))

(eval-after-load "compile"
  `(compile-face-settings))

(provide 'compile-face-settings)
