;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-05 16:56:36 Sunday by taoshanwen>

(defun pulse-settings ()
  "Settings for `pulse'."
  (defadvice exchange-point-and-mark-nomark (after pulse-advice activate)
    "Cause the line that is `goto'd to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p)
               (> (abs (- (point) (mark))) 400))
      (pulse-momentary-highlight-one-line (point))))

  (defadvice switch-to-buffer (after pulse-advice activate)
    "Cause the current line of new buffer to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))

  (defadvice ido-switch-buffer (after pulse-advice activate)
    "Cause the current line of new buffer to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))

  (defadvice visit-.emacs (after pulse-advice activate)
    "Cause the current line of .emacs buffer to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))

  (defadvice beginning-of-buffer (after pulse-advice activate)
    "Cause the current line of buffer to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))

  (pulse-toggle-integration-advice t))

(eval-after-load "pulse"
  `(pulse-settings))

(provide 'pulse-settings)
