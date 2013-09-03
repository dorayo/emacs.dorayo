SUBDIRS = src doc tools
DEPTH       = ..
include     $(top_srcdir)/rule.mak

INCLUDES = -I$(top_builddir)/hdr -I$(top_srcdir)/hdr    \
            -I$(fenghuo_sharelib_dir)/hdr

bin_PROGRAMS	=(>>>PROGRAM<<<) 
(>>>PROGRAM<<<)_SOURCES			=(>>>PROGRAM<<<).(>>>POINT<<<)
(>>>PROGRAM<<<)_LDADD		 	=
(>>>PROGRAM<<<)_LDFLAGS        	=     
(>>>PROGRAM<<<)_CFLAGS 			=
(>>>PROGRAM<<<)_CXXFLAGS		=

noinst_LIBRARIES                   =libxxxx.a
libxxxx_a_SOURCES            =   \
        xxxxx.cpp \
libxxxx_a_CXXFLAGS = $(fenghuo_CXXFLAGS)

release:
	[ -d ../lib ] ||  mkdir ../lib
	$(INSTALL) $(lib_LIBRARIES)  ../lib
all-local:release

install-exec-local:
	$(INSTALL_DATA)   ChangeLog   $(prefix)



>>>TEMPLATE-DEFINITION-SECTION<<<
("PROGRAM" "bin program name:" "" "" "run")
