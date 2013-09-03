;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 22:11:32 Monday by ahei>

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

(require 'mic-paren)

(defun mic-paren-settings ()
  "Face settings for `mic-paren'."
  (paren-activate)
  (setq paren-message-show-linenumber 'absolute))

(eval-after-load "mic-paren"
  `(mic-paren-settings))

(provide 'mic-paren-settings)
