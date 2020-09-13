//JCCC    PROC SOUT='*',JCC='JCC',INFILE='',JOPTS=''
//********************************************************************
//*
//* Name: SYS2.PROCLIB(JCCC)
//*
//* Desc: Compile C program using JCC
//*
//********************************************************************
//COMPILE  EXEC PGM=JCC,
//         PARM='-I//DDN:JCCINCL //DDN:SYSIN &JOPTS'
//STEPLIB  DD   DSN=&JCC..LINKLIB,DISP=SHR
//JCCINCL  DD   DSN=&JCC..INCLUDE,DISP=SHR
//JCCINCS  DD   DSN=&JCC..INCLUDE,DISP=SHR
//JCCOUTPT DD   UNIT=SYSDA,SPACE=(TRK,(50,20)),DISP=(,PASS),DSN=&&OUTPT
//STDOUT   DD   SYSOUT=&SOUT
//JCCOASM  DD   SYSOUT=&SOUT
//SYSIN    DD   DSN=&INFILE,DISP=SHR
