//TESTRPG JOB  (SETUP),
//             'TEST RPG',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* NAME: SYS2.JCLLIB(TSTRPG)
//*
//* DESC: TEST RPG INSTALLATION
//*
//********************************************************************
//HELOWRLD EXEC RPGECLG
//RPG.SYSUT3 DD UNIT=SYSDA
//RPG.SYSUT2 DD UNIT=SYSDA
//RPG.SYSUT1 DD UNIT=SYSDA
//RPG.SYSGO DD  UNIT=SYSDA
//RPG.SYSIN DD  *
00000H
01010FINPUT   IPE F  80  80            READ40
01020FOUTPUT  O   V 132 132     OF     PRINTER
01010IINPUT   AA  01
01020I                                        1  12 HELLO
02130OOUTPUT  T  2     LR
02140O                         HELLO     12
//GO.OUTPUT DD SYSOUT=A
//GO.INPUT DD  *
HELLO, WORLD
//
