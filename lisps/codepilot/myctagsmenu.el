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

(require 'cpimenu)
(require 'cpfilter)

(defvar exuberant-ctags-program (if (eq system-type 'windows-nt)
                                    (concat codepilot-dir "bin/ctags.exe")
                                  "ctags"))

(defvar myctags-sort-option "--sort=no")

(defun myctags-make-temp-file-if-file-nonlocal (file)
  (let (file-name-handler-alist)
    (cond ((file-exists-p file)
           ;; file is local, just return it as is.
           file)
          (t
           (let ((temp-file (make-temp-file "myctags" nil (file-name-nondirectory file))))
             (save-excursion
               (save-restriction
                 (widen)
                 (write-region (point-min) (point-max) temp-file)))
             temp-file)))))

(defvar myctags-ckinds
  '(
    (?z "defun")
    (?f "function")
    (?s "struct")
    (?c "class")
    (?u "union")
    (?m "member")
    (?v "variable")
    (?d "macro")
    (?g "enum")
    (?e "enumeration")
    (?l "local")
    (?n "namespace")
    (?p "prototype")
    (?t "typedef")
    (?x "externvar")

    (?i "import") ;; for python.
    ))

(defvar myctags-java-kinds
  '(
    (?p "package")
    (?c "class")
    (?i "interface")
    (?f "field")
    (?m "method")
    (?g "enum type")
    (?e "enum constant")))

(defvar myctags-js-kinds
  '(
    (?f "functions")
    (?c "classes")
    (?m "methods")
    (?p "properties")
    (?v "variables")))


(defvar myctags-side-window-size 35)

(defvar myctags-include-class t)
(defvar myctags-include-parmlist t)

(defun myctags-effected-modes? (mm)
  (or (eq mm 'c-mode)
      (eq mm 'c++-mode)
      (eq mm 'java-mode)))

(defmacro myctags-map-related-buffers (&rest body)
  `(dolist (b (buffer-list))
    (with-current-buffer b
        (when (myctags-effected-modes? major-mode)
          ,@body))))

(defun myctags-find-minoffset (vect pos elm-fn)
  "binary search!"
  (let ((len (length vect)))
    (when (> len 0)
      (let (idx min max can elm)
        (setq min 0)
        (setq max (1- len))

        (catch 'loo
          (while t
            (setq idx (/ (+ min max) 2))
            (setq elm (funcall elm-fn (aref vect idx)))

            (cond ((= pos elm)
                   ;; done
                   (throw 'loo idx))
                  (t
                   (cond ((< pos elm)
                          (setq max (1- idx)))
                         ((> pos elm)   ;; elm pos
                          (setq min (1+ idx)
                                can idx)))
                   (cond ((< max min)
                          ;; end loop
                          (throw 'loo can)))))))))))

(defun myctags-get-tags-list (file-input mj-mode)
  "work in the ctags output buffer"
  (let (tag ln kind buf
           tag-line items options m-str
           tag-lines parents signature)
    
    (erase-buffer)
    
    (call-process exuberant-ctags-program
                  nil t nil "-f" "-" "--format=2" "--excmd=number"
                  "--fields=ksS"
                  ;; "--fields=k"
                  "--regex-c=/^DEFUN[ \t]*\\([ \t]*\"([^\"]+)\"/\\1/z,defun/"
                  myctags-sort-option
                  file-input)
    ;; analyzed the output
    ;; e.g.;
    ;; swap	f:/boost/boost_1_39_0/boost/smart_ptr/detail/shared_ptr_nmt.hpp	168;"	f	namespace:boost	signature:(shared_ptr<T> & a, shared_ptr<T> & b)
    ;;
    ;; swap==== 0:tag
    ;; f:/boost/boost_1_39_0/boost/smart_ptr/detail/shared_ptr_nmt.hpp==== 1:filename
    ;; 168;"==== 2:line
    ;; f==== 3:kind
    ;; namespace:boost==== (optional)
    ;; signature:(shared_ptr<T> & a, shared_ptr<T> & b)==== (optional)
    ;; nil

    (goto-char (point-min))

    (while (not (eobp))
      (setq tag-line (buffer-substring-no-properties (point) (line-end-position)))
      (setq items (split-string tag-line "\t"))
      
      (setq tag (car items))
      (setq ln (string-to-number (nth 2 items)))
      (setq kind (aref (nth 3 items) 0))

      (setq options (nthcdr 4 items))

      (setq parents nil
            signature nil)
      (when options
        (cond ((= (length options) 2)
               (setq parents (car options))
               (setq signature (substring (second options) 10)))
              (t ;; only one option
               (cond ((string-match "signature:" (car options))
                      (setq signature (substring (car options) 10)))
                     (t
                      (setq parents (car options)))))))
      (push (list ln tag kind parents signature) tag-lines)
      (forward-line))
    tag-lines))

(defvar myctags-tag-vect nil)

(defsubst myctags-format-class-name (name)
  ;; class v8::internal::Factory
  ;; => class Factory |v8::internal|
  (if (null (string-match "^\\([^\s]+ \\)\\(.+?\\)::\\([^:]+\\)$" name))
      name
    (concat (match-string 1 name) (match-string 3 name) " |" (match-string 2 name) "|")))

(defun cc-create-index-function ()
  "Create imenu index using exuberant CTags"
  (let (alist (file (buffer-file-name)) kind tag ln al (m major-mode)
              file-input ll tag-lines myctags-cache myctags-class-list)

    (setq file-input (myctags-make-temp-file-if-file-nonlocal file))
    
    (save-match-data
      (with-temp-buffer
        (setq tag-lines (myctags-get-tags-list file-input m))))

    (when tag-lines
      (setq tag-lines (nreverse tag-lines))
      (set (make-local-variable 'myctags-tag-vect) (make-vector (length tag-lines) nil))
      
      ;; get the point of the line number.
      (save-restriction
        (widen)
        (save-excursion
          (goto-char (point-min))
          
          (let (ln (prev-line 1) delta (idx 0))
            (dolist (line tag-lines)
              (setq ln (car line))
              (setq delta (- ln prev-line))
              (forward-line delta)

              (aset myctags-tag-vect idx (cons (point) line))
              (setq prev-line ln)
              
              (setq idx (1+ idx)))))))

    (cond ((eq major-mode 'java-mode)
           (cond ((string-match "\.js$" file-input)
                  (setq myctags-cache (copy-tree myctags-js-kinds)))
                 (t
                  (setq myctags-cache (copy-tree myctags-java-kinds)))))
          (t
           (setq myctags-cache (copy-tree myctags-ckinds))))
    
    (setq myctags-class-list nil)

    
    (let ((idx 0) item pos tag kind parents signature
          in-class
          (myctags-include-parmlist (if (eq major-mode 'c-mode) nil t))
          aso class-name in-class al)

      (while (< idx (length myctags-tag-vect))
        
        (setq item (aref myctags-tag-vect idx))

        (setq pos (first item))
        (setq tag (third item))
        (setq kind (fourth item))
        (setq parents (fifth item))
        (setq signature (sixth item))
        
        (setq in-class nil)
        (when parents
          (cond ((or (eq ?f kind)
                     (eq ?m kind)
                     (eq ?e kind)
                     (eq ?t kind)
                     (eq ?g kind))
                 (when (and myctags-include-class
                            (string-match "\\(class\\|struct\\|enum\\):\\(.+\\)" parents))
                   (setq class-name (concat (match-string 1 parents) " " (match-string 2 parents)))
                   (setq in-class t)))
                ((or (eq ?c kind)
                     (eq ?s kind)
                     (eq ?n kind))
                 (when (and myctags-include-class
                            ;; (string-match "namespace:\\(.+\\)" parents)
                            )
                   ;; (setq tag (concat tag " |" (match-string 1 parents) "|"))
                   (setq tag (concat tag " |" parents "|"))))))

        (when (and signature
                   myctags-include-parmlist)
          (setq tag (concat tag " " signature)))

        ;; put the tags
        (cond (in-class
               (cond ((setq aso (assoc class-name myctags-class-list))
                      (push (cons tag pos) (cdr aso)))
                     (t
                      (push (list class-name (cons tag pos)) myctags-class-list))))
              (t
               (setq al (assq kind myctags-cache))
               (when al
                 (push (cons tag pos) (cdr (cdr al))))))


        ;; ===============
        (setq idx (1+ idx)))

      (setq myctags-class-list (nreverse myctags-class-list)))
    
    (save-excursion
      (dolist (i myctags-cache)
        (when (cdr (cdr i))
          (push  (cons (capitalize (second i)) (nreverse (cdr (cdr i)))) alist)))
      (dolist (i myctags-class-list)
        (push  (cons (myctags-format-class-name (car i)) (nreverse (cdr i))) alist)))

    (nreverse alist)))

(defun myctags-set-create-index-function ()
  (interactive)
  (when (myctags-effected-modes? major-mode)
    (setq imenu-create-index-function 'cc-create-index-function)
    (add-hook 'which-func-functions 'cc-which-func nil t)))


(defun myctags-unset-create-index-function ()
  (interactive)
  (when (myctags-effected-modes? major-mode)
    (setq imenu-create-index-function 'imenu-default-create-index-function)
    (remove-hook 'which-func-functions 'cc-which-func t)))


(defun pop-mc ()
  (interactive)
  (pop-to-buffer "*MyCtagsMenu*"))

(defalias 'mc 'pop-mc)

(defun test-mc ()
  (interactive)
  (let ((buf (buffer-file-name)))
    (with-output-to-temp-buffer "*test*"
      (set-buffer standard-output)
      (save-excursion
        (call-process exuberant-ctags-program
                  nil t nil "-f" "-" "--format=2" "--excmd=number"
                  "--fields=ksS"
                  ;; "--fields=k"
                  "--regex-c=/^DEFUN[ \t]*\\([ \t]*\"([^\"]+)\"/\\1/i,defun/"
                  myctags-sort-option
                  buf)
        
        ;; (call-process exuberant-ctags-program
        ;;               nil t nil "-f" "-" "--format=2"
        ;;               ;; "--excmd=number"
        ;;               "--excmd=pattern"
        ;;               ;; "--fields=ksiS"
        ;;               "--fields=nks"
        ;;               "--regex-c=/^DEFUN[ \t]*\\([ \t]*\"([^\"]+)\"/\\1/i,defun/"
        ;;               ;; "--extra=+q"
        ;;               ;; "--language-force=c" "--c-types=dgsutvf"
        ;;               ;; "--language-force=JavaScript"
        ;;               buf)
        ))))

(defun cc-which-func-2 ()
  (if (and (featurep 'semantic)
           ;; semantic--buffer-cache
           (semantic-active-p)
           (eq imenu-create-index-function 'semantic-create-imenu-index))
      (let (o name pos)
        (setq o (cpimenu-semantic-which-func-and-pos))
        (setq name (car o)
              pos (cdr o))
        (list name pos name pos))
    (progn
      (when (and (null imenu--index-alist)
                 (null which-function-imenu-failed))
        (imenu--make-index-alist t)
        (unless imenu--index-alist
          (make-local-variable 'which-function-imenu-failed)
          (setq which-function-imenu-failed t)))
      (when (and (boundp 'imenu--index-alist) imenu--index-alist)
        (let ((alist imenu--index-alist)
              idx pos kind tag-elem idx2 tag-elem2 (loo t)
              name-myi pos-myi name pos signature parents)
          (when (and alist myctags-tag-vect)
            (setq idx (myctags-find-minoffset myctags-tag-vect (point) #'car))
            (unless (null idx)
              (setq tag-elem (aref myctags-tag-vect idx))

              (setq name (third tag-elem))
              (setq pos (first tag-elem))

              (setq kind (fourth tag-elem))
              (cond ((or (eq kind ?d) (eq kind ?v)) ;; marco or variable! skip it.
                     (setq idx2 (1- idx))
                     (while (and (>= idx2 0) loo)
                       (setq tag-elem2 (aref myctags-tag-vect idx2))
                       (unless (or (eq (fourth tag-elem2) ?d)
                                   (eq (fourth tag-elem2) ?v))
                         (setq loo nil)
                         (setq name-myi (third tag-elem2))
                         (setq pos-myi (first tag-elem2))
                         (setq parents (fifth tag-elem2))
                         (setq signature (sixth tag-elem2)))
                       (setq idx2 (1- idx2))))
                    (t
                     (setq name-myi name)
                     (setq pos-myi pos)
                     (setq parents (fifth tag-elem))
                     (setq signature (sixth tag-elem))))

              (when parents
                (setq name-myi (concat parents "." name-myi)))
              ;; (when signature
              ;;   (setq name-myi (concat name-myi " " signature)))

              (list name-myi pos-myi name pos))))))))

(defun cc-which-func ()
  
  (let (name
        pos win buf-name update?
        cpimenu-not-care?
        name-myi pos-myi
        info)

    (when (setq info (cc-which-func-2))
      (setq name-myi (car info))
      (setq pos-myi (second info))
      (setq name (third info))
      (setq pos (fourth info))

      (setq buf-name (buffer-name))
      (when (setq win (get-buffer-window cpimenu-buf-name))
        (with-current-buffer cpimenu-buf-name
          (goto-char (point-min))
          (cond ((string= buf-name cpimenu-connected-buffer))
                (t
                 (setq update? t))))
        (when update?
          (save-current-buffer
            (cpimenu)))

        (when name
          (with-selected-window win
            (goto-char (point-min))
            (save-match-data
              (let ((loo t)
                    (org-pos (point))
                    pos-in-line)
                
                (while (and loo (not (eobp)))
                  (cond ((and (setq pos-in-line (get-text-property (point) 'cpimenu-target))
                              (= pos pos-in-line)
                              )
                         (cpimenu-hl-text (line-beginning-position) (line-end-position))
                         ;; (recenter (/ (window-height) 2))
                         (setq loo nil))
                        (t
                         (forward-line))))
                (when loo
                  (goto-char org-pos))))))))
    (when name-myi
      (cons name-myi pos-myi))))

(defun myctags ()
  "Create imenu index using exuberant CTags"
  (interactive)
  (let ((file (buffer-file-name))
        (buf-name (buffer-name))
        (m major-mode)
        pos pos2
        al tag ln kind
        file-input buf
        (ilist (cc-create-index-function)))
    
    (setq file-input (myctags-make-temp-file-if-file-nonlocal file))

    (setq buf (get-buffer-create "*MyCtagsMenu*"))
    (set-buffer buf)
    (setq buffer-read-only t)

    (make-local-variable 'cpimenu-refresh-func)
    (setq cpimenu-refresh-func 'myctags)

    (cpimenu-output buf-name ilist nil)
    
    (cond ((get-buffer-window "*MyCtagsMenu*"))
          (t (multiple-value-bind (ret sidebar code-win bottom-win)
                 (codepilot-window-layout-wise)
               (case ret
                 ((:window-layout-1&1)
                  (condition-case nil
                      (progn
                        (split-window nil (* 7 (/ (window-width) 9)) t)
                        (save-selected-window
                          (other-window 1)
                          (switch-to-buffer buf)
                          (set-window-dedicated-p (selected-window) t)))
                    (error
                     (pop-to-buffer buf)
                     (shrink-window-if-larger-than-buffer (get-buffer-window "*MyCtagsMenu*")))))
                 ((:window-layout-1)
                  (split-window nil myctags-side-window-size t)
                  (save-selected-window
                    (switch-to-buffer buf)
                    (set-window-dedicated-p (selected-window) t)))
                 (otherwise
                  (pop-to-buffer buf)
                  (shrink-window-if-larger-than-buffer (get-buffer-window "*MyCtagsMenu*")))))))))


(defun myctags-add-which-func-hook ()
  (interactive)
  (add-hook 'which-func-functions 'cc-which-func nil t))

(defun myctags-imenu-active ()
  ""
  (interactive)

  (add-hook 'c-mode-hook 'myctags-set-create-index-function)
  (add-hook 'c++-mode-hook 'myctags-set-create-index-function)
  (add-hook 'java-mode-hook 'myctags-set-create-index-function)

  (myctags-map-related-buffers
   (myctags-set-create-index-function)))

(defun myctags-imenu-deactive ()
  ""
  (interactive)
  (remove-hook 'c-mode-hook 'myctags-set-create-index-function)
  (remove-hook 'c++-mode-hook 'myctags-set-create-index-function)
  (remove-hook 'java-mode-hook 'myctags-set-create-index-function)

  (myctags-map-related-buffers
   (myctags-unset-create-index-function)))

(defun myctags-imenu-semantic-act ()
  (interactive)
  (myctags-imenu-deactive)
  (myctags-map-related-buffers
   (setq imenu-create-index-function 'semantic-create-imenu-index)))

(provide 'myctagsmenu)