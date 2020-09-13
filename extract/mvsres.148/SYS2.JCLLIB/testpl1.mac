//TESTPL1 JOB  (SETUP),
//             'TEST PLI',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* NAME: SYS2.JCLLIB(TESTPL1)
//*
//* DESC: TEST PLI INSTALLATION
//*
//********************************************************************
//HELOWRLD EXEC PL1LFCLG
//PL1L.SYSLIN DD UNIT=SYSDA
//PL1L.SYSIN DD *
 HELLO: PROC OPTIONS(MAIN);
 PUT SKIP LIST('HELLO WORLD');
 END HELLO;
//LKED.SYSLIB DD DSN=SYS1.PL1LIB,DISP=SHR
//GO.STEPLIB DD DSN=SYS1.PL1LIB,DISP=SHR
//
