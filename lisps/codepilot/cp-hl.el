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


(require 'cp-mark)
(require 'cp-base)

(defun codepilot-highlight (range-beg range-end string regexp case-fold)
  (let ((isearch-string string)
        (isearch-regexp regexp)
        (search-whitespace-regexp nil)
        (isearch-case-fold-search case-fold))
    (isearch-lazy-highlight-new-loop range-beg range-end)))

(defun codepilot-highlight-2 (buf)
  (let ((codepilot-mark-tag 'codepilot-highlight-2))
    (condition-case nil
        (save-excursion
          (set-buffer buf)
          (when codepilot-hl-text-overlay
            (overlay-put codepilot-hl-text-overlay 'face 'codepilot-hl-text-face)
            (overlay-put codepilot-hl-text-overlay 'priority 1001))
          (save-excursion
            (save-restriction
              (widen)
              (codepilot-unmark-all)
              (unless (or (codepilot-string-all-space? codepilot-current-search-text)
                          (< (length codepilot-current-search-text) 2))
                (save-match-data
                  (goto-char (point-min))
                  (cond ((eq codepilot-current-search-type 'id)
                         (while (word-search-forward codepilot-current-search-text nil t)
                           (codepilot-mark-region (match-beginning 0) (match-end 0))))
                        ((eq codepilot-current-search-type 'part-id)
                         (while (re-search-forward codepilot-current-search-text nil t)
                           (codepilot-mark-region (match-beginning 0) (match-end 0))))
                        (t
                         (while (search-forward codepilot-current-search-text nil t)
                           (codepilot-mark-region (match-beginning 0) (match-end 0))))))))))
      (error
       (message "error in codepilot-highlight-2")
       nil))))

(defun codepilot-highlight-3 (text type buf)
  (let ((codepilot-mark-tag 'codepilot-highlight-3)
        (codepilot-mark-face-var 'highlight))
    (save-excursion
      (set-buffer buf)
      (save-excursion
        (save-match-data
          (save-restriction
            (widen)
            (codepilot-unmark-all)

            (unless (or (codepilot-string-all-space? text)
                        (< (length text) 2))
              (goto-char (point-min))
              (cond ((eq type 'id)
                     (while (word-search-forward text nil t)
                       (codepilot-mark-region (match-beginning 0) (match-end 0))))
                    ((eq type 'part-id)
                     (while (re-search-forward text nil t)
                       (codepilot-mark-region (match-beginning 0) (match-end 0))))
                    (t
                     (while (search-forward text nil t)
                       (codepilot-mark-region (match-beginning 0) (match-end 0))))))))))))

(provide 'cp-hl)