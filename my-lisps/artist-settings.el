;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/artist-mode-settings.el
;; Time-stamp: <2010-08-10 00:48:26 Tuesday by taoshanwen>

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

(global-set-kbd "C-x M-A" 'artist-mode)

(eal-define-keys
 'artist-mode-map
 `(("C-c l"   artist-select-op-line)
   ("C-c r"   artist-select-op-rectangle)
   ("C-c M-c" artist-select-op-copy-rectangle)
   ("C-c M-w" artist-select-op-cut-rectangle)
   ("C-c M-p" artist-select-op-paste)))

(defun artist-settings ()
  "Settings for `artist-mode'."
  (defvar hl-line-mode-active          nil "`hl-line-mode' active or not.")
  (defvar highlight-symbol-mode-active nil "`hlghlight-symbol-mode' active or not.")

  (make-variable-buffer-local 'hl-line-mode-active)
  (make-variable-buffer-local 'highlight-symbol-mode-active)

  (am-def-active-fun hl-line-mode hl-line-mode-active)
  (am-def-active-fun highlight-symbol-mode highlight-symbol-mode-active)

  (defun artist-mode-init-hook-settings ()
    "Settings for `artist-mode-init-hook'."
    (artist-select-op-rectangle)
    (setq hl-line-mode-active (hl-line-mode-active))
    (setq highlight-symbol-mode-active (highlight-symbol-mode-active))
    (when hl-line-mode-active
      (hl-line-mode -1))
    (when highlight-symbol-mode-active
      (highlight-symbol-mode -1)))

  (defun artist-mode-exit-hook-settings ()
    "Settings for `artist-mode-exit-hook'."
    (when hl-line-mode-active
      (hl-line-mode t))
    (when highlight-symbol-mode-active
      (highlight-symbol-mode t)))

  (add-hook 'artist-mode-init-hook 'artist-mode-init-hook-settings)
  (add-hook 'artist-mode-exit-hook 'artist-mode-exit-hook-settings))

(eval-after-load "artist"
  `(artist-settings))

(provide 'artist-settings)
