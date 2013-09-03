;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 22:39:12 Saturday by ahei>

(require 'maxframe)

(defun toggle-fullscreen (&optional f)
  "Toggle frame F fullscreen."
  (interactive)
  (set-frame-parameter f 'fullscreen
                       (if (frame-parameter f 'fullscreen) nil 'fullboth)))

(defvar frame-state nil "State of frame, t means maximized, and nil means not maximized.")
  
(unless mswin
  (defun toggle-fullscreen ()
    "Toggle frame fullscreen."
    (interactive)
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                           '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

  (defun toggle-fullscreen ()
    "Toggle frame fullscreen."
    (interactive)
    (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))

  (defun maximize (&optional toggle)
    "Toggle or let frame maximized.
When prefix arg TOGGLE is provide, toggle frame maximized,
otherwise let frame maximized"
    (interactive "P")
    (setq toggle (if toggle 2 1))
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     (list toggle "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     (list toggle "_NET_WM_STATE_MAXIMIZED_VERT" 0)))

  (defun x-maximize-frame ()
    "Maximizes the frame to fit the display if under a windowing system."
    (interactive)
    (maximize)
    (setq frame-state t))

  (defun x-restore-frame ()
    "Restores a maximized frame.  See `x-maximize-frame'."
    (interactive)
    (if frame-state
      (maximize t))
    (setq frame-state nil)))

(defun w32-minimize-frame ()
  "Minimize emacs window in windows os"
  (interactive)
  ; #xf020 minimize
  (w32-send-sys-command #xf020))

(defun maximize-frame ()
  "Maximizes the frame to fit the display if under a windowing
system."
  (interactive)
  (cond ((eq window-system 'w32) (w32-maximize-frame))
        ((memq window-system '(x mac)) (x-maximize-frame)))
  (setq frame-state t))

(defun restore-frame ()
  "Restores a maximized frame.  See `maximize-frame'."
  (interactive)
  (cond ((eq window-system 'w32) (w32-restore-frame))
        ((memq window-system '(x mac)) (x-restore-frame)))
  (setq frame-state nil))

(defun minimize-frame ()
  "Minimize a maximized frame.  See `maximize-frame'."
  (interactive)
  (cond ((eq window-system 'w32) (w32-minimize-frame))
        ((memq window-system '(x mac)) (message "Sorry, do not support minimize frame in %s." window-system))))

(defun toggle-maximize-frame ()
  "Toggle maximize frame."
  (interactive)
  (let ((state frame-state))
    (if frame-state
        (restore-frame)
      (maximize-frame))
    (setq frame-state (not state))))

(define-prefix-command 'm-spc-map)
(global-set-key (kbd "M-SPC") 'm-spc-map)

(let ((map global-map)
      (key-pairs
       `(("M-SPC x"   toggle-maximize-frame)
         ("M-SPC M-x" toggle-maximize-frame)
         ("M-SPC n"   minimize-frame)
         ("M-SPC c"   delete-frame)
         ("M-SPC M-c" delete-frame))))
  (apply-define-key map key-pairs))

;; 启动的时候不能直接调用`maximize-frame', 否则如果去掉工具栏的话,
;; 底下会有一条缝隙, 没有完全最大化
(add-hook 'window-setup-hook 'maximize-frame t)

(provide 'maxframe-settings)
