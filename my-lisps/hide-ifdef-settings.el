;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 20:23:41 Saturday by ahei>

(autoload 'hide-ifdef-block "hideif"
  "Hide the ifdef block (true or false part) enclosing or before the cursor."
  t)
(autoload 'hide-ifdefs "hideif"
  "Hide the contents of some #ifdefs.
Assume that defined symbols have been added to `hide-ifdef-env'.
The text hidden is the text that would not be included by the C
preprocessor if it were given the file with those symbols defined.

Turn off hiding by calling `show-ifdefs'."
  t)
(autoload 'show-ifdef-block "hideif"
  "Show the ifdef block (true or false part) enclosing or before the cursor."
  t)
(autoload 'show-ifdefs "hideif"
  "Cancel the effects of `hide-ifdef': show the contents of all #ifdefs."
  t)

(eval-after-load "hideif"
  '(progn
     (setq hide-ifdef-env
           '((GNU_LINUX . t)
             (__GNUC__ . t)
             (__cplusplus . t)))))

(eval-after-load "cc-mode"
  '(progn
     (dolist (hook '(c-mode-common-hook))
       (add-hook hook 'hide-ifdef-mode))
     (dolist (map (list c-mode-base-map))
       (apply-define-key
        map
        `(("C-c w"   hide-ifdef-block)
          ("C-c W"   hide-ifdefs)
          ("C-c M-i" show-ifdef-block)
          ("C-c M-I" show-ifdefs))))))

(defun hif-goto-endif ()
  "Goto #endif."
  (interactive)
  (unless (or (hif-looking-at-endif)
              (save-excursion)
    (hif-ifdef-to-endif))))

(defun hif-goto-if ()
  "Goto #if."
  (interactive)
  (hif-endif-to-ifdef))

(defun hif-gototo-else ()
  "Goto #else."
  (hif-find-next-relevant)
  (cond ((hif-looking-at-else)
         'done)
	 (hif-ifdef-to-endif) ; find endif of nested if
	 (hif-ifdef-to-endif)) ; find outer endif or else
	((hif-looking-at-else)
	 (hif-ifdef-to-endif)) ; find endif following else
	((hif-looking-at-endif)
	 'done)
	(t
	 (error "Mismatched #ifdef #endif pair")))


(defun hif-find-next-relevant ()
  "Move to next #if..., #else, or #endif, after the current line."
  ;; (message "hif-find-next-relevant at %d" (point))
  (end-of-line)
  ;; avoid infinite recursion by only going to beginning of line if match found
  (re-search-forward hif-ifx-else-endif-regexp (point-max) t))

(provide 'hide-ifdef-settings)
