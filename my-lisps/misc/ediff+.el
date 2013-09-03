;;; ediff+.el --- Ediff plus

;; Copyright (C) 2009 ahei

;; Time-stamp: <2010-05-23 00:24:44 Sunday by ahei>
;; Author: ahei <ahei0802@126.com>
;; Keywords: ediff

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

;;; Installation:
;;
;; Copy ediff+.el to your load-path and add to your .emacs:
;;
;; (require 'ediff+)

;;; History:
;;
;; 2009-12-6
;;      * initial version 1.0.

(require 'ediff)

;;; Code:

(defgroup ediff+ nil
  "Enhacement for `'ediff'."
  :prefix "ediff+-")

(defcustom ediff+-ignore-whitespace-option3 ""
  "Option that causes the diff3 program to ignore whitespace.
GNU diff3 doesn't have such an option."
  :type 'string
  :group 'ediff+)

(defcustom ediff+-ignore-whitespace t
  "When diff, ignore whitespace or not."
  :type 'string
  :group 'ediff+)

(defcustom ediff+-ignore-whitespace-option "-w"
  "Option that causes the diff program to ignore whitespace."
  :type 'string
  :group 'ediff+)

(defun ediff+-set-actual-diff-options ()
  "Set actual diff options for ediff."
  (let ((ignore-case (if ediff-ignore-case ediff-ignore-case-option ""))
        (ignore-whitespace (if ediff+-ignore-whitespace ediff+-ignore-whitespace-option))
        (ignore-case3 (if ediff-ignore-case ediff-ignore-case-option3 ""))
        (ignore-whitespace3 (if ediff+-ignore-whitespace ediff+-ignore-whitespace-option3)))
    (setq ediff-actual-diff-options
          (concat ediff-diff-options " " ignore-case " " ignore-whitespace)
          ediff-actual-diff3-options
          (concat ediff-diff3-options " " ignore-case3 " " ignore-whitespace3)))
  (setq-default ediff-actual-diff-options ediff-actual-diff-options
                ediff-actual-diff3-options ediff-actual-diff3-options))

(defun ediff+-toggle-ignore-whitespace ()
  "Ignore whitespace."
  (interactive)
  (ediff-barf-if-not-control-buffer)
  (setq ediff+-ignore-whitespace (not ediff+-ignore-whitespace))
  (ediff+-set-actual-diff-options)
  (if ediff+-ignore-whitespace
      (message "Ignoring regions that differ only in whitespace.")
    (message "Ignoring whitespace differences turned OFF"))
  (cond (ediff-merge-job
         (message "Ignoring whitespace is too dangerous in merge jobs"))
        ((and ediff-diff3-job (string= ediff+-ignore-whitespace-option3 ""))
         (message "Ignoring whitespace is not supported by this diff3 program"))
        ((and (not ediff-3way-job) (string= ediff+-ignore-whitespace-option ""))
         (message "Ignoring whitespace is not supported by this diff program"))
        (t
         (sit-for 1)
         (ediff-update-diffs))))

(defun ediff+-previous-line ()
  "Make ediff buffer A and B scroll `previous-line'."
  (interactive)
  (setq last-command-char ?v)
  (call-interactively 'ediff-scroll-vertically))

(defun ediff+-goto-buffer-a ()
  "Goto buffer A."
  (interactive)
  (other-window 1))

(defun ediff+-goto-buffer-b ()
  "Goto buffer B."
  (interactive)
  (other-window 2))

(fset 'ediff-set-actual-diff-options 'ediff+-set-actual-diff-options)

(defun ediff-sequent-lines ()
  "Compare two sequent lines in the same buffer, by calling `ediff-regions-internal'."
  (interactive)
  (let ((fc (current-frame-configuration)))
    (eval
     `(defun rfc ()
        (set-frame-configuration ',fc)
        (remove-hook 'ediff-after-quit-hook-internal 'rfc)))
    (add-hook 'ediff-after-quit-hook-internal 'rfc)
    (ediff-regions-internal
     (current-buffer) (line-beginning-position) (line-end-position)
     (current-buffer) (line-beginning-position 2) (line-end-position 2)
     nil 'ediff-windows-wordwise 'word-mode nil)))

(provide 'ediff+)

;;; ediff+.el ends here
