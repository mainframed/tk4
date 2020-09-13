//HERC01  JOB  (SETUP),
//             'CLIP DASD',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: CLIPDASD
//*
//* DESC: Change volume serial of an offline DASD volume
//*
//********************************************************************
//ICKDSF  EXEC PGM=ICKDSF,PARM=NOREPLYU
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 REFORMAT UNITADDRESS(348) NOVERIFY VOLID(SRC000)
 REFORMAT UNITADDRESS(349) NOVERIFY VOLID(SRC001)
 REFORMAT UNITADDRESS(34A) NOVERIFY VOLID(SRC002)
 REFORMAT UNITADDRESS(34B) NOVERIFY VOLID(SRC003)
//
 REFORMAT UNITADDRESS(342) NOVERIFY VOLID(CBTCAT)
