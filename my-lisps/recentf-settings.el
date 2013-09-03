;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-12 11:06:57 Sunday by taoshanwen>

(recentf-mode 1)

(global-set-key (kbd "C-x C-r") 'recentf-open-files-complete-sb)

(defun recentf-open-files-complete ()
  (interactive)
  (let* ((all-files recentf-list)
         (default (file-name-nondirectory (directory-file-name recentf-open-last-file)))
         (collection (mapcar (lambda (x) (cons (file-name-nondirectory (directory-file-name x)) x)) all-files))
         (prompt (if (string= default "") "File or Directory: " (format "File or Directory (default %s): " default)))
         (file "")
         (completion-ignore-case t))
    (while (string= file "")
      (setq file (completing-read prompt collection nil t nil nil default)))
    (find-file (setq recentf-open-last-file (cdr (assoc-ignore-representation file collection))))))

(defun recentf-settings ()
  "settings for `recentf'."
  (defvar recentf-open-last-file "" "`recentf-open-files-complete'最近打开的文件")

  (setq recentf-max-saved-items nil)

  (eal-define-keys
   'recentf-dialog-mode-map
   `(("n" widget-forward)
     ("j" widget-forward)
     ("p" widget-backward)
     ("k" widget-backward))))

;; 记录打开的目录到recentf里面去
(defun recentf-add-dir ()
  "Add directory name to recentf file list."
  (recentf-add-file dired-directory))

(add-hook 'dired-mode-hook 'recentf-add-dir)

(eval-after-load "recentf"
  `(recentf-settings))

(provide 'recentf-settings)
