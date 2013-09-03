;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-26 10:22:22 Monday by ahei>

(require 'yasnippet)

(yas/global-mode 1)

(defun yasnippet-settings ()
  "settings for `yasnippet'."
  (setq yas/root-directory (concat my-emacs-path "snippets"))

  (defun yasnippet-unbind-trigger-key ()
    "Unbind `yas/trigger-key'."
    (let ((key yas/trigger-key))
      (setq yas/trigger-key nil)
      (yas/trigger-key-reload key)))

  (yasnippet-unbind-trigger-key)
  
;;;###autoload
  (defun yasnippet-reload-after-save ()
    (let* ((bfn (expand-file-name (buffer-file-name)))
           (root (expand-file-name yas/root-directory)))
      (when (string-match (concat "^" root) bfn)
        (yas/load-snippet-buffer))))
  (add-hook 'after-save-hook 'yasnippet-reload-after-save))

(eal-define-keys
 'yas/keymap
 `(("M-j"     yas/next-field-or-maybe-expand)
   ("M-k"     yas/prev-field)))

(eal-define-keys
 'yas/minor-mode-map
 `(("C-c C-f" yas/find-snippets)))

(eval-after-load "yasnippet"
  `(yasnippet-settings))

(yas/load-directory yas/root-directory)

(provide 'yasnippet-settings)
