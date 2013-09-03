;; rhtml-minor-mode.el -- Minor mode for Ruby .rhtml files that
;; attempts to link templates (views/$controller/foo.rhtml) to their
;; 'parent' (views/layouts/$controller.rhtml)

;; Copyright 2006 David N. Welton <davidw@dedasys.com>

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;	http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;; Usage --

;; I use some code like the following in my .emacs file to load up
;; both rhtml-minor-mode and two-mode-mode (which needs to be loaded
;; first, as it loads up the major modes.

;; (defun rhtml-modes ()
;;   (two-mode-mode)
;;   (rhtml-minor-mode))

;; (setq auto-mode-alist
;;       (cons '("\\.rhtml$" . rhtml-modes)
;; 	    auto-mode-alist))

;; Recent versions of this file can be found at:
;; http://www.dedasys.com/freesoftware/files/rhtml-minor-mode.el

;; TODO:

;; * It would be nice to look inside the layout template to see
;; exactly what element we are being called from.
;;
;; * We should probably not even attempt this lookup for
;; _partial.rhtml files.

(defvar rhtml-mode-bool nil)

(defun rhtml-setup (filename)
  (setq minor-mode-alist
	(cons '(rhtml-mode-bool " rhtml") minor-mode-alist))

  ;; Rumor has it that emacs translates the / as appropriate for the
  ;; operating system.
  (let* ((dirlist (split-string filename "/"))
	 ;; second to last component
	 (parentdir (car (last dirlist 2))))

    ;; if it's the layouts .rhtml file, we don't need to do anything
    ;; else.
    (when (not (string= parentdir "layouts"))
      (let ((layout
	     (append (butlast dirlist 2) '("layouts") (list (concat parentdir ".rhtml")))))
	;; put it all back together again, and assume that the layout file contains
	(setq sgml-parent-document
	      (list (concat "/" (mapconcat 'identity layout "/"))
		    "html" "body" (list)))))))

(defun rhtml-minor-mode ()
  "Minor mode for .rhtml files"
  (interactive)

  (make-local-variable 'minor-mode-alist)
  (make-local-variable 'rhtml-mode-bool)
  (setq rhtml-mode-bool t)

  (if (eq nil buffer-file-name)
      (progn
	(message "rhtml mode only works when associated with a file"))
    (rhtml-setup buffer-file-name)))

(provide 'rhtml-minor-mode)
