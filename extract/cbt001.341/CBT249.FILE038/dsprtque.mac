//DSPRTQUE JOB (T369027000),'INIT.DSPRINT.QUE',MSGCLASS=X,
//  CLASS=B,NOTIFY=TEC5722,TYPRUN=HOLD
/*JOBPARM ROOM=20,S=C033
//S1       EXEC PGM=PROGDQUE
//STEPLIB  DD   DSN=TEC.PROD.LOAD,DISP=SHR
//SYSUT1   DD   UNIT=3350,DISP=(NEW,DELETE),SPACE=(TRK,(1,1)),
//     DCB=(RECFM=F,BLKSIZE=2480,LRECL=2480)
//SYSUT2   DD   DSN=DSPRINT.REQUEST.QUEUE,DISP=OLD
//SYSUDUMP DD   SYSOUT=*
//SYSIN    DD   *
***********************************************************************
*                                                                     *
*              DSPRINT QUEUE SOURCE                                   *
*                                                                     *
*    SYNTAX:  COL 1 TO 8 LEFT ADJUSTED - NODE NAME                    *
*             COL 9 BLANK                                             *
*             COL 10 DSPRINT FEATURES(CHOOSE LETTER CODE BELOW)       *
*             COL 11 BLANK                                            *
*             COL 12 -> COMMENTS                                      *
*                                                                     *
*    FEATURE CODES  MACH  VFC  MAX  PLATEN PAGE     MARGIN     BUFFER *
*                   TYPE      PAGE   WIDTH SIZE   TOP  BOTTOM     C   *
*                            WIDTH     C    L      L     L            *
*                              C                                      *
*                                                                     *
*              A    3286   NO  132     132   66     2     2      1920 *
*              B    3286  YES  132     132   66     2     2      1920 *
*                                                                     *
*          C - CHARACTERS; L - LINES.                                 *
***********************************************************************
COMM01   A
COMM11   A
COSTEA7  A
PFIN     A
POR1     A
POR2     A
PPER     A
PUR1     A
PUR2     A
P100     A
RA503    A
RA50E    A
RA50F    A
RA602    A
RA611    A
RA621    A
RA703    A
RA711    A
RA721    A
RA807    A
RA903    A
RD02     B
RD05     B
RD08     A
RD0B     A
RE08     B
RE09     B
RE0A     A
RE0B     A
RE28     B
RE29     B
RE2A     A
RE2B     A
RG08     A
RG09     A
RG0A     A
RG0B     A
RG18     B
RG19     B
RG1A     B
RG1B     B
RG28     A
RG29     A
RG2A     A
RG2B     A
RG38     B
RG39     B
RG3A     A
RG3B     A
RH0E     A
RI0O     A
RI0Q     A
RI0R     A
RI0S     A
RI0T     A
RK12     A
RK17     A
RK1E     A
RK21     A
RK6C     A
RK6D     A
RK6E     A
RK6F     A
RL0L     A
RL0M     A
RL0N     A
RL0O     A
RN11     A
RN17     A
RQ08     A
RQ09     A
RQ0D     A
RQ14     A
RQ62     A
RR08     A
RR09     A
RR0A     B
RR0B     A
RR18     A
RR19     A
RR1A     B
RR1B     A
RR28     A
RR29     A
RR2A     B
RR2B     A
RS08     A
RS09     A
RS0A     B
RS0B     A
RS18     A
RS19     A
RS1A     A
RS1B     A
RV02     A
RX01     A
RY01     A
RY06     A
RY11     A
RY14     A
RY15     A
RZ04     A
RZ13     A
R003     A
R011     A
R202     A
R204     A
R206     A
R208     A
R209     A
R20E     A
R20I     A
R20N     A
R217     A
R218     A
R21A     A
R21L     A
R21M     A
R21N     A
R21R     A
R21S     A
R21T     A
R303     A
R304     A
R337     A
R371     B
/*
