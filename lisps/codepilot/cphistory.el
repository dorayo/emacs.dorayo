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

;; ============ next buffer and previous buffer

(eval-when-compile
  (require 'cl))

(require 'cp-layout)
(require 'cp-base)

;; codepilot-pre-pop-or-switch-buffer-hook

(defcustom codepilot-marker-ring-length 50
  ""
  :type 'integer
  :group 'codepilot)

(defcustom codepilot-forward-marker-ring-length 50
  ""
  :type 'integer
  :group 'codepilot)



(defvar codepilot-marker-ring (make-ring codepilot-marker-ring-length))
(defvar codepilot-forward-marker-ring (make-ring codepilot-forward-marker-ring-length))


(defun codepilot-push-marker ()
  ""
  (interactive)
  (codepilot-push-marker-1 codepilot-marker-ring))

(add-hook 'codepilot-pre-pop-or-switch-buffer-hook 'codepilot-push-marker)

(defun codepilot-pop-marker ()
  ""
  (interactive)
  (if (ring-empty-p codepilot-marker-ring)
      (error "There are no marked buffers in the codepilot-marker-ring yet."))

  (let* ((pushed (codepilot-push-forward-marker))
         (maker1 (ring-remove codepilot-marker-ring 0))
         (buf (nth 0 maker1))
         (pos (nth 1 maker1))
         (buf-mode (nth 2 maker1)))

    (when (and (string= buf (buffer-name))
             (= pos (point)))
      ;; Same buffer and pos found.
      (message "Same buffer and pos in the ringe. Go to the next one.")
      (when (ring-empty-p codepilot-marker-ring)
        (ring-remove codepilot-forward-marker-ring 0)
        (error "There are no marked buffers in the codepilot-marker-ring yet."))
      ;; try the next one
      (setq maker1 (ring-remove codepilot-marker-ring 0))
      (setq buf (nth 0 maker1))
      (setq pos (nth 1 maker1))
      (setq buf-mode (nth 2 maker1)))

    (if (codepilot-find-file buf buf-mode)
        (goto-char pos)
      (when pushed
          (ring-remove codepilot-forward-marker-ring 0))
      (codepilot-pop-marker))))



(defun codepilot-find-file (name mode)
  ""
  (interactive)
  (let ((buf (get-buffer name))
        file-full-path done ret)
    (cond (buf
           (codepilot-switch-to-buffer buf)
           (setq ret buf))
          (t
           (message (concat "Buffer " name " not exists. Back to ring further."))))
    ret))

(defun codepilot-push-forward-marker ()
  ""
  (interactive)
  (codepilot-push-marker-1 codepilot-forward-marker-ring))

(defun codepilot-push-marker-1 (ring)
  ""
  (interactive)

  (multiple-value-bind (ret sidebar code-win bottom-win)
      (codepilot-window-layout-wise)
    (when code-win
      (select-window code-win)))

  (let (;(mark1 (point-marker))
        (pos (point))
        (buf (buffer-name))
        (buf-mode major-mode)
        entry1
        cur
        (push t))

    (when (eq buf-mode 'cplist-mode)
      (setq push nil))

    (unless (ring-empty-p ring)
      (setq cur (ring-ref ring 0))

      (when (and (string= (nth 0 cur) buf)
                 (= (nth 1 cur) pos))
        (message "Same marker right here. Ignore")
        (setq push nil)))

    (when push
      (setq entry1 (list buf pos buf-mode))
      (ring-insert ring entry1)
      ;; (message "push marker")
      entry1)))


(defun codepilot-pop-forward-marker ()
  ""
  (interactive)
  (if (ring-empty-p codepilot-forward-marker-ring)
      (error "There are no marked buffers in the codepilot-forward-marker-ring yet."))

  (let* (pushed
         (maker1 (ring-remove codepilot-forward-marker-ring 0))
         (buf (nth 0 maker1))
         (pos (nth 1 maker1))
         (buf-mode (nth 2 maker1)))

    (while (and (string= (nth 0 maker1) (buffer-name))
               (= (nth 1 maker1) (point)))
      (if (ring-empty-p codepilot-forward-marker-ring)
          (error "Buffer is the same.")
        (setq maker1 (ring-remove codepilot-forward-marker-ring 0))
        (setq buf (nth 0 maker1))
        (setq pos (nth 1 maker1))
        (setq buf-mode (nth 2 maker1))
        (message "Same marker. go to the next.")))

    (setq pushed (codepilot-push-marker))

    (if (codepilot-find-file buf buf-mode)
        (goto-char pos)
      (when pushed
          (ring-remove codepilot-marker-ring 0))
      (codepilot-pop-forward-marker))))

(defalias 'codepilot-previous-buffer 'codepilot-pop-marker)

(defalias 'codepilot-forward-buffer 'codepilot-pop-forward-marker)

(defun codepilot-clear-marker-ring ()
  ""
  (interactive)
  (while (not (ring-empty-p codepilot-forward-marker-ring))
    (ring-remove codepilot-forward-marker-ring 0))

  (while (not (ring-empty-p codepilot-marker-ring))
    (ring-remove codepilot-marker-ring 0)))


(provide 'cphistory)