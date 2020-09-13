//HERC01RS JOB (RECV370S),'RECV SEQ',CLASS=A,MSGCLASS=X
//* USER=HERC01,PASSWORD=xxxxxxxx
//*
//********************************************************************
//*
//*  Name: SYS2.JCLLIB(RECV370S)
//*
//*  Desc: Receive xmitted data set back into SEQUENTIAL data set
//*
//********************************************************************
//*
//RECV370  EXEC PGM=RECV370
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//*
//* XMITIN - INput: the XMITTED data set
//XMITIN   DD  DISP=SHR,DSN=HERC01.FB80.DATA
//*
//* SYSUT1 - OUTput the data set to receive the sequential data
//SYSUT1   DD  DSN=HERC01.RECV370.DEMO.SEQ,
//             UNIT=SYSDA,VOL=SER=WORK03,
//             SPACE=(TRK,(60,60),RLSE),
//             DISP=(,CATLG,DELETE)
//SYSIN    DD  DUMMY
//SYSUDUMP DD  SYSOUT=*
