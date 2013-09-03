;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-26 14:40:36 Friday by taoshanwen>

(require 'psvn)
(require 'svn)
(require 'svn-misc)
(require 'util)

(eal-define-keys-commonly
 global-map
 `(("C-x C-v" svn-status)
   ("C-x M-u" svn-update-current-file-sb)
   ("C-x V"   visit-svn-status)
   ("C-x M-V" svn-status-use-history)
   ("C-x M-v" svn-status-my-emacs-dir)))

(eal-define-keys
 `(emacs-lisp-mode-map c-mode-base-map text-mode-map)
 `(("C-c M-c" svn-status-commit)))

(apply-args-list-to-fun
 `(def-execute-command-on-file-command
    def-execute-command-on-current-file-command
    def-execute-command-on-current-dir-command)
  `("svn add" "svn revert" "svn rm" "svn update" "svn resolved"))

(eal-define-keys
 `(emacs-lisp-mode-map c-mode-base-map sgml-mode-map
                       sh-mode-map text-mode-map conf-javaprop-mode-map
                       c++-mode-map image-mode-map nxml-mode-map python-mode-map)
 `(("C-c l" svn-status-show-svn-log)))

(eal-define-keys
 'svn-status-mode-map
 `(("C-c M-m" svn-status-make-directory)
   ("M-a"     svn-status-commit-all)
   ("n"       svn-status-next-line)
   ("j"       svn-status-next-line)
   ("p"       svn-status-previous-line)
   ("k"       svn-status-previous-line)
   ("<"       beginning-of-buffer)
   (">"       end-of-buffer)
   ("G"       svn-status-update-cmd)
   ("U"       svn-status-unset-all-usermarks)
   ("M"       svn-status-unset-user-mark)
   ("C-a"     svn-status-mark-changed)
   ("d"       svn-status-rm-sb)

   ("SPC"     svn-scroll-half-page-forward)
   ("u"       svn-scroll-half-page-backward)
   ("d"       svn-scroll-up)
   ("w"       svn-scroll-down)

   ("E"       svn-status-toggle-edit-cmd-flag)
   ("e"       svn-status-ediff-with-revision)
   ("C-h"     svn-status-examine-parent)
   ("t"       svn-status-toggle-hide-unmodified-unknown)
   ("K"       kill-this-buffer)
   ("r"       svn-status-revert-sb)
   ("f"       svn-status-goto-first-line)
   ("'"       switch-to-other-buffer)
   ("C-c C-j" ant)
   ("C-k"     svn-delete-files-sb)
   ("1"       delete-other-windows)
   ("J"       svn-dired-jump)
   ("C"       svn-status-cleanup)
   ("Q"       kill-this-buffer)
   ("o"       other-window)
   ("C-c M-r" svn-status-resolved-sb)))

(eal-define-keys
 'svn-info-mode-map
 `(("SPC"     svn-scroll-half-page-forward)
   ("u"       svn-scroll-half-page-backward)
   ("d"       svn-scroll-up)
   ("'"       switch-to-other-buffer)))

(eal-define-keys
 'svn-log-view-mode-map
 `(("j"   next-line)
   ("k"   previous-line)
   ("h"   backward-char)
   ("l"   forward-char)
   ("u"   View-scroll-half-page-backward)
   ("SPC" View-scroll-page-forward)
   ("d"   svn-log-view-diff)
   ("E"   svn-log-edit-log-entry)
   ("e"   svn-log-ediff-specific-revision)
   ("o"   other-window)
   ("G"   end-of-buffer)
   (">"   end-of-buffer)
   ("<"   beginning-of-buffer)
   ("1"   delete-other-windows)
   ("'"   switch-to-other-buffer)
   ("q"   delete-current-window)))

(defun svn-settings ()
  "Settings for `svn'."
  (setq svn-status-hide-unmodified t)
  (setq svn-status-hide-unknown t)

  (svn-status-update-state-mark-tooltip "svn")

  (defun svn-status-toggle-hide-unmodified-unknown ()
    "隐藏/不隐藏没有修改的文件和没加入版本控制的文件"
    (interactive)
    (let ((unmodified svn-status-hide-unmodified) (unknown svn-status-hide-unknown))
      (unless (or (and unmodified unknown) (not (or unmodified unknown)))
        (setq svn-status-hide-unmodified nil)
        (setq svn-status-hide-unknown nil))
      (svn-status-toggle-hide-unmodified)
      (svn-status-toggle-hide-unknown)))

  (defun svn-status-commit-all ()
    "Commit all files."
    (interactive)
    (call-interactively 'svn-status-mark-changed)
    (call-interactively 'svn-status-commit))

  (defsubst svn-status-interprete-state-mode-color (stat)
    "Interpret vc-svn-state symbol to mode line color"
    (if window-system
        (case stat
          ('up-to-date "GreenYellow")
          ('edited     "tomato")
          ('unknown    "gray")
          ('added      "blue")
          ('deleted    "magenta")
          ('unmerged   "purple")
          ('conflict   "red")
          (t           "black"))
      (case stat
        ('up-to-date "-")
        ('edited     "*")
        ('unknown    "u")
        ('added      "A")
        ('deleted    "D")
        ('unmerged   "M")
        ('conflict   "C")
        (t           "U"))))

  (defun svn-status-state-mark-modeline-dot (color)
    (if window-system
        (propertize "    "
                    'help-echo 'svn-status-state-mark-tooltip
                    'display
                    `(image :type xpm
                            :data ,(format "/* XPM */
static char * data[] = {
\"18 13 3 1\",
\"  c None\",
\"+ c #000000\",
\". c %s\",
\"                  \",
\"       +++++      \",
\"      +.....+     \",
\"     +.......+    \",
\"    +.........+   \",
\"    +.........+   \",
\"    +.........+   \",
\"    +.........+   \",
\"    +.........+   \",
\"     +.......+    \",
\"      +.....+     \",
\"       +++++      \",
\"                  \"};"
                                           color)
                            :ascent center))
      color)))

(eval-after-load "psvn"
  `(svn-settings))

(provide 'svn-settings)
