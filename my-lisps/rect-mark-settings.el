;; -*- Emacs-Lisp -*-

;; Time-stamp: <2013-08-12 20:44:19 Monday by oa>

(eal-define-keys-commonly
 global-map
`(("C-x \\"  rm-mark-command)
   ("M-w"     copy-region)))

;;;###autoload
(defun rm-mark-command ()
  "如果是CUA mode, 则执行`cua-set-rectangle-mark', 否则执行`rm-set-mark'"
  (interactive)
  (setq last-region-beg (point))
  (setq last-region-is-rect t)
  (setq last-region-use-cua cua-mode)
  (if cua-mode
      (call-interactively 'cua-set-rectangle-mark)
    (require 'rect-mark)
    (call-interactively 'rm-set-mark)))

;;;###autoload
(defun copy-region (beg end)
  "根据`mark-active'和`rm-mark-active'来决定是执行`copy-region-as-kill-nomark'还是`rm-kill-ring-save'"
  (interactive "r")
  (if cua-mode
      (if cua--rectangle
          (progn
            (cua-copy-rectangle t)
            (cua-cancel))
        (call-interactively 'cua-copy-region))
    (if (rm-mark-active) (call-interactively 'rm-kill-ring-save) (copy-region-as-kill-nomark beg end))))

;;;###autoload
(defun rect-mark-settings ()
  "Settings of `rect-mark'.")

(am-def-active-fun rm-mark-active rm-mark-active)

(eval-after-load "rect-mark"
  `(rect-mark-settings))

(provide 'rect-mark-settings)
