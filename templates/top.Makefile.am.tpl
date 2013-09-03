SUBDIRS = src doc

install-exec-local:
	$(INSTALL_DATA)   ChangeLog   $(prefix)

exportversion:install
	mv $(prefix) $(distdir)
	$(AMTAR) chof - $(distdir) | GZIP=$(GZIP_ENV) gzip -c >$(distdir).tar.gz
	rm  -rf  $(distdir)

