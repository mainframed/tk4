---------------- BSPPILOT - The MVS Auto Pilot ------------------------
*
The idea to the MVS auto pilot was taken from CBT tape 249, file 33.
Unfortunately, I couldn't get it to assemble correctly for MVS 3.8.
*
After a little bit of poking around in the source and doing a few
changes here and there I could get it to compile, but it didn't
work reliably.  That's when I decided to rewrite the whole thing
and, while being at it, add a few functions as well
*
Rewrite might be too strong a word, though.  Large portions of the
R2D2 part in IEECVXIT were taken unchanged from the CBT tape
*
What do we have now:
   * IEECVXIT - The WTO exit to automatically react to WTOs.  This
                function is table driven, and currently the following
                messages are recognized (and are being processed on)
                  IST020I        S TSO          s TSO
                  IEE362A        S DUMPSMF      dump full SYS1.MANx
                  IEEXXXA        S DUMPEREP     dump full SYS1.LOGREC
                  IEA994A        S DUMPDUMP     dump full dump datasets
                  $HASP190       $SPRTx         setup printer
                  BSPSD999       S BSPSHUTD     Initiate shutdown
                The routing and descriptor codes of the following
                messages are altered such that they are now
                roll-deletetable
                   IEA911E        full dump on XXXX for asid N
                   IEA994E        partial dump.....
                   IEA994A        all dump datasets are full
                   IGF995I        I/O Restart scheduled
                   IGF991E        IGF msg for mount, swap etc
                The following messages are suppressed altogether
                   BSPTEST1       used for playtesting Autopilot
                   $HASP000       JEs OK msg
   * R2D2     - An SRB routine that runs in the BSPPILOT address
                space and replies to the following WTORs
                 IEF238D  - Device name, Wait, or Cancel      WAIT
                 IEF433D  - Hold or Nohold                    NOHOLD
                 IEF434D  - invalid reply, Hold or Nohold     NOHOLD
                 IKT010D  - SIC or FSTOP                      SIC
                 IKT012D  - Reply U                           U
                 IEC301A  - Master catalog password           U
                 IEC804A  -                                   POST
                 IFA006A  - Dump request for active MANx      CANCEL
                 BSPTEST0 - Autopilot test message            U
   * BSPPILOT - (Or should this be called C3PO).  For info see PILOT@
   * BSPRUNSC - For info see RUNSC@
