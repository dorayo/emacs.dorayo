;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-06 23:05:41 Tuesday by ahei>

(require 'color-moccur)

(defun moccur-settings ()
  "Settings for `moccur'."

  (defun occur-by-moccur-at-point ()
    "对当前光标所在的单词运行`occur-by-moccur'命令"
    (interactive)
    (if (current-word)
        (occur-by-moccur-displn (current-word) nil)))

  (defun occur-by-moccur-at-point-displn ()
    "运行`occur-by-moccur-at-point'后显示行号"
    (interactive)
    (occur-by-moccur-at-point)
    (let ((buffer (get-buffer "*Moccur*")))
      (if buffer (with-current-buffer buffer (linum-mode t)))))

  (defun occur-by-moccur-displn (regexp arg)
    "运行`occur-by-moccur'后显示行号"
    (interactive (list (moccur-regexp-read-from-minibuf) current-prefix-arg))
    (occur-by-moccur regexp arg)
    (let ((buffer (get-buffer "*Moccur*")))
      (if buffer
          (with-current-buffer buffer
            (linum-mode t)
            (moccur-my-keys)))))

  (defun isearch-moccur-displn ()
    "运行`isearch-moccur'后显示行号"
    (interactive)
    (isearch-moccur)
    (let ((buffer (get-buffer "*Moccur*")))
      (if buffer
          (with-current-buffer buffer
            (linum-mode t)
            (moccur-my-keys)))))

  (defun moccur-my-keys ()
    (local-set-key (kbd "o") 'other-window)
    (local-set-key (kbd "m") 'moccur-disp-cur-line)
    (local-set-key (kbd "h") 'backward-char)
    (local-set-key (kbd "l") 'forward-char)
    (local-set-key (kbd "b") 'backward-word)
    (local-set-key (kbd "w") 'forward-word-or-to-word)
    (local-set-key (kbd "f") 'forward-word)
    (local-set-key (kbd "y") 'copy-region-as-kill-nomark)
    (local-set-key (kbd "c") 'copy-region-as-kill-nomark)
    (local-set-key (kbd ".") 'set-mark-command)
    (local-set-key (kbd "L") 'count-brf-lines))

  (defun moccur-disp-cur-line ()
    "moccur显示当前行"
    (interactive)
    (moccur-next 1)
    (moccur-prev 1))

  (eal-define-keys-commonly
    global-map
    `(("C-x C-u" occur-by-moccur-displn)
      ("C-x M-U" occur-by-moccur-at-point-displn)))
  
  (eal-define-keys
    'isearch-mode-map
    `(("M-o" isearch-moccur-displn))))

(eval-after-load "color-moccur"
  `(moccur-settings))

(provide 'moccur-settings)
