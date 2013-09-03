CC=gcc
#CC=$(XREFACTORY_COMPILER_WRAPPERS)gcc --xcall gcc
OBJS=browsing.o index.o ideCompileAndRun.o refactorings/index.o refactorings/rename.o refactorings/parameter.o refactorings/extract.o


all: $(OBJS) completions.o


completions.o: $(OBJS)


clean:;
	rm -f $(OBJS)




