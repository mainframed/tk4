SMPTFSEL is from CBT Tape 249, file 38.  It allows filtering of
data stored in SMP libraries.
Selection parameters are given in SYSIN in free format as a sequence of
keywords and parameters where
              KEYWORD is field label in SMPLIST report
              VALUE   is generic value to be selected
                      or a generic value range
              .       indicates end of parameters
Examples:
 FMID(ESP1200) FMID(JSP1210) .      (A)
 APP(80-80.122) .                   (B)
 REQ(UZ9-UZ95).                     (C)
 PRE(UZ27866) .                     (D)
 LMOD(IKJCT469) .                   (E)
 UMID(USER-USER50) UMID(USER900).   (F)
 SZAP(IRARMCNS) .                   (G)
Results: (depending on SMP list parameters)
 (A) all elements belonging to the FMIDs
 (B) all elements applied 80.000 thru 80.122
 (C) all elements that req any element in the range
 (D) all elements that pre-req UZ27866
 (E) all modules of IKJCT469
 (F) all elements updated by USER50. thru USER900
 (G) all superzaps for IRARMCNS

Sample execution JCL is in CBT.MVS38J.CNTL(SMPSL#)


