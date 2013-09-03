;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-18 22:31:55 Saturday by taoshanwen>

(require 'util)

;; 我自定义的一些face
(defface white-face
  '((((class color)) :foreground "white"))
  "我自定义的white face")
(defface white-red-face
  '((((class color) (background dark)) :foreground "white" :background "red") (t ()))
  "我自定义的white-red face")
(defface red-face
  '((((class color)) :foreground "red"))
  "我自定义的red face")
(defface darkred-face
  '((((type tty pc)) :bold t :foreground "red") (t (:foreground "red")))
  "我自定义的dark red face")
(defface red-face
  '((((class color) (background dark)) (:foreground "red")) (t ()))
  "我自定义的red face")
(defface green-face
  '((((class color)) :foreground "green"))
  "我自定义的green face")
(defface darkgreen-face
  '((((type tty pc)) :bold t :foreground "green") (t (:foreground "green")))
  "我自定义的dark green face")
(defface blue-face
  '((((type tty pc)) :foreground "blue") (t (:foreground "blue")))
  "我自定义的blue face")
(defface light-blue-face
  '((((type tty pc)) :foreground "blue")
    (t :foreground "cornflower blue"))
  "淡蓝色.")
(defface beautiful-blue-face
  '((((class grayscale) (background light)) :foreground "LightGray" :weight bold)
    (((class grayscale) (background dark)) :foreground "DimGray" :weight bold)
    (((class color) (min-colors 88) (background light)) :foreground "Orchid")
    (((class color) (min-colors 88) (background dark)) :foreground "cornflower blue")
    (((class color) (min-colors 16) (background light)) :foreground "Orchid")
    (((class color) (min-colors 16) (background dark)) :foreground "LightSteelBlue")
    (((class color) (min-colors 8)) (:foreground "blue" :weight bold))
    (t (:weight bold)))
  "漂亮的蓝色.")
(defface beautiful-blue-red-face
  '((((class grayscale) (background light)) (:foreground "red" :background "LightGray" :weight bold))
    (((class grayscale) (background dark)) (:foreground "red" :background "DimGray" :weight bold))
    (((class color) (min-colors 88) (background light)) (:foreground "red" :background "Orchid"))
    (((class color) (min-colors 88) (background dark)) (:foreground "red" :background "cornflower blue"))
    (((class color) (min-colors 16) (background light)) (:foreground "red" :background "Orchid"))
    (((class color) (min-colors 16) (background dark)) (:foreground "red" :background "LightSteelBlue"))
    (((class color) (min-colors 8)) (:foreground "red" :background "blue" :weight bold))
    (t (:weight bold)))
  "背景色为漂亮的蓝色, 前景色为红色.")
(defface darkblue-face
  '((((type tty pc)) :bold t :foreground "blue") (t (:foreground "blue")))
  "我自定义的dark blue face")
(defface lightblue-face
  '((((type tty pc)) :foreground "blue")
    (t :foreground "cornflower blue"))
  "我自定义的lightblue face")
(defface yellow-face
  '((t :foreground "yellow"))
  "我自定义的yellow face")
(defface darkyellow-face
  '((((type tty pc)) :bold t :foreground "yellow") (t (:foreground "yellow")))
  "我自定义的dark yellow face")
(defface cyan-face
  '((t :foreground "cyan"))
  "我自定义的cyan face")
(defface darkcyan-face
  '((((type tty pc)) :bold t :foreground "cyan") (t (:foreground "cyan")))
  "我自定义的dark cyan face")
(defface magenta-face
  '((((class color)) :foreground "magenta"))
  "我自定义的magenta face")
(defface darkmagenta-face
  '((((type tty pc)) :bold t :foreground "magenta") (t (:foreground "magenta")))
  "我自定义的magenta face")
(defface underline-green-face
  '((((class color) (background dark)) (:underline t :foreground "green")) (t ()))
  "我自定义的underline green face")
(defface underline-face
  '((((class color) (background dark)) (:underline t)) (t ()))
  "我自定义的underline face")
(defface black-red-face
  '((((class color) (background dark)) (:foreground "black" :background "red")) (t ()))
  "我自定义的black-red face")
(defface green-red-face
  '((((class color) (background dark)) (:foreground "green" :background "red")) (t ()))
  "我自定义的green-red face")
(defface yellow-red-face
  '((((class color) (background dark)) (:foreground "yellow" :background "red")) (t ()))
  "我自定义的yellow-red face")
(defface yellow-blue-face
  '((((class color) (background dark)) (:foreground "yellow" :background "blue")) (t ()))
  "我自定义的yellow-blue face")
(defface yellow-forestgreen-face
  '((((class color) (background dark)) :foreground "yellow" :background "forest green") (t ()))
  "我自定义的yellow-forestgreen face")
(defface red-yellow-face
  '((((class color) (background dark)) (:foreground "red" :background "yellow")) (t ()))
  "我自定义的red-yellow face")
(defface red-blue-face
  '((((class color) (background dark)) (:foreground "red" :background "blue")) (t ()))
  "我自定义的red-blue face")

(defface region-invert nil "Invert of face region.")

(apply-args-list-to-fun
 'defvar
 `((beautiful-blue-face 'beautiful-blue-face)
   (darkgreen-face      'darkgreen-face)
   (darkred-face        'darkred-face)
   (darkyellow-face     'darkyellow-face)
   (darkmagenta-face    'darkmagenta-face)
   (darkcyan-face       'darkcyan-face)
   (yellow-face         'yellow-face)
   (green-face          'green-face)
   (cyan-face           'cyan-face)))

(provide 'ahei-face)
