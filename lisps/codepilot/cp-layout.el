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

(defun codepilot-window-layout-wise ()
  (let (w-tree root column2 column3 sidebar bot sidebar-splited code-win num)
    (cond ((one-window-p :nomini)
           (values :window-layout-1))
          (t
           (setq root (car (window-tree)))
           (cond ((eq nil (car root))
                  ;; |
                  (setq sidebar (third root))
                  (while (consp sidebar)
                    (setq sidebar-splited t)
                    (setq sidebar (third sidebar)))

                  (setq column2 (fourth root))
                  (setq column3 (fifth root))
                  
                  (cond ((not (window-dedicated-p sidebar))
                         (values :window-layout-no-dedicated sidebar))
                        (column3
                         (values :window-layout-x&x&x sidebar code-win bot))
                        ((atom column2)
                         (values :window-layout-1&1 sidebar column2 nil 1))
                        ((eq t (car column2))
                         (setq num (- (length column2) 2))
                         (setq bot (car (last column2)))
                         (while (consp bot)
                           (setq bot (car (last bot))))
                         (setq code-win (third column2))
                         (while (consp code-win)
                             (setq code-win (third code-win)))
                         (values :window-layout-1&2+ sidebar code-win bot num))
                        (t ;; (eq nil (car column2))
                         ;; |
                         (setq code-win (third column2))
                         (while (consp code-win)
                           (setq code-win (third code-win))
                           (setq bot (car (last code-win))))
                         (while (consp bot)
                           (setq bot (car (last bot))))
                         (values :window-layout-x&<x&x> sidebar code-win bot))))
                 ((eq t (car root))
                  ;; -
                  (let (first-win last-win)
                    (setq first-win (third root))
                    (setq last-win (car (last root)))
                    (setq num (length (window-list)))
                    (cond ((= 2 num)
                           (values :window-layout-2 nil first-win last-win num))
                          (t
                           (while (consp first-win)
                             (setq first-win (third first-win)))
                           (while (consp last-win)
                             (setq last-win (car (last last-win))))
                           (values :window-layout-3+ nil first-win last-win num)))))
                 (t
                  (print "shall not hit here?!")
                  (values :other-layout)))))))


(defsubst codepilot-layout-custom-buffer? (buf-name)
  (and (> (length buf-name) 9)(string= "*Customize"(substring buf-name 0 10))))

(defun codepilot-layout-temp-buffer? (buf-name)
  (cond ((codepilot-layout-custom-buffer? buf-name)
         nil)
        (t
         (or (eq ?* (aref buf-name 0))
             (eq ?* (aref buf-name (1- (length buf-name))))))))

(defvar codepilot-layout-temp-buffer-func 'codepilot-layout-temp-buffer?)

(defun codepilot-display-and-temp-buffer-before-advice (buffer &optional not-this-window frame)
  (cond ((get-buffer-window-list buffer))
        (t
         (save-excursion
           (multiple-value-bind (ret sidebar code-win bottom-win num)
               (codepilot-window-layout-wise)
             (case ret
               ((:window-layout-1&1)
                (cond ((window-dedicated-p (selected-window))
                       (select-window code-win)))
                (save-selected-window
                  (select-window code-win)
                  (unless (or (codepilot-layout-custom-buffer? (buffer-name))
                              (string= (buffer-name) "*info*"))
                    (split-window-vertically))))
               ((:window-layout-1&2+
                 :window-layout-3+
                 :window-layout-2)
                (let ((win-list (window-list)))
                  (cond ((eq bottom-win (selected-window))
                         (cond (nil ;; (= num 2)
                                (cond ((or (eq major-mode 'occur-mode)
                                           (funcall codepilot-layout-temp-buffer-func (buffer-name)))
                                       (unless (string= (buffer-name) "*info*")
                                         (split-window-vertically)))))
                               (t
                                (select-window code-win)
                                (dotimes (i (- num 3))
                                  (other-window 1)))))
                        ((or (codepilot-layout-custom-buffer? (buffer-name))
                             (string= (buffer-name) "*info*")))
                        (t (save-selected-window
                             (select-window bottom-win)
                             (unless (or (eq major-mode 'occur-mode)
                                         (eq major-mode 'cpxref-mode)
                                         (funcall codepilot-layout-temp-buffer-func (buffer-name)))

                               (when (< num 2) ;; (<= num 2)
                                 (condition-case nil
                                     (progn
                                       (split-window-vertically)
                                       (other-window 1)
                                       (setq bottom-win (selected-window)))
                                   (error
                                    ;; for window too small error!
                                    nil))))

                             (dolist (win win-list)
                               (unless (eq win bottom-win)
                                 (select-window win))))))))))))))



(defadvice display-buffer (before codepilot-windown-layout
                                  (buffer &optional not-this-window frame))
  (codepilot-display-and-temp-buffer-before-advice buffer not-this-window frame))

;; (defun codepilot-before-temp-buffer-setup ()
;;   (display-and-temp-buffer-before-advice))

;; (add-hook 'temp-buffer-setup-hook 'codepilot-before-temp-buffer-setup)
;; (remove-hook 'temp-buffer-setup-hook 'codepilot-before-temp-buffer-setup)

;; temp-buffer-show-function
(defun codepilot-temp-buffer-show-function (buf)
  (save-selected-window
    (let ((w-l (get-buffer-window-list buf)))
      (with-current-buffer buf
        (setq buffer-read-only t))
      (cond (w-l
             (dolist (w (cdr w-l))
               (delete-window w)))
            (t
             (pop-to-buffer buf))))))

(setq temp-buffer-show-function 'codepilot-temp-buffer-show-function)

(defadvice pop-to-buffer (before codepilot-windown-layout
                                 (buffer &optional other-window norecord))
  (save-excursion
    (multiple-value-bind (ret sidebar code-win bottom-win)
        (codepilot-window-layout-wise)
      (case ret
        ((:window-layout-1&1)
         (cond ((window-dedicated-p (selected-window))
                (select-window code-win))))))))

(defadvice delete-window (around codepilot-windown-layout
                                (&optional window))
  (multiple-value-bind (ret sidebar code-win bottom-win)
      (codepilot-window-layout-wise)
    (case ret
      ((:window-layout-1&1)
       (cond ((eq code-win (if window window (selected-window))))
             (t
              ad-do-it)))
      (otherwise
       ad-do-it
       (when (and sidebar
                  (eq sidebar (selected-window)))
         (other-window -1))))))


(defadvice delete-other-windows (around codepilot-windown-layout (&optional window))
  ;; don't delete the dedicated windows
  (let ((cur-win (if window window (selected-window))))
    (dolist (w (window-list))
      (unless (or (eq w cur-win)
                  (window-dedicated-p w))
        (delete-window w)))))


(defun codepilot-layout-activate ()
  (interactive)
  (ad-activate 'display-buffer)
  (ad-activate 'pop-to-buffer)
  (ad-activate 'delete-window)
  (ad-activate 'delete-other-windows))

(defun codepilot-layout-deactivate ()
  (interactive)
  (ad-deactivate 'display-buffer)
  (ad-deactivate 'pop-to-buffer)
  (ad-deactivate 'delete-window)
  (ad-deactivate 'delete-other-windows))

(provide 'cp-layout)

