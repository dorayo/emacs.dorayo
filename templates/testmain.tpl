/* -*- C++ -*- */

// Time-stamp: <03/31/2009 17:47:10 星期二 by ahei>

#include <stdexcept>
#include <fstream>

#include <cppunit/CompilerOutputter.h>
#include <cppunit/TestResult.h>
#include <cppunit/TestResultCollector.h>
#include <cppunit/TestRunner.h>
#include <cppunit/TextTestProgressListener.h>
#include <cppunit/BriefTestProgressListener.h>
#include <cppunit/XmlOutputter.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
#include <cppunit/extensions/RepeatedTest.h>

using namespace CPPUNIT_NS;

int main(int argc, char * argv[])
{
    std::string testPath = argc > 1 ? argv[1] : "";
    const int DEFAULT_NUM = 1;
    int repeatNum = DEFAULT_NUM;

    if (argc > 2)
    {
        repeatNum = atoi(argv[2]);
    }
    if (repeatNum < 0)
    {
        repeatNum = DEFAULT_NUM;
    }

    TestResult controller;
    TestResultCollector result;
    BriefTestProgressListener progress;
    TestRunner runner;

    controller.addListener(&result);
    controller.addListener(&progress);

    runner.addTest(new RepeatedTest(TestFactoryRegistry::getRegistry().makeTest(), repeatNum));

    try
    {
        std::string path = (testPath == "") ? "All tests" : testPath;

        std::cout << "Running: " << path << std::endl
                  << "RunNum: " << repeatNum << std::endl;

        runner.run(controller, testPath);

        std::cout << std::endl;

        CompilerOutputter outputter(&result, std::cerr);

        outputter.write();
    }
    catch (std::invalid_argument& e)
    {
        std::cerr << std::endl
                  << "ERROR: " << e.what()
                  << std::endl;

        return EXIT_FAILURE;
    }

    return result.wasSuccessful() ? EXIT_SUCCESS : EXIT_FAILURE;
}
