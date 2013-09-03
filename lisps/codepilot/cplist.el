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

(require 'cphistory)
(require 'cp-layout)
(require 'cp-base)
(require 'cpfilter)

(defvar cplist-line-number-saved 0)
(defvar cplist-text-selected "")

(defvar cplist-type 'all)

(defvar cplist-mode-syntax-table nil
  "Syntax table in use in CPXREF buffers.")

(unless cplist-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?$ "w" table)
    (modify-syntax-entry ?. "." table)
    (setq cplist-mode-syntax-table table)))


(defvar cplist-mode-map nil
  "keymap for cplist mode")

(unless cplist-mode-map
  (let ((map (make-sparse-keymap)))
    (setq cplist-mode-map map)))

(defun cplist-mode ()
  ""
  (interactive)
  (if (eq major-mode 'cplist-mode)
      ()
    (kill-all-local-variables)
    (setq major-mode 'cplist-mode)
    (setq mode-name "CPList")
    (use-local-map cplist-mode-map)
    (set-syntax-table cplist-mode-syntax-table)
    (setq case-fold-search t)
    (cplist-font-lock-setup)
    (setq buffer-read-only t)
    (run-mode-hooks 'cplist-mode-hook)))


(defun cplist-font-lock-setup ()
  (make-local-variable 'font-lock-keywords-case-fold-search)
  (setq font-lock-keywords-case-fold-search t)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(cplist-font-lock-keywords t)))

(defface cplist-item-face
  '((default (:inherit font-lock-type-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)

(defface cplist-dir-face
  '((default (:inherit font-lock-keyword-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)


(defface cplist-head-face
  '((default (:inherit font-lock-warning-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)


(defvar cplist-font-lock-keywords
  (list

   ;; (list "^[a-zA-Z ] \\(.+\\)$"
   ;;       '(1 'cplist-item-face)
   ;;       )


   (list "^ +\\(.+?\\) \\(\\[.+?\\]\\)$"
         '(1 'cplist-item-face)
         '(2 'cplist-dir-face))
   
   (list "^ +\\(.+\\)$"
         '(1 'cplist-item-face))
   (list "@ \\(.+\\)$"
         '(1 'cplist-head-face))
   (list "\\[.+?\\]"
         '(0 'link)))
  
  "font-lock keywords setting for cpxref buffers.")


(defvar cplist-action-func nil)

(defun cplist-action ()
  "will be overrided by various impls."
  (interactive)
  (when cplist-action-func
    (funcall cplist-action-func)))

(defun cplist-mouse-click (event)
  (interactive "e")
  (mouse-set-point event)
  (cplist-action))

(defun cplist-enter ()
  (interactive)
  (cplist-action))

(defun cplist-mark-for-delete ()
  ""
  (interactive)
  (let ((case-fold-search t)
        (inhibit-read-only t)
        (buffer-undo-list t))
    (save-match-data
      (forward-line 0)
      (when (looking-at "[A-Za-Z ] ")
        (replace-match "D " nil t)
        (forward-line)))
    (set-buffer-modified-p nil)))

(defun cplist-unmark ()
  ""
  (interactive)
  (let ((case-fold-search t)
        (inhibit-read-only t)
        (buffer-undo-list t))
    (save-match-data
      (forward-line 0)
      (when (looking-at "[A-Za-Z] ")
        (replace-match "  " nil t))
      (forward-line))
    (set-buffer-modified-p nil)))

(defun cplist-mark-all-for-delete ()
  ""
  (interactive)
  (cplist-update)
  (let ((case-fold-search t)
        (inhibit-read-only t)
        (buffer-undo-list t))
    (save-match-data
      (goto-char (point-min))
      (when (re-search-forward "^@" nil t)
        (while (re-search-forward "^[A-Za-Z ] " nil t)
          (replace-match "D " nil t)
          (forward-line))))
    (set-buffer-modified-p nil)))

(defun cplist-kill-del-mark-lines (b e &optional sec-list)
  (let (n)
    (setq n (if sec-list 0 1))
    (save-excursion
      (save-match-data
        (with-modify-in-readonly
            (goto-char b)
          (while (re-search-forward "^D \\(.+\\)$" nil t)
            (delete-region (line-beginning-position n) (line-beginning-position 2))))))))


;; (defcustom cplist-side-window-default-size 38
;;   "*Size of cplist side window."
;;   :type 'integer
;;   :group 'codepilot)

(defvar cplist-side-window-size 38)
;(setq cplist-side-window-size cplist-side-window-default-size)

(defvar cplist-query-sort-type 'create)
(defvar cplist-section-sort-type 'last)

(defun cplist-del-dedicated-win ()
  (dolist (w (window-list))
    (when (window-dedicated-p w)
      (condition-case nil
          (delete-window w)
        (error
         (set-window-dedicated-p w nil))))))

(defun cplist-side-window ()
  ""
  (interactive)
  (let (win edges width)
    (if (setq win (get-buffer-window cplist-buf-name))
        ;; (delete-window win)
        (progn
          (setq edges (window-edges win))
          (setq width (- (nth 2 edges) (nth 0 edges)))

          (unless (= width window-min-width)
            (cplist-save-current-list-win-size))

          (run-hooks 'cplist-win-del)
          ;; (kill-buffer cplist-buf-name)
          (cplist-del-dedicated-win))

      (cplist-del-dedicated-win)

      (unless (one-window-p :nomin)
        (delete-other-windows))

      (condition-case nil
          (split-window nil cplist-side-window-size t)
        (error
         (split-window-horizontally)))
      (cplist-update)
      (switch-to-buffer cplist-buf-name)
      (setq buffer-read-only t)
      (cplist-mode)
      (run-hooks 'cplist-turn-on-mode-hook)
      (set-window-dedicated-p (selected-window) t)
      (run-hooks 'cplist-win-added))))

(defun cplist-update ()
  ""
  (interactive)
  (let ((buf (get-buffer-create cplist-buf-name))
        win)
    (with-current-buffer buf
      (with-modify-in-readonly
        (erase-buffer)

        ;; Call the hooks to fill the contents.
        (run-hooks 'cplist-fill-contents-hook)
        
        (goto-char (point-min))
        (cpfilter-add-edit-entry-field)
        (setq win (get-buffer-window cplist-buf-name))
        (when win
          (select-window win))))))


(define-key cplist-mode-map [mouse-3] 'cplist-mouse-click)
(define-key cplist-mode-map "g" 'cplist-update)

(define-key cplist-mode-map "d" 'cplist-mark-for-delete)
(define-key cplist-mode-map "u" 'cplist-unmark)
(define-key cplist-mode-map "x" 'cplist-do-kill-on-deletion-marks)

;; (define-key cplist-mode-map "s" 'cplist-sort-query-by-create)

(define-key cplist-mode-map "\r" 'cplist-enter)

(define-key cplist-mode-map "8" 'msym-show-ref)
(define-key cplist-mode-map "D" 'msym-goto-def-nosection)
(define-key cplist-mode-map "Q" 'msym-goto-imp-nosection)

(define-key cplist-mode-map "p" 'codepilot-query-proc)
(define-key cplist-mode-map "i" 'codepilot-query-id)
(define-key cplist-mode-map "o" 'codepilot-query-sym)
(define-key cplist-mode-map "l" 'codepilot-query-string)
(define-key cplist-mode-map "c" 'codepilot-query-comment)
(define-key cplist-mode-map "t" 'codepilot-query-patch)
(define-key cplist-mode-map "m" 'codepilot-query-module)
(define-key cplist-mode-map "n" 'codepilot-query-section)

(define-key cplist-mode-map "P" 'codepilot-query-proc-dim)
(define-key cplist-mode-map "I" 'codepilot-query-id-dim)
(define-key cplist-mode-map "O" 'codepilot-query-sym-dim)

(define-key cplist-mode-map "a" 'codepilot-open-calltrack)
(define-key cplist-mode-map "`" 'cplist-minimize/restore-sidebar)


(global-set-key [(f8)] 'cplist-side-window)


(defun cplist-mode-del-window ()
  ""
  (interactive)
  (let ((win (get-buffer-window cplist-buf-name)))
    (when win
      (delete-window win))))

(defun cplist-list-buffer (mode)
    (let (mm)
    (dolist (b (buffer-list))
      (setq mm (with-current-buffer b major-mode))
      (when (eq mm mode)
        (insert "  " (concat (buffer-name b) "\n")))))
  (insert "\n"))

(defun cplist-sort-query-list-by-name ()
  ""
  (interactive)
  (let ((case-fold-search t)
        beg end
        (inhibit-read-only t)
        (buffer-undo-list t))
    (save-excursion
      (save-match-data
        (goto-char (point-min))
        (forward-line)
        (forward-line)
        (setq beg (point))
        (setq end beg)
        (when (re-search-forward "^$" nil t)
          (setq end (point)))
        (unless (= beg end)
          (sort-lines nil beg end))
        (setq cplist-query-sort-type 'name)))
    (set-buffer-modified-p nil)))

(defun cplist-sort-query-by-id-name ()
  ""
  (interactive)
  (let ((case-fold-search t)
        beg end
        (inhibit-read-only t)
        (buffer-undo-list t))
    (save-excursion
      (save-match-data
        (goto-char (point-min))
        (forward-line)
        (forward-line)
        (setq beg (point))
        (setq end beg)
        (when (re-search-forward "^$" nil t)
          (setq end (point)))
        (unless (= beg end)
          (sort-fields 2 beg end))
        (setq cplist-query-sort-type 'id-name)))
    (set-buffer-modified-p nil)))



(defun cplist-save-current-list-win-size ()
  ""
  (interactive)
  (let ((win (get-buffer-window cplist-buf-name))
        edges)
    (if win
        (progn
          (setq edges (window-edges win))
          (setq cplist-side-window-size (- (nth 2 edges) (nth 0 edges))))
      (error "No IDList buffer now."))))



(defmacro cplist-sort-frame (section-start-regexp section-end-regexp variable mode mylist &rest body)
  (let ((tempvar (make-symbol "--cl-var--"))
        (tempbeg (make-symbol "--cl-beg--"))
        (tempend (make-symbol "--cl-end--"))
        (tempbuf (make-symbol "--cl-buf--"))
        )
    `(let ((case-fold-search t)
           ,tempbeg ,tempend ,tempvar
           (inhibit-read-only t)
           (buffer-undo-list t)
           ,mylist)
       (save-excursion
         (save-match-data
           (goto-char (point-min))
           (when (re-search-forward ,section-start-regexp nil t)
             (forward-line)
             (setq ,tempbeg (point))
             (setq ,tempend ,tempbeg)

             (when (re-search-forward ,section-end-regexp nil t)
               (setq ,tempend (point)))
             (unless (= ,tempbeg ,tempend)
               (delete-region ,tempbeg ,tempend))

             (dolist (,tempbuf (buffer-list))
               (when (eq (with-current-buffer ,tempbuf
                           ,(if variable
                                `(setq ,tempvar ,variable)
                              ())
                           major-mode)
                         ,mode)
                 (push
                  ,(if variable
                       `(cons ,tempvar (buffer-name ,tempbuf))
                     `(buffer-name ,tempbuf))
                  ,mylist)))
             ,@body
             (set-buffer-modified-p nil)))))))



(defun cplist-minimize/restore-sidebar ()
  (interactive)
  (let ((buf (get-buffer cplist-buf-name))
        swin
        edges width)
    (if buf
      (save-selected-window
        (setq swin (get-buffer-window (get-buffer cplist-buf-name)))
        (select-window swin)
        (setq edges (window-edges swin))
        (setq width (- (nth 2 edges) (nth 0 edges)))

        (if (= width window-min-width)
            (enlarge-window-horizontally (- cplist-side-window-size width))
          (setq cplist-side-window-size width)
          (shrink-window-horizontally (- width window-min-width))))
      (cplist-side-window))))


(provide 'cplist)

