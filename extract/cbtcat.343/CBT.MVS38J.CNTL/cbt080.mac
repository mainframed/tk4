//HERC01  JOB  (CBT),
//             'Install compression',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(2,1),
//             REGION=4096K
//********************************************************************
//*                                                                  *
//* Name: CBT.MVS38J.CNTL(CBT080)                                    *
//*                                                                  *
//* Desc: Assemble and link the CBT compression/decompression program*
//*                                                                  *
//********************************************************************
/*MESSAGE  *****************************
/*MESSAGE  *                           *
/*MESSAGE  *          Note:            *
/*MESSAGE  *          =====            *
/*MESSAGE  *                           *
/*MESSAGE  * This job needs the CBTtape*
/*MESSAGE  * 129 in AWS format.  This  *
/*MESSAGE  * can be downloaded from    *
/*MESSAGE  *                           *
/*MESSAGE  * http://www.cbttape.org    *
/*MESSAGE  *                           *
/*MESSAGE  *****************************
//ASM     EXEC PGM=IFOX00,PARM='DECK,NOOBJECT,TERM,NOLIST'
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSLIB   DD  DISP=SHR,DSN=SYS1.MACLIB
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//SYSIN    DD  UNIT=(TAPE,,DEFER),
//             VOL=(,RETAIN,SER=CBT129),
//             DISP=(OLD,PASS),
//             DCB=(DEN=3,RECFM=FB,LRECL=80,BLKSIZE=32720),
//             DSN=CBT129.FILE002,
//             LABEL=(2,NL)
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DISP=(,PASS),UNIT=VIO,SPACE=(CYL,(1,1))
//LINK    EXEC PGM=IEWL,PARM='MAP,LIST,XREF'
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSPRINT DD  SYSOUT=*
//SYSLIN   DD  DISP=(OLD,DELETE),DSN=*.ASM.SYSPUNCH
//SYSLMOD  DD  DISP=SHR,DSN=SYS2.LINKLIB(CBT973) <<==== change
