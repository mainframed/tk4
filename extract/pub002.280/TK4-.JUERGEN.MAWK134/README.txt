Port of MAWK to MVS
===================

This is a port of mawk to MVS. The mawk Documentation and the
current original source (without MVS adaptions) can be found at

http://invisible-island.net/mawk/mawk.html

The MVS port is based on mawk 1.3.4 at level 20100625. A fully
self contained and ready to run MVS load module is provided
as well as the original mawk source at the above mentioned
level together with a patch containing modifications needed
to adapt it to MVS.

If you intend to build mawk from source you'll need a Linux system
and Jason Winter's jcc compiler from http://www.8mm.com.au/jcc.
Please make sure to download the latest jcc version. The minimum jcc
package level needed for mawk compilation is dated 12th June 2011.

To install the load module do a binary upload of binary.load.xmi
to your MVS system and receive it into a loadlib using the RECV370
utility. To execute MAWK provide //STDIN, //STDOUT and //STDERR DD
definitions as you would do on Linux or Unix systems, plus of course
DD statements for your script and all other files that are needed
by your script. The MAWK load module can be executed using
// EXEC PGM=MAWK in a job step as well as interactively as a
TSO command processor. Of course you need to make it accessible
to the job step or TSO session, either by pointing //STEPLIB DD
to the loadlib where you received it or by putting it into linklist.
Note that MAWK is NOT reentrant, so don't put it into LPA.

To build mawk from source use gunzip/untar on a Linux system to untar
source.tgz and follow the instructions of the README file in the
folder to which you untared it.

Although the port has not been systematically tested, typically
used functions, escape sequences and regular expressions do work
without problems. The port is intended to provide a basic scripting
capability for MVS systems on which no integrated high level
scripting language like REXX is available, i.e. the target
specifically is MVS 3.8j.

Note that the system() function has not been implemented. This
means that mawk can only be used to convert data from one structure
to another but not to execute system or TSO commands. On MVS 3.8j
systems this "edit only" functionality is sufficient to automate
many system programming tasks, as the requirements typically are
of the type "create control statements for a utility from the output
of another one or from a text file".

In that sense TSO commands, for example, can be seen as control
statements to the IKJEFT01 "utility", i.e. one can create in one
job step all commands to be executed and then pass this file as
SYSTSIN to the next step to execute them through IKJEFT01. While
of course not being as versatile as to be able to execute them
directly through system() this method should be sufficient for
many needs. And if not: Feel free to implement any system()
functionality you need ...

As with every program written for ASCII based systems there
are a few considerations concerning character sets: The jcc
compiler translates all character constants to EBCDIC using
codepage 1047. So, to ensure that regular expressions and
escapes work as expected, safest would have been to simply
require that scripts be edited using codepage 1047.
Codepage 037, however, is widely used in MVS 3.8j. To
enable running scripts written using codepage 037, the one
way mappings for special characters that are used for regexps
and escapes have been created for CP 037 as well as for CP 1047.
Although this has the potential that characters that don't
have a special meaning in one codepage are interpreted with a
special meaning because they represent a special character in
the other codepage, this is unlikely, because these characters
typically are very seldom used in the other codepage. In case these
"additional" special characters still need to be used in a script
at a location where they would exhibit their function behavior,
simply escape them (i.e. precede them with a backslash) to prevent
them from triggering their function.

The files mawk_help_cp1047 and mawk_help_cp037 contain the mawk(1) man
page formatted as EBCDIC text in codepage 037 and 1047, respectively,
for browing on your MVS system (for example using REVIEW or RPF Browse).
If you prefer a more "TSO HELP"-like experience place the version fitting
the codepage you primarily use for script editing in your TSO HELP PDS
using member name MAWK. Then you can, after having allocated STDOUT to
the terminal, easily view it using the TSO command 

mawk '{print}' syshelp(mawk)

Of course you can view it using the TSO command HELP MAWK too, but
TSO HELP displays most characters having a special meaning in the
AWK language as non printable characters, i.e. as a dot, which isn't
very useful.

If you find bugs please report them to winkelmann@id.ethz.ch.

Have fun!

Juergen Winkelmann
