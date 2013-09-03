;;; display-line-number.el --- line number mode for Emacs

;; Copyright (C) 2004  Free Software Foundation, Inc.

;; Author: ChunYe Wang 
;; Keywords: tools

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Installation:

;; put the display-line-number.el in your load-path
;; (require 'display-line-number)
;; M-x display-line-number-mode
;; M-x display-line-number-mode-on
;; M-x display-line-number-mode-off
;;; Code:




(defvar display-line-number-mode nil
  "Non-nil if display-line-number-mode is active in the current buffer.")
(make-variable-buffer-local 'display-line-number-mode)

(defvar display-line-number-face 'font-lock-keyword-face)

(defvar global-display-line-number-mode nil
  "Non-nil if display-line-number-mode is active in the all buffer.")

(defvar display-line-number-format "%5d "
  "String suitable for `format' that will generate a line number string.
`format' will be called with this string and one other argument
which will be an integer, the line number.")

(defun display-line-number-mode (&optional arg)
  "Toggle display-line-number-mode.
With prefix argument, turn display-line-number-mode on if argument is positive.
When display-line-number-mode is enabled, a line number will appear at the left
margin of each line."
  (interactive "P")
  (if (null arg) (setq arg 0)
    (setq arg (prefix-numeric-value arg)))
  (cond 
   ((> arg 0) (setq display-line-number-mode t))
   ((= arg 0) (setq display-line-number-mode 
                    (not display-line-number-mode)))
   ((< arg 0) (setq display-line-number-mode nil)))
  (if display-line-number-mode
      (display-line-number-mode-on)
    (display-line-number-mode-off)))


(defun global-display-line-number-mode (&optional arg)
  "Toggle display-line-number-mode.
With prefix argument, turn display-line-number-mode on if argument is positive.
When display-line-number-mode is enabled, a line number will appear at the left
margin of each line."
  (interactive "P")
  (if (null arg) (setq arg 0)
    (setq arg (prefix-numeric-value arg)))
  (cond 
   ((> arg 0) (setq global-display-line-number-mode t))
   ((= arg 0) (setq global-display-line-number-mode 
                    (not global-display-line-number-mode)))
   ((< arg 0) (setq global-display-line-number-mode nil)))
  (if global-display-line-number-mode
      (add-hook 'find-file-hooks
                'display-line-number-mode-on)
    (remove-hook 'find-file-hooks
                 'display-line-number-mode-on))
  (message "global display line number mode is %s" (if global-display-line-number-mode "on" "off")))

;; (global-display-line-number-mode (if global-display-line-number-mode 1 0))
  


(defun display-line-number-mode-on()
  (interactive)
  (setq display-line-number-mode t)
  (dln-undisplay)
  (dln-display)
  (make-local-variable 'after-change-functions)
  (make-local-variable 'window-scroll-functions)
  (make-local-variable 'window-configuration-change-hook)
  (add-to-list 'after-change-functions
               'dln-after-change-function)
  (add-to-list 'window-configuration-change-hook 
               'dln-window-configuration-change-function)
  (add-to-list 'window-scroll-functions
               'dln-window-scroll-function))


(defun display-line-number-mode-off()
  (interactive)
  (dln-undisplay)
  (setq after-change-functions (remq
                                'dln-after-change-function
                                after-change-functions))
  (setq window-configuration-change-hook (remq
                                          'dln-window-configuration-change-function
                                          window-configuration-change-hook))
  (setq window-scroll-functions (remq
                                 'dln-window-scroll-function
                                 window-scroll-functions)))



(defun dln-core (start end str)
  (let ((e (make-overlay start end)))
    (overlay-put e 'before-string (propertize str 'face display-line-number-face))
    (overlay-put e 'name 'dln-core)))

(defun dln-display ( &optional arg)
  (interactive "p")
;;  (setq left-margin-width 5)
;;  (set-window-margins (selected-window) 5 0)
  (let ((line-number 1)
        (start (window-start (selected-window)))
        (end (window-end (selected-window) t))
        (n 0)
        (flag 0))
    (save-excursion
      (save-restriction
        (widen)
        (goto-char start)
        (beginning-of-line)
        (setq n (count-lines 1 (point)))
        (while (= flag 0)
          (setq n (1+ n))
          (dln-core (line-beginning-position) 
                    (line-end-position)
                    (format display-line-number-format n
                            ))
          (forward-line 1)
          (if (or (>= (point) end)
                  (>= (point) (point-max))
                  (not (equal (point) (line-beginning-position))))
              (setq flag 1)))))))

(defun dln-undisplay ()
  (interactive)
  (save-excursion
   (save-restriction
     (widen)
     (let ((es (overlays-in 1 (1+ (point-max)))))
       (mapc (lambda (e) 
               (if (eq (overlay-get e 'name) 'dln-core)
                   (delete-overlay e)))
             es)))))


(defun dln-after-change-function (&optional start end length)
  (dln-undisplay)
  (dln-display))


(defun dln-window-scroll-function (&optional win pos)
  (dln-undisplay)
  (dln-display))

(defun dln-window-configuration-change-function (&optional win pos)
  (dln-undisplay)
  (dln-display))

(provide 'display-line-number)
;;; display-line-number.el ends here
