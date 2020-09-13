//HERC01  JOB  (SETUP),
//             'Install MOVELOAD',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: CBT.MVS38J.CNTL(MOVELOD#)
//*
//* Desc: MOVELOAD Sample run
//*
//********************************************************************
//MOVELOD EXEC PGM=MOVELOD,PARM='POWER=9'
//SYSPRINT DD  SYSOUT=*
 MOVE TO=3350=USER50,DSNAME=HERC02.TEST.PDS
//VUSER50  DD  UNIT=3350,VOL=SER=USER50,DISP=SHR
//PROTECT  DD  UNIT=3350,VOL=SER=WORK50,DISP=SHR
//SYSUT1   DD  UNIT=3380,VOL=SER=WORK80,DISP=SHR
//LOCKSTEP EXEC PGM=IEFBR14,COND=(0,LE)
//DSNLOCK  DD  DISP=OLD,DSN=HERC02.TEST.PDS
//
