;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 22:12:40 Monday by ahei>

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

(defun log-view-face-settings ()
  "Face settings for `log-view'."
  (if is-before-emacs-21
      (progn
        (set-face-foreground 'log-view-file-face "green")
        (set-face-foreground 'log-view-message-face "yellow"))
    (setq log-view-file-face 'darkgreen-face)
    (setq log-view-message-face 'darkyellow-face)))

(eval-after-load "log-view"
  `(log-view-face-settings))

(provide 'log-view-face-settings)
