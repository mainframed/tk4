//HERC01ZS JOB (MINIZIPS),'MINIZIPS',CLASS=A,MSGCLASS=X,NOTIFY=HERC01,
//  REGION=4096K
//* USER=HERC01,PASSWORD=xxxxxxxx
//*
//********************************************************************
//*
//*  NAME: SYS2.JCLLIB(MINIZIPS)
//*
//*  DESC: Zip a sequential file using MINIZIP
//*
//*  Note: A zip archive is created from the input sequential file.
//*
//*  Note: This is a set of related samples:
//*        Running these 5 members in this order is meant to
//*        illustrate their relationship to one another.
//*    MINIUNZP - Unzip a zip archive and store each file as PDS member
//*    RECV370P - Receive the XMIT file (member),
//*               created as a result of MINIUNZP and create a PDS.
//*    XMIT370P - Create an XMIT file from the PDS created in RECV370P.
//*    MINIZIPP - Create a zip archive from the PDS created in RECV370P
//*    MINIZIPS - Create a zip archive from the sequential XMIT file
//*               created in XMIT370P.
//*
//* Here is an example of MINIZIP
//*
//* usage: minizip -abcolx zipfile files_to_add
//* where: -a opens files_to_add in text-translated mode and
//*           converts EBCDIC to ASCII.
//*        -b zips files without length indicators (use with V,VB
//*           or U datasets only).
//*        -c chooses the alternate code-page 037 instead of the
//*           default 1047.
//*        -o specifies that all files_to_add are Partition
//*           Organised datasets (PDS) and that all members/alias's
//*           in each dataset should be zipped.
//*
//*        SYSUT1 and zipfile need to be allocated as F/FB with any
//*        LRECL and BLKSIZE.
//*
//ZIPMINI  PROC VOL='PUB003'
//*
//MINIZIP  EXEC PGM=MINIZIP,PARM='output FILE571'
//FILE571  DD DSN=TK4-.JIM.CBT571.XMIT370.PDS.XMIT,DISP=SHR
//OUTPUT   DD DSN=TK4-.JIM.CBT571.XMIT370.PDS.XMIT.ZIP,
//            DISP=(NEW,CATLG),
//            DCB=(RECFM=VB,LRECL=255,BLKSIZE=15050),
//            SPACE=(TRK,(11,1)),VOL=SER=&VOL,UNIT=SYSALLDA
//SYSIN    DD DUMMY
//STDOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)
//*
//* SYSUT1   = Temporary work space
//SYSUT1   DD DSN=&&TEMP2,DISP=(,DELETE),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),
//         SPACE=(CYL,(20,20)),UNIT=SYSALLDA
// PEND
//*
//S1 EXEC PROC=ZIPMINI
//
