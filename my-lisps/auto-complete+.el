;;; auto-complete+.el --- Auto complete plus

;; Copyright (C) 2009 ahei

;; Author: ahei <ahei0802@126.com>
;; Keywords: auto complete plus regexp

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
;; This library auto-complete+ extend library auto-complete with let users to
;; define regexp to ignore files when they expand use
;; ac-source-files-in-current-dir and ac-source-filename, and filter invalid
;; symbol when they expand use ac-source-symbols, because there so many garbage
;; in obarray.

;;; Installation:
;;
;; Copy auto-complete+.el to your load-path and add to your .emacs:
;;
;; (require 'auto-complete+)
;; add (ac+-apply-source-elisp-faces) to your emacs-lisp-mode-hook.

;;; History:
;;
;; 2009-11-18
;;      * Add support for emacs faces completion.

;; 2009-11-2
;;      * initial version 1.0.

;;; Code:

(require 'auto-complete)

(defgroup auto-complete+ nil
  "Auto completion plus."
  :group 'convenience
  :prefix "ac+-")

(defcustom ac+-filename-ignore-regexp "^#.*#$\\|.*~$\\|^\\./?$\\|^\\.\\./?$\\|^.svn\\|^CVS$"
  "Regexp of filename to ignore when use AC complete."
  :type 'regexp
  :group 'auto-complete+)

(defcustom ac+-valid-symbol-fun 'ac+-valid-symbolp
  "Function to judge a symbol is a valid symbol or not."
  :type 'function
  :group 'auto-complete+)

(defcustom ac+-modes
  '(emacs-lisp-mode lisp-interaction-mode
                    c-mode c++-mode java-mode
                    perl-mode cperl-mode python-mode ruby-mode
                    javascript-mode js2-mode php-mode css-mode
                    makefile-mode sh-mode fortran-mode f90-mode ada-mode
                    xml-mode sgml-mode html-mode fundamental-mode
                    org-mode svn-log-edit-mode text-mode
                    autoconf-mode makefile-automake-mode makefile-gmake-mode
                    conf-javaprop-mode conf-unix-mode change-log-mode
                    tcl-mode awk-mode latex-mode)
  "Major modes function `auto-complete-mode' can run on."
  :type '(list symbol)
  :group 'auto-complete+)

(defcustom ac+-source-elisp-faces '((candidates . ac+-elisp-faces-candidate))
  "Source for faces used in Emacs."
  :group 'auto-complete+)

(defcustom ac+-omni-completion-elisp-faces-sources
  '(("\\<set-\\(back\\|fore\\)ground-color\s+\"" ac+-source-elisp-faces)
    ("\\<set-face-\\(back\\|fore\\)ground\s+\"" ac+-source-elisp-faces))
  "Emacs faces for `ac-omni-completion-sources'."
  :group 'auto-complete+)

(defcustom ac+-source-elisp-features
  '((candidates . ac+-elisp-features-candidate))
  "Source for complete Emacs Lisp `features'."
  :group 'auto-complete+)

(defun ac+-filename-candidate ()
  "Get all candidates for filename(full patch filename)."
  (let ((dir (file-name-directory ac-prefix)))
    (ignore-errors
      (delq nil
            (mapcar
             (lambda (file)
               (unless (string-match ac+-filename-ignore-regexp file) (concat dir file)))
             (file-name-all-completions (file-name-nondirectory ac-prefix) dir))))))

(defun ac+-files-candidate ()
  "Get all candidates for files in current directory(only filename, exclude path)."
  (all-completions
   ac-prefix
   (delq nil
         (mapcar
          (lambda (file)
            (unless (string-match ac+-filename-ignore-regexp file) file))
          (directory-files default-directory)))))

(defun ac+-valid-symbolp (symbol)
  "Judge symbol SYMBOL is a valid symbol or not."
  (or (fboundp symbol)
      (boundp symbol)
      (generic-p symbol)
      (facep symbol)))
  
(defun ac+-elisp-faces-candidate ()
  "Get all candidates of faces used in Emacs."
  (all-completions ac-prefix (defined-colors)))

(defun ac+-elisp-features-candidate ()
  "Get all candidates of elisp features."
  (all-completions ac-prefix (mapcar 'symbol-name features)))

(defun ac+-apply-source-elisp-faces ()
  "Add `ac+-elisp-faces-candidate' to `ac-omni-completion-sources'."
  (if ac-omni-completion-sources
      (dolist (source ac+-omni-completion-elisp-faces-sources)
        (add-to-list 'ac-omni-completion-sources source))
    (setq ac-omni-completion-sources
          (append ac-omni-completion-sources ac+-omni-completion-elisp-faces-sources))))

(setq ac-source-filename '((candidates . ac+-filename-candidate)))
(setq ac-source-files-in-current-dir '((candidates . ac+-files-candidate)))

(provide 'auto-complete+)

;;; auto-complete+.el ends here
