;;; eval-after-load.el --- `eval-after-load' by mode, map, hook

;; Author: ahei <ahei0802@gmail.com>
;; Keywords: eval-after-load, autoload
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/eval-after-load.el
;; Time-stamp: <2010-11-26 14:40:02 Friday by taoshanwen>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This package make you can `eval-after-load' by modes, keymaps,
;; by    use    `eal-eval-by-modes',   `eal-eval-by-maps',    and
;; `define-key'  more convenient  use  function `eal-define-key',
;; `eal-define-key',    `eal-define-keys-commonly'.    For   more
;; details, see article http://emacser.com/eval-after-load.htm

;;; History:
;;
;; 2010-4-5
;;      * initial version 1.0.

;;; Code:

(eval-when-compile
  (require 'cl))

(defgroup eal nil
  "Package use `eval-after-load' technique."
  :prefix "eal-")

;;;###autoload
(defcustom eal-loadfile-mode-maps
  `(("cc-mode"         nil                    c-mode-base-map)
    ("cc-mode"         c-mode                 c-mode-map)
    ("cc-mode"         c++-mode               c++-mode-map)
    ("cc-mode"         java-mode              java-mode-map)
    ("cc-mode"         awk-mode               awk-mode-map)
    "lisp-mode"
    ("lisp-mode"       emacs-lisp-mode        emacs-lisp-mode-map)
    "help-mode"
    ("man"             Man-mode               Man-mode-map)
    "log-view"
    ("compile"         compilation-mode       compilation-mode-map)
    ("gud")
    ("lisp-mode"       lisp-interaction-mode  lisp-interaction-mode-map)
    "browse-kill-ring"
    ("simple"          completion-list-mode   completion-list-mode-map)
    ("inf-ruby"        inferior-ruby-mode     inferior-ruby-mode-map)
    "ruby-mode"
    ("cus-edit"        custom-mode            custom-mode-map)
    ("info"            Info-mode              Info-mode-map)
    ("psvn"            svn-log-edit-mode      svn-log-edit-mode-map)
    ("psvn"            svn-status-mode        svn-status-mode-map)
    ("psvn"            svn-info-mode          svn-info-mode-map)
    ("package"         package-menu-mode      package-menu-mode-map)
    "dired"
    "apropos"
    "emaci"
    ("psvn"            svn-log-view-mode      svn-log-view-mode-map)
    ("vc-svn"          vc-svn-log-view-mode   vc-svn-log-view-mode-map)
    ("log-view"        log-view-mode          log-view-mode-map)
    "diff-mode"
    ("sgml-mode"       html-mode              html-mode-map)
    "sgml-mode"
    "w3m"
    ("data-debug"      data-debug-mode)
    ("debug"           debugger-mode          debugger-mode-map)
    "text-mode"
    "color-theme"
    "woman"
    "doxymacs"
    "grep"
    "view"
    ("hi-lock"         hi-lock-mode           hi-lock-map)
    "autoconf"
    "tcl"
    "sgml-mode"
    "image-mode"
    "shell"
    "sql"
    "rhtml-mode"
    "senator"
    "org"
    "org-agenda"
    "python"
    "groovy-mode"
    "nxml-mode"
    "perl-mode"
    "artist"
    "calendar"
    "outline"
    "google-maps-static"
    "flymake"
    ("speedbar"        speedbar-mode          speedbar-key-map)
    ("speedbar"        speedbar-mode          speedbar-file-key-map)
    ("yasnippet"       nil                    yas/keymap)
    ("yasnippet"       yas/minor-mode         yas/minor-mode-map)
    ("chart"           chart-mode             chart-map)
    ("recentf"         recentf-dialog-mode    recentf-dialog-mode-map)
    ("conf-mode"       conf-javaprop-mode     conf-javaprop-mode-map)
    ("conf-mode"       conf-space-mode        conf-space-mode-map)
    ("cua-base"        nil                    cua--rectangle-keymap)
    ("make-mode"       makefile-gmake-mode    makefile-gmake-mode-map)
    ("make-mode"       makefile-mode          makefile-mode-map)
    ("make-mode"       makefile-automake-mode makefile-automake-mode-map)
    ("sh-script"       sh-mode                sh-mode-map)
    ("auto-complete"   auto-complete-mode     ac-completing-map)
    ("auto-complete"   nil                    ac-mode-map)

    ("semantic-decoration-on-include" nil semantic-decoration-on-include-map)
    ("semantic-symref-list" semantic-symref-results-mode semantic-symref-results-mode-map))
  "*List used to find load file by mode or map.

Every element of list is or a list consisted by load file, mode and map,
or just one load file, or nil. If element is a list, and its last element is nil,
it will be ignored."
  :type 'alist
  :group 'eal)

;;;###autoload
(defun eal-eval-by-modes (modes fun)
  "Run `eval-after-load' on function FUN by MODES.

FUN will be called by `eval' with argument mode of MODES.
Example:
\(eal-eval-by-modes
 ac-modes
 (lambda (mode)
   (let ((mode-name (symbol-name mode)))
     (when (and (intern-soft mode-name) (intern-soft (concat mode-name \"-map\")))
       (define-key (symbol-value (am-intern mode-name \"-map\")) (kbd \"C-c a\") 'ac-start)))))"
  (if (listp modes)
      (eal-eval-by-symbols modes 1 fun)
    (eal-eval-by-symbol modes 1 fun)))

;;;###autoload
(defun eal-eval-by-maps (maps fun)
  "Run `eval-after-load' on function FUN by MAPS.

FUN will be call by `eval' with argument mode of MAPS."
  (if (listp maps)
      (eal-eval-by-symbols maps 2 fun)
    (eal-eval-by-symbol maps 2 fun)))

;;;###autoload
(defun eal-eval-by-symbols (symbols pos fun)
  "Run `eval-after-load' on function FUN by SYMBOLS.

FUN will be call by `eval' with argument mode of SYMBOLS. "
  (mapc
   `(lambda (symbol)
      (eal-eval-by-symbol symbol ,pos ,fun))
   symbols))

;;;###autoload
(defun eal-eval-by-symbol (symbol pos fun)
  "Run `eval-after-load' on function FUN by SYMBOL."
  (let ((file (eal-find-loadfile-by-symbol symbol pos))
        (form `(,fun ',symbol)))
    (if file
        (eval-after-load file form)
      (eval form))))

;;;###autoload
(defun eal-find-loadfile-by-mode (mode)
  "Find load file by mode MODE."
  (eal-find-loadfile-by-symbol mode 1))

;;;###autoload
(defun eal-find-loadfile-by-map (map)
  "Find load file by map MAP."
  (eal-find-loadfile-by-symbol map 2))

;;;###autoload
(defun eal-find-loadfile-by-symbol (symbol pos)
  "Find load file by symbol SYMBOL, its position is POS."
  (let* ((symbol-name (symbol-name symbol))
         (first
          (find-if
           (lambda (pair)
             (if (stringp pair)
                 (if (string= symbol-name (eal-get-name-by-loadfile pair pos))
                     pair
                   (let ((file (and (string-match "^\\(.+\\)-mode$" pair)
                                    (match-string 1 pair))))
                     (if file
                         (if (string= symbol-name (eal-get-name-by-loadfile file pos))
                             pair))))
               (if pair
                   (if (eq (nth pos pair) symbol)
                       (car pair)))))
           eal-loadfile-mode-maps)))
    (if (listp first) (car first) first)))

;;;###autoload
(defun eal-get-name-by-loadfile (file pos)
  "Get `symbol-name' by load file FILE and position POS."
  (concat file "-" (if (= pos 1) "mode" "mode-map")))

;;;###autoload
(defun eal-define-keys (keymaps key-defs)
  "Execute `define-key' on KEYMAPS by `eval-after-load' technique use arguments from element of list KEY-DEFS.

KEY-DEFS should be one list, every element of it is a list
whose first element is key like argument of `define-key', and second element is command
like argument of `define-key'."
  (eal-eval-by-maps
   keymaps
   `(lambda (keymap)
      (eal-define-keys-commonly (symbol-value keymap) ',key-defs))))

;;;###autoload
(defun eal-define-keys-commonly (keymap key-defs)
  "Execute `define-key' on KEYMAP use arguments from KEY-DEFS.

KEY-DEFS should be one list, every element of it is a list
whose first element is key like argument of `define-key', and second element is command
like argument of `define-key'."
   (dolist (key-def key-defs)
     (when key-def
       (define-key keymap (eval `(kbd ,(car key-def))) (nth 1 key-def)))))

;;;###autoload
(defun eal-define-key (keymap key def)
  "Execute `define-key' use arguments KEYMAP, KEY, DEF by `eval-after-load' technique.

*Note*: KEYMAP should be quoted, this is diference between argument of `define-key'."
  (eal-eval-by-maps
   keymap
   `(lambda (keymap)
      (define-key (symbol-value keymap) ,key ',def))))

(provide 'eval-after-load)

;;; eval-after-load.el ends here
