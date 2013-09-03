CXX=g++
#CXX=$(XREFACTORY_COMPILER_WRAPPERS)g++ --xcall g++
OBJS=browsing.o index.o ideCompileAndRun.o refactorings/index.o refactorings/rename.o refactorings/parameter.o refactorings/extract.o


all: $(OBJS) completions.o


completions.o: $(OBJS)


clean:;
	rm -f $(OBJS)




