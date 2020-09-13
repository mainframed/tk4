
    T T Y    M O D E    T S O    F O R    T U R N K E Y     M V S    3
   ====================================================================

This modification has been developed and tested using the following
 - Linux with Hercules-3.04.1 
 - MVS 3.8J turnkey release 3 using TSO with TCAM
 - VM/370 R6 4-pack system (VM *NOT* working as of Feb. 19, 2007)

The modification consists of patches to Hercules (to add 2703 TTY 
support) and procedures for installing and starting TCAM in MVS.
The hercules mod enhances commadpt.c to add 2703 Telegraph Terminal
Control Type II (TTY 33/35) support, offering access via TCP/IP to any
standard TELNET client.

1. The supplied versions of commadpt.c and commadpt.h must be copied to
the hercules source code tree, and hercules must be recompiled and
reinstalled.  As an alternative, you can apply the patch (in file
commadpt.patch) and then recompile/reinstall hercules.

2. You must define each TTY port to be used in the hercules config file.
The following lines should be added to your herc conf file:
   00C3 2703 lport=32003 dial=IN lnctl=tele2
   00C4 2703 lport=32004 dial=IN lnctl=tele2
   00C5 2703 lport=32005 dial=IN lnctl=tele2
Note that both dial=IN and tty=1 must be specified.  Change the CUA
values and/or lport numbers as needed.

3. These TCAM installation procedures are based on the OS/360 ones...

3.1.  First, submit job 'tcamstg12.txt' (combined TCAM stage I/II).  This
should run three steps with MAXCC zero.  It should produce a load
module IEDQTCAM in SYS1.LINKLIB.

Notes
 - IEDQTCAM must now be authorized (AC=1) unlike in OS/360.
 - The example has three units.  Chg LINENO and UNITNO to add more.

3.2. Run job tcamprcs.txt.  This will install the TCAM proc in SYS1.PROCLIB,
to invoke the module you built in step 1.

Notes
 - If you change the CUA's (default 0C3 thru 0C5) you must also review
step 4 (UCB zapping locations, below), and step 0.2 above (CUA's in TCAM
startup JCL must match those in hercules conf file).

3.3. Run job tsosetup.txt.  This will install the PARMLIB member IKJPRM00.

4. The install of MVS turnkey (release 3) does not include any 2703-type
devices, which are needed by this hack.  Of the possible ways to remedy
this problem (re-run the SYSGEN, zap the nuc image, zap the running system),
these procedures will describe a simple method to zap core in the running
system.  This has the disadvantage that the changes will be lost at the next
IPL of MVS.  However the advantages are that it's the simplest possible way,
and if you make a mistake, the worst that should happen is you'll need to
re-IPL and try again.  Aside from this small zap, every aspect of your MVS
and TCAM installation will be 100% pure vanilla.

The core locations to be zapped should be constant for all users of MVS
turnkey release 3.  *HOWEVER* you are responsible to check to make sure
you are zapping the proper memory locations.

4.1. From the OS console enter the command #d 1200,16 as shown below:

----------------------------------------------------------------------
#d 1200,16
--  CMDSBSYS (#D)  L=02  BSP1  07.050  12.43  --
001200    00000000  00FF7810  0000FF80  00C30000
001210    70000000  00F0C3F3  12501009  000060D8  <=== note eyecatcher
001220    20000000  00000000  00000000  00000000       at word at 001214.
001230    00000000  00FF7810  0000FF80  00C40000       This is the 0C3 UCB.
001240    70000000  00F0C3F4  12501009  000060F0
001250    20000000  00000000  00000000  00000000
001260    00000000  00FF7810  0000FF80  00C50000
001270    70000000  00F0C3F5  12501009  00006108
----------------------------------------------------------------------

We will be zapping the fullword that appears immediately following the
eyecatcher within each UCB.  The core locations to be zapped are 001218,
001248, and 001278.  In each case the current contents are 12501009 (the
3277-type device code).  Once you have verified this proceed to the next
step.

4.2. Use the hercules console (not the MVS system console) to zap core
using the locations you previously verified in step 4.1.  Enter the
following three commands.  A sample session is shown below.
   v 1218=51 10 40 53                                                              
   v 1248=51 10 40 53                                                              
   v 1278=51 10 40 53                                                              

----------------------------------------------------------------------
v 1218=51 10 40 53                                                              
V:00001218 (primary) R:00001218                                                 
V:00001218:K:06=51104053 000060D8 20000000 00000000  .. ...-Q½.......           
v 1248=51 10 40 53                                                              
V:00001248 (primary) R:00001248                                                 
V:00001248:K:06=51104053 000060F0 20000000 00000000  .. ...-0½.......           
v 1278=51 10 40 53                                                              
V:00001278 (primary) R:00001278                                                 
V:00001278:K:06=51104053 00006108 20000000 00000000  .. .../©½.......           
----------------------------------------------------------------------

4.3. Use the OS console to verify that the devices are have been changed
from device type 3277 to type 2703.  Enter the command
   d u,,,0c3,3

----------------------------------------------------------------------
-           d u,,,0c3,3           [BEFORE]
            IEE450I 12.52.20 UNIT STATUS 321                   C       
  UNIT TYPE STATUS  VOLSER VOLSTATE   UNIT TYPE STATUS  VOLSER VOLSTATE
  0C3  3277 O                         0C4  3277 O                      
  0C5  3277 O                                                          

-           d u,,,0c3,3           [AFTER]
            IEE450I 13.00.25 UNIT STATUS 327                   C       
  UNIT TYPE STATUS  VOLSER VOLSTATE   UNIT TYPE STATUS  VOLSER VOLSTATE
  0C3  2703 O                         0C4  2703 O                      
  0C5  2703 O                                                          
----------------------------------------------------------------------

4.4. Notes
 - There are other ways to zap core including #D
 - You can use the #DU MVS system command to locate UCB's
 - I have included a sample file which contains the zapping commands 
   and which may be scripted using the hercules "script" command

5. Start TCAM and TSO:
   s tcam
   f tcam,ts=start

----------------------------------------------------------------------
-           s tcam                                
  STC  728  $HASP100 TCAM     ON STCINRDR         
- STC  728  $HASP373 TCAM     STARTED             
- STC  728  IEF403I TCAM - STARTED - TIME=13.08.19
-           f tcam,ts=start                       
  STC  728  IKJ019I TIME SHARING IS INITIALIZED   
----------------------------------------------------------------------

Notes
 - Abend 047: most likely not linked AC=1 or the load library is
   not authorized
 - IED008I TCAM OPEN ERROR 040 - F CHARERR  IN DCB LTTYA: most likely,
   the device type was not properly set to 2703 as described in step 4.
 - It's quite standard to run TCAM and VTAM/TCAS (NET/TSO) at the same
   time...
 - Some other interesting TCAM/operator commands ...
      d tp,act,0c3
      d tp,queue,t1001
      f tcam,ts=stop
      z tp
      v t1001,ontp,e
      v t1001,offtp,e
      f tcam,trace=t1001     [abends on my machine (why?)]
      #L

6. Establish a TELNET connection to the host using a port matching
"lport" in your herc config.  You should receive a TERMINAL CONNECTED
message.  DON'T just press enter at this point or you'll get kicked
off TSO...  Instead enter a LOGON command as shown below.

----------------------------------------------------------------------
localhost ~ $ telnet localhost 32003
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
Escape character is '^]'.
127.0.0.1:33026 TERMINAL CONNECTED CUA=00C3
logon ibmuser
IKJ56455I IBMUSER LOGON IN PROGRESS AT 18:53:51 ON FEBRUARY 19, 1907
IKJ56951I NO BROADCAST MESSAGES
READY 
terminal linesize(100)
READY 
----------------------------------------------------------------------

Notes
 - Press Control-C to initiate a BREAK/ATTN.
 - In this version, all lowercase input is automatically converted to
   uppercase before sending to the host.
 - IKJ54011I TSO IS NOT ACTIVE could mean you forgot to do F TCAM,TS=START

=========================================================================
UPDATES FOR TK4 BETA Feb. 25, 2007

This applies to the TK4 "beta" version created using the following two
update files:
64384474 TK3SU1.zip
   29819 fixpack1.zip

The example uses CUA's 045 through 047 instead of 0C3 - 0C5.

1. Change CUA's to 045 - 047 in tcamprcs.txt before submitting.

2. Make sure the "2703" definition lines in the herc conf file are
set to CUA's 045 - 047.

3. Change the UCB zapping locations as follows (please confirm before
   using)
# v 1328=51 10 40 53
# v 1348=51 10 40 53
# v 1368=51 10 40 53

=========================================================================
UPDATES FOR 2741 MODE 5/13/2009
        These CUA's are based on TK4b (TK3SU1+fixpack1)
herc-conf.txt         herc conf file entries for 2703 ports
herc-script-tk4b.txt  UCB zapping script (optional)
README2.txt           additional information
tcamboth.txt          TCAM install JCL for both TTY's and 2741's
commadpt.patch        for Hercules 3.06
tcamprcs.txt          updated for new L2741A DD and CUA's
vm370.txt             running TTY MVS under VM/370
