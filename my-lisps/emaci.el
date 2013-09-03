;;; emaci.el --- Emacs and vi mode

;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; Keywords: emacs vi
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/emaci.el
;; Time-stamp: <2013-09-03 00:26:31 Tuesday by oa>

;; This file is  free software; you can redistribute  it and/or modify
;; it under the  terms of the GNU General  Public License as published
;; by  the Free  Software Foundation;  either version  3, or  (at your
;; option) any later version.

;; This file  is distributed in the  hope that it will  be useful, but
;; WITHOUT  ANY  WARRANTY;  without   even  the  implied  warranty  of
;; MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU
;; General Public License for more details.

;; You should have  received a copy of the  GNU General Public License
;; along with GNU  Emacs; see the file COPYING.  If  not, write to the
;; Free Software  Foundation, Inc.,  51 Franklin Street,  Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; emaci-mode make you browse and edit your file quickly.  Use it, you
;; can browse file like vi, but more quickly, and when you browe file,
;; you  can also edit  your file  use Emacs  key bindings.   It's name
;; "emaci"   is  combine  of   EMACs  and   vI.  Its   screenshots  is
;; http://emacser.com/screenshots/emaci.png  . This package  is depend
;; on                                                           package
;; http://code.google.com/p/dea/source/browse/trunk/my-lisps/ahei-misc.el
;; and                                                          package
;; http://code.google.com/p/dea/source/browse/trunk/my-lisps/eval-after-load.el
;; . For more details, see article http://emacser.com/emaci.htm

;;; Installation:
;;
;; Copy emaci.el to your load-path and add to your .emacs:
;;
;; (require 'emaci)

;;; History:
;;
;; 2010-04-25
;;      * Add variable emaci-key-command-alist
;;
;; 2010-3-21
;;      * initial version 1.0.

;;; Code:

(eval-when-compile
  (require 'cl))

(require 'view)
(require 'misc)
(require 'ahei-misc)
(require 'eval-after-load)

(defgroup emaci nil
  "Minor mode for browse and edit file more quickly."
  :prefix "emaci-")

;;;###autoload
(defcustom emaci-mode-line-format (propertize "Emaci" 'face 'emaci-mode-line-face)
  "Mode line format of function `emaci-mode'."
  :type 'string
  :group 'emaci)

;;;###autoload
(defcustom emaci-maps-to-bind-brief-keys
  `(view-mode-map
    Man-mode-map
    apropos-mode-map
    completion-list-mode-map
    compilation-mode-map
    diff-mode-map
    help-mode-map
    svn-info-mode-map
    ,(if (>= emacs-major-version 21) 'grep-mode-map)
    color-theme-mode-map
    semantic-symref-results-mode-map
    chart-map)
  "List used for `emaci-bind-modes-keys'.

Element of this list either a list whose first element is load file,
and second element is map, or a string which means load file, or a map."
  :group 'emaci)

;;;###autoload
(defcustom emaci-brief-key-defs
  `(("h" backward-char)
    ("l" forward-char)
    ("j" next-line)
    ("k" previous-line)
    ("J" emaci-roll-down)
    ("K" emaci-roll-up)
    ("b" backward-word)
    ("w" scroll-down)
    ("o" other-window)
    ("G" end-of-buffer)
    ("a" move-beginning-of-line)
    ("e" move-end-of-line)
    ("1" delete-other-windows)
    ("2" split-window-vertically)
    ("3" split-window-horizontally))
  "Key pairs used bind in modes `emaci-maps-to-bind-brief-keys'.

Each element of this variable is two-elements list, and first
element is key like argument of `kbd', and second element is command."
  :type 'list
  :group 'emaci)

;;;###autoload
(defcustom emaci-key-command-alist
  `(("n" (((edebug-active) edebug-next-mode)
          ((eq major-mode 'gud-mode) gud-next)
          next-line))
    ("g" (((edebug-active) edebug-go-mode)
          beginning-of-buffer))
    ("b" (((edebug-active) edebug-set-breakpoint)
          backward-word))
    ("q" (((edebug-active) top-level)
          emaci-mode-off)))
  "This variable is a list, its element is a list whose first
element is a key, and second element is a list which consist by
many pairs whose first element is a condition, and second element is
a command."
  :type 'list
  :group 'emaci)

(defvar emaci-mode-map nil "Keymap for function `emaci-mode'.")

(defvar emaci-read-only nil "Readonly before enter in function `emaci-mode' or not.")
(make-variable-buffer-local 'emaci-read-only)

(defface emaci-mode-line-face
  '((((type tty pc)) :bold t :foreground "red" :background "white")
    (t (:background "red" :foreground "white")))
  "Face used highlight `emaci-mode-line-format'.")

;; must do this
(put 'emaci-mode-line-format 'risky-local-variable t)

(unless emaci-mode-map
  (setq emaci-mode-map (make-sparse-keymap))
  (setq minor-mode-alist
        (append
         `((emaci-mode " ") (emaci-mode ,emaci-mode-line-format))
         (delq (assq 'emaci-mode minor-mode-alist) minor-mode-alist))))

(eal-define-keys-commonly
 emaci-mode-map
 `(("a"       move-beginning-of-line)
   ("e"       move-end-of-line)
   ("j"       next-line)
   ("k"       previous-line)
   ("h"       backward-char)
   ("l"       forward-char)
   ("n"       emaci-n)
   ("p"       previous-line)
   ("u"       View-scroll-half-page-backward)
   ("S-SPC"   View-scroll-half-page-backward)
   ("SPC"     View-scroll-half-page-forward)
   ("w"       scroll-down)
   ("d"       scroll-up)
   ("g"       emaci-g)
   ("<"       beginning-of-buffer)
   (">"       end-of-buffer)
   ("J"       emaci-roll-down)
   ("K"       emaci-roll-up)
   ("f"       am-forward-word-or-to-word)
   ("b"       emaci-b)
   ("x"       delete-char)
   ("I"       emaci-bol-and-quit)
   ("A"       emaci-eol-and-quit)
   ("o"       other-window)
   ("O"       emaci-newline-and-quit)
   ("m"       back-to-indentation)
   ("q"       emaci-q)
   ("["       emaci-\[)
   ("Q"       delete-current-window)
   ("1"       delete-other-windows)
   ("2"       split-window-vertically)
   ("3"       split-window-horizontally)
   ("v"       set-mark-command)
   ("B"       eval-buffer)))

(am-def-active-fun edebug-active)

;;;###autoload
(defmacro emaci-def-brief-key-command (command-name command-alist)
  "Make definition of command which bind to brief key."
  `(defun ,(intern command-name) ()
     "Command generated by `emaci-def-brief-key-command'."
     (interactive)
     (call-interactively
      (let ((element 
             (find-if
              (lambda (pair)
                (if (listp pair)
                    (eval (car pair))
                  t))
              ',command-alist)))
        (if (listp element) (nth 1 element) element)))))

;;;###autoload
(defun emaci-make-brief-key-commands ()
  "Make definition of commands which bind to brief key."
  (dolist (pair emaci-key-command-alist)
    (eval `(emaci-def-brief-key-command ,(concat "emaci-" (car pair)) ,(nth 1 pair)))))

(emaci-make-brief-key-commands)

;;;###autoload
(defun emaci-make-brief-key-command (key)
  "Make definition of commands which bind to brief KEY."
  (let ((key-command (assoc key emaci-key-command-alist)))
    (if key-command
        (eval `(emaci-def-brief-key-command ,(concat "emaci-" key) ,(nth 1 key-command))))))

;;;###autoload
(defun emaci-add-key-definition (key command &optional condition)
  "Add key definition to `emaci-key-command-alist'."
  (let* ((cond-commands (nth 1 (assoc key emaci-key-command-alist)))
         (cond-commands-bak cond-commands))
    (if cond-commands
        (if condition
            (let ((cond-command (assoc condition cond-commands)))
              (if cond-command
                  (unless (eq command (nth 1 cond-command))
                    (setcdr cond-command `(,command)))
                (push `(,condition ,command) (nth 1 (assoc key emaci-key-command-alist)))))
          (unless (listp (car (last cond-commands)))
            (setq cond-commands (butlast cond-commands)))
          (add-to-list 'cond-commands command t)
          (delq cond-commands-bak emaci-key-command-alist)
          (add-to-list 'emaci-key-command-alist `(,key ,cond-commands)))
      (add-to-list 'emaci-key-command-alist
                   `(,key ,(if condition `((,condition ,command)) `(,command))))))
  (emaci-make-brief-key-command key))

;;;###autoload
(defun emaci-bol-and-quit ()
  "First exit function `emaci-mode' and then call `back-to-indentation', like I command in vi."
  (interactive)
  (emaci-mode-off)
  (back-to-indentation))

;;;###autoload
(defun emaci-eol-and-quit ()
  "First exit function `emaci-mode' and then call `end-of-line', like A command in vi."
  (interactive)
  (emaci-mode-off)
  (end-of-line))

;;;###autoload
(defun emaci-newline-and-quit ()
  "First exit function `emaci-mode' and then call `newline-and-indent', like o command in vi."
  (interactive)
  (emaci-mode-off)
  (end-of-line)
  (newline-and-indent))

;;;###autoload
(defun emaci-roll-down (&optional n)
  "Simulate roll down lines N."
  (interactive "P")
  (if (null n) (setq n 7))
  (next-line n))

;;;###autoload
(defun emaci-roll-up (&optional n)
  "Simulate roll up lines N."
  (interactive "P")
  (if (null n) (setq n 7))
  (previous-line n))

(add-hook 'find-file-hook 'emaci-exist-file)

;; when open exist file automatically enter `emaci-mode', but if file
;; does not exist, do not enter it.
;;;###autoload
(defun emaci-exist-file ()
  "Only when variable `buffer-file-name' is exist, enter function `emaci-mode'."
  (when (file-exists-p (buffer-file-name))
    (emaci-mode-off)))

;;;###autoload
(defun emaci-bind-brief-keys ()
  "Bind brief keys."
  (interactive)
  (eal-define-keys emaci-maps-to-bind-brief-keys emaci-brief-key-defs))

;;;###autoload
(define-minor-mode emaci-mode
  "Toggle `emaci-mode'.

  \\{emaci-mode-map}
Entry to this mode calls the value of `emaci-mode-hook'
if that value is non-nil.  \\<emaci-mode-map>"
  :group 'emaci
  (if emaci-mode
      (progn
        (setq emaci-read-only buffer-read-only)
        (setq buffer-read-only nil))
    (setq buffer-read-only emaci-read-only)))

;;;###autoload
(defun emaci-mode-on ()
  "Turn on function `emaci-mode'."
  (interactive)
  (emaci-mode 1))

;;;###autoload
(defun emaci-mode-off ()
  "Turn off function `emaci-mode'."
  (interactive)
  (emaci-mode -1))

(emaci-bind-brief-keys)

(provide 'emaci)

;;; emaci.el ends here
