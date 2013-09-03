;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 16:59:10 Monday by ahei>

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

(which-func-mode 1)

(defun which-func-settings ()
  "Settings for `which-func'."
  (setq which-func-unknown "unknown"))

(eval-after-load "which-func"
  `(which-func-settings))

(provide 'which-func-settings)
