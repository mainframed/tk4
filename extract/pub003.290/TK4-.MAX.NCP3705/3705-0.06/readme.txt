    3705/NCP/SNA SUPPORT        EXPERIMENTAL RELEASE 0.02

 (C) COPYRIGHT 2007-2009 MHP (IKJ1234I AT YAHOO DOT COM)

This file and the other attached files may be used for any purpose,
provided that all notices are retained and proper attribution given.
No warranty ;-)

OVERVIEW OF RELEASE 0.06
========================
IBM 3791 (local SNA PU2) is now supported.  Set emu3791=yes in the herc conf
when using the 3791.  There is a new sample job (ncpjcl9) which creates the
VTAM definition for the 3791 node.
Also, please see file readme-patches.txt for a list of the patches.

OVERVIEW OF RELEASE 0.05
========================
Update VTAM configuration definitions; new LOGMODE and USS definition tables.
No Hercules driver changes in this release.

OVERVIEW OF RELEASE 0.04
========================
Add "debug=" driver config option.

OVERVIEW OF RELEASE 0.03
========================
For Kermit, wait for Carriage Return char in TTY mode prior to submitting
input line to VTAM.

OVERVIEW OF RELEASE 0.02
========================
This release contains three new features: remote 3705 support,
VTAM dial (switched major node) support, and SNA 3270 terminal support.
Also included are several fixes for bugs and limitations in release
0.01, and a new set of sample config files including remote NCP,
dial major node, and a logmode table for SNA 3270 terminal users.
Finally, there's a new and improved version of IFLOADRN, the 3705
loader program, demonstrating the transmission of IPL TEXT (load binary)
records to the remote NCP.

As in release 0.01 there's no SDLC (link protocol) support, and
3705 impersonation rather than hardware emulation is performed.
Instead of creating a complete NCP/SNA/SDLC implementation,
the focus has been to have a simplified working prototype to excercise
as much native VTAM functionality as possible (given the primitive
version of VTAM that's available under MVS 3.8).  Consequently some
actions (such as activating SDLC links/stations) don't actually do anything
other than perhaps issue some console messages, whereas in a real NCP
there would have been actual consequences including specific SDLC protocol
frames transmitted or received, modems activated or deactivated, etc.

REMOTE NCP SUPPORT
==================

The supplied sample configuration now includes a remote NCP definition.
Real remote 3705's were connected to the host over SDLC links to other
3705's, as contrasted with local (channel attached) 3705's.  The 3705
Network Control Program (NCP) was downloaded to the 3705 at boot time.
For remote 3705's this involved IPL'ing from a diskette followed by a
VTAM-initiated procedure to load the NCP.  The IBM standard 3705 loader
program (IFLOADRN) is unfortunately not available in MVS 3.8.  Apparently
this program was set up to load local 3705's by constructing its own channel
programs and issuing EXCP.  IFLOADRN loaded remote 3705's by sending each 
block of the load module to VTAM, where they were enveloped in SNA request
packets (IPLTEXT) and handed off to the adjacent NCP.  At the end of the
load sequence IFLOADRN transmits a 4-byte Entry Point address which VTAM
sends (wrapped as an IPLFINAL RU) to the remote.

The sample version of IFLOADRN supplied in experimental release 0.02
contains code to detect whether the NCP being loaded is local or remote.
For remote NCP's, it transmits two 256-byte text blocks each containing
all possible code points from x'00' - x'FF'.   The real version of
IFLOADRN would read the NCP load module from host DASD, but the sample
version just sends these blocks from a hardcoded buffer.  After the two
sample text blocks IFLOADRN sends a fake 4-byte module entry address.

In this experimental release, the 3705/NCP driver (Hercules module
comm3705.c) receives and discards the IPL (IPLINIT, IPLTEXT, and IPLFINAL)
commands including the fake load module text contents created by IFLOADRN.
However, it should suffice as a demonstration of further possibilities...

VTAM DIAL SUPPORT
=================

Also new in this release is VTAM dial (switched major node) support.  Dial
connections include a REQCONT (request contact) command to cause VTAM to
perform a table lookup (using type/IDNUM/IDBLK) to find the PU entry (in the
switched major node) matching the calling device.  VTAM dynamically assigns
the PU to the dial line for the duration of the call.  If the lookup fails,
VTAM issues the message
-----------------------------------------------------------------------
IST690I  CONNECTION REQUEST DENIED-INVALID STATION ID= 010001700017
-----------------------------------------------------------------------
and the call is disconnected.

At call disconnect, VTAM disassociates the PU from the line.  This release
also handles an abnormal disconnect (break in the TELNET connection while
the VTAM dial connection is still established) by sending INOP to VTAM:
-----------------------------------------------------------------------
IST619I  NETWORK NODE P376701  HAS FAILED - RECOVERY IN PROGRESS
IST031I  ERROR RECOVERY PROCESSING COMPLETE FOR P376701         
IST676I  DISCONNECTION SCHEDULED FOR ID= P376701                
-----------------------------------------------------------------------

If there was an active TSO logon at the time of the abnormal disconnect,
it should be possible to reconnect:
-----------------------------------------------------------------------
IKJ56400A ENTER LOGON OR LOGOFF-
logon ibmuser reconnect
IKT00300I LOGON RECONNECT SUCCESSFUL, SESSION ESTABLISHED:
READY 
-----------------------------------------------------------------------

SNA 3270 TERMINAL SUPPORT
=========================

To use this, connect your TN3270 terminal emulator client to hercules in the
same manner as for local 3270 connections (but using a different TCP port).
The terminal type (TTY or 3270) determines a value for the PU type
byte (1 or 2, respectively) set in the contact request that is sent to
VTAM.  The supplied sample switched major node contains two separate sets
of definitions, a "3767" device and a "3270".  When a remote terminal
connects (dials in), VTAM chooses the appropriate one based on the terminal
type.

Since TSO requires an SNA 3270 logon mode entry (LOGMODE) that is apparently
not included in MVS 3.8, there's one included in the samples.  Note that the
module must reside in common storage (LPA), or else you'll receive an abend
in TCAS at logon time.

The sample logmode entry includes a set of session parameters (BIND image)
that seem to be of great interest to TCAS/VTIOC, but are ignored by the SNA
logic in the Herc 3705 driver.  In particular, the query (extended 3270
datastream) bit is set to zero, but this doesn't seem to stop something
in TSO from performing a query regardless...

As of this writing, testing the 3270 logic has been confined to the x3270
client running in the Linux OS.  IND$FILE has been tested sucessfully.  The
ATTN processing works but seems to have a slight bug.  As a workaround, only
press ATTN when the keyboard is locked (use PA1 otherwise).

BUG FIXES
=========

1. The total number of nodes in the network is severely limited in the
default VTAM configs supplied in Turnkey MVS.  The VTAM parameter NPBUF 
value is too low, and needs to be raised.  A symptom that you're having
this problem is
IST603I  UNABLE TO OPEN T1009    - COMMAND CONTINUES

2. Any large sized output was failing with error messages:
IKT00403I ERROR ON OUTPUT, RETRY IN PROGRESS
IKT108I MHP      SEND    ERROR,RPLRTNCD=14,RPLFDB2=1E,SENSE=00000000,
WAITING FOR RECONNECT T1007
This occurs when the value for the MAXDATA parameter in the NCP major node
is too low.  MAXDATA should be at least 265 (MAXDATA=530 needed when using
remote NCP's).

3. A bug (MVS "hot I/O" crash) has been fixed by adding a limit on the number
of channel attentions.

4. Several minor bug and protocol fixes.
======================================================================

PROCEDURES FOR VTAM
===================

MVS 3.8 VTAM needs several files to activate an NCP:  NCP source member in
VTAMLST, and NCP and NCP-RRT load modules (in LINKLIB).  Also required is a
loader program (IFLOADRN).  It is possible to get away without the NCP load
module, and the IFLOADRN program in the simplest case could just be aliased
to IEFBR14.  This example uses an NCP major nodename of 'MHP3705' for the
local NCP name and 'MHPRMT1' for the remote.

0. If you installed an earlier release, make sure to remove ALL parts of it from
SYS1.PROCLIB
SYS1.LINKLIB
SYS1.VTAMLST
SYS1.VTAMOBJ
SYS1.VTAMLIB
SYS1.LPALIB

1. Apply the hercules patch (new 3705 module comm3705.c) and recompile.
After applying the patch and before running 'make' you may need to run
'automake' and './configure'.

2. Add the following definition to your Herc conf file:
00C7 3705 lport=32001 debug=yes

3. Submit and check the following jobs, all should have zero MAXCC.
   ncpjcl1.txt - VTAM resource definition - local NCP
   ncpjcl2.txt - NCP RRT for local NCP
   ncpjcl3.txt - new VTAM LOGMODE table BSPLMT02
   ncpjcl4.txt - IFLOADRN replacement
   ncpjcl5.txt - VTAM resource definition - remote NCP
   ncpjcl6.txt - NCP RRT for remote NCP
   ncpjcl7.txt - VTAM resource definition - switched major node
   ncpjcl8.txt - new VTAM USS Definition Table BSPUDT01

4. The logon mode (LOGMODE) table BSPLMT02 must be loaded into common 
storage (LPA).  Job ncpjcl3 (above) has created the module in SYS1.LPALIB.
Now you must re-IPL the system and reply 'CLPA' at the initial MVS prompt
to ENTER SYSTEM PARAMETERS.  Once the system has IPL'ed, verify that the
module exists in LPA: 
----------------------------------------------------------------------------
    -           #s bsplmt02                                     
    -           --  CMDSBSYS (#S)  L=01  BSP1  09.147  15.48  --
    -           BC9B68  BSPLMT02  F5F000  001088                
----------------------------------------------------------------------------

Note: before you IPL, you might want to increase the NPBUF parameter value
now in SYS1.VTAMLST(ATCSTR00) (see below).

5. The install of MVS turnkey (release 3) does not include any 3705-type
devices, needed in this hack.  A howto on zapping UCB's is available at
    http://www.lightlink.com/mhp/2703/        (see README file)
The type values to zap are 50 00 40 15.  The other values needed are:
  OS       CUA     ADDR     Hercules core zap command
MVS-TK3    0C7     12D8     v 12d8=50 00 40 15
TK4-beta   044     1308     v 1308=50 00 40 15

After zapping the UCB, verify that it's been set to device type '3705':
----------------------------------------------------------------------------
    -           d u,,,044,1                                         
                IEE450I 13.06.35 UNIT STATUS 343                   C
      UNIT TYPE STATUS  VOLSER VOLSTATE                             
      044  3705 O                                                   
----------------------------------------------------------------------------

6. From the system console
   z net,cancel
   s net,,,(NPBUF=(32,,32,f))
      [no need to restart VTAM if you've already changed parameter via
       ATCSTR00 and then re-IPL'ed]
   v net,act,id=mhp3705  [there is a 5 sec. or so delay after message IST270I]
----------------------------------------------------------------------------
    -           v net,act,id=mhp3705
      STC 3100  IST097I  VARY     ACCEPTED
      STC 3100  IST270I  370X MHP3705  NOW LOADED WITH LOADMOD MHP3705
      STC 3100  IST093I  MHP3705  ACTIVE
----------------------------------------------------------------------------

Here are some common errors (with suggested fixes)
IST025I  BLDL FAILED FOR BSPLMT02 IN VTAMLIB
    You must re-IPL MVS; reply 'CLPA' to IEA101A SPECIFY SYSTEM PARAMETERS
IST609I  VARY FAILED ID= MHP3705  - UNABLE TO PERFORM SYSTEM ALLOCATION
    The CUADDR parameter in the NCP resource definition must reference a
    unit of device type 3705.  Display the UCB (d u,,,044,1) and refer to
    the section on zapping UCB's (above).  Also make sure the unit is online
    and not already allocated.
IST603I  UNABLE TO OPEN T1007    - COMMAND CONTINUES
    Restart VTAM with an increased value for the NPBUF parameter (see above)
IFL002I  IFLOADRN FAILURE IN ISTAPC32
    The MAXDATA value in the adjacent NCP needs to be at least 530.

7. Next, activate the remote NCP
----------------------------------------------------------------------------
    -           V NET,ACT,ID=MHPrmt1                                          
      STC 7702  IST097I  VARY     ACCEPTED                                    
    | STC 7702 *01 IST183A  MHPRMT1  FOUND LOADED WITH MHPRMT1  - REPLY YES/NO
    |  TO RE-IPL                                                              
    -           r 1,yes                                                       
                IEE600I REPLY TO 01 IS;YES                                    
      STC 7702  IFL003I  IFLOADRN COMPLETED                                   
      STC 7702  IST270I  370X MHPRMT1  NOW LOADED WITH LOADMOD MHPRMT1        
  00  STC 7702  IST093I  MHPRMT1  ACTIVE                                      
----------------------------------------------------------------------------
The IST183A message occurs because VTAM contacts the NCP and finds it already
loaded.  In real life this wouldn't have occurred; the first activation 
would find nothing loaded.

8. Activate the switched major node
----------------------------------------------------------------------------
    -           v net,act,id=mhpdial
      STC 7686  IST097I  VARY     ACCEPTED
      STC 7686  IST093I  MHPDIAL  ACTIVE
----------------------------------------------------------------------------

9. Establish a TELNET (TTY) session (port is 'lport' from Step 2, above).
(OR, logon in 3270 mode; see next step).  Once connected you can enter
VTAM USS logon commands for example:
   logon applid(tso) logmode(interact)
Or, use short-form USS logon
   tso herc01
Or
   herc01

----------------------------------------------------------------------------
localhost ~ $ telnet localhost 32001
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
Escape character is '^]'.
logon applid(tso) logmode(interact)
IKJ56700A ENTER USERID -
ibmuser
IKJ56455I IBMUSER LOGON IN PROGRESS AT 15:51:32 ON MARCH 19, 1907
IKJ56951I NO BROADCAST MESSAGES
READY 
----------------------------------------------------------------------------

10. Logon in 3270 mode as follows (tested with x3270/Linux)
 - Connect your TN3270 client to port 'lport' (32001); see step 2 above
   $ x3270 -model 3279-2 -port 32001 localhost
 - Press RESET (Alt-R in x3270)
 - Press ENTER.  You should receive "UNSUPPORTED FUNCTION"
 - Type LOGON APPLID(TSO) LOGMODE(MHP3278E) [but DO NOT press ENTER]
 - Instead of pressing ENTER, you should press SYS REQ key (click on the
   keyboard icon in the upper-right corner; special-keys window appears;
   click on "Sys Req")
 - The short-form USS command "TSO2" should also work, for example:
      TSO2 <userid> [then press Sys Req key]
See above for more information about 3270 mode.

PROCEDURES FOR TCAM
===================

[NOTE: Any pretense of TCAM support has been left in release 0.01 - if you
want to play with TCAM, download release 0.01]

Run the TCAM combined stage 1/2 job tcamsna.txt, also tcamprcs.txt.  Both
should have zero MAXCC.  TCAM also needs the RRT (created in Step 3 above,
ncprrt.txt).

Enter the following commands at the OS console:
   s tp
   f tp,load=l3705a,mhp3705
   f tp,activ=l3705a
----------------------------------------------------------------------------
    -           s tp                                
      STC 3106  $HASP100 TP       ON STCINRDR       
    - STC 3106  $HASP373 TP       STARTED           
    - STC 3106  IEF403I TP - STARTED - TIME=15.44.13  
    -           f tp,load=l3705a,mhp3705              
      STC 3106  IED160I 3705 L3705A   LOAD=MHP3705    
    -           f tp,activ=l3705a                     
      STC 3106  IED382I L3705A   ACTIVATE COMPLETE    
----------------------------------------------------------------------------

A S0C4 occurs on my test system, after quite a bit of successful activity
(ACTLINK/ACTPU OK for all 3 devices).  No further TCAM testing has been done.

----------------------------------------------------------------------------

NOTES
=====

1. Yeah, I know, the naming of the PU's and LU's is strange.  This is
because the names are assigned in the TCAM sysgen process, and I decided
to just reuse the same ones for VTAM...

2. There seems to be a persistent bug that prevents activation of all three
PU's.  Things appear to work OK though if only one of the PU's is activated.
[Update for release 0.02 -- NPBUF=(32,,32,F) seems to help]

3. When logging off TSO, some VTAM resources seem to remain "hung" preventing
the user from logging back on.  It's possible that an SNA command (LUSTAT
perhaps?) might be missing.  [things seems to have improved in R0.02?]

4. However in general, the prevalence of "hung" resources seems to be even
worse now than my nostalgic memories of VTAM in the old days.  There are
undoubtedly still many bugs.....

5. SNA PIU's are traced by the Herc driver, in abbreviated form, if
debug=yes is specified on the 3705 driver definition line.
An unabridged version is available if you run a Herc CCW trace.
