;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-11 20:14:09 Sunday by ahei>

(defalias 'irb 'run-ruby)

(font-lock-add-keywords 'ruby-mode '(("\\<require\\>" . font-lock-keyword-face)))

(eal-define-keys-commonly
 global-map
 `(("C-x r" run-ruby)
   ("C-x R" ri)))

(autoload 'run-ruby
  "Run an inferior Ruby process, input and output via buffer *ruby*.
If there is a process already running in `*ruby*', switch to that buffer.
With argument, allows you to edit the command line (default is value
of `ruby-program-name').  Runs the hooks `inferior-ruby-mode-hook'
\(after the `comint-mode-hook' is run).
\(Type \\[describe-mode] in the process buffer for a list of commands.)" t)

(autoload 'ri "ri-ruby"
  "Execute `ri'." t)

(defun ruby-settings ()
  "Settings for `ruby'."
  (defun complete-or-indent-for-ruby (arg)
    (interactive "P")
    (complete-or-indent arg nil 'ruby-indent-command))

  (eal-define-keys
   'ruby-mode-map
   `(("TAB"     complete-or-indent-for-ruby)
     ("C-j"     goto-line)
     ("C-c C-c" comment)
     ("{"       self-insert-command)
     ("}"       self-insert-command)))

  (defun ruby-keys ()
    "Ruby keys definition."
    (local-set-key (kbd "<return>") 'newline-and-indent))
  (add-hook 'ruby-mode-hook
            (lambda ()
              (setq ruby-indent-level 4)
              (ruby-electric-mode nil)
              (ruby-keys)) t)

  (defun ruby-mark-defun ()
    "Put mark at end of this Ruby function, point at beginning."
    (interactive)
    (push-mark (point))
    (ruby-end-of-defun)
    (push-mark (point) nil t)
    (ruby-beginning-of-defun))

  (setq ri-ruby-script (concat my-emacs-lisps-path "ri-emacs.rb"))
  (setq ri-ruby-script "/home/ahei/emacs/lisps/ri-emacs.rb"))

(eval-after-load "ruby-mode"
  `(ruby-settings))

(provide 'ruby-settings)
