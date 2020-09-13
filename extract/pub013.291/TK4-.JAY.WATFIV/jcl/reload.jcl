//RELOAD   JOB  (SYS),
//             'Install WATFIV',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: RELOAD
//*
//* Desc: Install Waterloo FORTRAN IV (WATFIV)
//*
//* Note: - Cataloging WATFIV in the master catalog is not
//*         recommended. Create an alias in a user catalog for the
//*         highlevel qualifier of the WATFIV installation. On TK4-
//*         SYS1.UCAT.MVS is designed to hold the HLQs of installed
//*         programs. When using the default HLQ of WATFIV the
//*         following TSO command can be used to create the alias:
//*
//*         DEFINE ALIAS(NAME('WATFIV') REL('SYS1.UCAT.MVS'))
//*
//*       - Change all occurrences of DSN=WATFIV. to DSN=HLQ., where
//*         HLQ is the desired high level qualifier of the WATFIV
//*         installation.
//*
//*       - Change UNIT=3350,VOL=SER=PUB000 to the desired device type
//*         and serial of the DASD to install WATFIV on. If the target
//*         device is not a 3350 the SPACE parameters may need to be
//*         adjusted.
//*
//*       - The WATFIV procedure will be installed into SYS2.PROCLIB.
//*         If this is not desired change SYS2.PROBLIB in step COPY001
//*         to the desired procedure library.
//*
//********************************************************************
//*
//* Allocate WATFIV datasets
//*
//ALLOCATE EXEC PGM=IEFBR14
//DD001    DD DSN=WATFIV.FUNLIB,DISP=(,CATLG),
//            SPACE=(TRK,(8,2,13)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800),
//            UNIT=3350,VOL=SER=PUB000
//DD002    DD DSN=WATFIV.JOBLIB,DISP=(,CATLG),
//            SPACE=(TRK,(33,11,3)),
//            DCB=(RECFM=U,LRECL=0,BLKSIZE=7294),
//            UNIT=3350,VOL=SER=PUB000
//DD003    DD DSN=WATFIV.MACLIB,DISP=(,CATLG),
//            SPACE=(TRK,(31,10,19)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3440),
//            UNIT=3350,VOL=SER=PUB000
//DD004    DD DSN=WATFIV.OBJLIB,DISP=(,CATLG),
//            SPACE=(TRK,(22,7,7)),
//            DCB=(RECFM=U,LRECL=80,BLKSIZE=3440),
//            UNIT=3350,VOL=SER=PUB000
//DD005    DD DSN=WATFIV.PLOTLIB,DISP=(,CATLG),
//            SPACE=(TRK,(15,5,3)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=80),
//            UNIT=3350,VOL=SER=PUB000
//DD006    DD DSN=WATFIV.PROCLIB,DISP=(,CATLG),
//            SPACE=(TRK,(7,2,3)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=80),
//            UNIT=3350,VOL=SER=PUB000
//DD007    DD DSN=WATFIV.SOURCE,DISP=(,CATLG),
//            SPACE=(TRK,(292,97,11)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3440),
//            UNIT=3350,VOL=SER=PUB000
//DD008    DD DSN=WATFIV.WATLIB,DISP=(,CATLG),
//            SPACE=(TRK,(19,6,3)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800),
//            UNIT=3350,VOL=SER=PUB000
//DD009    DD DSN=WATFIV.ERRTEXTS,DISP=(,CATLG),
//            SPACE=(TRK,(6,0)),
//            DCB=(RECFM=F,LRECL=132,BLKSIZE=132),
//            UNIT=3350,VOL=SER=PUB000
//DD010    DD DSN=WATFIV.MESSAGE,DISP=(,CATLG),
//            SPACE=(TRK,(3,0)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3200),
//            UNIT=3350,VOL=SER=PUB000
//DD011    DD DSN=WATFIV.TESTS,DISP=(,CATLG),
//            SPACE=(TRK,(7,0)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800),
//            UNIT=3350,VOL=SER=PUB000
//DD012    DD DSN=WATFIV.USER.GUIDE,DISP=(,CATLG),
//            SPACE=(TRK,(16,0)),
//            DCB=(RECFM=VBA,LRECL=140,BLKSIZE=19040),
//            UNIT=3350,VOL=SER=PUB000
//DD013    DD DSN=WATFIV.USER.GUIDE.PDF,DISP=(,CATLG),
//            SPACE=(TRK,(34,0)),
//            DCB=(RECFM=FB,LRECL=1022,BLKSIZE=18396),
//            UNIT=3350,VOL=SER=PUB000
//*
//* Load partitioned datasets from tape
//*
//COPY001  EXEC PGM=IEBCOPY
//IN001    DD DSN=TAPE.FUNLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(1,SL)
//OUT001   DD DSN=WATFIV.FUNLIB,DISP=SHR
//IN002    DD DSN=TAPE.JOBLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(2,SL)
//OUT002   DD DSN=WATFIV.JOBLIB,DISP=SHR
//IN003    DD DSN=TAPE.MACLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(3,SL)
//OUT003   DD DSN=WATFIV.MACLIB,DISP=SHR
//IN004    DD DSN=TAPE.OBJLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(4,SL)
//OUT004   DD DSN=WATFIV.OBJLIB,DISP=SHR
//IN005    DD DSN=TAPE.PLOTLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(5,SL)
//OUT005   DD DSN=WATFIV.PLOTLIB,DISP=SHR
//IN006    DD DSN=TAPE.PROCLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(6,SL)
//OUT006   DD DSN=WATFIV.PROCLIB,DISP=SHR
//IN007    DD DSN=TAPE.SOURCE,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(7,SL)
//OUT007   DD DSN=WATFIV.SOURCE,DISP=SHR
//IN008    DD DSN=TAPE.WATLIB,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(8,SL)
//OUT008   DD DSN=WATFIV.WATLIB,DISP=SHR
//IN009    DD DSN=TAPE.SYS2PROC,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(9,SL)
//OUT009   DD DSN=SYS2.PROCLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 COPY INDD=((IN001,R)),OUTDD=OUT001
 COPY INDD=((IN002,R)),OUTDD=OUT002
 COPY INDD=((IN003,R)),OUTDD=OUT003
 COPY INDD=((IN004,R)),OUTDD=OUT004
 COPY INDD=((IN005,R)),OUTDD=OUT005
 COPY INDD=((IN006,R)),OUTDD=OUT006
 COPY INDD=((IN007,R)),OUTDD=OUT007
 COPY INDD=((IN008,R)),OUTDD=OUT008
 COPY INDD=((IN009,R)),OUTDD=OUT009
/*
//*
//* Load sequential datasets from tape
//*
//COPY002  EXEC PGM=IEBGENER
//SYSUT1   DD DSN=TAPE.ERRTEXTS,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(10,SL)
//SYSUT2   DD DSN=WATFIV.ERRTEXTS,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//*
//COPY003  EXEC PGM=IEBGENER
//SYSUT1   DD DSN=TAPE.MESSAGE,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(11,SL)
//SYSUT2   DD DSN=WATFIV.MESSAGE,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//*
//COPY004  EXEC PGM=IEBGENER
//SYSUT1   DD DSN=TAPE.TESTS,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(12,SL)
//SYSUT2   DD DSN=WATFIV.TESTS,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//*
//COPY005  EXEC PGM=IEBGENER
//SYSUT1   DD DSN=TAPE.USER.GUIDE,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(13,SL)
//SYSUT2   DD DSN=WATFIV.USER.GUIDE,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//*
//COPY006  EXEC PGM=IEBGENER
//SYSUT1   DD DSN=TAPE.GUIDE.PDF,DISP=OLD,
//            UNIT=(TAPE,,DEFER),VOL=(,RETAIN,SER=WATFIV),
//            LABEL=(14,SL)
//SYSUT2   DD DSN=WATFIV.USER.GUIDE.PDF,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//
