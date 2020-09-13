//HERC01   JOB (CBT),
//             'Run BSPPA2SI',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC02
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(PA2SI#)                                   *
//*                                                                  *
//*  Desc: Test run of BSPPA2SI                                      *
//*                                                                  *
//********************************************************************
//LISTC   PROC L=
//PA2SI   EXEC PGM=BSPPA2SI,
//             PARM=' LISTCAT LEVEL(&L)'
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(80,(1,1))
//IDCAMS  EXEC PGM=IDCAMS,COND=(4,LT,PA2SI)
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.PA2SI.SYSUT1
//        PEND
//HERC01  EXEC LISTC,L=HERC01
//HERC02  EXEC LISTC,L=HERC02
