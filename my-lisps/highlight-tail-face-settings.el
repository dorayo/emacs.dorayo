;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 20:31:11 Saturday by ahei>

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

(provide 'highlight-tail-face-settings)

(require 'face-settings)

(defun highlight-tail-face-settings ()
  "Face settings for `highlight-tail'."
  (if use-black-background
      ;; (setq highlight-tail-colors
      ;;       '(("black" . 0)
      ;;         ("#bc2525" . 25)
      ;;         ("black" . 66)))
      (setq highlight-tail-colors
            '(("black" . 0)
              ("red" . 40)
              ("blue" . 80)
              ("black" . 100)))
    (setq highlight-tail-colors
          '(("#c1e156" . 0)
            ("#b8ff07" . 25)
            ("#00c377" . 60)))))

(eval-after-load "highlight-tail"
  `(highlight-tail-face-settings))
