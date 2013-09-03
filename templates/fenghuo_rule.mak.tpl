##  -*- makefile -*-
## 用来定义全局的变量
##
fenghuo_sharelib_dir=$(top_builddir)/../sharelib

###定义debug的宏,可以在configure中生成
fenghuo_DEBUGFLAGS=@debug_flags@

fenghuo_CFLAGS=-D__LINUX__ $(fenghuo_DEBUGFLAGS)
fenghuo_LDFALGS=-lpthread 
fenghuo_CXXFLAGS=$(fenghuo_CFLAGS)
