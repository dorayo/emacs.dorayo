;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-08-08 12:04:13 Sunday by taoshanwen>

(if is-before-emacs-21
    (require 'ido "ido-for-21"))

(ido-mode 1)

(defun ido-settings ()
  "settings for `ido'."
  (if is-before-emacs-21
      (setq read-buffer-function 'ido-read-buffer)
    (ido-everywhere t)
    (setq ido-define-mode-map-hook 'ido-setup-hook))

  (add-hook ido-define-mode-map-hook 'ido-keys)

  (global-set-key (kbd "C-x C-f") 'ido-find-file)
  (setq ido-max-directory-size 1000000)

  (defmacro def-ido-enter-command (command)
    "Make definition of command which execute some command in ido."
    `(defun ,(am-intern "ido-enter-" command) ()
       ,(concat "Drop into `" command "' from file switching.")
       (interactive)
       (setq ido-exit (quote ,(intern command)))
       (exit-minibuffer)))

  (require 'util)
  
  (apply-args-list-to-fun
   'def-ido-enter-command
   `("svn-status-hide"))

  (defun ido-up-directory-clean-text ()
    "Run C-u `ido-up-directory'."
    (interactive)
    (ido-up-directory t))

  (defun ido-clean-text ()
    "Clean `ido-text'."
    (interactive)
    (if (= (minibuffer-prompt-end) (point))
        (ido-up-directory t)
      (delete-region (minibuffer-prompt-end) (point-max))))

  (defun ido-goto-home ()
    (interactive)
    "Go to home directory when use `ido-find-file'"
    (ido-set-current-home)
    (setq ido-exit 'refresh)
    (exit-minibuffer))

  (defun ido-goto-root ()
    (interactive)
    "Go to root directory when use `ido-find-file'"
    (ido-set-current-directory "/")
    (setq ido-exit 'refresh)
    (exit-minibuffer))
  
  (defun ido-keys ()
    "`ido'的按键设置"
    (let ((map
           (unless is-before-emacs-21
             (setq ido-mode-map ido-completion-map))))
      (eal-define-keys-commonly
       map 
       `(("M-."   ido-next-match-dir)
         ("M-,"   ido-prev-match-dir)
         ("C-h"   ido-delete-backward-updir)
         ("M-h"   ido-up-directory)
         ("M-H"   ido-up-directory-clean-text)
         ("C-M-h" ido-goto-home)
         ("C-r"   ido-goto-root)
         ("C-u"   ido-clean-text)
         ("M-b"   backward-word)
         ("C-w"   ido-delete-backward-word-updir)
         ("C-v"   ido-enter-svn-status-hide)
         ("C-n"   ido-next-match)
         ("C-p"   ido-prev-match))))))

(eval-after-load 'ido
  `(ido-settings))

(provide 'ido-settings)
