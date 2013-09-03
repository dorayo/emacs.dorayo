;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-11-04 17:06:12 Thursday by taoshanwen>

(global-set-key (kbd "C-x D") 'ediff)

(defun ediff-settings ()
  "settings for `ediff'."
  (defun ediff-variable-settings ()
    (setq ediff-highlight-all-diffs nil
          ediff-highlighting-style 'face))

  (defun ediff-keys ()
    (interactive)
    "`ediff-mode'的按键设置"
    (define-prefix-command 'ediff-R-map)
    (define-key-list
      ediff-mode-map
      `(("# w" ediff+-toggle-ignore-whitespace)
        ("u"   ediff-update-diffs)
        ("/"   ediff-toggle-help)
        ("c"   ediff-inferior-compare-regions)
        ("f"   ediff-jump-to-difference)
        ("j"   ediff+-previous-line)
        ("k"   ediff-scroll-vertically)
        ("R"   ediff-R-map)
        ("R a" ediff-toggle-read-only)
        ("R b" ediff-toggle-read-only)
        ("o"   other-window)
        ("A"   ediff+-goto-buffer-a)
        ("B"   ediff+-goto-buffer-b))))

  (defun ediff-startup-settings ()
    "Settings of ediff startup."
    (ediff-next-difference))

  (add-hook 'ediff-startup-hook 'ediff-startup-settings)
  (add-hook 'ediff-prepare-buffer-hook 'turn-off-hideshow)
  (add-hook 'ediff-mode-hook 'ediff-variable-settings)
  (add-hook 'ediff-keymap-setup-hook 'ediff-keys)

  ;; 用ediff比较的时候在同一个frame中打开所有窗口
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)

  (require 'ediff+)
  (ediff+-set-actual-diff-options))

(eval-after-load "ediff"
  `(ediff-settings))

(provide 'ediff-settings)
