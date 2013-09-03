;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 18:03:32 Saturday by ahei>

(defun icicles-settings ()
  "settings of icicles."
  (setq icicle-download-dir (concat my-emacs-lisps-path "/icicles"))

  (setq icicle-highlight-input-completion-failure-delay 0)
  
  (defun icicle-keys ()
    "icicle-mode的按键设置."
    (define-key minibuffer-local-completion-map (kbd "SPC") 'minibuffer-complete-word)
    (define-key minibuffer-local-completion-map (kbd "C-w") 'backward-kill-word-or-kill-region))

  (add-hook 'icicle-mode-hook 'icicle-keys t)

  (setq icicle-top-level-key-bindings
        `((,(kbd "<pause>") icicle-switch-to/from-minibuffer    t)   ; `pause'
          (,(kbd "C-c `")   icicle-search-generic               t)   ; `C-c `'
          (,(kbd "C-c $")   icicle-search-word                  t)   ; `C-c $'
          (,(kbd "C-c ^")   icicle-search-keywords              t)   ; `C-c ^'
          (,(kbd "C-c '")   icicle-occur                        t)   ; `C-c ''
          (,(kbd "C-c =")   icicle-imenu                        t)   ; `C-c ='
          (,(kbd "C-c \"")  icicle-search-text-property         t)   ; `C-c "'
          (,(kbd "C-x M-e") icicle-execute-named-keyboard-macro t)   ; `C-x M-e'
          (,(kbd "C-x SPC") icicle-command-abbrev               t)   ; `C-x SPC'
          (,(kbd "C-x 5 o") icicle-select-frame                 t)   ; `C-x 5 o'
          ,@(and (require 'kmacro nil t)                             ; (Emacs 22+)
                 `((,(kbd "S-<f4>")    icicle-kmacro            t))) ; `S-f4'
          (abort-recursive-edit           icicle-abort-recursive-edit     t) ; `C-]'
          (minibuffer-keyboard-quit      icicle-abort-recursive-edit ; `C-g' (minibuffer - `delsel.el')
                                         (fboundp 'minibuffer-keyboard-quit))
          (execute-extended-command       icicle-execute-extended-command t) ; `M-x'
          ;; There are no key bindings in vanilla Emacs for `insert-buffer'.
          ;; If you use `setup-keys.el', then these are its bindings: `C-S-insert', `M-S-f1'.
          (insert-buffer                  icicle-insert-buffer            t)
          (bookmark-set                   icicle-bookmark-cmd             t) ; `C-x r m'
          (bookmark-jump                  icicle-bookmark                 t) ; `C-x r b'
          (bookmark-jump-other-window     icicle-bookmark-other-window    t)
          ;; Don't let Emacs 20 or 21 use `substitute-key-definition' on `M-.' or `M-*', since we need
          ;; these keys for the minibuffer.  Leave them unbound in `icicle-mode-map' until Emacs 22+.
          (pop-tag-mark        icicle-pop-tag-mark          (fboundp 'command-remapping)) ; `M-*'
          (find-tag            icicle-find-tag              (fboundp 'command-remapping)) ; `M-.'
          (eval-expression     icicle-pp-eval-expression    (fboundp 'command-remapping)) ; `M-:'
          (pp-eval-expression icicle-pp-eval-expression (fboundp 'command-remapping)) ;`M-:' (`pp+.el')
          (find-tag-other-window        icicle-find-first-tag-other-window t) ; `C-x 4 .'
          (kill-buffer                  icicle-kill-buffer                 t) ; `C-x k'
          (kill-buffer-and-its-windows  icicle-kill-buffer                t) ; `C-x k' (`misc-cmds.el')
          (delete-window                icicle-delete-window               t) ; `C-x 0'
          (delete-windows-for           icicle-delete-window             t) ; `C-x 0' (`frame-cmds.el')
          (other-window-or-frame        icicle-other-window-or-frame     t) ; `C-x o' (`frame-cmds.el')
          (other-window                 icicle-other-window-or-frame       t) ; `C-x o'
          (exchange-point-and-mark      icicle-exchange-point-and-mark     t) ; `C-x C-x'
          (where-is                     icicle-where-is                    t) ; `C-h w'
          (,icicle-yank-function        icicle-yank-maybe-completing       t) ; `C-y'
          (set-mark-command
           icicle-goto-marker-or-set-mark-command                          t) ; `C-@', `C-SPC'
          (pop-global-mark
           icicle-goto-global-marker-or-pop-global-mark                    t) ; `C-x C-@', `C-x C-SPC'
          ;; For La Carte (`lacarte.el'), not Icicles, but it's convenient to do this here.
          (,(kbd "ESC M-x")      lacarte-execute-menu-command
           (fboundp 'lacarte-execute-menu-command)) ; `ESC M-x'
          (,(kbd "M-`")          lacarte-execute-menu-command
           (fboundp 'lacarte-execute-menu-command)) ; `M-`' - replaces `tmm-menubar'.
          (,(kbd "<f10>")        lacarte-execute-menu-command
           (fboundp 'lacarte-execute-menu-command))) ; `f10' - replaces `menu-bar-open'.
        ))

(eval-after-load "icicles"
  `(icicles-settings))

(provide 'icicles-settings)
