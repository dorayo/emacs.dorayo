;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/vc-settings.el
;; Time-stamp: <2010-11-21 14:41:32 Sunday by taoshanwen>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.

(eal-define-keys
 `(emacs-lisp-mode-map c-mode-base-map sgml-mode-map
                       sh-mode-map text-mode-map conf-javaprop-mode-map
                       c++-mode-map image-mode-map makefile-gmake-mode-map
                       org-mode-map nxml-mode-map python-mode-map perl-mode-map)
 `(("C-c L"   vc-print-log)
   ("C-c C-u" vc-update-and-revert-buffer)
   ("C-c C-b" vc-annotate)
   ("C-c C-r" vc-rename)
   ("C-c M-D" vc-delete)
   ("C-c U"   vc-revert-update-modeline)
   ("C-c C-a" svn-add-current-file)
   ("C-c M-r" svn-resolved-current-file)
   ("C-c M-u" vc-update)
   ("C-c M-U" svn-update-current-dir)
   ("C-c v"   svn-status-this-dir-hide)
   ("C-c M-E" vc-ediff-with-prev-rev)
   ("C-c M-W" vc-checkout-working-revision)
   ("C-c C-v" ,(if is-after-emacs-23 `vc-revision-other-window `vc-version-other-window))))

(eal-define-keys
 (if is-after-emacs-23 'vc-svn-log-view-mode-map 'log-view-mode-map)
 '(("u"   scroll-down)
   ("SPC" View-scroll-half-page-forward)
   ("q"   delete-current-window)
   ("."   set-mark-command)
   ("'"   switch-to-other-buffer)
   ("j"   next-line)
   ("k"   previous-line)
   ("<"   beginning-of-buffer)
   ("1"   delete-other-windows)
   ("2"   split-window-vertically)
   ("3"   split-window-horizontally)
   (">"   end-of-buffer)))

(defun vc-settings ()
  "Settings for `vc'."
  (require 'vc+))

(eval-after-load "vc-svn"
  `(vc-settings))

(provide 'vc-settings)
