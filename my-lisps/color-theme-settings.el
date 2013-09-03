;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 22:51:06 Saturday by ahei>

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

;; http://emacser.com/color-theme.htm

(require 'color-theme-autoloads)

(defun color-theme-settings ()
  "Settings for `color-theme'."

  (require 'util)

  (apply-define-key
   color-theme-mode-map
   `(("'"   switch-to-other-buffer)
     ("u"   View-scroll-half-page-backward)
     ("SPC" scroll-up)
     ("1"   delete-other-windows)
     ("."   find-symbol-at-point))))

(eval-after-load "color-theme"
  `(color-theme-settings))

(provide 'color-theme-settings)
