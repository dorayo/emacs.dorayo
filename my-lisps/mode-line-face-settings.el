;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-05 22:31:54 Monday by ahei>

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

(defun mode-line-face-settings ()
  "Face settings for `mode-line'."
  (unless is-before-emacs-21
    (custom-set-faces
     '(mode-line-buffer-id
       ((((class grayscale) (background light)) (:foreground "LightGray" :background "yellow" :weight bold))
        (((class grayscale) (background dark)) (:foreground "DimGray" :background "yellow" :weight bold))
        (((class color) (min-colors 88) (background light)) (:foreground "Orchid" :background "yellow"))
        (((class color) (min-colors 88) (background dark)) (:foreground "yellow" :background "HotPink3"))
        (((class color) (min-colors 16) (background light)) (:foreground "Orchid" :background "yellow"))
        (((class color) (min-colors 16) (background dark)) (:foreground "LightSteelBlue" :background "yellow"))
        (((class color) (min-colors 8)) (:foreground "blue" :background "yellow" :weight bold))
        (t (:weight bold))))))
  (if window-system
      (progn
        (set-face-foreground 'mode-line "black")
        (set-face-background 'mode-line "lightgreen")
        (unless is-before-emacs-21
          (set-face-foreground 'mode-line-inactive "black")
          (set-face-background 'mode-line-inactive "white")))
    (set-face-foreground 'mode-line "green")
    (set-face-background 'mode-line "black")
    (unless is-before-emacs-21
      (set-face-foreground 'mode-line-buffer-id "blue")
      (set-face-background 'mode-line-buffer-id "yellow")
      (set-face-foreground 'mode-line-inactive "white")
      (set-face-background 'mode-line-inactive "black")))

  (custom-set-faces
   '(header-line
     ((default
        :inherit mode-line)
      (((type tty))
       :foreground "black" :background "yellow" :inverse-video nil)
      (((class color grayscale) (background light))
       :background "grey90" :foreground "grey20" :box nil)
      (((class color grayscale) (background dark))
       :background "#D58EFFFFFC18" :foreground "blue")
      (((class mono) (background light))
       :background "white" :foreground "black"
       :inverse-video nil
       :box nil
       :underline t)
      (((class mono) (background dark))
       :background "black" :foreground "white"
       :inverse-video nil
       :box nil
       :underline t)))))

(eval-after-load "mode-line-settings"
  '(progn
     (defface mode-line-lines-face
       '((((type tty pc)) :background "red" :foreground "white")
         (t (:background "dark slate blue" :foreground "yellow")))
       "Face used to highlight lines on mode-line.")))

(eval-after-load "faces"
  `(mode-line-face-settings))

(provide 'mode-line-face-settings)
