
(defvar cpfilter-edit-field-overlay nil)

(defface cpfilter-face
    '((default (:inherit region))
      (((class color) (background light)) (:background "darkseagreen2" :underline t))
      (((class color) (background dark)) (:background "dark olive green" :foreground "white" :underline t)))
  "Cpfilter edit entry face."
  :group 'codepilot)

(defface cpfilter-tab-face
    '((((class color)) (:strike-through "red")))
  "To highlight tabs."
  :group 'codepilot)

(defun cpfilter-lock-tab (limit)
  "Run through the buffer and add overlays to target matches."
  (let ((end (overlay-end cpfilter-edit-field-overlay)))
    (and end
         (> end (point))
         (re-search-forward "[\t]+" end t))))

(defvar cpfilter-lock-keywords
  (list
   '(cpfilter-lock-tab (0 'cpfilter-tab-face))))


;; (defun cpfilter-after-change (start end old-len)
;;   (when cpfilter-edit-field-overlay
;;     (let ((o-start (overlay-start cpfilter-edit-field-overlay))
;;           (o-end (overlay-end cpfilter-edit-field-overlay)))
;;       (and o-end
;;            (>= start o-start)
;;            (<= end o-end)
;;            ;; (cpfilter-do-filter o-start (1- o-end))
;;            (cpfilter-do-filter (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
;;            (message "dfdfdf")
;;            ))))

(defvar cpfilter-keymap (make-sparse-keymap))

(defun cpfilter-add-edit-entry-field ()
  (let ((inhibit-read-only t))
    (when cpfilter-edit-field-overlay
      (delete-overlay cpfilter-edit-field-overlay))
    (kill-local-variable 'cpfilter-edit-field-overlay)
    (make-local-variable 'cpfilter-edit-field-overlay)
    (insert "\n")
    (backward-char)
    (setq cpfilter-edit-field-overlay (make-overlay (line-beginning-position) (line-beginning-position 2)))
    (overlay-put cpfilter-edit-field-overlay 'face 'cpfilter-face)
    (overlay-put cpfilter-edit-field-overlay 'keymap cpfilter-keymap)
    (font-lock-add-keywords nil cpfilter-lock-keywords)
    ;; (add-hook 'after-change-functions 'cpfilter-after-change t t)
    ))

;; (defun cpfilter-hide-region (from to tag)
;;   (when (< from to)
;;     (let (o)
;;       (setq o (make-overlay from to))
;;       (overlay-put o 'tag tag)
;;       (overlay-put o 'invisible t)
;;       )))

(defun cpfilter-del-all-overlays (tag)
  (remove-overlays nil nil 'tag tag))


(defun cpfilter-do-filter (str)
  "str shall not contain \\n"
  (when str
    (cond ((> (length str) 0)
           (let ((strs (split-string str "[\t]+" t))
                 str1 strs-cdr o pos line) (when strs
               (setq str1 (car strs))
               (setq strs-cdr (cdr strs))
               (save-excursion
                 (save-match-data
                   ;;           (forward-line)
                   ;;           (setq pre-pos (point))
                   ;;           (while (search-forward str nil t)
                   ;;             (cpfilter-hide-region pre-pos (line-beginning-position) 'cpfilter)
                   ;;             (forward-line)
                   ;;             (setq pre-pos (point))
                   ;;             )
                   ;;           (cpfilter-hide-region pre-pos (point-max) 'cpfilter)
                   ;;           )

                   (forward-line)
                   (setq pos (point))

                   (remove-overlays nil nil 'tag 'cpfilter)
                   
                   (setq o (make-overlay pos (point-max)))
                   (overlay-put o 'tag 'cpfilter)
                   (overlay-put o 'invisible t)

                   (goto-char pos)

                   (cond (strs-cdr
                          (let (not-match)
                            (while (search-forward str1 nil t)
                              (setq not-match nil)
                              (dolist (s1 strs-cdr)
                                (forward-line 0)
                                (unless (search-forward s1 (line-end-position) t)
                                  (setq not-match t)
                                  (return)))
                              (unless not-match
                                (remove-overlays (line-beginning-position) (line-beginning-position 2)
                                                 'tag 'cpfilter))
                              (forward-line))))
                         (t
                          (while (search-forward str1 nil t)
                            (remove-overlays (line-beginning-position) (line-beginning-position 2)
                                             'tag 'cpfilter)
                            (forward-line))))
                   
                   (goto-char pos)
                   (while (re-search-forward "^\\[\\|@" nil t)
                     (remove-overlays (line-beginning-position) (line-beginning-position 2) 'tag 'cpfilter))
                   
                   (goto-char pos)
                   (while (and (not (eobp)) (re-search-forward "^$" nil t))
                     (remove-overlays (line-beginning-position) (line-beginning-position 2) 'tag 'cpfilter)
                     (forward-line)))))))
          (t
           (cpfilter-del-all-overlays 'cpfilter)))))

(defun cpfilter-self-insert-command (arg)
  (interactive "p")
  (let ((inhibit-read-only t))
    (self-insert-command (or arg 1))
    (cpfilter-do-filter (buffer-substring-no-properties (line-beginning-position) (line-end-position)))))

(defun cpfilter-backward-delete-char ()
  (interactive)
  (when (> (point) (overlay-start cpfilter-edit-field-overlay))
    (let ((inhibit-read-only t))
        (backward-delete-char 1)
        (cpfilter-do-filter (buffer-substring-no-properties (line-beginning-position) (line-end-position))))))

(defun cpfilter-backward-delete-word ()
  (interactive)
  (let ((o-start (overlay-start cpfilter-edit-field-overlay)))
    (when (> (point) o-start)
      (let ((inhibit-read-only t) (old-pos (point)) pos)
        (when (setq pos (re-search-backward "\\<" o-start t))
          (delete-region pos old-pos)
          (cpfilter-do-filter (buffer-substring-no-properties (line-beginning-position)
                                                              (line-end-position))))))))

(defun cpfilter-erase ()
  (interactive)
  (let (s)
    (when (setq s (overlay-start cpfilter-edit-field-overlay))
      (goto-char s)
      (unless (= s (line-end-position))
        (let ((inhibit-read-only t))
          (delete-region s (line-end-position)))))
    (cpfilter-del-all-overlays 'cpfilter)))

(defun cpfilter-yank ()
  (interactive)
  (let ((inhibit-read-only t)
        (str (current-kill 0)))
    (when str
      (setq str (substring str 0 (string-match "\n" str)))
      (when str
        (insert str)
        (cpfilter-do-filter (buffer-substring-no-properties (line-beginning-position) (line-end-position)))))))

(defun cpfilter-tab (arg)
  (interactive "p")
  (cond ((and (eq ?\t (char-before))
              (save-excursion
                (forward-line)))
         (forward-line)
         (command-execute "\t"))
        (t
         (cpfilter-self-insert-command (or arg 1)))))


(defun cpfilter-enter (arg)
  (interactive "p")
  (forward-line)
  (command-execute "\t"))

(loop for i from 32 to 126 do
     (define-key cpfilter-keymap (vector i) 'cpfilter-self-insert-command))

;; (define-key cpfilter-keymap "\r" 'cpfilter-erase)
(define-key cpfilter-keymap "\r" 'cpfilter-enter)
(define-key cpfilter-keymap "\d" 'cpfilter-backward-delete-char)
(define-key cpfilter-keymap "\C-y" 'cpfilter-yank)
(define-key cpfilter-keymap "\C-v" 'cpfilter-yank)
(define-key cpfilter-keymap "\t" 'cpfilter-tab)
(define-key cpfilter-keymap [M-backspace] 'cpfilter-backward-delete-word)

(provide 'cpfilter)