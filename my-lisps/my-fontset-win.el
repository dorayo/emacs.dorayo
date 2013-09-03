;;-*- coding: utf-8 -*-
;; ############## font setting ###################
;; *ONLY* for windows
;; Usage:
;; Put this file into your load-path
;; and add following into your ~/.emacs file:
;;   (load "fontset-win")
;;   (huangq-fontset-courier 17)
;;
;; it uses Courier New 17 and 新宋体 20 by default
;; I suppose you have Courier New and 新宋体
;;
;; To change default font, add following lines in ~/.emacs:
;;   (load "fontset-win")
;;   (setq my-latin-font "Monaco")
;;   (setq my-latin-size 15)
;;   (huangq-set-font my-latin-size)
;;
;; OR:
;;   (huangq-fontset-monaco 15)
;;
;; To change the font size:
;;    M-x huangq-set-font <RET> FONT-SIZE
;; or press C-x <RET> s
;;
;; To change font:
;;    M-x huangq-fontset-monaco <RET>
;;
;; Following presets are available:
;; huangq-fontset-courier       ;; Courier New 
;; huangq-fontset-monaco        ;; Monaco
;; huangq-fontset-lucida        ;; Lucida Sans Typewriter 
;; huangq-fontset-consolas      ;; Consolas + 微软雅黑
;; huangq-fontset-consolas0     ;; Consolas + 新宋体
;; huangq-fontset-dejavu        ;; DejaVu Sans Mono
;;
;; Of course, you should download these fonts yourself
;;
;; Note: the frame size may change during the change of fontset!

(defvar my-latin-font "Courier New")
(defvar my-chinese-font "新宋体")
(defvar my-fontset "fontset-courier")

(defvar my-latin-size 17)
(defvar my-chinese-size 20)


(create-fontset-from-fontset-spec
 "-outline-Courier New-normal-r-*-*-17-97-96-96-c-*-fontset-courier")

(create-fontset-from-fontset-spec
 "-outline-Monaco-normal-r-*-*-15-*-96-96-c-*-fontset-monaco")

(create-fontset-from-fontset-spec
 "-outline-Lucida Sans Typewriter-normal-r-*-*-15-*-96-96-c-*-fontset-lucida")

(create-fontset-from-fontset-spec
 "-outline-DejaVu Sans Mono-normal-r-*-*-15-*-96-96-c-*-fontset-dejavu")

(create-fontset-from-fontset-spec
 "-outline-Consolas-normal-r-*-*-15-*-96-96-c-*-fontset-consolas")

(defun huangq-set-font (latin-size &optional chinese-size)
  (interactive "nLatin Font Size: ")
  (cond
   ((string= my-latin-font "Monaco")    
    (setq my-fontset "fontset-monaco"))
   ((string= my-latin-font "Lucida Sans Typewriter")
    (setq my-fontset "fontset-lucida"))
   ((string= my-latin-font "Consolas")
    (setq my-fontset "fontset-consolas"))
   ((string= my-latin-font "DejaVu Sans Mono")
    (setq my-fontset "fontset-dejavu"))
   ((string= my-latin-font "Courier New")
    (setq my-fontset "fontset-courier"))
   (t
    (setq my-fontset "fontset-courier")))
  (setq my-latin-size latin-size)
  ;; chinese-size is normally not same as latin-size
  (unless chinese-size      
    (setq chinese-size
          (if (string= my-latin-font "Consolas")
              (cond
               ((<= latin-size 20) (+ 1 latin-size))
               ((<= latin-size 33) (+ 3 latin-size))
               (t (+ 4 latin-size)))
          (cond
           ((<= latin-size 24) (+ 3 latin-size))
           ((<= latin-size 29)  (+ 5 latin-size))
           (t (+ 6 latin-size)))
          )))
  (setq my-chinese-size chinese-size)
  ;; the font-name format of 微软雅黑 might be different from 新宋体
  (let ((latin-font
         (format
          (concat "-outline-" my-latin-font "-*-*-*-*-%d-97-96-96-c-*-iso8859-1")
          latin-size))
        (chinese-font
         (format
          (if (string= my-chinese-font "微软雅黑")
;;           (decode-coding-string              
              (concat "-outline-" my-chinese-font "-*-r-*-*-%d-*-96-96-p-*-iso10646-1")
;;            'utf-8)
;;           (decode-coding-string              
            (concat "-outline-" my-chinese-font "-*-r-*-*-%d-*-96-96-c-*-iso10646-1")
;;            'utf-8)
            )
          chinese-size)))
    ;; set font for all charsets
    (set-fontset-font			
     my-fontset nil chinese-font nil 'prepend)
    (set-fontset-font
     my-fontset 'ascii latin-font nil 'prepend)
    (set-fontset-font
     my-fontset 'latin latin-font nil 'prepend)
    (set-fontset-font
     my-fontset 'kana chinese-font nil 'prepend)
    (set-fontset-font
     my-fontset 'han chinese-font nil 'prepend)
    (set-fontset-font
     my-fontset 'cjk-misc chinese-font nil 'prepend)
    (set-fontset-font
     my-fontset 'symbol chinese-font nil 'prepend)
    ;; use the font
    (set-default-font my-fontset)
    )
  (message "Current Latin font: %s, font size: %d, chinese font size: %d"
           my-latin-font my-latin-size my-chinese-size))

;; (set-fontset-font
;;  "fontset-consolas" 'han
;;  "-outline-微软雅黑-normal-r-*-*-16-*-96-96-p-*-iso10646-1" nil 'prepend)

(defun huangq-fontset-monaco (&optional size)
  (interactive "P")
  (setq my-latin-font "Monaco")
  (setq my-chinese-font "新宋体")
  (if size
      (setq my-latin-size size))
    ;;(setq my-latin-size 14))
  (huangq-set-font my-latin-size))

(defun huangq-fontset-lucida (&optional size)
  (interactive "P")
  (setq my-latin-font "Lucida Sans Typewriter")
  (setq my-chinese-font "新宋体")
  (if size
      (setq my-latin-size size))
    ;;(setq my-latin-size 15))
  (huangq-set-font my-latin-size))

(defun huangq-fontset-courier (&optional size)
  (interactive "P")
  (setq my-latin-font "Courier New")
  (setq my-chinese-font "新宋体")
  (if size
      (setq my-latin-size size))
    ;;(setq my-latin-size 17))
  (huangq-set-font my-latin-size))

(defun huangq-fontset-dejavu (&optional size)
  (interactive "P")
  (setq my-latin-font "DejaVu Sans Mono")
  (setq my-chinese-font "新宋体")  
  (if size
      (setq my-latin-size size))
    ;;(setq my-latin-size 15))
  (huangq-set-font my-latin-size))

(defun huangq-fontset-fixedsys (&optional size)
  (interactive "P")
  (setq my-latin-font "Fixedsys Excelsior 2.00")
  (setq my-chinese-font "新宋体")
  (when size
      (setq my-latin-size size)
      (setq my-chinese-size (+ 1 size)))
  (huangq-set-font my-latin-size my-chinese-size))

(defun huangq-fontset-consolas (&optional size)
  (interactive "P")
  (setq my-latin-font "Consolas")
  (setq my-chinese-font "微软雅黑")
  (when size
    (setq my-latin-size size))
  (huangq-set-font my-latin-size))

(defun huangq-fontset-consolas0 (&optional size)
  (interactive "P")
  (setq my-latin-font "Consolas")
  (setq my-chinese-font "新宋体")  
  (if size
      (setq my-latin-size size))
  (huangq-set-font my-latin-size))

(provide 'my-fontset-win)
