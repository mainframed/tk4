//HERC01  JOB  (CBT),
//             'Create CBT cat',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: CBT.MVS38J.CNTL(CBT010)
//*
//* Desc: Create Usercatalog
//*
//********************************************************************
//DEFUCAT EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//CBTCAT   DD  DISP=SHR,UNIT=SYSDA,VOL=SER=CBTCAT
//SYSIN    DD  *
 DEFINE USERCATALOG( -
                     NAME(SYS1.UCAT.CBT) -
                     FILE(CBTCAT) -
                     VOLUME(CBTCAT) -
                     CYL(30) -
                     BUFSPC(32768) -
                     NRVBL -
                   )
