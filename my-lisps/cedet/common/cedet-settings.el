;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-08-28 21:03:22 Saturday by taoshanwen>

;; cedet1.0pre6 is conflict with which-func
;; after require cedet, which-func cann't work

;; http://emacser.com/install-cedet.htm
;; http://emacser.com/cedet.htm

(when mswin
  (defvar cedet-path (concat my-emacs-lisps-path "cedet") "Path of `cedet'")
  (my-add-subdirs-to-load-path cedet-path))

(require 'cedet)
(require 'cedet-eieio-settings)
(require 'cedet-ede-settings)
(require 'cedet-cogre-settings)
(require 'cedet-semantic-settings)
(require 'cedet-srecode-settings)
(require 'cedet-speedbar-settings)

;; 用pulse实现Emacs的淡入淡出效果
;; http://emacser.com/pulse.htm
(require 'pulse-settings)

;;;###autoload
(defun cedet-settings-4-info ()
  "`cedet' settings for `info'."
  (info-initialize)
  (dolist (package `("cogre" "common" "ede" "eieio" "semantic/doc" "speedbar" "srecode"))
    (add-to-list 'Info-directory-list (concat my-emacs-lisps-path "cedet/" package "/"))))

(eval-after-load "info"
  `(cedet-settings-4-info))

(provide 'cedet-settings)
