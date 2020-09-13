//HERC01  JOB  (MVS),
//             'INSTALL # SUBSYS',
//             CLASS=A,
//             RESTART=APPCHCK.HMASMP,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//* Name: CBT.MVS38J.CNTL(CMDSB1)                                    *
//*                                                                  *
//* Type: JCL to install a PTF                                       *
//*                                                                  *
//* Desc: This PTF updates the RESETPL macro.  Without this PTF      *
//*       the assembly of CSCSBMON will fail                         *
//*                                                                  *
//* Note: The PTF UZ61025 was installed as part of SYSGEN job        *
//*       sg0050 of the MVS Turnkey system generation.  If you are   *
//*       not using the MVS Turnkey system, or did not run SG0050,   *
//*       you need to remove the RESTART line from the jobcard       *
//*                                                                  *
//********************************************************************
//RECEIVE EXEC SMPREC
//SMPPTFIN DD  DISP=SHR,DSN=CBT.MVS38J.CNTL(UZ61025)
//SMPCNTL  DD  *
 RECEIVE.
//APPCHCK EXEC SMPAPP
//SMPCNTL  DD  *
 APPLY GROUP(UZ61025)
       DIS(WRITE)
       CHECK
 .
//APPLY  EXEC SMPAPP,COND=(0,NE)
//SMPCNTL DD  *
 APPLY GROUP(UZ61025)
       DIS(WRITE)
       .
//ACCCHCK EXEC SMPACC,COND=(0,NE)
//SMPCNTL  DD  *
 ACCEPT GROUP(UZ61025)
       DIS(WRITE)
       CHECK
 .
//ACCEPT EXEC SMPACC,COND=(0,NE)
//SMPCNTL DD  *
 ACCEPT GROUP(UZ61025)
        DIS(WRITE)
 .
