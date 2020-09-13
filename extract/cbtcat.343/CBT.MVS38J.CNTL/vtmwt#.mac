//TSO     PROC MEM=00
//********************************************************************
//* THIS IS ONLY NEEDED IF YOU DO NOT USE THE AUTOPILOT FUNCTIONS    *
//********************************************************************
//WAITTSO EXEC PGM=BSPVTMWT,PARM='TXX'
//TSO     EXEC PGM=IKTCAS00,TIME=1440,COND=(4,LT,WAITTSO)
//PARMLIB  DD  DISP=SHR,DSN=SYS1.PARMLIB(TSOKEY&MEM),FREE=CLOSE
//PRINTOUT DD  SYSOUT=A,DCB=(LRECL=133,RECFM=FBB)
