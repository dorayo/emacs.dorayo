;;; dired-lis.el --- Change cursor smartly

;; Copyright (C) 2009 ahei

;; Author: ahei <ahei0802@126.com>
;; Keywords: cursor

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

;;; Commentary:
;;
;; Change cursor smartly

;;; Installation:
;;
;; Copy cursor-change.el to your load-path and add following statement to
;; your .emacs:
;;
;; (require 'cursor-change)
;;
;; then M-x cursor-change-mode to use this library.

;;; History:
;;
;; 2009-11-22
;;      * initial version 1.0.

;;; Code:

(require 'cursor-chg)

(defgroup cursor-change nil
  "Group for cursor-change."
  :group 'cursor
  :prefix "cursor-change-")

(defvar cursor-change-old-cursor-type nil "Cursor type before toggle on function `cursor-change-mode'.")
(defvar cursor-change-old-blink-cursor-mode nil "`blink-cursor-mode' before toggle on function `crsor-change-mode'.")

(setq curchg-default-cursor-color "green")

;;;###autoload
(define-minor-mode cursor-change-mode
  "Toggle `cursor-change-mode'."
  :global t
  :group 'cursor-change
  (if cursor-change-mode
      (progn
        (setq cursor-change-old-cursor-type (cursor-change-get-cursor-type))
        (setq cursor-change-old-blink-cursor-mode blink-cursor-mode))
    (blink-cursor-mode (if cursor-change-old-blink-cursor-mode 1 -1)))
  (toggle-cursor-type-when-idle cursor-change-mode)
  (change-cursor-mode cursor-change-mode)
  (unless cursor-change-mode
    (curchg-set-cursor-type cursor-change-old-cursor-type)))

(defun cursor-change-get-cursor-type (&optional frame)
  "Get cursor type of frame FRAME."
  (cdr (assq 'cursor-type (frame-parameters frame))))

(defun curchg-change-cursor-on-overwrite/read-only ()
  "Set cursor type differently for overwrite mode, function `view-mode', and read-only buffer.
That is, use one cursor type for overwrite mode and read-only buffers,
and another cursor type otherwise."
  (curchg-set-cursor-type
   (if (or buffer-read-only overwrite-mode view-mode)
       curchg-overwrite/read-only-cursor-type
     curchg-default-cursor-type)))

(provide 'cursor-change)

;;; cursor-change.el ends here
