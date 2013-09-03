/* -*- java -*- */

/* Time-stamp: <10/14/2009 14:20:30 星期三 by ahei> */

/**
 * @file (>>>FILE<<<)
 * @author ahei
 */

import java.io.*;
import java.util.*;

import org.apache.commons.cli.*;
import org.apache.commons.logging.*;
import org.apache.log4j.*;

public class (>>>FILE_SANS<<<)
{
    private static String PROGRAM_NAME = "(>>>FILE_SANS<<<)";

    public static void main(String[] args)
    {
        Options options = new Options();
        int argsLen = 0;
        
        options.addOption("h", "help", false, "Print this usage information");
        options.addOption(OptionBuilder.withLongOpt("debug")
                          .withDescription("Set debug level, LEVEL can be: ALL, DEBUG, INFO, WARN, ERROR, FATAL, OFF, default is DEBUG.")
                          .hasOptionalArg()
                          .withArgName("LEVEL")
                          .create('d'));

        CommandLineParser parser = new PosixParser();
        CommandLine commandLine = null;

        try
        {
            commandLine = parser.parse(options, args);
        }
        catch (ParseException e)
        {
            System.err.println("You provided wrong arguments.\n");
            usage(1);
        }

        if (commandLine.hasOption("help"))
        {
            usage(0);
        }

        if (commandLine.hasOption("debug"))
        {
            Logger.getRootLogger().setLevel(Level.toLevel(commandLine.getOptionValue("debug")));
        }

        argsLen = commandLine.getArgs().length;
        (>>>POINT<<<)
    }

    public static void usage(int code)
    {
        PrintStream ps = null;

        if (code != 0)
        {
            ps = System.err;
        }
        else
        {
            ps = System.out;
        }

        String help;
        
        help = "Usage: " + PROGRAM_NAME + " [OPTIONS]\n\n"+
               "This program .\n\n"+
               "Options:\n"+
               "    -d, --debug\n"+
               "        Set debug level, can be: ALL, DEBUG, INFO, WARN, ERROR, FATAL, OFF.\n"+
               "    -h, --help\n"+
               "        Output this help.\n\n"+
               "Report bugs to <ahei0802@126.com>.";

        ps.println(help);
        
        System.exit(code);
    }
}
