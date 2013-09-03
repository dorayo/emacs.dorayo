##  -*- makefile -*-
## 用来定义全局的变量,不需要要什么in文件，am中自动包含##

###定义debug的宏,可以在configure中生成
##@debug_flags@

##ace_lib_dir=


###所有的INCLUDE and lidadd 
project_INCLUDES= -I$(top_builddir)/hdr -I$(top_srcdir)/hdr
project_LIBADDS =


