;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-12 21:24:44 Sunday by taoshanwen>

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

(defun zjl-hl-face-settings ()
  "Face settings for `zjl-hl'."
  (setq zjl-hl-operators-face 'font-lock-type-face
        zjl-hl-local-variable-reference-face 'font-lock-variable-name-face
        zjl-hl-parameters-reference-face 'font-lock-variable-name-face
        zjl-hl-member-reference-face 'font-lock-variable-name-face
        zjl-elisp-hl-setq-face 'font-lock-keyword-face)

  (custom-set-faces
   '(zjl-hl-function-call-face
     ((((class grayscale) (background light)) :foreground "LightGray" :weight bold)
      (((class grayscale) (background dark)) :foreground "DimGray" :weight bold)
      (((class color) (min-colors 88) (background light)) :foreground "Orchid")
      (((class color) (min-colors 88) (background dark)) :foreground "cornflower blue")
      (((class color) (min-colors 16) (background light)) :foreground "Orchid")
      (((class color) (min-colors 16) (background dark)) :foreground "LightSteelBlue")
      (((class color) (min-colors 8)) (:foreground "blue" :weight bold))
      (t (:weight bold)))))

  (custom-set-faces
   '(zjl-elisp-hl-function-call-face
     ((((class grayscale) (background light)) :foreground "LightGray" :weight bold)
      (((class grayscale) (background dark)) :foreground "DimGray" :weight bold)
      (((class color) (min-colors 88) (background light)) :foreground "Orchid")
      (((class color) (min-colors 88) (background dark)) :foreground "cornflower blue")
      (((class color) (min-colors 16) (background light)) :foreground "Orchid")
      (((class color) (min-colors 16) (background dark)) :foreground "LightSteelBlue")
      (((class color) (min-colors 8)) (:foreground "blue" :weight bold))
      (t (:weight bold))))))

(eval-after-load "zjl-hl"
  `(zjl-hl-face-settings))

(provide 'zjl-hl-face-settings)
