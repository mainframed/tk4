**************************************************************************


                               C H E C K M O D
                               ===============

                     Check for presence of a load module
                     -----------------------------------

  Author:  Juergen Winkelmann - ETH Zuerich

  History: 2012/09/21 - initial implementation, version 1.0                 JW
           2012/10/02 - LOAD operand added                                  JW
                      - explicit CDE and LPDE chain loops replaced by calls JW
                        to IEAQCDSR and IEAVVMSR
                      - enhanced VERBOSE mode to report original module     JW
                        name for an alias
                      - enhanced VERBOSE mode to report the amount of       JW
                        contiguous storage needed to load the module (case
                        JOBLIB/STEPLIB/link list) or the size of the
                        module's first extent (case link pack area)
                      - changed terminal messages from TPUT to PUTLINE to   JW
                        enable batch usage

**************************************************************************

  The CHECKMOD command checks whether a load module is available
  to the current TSO session by searching JOBLIB, STEPLIB, link
  list and link pack area.

**************************************************************************

  Distribution Member Index:
  ==========================

CHECKMOD - assembler source for CHECKMOD
CHECKMO$ - assemble and link job
CHECKMO# - TSO help member for CHECKMOD

**************************************************************************

  Installation Steps:
  ===================

1. Upload distlib.xmi to your MVS system and receive it into a
   PDS using TSO/E RECEIVE or RECV370. If you've neither download
   and install RECV370 from CBT file 571.

2. Edit job CHECKMO$ to match your library names: Default is to use
   the source member (CHECKMOD) from SYS2.ASM and to create the
   CHECKMOD module in SYS1.LPALIB.

3. Submit CHECKMO$ to install CHECKMOD.

4. If you installed CHECKMOD in the PLPA (which is the default and
   is strongly recommended) perform an IPL with the CLPA option to
   activate the change.

5. Copy CHECKMO# (rename to CHECKMOD) to your TSO help library.
   
Have fun!

Juergen Winkelmann, 10/3/2012
winkelmann@id.ethz.ch
