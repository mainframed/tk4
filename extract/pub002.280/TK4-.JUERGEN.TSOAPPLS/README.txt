**************************************************************************


                          MVS 3.8j TSO Applications
                   "Primary Options Menu" for 3270 Devices
                   =======================================


**************************************************************************

  This package provides a fully functional sample implementation of an
  application selection menu for 3270 devices that can be included in
  a TSO logon CLIST (USRLOGON, etc.) to provide an easy to use path to
  the major applications of the system. It is based on a hardcoded 3270
  panel created using the MAP3270 utility and a dialog manager CLIST
  displaying the panel and interacting with the user by means of the
  CLIST <--> 3270 interface C3270.

**************************************************************************


  Installation Steps:
  ===================

The installation requires RECV370. If you don't have it, download and
install it from CBT file 571.

1. Upload file distlib.xmi (binary, LRECL=80) to your MVS 3.8j system.
2. Receive distlib.xmi into a PDS (RECFM=FB,LRECL=80).
3. Follow the steps outlined in member $$README of the distribution PDS.

Have fun!

Juergen Winkelmann, 28/8/2013
winkelmann@id.ethz.ch
