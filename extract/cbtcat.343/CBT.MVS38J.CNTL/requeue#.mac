//HERC01  JOB  (SETUP),
//             'Test run REQUEUE',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name:REQUEUE#
//*
//* Desc: Sample run of REQUEUE module
//*
//********************************************************************
//IEHLIST EXEC PGM=IEHLIST
//SY5PR1NT DD SYSOUT=*
 LISTVTOC VOL=3350=MVSRES,FORMAT
//VSYSRES  DD UNIT=SYSDA,VOL=SER=MVSRES,DISP=SHR
//REQUEUE EXEC PGM=REQUEUE,COND=(0,EQ,IEHLIST)
