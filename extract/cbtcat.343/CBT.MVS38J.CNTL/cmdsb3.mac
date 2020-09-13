//HERC01  JOB  (MVS),
//             'Install # subsys',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//* NAME: SYS1.SETUP.CNTL(CMDSB3)                                    *
//*                                                                  *
//* TYPE: JCL to allocate the CMDSBSYS load lib                      *
//*                                                                  *
//* DESC: This job is not needed if you just want to install the     *
//*       pre-assembled/compiled version                             *
//*                                                                  *
//********************************************************************
//CLEANUP EXEC PGM=IEFBR14
//LINKLIB  DD  DSN=CBT.CMDSBSYS.LINKLIB,
//             UNIT=SYSDA,
//             VOL=SER=CBT003,
//             DISP=(MOD,DELETE,DELETE),
//             SPACE=(CYL,(0)),
//             DCB=(RECFM=U,BLKSIZE=6144)
//ALLOC   EXEC PGM=IEFBR14
//LINKLIB  DD  DSN=*.CLEANUP.LINKLIB,
//             UNIT=SYSDA,
//             VOL=REF=*.CLEANUP.LINKLIB,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(CYL,(5,1,28)),
//             DCB=(RECFM=U,BLKSIZE=6144)
