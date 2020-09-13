//HERC01  JOB  (SETUP),
//             'Run BRODSCAN',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: CBT.MVS38J.CNTL(BRODSCN#)
//*
//* Desc: Run the BRODSCAN program
//*
//********************************************************************
//BRODSCN EXEC PGM=BRODSCAN
//BRODCAST DD  DSN=SYS1.BRODCAST,DISP=SHR
//SYSOUT   DD  SYSOUT=*,DCB=BLKSIZE=133
//* SYSUDUMP DD  SYSOUT=*
//
