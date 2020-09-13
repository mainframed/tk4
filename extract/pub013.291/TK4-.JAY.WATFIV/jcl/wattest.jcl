//WATTEST  JOB (SYS),
//             'Test WATFIV FORTRAN',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: WATTEST
//*
//* Desc: Test Waterloo FORTRAN (WATFIV)
//*
//* Note: - Some test programs intentionally terminate with errors,
//*         an overall return code 4 is expected.
//*
//*       - This job requires the WATFIV cataloged procedure. If this
//*         procedure wasn't loaded into one of the standard procedure
//*         libraries (SYS2.PROCLIB recommended on Tur(n)key systems)
//*         use a //JOBPROC DD statement to identify it.
//*
//********************************************************************
//RUNTESTS EXEC WATFIV
//FT08F001 DD SPACE=(TRK,(20,10)),DCB=(RECFM=VS,BLKSIZE=256),UNIT=SYSDA
//SYSIN    DD DSN=WATFIV.TESTS,DISP=SHR
