 This program display my snoozing little cat (well, actually, he
 is no longer little at all, but a proud, big tomcat.  But snoozing
 is still my little friends favourite pastime)

 As usual, my little cat comes with some wisdom from the fortune
 cookie jar.  I merged my database with about 7000 entries with
 the one found on CBTTAPE 429, file 300, member MURPHY

 The program detects the environment it is running in and uses
 WTO when running as STC, PUT when running as batch, and TPUT
 when running under TSO

The installation JCL will create a load module and a few alias names:
  BSPFCOOK
  COOKIE
  FCOOKIE
  FORTUNE

If you have not already done so, you might want to include a call to
this program in the STDLOGON procedure of SYS1.CMDPROC

Note that in the previous version of the Turnkey system the MURPHY
program (from CBT249 FILE300) was included, and a call to MURPHY
will still invoke that program.  If you want to use the new
fortune cookie jar, delete MURPHY from SYS2.CMDLIB and assign
the alias MURPHY to the load module BSPFCOOK (using, e.g., RPF option
3.4)
