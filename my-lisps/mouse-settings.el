;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 15:55:06 Saturday by ahei>

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

(eval-after-load "mouse-drag"
  '(progn
     (setq mouse-throw-with-scroll-bar nil)))

(eal-define-keys-commonly
 global-map
 `(("<S-down-mouse-1>" mouse-drag-drag)
   ("<down-mouse-1>"  mouse-drag-region-sb)
   ;; 使终端支持鼠标
   ("C-x T"            xterm-mouse-mode)))

(provide 'mouse-settings)
