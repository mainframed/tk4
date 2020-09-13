//HERC011 JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=HERC01                   00010000
//********************************************************************  00020000
//*                                                                     00030000
//*   COPY THE CLE UTILITIES DISTRIBUTION FROM TAPE TO DISK             00040000
//*                                                                     00050000
//*   THE CLE UTILITIES DISTRIBUTION TAPE IS CUMMULATIVE.  SINCE        00060000
//*   MANY OF THE WORKS IN THIS PACKAGE ARE SMALL, I DECIDED THE        00070000
//*   TO KEEP ALL OF THE COMPONENTS IN THREE LIBRARIES - SOURCE,        00080000
//*   CONTROL, AND LOAD MODULES.                                        00090000
//*                                                                     00100000
//*   ALL DATASET CREATED BY THIS JOB WILL BE CREATED WITH THE          00110000
//*   HIGH LEVEL QUALIFIER OF HERC01 ON VOLUME PUB002.  YOU CAN         00120000
//*   DO A CHANGE ALL TO USE A DIFFERENT QUALIFIER OR VOLUME.           00130000
//*                                                                     00140000
//*   THE DISTRIBUTION TAPE CONTAINS THE FOLLOWING DATASETS:            00150000
//*   LABEL   DSN        DESCRIPTION                                    00160000
//*       1   DISTRO1    THIS JCL                                       00170000
//*       2   DISTRO2    IEBCOPY UNLOADED HERC01.CLE.DISTRO.SOURCE      00180000
//*       3   DISTRO3    IEBCOPY UNLOADED HERC01.CLE.DISTRO.SOURCEX     00190000
//*       4   DISTRO4    IEBCOPY UNLOADED HERC01.CLE.DISTRO.CNTL        00200000
//*       5   DISTRO5    IEBCOPY UNLOADED HERC01.CLE.DISTRO.CNTLX       00210000
//*       6   DISTRO6    IEBCOPY UNLOADED HERC01.CLE.DISTRO.LOADLIB     00220000
//*                                                                     00230000
//********************************************************************  00240000
//*                                                                     00250000
//*   STEP 1 - DELETE THE EXISTING PDS IF THEY EXIST                    00260000
//*                                                                     00270000
//********************************************************************  00280000
//STEP01   EXEC  PGM=IDCAMS                                             00290000
//SYSPRINT DD SYSOUT=*                                                  00300000
//SYSIN    DD *                                                         00310000
   DELETE HERC01.CLE.DISTRO.SOURCE  NONVSAM PURGE                       00320000
   DELETE HERC01.CLE.DISTRO.SOURCEX NONVSAM PURGE                       00330000
   DELETE HERC01.CLE.DISTRO.CNTL    NONVSAM PURGE                       00340000
   DELETE HERC01.CLE.DISTRO.CNTLX   NONVSAM PURGE                       00350000
   DELETE HERC01.CLE.DISTRO.LOADLIB NONVSAM PURGE                       00360000
   SET LASTCC = 0                                                       00370000
   SET MAXCC = 0                                                        00380000
//********************************************************************  00390000
//*                                                                     00400000
//*   STEP 2 - ALLOCATE THE NEW PDS                                     00410000
//*                                                                     00420000
//********************************************************************  00430000
//STEP02   EXEC  PGM=IEFBR14                                            00440000
//DD2 DD DSN=HERC01.CLE.DISTRO.SOURCE,DISP=(NEW,CATLG,DELETE),          00450000
//       UNIT=3380,VOL=SER=PUB002,SPACE=(TRK,(30,30,30)),               00460000
//       DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)                           00470000
//DD3 DD DSN=HERC01.CLE.DISTRO.SOURCEX,DISP=(NEW,CATLG,DELETE),         00480000
//       UNIT=3380,VOL=SER=PUB002,SPACE=(TRK,(15,15,15)),               00490000
//       DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)                           00500000
//DD4 DD DSN=HERC01.CLE.DISTRO.CNTL,DISP=(NEW,CATLG,DELETE),            00510000
//       UNIT=3380,VOL=SER=PUB002,SPACE=(TRK,(15,15,15)),               00520000
//       DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)                           00530000
//DD5 DD DSN=HERC01.CLE.DISTRO.CNTLX,DISP=(NEW,CATLG,DELETE),           00540000
//       UNIT=3380,VOL=SER=PUB002,SPACE=(TRK,(15,15,15)),               00550000
//       DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)                           00560000
//DD6 DD DSN=HERC01.CLE.DISTRO.LOADLIB,DISP=(NEW,CATLG,DELETE),         00570000
//       UNIT=3380,VOL=SER=PUB002,SPACE=(TRK,(15,15,15)),               00580000
//       DCB=(RECFM=U,BLKSIZE=19068)                                    00590000
//********************************************************************  00600000
//*                                                                     00610000
//*  THIS WILL RESTORE THE TAPE TO PDS USING IEBCOPY                    00620000
//*                                                                     00630000
//********************************************************************  00640000
//STEP02  EXEC PGM=IEBCOPY                                              00650000
//IN02   DD DSN=DISTRO2,DISP=(OLD,KEEP),                                00660000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=CLEDST),                    00670000
//       LABEL=(2,SL)                                                   00680000
//OUT02  DD DSN=HERC01.CLE.DISTRO.SOURCE,DISP=SHR                       00690000
//*                                                                     00700000
//IN03   DD DSN=DISTRO3,DISP=(OLD,KEEP),                                00710000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=CLEDST),                    00720000
//       LABEL=(3,SL)                                                   00730000
//OUT03  DD DSN=HERC01.CLE.DISTRO.SOURCEX,DISP=SHR                      00740000
//*                                                                     00750000
//IN04   DD DSN=DISTRO4,DISP=(OLD,KEEP),                                00760000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=CLEDST),                    00770000
//       LABEL=(4,SL)                                                   00780000
//OUT04  DD DSN=HERC01.CLE.DISTRO.CNTL,DISP=SHR                         00790000
//*                                                                     00800000
//IN05   DD DSN=DISTRO5,DISP=(OLD,KEEP),                                00810000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=CLEDST),                    00820000
//       LABEL=(5,SL)                                                   00830000
//OUT05  DD DSN=HERC01.CLE.DISTRO.CNTLX,DISP=SHR                        00840000
//*                                                                     00850000
//IN06   DD DSN=DISTRO6,DISP=(OLD,KEEP),                                00860000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=CLEDST),                    00870000
//       LABEL=(6,SL)                                                   00880000
//OUT06  DD DSN=HERC01.CLE.DISTRO.LOADLIB,DISP=SHR                      00890000
//SYSPRINT DD SYSOUT=*                                                  00900000
//SYSIN  DD *                                                           00910000
 COPY INDD=IN02,OUTDD=OUT02                                             00920000
 COPY INDD=IN03,OUTDD=OUT03                                             00930000
 COPY INDD=IN04,OUTDD=OUT04                                             00940000
 COPY INDD=IN05,OUTDD=OUT05                                             00950000
 COPY INDD=IN06,OUTDD=OUT06                                             00960000
//*                                                                     00970000
