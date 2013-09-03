TDIR=../xref-recipe-build-compiler-wrappers
CC=gcc

all: ../xref-recipe-build \
	$(TDIR)/xref-recipe-build-compiler-wrapper \
	$(TDIR)/c++ \
	$(TDIR)/g++ \
	$(TDIR)/gcc \
	$(TDIR)/cc \
	$(TDIR)/CC

../xref-recipe-build: xref-recipe-build.c
	$(CC) -O -o ../xref-recipe-build xref-recipe-build.c

$(TDIR)/xref-recipe-build-compiler-wrapper: xref-recipe-build-compiler-wrapper.c
	$(CC) -O -o $(TDIR)/xref-recipe-build-compiler-wrapper xref-recipe-build-compiler-wrapper.c

$(TDIR)/c++: xref-recipe-build-compiler-wrapper.c
	$(CC) -O -o  $(TDIR)/c++ xref-recipe-build-compiler-wrapper.c
$(TDIR)/g++: xref-recipe-build-compiler-wrapper.c
	$(CC) -O -o  $(TDIR)/g++ xref-recipe-build-compiler-wrapper.c
$(TDIR)/gcc: xref-recipe-build-compiler-wrapper.c
	$(CC) -O -o  $(TDIR)/gcc xref-recipe-build-compiler-wrapper.c
$(TDIR)/cc: xref-recipe-build-compiler-wrapper.c
	$(CC) -O -o  $(TDIR)/cc xref-recipe-build-compiler-wrapper.c
$(TDIR)/CC: xref-recipe-build-compiler-wrapper.c
	$(CC) -O -o  $(TDIR)/CC xref-recipe-build-compiler-wrapper.c



clean:;
	rm -f ../xref-recipe-build $(TDIR)/c++ $(TDIR)/g++ $(TDIR)/gcc $(TDIR)/cc $(TDIR)/CC
