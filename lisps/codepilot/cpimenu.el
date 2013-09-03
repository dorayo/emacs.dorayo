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


(require 'cl)

(require 'cp-mark)
(require 'cpfilter)
(require 'cplist)

;; ======= imenu relate ============

;; imenu--sort-by-name
;; (sort (copy-sequence menulist) imenu-sort-function)

(defvar cpimenu-sort-method nil)

(defvar cpimenu-buf-name "*CPImenu*")

(defvar cpimenu-refresh-func 'cpimenu)

(defun cpimenu--sort-by-position-ov (item1 item2)
  ;;(< (overlay-start (cdr item1)) (overlay-start (cdr item2)))
  )

(defsubst cpimenu-output-item (prefix-str ii)
  (insert prefix-str)
  (insert-image codepilot-image-item " ") ;; brian test
  (insert " " (car ii))

  (put-text-property (line-beginning-position) (line-end-position)
                     'cpimenu-target (if (integerp (cdr ii))
                                         (cdr ii)
                                         (if (overlayp (cdr ii))
                                             (overlay-start (cdr ii))
                                             (marker-position (cdr ii)))))
  
  (insert "\n"))

(defun output-imenu-alist (ilist &optional prefix-str cedet?)
  ""
  (let (pos ll ll2 ind ll3
            block-start
            (cpimenu--sort-by-position-fn
             (cond (cedet? 
                    'cpimenu--sort-by-position-ov)
                   (t
                    'imenu--sort-by-position))))
    (setq ll ilist)

    (unless prefix-str
      (setq prefix-str " "))

    (dolist (ii ll)
      (when (consp ii)
        (cond ((listp (cdr ii))
               (insert prefix-str)
               (insert-image codepilot-image-bucket "@") ;; brian test
               (insert " " (car ii) "  \n")
               (setq block-start (1- (point)))

               (setq ii (cdr ii))

               (output-imenu-alist ii (concat prefix-str " ") cedet?)

               (put-text-property block-start (1+ block-start)
                                  'cpimenu-block-end (point)))
              (t
               (cond (cpimenu-sort-method
                      (push ii ll2))
                     (t
                      (cpimenu-output-item prefix-str ii)))))))
    (when  ll2
      (cond ((eq cpimenu-sort-method :position)
             (setq ll2 (sort ll2 cpimenu--sort-by-position-fn))
             )
            ((eq cpimenu-sort-method :name)
             (setq ll2 (sort ll2 #'imenu--sort-by-name)))
            (t
             (setq ll2 (nreverse ll2))))

      (dolist (ii ll2)
        (cpimenu-output-item prefix-str ii)))
    (insert "\n")))

(defun cpimenu-rescan ()
  (imenu--cleanup)
  ;; Make sure imenu-update-menubar redoes everything.
  (setq imenu-menubar-modified-tick -1)
  (setq imenu--index-alist nil)
  (setq imenu--last-menubar-index-alist nil)
  (imenu-update-menubar)
  t)


(defface cpimenu-function-face
    '((default (:inherit font-lock-function-name-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)

(defface cpimenu-keyword-face
    '((default (:inherit font-lock-keyword-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)

(defface cpimenu-head-face
    '((default (:inherit font-lock-warning-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)

(defface cpimenu-info-face
    '((default (:inherit font-lock-type-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)

(defface cpimenu-note-face
    '((default (:inherit font-lock-variable-name-face)))
  "To highlight cplist, cptree, msym buffer."
  :group 'codepilot)


(defvar cpimenu-font-lock-keywords
  (list

   (list "^ +\\(operator\\) \\([^ ]+\\) \\((.*$\\)"
         '(1 'cpimenu-note-face)
         '(2 'cpimenu-function-face)
         '(3 'cpimenu-info-face))
   
   (list "\\((.*$\\)"  ; (....
         '(1 'cpimenu-info-face))

   (list "^[ ]*\\([^ )\n]+\\)$"
         '(1 'cpimenu-keyword-face))

   (list "^[ ]*\\([^ )[\n]+\\) *\\(\\[.*?\\]\\) ?("
         '(1 'cpimenu-function-face)
         '(2 'cpimenu-note-face))

   (list "^[ ]*\\([^ )[\n]+\\) *\\(\\[.*?\\]\\)"
         '(1 'cpimenu-keyword-face)
         '(2 'cpimenu-note-face))
   
   (list "^[ ]*\\([^)\n]+\\) ?("
         '(1 'cpimenu-function-face))

   (list "@ \\(.+\\)\\(|.+|\\)"
         '(1 'cpimenu-head-face)
         '(2 'cpimenu-info-face))
   
   (list "@ \\(.+\\)$"
         '(1 'cpimenu-head-face))

   (list "^ +\\(.+\\)\\(|.+|\\)"
         '(1 'cpimenu-keyword-face)
         '(2 'cpimenu-info-face))

   (list "\\[.+?\\]"
         '(0 'link)))
  
  "font-lock keywords setting for cpxref buffers.")

(defun cpimenu-font-lock-setup ()
  (make-local-variable 'font-lock-keywords-case-fold-search)
  (setq font-lock-keywords-case-fold-search t)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(cpimenu-font-lock-keywords t)))


(defvar cpimenu-mode-map nil
  "keymap for cplist mode")

(unless cpimenu-mode-map
  (let ((map (make-sparse-keymap)))
    (setq cpimenu-mode-map map)))

(defvar cpimenu-connected-buffer "")
(defvar cpimenu-need-update-due-to-parse-delay nil)

(defun cpimenu-mode ()
  "Put the current buffer into cpimenu mode"
  (interactive)
  (if (eq major-mode 'cpimenu-mode)
      ()
    (kill-all-local-variables)
    (make-local-variable 'cpimenu-connected-buffer)
    (make-local-variable 'cpimenu-need-update-due-to-parse-delay)
    (setq major-mode 'cpimenu-mode)
    (setq mode-name "CP IMenu")
    (use-local-map cpimenu-mode-map)
    (setq case-fold-search t)
    (cpimenu-font-lock-setup)
    (toggle-truncate-lines 1)
    (run-mode-hooks 'cpimenu-mode-hook)))


(defvar cpimenu-hl-text-overlay nil)
(make-variable-buffer-local 'cpimenu-hl-text-overlay)

(defface cpimenu-hl-text-face
  '((default (:inherit region))
    (((class color) (background light)) (:background "DarkOliveGreen2"))
    (((class color) (background dark)) (:background "SeaGreen" :foreground "white")))
  "*Font used by folding overlay."
  :group 'cpimenu)



(defun cpimenu-hl-text (beg end)
  ""
  (unless cpimenu-hl-text-overlay
    (setq cpimenu-hl-text-overlay (make-overlay 1 1)) ; to be moved
    (overlay-put cpimenu-hl-text-overlay 'face 'cpimenu-hl-text-face)
    (overlay-put cpimenu-hl-text-overlay 'priority 1001))
  (move-overlay cpimenu-hl-text-overlay beg end))

(defun cpimenu-unhl-text (o)
  (when o
    (move-overlay o 0 0)))

(defun cpimenu-click (e)
  (interactive "e")
  (mouse-set-point e)
  (cpimenu-action))

(defun cpimenu-action ()
  (interactive)
  (let (pos buf-name to col b-end cw
            (refresh-fn cpimenu-refresh-func))
    (setq col (current-column))
    (setq cw (current-word))
    (forward-line 0)
    (setq buf-name cpimenu-connected-buffer)
    (cond ((bobp))
          ((looking-at "^\\[\\*Rescan")
           (cond ((string= cw "*Rescan*")
                  ;; rescant!
                  (when (get-buffer buf-name)
                    (save-selected-window
                      (codepilot-switch-to-buffer buf-name)
                      (cpimenu-rescan)
                      (funcall refresh-fn))))
                 ((string= cw "Name")
                  ;; sort by name
                  (when (get-buffer buf-name)
                    (save-selected-window
                      (codepilot-switch-to-buffer buf-name)
                      (let ((cpimenu-sort-method :name))
                        (funcall refresh-fn)))))
                 ((string= cw "Pos")
                  (when (get-buffer buf-name)
                    (save-selected-window
                      (codepilot-switch-to-buffer buf-name)
                      (let ((cpimenu-sort-method :position))
                        (funcall refresh-fn)))))
                 ((string= cw "Ctags")
                  (with-current-buffer buf-name
                    (if (myctags-effected-modes? major-mode)
                        (progn
                          (myctags-set-create-index-function)
                          (cpimenu-rescan)
                          (funcall refresh-fn))
                      (message "The major mode is not supported by Ctags."))))
                 ((string= cw "Cedet")
                  (with-current-buffer buf-name
                    (if (assq major-mode semantic-new-buffer-setup-functions)
                      (progn
                        (setq imenu-create-index-function 'semantic-create-imenu-index)
                        (remove-hook 'which-func-functions 'cc-which-func t)
                        (cpimenu-rescan)
                        (funcall refresh-fn))
                      (message "The major mode is not supported by semantic."))))))
          ((setq b-end
                 (get-text-property (line-end-position) 'cpimenu-block-end))
           ;; fold/unfold it.
           (end-of-line)
           (cpimenu-toggle-folding))
          
          ((looking-at "^[ \t]*$"))
          (t
           (when (setq to (get-text-property (point) 'cpimenu-target))
             (when (get-buffer buf-name)
               (cpimenu-hl-text (point) (line-end-position))
               (progn
                 (codepilot-pop-or-switch-buffer buf-name :cpimenu)
                 (push-mark (point) t)
                 (goto-char to)
                 (codepilot-highlight-one-line))))))))


(defun cpimenu-fold ()
  "fold or unload the group."
  (interactive)
  (let (pos (loo t) e str)
    (save-excursion
      (save-match-data
        (setq pos (line-end-position))
        (while (and loo (re-search-backward "@" nil t))
          (cond ((> (setq e (get-text-property (line-end-position) 'cpimenu-block-end)) pos)
                 ;; ok. my head.
                 (setq loo nil)
                 (cptree-hide-region (line-end-position) e 'cptree)
                 (when (> (window-start) (point))
                   (let ((current-prefix-arg 4)) (call-interactively 'recenter)))
                 (skip-chars-forward " @")
                 (setq str (buffer-substring-no-properties (point)
                                                           (line-end-position)))
                 (message str))))))))


(defun cpimenu-unfold ()
  (interactive)
  (let (ret str pos)
    (dolist (o (overlays-at (line-end-position)))
      (setq pos (overlay-start o))
      (when (cptree-delete-overlay o 'cptree)
        (setq ret t)
        (save-excursion
          (goto-char pos)
          (forward-line 0)
          (skip-chars-forward " @")
          (setq str (buffer-substring-no-properties (point)
                                                    (line-end-position)))
          (message str))))
    ret))

(defun cpimenu-toggle-folding ()
  (interactive)
  (let ((case-fold-search t))
    (unless (cpimenu-unfold)
      (cpimenu-fold))))

(defun cpimenu-fold-all ()
  (interactive)
  (cpimenu-unfold-all)
  (let (e)
    (save-match-data
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "@" nil t)
          (when (setq e (get-text-property (line-end-position) 'cpimenu-block-end))
            (cptree-hide-region (line-end-position) e 'cptree)))
        (goto-char (point-min))
        (let ((current-prefix-arg 4)) (call-interactively 'recenter))))))

(defun cpimenu-unfold-all ()
  "Document string:"
  (interactive)
  (dolist (o (overlays-in (point-min) (point-max)))
    (cptree-delete-overlay o 'cptree)))

(defalias 'cpimenu-unfold-all 'cptree-unfold-all)



(defun cpimenu-goto-next-visible-tagline ()
  (forward-line)
  (while (and (not (eobp))
              (or (not (get-text-property (point) 'cpimenu-target)) ;; no target
                  (let ((ol (overlays-at (point)))) ;; in overlay. invisible.
                    (and ol
                         (some #'(lambda (o)
                                   (eq 'cpfilter (overlay-get o 'tag)))
                               ol)))))
    (forward-line))
  (unless (eobp)
    t))

(defun cpimenu-tab ()
  (interactive)

  (let (pos)
    (save-excursion
      (when (cpimenu-goto-next-visible-tagline)
        (setq pos (point))))
    (cond (pos
           (goto-char pos)
           t)
          (t
           (save-excursion
             (goto-char (point-min))
             (forward-line) ;; skip the cpfilter line
             (when (cpimenu-goto-next-visible-tagline)
               (setq pos (point))))
           (when pos
             (goto-char pos)
             t)))))


(defun cpimenu-go ()
  (interactive)
  (unless (get-buffer-window cpimenu-buf-name)
      (cpimenu))
  (let (win)
    (when (setq win (get-buffer-window cpimenu-buf-name))
      (select-window win)
      (goto-char (point-min))
      (cpfilter-erase))))

(defvar cplist-side-window-size 38)

(defvar cpimenu-win-height 20)

(defun cpimenu-show-buffer (buf)
  (cond ((get-buffer-window cpimenu-buf-name))
        (t
         (multiple-value-bind (ret sidebar code-win bottom-win)
             (codepilot-window-layout-wise)
           (cond (sidebar
                  (condition-case nil
                      (progn
                        ;; (split-window nil (* 7 (/ (window-width) 9)) t)
                        ;; (save-selected-window
                        ;;   (other-window 1)
                        ;;   (switch-to-buffer buf)
                        ;;   (set-window-dedicated-p (selected-window) t)
                        ;;   )
                        (save-selected-window
                          (select-window sidebar)
                          (condition-case nil
                              (split-window-vertically (- cpimenu-win-height))
                            (error
                             (split-window-vertically)))
                          (other-window 1)
                          (switch-to-buffer buf)
                          (set-window-dedicated-p (selected-window) t)))
                    (error
                     (pop-to-buffer buf)
                     (shrink-window-if-larger-than-buffer (get-buffer-window cpimenu-buf-name)))))
                 (t
                  (case ret
                    ((:window-layout-1)
                     (split-window nil cplist-side-window-size t)
                     (switch-to-buffer buf)
                     (set-window-dedicated-p (selected-window) t)
                     (other-window 1))
                    (otherwise
                     (display-buffer buf)
                     (shrink-window-if-larger-than-buffer (get-buffer-window cpimenu-buf-name))))))))))

(defun cpimenu-toggle-cpimenu-win ()
  (interactive)
  (let (buf win)
    (save-selected-window
      (cond ((setq win (get-buffer-window cpimenu-buf-name))
             (setq cpimenu-win-height (window-height win))
             (setq cpimenu-show-with-cplist nil)
             (delete-window win))
            (t
             (setq buf (get-buffer-create cpimenu-buf-name))
             (setq buffer-read-only t)
             (setq cpimenu-show-with-cplist t)
             (cpimenu-show-buffer buf))))))

(defun cpimenu-del-win-in-me ()
  (interactive)
  (setq cpimenu-win-height (window-height))
  (delete-window))


(defvar cpimenu-show-with-cplist t)

(defun cpimenu-when-cplist-win-del ()
  (let (win)
    (cond ((setq win (get-buffer-window cpimenu-buf-name nil))
           (setq cpimenu-win-height (window-height win))
           ;; (setq cpimenu-show-with-cplist t)
           ;; (kill-buffer cpimenu-buf-name)
           )
          (t
           ;;(setq cpimenu-show-with-cplist nil)
           ))))

(defun cpimenu-when-cplist-win-added ()
  (when cpimenu-show-with-cplist
    (let (buf)
      (setq buf (get-buffer-create cpimenu-buf-name))
      (cpimenu-show-buffer buf))))

(defsubst cpimenu-output (buf-name ilist cedet?)
  (let (pos)
    (with-modify-in-readonly
        (save-excursion
          (erase-buffer)
          (insert "[*Rescan*] [Ctags] [Cedet] [Name] [Pos]" )
          (insert "\n\n")
          (cpimenu-mode)
          (setq cpimenu-connected-buffer "")
          (when (car ilist)
            (output-imenu-alist ilist nil cedet?))
          (setq cpimenu-connected-buffer buf-name)
          (goto-char 1)
          (cpfilter-add-edit-entry-field)))))

(defun cpimenu ()
  (interactive)
  (let ((buf-name (buffer-name))
        (ilist (cdr (imenu--make-index-alist t)))
        (mj-mode major-mode)
        buf
        (cedet? (and (featurep 'semantic) (semantic-active-p))) ;; semantic--buffer-cache
        )
    (setq buf (get-buffer-create cpimenu-buf-name))
    (set-buffer buf)
    (setq buffer-read-only t)
    (make-local-variable 'cpimenu-refresh-func)
    (setq cpimenu-refresh-func 'cpimenu)
    (cpimenu-output buf-name ilist cedet?)
    (cpimenu-show-buffer buf)))

(defvar cpimenu-return-pos nil)

(defun cpimenu-semantic-which-func-and-pos ()
  ;; assume the semantic is enabled for the buffer
  (let ((taglist (semantic-find-tag-by-overlay)))
    (when taglist
      (let* ((name (semantic-default-which-function taglist))
             (cur-tag (car (nreverse taglist))))
        (cons name (overlay-start (nth 4 cur-tag)))))))

(defun cpimenu-which-func (&optional taglist) ;; =ToSync= with which-func.el
  (let (name pos win buf-name update? ooo (tree-updated? t))
    (cond ((and (featurep 'semantic) (semantic-active-p))
           (if (setq ooo (cpimenu-semantic-which-func-and-pos))
               (progn
                 (setq pos (cdr ooo))
                 (setq name (car ooo)))
             (setq tree-updated? (semantic-parse-tree-up-to-date-p))))
          (t
           ;; If Imenu is loaded, try to make an index alist with it.
           (when (and (boundp 'imenu--index-alist) (null imenu--index-alist)
                      (null which-function-imenu-failed))
             (imenu--make-index-alist t)
             (unless imenu--index-alist
               (make-local-variable 'which-function-imenu-failed)
               (setq which-function-imenu-failed t)))
           ;; If we have an index alist, use it.
           (when (and (boundp 'imenu--index-alist) imenu--index-alist)
             (let ((alist imenu--index-alist)
                   (minoffset (point-max))
                   offset pair mark imstack namestack)
               ;; Elements of alist are either ("name" . marker), or
               ;; ("submenu" ("name" . marker) ... ). The list can be
               ;; arbitrarily nested.
               (while (or alist imstack)
                 (if alist
                     (progn
                       (setq pair (car-safe alist)
                             alist (cdr-safe alist))

                       (cond ((atom pair)) ; skip anything not a cons

                             ((imenu--subalist-p pair)
                              (setq imstack   (cons alist imstack)
                                    namestack (cons (car pair) namestack)
                                    alist     (cdr pair)))

                             ((number-or-marker-p (setq mark (cdr pair)))
                              (if (>= (setq offset (- (point) mark)) 0)
                                  (if (< offset minoffset) ; find the closest item
                                      (setq minoffset offset
                                            pos (cdr pair)
                                            name (funcall
                                                  which-func-imenu-joiner-function
                                                  (reverse (cons (car pair)
                                                                 namestack))))
                                    ;; Entries in order, so can skip all those after point.
                                    ;; (setq elem nil) ;; brian!!! TODO

                                    )))))
                   (setq alist     (car imstack)
                         namestack (cdr namestack)
                         imstack   (cdr imstack))))))

           ;; Try using add-log support.
           (when (and (null name) (boundp 'add-log-current-defun-function)
                      add-log-current-defun-function)
             (setq name (funcall add-log-current-defun-function)))
           ;; Filter the name if requested.
           (when name
             (setq name
                   (if which-func-cleanup-function
                       (funcall which-func-cleanup-function name)
                     name)))))
    

    (setq buf-name (buffer-name))
    (when (setq win (get-buffer-window cpimenu-buf-name))
      (with-current-buffer cpimenu-buf-name
        (goto-char (point-min))
        (cond ((and (not cpimenu-need-update-due-to-parse-delay)
                    (string= buf-name cpimenu-connected-buffer))
               nil)
              ((not tree-updated?)
               (make-local-variable 'cpimenu-need-update-due-to-parse-delay)
               (setq cpimenu-need-update-due-to-parse-delay t)
               (setq update? t)
               (message "Wait for semantic parsing!"))
              (t
               (setq update? t)
               (message "CPImenu update!")))
        (when tree-updated?
          (make-local-variable 'cpimenu-need-update-due-to-parse-delay)
          (setq cpimenu-need-update-due-to-parse-delay nil)))
      (when update?
        (save-current-buffer
          (cpimenu)))

      (when name
        (with-selected-window win
          (let ((loo t) pos-in-line pos-f)
            (save-excursion
              (save-match-data
                (goto-char (point-min))
                (while (and loo (not (eobp)))
                  (cond ((and (setq pos-in-line (get-text-property (point) 'cpimenu-target))
                              (= pos pos-in-line))
                         (setq loo nil)
                         (setq pos-f (point)))
                        (t
                         (forward-line))))))
            (when pos-f
              (goto-char pos-f)
              ;; (cpimenu-hl-text (match-beginning 0) (match-end 0))
              (cpimenu-hl-text (line-beginning-position) (line-end-position))
              ;; (recenter (/ (window-height) 2))
              )))
        ))
    (when name
      (if cpimenu-return-pos
          (cons name pos)
        name))))

(defun cpimenu-toggle ()
  (interactive)
  (let (win)
    (cond ((setq win (get-buffer-window cpimenu-buf-name))
           (setq cpimenu-win-height (window-height win))
           (delete-window win))
          (t
           (cpimenu)))))

(defadvice scroll-bar-toolkit-scroll (before scroll-bar-toolkit-scroll (event))
  (let* ((end-position (event-end event))
         (window (nth 0 end-position)))
    (when (eq (get-buffer-window cpimenu-buf-name) window)
      (select-window window))))

(defadvice mwheel-scroll (before mwheel-scroll (event))
  (let* ((end-position (event-end event))
         (window (nth 0 end-position)))
    (when (eq (get-buffer-window cpimenu-buf-name) window)
      (select-window window))))

;; (defadvice semantic-default-which-function (after semantic-default-which-function (taglist))
;;   (cpimenu-which-func taglist))
;;  
;; (ad-activate 'semantic-default-which-function)

(defvar cpimenu-menu
  '("CPImenu"
    ["Fold all" cpimenu-fold-all t]
    ["Unfold all" cpimenu-unfold-all t]
    ["Toggle foldding" cpimenu-toggle-folding t]))

(easy-menu-define cpimenu-menu-symbol
                  cpimenu-mode-map
                  "Cpimenu menu"
                  cpimenu-menu)

(define-key cpimenu-mode-map [mouse-3] 'cpimenu-click)
(define-key cpimenu-mode-map "q" 'cpimenu-del-win-in-me)
(define-key cpimenu-mode-map "k" 'cpimenu-del-win-in-me)
(define-key cpimenu-mode-map "0" 'cpimenu-del-win-in-me)
(define-key cpimenu-mode-map "=" 'cpimenu-del-win-in-me)
(define-key cplist-mode-map "=" 'cpimenu-toggle-cpimenu-win)
(define-key cpimenu-mode-map "`" 'cplist-minimize/restore-sidebar)

(define-key cpimenu-mode-map "s" 'codepilot-search-hi-string)
(define-key cpimenu-mode-map "f" 'codepilot-search-hl-again-f)
(define-key cpimenu-mode-map "b" 'codepilot-search-hl-again-b)

(define-key cpimenu-mode-map "g" '(lambda ()
                                   (interactive)
                                   (goto-char (point-min))
                                   (cpfilter-erase)))


(define-key cpimenu-mode-map "v" 'cpimenu-toggle-folding)
(define-key cpimenu-mode-map "c" 'cpimenu-fold-all)
(define-key cpimenu-mode-map "o" 'cpimenu-unfold-all)

(define-key cpimenu-mode-map "\r" 'cpimenu-action)
(define-key cpimenu-mode-map "\t" 'cpimenu-tab)
(define-key cpimenu-mode-map "\M-n" 'cpfilter-erase)


(defun cpimenu-activate ()
  (interactive)
  (add-hook 'cplist-win-del 'cpimenu-when-cplist-win-del)
  (add-hook 'cplist-win-added 'cpimenu-when-cplist-win-added)
  (add-hook 'which-func-functions 'cpimenu-which-func)
  (ad-activate 'scroll-bar-toolkit-scroll)
  (ad-activate 'mwheel-scroll))

(defun cpimenu-deactivate ()
  (interactive)
  (remove-hook 'cplist-win-del 'cpimenu-when-cplist-win-del)
  (remove-hook 'cplist-win-added 'cpimenu-when-cplist-win-added)
  (remove-hook 'which-func-functions 'cpimenu-which-func)
  (ad-deactivate 'scroll-bar-toolkit-scroll)
  (ad-deactivate 'mwheel-scroll)
  (ad-deactivate 'semantic-default-which-function))

(provide 'cpimenu)
