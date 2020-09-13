//HERC01   JOB (CBT),
//             'Build Addon Tape',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL($UNLOAD)                                  *
//*                                                                  *
//*  Type: JCL                                                       *
//*                                                                  *
//*  Desc: Unload MVS 3.8J Addon files to tape                       *
//*                                                                  *
//********************************************************************
//UNLOAD  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//CNTLOUT  DD  DISP=(,KEEP),DSN=BSP.MVS38J.CNTL,
//             UNIT=(TAPE,,DEFER),
//             VOL=SER=BSP38J,
//             LABEL=(1,SL)
//MACOUT   DD  DISP=(,KEEP),DSN=BSP.MVS38J.MACLIB,
//             UNIT=AFF=CNTLOUT,
//             VOL=REF=*.CNTLOUT,
//             LABEL=(2,SL)
//ASMOUT   DD  DISP=(,KEEP),DSN=BSP.MVS38J.ASM,
//             UNIT=AFF=CNTLOUT,
//             VOL=REF=*.MACOUT,
//             LABEL=(3,SL)
//LOADOUT  DD  DISP=(,KEEP),DSN=BSP.MVS38J.LOAD,
//             UNIT=AFF=CNTLOUT,
//             VOL=REF=*.ASMOUT,
//             LABEL=(4,SL)
//CMDSBOUT DD  DISP=(,KEEP),DSN=BSP.MVS38J.CMDSBSYS,
//             UNIT=AFF=CNTLOUT,
//             VOL=REF=*.LOADOUT,
//             LABEL=(5,SL)
//CNTLIN   DD  DISP=SHR,DSN=CBT.MVS38J.CNTL
//MACIN    DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB
//ASMIN    DD  DISP=SHR,DSN=CBT.MVS38J.ASM
//LOADIN   DD  DISP=SHR,DSN=SYS2.LINKLIB
//CMDSBIN  DD  DISP=SHR,DSN=CBT.CMDSBSYS.LINKLIB
//SYSIN    DD  *
 C I=CNTLIN,O=CNTLOUT
 C I=MACIN,O=MACOUT
 C I=ASMIN,O=ASMOUT
 C I=LOADIN,O=LOADOUT
 SELECT MEMBER=BSPAPFCK
 SELECT MEMBER=BSPAPFLS
 SELECT MEMBER=BSPVTMWT
 SELECT MEMBER=(BSPFCOOK,COOKIE,FCOOKIE,FORTUNE,MURPHY)
 SELECT MEMBER=BSPSETPF
 SELECT MEMBER=BSPOSCMD
 SELECT MEMBER=BSPPA2SI
 SELECT MEMBER=BSPPILOT
 SELECT MEMBER=BSPRUNSC
 SELECT MEMBER=CBT973
 SELECT MEMBER=DELAY
 SELECT MEMBER=BRODSCAN
 SELECT MEMBER=REQUEUE
 SELECT MEMBER=TAPEHDR
 SELECT MEMBER=(DISKMAP,DISKMAPA)
 SELECT MEMBER=(MOVELOAD,MOVELOD)
 SELECT MEMBER=SMPTFSEL
 C I=CMDSBIN,O=CMDSBOUT
