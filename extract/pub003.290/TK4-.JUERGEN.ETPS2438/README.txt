**************************************************************************


                E  T  P  S   for   M V S  3 . 8 j


                EMERGENCY TELE-PROCESSING SERVICES


  Author:        Brian Cook, Morton Thiokol Inc., Chicago
  Contributions: Wayne A. Mitchell, Virginia Community College System
                 Juergen Winkelmann, ETH Zuerich

  History: Initial implementation          Brian Cook        around 1983
           Version 2.1                     Brian Cook          9/27/1984
           3278-2A support                 Wayne Mitchell      4/09/1985
           EXCP attention exit removed     Brian Cook         12/17/1985
           3279-2C support                 Wayne Mitchell      1/21/1986
           Version 2.3                     Brian Cook          6/25/1986
           Attention exit added back in    Wayne Mitchell      7/07/1986
           Flag selectable attention exit  Brian Cook          7/07/1986
           Version 2.4                     Brian Cook         11/10/1986
           Final version on CBT file 353   Brian Cook         11/21/1989
 ------------------------------- Sleeping Beauty -------------------------
           Version 2.4-3.8j                Juergen Winkelmann  5/10/2012

**************************************************************************

  This program provides some basic time-sharing services when
  TSO is unavailable. If you define it as a sub-system, it can
  be brought up even when JES abends, or will not initialize.

  Version 2.4-3.8j is an adaption of Brian's final version from CBT
  file 353 to MVS 3.8j.

**************************************************************************


  Installation Steps:
  ===================

The installation of ETPS 2.4-3.8j requires RECV370. If you don't have it,
download and install it from CBT file 571.

1. Upload file etps.v2438j.xmi to your MVS 3.8j system.
2. Edit receive.jcl according to the instructions in the file.
3. Submit receive.jcl. This will receive the ETPS distribution PDS.
4. Follow the installation steps outlined in member $$README of
   the distribution PDS.

Have fun!

Juergen Winkelmann, 5/10/2012
winkelmann@id.ethz.ch
