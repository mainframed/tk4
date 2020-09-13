//IEHMAP$  JOB (001),'INSTALL IEHMAP',                                  00010000
//             CLASS=A,MSGCLASS=A,COND=(0,NE)                           00020000
//*                                                                     00030000
//********************************************************************* 00040000
//* FIRST, LINK THE S/370 VERSION OF IEHMAP FROM CBT129 FILE #083       00050000
//********************************************************************* 00060000
//*                                                                     00070000
//CBT129 EXEC LKED                                                      00080000
//LKED.SYSLIN  DD DSN=IEHMAP.OBJECTS,UNIT=(TAPE,,DEFER),DISP=OLD,       00090000
//             VOL=SER=200203,LABEL=(1,SL)                              00100000
//LKED.SYSLMOD DD DSN=SYS2.LINKLIB,DISP=SHR                             00110000
//*                                                                     00120000
//********************************************************************* 00130000
//* ASSEMBLE REPLACEMENT MAPDEV MODULE                                  00140000
//********************************************************************* 00150000
//*                                                                     00160000
//A      EXEC ASMFC,PARM.ASM='LOAD,NODECK,LIST'                         00170000
//ASM.SYSIN DD *                                                        00180000
         TITLE 'MAPDEV - TABLE OF DEVICE CONSTANTS'                     00010000
         PRINT ON,DATA                                                  00020000
*---------------------------------------------------------------------* 00030000
*                                                                     * 00040000
*  THIS IS A REPLACEMENT FOR THE MAPDEV MODULE IN THE S/370 VERSION   * 00050000
*  IF IEHMAP.  IT SHOULD NOT BE INCORPORATED INTO THE LATEST VERSION  * 00060000
*  OF IEHMAP AS THE MAPDEV MODULE FOR THAT VERSION OF IEHMAP USES     * 00070000
*  A DIFFERENT TABLE THAN THIS.                                       * 00080000
*                                                                     * 00090000
*  I CREATED THIS VERSION OF MAPDEV TO UPDATE IEHMAP FOR USE WITH     * 00100000
*  VERSION 3.8J OF MVS UNDER HERCULES - JAY MOSELEY, MARCH, 2002.     * 00110000
*                                                                     * 00120000
*  IT IS BASED ON THE SOURCE FOR MAPDEV IN THE CURRENT CBT TAPE.      * 00130000
*                                                                     * 00140000
*  EACH ENTRY OF THE TABLE IN MAPDEV IS FORMATTED AS FOLLOWS:         * 00150000
*                                                                     * 00160000
*             FIELD NAME                          BYTES               * 00170000
*             ----------                          -----               * 00180000
*      DEVICE TYPE                                  0                 * 00190000
*      DEVICE DESCRIPTION                          1-15               * 00200000
*      SCALE FACTORS FOR CCHH OF DEVICE           16-23               * 00210000
*        FACTOR TO CONVERT REL-TRACK TO CCHH      16-17               * 00220000
*          (THIS IS USED FOR DEVICES THAT HAVE                        * 00230000
*           HH AS A SINGLE NUMBER, OTHERWISE                          * 00240000
*           SHOULD BE ZERO - THIS IS REALLY                           * 00250000
*           TRACKS PER CYL FOR NORMAL DEVICES)                        * 00260000
*        FACTOR TO CONVERT CC TO REL-TRACK        18-19               * 00270000
*          (THIS IS USED FOR DEVICES THAT                             * 00280000
*           SPLIT THE FUNCTION OF HH INTO H(1),                       * 00290000
*           AND H(2) WHICH THEN HAVE DIFFERENT                        * 00300000
*           MEANINGS - THIS IS REALLY TRACKS                          * 00310000
*           PER CYL FOR NORMAL DEVICES)                               * 00320000
*        FACTOR TO CONVERT H(1) TO REL-TRACK      20-21               * 00330000
*          (SHOULD BE ZERO IF H(1) NOT USED)                          * 00340000
*        FACTOR TO CONVERT H(2) TO REL-TRACK      22-23               * 00350000
*          (IN CONVERSION FROM REL-TRACK TO                           * 00360000
*           CCHH, THIS IS ASSUMED TO BE '1')                          * 00370000
*        NUMBER OF TRACKS PER CYLINDER            24-25               * 00380000
*        MAX RELATIVE TRACK FOR DEVICE            26-27               * 00390000
*                                                                     * 00400000
*---------------------------------------------------------------------* 00410000
MAPDEV   CSECT                                                          00420000
*                                                                       00430000
         ENTRY MDEVEND,MDVPATCH                                         00440000
*                                                                       00450000
MAPDEVT  EQU   *                                                        00460000
         DC    X'09'               3330 MODEL 1                         00470000
         DC    CL15'3330 DISK PACK '                                    00480000
         DC    H'19,19,1,1,19,7676'    7676 -> 19 * 404                 00490000
MDENTLN  EQU   *-MAPDEVT                                                00500000
*---------------------------------------------------------------------* 00510000
         DC    X'0D'               3330 MODEL 11                        00520000
         DC    CL15'3330-1 DISK    '                                    00530000
         DC    H'19,19,1,1,19,15352'   15352 -> 19 * 808                00540000
*---------------------------------------------------------------------* 00550000
         DC    X'0A'               3340 MODEL 35                        00560000
         DC    CL15'3340 DISK PACK '                                    00570000
         DC    H'12,12,1,1,12,4176'    4176 -> 12 * 348                 00580000
*---------------------------------------------------------------------* 00590000
         DC    X'0B'               3350                                 00600000
         DC    CL15'3350 DISK PACK '                                    00610000
         DC    H'30,30,1,1,30,16650'   16650 -> 30 * 555                00620000
*---------------------------------------------------------------------* 00630000
         DC    X'0E'               3380 A/B/D/J                         00640000
         DC    CL15'3380 DISK PACK '                                    00650000
         DC    H'15,15,1,1,15,13275'   13275 -> 15 * 885                00660000
*---------------------------------------------------------------------* 00670000
         DC    X'0F'               3390-1                               00680000
         DC    CL15'3390 DISK PACK '                                    00690000
         DC    H'15,15,1,1,15,16710'   16710 -> 15 * 1114               00700000
*---------------------------------------------------------------------* 00710000
         DC    X'08'               2314                                 00720000
         DC    CL15'2314 DISK PACK '                                    00730000
         DC    H'00,20,1,1,20,4000'    4000 -> 20 * 200                 00740000
*---------------------------------------------------------------------* 00750000
         DC    X'01'               2311                                 00760000
         DC    CL15'2311 DISK PACK '                                    00770000
         DC    H'00,10,0,1,10,2000'    2000 -> 10 * 200                 00780000
*---------------------------------------------------------------------* 00790000
         DC    X'0C'               3375                                 00800000
         DC    CL15'3375 DISK PACK '                                    00810000
         DC    H'12,12,1,1,12,11508'   11508 -> 12 * 959                00820000
*---------------------------------------------------------------------* 00830000
         DC    X'07'               2305-2                               00840000
         DC    CL15'2305-2 DISK    '                                    00850000
         DC    H'00,08,0,1,08,768'     768 -> 8 * 96                    00860000
*---------------------------------------------------------------------* 00870000
         DC    X'06'               2305-1                               00880000
         DC    CL15'2305-1 DISK    '                                    00890000
         DC    H'00,08,0,1,08,384'     384 -> 8 * 48                    00900000
*---------------------------------------------------------------------* 00910000
         DC    X'05'               2321                                 00920000
         DC    CL15'2321 DATA CELL '                                    00930000
         DC    H'00,46,0,1,46,11500'                                    00940000
*---------------------------------------------------------------------* 00950000
         DC    X'04'               2302                                 00960000
         DC    CL15'2302 DISK PACK '                                    00970000
         DC    H'00,46,0,1,46,11500'                                    00980000
*---------------------------------------------------------------------* 00990000
         DC    X'03'               2303                                 01000000
         DC    CL15'2303 DRUM      '                                    01010000
         DC    H'00,10,0,1,10,800'                                      01020000
*---------------------------------------------------------------------* 01030000
         DC    X'02'               2301                                 01040000
         DC    CL15'2301 DRUM      '                                    01050000
         DC    H'00,08,0,1,08,200'                                      01060000
*---------------------------------------------------------------------* 01070000
MDEVEND  EQU   *                                                        01080000
         DC    X'FF'                                                    01090000
         DC    CL15'END OF TABLE   '                                    01100000
         DC    H'15,15,1,1,15,16680'                                    01110000
*---------------------------------------------------------------------* 01120000
MDVPATCH EQU   *                                                        01130000
         DC    5XL(MDENTLN)'00'                                         01140000
         END                                                            01150000
//SYSGO    DD  DSN=&&MAPDEV,DISP=(,PASS),                               00200000
//             UNIT=SYSDA,SPACE=(TRK,60)                                00210000
//*                                                                     00220000
//********************************************************************* 00230000
//* RELINK IEHMAP LOAD MODULE REPLACING MAPDEV CSECT                    00240000
//********************************************************************* 00250000
//*                                                                     00260000
//LKED    EXEC PGM=IEWL,REGION=1024K,                                   00270000
//             PARM='LIST,LET,XREF,MAP'                                 00280000
//NEWMOD   DD  DSN=&&MAPDEV,DISP=(OLD,PASS)                             00290000
//SYSLIN   DD  *                                                        00300000
  INCLUDE NEWMOD                                                        00310000
  INCLUDE SYSLMOD(IEHMAP)                                               00320000
  ENTRY IEHMAP                                                          00330000
  SETCODE AC(1)                                                         00340000
  SETSSI 00075248                                                       00350000
  NAME IEHMAP(R)                                                        00360000
/*                                                                      00370000
//SYSLMOD  DD  DSN=SYS2.LINKLIB,DISP=SHR                                00380000
//SYSUT1   DD  SPACE=(1024,(120,120),,,ROUND),UNIT=SYSDA                00390000
//SYSPRINT DD  SYSOUT=*                                                 00400000
//                                                                      00410000
