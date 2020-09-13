//HERC01UZ JOB (MINIUNZP),'MINIUNZP',CLASS=A,MSGCLASS=X
//* USER=HERC01,PASSWORD=xxxxxxxx
//*
//********************************************************************
//*
//*  NAME: SYS2.JCLLIB(MINIUNZP)
//*
//*  DESC: Unzip a zip archive using MINIUNZ
//*
//*  Note: Each output file from the zip input is stored as a pds mbr
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
//********************************************************************
//*
//MINIUNZ PROC DUMMY='',          <=== Code 'DUMMY,' for stats only
//           INDSN='missing',
//*         INFILE='missing',     <=== Single file name example
//*            EXT='.xmi',        <=== Single file name example
//          OUTPDS='missing',
//           ASCII=''             <=== Code '-l' for stats only
//*
//* usage: miniunz -aclv zipfile dest_file ªfile_to_extract³
//* where: -a opens files in text-translated mode and converts
//*           ASCII to EBCDIC.
//*        -c chooses the alternate code-page 037 instead of the
//*           default 1047.
//*        -l only lists statistics and files in the zip archive.
//*        -v only lists statistics and files in the zip archive.
//*
//*        If no file_to_extract is specified, all files are
//*        extracted and the destination file will have (member)
//*        automatically appended.
//*
//MINIUNZ EXEC PGM=MINIUNZ,
//* PARM='&ASCII dd:input dd:output &INFILE.&EXT' makeutil format
//* PARM='&ASCII input output &INFILE.&EXT' to extract only one file
//  PARM='&ASCII input output'
//*STEPLIB  DD DSN=&HLQ..MAKEUTIL.LINKLIB,DISP=SHR
//INPUT    DD  DSN=&INDSN,DISP=SHR
//**          DCB=(LRECL=0,BLKSIZE=32760,RECFM=U)
//*OUTPUT   DD  DSN=&OUTPDS(&INFILE), Single file name
//OUTPUT   DD  &DUMMY.DSN=&OUTPDS,
//             DISP=(NEW,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),
//             SPACE=(TRK,(6000,2000,15),RLSE),
//             VOL=SER=WORK03,UNIT=3390
//SYSIN    DD  DUMMY
//STDOUT   DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)
//SYSTERM  DD  SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)
//*
// PEND
//*
//*   FOR STATS ONLY
//*
//STEP010 EXEC PROC=MINIUNZ,
//**           COND=(0,LE),   <=== UNCOMMENT TO BYPASS THIS STEP
//            ASCII='-l',
//            INDSN='TK4-.JIM.CBT571.XMIT370.ZIP',
//            DUMMY='DUMMY,',OUTPDS='DUMMY'
//*
//*   FOR ACTUAL UNZIP
//*
//STEP020 EXEC PROC=MINIUNZ,
//            INDSN='*.STEP010.MINIUNZ.INPUT',
//*          INFILE='FILE571',    <=== Single file name example
//*            EXT='.xmi',        <=== Single file name example
//          OUTPDS='TK4-.JIM.CBT571.XMIT370.UNZIP'
//
