//HERC01   JOB (CBT),
//             'Build SMPTFSEL',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(SMPSL$)                                   *
//*                                                                  *
//*  Type: Assembly of SMPSEL Module                                 *
//*                                                                  *
//*  Desc: Select SYSMOD entries via FMID                            *
//*                                                                  *
//*  Note: Requires CBT249.FILE038 (File 38 from CBT TAPE 249)       *
//*                                                                  *
//********************************************************************
//CBTASML PROC CBT='CBT249.FILE038',
//             SYSLMOD='SYS2.LINKLIB',    <<==== CHANGE
//             MEMBER=SMPTFSEL
//ASM     EXEC PGM=IFOX00,
//             REGION=1024K,
//             PARM='NOXREF,NOLIST,TERM,DECK,NOOBJECT'
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSLIB   DD  DISP=SHR,DSN=&CBT,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB
//         DD  DISP=SHR,DSN=CBT.MVS38J.ASM
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//SYSPUNCH DD  UNIT=VIO,
//             SPACE=(CYL,(1,1)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),
//             DISP=(NEW,PASS)
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DISP=SHR,DSN=&CBT(&MEMBER)
//LINK    EXEC PGM=IEWL,PARM='XREF,LIST,MAP',COND=(0,NE,ASM)
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSPRINT DD  SYSOUT=*
//SYSLMOD  DD  DISP=SHR,DSN=&SYSLMOD(&MEMBER)
//SYSLIN   DD  DISP=(OLD,DELETE),DSN=*.ASM.SYSPUNCH
//         DD  DDNAME=SYSIN
//        PEND
//SMPTFSEL EXEC CBTASML
