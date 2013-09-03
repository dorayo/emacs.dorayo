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


(require 'cp-pb)
(require 'myctagsmenu)

(defun c-skip-quote (string &optional limit)
  "assume it is after the start single quote"
  (save-match-data
    (let (done n)
      (while (and (not done)
                  (re-search-forward string limit))
        (save-excursion
          (backward-char)
          (setq n (skip-chars-backward "\\\\"))

          (cond ((= 0 (% n 2))
                 (setq done t))))))))


;; 1: /* 2: // 3: {  4: " 5: '
(defvar comment-and-string-start-regexp "\\(/\\*\\)\\|\\(//\\)\\|\\({\\)\\|\\(\"\\)\\|\\(\'\\)")


(defvar c-switch-branch-regexp "\\|\\(\\_<case\\_>\\)\\|\\(\\_<default\\_>\\)")

;; 6: case xxx: 7: default:
(defvar c-switch-search-regexp
  (concat comment-and-string-start-regexp
          c-switch-branch-regexp))

(defmacro with-c-skip-comment/string (text limit ret &rest body)
  (let ((temp-ok (make-symbol "--cl-ok--"))
        (temp-regexp (make-symbol "--cl-regexp--")))
    `(let ((,temp-regexp (concat comment-and-string-start-regexp ,text))
           ,temp-ok)
       (while (and (not ,ret)
                   (re-search-forward ,temp-regexp ,limit t))
         (cond ((match-beginning 1)
                ;; /*
                ;; then skip the comments
                (re-search-forward "\\*/"))
               ((match-beginning 2)
                ;; //
                ;; skip the comments
                (forward-line))
               ((match-beginning 3)
                ;; {
                ;; skip the block
                (up-list))
               ((match-beginning 4)
                ;; doublt quote
                (c-skip-quote "\""))
               ((match-beginning 5)
                ;; single quote
                (c-skip-quote "\'"))
               (t
                ,@body)))
       ,ret)))

(defun c-find-a-string-not-in-comment/quote (s &optional limit)
  (let (result)
    (with-c-skip-comment/string
     (concat "\\|\\(" s "\\)")
     limit
     result
     (when (match-beginning 6)
       (setq result t)))))

(defun fold-c-switch ()
  ""
  (interactive)
  (let (b e pos result)
    (save-restriction
      (save-excursion
        (save-match-data
          (backward-up-list)
          (setq b (point))
          (forward-list)
          (setq e (point))
          (narrow-to-region b e)
          (goto-char (point-min))
          (forward-char)

          (with-c-skip-comment/string
           c-switch-branch-regexp
           nil
           result
           (cond ((or (match-beginning 6)
                      (match-beginning 7))
                  ;; case xxxx:
                  ;; fold it
                  (when pos
                    (cptree-hide-region pos
                                        (save-excursion
                                          (goto-char (match-beginning 0))
                                          (forward-line 0)
                                          (backward-char)
                                          (point))
                                        'cptree))
                  (save-excursion
                    (c-find-a-string-not-in-comment/quote ":")
                    (end-of-line)
                    (setq pos (point))))))
          (when pos
            (cptree-hide-region pos (1- (point-max)) 'cptree)))))))

(defun fold-c-switch-branch ()
  ""
  (interactive)
  (let (pos done limit result)
    (save-excursion
      (save-match-data
        (forward-line 0)
        (c-find-a-string-not-in-comment/quote "\\_<case\\|default\\_>")
        (c-find-a-string-not-in-comment/quote ":")
        (save-excursion
          (end-of-line)
          (setq pos (point)))
        (setq limit (save-excursion
                      (up-list)
                      (backward-char)
                      (point)))


        (with-c-skip-comment/string
         c-switch-branch-regexp
         limit
         result
         (cond ((or (match-beginning 6)
                    (match-beginning 7))
                ;; case xxxx:
                ;; default:
                ;; fold it
                (cptree-hide-region pos
                                    (save-excursion
                                      (goto-char (match-beginning 0))
                                      (forward-line 0)
                                      (backward-char)
                                      (point))
                                    'cptree)
                (setq pos (point))
                (setq result t))))

        (unless result
          (cptree-hide-region pos limit 'cptree))))))



(defvar mycutil-c-block-regexp
  (concat "\\_<"
          (regexp-opt (list
                       "if" "else" "switch" "case" "for" "while" "default" "do")
                      t)
          "\\_>"
          "\\|}"))

(defun my-in-quote/comment ()
  "Returns none nil if point is in quote or comment, nil otherwise."
  (save-match-data
    (nth 8 (syntax-ppss))))

(defun mycutil-search-forward (string &optional bound)
  (let (pos)
    (save-excursion
      (save-match-data
        (while (and (search-forward string bound t)
                    (null pos))
          (unless (my-in-quote/comment)
            (setq pos (point))))))
    (when pos
      (goto-char pos))
    pos))

(defun mycutil-re-search (string fn &optional bound)
  (let (pos)
    (save-excursion
      (save-match-data
        (while (and (funcall fn string bound t)
                    (null pos))
          (unless (my-in-quote/comment)
            (setq pos (point))))))
    (when pos
      (goto-char pos))
    pos))

(defun mycutil-re-search-forward (string &optional bound)
  (mycutil-re-search string 're-search-forward bound))

(defun mycutil-re-search-backward (string &optional bound)
  (mycutil-re-search string 're-search-backward bound))

(defun mycutil-which-block (&optional b)
  (interactive)
  (let ((b (if b b (save-excursion (beginning-of-defun) (point))))
        pos
        (org-p (point))
        str-m
        temp-pos)
    (save-excursion
      (save-match-data
        (while (and (re-search-backward mycutil-c-block-regexp b t)
                    (null pos))
          (unless (my-in-quote/comment)
            (setq str-m (match-string 0))
            (cond ((string= str-m "}")
                   (backward-up-list))

                  ((or (string= str-m "case")
                       (string= str-m "default"))
                   (setq pos (point)))
                  (t

                   (cond ((and (or (string= str-m "else")
                                   (string= str-m "if"))
                               (eq (char-before) ?#))
                          ;; it is #if or #else
                          ;; search again.
                          )

                         (t
                          (setq temp-pos (point))
                          (save-excursion

                            (unless (or (string= str-m "else")
                                        ;; (string= str-m "switch")
                                        (string= str-m "do"))
                              (forward-list))

                            (cond ((and (> org-p (point))
                                        (mycutil-re-search-forward "[{;]" org-p))
                                   (let ((c (char-before)))
                                     (cond ((eq c ?{)
                                            (backward-char)
                                            (forward-list)
                                            (when (> (point) org-p)
                                              (setq pos temp-pos)))
                                           (t
                                            ;;seach again.
                                            ))))
                                  (t
                                   (setq pos temp-pos))))))))))))
    ;; (when b
    ;;   (goto-char b)
    ;;   )
    (when pos
      (goto-char pos)
      str-m)))

(defun mycutil-cp-pb-where-we-are ()
  (interactive)
  (let ((inhibit-push-mark t)
        ms ll begpt endpt marker buf proc md pos
        (f-name (buffer-file-name)) to-pos
        p2 p1 (last-line-b -1) stored-pos
        skip-back-func
        search-uncommented-b-func
        ;; (b (save-excursion (beginning-of-defun) (point)))
        name-and-pos b p1 p2 p3)

    (forward-line 0) ;; brian: Think about it
    
    (make-local-variable 'cp-pb-buffer-file-name)
    (setq cp-pb-buffer-file-name (buffer-file-name))

    (setq name-and-pos (cc-which-func-2))
    (setq proc (car name-and-pos))
    (setq b (second name-and-pos))

    (push (list (buffer-substring (line-beginning-position) (line-end-position))
                (point))
          ll)

    (setq last-line-b (line-beginning-position))

    (save-excursion
      (save-match-data
        (save-restriction
          (widen)
          (while (setq ms (mycutil-which-block b))

            (cond ((string= ms "else")
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position))
                   (mycutil-re-search-backward "[};]"))
                  ((or (string= ms "if")
                       (string= ms "for")
                       (string= ms "while"))
                   (setq p1 (point))
                   (setq p2 (line-beginning-position))
                   (forward-list)
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position))
                   (forward-line -1)
                   (while (>= (point) p2)
                     (setq ll (cp-pb-push-line ll last-line-b)
                           last-line-b (line-beginning-position))
                     (forward-line -1))
                   (goto-char p1))
                  ((string= ms "default")
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position))
                   (backward-up-list)
                   (mycutil-re-search-backward "\\_<switch\\_>")
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position)))
                  ((string= ms "case")
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position))
                   (skip-chars-backward "[\t\n ]")
                   (setq p1 (point))
                   (setq p2 nil)
                   (while (and (mycutil-re-search-backward "[^ \n\t]")
                               (eq ?: (char-after))
                               (mycutil-re-search-backward "\\_<case\\_>"))
                     (setq p2 (line-beginning-position)))
                   (goto-char p1)
                   (when p2
                     (setq ll (cp-pb-push-line ll last-line-b)
                           last-line-b (line-beginning-position))
                     (forward-line -1)
                     (while (>= (point) p2)
                       (setq ll (cp-pb-push-line ll last-line-b)
                             last-line-b (line-beginning-position))
                       (forward-line -1)))
                   (goto-char p1)
                   (backward-up-list)
                   (mycutil-re-search-backward "\\_<switch\\_>")
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position)))
                  (t
                   (setq ll (cp-pb-push-line ll last-line-b)
                         last-line-b (line-beginning-position))))))))

    (setq buf (get-buffer-create "*Block Traceback*"))

    (with-current-buffer buf
      (font-lock-mode 0)
      (cp-pb-mode 1)

      (make-local-variable 'cp-pb-buffer-file-name)
      (setq cp-pb-buffer-file-name f-name)

      (setq buffer-read-only t)
      (with-modify-in-readonly
       (erase-buffer)
       (insert "Proc: ")
       (when proc
         (setq pos (point))
         (insert proc)
         (put-text-property pos (point)
                            'face 'codepilot-hl-text-face)
         (insert " - How did I reach the point?")
         (put-text-property (line-beginning-position) (line-end-position)
                            'cp-pb-target b))

       (insert "\n")
       (dolist (i ll)
         (insert (car i))
         (put-text-property (line-beginning-position) (line-end-position)
                            'cp-pb-target (second i))
         (insert "\n"))
       (goto-char (point-max))
       (forward-line -1)
       (setq to-pos (point))
       ;; (myimenu-hl-text (line-beginning-position) (line-end-position))
       (codepilot-highlight-one-line-1)))

    (save-selected-window
      (cp-pb-pop-to-buffer buf)
      (goto-char to-pos)
      (recenter -1)
      ;; (shrink-window-if-larger-than-buffer)
      ;; (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2))
      )))

(defalias 'cp-pb-where-we-are 'mycutil-cp-pb-where-we-are)


(defun mycutil-cp-pb-which-procs-i-in ()
  (interactive)
  (let ((inhibit-which-func-update t)
        (proc "")
        (prev-pos -1)
        pnm mp ll begpt endpt p1 buf pos pt
        (txt codepilot-current-search-text)
        (s-type codepilot-current-search-type)
        (f-name (buffer-file-name))
        (b-pos (line-end-position))
        (to-pos (make-marker))
        line-pos
        (proc-count 0))

    (set-marker to-pos 1)

    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (when (not (string= "" codepilot-current-search-text))
          (while (codepilot-search-hl-again-f-2)
            (setq pnm (cc-which-func-2))
            (cond ((and pnm (car pnm))
                   (setq proc (car pnm))
                   (setq mp (second pnm)))
                  (t
                   (setq proc "--Global---")
                   (setq mp nil)))
            (setq begpt (line-beginning-position))
            (setq endpt (line-end-position))
            (if (and (if (boundp 'jit-lock-mode) jit-lock-mode)
                     (text-property-not-all begpt endpt 'fontified t))
                (if (fboundp 'jit-lock-fontify-now)
                    (jit-lock-fontify-now begpt endpt)))
            (push (list proc mp (buffer-substring begpt endpt) (point))
                  ll)
            (forward-line)))))

    (setq buf (get-buffer-create "*Which Procs*"))

    (when ll
      (with-current-buffer buf
        (cond
         ((and cp-pb-buffer-file-name
               cp-pb-buffer-search-text
               cp-pb-buffer-search-type
               (string= cp-pb-buffer-file-name f-name)
               (string= cp-pb-buffer-search-text txt)
               (string= cp-pb-buffer-search-type s-type))
          ;; Highlight Corresponding line.
          (set-marker to-pos (cp-pb-highlight-line-cordingly b-pos)))
         (t
          (font-lock-mode 0)
          (cp-pb-mode 1)
          (make-local-variable 'cp-pb-buffer-file-name)
          (setq cp-pb-buffer-file-name f-name)

          (make-local-variable 'cp-pb-buffer-search-text)
          (setq cp-pb-buffer-search-text txt)

          (make-local-variable 'cp-pb-buffer-search-type)
          (setq cp-pb-buffer-search-type s-type)

          (setq buffer-read-only t)
          (with-modify-in-readonly
           (erase-buffer)

           (insert "Procs contain: ")
           (setq pos (point))
           (insert txt)
           (put-text-property pos (point) 'face 'codepilot-hl-text-face)

           (insert "\tType: " (prin1-to-string s-type) "\n\n")
           (dolist (i (nreverse ll))
             (setq mp (second i))

             (cond (mp
                    (unless (= prev-pos mp)
                      (insert "[" (car i) "]:")
                      (put-text-property (line-beginning-position) (line-end-position)
                                         'cp-pb-target mp)
                      (put-text-property (line-beginning-position) (line-end-position)
                                         'face 'font-lock-function-name-face)
                      (when (>= b-pos mp)
                        (set-marker to-pos (line-beginning-position)))
                      (insert "\n")
                      (setq prev-pos mp)
                      (setq proc-count (1+ proc-count))))
                   (t
                    (insert "[" (car i) "]:")
                    (put-text-property (line-beginning-position) (line-end-position)
                                       'face 'font-lock-function-name-face)
                    (insert "\n")))

             (insert "   |" (third i))

             (setq line-pos (fourth i))
             (when (>= b-pos line-pos)
               (set-marker to-pos (line-beginning-position)))
             (put-text-property (line-beginning-position) (line-end-position)
                                'cp-pb-target line-pos)

             (insert "\n"))
           (goto-char (point-min))
           (end-of-line)
           (insert "\tProc count: " (int-to-string proc-count))

           (goto-char to-pos)
           ;; (myimenu-hl-text (line-beginning-position) (line-end-position))
           (codepilot-highlight-one-line-1)
           ;; (when (/= 0 (length txt))
           ;;   (codepilot-highlight-3 txt s-type buf)  ;; brian todo
           ;;   )
           )))))

    (save-selected-window
      (cp-pb-pop-to-buffer buf)
      (goto-char to-pos)
      ;; (recenter -1)
      ;; (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2))
      )
    ;; (set-window-point (get-buffer-window buf) to-pos)
    ))

(defalias 'cp-pb-which-procs-i-in 'mycutil-cp-pb-which-procs-i-in)


(defvar c-cpp-header-file-subfixes '("h" "hpp"))
(defvar c-cpp-src-file-subfixes '("c" "cpp" "cc"))

;; similar function has already available as command "ff-find-other-file" : (
(defun jump-to-h-c-file ()
  (interactive)
  (let ((cur-f (buffer-file-name))
        f f-type subfix f-sans
        subfixes f-try)
    (setq f (file-name-nondirectory cur-f))
    (setq subfix (file-name-extension f))
    (setq f-sans (file-name-sans-extension f))

    (cond ((member subfix c-cpp-header-file-subfixes)
           (setq subfixes c-cpp-src-file-subfixes))
          ((member subfix c-cpp-src-file-subfixes)
           (setq subfixes c-cpp-header-file-subfixes)))
    (when subfixes
      (catch 'loo
        (dolist (sf subfixes)
          (setq f-try (concat f-sans "." sf))
          (when (file-exists-p f-try)
            (find-file f-try)
            (throw 'loo t)))))))

(provide 'mycutil)

