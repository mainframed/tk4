//HERC01   JOB (CBT),
//             'Build BSPAPFLS',
//             CLASS=A,
//*            RESTART=LINK,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(APFLS$)                                   *
//*                                                                  *
//*  Type: Assembly of BSPAPFLS Module                               *
//*                                                                  *
//*  Desc: List APF privilegded data sets                            *
//*                                                                  *
//********************************************************************
//ASM     EXEC PGM=IFOX00,PARM='DECK,NOOBJECT,TERM,NOXREF'
//********************************************************************
//* You might have to change the DSNAMES in the next 2 DD statements *
//********************************************************************
//SYSIN    DD  DISP=SHR,DSN=CBT.MVS38J.ASM(BSPAPFLS)
//SYSLIB   DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DISP=(,PASS),UNIT=VIO,SPACE=(CYL,(1,1))
//LINK    EXEC PGM=IEWL,
//             COND=(0,NE),
//             PARM='LIST,LET,MAP,SIZE=(140K,6400)'
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(TRK,(50,20))
//SYSLMOD  DD  DISP=SHR,DSN=SYS2.LINKLIB(BSPAPFLS)   <<=== CHANGE
//*YSLMOD  DD  DISP=(,PASS),UNIT=VIO,SPACE=(CYL,(1,1,1)),
//*            DCB=SYS2.LINKLIB,DSN=&&GOSET(GO)
//SYSLIN   DD  DISP=(OLD,DELETE),DSN=*.ASM.SYSPUNCH
//
//LISTAPF EXEC PGM=*.LINK.SYSLMOD,COND=(0,NE)
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
