# Process this file with autoconf to produce a configure script.
AC_INIT(Makefile.am)

# Making releases:
(>>>PROJECT<<<)_MAJOR_VERSION=1
(>>>PROJECT<<<)_MINOR_VERSION=0
(>>>PROJECT<<<)_MICRO_VERSION=0
(>>>PROJECT<<<)_VERSION=$(>>>PROJECT<<<)_MAJOR_VERSION.$(>>>PROJECT<<<)_MINOR_VERSION.$(>>>PROJECT<<<)_MICRO_VERSION
AC_SUBST((>>>PROJECT<<<)_MAJOR_VERSION)
AC_SUBST((>>>PROJECT<<<)_MINOR_VERSION)
AC_SUBST((>>>PROJECT<<<)_MICRO_VERSION)
AC_SUBST((>>>PROJECT<<<)_VERSION)
  

AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(hdr/(>>>PROJECT<<<)-config.h)
AM_INIT_AUTOMAKE((>>>PROJECT<<<),$(>>>PROJECT<<<)_VERSION)
AH_TOP(
[
#ifndef (>>>PROJECT<<<)_CONFIG_H
#define (>>>PROJECT<<<)_CONFIG_H
]
)
AH_BOTTOM(
[
#endif /*(>>>PROJECT<<<)_CONFIG_H*/
]
)

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_LANG(C++)

dnl #
dnl #Set Default CFLAGS
dnl #
dnl if use other compiler,see acchiver.sf.net

dnl gcc and g++ comm flags
COMM_FLAGS="-g -Wall -D_GNU_SOURCE -W -pedantic -Wfloat-equal -Wundef -Wshadow -Wpointer-arith \
    -Wcast-qual -Wcast-align  -Wconversion -Wsign-compare -Wredundant-decls \
    -Winline"

if test "x$GCC" = "xyes"; then
    CFLAGS="$COMM_FLAGS  -Wtraditional  -Wbad-function-cast   -Wstrict-prototypes   -Wmissing-prototypes  -Wnested-externs"
fi
if test "$GXX" = yes; then
    CXXFLAGS="$COMM_FLAGS -Woverloaded-virtual"
fi


dnl lint check
AC_ARG_ENABLE(lint_check,
        [  --enable-lint-check          lint check],
            lint_check="yes",lint_check="no")

if test "x$lint_check" = "xyes"; then
   LINT_FLAGS="  -ansi -pedantic  -Wmissing-noreturn -Wmissing-declarations -Wunreachable-code -Wundef -Wwrite-strings"

   CFLAGS="$CFLAGS $LINT_FLAGS "
   CXXFLAGS="$CXXFLAGS $LINT_FLAGS   -fcheck-new   -Weffc++   -Wold-style-cast"
   AC_MSG_RESULT("lint check  enable")
fi


AC_ARG_ENABLE(compile_optimize,
	    [  --enable-compile-optimize          compile with O2.],
		    compile_optimize="yes",compile_optimize="no")

if test "x$compile_optimize" = "xyes"; then
   CFLAGS="$CFLAGS -O2"
   CXXFLAGS="$CXXFLAGS -O2"
   AC_MSG_RESULT("compile optimize enable")
fi

##debug option
AC_ARG_WITH(debug_flags,
    [  --with-debug-flags=flags             debug flag to c and c++ file],
       debug_flags="$withval"
     )
AC_SUBST(debug_flags)


#AC_PROG_MAKE_SET
#AC_PROG_INSTALL

#AC_PROG_LIBTOOL	
AC_PROG_RANLIB

# check for doxygen
BB_ENABLE_DOXYGEN
	
# Checks for libraries.

#check have cppunit
AM_PATH_CPPUNIT(1.9.1)



# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

dnl Add a search path to the LIBS and CFLAGS variables
dnl 应该写到另外一个m4的文件中
dnl
AC_DEFUN(AC_ADD_SEARCH_PATH,[
  if test "x$1" != x -a -d $1; then
       if test -d $1/lib; then
          LDFLAGS="-L$1/lib $LDFLAGS"
       fi
       if test -d $1/include; then
          CPPFLAGS="-I$1/include $CPPFLAGS"
       fi
 fi
])



dnl
dnl 是否要做gprof
dnl
AC_ARG_ENABLE(compile_profile,
    [  --enable-compile-profile          compile with gprof.],
    compile_profile="yes",compile_profile="no")

AC_ARG_WITH(dmalloc,
	[  --with-dmalloc=PATH             Use dmalloc library (www.dmalloc.com)],
    if test "x$withval" = "xyes"; then
       LIBS="$LIBS -ldmallocthcxx"
	   AC_DEFINE(HAVE_DMALLOC_H,1,[Use dmalloc to do malloc debugging?])
	elif test -d "$withval"; then
	   AC_ADD_SEARCH_PATH($withval)
	   LIBS="$LIBS -ldmallocthcxx"
	   AC_DEFINE(HAVE_DMALLOC_H,1,[Use dmalloc to do malloc debugging?])
	fi
)

AC_ARG_WITH(purify,
    [  --with-purify=PATH             Use purify compiler],
    if test "x$withval" = "xyes"; then
        CC="purify $CC"
        CXX="purify $CXX"
       AC_DEFINE(HAVE_PURIFY_COMPILED,1,[Use purify compile ?])
    elif test -f "$withval"; then
        CC="$withval  $CC"
        CXX="$withval  $CXX"
       AC_DEFINE(HAVE_PURIFY_COMPILED,1,[Use purify compile ?])
    fi
)


dnl 加-pg
if test "x$compile_profile" = "xyes"; then
   LDFLAGS="$LDFLAGS -pg"
   CFLAGS="$CFLAGS -pg"
   CXXFLAGS="$CXXFLAGS -pg"
   AC_MSG_RESULT("compile profile enable")
fi

dnl
dnl 是否要做gcov
dnl
AC_ARG_ENABLE(compile_coverage,
    [  --enable-compile-coverage          compile with gcov.],
    compile_coverage="yes",compile_coverage="no")
if test "x$compile_coverage" = "xyes"; then
   CFLAGS="$CFLAGS -fprofile-arcs -ftest-coverage"
   CXXFLAGS="$CXXFLAGS -fprofile-arcs -ftest-coverage"
   AC_MSG_RESULT("compile coverage enable")
fi
											  
											  
AC_OUTPUT([
	  Makefile
	  hdr/Makefile
	  src/Makefile
	  src/test/Makefile
	  doc/Makefile
	  doc/Doxyfile
	  ])

																	
>>>TEMPLATE-DEFINITION-SECTION<<<
("PROJECT" "input project name:" "" "" "")
