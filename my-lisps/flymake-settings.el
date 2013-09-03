;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/flymake-settings.el
;; Time-stamp: <2010-11-26 13:41:40 Friday by taoshanwen>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.

(defvar flymake-mode-map (make-sparse-keymap))

(autoload 'flymake-find-file-hook "flymake" "" t)

(add-hook 'find-file-hook 'flymake-find-file-hook)

(defun flymake-settings ()
  "Settings for `flymake'."
  (setq flymake-gui-warnings-enabled nil)
  
  (defvar flymake-makefile-filenames '("Makefile" "makefile" "GNUmakefile") "File names for make.")
  
  (defun flymake-get-make-gcc-cmdline (source base-dir)
    (let (found)
      (dolist (makefile flymake-makefile-filenames)
        (if (file-readable-p (concat base-dir "/" makefile))
            (setq found t)))
      (if found
          (list "make"
                (list "-s"
                      "-C"
                      base-dir
                      (concat "CHK_SOURCES=" source)
                      "SYNTAX_CHECK_MODE=1"
                      "check-syntax"))
        (list (if (string= (file-name-extension source) "c") "gcc" "g++")
              (list "-o"
                    "/dev/null"
                    "-S"
                    source)))))

  (defun flymake-simple-make-gcc-init-impl (create-temp-f use-relative-base-dir use-relative-source build-file-name get-cmdline-f)
    "Create syntax check command line for a directly checked source file.
Use CREATE-TEMP-F for creating temp copy."
    (let* ((args nil)
           (source-file-name buffer-file-name)
           (buildfile-dir (file-name-directory source-file-name)))
      (if buildfile-dir
          (let* ((temp-source-file-name  (flymake-init-create-temp-buffer-copy create-temp-f)))
            (setq args
                  (flymake-get-syntax-check-program-args
                   temp-source-file-name
                   buildfile-dir
                   use-relative-base-dir
                   use-relative-source
                   get-cmdline-f))))
      args))
  
  (defun flymake-simple-make-gcc-init ()
    (flymake-simple-make-gcc-init-impl 'flymake-create-temp-inplace t t "Makefile" 'flymake-get-make-gcc-cmdline))
  
  (setq flymake-allowed-file-name-masks
        '(("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-gcc-init)
          ("\\.xml\\'" flymake-xml-init)
          ("\\.html?\\'" flymake-xml-init)
          ("\\.cs\\'" flymake-simple-make-init)
          ("\\.p[ml]\\'" flymake-perl-init)
          ("\\.php[345]?\\'" flymake-php-init)
          ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup)
          ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup)
          ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup)
          ("\\.tex\\'" flymake-simple-tex-init)
          ("\\.idl\\'" flymake-simple-make-init)))

  (defun flymake-display-current-warning/error ()
    "Display warning/error under cursor."
    (interactive)
    (let ((ovs (overlays-in (point) (1+ (point)))))
      (dolist (ov ovs)
        (catch 'found
          (when (flymake-overlay-p ov)
            (message (overlay-get ov 'help-echo))
            (throw 'found t))))))

  (defun flymake-goto-next-error-disp ()
    "Go to next error in err ring, and then display warning/error."
    (interactive)
    (flymake-goto-next-error)
    (flymake-display-current-warning/error))

  (defun flymake-goto-prev-error-disp ()
    "Go to previous error in err ring, and then display warning/error."
    (interactive)
    (flymake-goto-prev-error)
    (flymake-display-current-warning/error))

  (defun flymake-settings-4-emaci ()
    "`flymake' settings for `emaci'."
    (emaci-add-key-definition
     "z" 'flymake-display-current-warning/error
     '(memq major-mode dev-modes)))

  (eval-after-load "emaci"
    `(flymake-settings-4-emaci)))

(eval-after-load "flymake"
  `(flymake-settings))

(eal-define-keys
 'flymake-mode-map
 `(("C-c N"   flymake-goto-next-error-disp)
   ("C-c P"   flymake-goto-prev-error-disp)
   ("C-c M-w" flymake-display-current-warning/error)))

(provide 'flymake-settings)
