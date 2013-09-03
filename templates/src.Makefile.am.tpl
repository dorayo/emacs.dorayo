SUBDIRS = . test
DEPTH       = ..
include     $(top_srcdir)/rule.mak


INCLUDES = $(project_INCLUDES) 
LDADDS   = $(project_LIBADDS)


bin_PROGRAMS	=(>>>PROGRAM<<<) 
(>>>PROGRAM<<<)_SOURCES			=(>>>PROGRAM<<<).cpp
(>>>PROGRAM<<<)_LDADD		 	=
(>>>PROGRAM<<<)_LDFLAGS        	=     
(>>>PROGRAM<<<)_CFLAGS 			=
(>>>PROGRAM<<<)_CXXFLAGS		=

noinst_LIBRARIES                   =lib(>>>PROGRAM<<<).a
lib(>>>PROGRAM<<<)_a_SOURCES            =   
lib(>>>PROGRAM<<<)_a_CXXFLAGS =



>>>TEMPLATE-DEFINITION-SECTION<<<
("PROGRAM" "bin program name:" "" "" "run")
