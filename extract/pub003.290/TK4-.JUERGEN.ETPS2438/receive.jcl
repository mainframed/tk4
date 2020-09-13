//RECEIVE  JOB (ETPS),
//         'Receive XMIT PDS',
//         CLASS=A,REGION=4096K,
//         MSGCLASS=X
//*
//*********************************************************************
//*
//* Name: RECEIVE
//*
//* Desc: Receive the ETPS 2.4-3.8j distribution PDS.
//*
//* Usage: Change ETPS.V2438J.DIST to the desired distribution PDS name
//*               ETPS.V2438J.XMI  to the DSN of the XMIT dataset
//*
//*********************************************************************
//*
//RECEIVE  PROC D=,X=
//RECV370  EXEC PGM=RECV370
//RECVLOG   DD SYSOUT=*
//XMITIN    DD DSN=&X.,DISP=SHR
//SYSPRINT  DD SYSOUT=*
//SYSUT1    DD DSN=&&SYSUT1,
//             UNIT=SYSDA,
//             SPACE=(CYL,(100,50)),
//             DISP=(,DELETE,DELETE)
//SYSUT2    DD DSN=&D.,
//             UNIT=SYSDA,
//             SPACE=(TRK,(600,50,6),RLSE),
//             DISP=(,CATLG)
//SYSIN     DD DUMMY
//SYSUDUMP  DD SYSOUT=*
//         PEND
//*
//* Receive distribution PDS
//*
//RECVDIST EXEC RECEIVE,
//         D='ETPS.V2438J.DIST',
//         X='ETPS.V2438J.XMI'
//
