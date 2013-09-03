;; Copyright (C) 2010  Brian Jiang

;; Author: Brian Jiang <brianjcj@gmail.com>
;; Keywords: Programming
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(eval-when-compile
  (require 'cl))

(require 'cp-base)

(defvar cp-pb-buffer-file-name nil)
(defvar cp-pb-buffer-search-text nil)
(defvar cp-pb-buffer-search-type nil)

(pushnew "*Which Procs*" codepilot-buffer-to-bury)
(pushnew "*Block Traceback*" codepilot-buffer-to-bury)
(pushnew "*Proc Outline*" codepilot-buffer-to-bury)


(defun cp-pb-fold/unfold ()
  (interactive)
  (save-excursion
    (forward-line 0)
    (when (looking-at "^\\[.+\\]:$")
      (let (b e pos ret)
        (dolist (o (overlays-at (line-end-position)))
          (cptree-delete-overlay o 'cptree)
          (setq ret t))

        (unless ret
          (save-excursion
            (end-of-line)
            (setq b (point))
            (cond ((re-search-forward "\\(^\\[.+\\]:$\\)\\|\\(^$\\)" nil t)
                   (forward-line 0)
                   (setq e (1- (point))))
                  ((re-search-forward "^$" nil t)
                   (setq e (1- (point))))
                  (t
                   (setq e (point-max))))
            (cptree-hide-region b e 'cptree)))))))


(defun cp-pb-fold/unfold-mouse (e)
  (interactive "e")
  (mouse-set-point e)
  (cp-pb-fold/unfold))


(defun cp-pb-go ()
  (interactive)
  (let (pos win buf my-buf from-which-procs)
    (when (string= "*Which Procs*" (buffer-name))
      (codepilot-highlight-one-line-1)
      (setq from-which-procs t))

    (cond ((and (setq pos (get-text-property (point) 'cp-pb-target))
                cp-pb-buffer-file-name
                (setq buf (find-file-noselect cp-pb-buffer-file-name)))
           (setq my-buf (current-buffer))
           (multiple-value-bind (ret sidebar code-win bottom-win num)
               (codepilot-window-layout-wise)
             (case ret
               ((:window-layout-1&1
                 :window-layout-1)
                (select-window code-win)
                (split-window-vertically)
                (other-window 1)
                (setq win (selected-window))
                ;; (switch-to-buffer-other-window buf)
                (let ((inhibit-codepilot-pre-pop-or-switch-buffer-hook t))
                  (codepilot-pop-or-switch-buffer buf))
                (fit-window-to-buffer win (/ (frame-height) 2) 10)
                (recenter -1)
                (bury-buffer my-buf))
               (otherwise
                (let ((inhibit-codepilot-pre-pop-or-switch-buffer-hook t))
                  (codepilot-pop-or-switch-buffer buf))
                (bury-buffer my-buf))))
           (goto-char pos)
           (sit-for 0.0)
           (goto-char pos)
           (set-window-point (get-buffer-window buf) pos)
           (codepilot-highlight-one-line)

           (when (and from-which-procs
                      (get-buffer-window "*Block Traceback*"))
             (message "Sync *Block Traceback*")
             (cp-pb-where-we-are))))))


(defun cp-pb-go-mouse (e)
  (interactive "e")
  (mouse-set-point e)
  (cp-pb-go))


(define-minor-mode cp-pb-mode
  "..."
  ;; The initial value.
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " POL"
  ;; The minor mode bindings.
  :keymap
  '(([mouse-3] . cp-pb-go-mouse)
    ([mouse-2] . cp-pb-fold/unfold-mouse)
    ("\r" . cp-pb-go)
    ("0" . delete-window)
    ("k" . delete-window)
    ("q" . delete-window)
    ("`" . cplist-minimize/restore-sidebar))
  :group 'codepilot
  (modify-syntax-entry ?- ".")
  (modify-syntax-entry ?& ".")
  (toggle-truncate-lines 1))

(defun cp-pb-pop-to-buffer (buf)
  (let (win)
    (multiple-value-bind (ret sidebar code-win bottom-win num)
        (codepilot-window-layout-wise)
      (cond ((null num)
             (pop-to-buffer buf)
             (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2) 10))
            ((setq win (get-buffer-window buf))
             (select-window win)
             (when (= num 2)
               (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2) 10)))
            (t
             (case ret
               ((:window-layout-1&1)
                (cond ((window-dedicated-p (selected-window))
                       (select-window code-win)))
                (progn ;;save-selected-window
                  (select-window code-win)
                  (split-window-vertically)
                  (other-window 1)
                  (switch-to-buffer buf)
                  ;; (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2) 10)
                  (when (< (count-lines (point-min) (point-max)) (/ (frame-height) 2))
                    (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2) 10))))
               ((:window-layout-1&2+
                 :window-layout-3+
                 :window-layout-2)
                (cond ((eq bottom-win (selected-window))
                       (cond ((= num 2)
                              (split-window-vertically)
                              (pop-to-buffer buf))
                             (t
                              (other-window -1)
                              (switch-to-buffer buf))))
                      (t
                       (progn ;; save-selected-window
                         (select-window bottom-win)
                         (cond ((or (eq major-mode 'occur-mode)
                                    (eq major-mode 'cpxref-mode)
                                    (eq major-mode 'cscope-list-entry-mode)
                                    (let ((s (buffer-name)))
                                      (and (eq ?* (aref s 0))
                                           (eq ?* (aref s (1- (length s)))))))
                                (switch-to-buffer buf)
                                (when (= num 2)
                                    (fit-window-to-buffer (get-buffer-window buf) (/ (frame-height) 2) 10)))
                               (t
                                (when (<= num 2)
                                  (condition-case nil
                                      (progn
                                        (split-window-vertically)
                                        (other-window 1)
                                        (switch-to-buffer buf))
                                    (error
                                     ;; for window too small error!
                                     (pop-to-buffer buf))))))))))))))))


(defun cp-pb-highlight-line-cordingly (buf-pos)
  (let (pos (to-pos 1))
    (goto-char (point-min))
    (catch 'loop
      (while (not (eobp))
        (when (setq pos (get-text-property (point) 'cp-pb-target))
          (cond ((>= buf-pos pos)
                 (setq to-pos (point)))
                (t
                 (throw 'loop nil))))
        (forward-line)))
    (goto-char to-pos)
    (codepilot-highlight-one-line-1)
    to-pos))

(defun codepilot-search-hl-again-f-2 ()
  (let ((inhibit-my-highlight-2 t)
        (inhibit-codepilot-hl-text t))
    (codepilot-search-and-hl-text codepilot-current-search-text nil
                                  codepilot-current-search-type)))


(defun cp-pb-blocktrace-and-procs-layout ()
  (interactive)
  (progn ;; when (eq major-mode 'protel-mode)
    (multiple-value-bind (ret sidebar code-win bottom-win num)
        (codepilot-window-layout-wise)
      (cond ((eq ret :window-layout-1)
             (setq code-win (selected-window)))
            ((eq ret :window-layout-1&2)
             (select-window code-win))
            (t
             (select-window code-win)
             (delete-other-windows)))
      ;; (split-window-vertically (* 3 (/ (window-height) 5)))
      (split-window-vertically)
      (other-window 1)
      (switch-to-buffer (get-buffer-create "*Which Procs*"))
      ;; (split-window-vertically (* 7 (/ (window-height) 10)))
      (split-window-vertically)
      (other-window 1)
      (switch-to-buffer (get-buffer-create "*Block Traceback*"))
      (select-window code-win)

;;       (when (eq major-mode 'protel-mode)
;;         (cp-pb-which-procs-i-in)
;;         (cp-pb-where-we-are)
;;         )
      )))


(defun cp-pb-search-id-and-which-procs ()
  (interactive)
  (codepilot-search-hi (current-word))
  (cp-pb-which-procs-i-in))


;; (defmacro* cp-pb-push-line (ll &optional last-line-b)
;;   (let ((begpt (make-symbol "--cl-var--"))
;;         (endpt (make-symbol "--cl-var--"))
;;         )
;;     `(let (,begpt ,endpt)
;;        (setq ,begpt (line-beginning-position))

;;        (when (or (null ,last-line-b)
;;                   (/= ,last-line-b ,begpt))
;;          (setq ,endpt (line-end-position))
;;          (if (and (if (boundp 'jit-lock-mode) jit-lock-mode)
;;                   (text-property-not-all, begpt ,endpt 'fontified t))
;;              (if (fboundp 'jit-lock-fontify-now)
;;                  (jit-lock-fontify-now ,begpt ,endpt)))

;;          (push (list (buffer-substring ,begpt ,endpt)
;;                      (save-excursion
;;                        (back-to-indentation)
;;                        (point))
;;                      ;; (line-number-at-pos)
;;                      )
;;                ,ll)
;;          (when ,last-line-b
;;            (setq ,last-line-b ,begpt))
;;          )
;;        ,ll)))

(defun cp-pb-push-line (ll &optional last-line-b)
  (let (begpt endpt)
    (setq begpt (line-beginning-position))

    (when (or (null last-line-b)
               (/= last-line-b begpt))
      (setq endpt (line-end-position))
      (if (and (if (boundp 'jit-lock-mode) jit-lock-mode)
               (text-property-not-all begpt endpt 'fontified t))
          (if (fboundp 'jit-lock-fontify-now)
              (jit-lock-fontify-now begpt endpt)))

      (push (list (buffer-substring begpt endpt)
                  (save-excursion
                    (back-to-indentation)
                    (point)))
            ll)
      (when last-line-b
        (setq last-line-b begpt)))
    ll))

(provide 'cp-pb)