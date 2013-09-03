;; Copyright (C) 2010  Brian Jiang

;; Author: Brian Jiang <brianjcj@gmail.com>
;; Keywords: Programming
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(eval-when-compile
  (require 'cl))

(require 'easymenu)
(require 'remember)
(require 'which-func)

(require 'cp-layout)

;global
(defvar cptree-serial-number 0)

(defvar cptree-serial-no-last 0)

(defcustom my-hide-region-before-string " ..."
  "String to mark the beginning of an invisible region. This string is
not really placed in the text, it is just shown in the overlay"
  :type '(string)
  :group 'codepilot)

(defcustom my-hide-region-after-string "... "
  "String to mark the beginning of an invisible region. This string is
not really placed in the text, it is just shown in the overlay"
  :type '(string)
  :group 'codepilot)


(defface codepilot-folding-overlay
  '((default (:inherit region :box (:line-width 1 :color "DarkSeaGreen1" :style released-button)))
    (((class color)) (:background "DarkSeaGreen2" :foreground "black")))
  "*Font used by folding overlay."
  :group 'codepilot)


;; (defface codepilot-forest-green-face
;;   '((((class color)) (:foreground "ForestGreen")))
;;   "To highlight cplist, cptree, msym buffer. I like green. But it can be changed to other color."
;;   :group 'codepilot)

;; (defface codepilot-purple-face
;;   '((((class color)) (:foreground "Purple")))
;;   "To highlight cplist, cptree, msym buffer."
;;   :group 'codepilot)


(defvar cplist-buf-name "*IDList*")

(defvar codepilot-buffer-to-bury nil)

(defvar inhibit-codepilot-pre-pop-or-switch-buffer-hook nil)

(defmacro with-modify-in-readonly (&rest body)
  `(let ((inhibit-read-only t)
         (buffer-undo-list t))
     ,@body
     (set-buffer-modified-p nil)))

(defsubst codepilot-string-all-space? (str)
  (let ((ret t))
    (dotimes (i (length str))
      (unless (eq ?\s (aref str i))
        (setq ret nil)
        (return)))
    ret))

(defsubst codepilot-goto-line (line)
  (goto-char (point-min)) (forward-line (1- line)))

(defun codepilot-pop-or-switch-buffer (buf &optional type)
  ""
  (multiple-value-bind (ret sidebar code-win bottom-win)
      (codepilot-window-layout-wise)

    (when (and code-win (not (eq type :cpimenu)))
      (select-window code-win)) ;; brian TODO

    (unless inhibit-codepilot-pre-pop-or-switch-buffer-hook
      (run-hooks 'codepilot-pre-pop-or-switch-buffer-hook))

    (case ret
      ((:window-layout-1)
       (case type
         ((:xref-to-listing)
          (pop-to-buffer buf))
         ((:cpnote-click-link)
          (split-window-vertically)
          (switch-to-buffer buf))
         (otherwise
          (switch-to-buffer buf))))
      ((:window-layout-1&1)
       (case type
         ((:cpnote-click-link)
          (select-window code-win)
          (split-window-vertically)
          (switch-to-buffer buf))
         (otherwise
          (select-window code-win)
          (switch-to-buffer buf))))
      ((:window-layout-1&2+
        :window-layout-3+)

       (cond ((eq type :cpimenu)
              (pop-to-buffer buf))
             (t
              (select-window code-win)
              (switch-to-buffer buf)))
       (switch-to-buffer buf))
      (otherwise
       (case type
         ((:xref-to-listing)
          (pop-to-buffer buf))
         ((:cpnote-click-link)
          (pop-to-buffer buf))
         (otherwise
          (switch-to-buffer buf)))))))


(defun codepilot-switch-to-buffer (buf)
  ""
  (interactive)
  (let ((swin (selected-window))
        (buf-cur-win (get-buffer-window buf)))
    (if buf-cur-win
        (select-window buf-cur-win)
      ;; else
      (multiple-value-bind (ret sidebar code-win bottom-win)
          (codepilot-window-layout-wise)
        (case ret
          ((:window-layout-1)
           (when (get-buffer cplist-buf-name)
             (kill-buffer cplist-buf-name))
           (switch-to-buffer buf))
          ((:window-layout-1&1)
           (select-window code-win)
           (switch-to-buffer buf))
          ((:window-layout-1&2+
            :window-layout-2
            :window-layout-3+)
           ;; (codepilot-remove-xref-if-proper buf bottom-win)
           (select-window code-win)
           (switch-to-buffer buf))
          (otherwise
           (other-window 1)
           (switch-to-buffer buf)))))))



(defvar codepilot-hl-text-overlay nil)
(make-variable-buffer-local 'codepilot-hl-text-overlay)


(defface codepilot-hl-text-face
  '((default (:inherit region)) (((class color)) (:background "yellow" :foreground "black")))
  "*Font used by folding overlay."
  :group 'codepilot)


(defun codepilot-hl-text (beg end)
  ""
  ;; (cond (codepilot-hl-text-overlay
  ;;        (move-overlay codepilot-hl-text-overlay beg end)
  ;;        )
  ;;       (t
  ;;        (setq codepilot-hl-text-overlay (make-overlay beg end))
  ;;        ;; (overlay-put codepilot-hl-text-overlay 'face 'codepilot-hl-text-face)
  ;;        ;; (overlay-put codepilot-hl-text-overlay 'priority 1001)
  ;;        ))
  (when codepilot-hl-text-overlay
    (delete-overlay codepilot-hl-text-overlay)
    )
  (setq codepilot-hl-text-overlay (make-overlay beg end))
  )


(defvar codepilot-current-search-text "")
(make-variable-buffer-local 'codepilot-current-search-text)
(defvar codepilot-current-search-type 'id)
(make-variable-buffer-local 'codepilot-current-search-type)


(require 'which-func)

(defvar inhibit-which-func-update nil)
(defvar inhibit-codepilot-highlight-2 nil)
(defvar inhibit-codepilot-hl-text nil)


(defvar codepilot-search-and-hl-text-func nil)

(defun codepilot-search-and-hl-text (text &optional backward search-type class-id)
  ""
  (when codepilot-search-and-hl-text-func
    (funcall codepilot-search-and-hl-text-func text backward search-type class-id)))

(defun codepilot-search-hl-again-f ()
  ""
  (interactive)
  (if (/= 0 (length codepilot-current-search-text))
      (progn
        (cond (codepilot-hl-text-overlay
               (if (= (point) (overlay-start codepilot-hl-text-overlay))
                   (forward-char)))
              (t
               (forward-line 0)))

        (let ((inhibit-codepilot-highlight-2 t))
          (cond ((codepilot-search-and-hl-text codepilot-current-search-text nil
                                            codepilot-current-search-type)
                 (overlay-put codepilot-hl-text-overlay 'face 'codepilot-hl-text-face)
                 (overlay-put codepilot-hl-text-overlay 'priority 1001)
                 t)
                (t
                 (message "Reach the end.")
                 nil))))
      (message (concat "Search text not set." codepilot-current-search-text "???"))
      nil))

(defun codepilot-search-hl-again-b ()
  ""
  (interactive)
  (if (/= 0 (length codepilot-current-search-text))
      (progn
        (cond (codepilot-hl-text-overlay)
              (t
               (end-of-line)))

        (let ((inhibit-codepilot-highlight-2 t))
          (cond ((codepilot-search-and-hl-text codepilot-current-search-text t
                                            codepilot-current-search-type)
                 (overlay-put codepilot-hl-text-overlay 'face 'codepilot-hl-text-face)
                 (overlay-put codepilot-hl-text-overlay 'priority 1001)
                 t)
                (t
                 (message "Reach the file start.")
                 nil))))
    (message "Search text not set.")
    nil))

(defun codepilot-search-hi (text)
  ""
  (interactive
   (list
    (let ((cur (current-word)))
      (read-string
       (concat "Search id" (if cur (concat " (default " cur ")") "") ": ")
      nil nil cur))))
  (codepilot-search-hi-1 text "id"))

(defun codepilot-search-hi-1 (text type)
  ""
  (interactive
   (list
    (let ((cur (current-word)))
      (read-string
       (concat "Search text" (if cur (concat " (default " cur ")") "") ": ")
      nil nil cur))

;;     (let ((cur (symbol-name codepilot-current-search-type)))
;;       (read-string
;;        (concat "Search type" (if cur (concat " (default " cur ")") "") ": ")
;;       nil nil cur))

    (completing-read "Search type: ([id|comment|string|literal]): "
                     '("id" "comment" "string" "literal") nil t "id")))

  (when (= 0 (length text))
    (error "Search string is empty!!!"))

  (unless (looking-at "\\_<")
    (re-search-backward "\\_<" nil t))

  (setq codepilot-current-search-type
        (cond ((string= type "id")
               'id)
              ((string= type "comment")
               'comment)
              ((string= type "string")
               'string)
              ((string= type "literal")
               'literal)
              (t
               codepilot-current-search-type)))
  (unless (codepilot-search-and-hl-text text nil codepilot-current-search-type)
    (message "Search failed.")))

(defun codepilot-search-hi-string (text)
  (interactive
   (list
    (let ((cur (current-word)))
      (read-string
       (concat "Search text" (if cur (concat " (default " cur ")") "") ": ")
      nil nil cur))))
  (codepilot-search-hi-1 text "string"))

(defun cptree-ov-delete ()
  ""
  (interactive)
  (dolist (o (overlays-at (point)))
    (cptree-delete-overlay o 'cptree))
  t)

(defvar cptree--overlay-keymap nil "keymap for folding overlay")

(unless cptree--overlay-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-1] 'cptree-ov-delete)
    (define-key map "\r" 'cptree-ov-delete)
    (setq cptree--overlay-keymap map)))


(defun cptree-delete-overlay(o prop)
  ""
  (when (eq (overlay-get o 'cptree-tag) prop)
    (delete-overlay o) t
    ))

(defun cptree-point-at-fold-p (pos)
  (catch 'loo
    (dolist (o (overlays-at pos))
      (when (eq (overlay-get o 'cptree-tag) 'cptree)
        (throw 'loo t)))))


(defun cptree-hide-region (from to prop)
  "Hides a region by making an invisible overlay over it and save the
overlay on the hide-region-overlays \"ring\""
  (interactive)
  (let ((new-overlay (make-overlay from to)))
    ;;(overlay-put new-overlay 'invisible nil)
    (overlay-put new-overlay 'cptree-tag prop)
    (overlay-put new-overlay 'face 'codepilot-folding-overlay)
    (overlay-put new-overlay 'display
                 (propertize
                  (format "%s<%d lines>%s"
                           my-hide-region-before-string
                          (1- (count-lines (overlay-start new-overlay)
                                           (overlay-end new-overlay)))
                          my-hide-region-after-string)))
    (overlay-put new-overlay 'priority (- 0 from))
    (overlay-put new-overlay 'keymap cptree--overlay-keymap)
    (overlay-put new-overlay 'pointer 'hand)))


(defun cptree-unfold-all()
  ""
  (interactive)
  (save-excursion
    (dolist (o (overlays-in (point-min) (point-max)))
      (cptree-delete-overlay o 'cptree))))


(defun codepilot-at-tagged-overlay-p (pos tag)
  (catch 'loo
    (dolist (o (overlays-at pos))
      (when (eq (overlay-get o 'tag) tag)
        (throw 'loo t)))))

;;
(require 'image)
(defimage codepilot-image-directory
  ((:type xpm :file "ppcmm/dir.xpm" :ascent center))
  "Image used for directories.")

(defimage codepilot-image-page
  ((:type xpm :file "ppcmm/page.xpm" :ascent center))
  "Image used for files.")

(defimage codepilot-image-bucket
  ((:type xpm :file "ppcmm/ecb-function-bucket.xpm" :ascent center))
  "Image used for bucket.")

(defimage codepilot-image-item
  ((:type xpm :file "ppcmm/ecb-function-unknown.xpm" :ascent center))
  "Image used for item.")

(defimage codepilot-image-bucket-1
  ((:type xpm :file "ppcmm/ecb-variable-bucket.xpm" :ascent center))
  "Image used for bucket.")



;; deal with desktop
(require 'desktop)
(pushnew 'cplist-side-window-size desktop-globals-to-save)
(pushnew 'cpimenu-show-with-cplist desktop-globals-to-save)
(pushnew 'cpimenu-win-height desktop-globals-to-save)

(provide 'cp-base)

