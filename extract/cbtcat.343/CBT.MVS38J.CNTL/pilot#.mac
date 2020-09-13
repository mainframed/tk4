//HERC01   JOB (CBT),
//             'Build BSPOPRWT',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(OPRWT#)                                   *
//*                                                                  *
//*  Type: JCL to run program BSPOPRWT                               *
//*                                                                  *
//*  Desc: Wait indefinitely until stop or modify command.  Used     *
//*        by Autooperator                                           *
//*                                                                  *
//********************************************************************
//JOBLIB   DD  DISP=SHR,DSN=CBT.MVS38J.LOAD  <=== or omit
//OPRWT   EXEC PGM=BSPOPRWT                  <=== Show all WTOs
//OPRWT   EXEC PGM=BSPOPRWT,PARM=NOWTO       <=== Show no WTOs
//OPRWT   EXEC PGM=BSPOPRWT,PARM=CATWTO      <=== Show the cat only
