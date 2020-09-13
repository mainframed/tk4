**************************************************************************


                           C 3 2 7 0  aka  K O M M
                           =========       =======

                      Full Screen 3270 Output for CLISTs
                      ----------------------------------

  Author:        Kermit Kiser - Washington State DP Service Center (WDPSC)
  Contributions: Wolfgang Schaefer
                 Juergen Winkelmann, ETH Zuerich

  History: - First KOMM on CBT249 file 270    v1.2 Kermit Kiser        2/25/1979

           - Support for VTAM and 3279 orders v2.4 Kermit Kiser        8/03/1983

           - SBA to | conversion for v1.2     v-.- Wolfgang Schaefer   7/01/2001
           - rename to C3270
           - extended documentation
           - comprehensive examples
           - submitted to CBT file 574

           - SBA to | conversion for v2.4     v2.5 Juergen Winkelmann  8/23/2012
           - reintroduce TERMTYPE command
           - complete Kermit's extended
             datastream support from v2.4
           - wide screen support

**************************************************************************

  The C3270 command is used in CLISTs for full-screen displays on a
  3270 terminal screen. The TERMTYPE command is used to determine if
  the terminal in use is suitable for use with C3270.

**************************************************************************


  Distribution Member Index:
  ==========================

C3270    - assembler source for C3270
C3270$   - assemble and link job
C3270#   - TSO help member for C3270
C3270DOC - extended documentation by Wolfgang Schaefer
C3270TT  - assembler source for TERMTYPE
TERMTYPE - TSO help member for TERMTYPE
DEMO1   \ 
DEMO2    > original examples by Wolfgang Schaefer
DEMO3   /
DEMO4   \
DEMO5    > same as DEMO 1-3, but using extended datastream
DEMO6   /
DEMO7    - TK3UPD splash screen from Phil Roberts
DEMO8    - extension of DEMO6 showcasing TRANSADD/TA
           addressing scheme


  Installation Steps:
  ===================

1. Upload distlib.xmi to your MVS system and receive it into a
   PDS using TSO/E RECEIVE or RECV370. If you've neither download
   and install RECV370 from CBT file 571.

2. Edit job C3270$ to match your library names: Default is to use
   source members (C3270 and C3270TT) from SYS2.ASM and create the
   C3270 module with alias TERMTYPE in SYS2.CMDLIB.

3. Submit C3270$ to install C3270.

4. Copy C3270# (rename to C3270), C3270DOC and TERMTYPE to your
   TSO help library.
   
Note: C3270DOC is a very elaborate introduction to C3270 written
      by Wolfgang Schaefer in 2002. It has been updated for this
      distribution with the new NE/NOEDIT, GS/GETSIZE and
      TA/TRANSADD operands, but not with the datastream translations
      for the SFE, MF and SA orders. See the C3270 TSO help member
      (member C3270# of the distribution) for a list of all data-
      stream translations supported.

Have fun!

Juergen Winkelmann, 8/23/2012
winkelmann@id.ethz.ch
