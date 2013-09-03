;; -*- Emacs-Lisp -*-

;; Time-stamp: <2009-11-13 16:53:29 Friday by ahei>

(defgroup paren-position nil
  "Paren position group."
  :prefix "paren-position-")

(defcustom paren-position-cpp-prefix "^\\s-*#\\s-*"
  "Prefix of c pre-processing symbol."
  :type 'regexp
  :group 'paren-position)

(defcustom paren-position-cpp-ifx (concat paren-position-cpp-prefix "\\(ifn?def\\)\\s-+")
  "Regexp of ifdef or ifndef in c/c++."
  :type 'regexp
  :group 'paren-position)

(defcustom paren-position-cpp-else (concat paren-position-cpp-prefix "\\(else\\)\\b")
  "Regexp of endif in c/c++."
  :type 'regexp
  :group 'paren-position)

(defcustom paren-position-cpp-endif (concat paren-position-cpp-prefix "\\(endif\\)\\b")
  "Regexp of endif in c/c++."
  :type 'regexp
  :group 'paren-position)

(defcustom paren-position-goto-behavior 'smart
  "Behavior when goto #ifdef/#ifndef, #else, #endif."
  :group 'paren-position)

(defun paren-position-goto ()
  "When found c pre-processing symbol, goto it."
  (let ((word-start (match-beginning 1)))
    (cond
     ((eq paren-position-goto-behavior 'smart)
      (if (= (char-before word-start) ?#)
          (back-to-indentation)
        (goto-char word-start)))
     ((eq paren-position-goto-behavior 'word)
      (goto-char word-start))
     ((eq paren-position-goto-behavior 'pound)
      (back-to-indentation))
     ((eq 'line-beginning)
      (move-beginning-of-line nil)))))

(defun paren-position-goto-endif ()
  "Goto #endif."
  (interactive)
  (move-beginning-of-line nil)
  (if (re-search-forward paren-position-cpp-endif (point-max) t)
      (paren-position-goto)
    (message "Can not found #endif.")))

(defun paren-position-goto-ifx ()
  "Goto #ifdef/#ifndef."
  (interactive)
  (move-end-of-line nil)
  (if (re-search-backward paren-position-cpp-ifx (point-min) t)
      (paren-position-goto)
    (message "Can not found #ifdef/#ifndef.")))

(defun paren-position-goto-next-cpp ()
  "Goto next c pre-processing symbol."
  )
(defun paren-position-goto-else ()
  "Goto #else."
  (interactive)
