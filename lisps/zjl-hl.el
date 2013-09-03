;;这package里的regions-list的成员和todo, 都是闭合包括两端的位置的. 所以在zjl-regions-delete开头那儿要特殊处理
;;;###autoload
(defun zjl-regions-add (regions-list todo)
  (interactive)
  (let (beg-node-to-insert beg-node-included-p end-node-to-insert end-node-included-p beg-have-find-p end-have-find-p temp-node temp-list temp-pre temp-next)
    (dotimes (Num (length regions-list))
      (cond ((and (not beg-have-find-p);;在Num个的包围中,包括Num的结束和开始
                  (>= (car todo) (car (nth Num regions-list)))
                  (<= (car todo) (cdr (nth Num regions-list))))
             (setq beg-have-find-p t)
             (setq beg-node-to-insert Num)
             (setq beg-node-included-p t))

            ((and (not beg-have-find-p);;在Num的前面--已经排除了上面的
                  (< (car todo) (cdr (nth Num regions-list))))
             (setq beg-have-find-p t)
             (setq beg-node-to-insert Num)
             (setq beg-node-included-p nil))
            (t nil)))
    (dotimes (Num (length regions-list));;必须2个dotimes,否则如果遇到都在同一个dotimes中可能beg end都符合的, end会被忽略
      (cond ((and (not end-have-find-p);;在Num个的包围中
                  (>= (cdr todo) (car (nth Num regions-list)))
                  (<= (cdr todo) (cdr (nth Num regions-list))))
             (setq end-have-find-p t)
             (setq end-node-to-insert Num)
             (setq end-node-included-p t))

            ((and (not end-have-find-p);;在Num个的前面
                  (< (cdr todo) (car (nth Num regions-list))))
             (setq end-have-find-p t)
             (setq end-node-to-insert Num)
             (setq end-node-included-p nil))
            
            (t nil)))

    (cond ((not beg-have-find-p);;都在最后
           (setq temp-list (list todo))
           (if regions-list ;;避免是regions-list 是 nil的情况
               (setcdr (nthcdr (1- (length regions-list)) regions-list) temp-list)
             (setq regions-list temp-list)))

          ((and beg-have-find-p;;末尾在最后, 前在节点中
                beg-node-included-p
                (not end-have-find-p))
           (setq temp-node (cons (car (nth beg-node-to-insert regions-list))(cdr todo)))
           (setq temp-list (nthcdr beg-node-to-insert regions-list))
           (setcar temp-list temp-node)
           (setcdr temp-list nil))
          
          ((and beg-have-find-p;;末尾在最后, 前在当中,不在节点中
                (not beg-node-included-p)
                (> beg-node-to-insert 0)
                (not end-have-find-p))
           (setq temp-pre (nthcdr (1- beg-node-to-insert) regions-list))
           (setcdr temp-pre (list todo)))

          ((and beg-have-find-p;;末尾在最后, 前在最前,不在节点中
                (not beg-node-included-p)
                (= beg-node-to-insert 0)
                (not end-have-find-p))
           (setq regions-list (list todo)))

          ((and beg-have-find-p ;;前后都在节点中, 即使后所在节点是0
                beg-node-included-p
                end-have-find-p
                end-node-included-p)
           (setq temp-node (cons (car (nth beg-node-to-insert regions-list)) (cdr (nth end-node-to-insert  regions-list))))
           (setq temp-list (nthcdr beg-node-to-insert regions-list))
           (setcar temp-list temp-node)
           (setcdr temp-list (nthcdr (1+ end-node-to-insert) regions-list)))

          ((and beg-have-find-p;;前在当中,不在节点中, 后在节点中, 即使后在最后一个节点中
                (not beg-node-included-p)
                (> beg-node-to-insert 0)
                end-have-find-p
                end-node-included-p)
           (setq temp-node (cons (car todo) (cdr (nth end-node-to-insert regions-list))))
           (setq temp-pre (nthcdr (1- beg-node-to-insert) regions-list))
           (setq temp-next (nthcdr (1+ end-node-to-insert) regions-list))
           (setcdr temp-pre (cons temp-node temp-next)))

          ((and beg-have-find-p;;前在最前, 后在节点中,即使是最后一个节点
                (not beg-node-included-p)
                (= beg-node-to-insert 0)
                end-have-find-p
                end-node-included-p)
           (setq temp-node (cons (car todo) (cdr (nth end-node-to-insert regions-list))))
           (setq temp-next (nthcdr (1+ end-node-to-insert) regions-list))
           (setq regions-list (cons temp-node temp-next)))

          ((and beg-have-find-p ;;都在第一个节点之前
                end-have-find-p
                (not end-node-included-p)
                (= end-node-to-insert 0))
           (setq regions-list (cons todo regions-list)))

          ((and beg-have-find-p;;前后都在当中,但都不在节点中
                (not beg-node-included-p)
                (> beg-node-to-insert 0)
                end-have-find-p
                (not end-node-included-p)
                (> end-node-to-insert 0))
           (setq temp-pre (nthcdr (1- beg-node-to-insert) regions-list))           
           (setq temp-next (nthcdr end-node-to-insert regions-list))
           (setcdr temp-pre (cons todo temp-next)))

          ((and beg-have-find-p;;前在最前, 后在当中,但不在节点中
                (not beg-node-included-p)
                (= beg-node-to-insert 0)
                end-have-find-p
                (not end-node-included-p)
                (> end-node-to-insert 0))
           (setq temp-list (nthcdr end-node-to-insert regions-list))
           (setq regions-list (cons todo temp-list))
           )

          ((and beg-have-find-p;;前在当中,在节点中,后在当中,不在节点中
                beg-node-included-p
                end-have-find-p
                (not end-node-included-p)
                (> end-node-to-insert 0))
           (setq temp-node (cons (car (nth beg-node-to-insert regions-list)) (cdr todo)))
           (setq temp-list (nthcdr beg-node-to-insert regions-list))
           (setcar temp-list temp-node)
           (setcdr temp-list (nthcdr end-node-to-insert regions-list)))
          (t nil))
  regions-list))
;;(setq zjl-regions-example '((4 . 7) (11 . 15) (17 . 17) (20 . 25)))
;;都在最后
;;(zjl-regions-add zjl-regions-example '(26 . 27))
;;末尾在最后, 前在节点中
;;(zjl-regions-add zjl-regions-example '(25 . 27))
;;(zjl-regions-add zjl-regions-example '(23 . 27))
;;(zjl-regions-add zjl-regions-example '(4 . 27))
;;末尾在最后, 前在当中,不在节点中
;;(zjl-regions-add zjl-regions-example '(5 . 27))
;;末尾在最后, 前在最前,不在节点中
;;(zjl-regions-add zjl-regions-example '(3 . 27))

;;前后都在节点中, 即使后所在节点是0----下面这几个是后在节点中的可能
;;(zjl-regions-add zjl-regions-example '(4 . 17))
;;(zjl-regions-add zjl-regions-example '(4 . 4))
;;(zjl-regions-add zjl-regions-example '(4 . 25))
;;前在当中,不在节点中, 后在节点中, 即使后在最后一个节点中
;;(zjl-regions-add zjl-regions-example '(16 . 22))
;;前在最前, 后在节点中,即使是最后一个节点
;;(zjl-regions-add zjl-regions-example '(1 . 22))
;;都在第一个节点之前
;;(zjl-regions-add zjl-regions-example '(1 . 1))
;;(zjl-regions-add zjl-regions-example '(2 . 3))

;;前后都在当中,但都不在节点中----后在当中,不在节点中
;;(zjl-regions-add zjl-regions-example '(10 . 19))
;;前在最前, 后在当中,但不在节点中
;;(zjl-regions-add zjl-regions-example '(1 . 19))
;;前在当中,在节点中,后在当中,不在节点中
;;(zjl-regions-add zjl-regions-example '(5 . 19))

;;(setq zjl-regions-example nil)
;;(setq zjl-regions-example (zjl-regions-add zjl-regions-example '(5 . 19)))
;;(zjl-regions-delete zjl-regions-example '(5 . 19))

;;(setq zjl-regions-example '((5 . 19)))
;;(setq zjl-regions-example (zjl-regions-add zjl-regions-example '(5 . 19)))
;;(zjl-regions-delete zjl-regions-example '(6 . 18))
;;(zjl-regions-delete zjl-regions-example '(6 . 19))
;;(zjl-regions-delete zjl-regions-example '(5 . 18))

;;(setq zjl-regions-example nil)


;;;###autoload
(defun zjl-regions-delete (regions-list todo)
  (interactive)
  (setq todo  (cons (1- (car todo)) (1+ (cdr todo))));;注意,修正过后的,一定是不会出现 (5 . 5)或者(5 . 6)这种的, 至少也是(4 . 6)
  (let (beg-node-to-insert beg-node-included-p end-node-to-insert end-node-included-p beg-have-find-p end-have-find-p temp-node temp-list temp-pre temp-next)
    (dotimes (Num (length regions-list))
      (cond ((and (not beg-have-find-p);;在Num个的包围中,包括Num的结束和开始
                  (>= (car todo) (car (nth Num regions-list)))
                  (<= (car todo) (cdr (nth Num regions-list))))
             (setq beg-have-find-p t)
             (setq beg-node-to-insert Num)
             (setq beg-node-included-p t))

            ((and (not beg-have-find-p);;在Num的前面--已经排除了上面的
                  (< (car todo) (cdr (nth Num regions-list))))
             (setq beg-have-find-p t)
             (setq beg-node-to-insert Num)
             (setq beg-node-included-p nil))
            (t nil)))
    
    (dotimes (Num (length regions-list));;必须2个dotimes,否则如果遇到都在同一个dotimes中可能beg end都符合的, end会被忽略
      (cond ((and (not end-have-find-p);;在Num个的包围中
                  (>= (cdr todo) (car (nth Num regions-list)))
                  (<= (cdr todo) (cdr (nth Num regions-list))))
             (setq end-have-find-p t)
             (setq end-node-to-insert Num)
             (setq end-node-included-p t))

            ((and (not end-have-find-p);;在Num个的前面
                  (< (cdr todo) (car (nth Num regions-list))))
             (setq end-have-find-p t)
             (setq end-node-to-insert Num)
             (setq end-node-included-p nil))
            
            (t nil)))

    (cond ((not beg-have-find-p);;都在最后
           (setq temp-list (list todo))
           nil)

          ((and beg-have-find-p;;末尾在最后, 前在节点中
                beg-node-included-p
                (not end-have-find-p))
           (setq temp-node (cons (car (nth beg-node-to-insert regions-list))(car todo)))
           (setq temp-list (nthcdr beg-node-to-insert regions-list))
           (setcar temp-list temp-node)
           (setcdr temp-list nil))
          
          ((and beg-have-find-p;;末尾在最后, 前在当中,不在节点中
                (not beg-node-included-p)
                (> beg-node-to-insert 0)
                (not end-have-find-p))
           (setq temp-pre (nthcdr (1- beg-node-to-insert) regions-list))
           (setcdr temp-pre nil))

          ((and beg-have-find-p;;末尾在最后, 前在最前,不在节点中
                (not beg-node-included-p)
                (= beg-node-to-insert 0)
                (not end-have-find-p))
           (setq regions-list nil))

          ((and beg-have-find-p ;;前后都在节点中, 即使后所在节点是0  (4 . 6) - (4 . 6)
                beg-node-included-p
                end-have-find-p
                end-node-included-p)
           (setq temp-pre (cons (car (nth beg-node-to-insert regions-list)) (car todo)))
           (setq temp-list (nthcdr beg-node-to-insert regions-list))
           (setq temp-node (cons (cdr todo) (cdr (nth end-node-to-insert regions-list))))
           (setq temp-next (nthcdr (1+ end-node-to-insert) regions-list))
           (setq temp-next (cons temp-node temp-next))
           (setcar temp-list temp-pre);;这个不能太早设,否则,可能会改变nth的结果, 比如((5 . 19)) - (6 . 18),就会
           (setcdr temp-list temp-next))

          ((and beg-have-find-p;;前在当中,不在节点中, 后在节点中, 即使后在最后一个节点中
                (not beg-node-included-p)
                (> beg-node-to-insert 0)
                end-have-find-p
                end-node-included-p)
           (setq temp-node (cons (cdr todo) (cdr (nth end-node-to-insert regions-list))))
           (setq temp-pre (nthcdr (1- beg-node-to-insert) regions-list))
           (setq temp-next (nthcdr (1+ end-node-to-insert) regions-list))
           (setcdr temp-pre (cons temp-node temp-next)))

          ((and beg-have-find-p;;前在最前, 后在节点中,即使是最后一个节点
                (not beg-node-included-p)
                (= beg-node-to-insert 0)
                end-have-find-p
                end-node-included-p)
           (setq temp-node (cons (cdr todo) (cdr (nth end-node-to-insert regions-list))))
           (setq temp-next (nthcdr end-node-to-insert regions-list))
           (setcar temp-next temp-node)
           (setq regions-list temp-next))

          ((and beg-have-find-p ;;都在第一个节点之前
                end-have-find-p
                (not end-node-included-p)
                (= end-node-to-insert 0))
           nil)

          ((and beg-have-find-p;;前后都在当中,但都不在节点中
                (not beg-node-included-p)
                (> beg-node-to-insert 0)
                end-have-find-p
                (not end-node-included-p)
                (> end-node-to-insert 0))
           (setq temp-pre (nthcdr (1- beg-node-to-insert) regions-list))           
           (setq temp-next (nthcdr end-node-to-insert regions-list))
           (setcdr temp-pre temp-next))

          ((and beg-have-find-p;;前在最前, 后在当中,但不在节点中
                (not beg-node-included-p)
                (= beg-node-to-insert 0)
                end-have-find-p
                (not end-node-included-p)
                (> end-node-to-insert 0))
           (setq regions-list (nthcdr end-node-to-insert regions-list))
           )

          ((and beg-have-find-p;;前在当中,在节点中,后在当中,不在节点中
                beg-node-included-p
                end-have-find-p
                (not end-node-included-p)
                (> end-node-to-insert 0))
           (setq temp-node (cons (car (nth beg-node-to-insert regions-list)) (car todo)))
           (setq temp-next (nthcdr end-node-to-insert regions-list))
           (setq temp-pre (nthcdr beg-node-to-insert regions-list))
           (setcar temp-pre temp-node)
           (setcdr temp-pre temp-next))
          (t nil))
    regions-list))

;;(setq zjl-regions-example '((4 . 7) (11 . 15) (17 . 17) (20 . 25)))
;;都在最后
;;(zjl-regions-delete zjl-regions-example '(27 . 28))
;;末尾在最后, 前在节点中
;;(zjl-regions-delete zjl-regions-example '(25 . 27))
;;(zjl-regions-delete zjl-regions-example '(18 . 27))
;;(zjl-regions-delete zjl-regions-example '(4 . 27))这个能够删除到没有!!!, 对的
;;(zjl-regions-delete zjl-regions-example '(5 . 25))
;;末尾在最后, 前在当中,不在节点中
;;(zjl-regions-delete zjl-regions-example '(16 . 27))
;;末尾在最后, 前在最前,不在节点中
;;(zjl-regions-delete zjl-regions-example '(3 . 27))

;;前后都在节点中, 即使后所在节点是0----下面这几个是后在节点中的可能
;;(zjl-regions-delete zjl-regions-example '(6 . 17))
;;(zjl-regions-delete zjl-regions-example '(4 . 4))
;;(zjl-regions-delete zjl-regions-example '(4 . 25))

;;前在当中,不在节点中, 后在节点中, 即使后在最后一个节点中
;;(zjl-regions-delete zjl-regions-example '(9 . 22))
;;前在最前, 后在节点中,即使是最后一个节点
;;(zjl-regions-delete zjl-regions-example '(1 . 22))
;;都在第一个节点之前
;;(zjl-regions-delete zjl-regions-example '(1 . 4))
;;(zjl-regions-delete zjl-regions-example '(2 . 3))

;;前后都在当中,但都不在节点中----后在当中,不在节点中
;;(zjl-regions-delete zjl-regions-example '(10 . 18))
;;(zjl-regions-delete zjl-regions-example '(10 . 11))
;;前在最前, 后在当中,但不在节点中
;;(zjl-regions-delete zjl-regions-example '(1 . 14))
;;前在当中,在节点中,后在当中,不在节点中
;;(zjl-regions-delete zjl-regions-example '(5 . 19))

;;极限下面的测试
;;((1 . 1))
;;()=nil时


;;;###autoload
;;; begin lisp code
(require 'highlight)

;;;###autoload
(defcustom zjl-hl-c-mode-enable-flag t
  "Enable c mode highlight when zjl-hl-enable-global-all is called"
  :type 'boolean :group 'zjl-hl)
;;;###autoload
(defcustom zjl-hl-c++-mode-enable-flag nil
  "Enable c++ mode highlight when zjl-hl-enable-global-all is called.
Currently only c style file but named as *.cpp is supported"
  :type 'boolean :group 'zjl-hl)
(defcustom zjl-hl-elisp-mode-enable-flag t
  "Enable emacs lisp mode highlight when zjl-hl-enable-global-all is called."
  :type 'boolean :group 'zjl-hl)

;;;###autoload
(defcustom zjl-hl-normal-size 40000
  "The size of erea that zjl-hl can highlight without any delay.
You can improve this if your computer has enough performance."
  :type 'integer :group 'zjl-hl)
;;;###autoload
(defcustom zjl-hl-toobig-size 10000000
  "The threshold size of function that zjl-hl will stop to highlight since it is too big. The size corresponds to the largest function found in current screen and
+-zjl-hl-numberofscreen-to-hl-each-time screens"
  :type 'integer :group 'zjl-hl)
;;;###autoload
(defcustom zjl-hl-toobig-not-update-size 1000000
  "The size of function that zjl-chl will stop to  highlight when the function is modified.
the function means those that inculded in current screen and +-zjl-hl-numberofscreen-to-hl-each-time
screens"
  :type 'integer :group 'zjl-hl)
;;;###autoload
(defcustom zjl-hl-numberofscreen-to-hl-each-time 2
  "The number of screens around current screen to highlight every time.
This variable is define for:
I use idle timer delay to begin highlight current screen when user stop to scroll screen
(so as to have no delay when scroll),but this cause the highlight happen delay 0.5sec
after we stop scroll screen, and this not feels so good. The way to void this(in some degree)
is highlighting [-zjl-hl-numberofscreen-to-hl-each-time +zjl-hl-numberofscreen-to-hl-each-time]
screens for each time zjl-hl work"
    :type 'integer :group 'zjl-hl)

;;;###autoload
(defcustom zjl-hl-firstscreen-hl-toggle nil
  "When not nil and when you open a new buffer, hl buffer before it shown on window.
this will cause delay that feel uncomfortable.Don't enable this unless your computer has
enough performance."
  :type 'boolean :group 'zjl-hl)


(setq zjl-hl-timer-obj nil)

(defface zjl-hl-font-lock-bracket-face
  '((((class color)
      (background dark))
     (:foreground "firebrick3"))
    (((class color)
      (background light))
     (:foreground "firebrick3"))
    (t
     ()))
  "*Font lock mode face for brackets, e.g. '(', ']', etc."
  :group 'zjl-hl-faces)
(defvar zjl-hl-font-lock-bracket-face 'zjl-hl-font-lock-bracket-face
  "Font lock mode face for backets.  Changing this directly
  affects only new buffers.")

(defface zjl-hl-operators-face
  '((((class color)
      (background dark))
     (:foreground "DarkGoldenrod4"))
    (((class color)
      (background light))
     (:foreground "DarkGoldenrod4"))
    (t
     ()))
  "*Font lock mode face for operater, e.g. '+', '-', etc."
  :group 'zjl-hl-faces)
(defvar zjl-hl-operators-face 'zjl-hl-operators-face)

(defface zjl-hl-member-reference-face
  '((((class color)
      (background dark))
     (:foreground "#008000"))
    (((class color)
      (background light))
     (:foreground "#008000"))
    (t
     ()))
  "*Font lock mode face for the struct member reference, e.g. b in \"a->b\"."
  :group 'zjl-hl-faces)
(defvar zjl-hl-member-reference-face 'zjl-hl-member-reference-face)

(defface zjl-hl-function-call-face
  '((((class color)
      (background dark))
     (:foreground "#008000" :bold t))
    (((class color)
      (background light))
     (:foreground "#008000" :bold t))
    (t
     ()))
  "*Font lock mode face for functioin calling."
  :group 'zjl-hl-faces)
(defvar zjl-hl-function-call-face 'zjl-hl-function-call-face)
;; (defvar zjl-hl-function-call-face 'font-lock-function-name-face)

(defface zjl-hl-local-variable-reference-face
  '((((class color)
      (background dark))
     (:foreground "#008080"))
    (((class color)
      (background light))
     (:foreground "#008080"))
    (t
     ()))
  "*Font lock mode face for variable in function body."
  :group 'zjl-hl-faces)
(defvar zjl-hl-local-variable-reference-face 'zjl-hl-local-variable-reference-face)
;; (defvar zjl-hl-local-variable-reference-face 'font-lock-variable-name-face)

(defface zjl-hl-parameters-reference-face
  '((((class color)
      (background dark))
     (:foreground "#008080" :bold t))
    (((class color)
      (background light))
     (:foreground "#008080" :bold t))
    (t
     ()))
  "*Font lock mode face for parameters in function body"
  :group 'zjl-hl-faces)
(defvar zjl-hl-parameters-reference-face 'zjl-hl-parameters-reference-face)

(defface zjl-hl-number-face
  '((((class color)
      (background dark))
     (:foreground "red"))
    (((class color)
      (background light))
     (:foreground "red"))
    (t
     ()))
  "*Font lock mode face for number, e.g. \"0xf5\" \"0.5\" \"234\", etc."
  :group 'zjl-hl-faces)
(defvar zjl-hl-number-face 'zjl-hl-number-face)

(defface zjl-hl-member-point-face
  '((((class color)
      (background dark))
     (:foreground "SpringGreen4"))
    (((class color)
      (background light))
     (:foreground "SpringGreen4"))
    (t
     ()))
  "*Font lock mode face for \"->\"."
  :group 'zjl-hl-faces)
(defvar zjl-hl-member-point-face 'zjl-hl-member-point-face)

;;comment should be #ff00000

(setq zjl-hl-operators-regexp
      (regexp-opt '("+" "-" "*" "/" "%" "!"
                    "&" "^" "~" "|"
                    "=" "<" ">"
                    "." "," ";" ":")))
(setq zjl-hl-brackets-regexp
      (regexp-opt '("(" ")" "[" "]" "{" "}")))
(setq zjl-hl-types-regexp
      (concat
       "\\_<[_a-zA-Z][_a-zA-Z0-9]*_t\\_>" "\\|"       
      (concat "\\_<" (regexp-opt '("unsigned" "int" "char" "float" "void" "UINT8" "UINT16" "UINT32") 'words) "\\_>")))

(setq zjl-hl-warning-words-regexp
      (concat "\\_<" (regexp-opt '("FIXME" "TODO" "BUG" "XXX" "DEBUG")) "\\_>"))


(setq zjl-hl-c-mode-keywords (list
       '("->"
          0  zjl-hl-member-point-face keep) ;;should put before the c-operators
       (cons zjl-hl-operators-regexp (cons 0  '(zjl-hl-operators-face keep)))       
       (cons zjl-hl-brackets-regexp 'zjl-hl-font-lock-bracket-face)
       (cons zjl-hl-types-regexp 'font-lock-type-face)
       (cons zjl-hl-warning-words-regexp 'font-lock-warning-face)
       '("\\(\\_<\\(?:\\(?:0x[0-9a-fA-F]*\\)\\|\\(?:[0-9]+\\(\\.[0-9]+\\)?\\)\\|\\(?:0[0-7]*\\)\\|\\(?:[01]+b\\)\\)\\_>\\)"
        0  zjl-hl-number-face keep)
       '("\\(?:\\.\\|->\\)\\(\\_<\\(?:\\w\\|\\s_\\)+\\_>\\)"
         1  zjl-hl-member-reference-face keep)
       '("\\(\\_<\\(\\w\\|\\s_\\)+\\_>\\)[ 	]*("
         1  zjl-hl-function-call-face keep)
       ))









;;; begin lisp code
;;DarkGoldenrod4
;;SaddleBrown
;;RosyBrown
(defface zjl-elisp-hl-function-call-face
  '((((class color)
      (background dark))
     (:foreground "darkgreen"))
    (((class color)
      (background light))
     (:foreground "firebrick"))
    (t
     ()))
  "*Face used for link privilege indicator (l) in dired buffers."
  :group 'zjl-elisp-hl-faces)
(defvar zjl-elisp-hl-function-call-face 'zjl-elisp-hl-function-call-face)
;; (defvar zjl-elisp-hl-function-call-face 'font-lock-function-name-face)
;;(setq zjl-elisp-hl-function-call-face 'zjl-elisp-hl-function-call-face9)


(defface zjl-elisp-hl-setq-face
  '((((class color)
      (background dark))
     (:foreground "dark slate grey"))
    (((class color)
      (background light))
     (:foreground "RosyBrown"))
    (t
     ()))
  "*Face used for link privilege indicator (l) in dired buffers."
  :group 'zjl-elisp-hl-faces)
(defvar zjl-elisp-hl-setq-face 'zjl-elisp-hl-setq-face)
;(setq zjl-elisp-hl-setq-face 'zjl-elisp-hl-setq-face6)

(defface zjl-elisp-hl-number-face
  '((((class color)
      (background dark))
     (:foreground "red"))
    (((class color)
      (background light))
     (:foreground "red"))
    (t
     ()))
  "*Face used for link privilege indicator (l) in dired buffers."
  :group 'zjl-elisp-hl-faces)
(defvar zjl-elisp-hl-number-face 'zjl-elisp-hl-number-face)


(setq zjl-hl-emacs-lisp-mode-keywords '(("\\(\\_<\\(?:\\(?:0x[0-9a-fA-F]*\\)\\|\\(?:[0-9]+\\(\\.[0-9]+\\)?\\)\\|\\(?:0[0-7]*\\)\\|\\(?:[01]+b\\)\\|nil\\|t\\)\\_>\\)"
          0  zjl-elisp-hl-number-face keep)
                             ("\\(\\_<setq\\_>\\)" 0  zjl-elisp-hl-setq-face keep)                             
                             ("([ 	]*\\(\\_<\\(?:\\w\\|\\s_\\)+\\_>\\)" 1  zjl-elisp-hl-function-call-face keep)
                             ))




;;;###autoload
(defun zjl-hl-local-variable-and-parameter-in-func-region (start end )
  (let* ((local-variable-list '())
         (parameter-list '())                
         (func-body-begin (funcall zjl-hl-get-body-begin start end))
         (case-fold-search nil)
         items
         item
         successful)          
    (save-excursion
      (condition-case nil         
          (when func-body-begin                               
            (goto-char func-body-begin)
            (setq items (semantic-get-local-variables))
            (unless items
              (semantic-parse-region start end);;force reparse, idea from ecb-method
              (setq items (semantic-get-local-variables)))
            (when items
              (dolist (item items)
                (setq local-variable-list (cons (car item) local-variable-list))))
            (setq items (semantic-get-local-arguments))
            (unless items
              (semantic-parse-region start end);;force reparse, idea from ecb-method
              (setq items (semantic-get-local-arguments)))
            (when items
              (dolist (item items)
                (setq parameter-list (cons (car item) parameter-list))))
            (save-excursion
              (when parameter-list
                (case major-mode
                  ('c-mode (zjl-hl-symbol-region func-body-begin end (concat "\\_<" (regexp-opt parameter-list) "\\_>") zjl-hl-parameters-reference-face t t t))
                  ('c++-mode (zjl-hl-symbol-region func-body-begin end (concat "\\_<" (regexp-opt parameter-list) "\\_>") zjl-hl-parameters-reference-face t t t))
                  ('emacs-lisp-mode (zjl-hl-symbol-region start end (concat "\\_<" (regexp-opt parameter-list) "\\_>") zjl-hl-parameters-reference-face t t t)))                
                
                (setq successful t))
              (when local-variable-list
                (case major-mode
                  ('c-mode (zjl-hl-symbol-region func-body-begin end (concat "\\_<" (regexp-opt local-variable-list) "\\_>")  zjl-hl-local-variable-reference-face t t t))
                  ('c++-mode (zjl-hl-symbol-region func-body-begin end (concat "\\_<" (regexp-opt local-variable-list) "\\_>")  zjl-hl-local-variable-reference-face t t t))
                  ('emacs-lisp-mode (zjl-hl-symbol-region start end (concat "\\_<" (regexp-opt local-variable-list) "\\_>")  zjl-hl-local-variable-reference-face t t t)))
                (setq successful t)))
              )
        (error nil)))
    successful))

;;;###autoload
(defun zjl-hl-symbol-region (start end symbol-exp symbol-face override-c-mode override-my override-nil)
  (let (target-this-end target-next-start (case-fold-search nil) pos-pair)
    (save-excursion
      (goto-char start)
      (while   (< (point) end)
        (setq pos-pair (funcall zjl-hl-next-comment-pos (point) end))
        (if pos-pair
            (progn
              (setq target-this-end (car pos-pair))
              (setq target-next-start (cdr pos-pair)))
          (setq target-this-end end)
          (setq target-next-start end))
        (if override-c-mode
            (progn (hlt-highlight-regexp-region (point) target-this-end symbol-exp symbol-face)
                   (goto-char target-next-start))
          (while (and (re-search-forward symbol-exp target-this-end t)
                      (save-excursion
                        (re-search-backward symbol-exp)
                        (not (looking-back "\\.\\|->"))))
            (backward-char)
            (when (or 
                   (and override-my
                        (or (equal (get-char-property (point) 'face) 'zjl-hl-parameters-reference-face)
                            (equal (get-char-property (point) 'face) 'zjl-hl-local-variable-reference-face)
                            (not (zjl-hl-what-face))))
                   (and override-nil
                        (not (zjl-hl-what-face))))
              (let ((symbol-boundaries (bounds-of-thing-at-point 'symbol)))
                (hlt-highlight-regexp-region (car symbol-boundaries) (cdr symbol-boundaries) ".*" symbol-face)))
            (forward-char))
          (goto-char target-next-start))))))

;;;###autoload
(defun zjl-hl-find-regexp-goto-end (start end regexp);;if find, return point after the re-search, else return nil
  (let (target-this-end target-next-start (case-fold-search nil) find-p pos-pair)
    (save-excursion
      (goto-char start)
      (while   (< (point) end)
        (setq pos-pair (funcall zjl-hl-next-comment-pos (point) end))
        (if pos-pair
            (progn
              (setq target-this-end (car pos-pair))
              (setq target-next-start (cdr pos-pair)))
          (setq target-this-end end)
          (setq target-next-start end))
        (setq find-p (re-search-forward regexp target-this-end t))
        (if find-p
            (progn  (setq find-p (point))
                    (goto-char end))
          (goto-char target-next-start))))
        find-p))


;;;###autoload
(defun zjl-hl-local-variable-and-parameter-region (start end)
  (save-excursion
    (hlt-unhighlight-region-for-face zjl-hl-parameters-reference-face start end)
    (hlt-unhighlight-region-for-face zjl-hl-local-variable-reference-face start end)
    
    (let ((regions (funcall zjl-hl-find-hl-var-arg-regions start end))
          (successful t))
      (dolist (each-region regions)
        (setq  successful (and (zjl-hl-local-variable-and-parameter-in-func-region (car each-region) (cdr each-region))
                               successful)))
      successful)
    ))

;;borrow from http://stackoverflow.com/questions/1242352/get-font-face-under-cursor-in-emacs
;;;###autoload
(defun zjl-hl-what-face ()
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    face))


;;;###autoload
(defun zjl-hl-func-too-big-stop-reset(thisbuffer)
  (save-excursion
    (when (buffer-live-p thisbuffer)
      (set-buffer thisbuffer)
      (setq zjl-hl-func-too-big-stop 1)
      (setq zjl-hl-func-too-big-interval 1)
      (setq zjl-hl-func-too-big-timer-registed nil))))

;;;###autoload
(defun zjl-hl-timer-do-every-time (thisbuffer)
  (condition-case nil
      (save-excursion
        (when (buffer-live-p thisbuffer)
          (with-current-buffer thisbuffer
            (when (get-buffer-window)
            (let(start end temp-regions temptime (all-regions-successful t))
              ;;current-screen not include  window-end this point, but it is ok to include it from hl.
              (if (and (window-end) (window-start))
                  (progn
                    (setq start (copy-marker (max (point-min);; hl eary around screen window
                                                  (- (window-start)
                                                     (* zjl-hl-numberofscreen-to-hl-each-time (- (window-end) (window-start)))))))
                    (setq end (copy-marker (min (point-max)
                                                (+ (window-end)
                                                   (* zjl-hl-numberofscreen-to-hl-each-time (- (window-end) (window-start))))))))
                (progn
                  (setq end (point-max-marker))
                  (setq start (point-min-marker))))

              (setq start (save-excursion
                            (goto-char start)
                            (if (beginning-of-defun) 
                                (point-marker)
                              start)))
              (setq end (save-excursion
                            (goto-char end)
                            (if (let ((orginal (point)));;for end-of-defun's bug,  it return nil whenever it is called
                                  (end-of-defun)
                                  (/= (point) orginal))
                                (point-marker)
                              end)))
              (when (and (< (- end start) zjl-hl-toobig-size)
                         (or (< (- end start) zjl-hl-normal-size)
                             (< zjl-hl-func-too-big-stop 2)))
                (setq temp-regions (list (cons start end)))
                (dolist (hl-region zjl-hl-regions-already-hl)
                  (setq temp-regions (zjl-regions-delete temp-regions hl-region)))
                (when temp-regions
                  (dolist (each-region temp-regions)
                    (if (zjl-hl-local-variable-and-parameter-region (car each-region) (cdr each-region))
                    (setq zjl-hl-regions-already-hl (zjl-regions-add zjl-hl-regions-already-hl each-region t)) ;; t means merge hl-regions
                    (setq all-regions-successful nil)))

                  (when all-regions-successful
                    (when (and (> (- end start) zjl-hl-normal-size)
                               (< zjl-hl-func-too-big-stop 2))          
                      (setq zjl-hl-func-too-big-stop (1+ zjl-hl-func-too-big-stop)))

                    (when (and (> (- end start) zjl-hl-normal-size)
                               (<= zjl-hl-func-too-big-stop 2))
                      (setq temptime  (/ (- end start) (/ zjl-hl-normal-size 8)))
                      (setq zjl-hl-func-too-big-interval (max temptime zjl-hl-func-too-big-interval)))
                    (when (and (equal zjl-hl-func-too-big-stop 2)
                               (not zjl-hl-func-too-big-timer-registed))
                      (run-with-idle-timer zjl-hl-func-too-big-interval nil 'zjl-hl-func-too-big-stop-reset (current-buffer))
                      (setq zjl-hl-func-too-big-timer-registed t)))))))
                    ))
        )        (error nil))
 )

;;;###autoload
(defun zjl-hl-window-scroll-hook(par1 par2)
  (save-excursion
    (when (and (get-buffer-window)
               (or (equal major-mode 'c-mode)
                   (equal major-mode 'c++-mode)
                   (equal major-mode 'emacs-lisp-mode));;for sometimes maybe major-mode is change, and this hook still running, I guess this is need
               )
      (when zjl-hl-firsttime
        (add-hook 'semantic-after-partial-cache-change-hook 'zjl-hl-semantic-after-partial-cache-change-hook t t)
        (setq zjl-hl-firsttime nil))

      ;;this should before if, to canel possbile hl timer, before zjl-hl-timer-do-every-time realy begin
      (when zjl-hl-timer-obj
        (cancel-timer zjl-hl-timer-obj))
      
      (if zjl-hl-firsttime-need-hl
          (progn (zjl-hl-timer-do-every-time (current-buffer))
                 (setq zjl-hl-firsttime-need-hl nil))
        
        (setq zjl-hl-timer-obj (run-with-idle-timer 0.5 nil 'zjl-hl-timer-do-every-time (current-buffer)))
        ))))

;;;###autoload
(defun zjl-hl-init ()
  (save-excursion
      (let (start end)
        (make-local-variable 'zjl-hl-func-too-big-stop)
        (make-local-variable 'zjl-hl-func-too-big-interval)
        (make-local-variable 'zjl-hl-func-too-big-timer-registed)
        (make-local-variable 'zjl-hl-firsttime)
        (make-local-variable 'zjl-hl-firsttime-need-hl)
        (make-local-variable 'zjl-hl-regions-already-hl)
        
        (setq zjl-hl-regions-already-hl nil)
        (setq zjl-hl-func-too-big-timer-registed nil)
        (setq zjl-hl-func-too-big-stop 0)
        (setq zjl-hl-func-too-big-interval 1)
        (setq zjl-hl-firsttime t)
        
        (make-local-variable 'zjl-hl-find-hl-var-arg-regions)
        (setq zjl-hl-find-hl-var-arg-regions
              (case major-mode
                ('c-mode 'zjl-hl-find-hl-var-arg-regions-c)
                ('c++-mode 'zjl-hl-find-hl-var-arg-regions-c)
                ('emacs-lisp-mode 'zjl-hl-find-hl-var-arg-regions-elisp)))

        (make-local-variable 'zjl-hl-next-comment-pos)
        (setq zjl-hl-next-comment-pos
              (case major-mode
                ('c-mode 'zjl-hl-next-comment-pos-c)
                ('c++-mode 'zjl-hl-next-comment-pos-c)
                ('emacs-lisp-mode 'zjl-hl-next-comment-pos-elisp)))

        (make-local-variable 'zjl-hl-get-body-begin)
        (setq zjl-hl-get-body-begin
              (case major-mode
                ('c-mode 'zjl-hl-get-body-begin-c)
                ('c++-mode 'zjl-hl-get-body-begin-c)
                ('emacs-lisp-mode 'zjl-hl-get-body-begin-elisp)))

        
        (setq zjl-hl-firsttime-need-hl nil)
        
        (when zjl-hl-firstscreen-hl-toggle
          (setq start (copy-marker (max (point-min);; hl early around screen window
                         (- (window-start)
                                         (* zjl-hl-numberofscreen-to-hl-each-time (- (window-end) (window-start)))))))
        (setq end (copy-marker (min (point-max)
                       (+ (window-end)
                                       (* zjl-hl-numberofscreen-to-hl-each-time (- (window-end) (window-start)))))))
        (if (< (- end start) zjl-hl-normal-size)
            (setq zjl-hl-firsttime-need-hl t)
          (setq zjl-hl-firsttime-need-hl nil)))
        
        (add-hook 'window-scroll-functions 'zjl-hl-window-scroll-hook t t))))


;idea from how ecb update method buffer
;;(add-hook (ecb--semantic-after-partial-cache-change-hook) 'ecb-update-after-partial-reparse t)
;;(add-hook (ecb--semantic-after-toplevel-cache-change-hook) 'ecb-rebuild-methods-buffer-with-tagcache t)
;;;###autoload
(defun zjl-hl-semantic-after-partial-cache-change-hook (updated-tags)
  (when zjl-hl-regions-already-hl  ;;maybe zjl-hl-init has not hl any where
    (let (start end overlay todo)
      (dolist (tags updated-tags)
        (setq overlay (semantic-tag-overlay tags))
        (setq todo (cons (overlay-start overlay) (overlay-end overlay)))
        (setq zjl-hl-regions-already-hl (zjl-regions-delete zjl-hl-regions-already-hl todo))
        )
      (when (< (- (overlay-end overlay) (overlay-start overlay)) zjl-hl-toobig-not-update-size)
        (zjl-hl-window-scroll-hook 1 1)))))

;;;###autoload
(defun zjl-hl-enable-global-all ()
  (interactive)
  (when zjl-hl-c-mode-enable-flag
    (zjl-hl-enable-global 'c-mode))
  (when zjl-hl-c++-mode-enable-flag
    (zjl-hl-enable-global 'c++-mode))
  (when zjl-hl-elisp-mode-enable-flag
    (zjl-hl-enable-global 'emacs-lisp-mode))
  )

;;;###autoload
(defun zjl-hl-disable-global-all ()
  (interactive)
  (when zjl-hl-c-mode-enable-flag
    (zjl-hl-disable-global 'c-mode))
  (when zjl-hl-c++-mode-enable-flag
     (zjl-hl-disable-global 'c++-mode))
  (when zjl-hl-elisp-mode-enable-flag
    (zjl-hl-disable-global 'emacs-lisp-mode)))

;;;###autoload
(defun zjl-hl-enable-global (mode)
  (let ((mode-name (symbol-name mode)) hook keywords)
    (setq keywords (intern-soft (concat "zjl-hl-" mode-name "-keywords")))
    (font-lock-add-keywords mode (symbol-value keywords) 1)
    (setq hook (intern-soft (concat mode-name "-hook")))
    (add-hook hook 'zjl-hl-init)))

;;;###autoload
(defun zjl-hl-disable-global (mode)
  (let ((mode-name (symbol-name mode)) hook keywords)
    (setq keywords (intern-soft (concat "zjl-hl-" mode-name "-keywords")))
    (font-lock-remove-keywords mode (symbol-value keywords))
    (setq hook (intern-soft (concat mode-name "-hook")))
    (remove-hook hook 'zjl-hl-init)))



;;;###autoload
(defun zjl-hl-get-body-begin-c (start end);;if has no begin, return nil, (zjl-hl-find-regexp-goto-end) may return nil
(save-excursion
  (goto-char start)
  (zjl-hl-find-regexp-goto-end start end "{")))

;;;###autoload
(defun zjl-hl-get-body-begin-elisp (start end);;if has no begin, return nil
  (save-excursion
    (let (pos1 pos2 letfinded)
      (goto-char start)
      (setq letfinded (re-search-forward "let" nil t))
      (if (setq pos1 (and letfinded
                          (zjl-hl-find-regexp-goto-end letfinded end "(")));; (zjl-hl-find-regexp-goto-end) may return nil
          (progn
            (setq pos1 (1- pos1))
            (goto-char pos1)
            (forward-sexp)
            (setq pos2 (point))
            (if (/= pos1 pos2)
                pos2
              nil))
        nil)
      )))

;;;###autoload
(defun zjl-hl-find-hl-var-arg-regions-c (start end)
  (save-excursion
    (goto-char start)
    (let (defun-start defun-end regions)
      (while (and (setq defun-end 
                        (if (let ((orginal (point)));;for end-of-defun's bug,  it return nil whenever it is called
                              (end-of-defun)
                              (/= (point) orginal))
                            (point)
                          nil))
                  (setq defun-start
                        (if (beginning-of-defun)
                            (point)
                          nil))
                  (< defun-start end))
        (setq regions  (cons (cons defun-start defun-end) regions))
        (goto-char defun-end))
      regions)))

;; (progn (re-search-forward  "([ 	]*let" nil t)
;;        (goto-char (match-beginning 0)))

;;;###autoload
(defun zjl-hl-find-hl-var-arg-regions-elisp (start end)
  (save-excursion
    (goto-char start)
    (let (defun-start defun-end regions)
      (while (and (re-search-forward  "(let\\*?[ 	
]*" end t)
                  (<= (match-beginning 0) end)
                  )
        (setq defun-start (match-beginning 0))
        (goto-char defun-start)
        (forward-sexp);;this function do not return t even if it forward successfully
        (setq defun-end (point))
        (when (/= defun-end defun-start)
          (setq regions  (cons (cons defun-start defun-end) regions))
          (goto-char (+ 2 defun-start))))
      regions)))


;;;###autoload
(defun zjl-hl-next-comment-pos-c (start end)
  (save-excursion
    (let (next-comment-start next-comment-exist comment-pos-1 comment-pos-2 min-pos pos-pair)
      (goto-char start)
      (save-excursion
        (if (re-search-forward "/\\*" end t)
            (progn 
              (setq comment-pos-1 (point))
              (setq next-comment-exist t))
          (setq comment-pos-1 end)))
      (save-excursion 
        (if (re-search-forward "//" end t)
            (progn
              (setq comment-pos-2 (point))
              (setq next-comment-exist t))
          (setq comment-pos-2 end)))
      (when next-comment-exist
        (setq min-pos (min comment-pos-1 comment-pos-2))
        (setq next-comment-start (- min-pos 2))
        (cond
         ((equal comment-pos-2 min-pos) 
          (goto-char min-pos)
          (end-of-line))
         ((equal comment-pos-1 min-pos)
          (unless (re-search-forward "\\*/" end t)
            (goto-char end))))
        (setq pos-pair (cons next-comment-start (point)))
        )
      pos-pair)))

;;;###autoload
(defun zjl-hl-next-comment-pos-elisp (start end)
  (save-excursion
    (let (next-comment-start next-comment-exist comment-pos-1 comment-pos-2 min-pos pos-pair)
      (goto-char start)
      (save-excursion
        (if (re-search-forward "\"" end t)
            (progn 
              (setq comment-pos-1 (point))
              (setq next-comment-exist t))
          (setq comment-pos-1 end)))
      (save-excursion 
        (if (re-search-forward ";" end t)
            (progn
              (setq comment-pos-2 (point))
              (setq next-comment-exist t))
          (setq comment-pos-2 end)))
      (when next-comment-exist
        (setq min-pos (min comment-pos-1 comment-pos-2))
        (setq next-comment-start (- min-pos 1))
        (cond
         ((equal comment-pos-2 min-pos) 
          (goto-char min-pos)
          (end-of-line))
         ((equal comment-pos-1 min-pos)
          (goto-char next-comment-start)
          (forward-sexp)))
        (setq pos-pair (cons next-comment-start (point)))
        )
      pos-pair)))

(zjl-hl-enable-global-all);(zjl-hl-disable-global-all)
(provide 'zjl-hl)
;;; end lisp code 
