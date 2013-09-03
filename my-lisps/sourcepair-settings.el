;; Copyright (C) 2010 ahei

;; Author: ahei <ahei0802@gmail.com>
;; URL: http://code.google.com/p/dea/source/browse/trunk/my-lisps/sourcepair-settings.el
;; Time-stamp: <2012-12-17 04:46:39 Monday by oa>

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

(eal-define-keys
 `(c-mode-base-map)
 `(("C-c d" sourcepair-load)))

(autoload 'sourcepair-load "sourcepair"
  "Load the corresponding C/C++ header or source file for the current buffer.

This function can be invoked by \\[sourcepair-load].  It will load the the
corresponding header or source file for the current buffer.  For example, if
you are looking at the file FooParser.cpp and press \\[sourcepair-load], the
file FooParser.h will be loaded.  It also works the other way as well.

There are six global variables that can be used to adjust how the function
works:

 `sourcepair-source-extensions'
 `sourcepair-header-extensions'
 `sourcepair-source-path'
 `sourcepair-header-path'
 `sourcepair-recurse-ignore'
 `sourcepair-private-header-suffixes'

See the documentation for these variables for more info.
" t)

(defun sourcepair-settings ()
  "Settings for `sourcepair'."
  (setq sourcepair-source-path '( "." "../src"))
  (setq sourcepair-header-path user-head-file-dir)
  (setq sourcepair-recurse-ignore '("CVS" "bin" "lib" "Obj" "Debug" "Release" ".svn")))

(eval-after-load "sourcepair"
  `(sourcepair-settings))

(provide 'sourcepair-settings)
