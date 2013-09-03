TESTS = testmain

check_PROGRAMS = testmain

testmain_SOURCES =								\
	testmain.cpp								\
	TestHashTrie.cpp
testmain_CXXFLAGS	=  -D_UNIT_TEST
testmain_LDFLAGS	= -lcppunit
