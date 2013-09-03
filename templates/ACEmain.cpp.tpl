// Time-stamp: <10/25/2007 17:53:53 星期四 by ahei>

/**
 * @file (>>>FILE<<<)
 * @author ahei
 */

#include <iostream>

#include "ace/Get_Opt.h"
#include "ace/Argv_Type_Converter.h"

/**
 * @brief read option
 *
 * @retval 0 sucess
 * @retval -1 fail
 */
int readOption(int argc, char *argv[]);
void usage(const char *program);

/// error mark
const std::string ERROR_MARK = "[ERROR]";
/// warning mark
const std::string WARN_MARK = "[WARN]";

int main(int argc, char *argv[])
{
    if (readOption(argc, argv) != 0)
    {
        usage(argv[0]);
    }

    (>>>POINT<<<)
    return 0;
}

int readOption(int argc, char *argv[])
{
    ACE_Argv_Type_Converter argvConverter(argc, argv);
    ACE_Get_Opt getOpt(argvConverter.get_argc(), argvConverter.get_TCHAR_argv());

    getOpt.long_option(ACE_TEXT("help"), 'h', ACE_Get_Opt::NO_ARG);

    int c = 0;

    while ((c = getOpt()) != EOF)
    {
        switch (c)
        {
        case 0:
            break;

        case 'h':
            usage(argv[0]);
            break;

        default:
            ACE_DEBUG((LM_INFO, "Found an unknown option: \"%s\"\n", getOpt.last_option()));
            break;
        }
    }

    int index = 0;

    for (index = getOpt.opt_ind(); index < getOpt.argc(); index++)
    {
        ACE_DEBUG((LM_INFO, "Found non-option argument: \"%s\"\n", getOpt.argv()[index]));
    }

    return 0;
}

void usage(const char *program)
{
    std::cerr << "Usage: " << program << " <OPTION>" << std::endl;
    std::cerr << "options:" << std::endl;
    std::cerr << "-h, --help    display this info and exit" << std::endl;
    std::cerr << "Last Make: " << __DATE__ << " " << __TIME__ << std::endl;

    exit(1);
}
