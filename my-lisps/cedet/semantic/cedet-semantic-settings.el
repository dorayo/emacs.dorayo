;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/cedet-semantic-settings.el
;; Time-stamp: <2010-09-26 00:45:32 Sunday by taoshanwen>

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

(semantic-load-enable-excessive-code-helpers)
(global-semantic-idle-completions-mode -1)
(semantic-load-enable-semantic-debugging-helpers)
(when window-system
  (global-semantic-tag-folding-mode 1))

(eal-define-keys-commonly
 global-map
 `(("C-x M-j" semantic-complete-jump)))

(defun cedet-semantic-settings ()
  "Settings for `semantic'."
  (eal-define-keys
   `(c-mode-base-map makefile-gmake-mode-map python-mode-map perl-mode-map sh-mode-map)
   `(("C-c C-j" semantic-ia-fast-jump)
     ("C-c j"   semantic-complete-jump-local)
     ("C-c n"   senator-next-tag)
     ("C-c p"   senator-previous-tag)))

  (defun cedet-semantic-settings-4-emaci ()
    "cedet `semantic' settings for `emaci'."  
    (emaci-add-key-definition
     "." 'semantic-ia-fast-jump
     '(memq major-mode dev-modes))
    (emaci-add-key-definition
     "," 'recent-jump-backward
     '(memq major-mode dev-modes)))

  (eval-after-load "emaci"
    `(cedet-semantic-settings-4-emaci))

  (eal-define-keys
   'emaci-mode-map
   `(("." emaci-.)
     ("," emaci-\,)))
  
  ;; system include path
  (if (or mswin cygwin)
      (dolist (mode '(c-mode c++-mode))
        (semantic-add-system-include "c:/cygwin/usr/include/" mode))))

(defun semantic-decorate-include-settings ()
  "Settings of `semantic-decorate-include'."
  (eal-define-keys
   'semantic-decoration-on-include-map
   `(("." semantic-decoration-include-visit))))

(defun cedet-semantic-idle-settings ()
  "Settings for `semantic-idle'."
  (defun semantic-idle-tag-highlight-idle-command ()
    "Highlight the tag, and references of the symbol under point.
Call `semantic-analyze-current-context' to find the refer ence tag.
Call `semantic-symref-hits-in-region' to identify local references."
    (interactive)
    (semantic-idle-tag-highlight-idle-function))

  (defun semantic-idle-summary-idle-command ()
    "Display a tag summary of the lexical token under the cursor.
Call `semantic-idle-summary-current-symbol-info' for getting the
current tag to display information."
    (interactive)
    (semantic-idle-summary-idle-function))

  (defun semantic-refresh-tags ()
    "Execute `semantic-idle-scheduler-refresh-tags'"
    (interactive)
    (semantic-idle-scheduler-refresh-tags))
  
  (eal-define-keys
   `(c-mode-base-map)
   `(("C-c M-s" semantic-idle-summary-idle-command))))

(defun semantic-decorate-mode-settings ()
  "Settings of `semantic-decorate-mode'."
  (defun semantic-decoration-decorate ()
    "`semantic-decorate-add-decorations' all `semantic-fetch-available-tags'."
    (interactive)
    (semantic-decorate-add-decorations (semantic-fetch-available-tags))))

(eal-define-keys
 `(semantic-symref-results-mode-map)
 `(("1" delete-other-windows)
   ("2" split-window-vertically)
   ("3" split-window-horizontally)
   ("q" delete-current-window)))

(eval-after-load "semantic-decorate-include"
  `(semantic-decorate-include-settings))

(eval-after-load "semantic-decorate-mode"
  `(semantic-decorate-mode-settings))

(eval-after-load "semantic-idle"
  `(cedet-semantic-idle-settings))

(eval-after-load "semantic"
  `(cedet-semantic-settings))

(provide 'cedet-semantic-settings)
