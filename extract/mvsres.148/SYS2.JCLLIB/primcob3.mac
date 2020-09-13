//PRIMCOB3 JOB (COBOL),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMCOB3)
//*
//* Desc: Sieve of Eratosthenes programmed in COBOL.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed. An assembler subroutine
//*       is used to overcome COBOL 32767 array index
//*       and 131068 array length limitations.
//*
//********************************************************************
//ARRAY   EXEC ASMFC,PARM.ASM=(OBJ,NODECK,NOESD,NOLIST,NOXREF)
//ASM.SYSIN DD *
INIPRIME TITLE 'Provide Array to COBOL Program'
         ENTRY ISPRIME,SETPRIME,RLSPRIME entry points
***********************************************************************
***                                                                 ***
*** Program:  INIPRIME                                              ***
***                                                                 ***
*** Purpose:  Provide dynamic array to COBOL Sieve of Eratosthenes  ***
***                                                                 ***
***********************************************************************
INIPRIME CSECT ,                main entry point and program name
*
* Obtain storage and initialize array
*
         SAVE  (14,12),,*       save registers
         LR    R12,R15          establish module addressability
         USING INIPRIME,R12     tell assembler of base
         LA    R2,SAVEA         chain ..
         ST    R13,4(,R2)         .. the ..
         ST    R2,8(,R13)           .. save ..
         LR    R13,R2                 .. areas
         L     R2,0(,R1)        array size address
         L     R7,0(,R2)        array size
         LA    R7,1(,R7)        COBOL Sieve will overshoot by one
         ST    R7,SIZE          remember array size
         GETMAIN R,LV=(R7)      obtain storage
         ST    R1,ARRAY         remember address of gotten storage
         LR    R6,R1            address of array for MVCL
         XR    R8,R8            clear R8 for MVCL
         L     R9,INIT          get initialization pattern for MVCL
         MVCL  R6,R8            initialize array
         B     RETURN           return to caller
*
* Query array element
*
ISPRIME  SAVE  (14,12),,*       save registers
         USING ISPRIME,R15      tell assembler of temporary base
         L     R12,LOADED       establish original base
         DROP  R15              drop temporary base
         LA    R2,SAVEA         chain ..
         ST    R13,4(,R2)         .. the ..
         ST    R2,8(,R13)           .. save ..
         LR    R13,R2                 .. areas
         LM    R2,R3,0(R1)      array index and return value addresses
         L     R2,0(,R2)        index value
         BCTR  R2,0             COBOL index counts from 1, decrement
         L     R7,ARRAY         array address
         LA    R7,0(R2,R7)      array element address
         MVC   1(1,R3),0(R7)    return array element
         B     RETURN           return to caller
*
* Set array element
*
SETPRIME SAVE  (14,12),,*       save registers
         USING SETPRIME,R15     tell assembler of temporary base
         L     R12,LOADED       establish original base
         DROP  R15              drop temporary base
         LA    R2,SAVEA         chain ..
         ST    R13,4(,R2)         .. the ..
         ST    R2,8(,R13)           .. save ..
         LR    R13,R2                 .. areas
         LM    R2,R3,0(R1)      array index and return value addresses
         L     R2,0(,R2)        index value
         BCTR  R2,0             COBOL index counts from 1, decrement
         L     R7,ARRAY         array address
         LA    R7,0(R2,R7)      array element address
         MVC   0(1,R7),1(R3)    set array element
         B     RETURN           return to caller
*
* Release array
*
RLSPRIME SAVE  (14,12),,*       save registers
         USING RLSPRIME,R15     tell assembler of temporary base
         L     R12,LOADED       establish original base
         DROP  R15              drop temporary base
         LA    R2,SAVEA         chain ..
         ST    R13,4(,R2)         .. the ..
         ST    R2,8(,R13)           .. save ..
         LR    R13,R2                 .. areas
         L     R1,ARRAY         array address
         L     R7,SIZE          array size
         FREEMAIN R,LV=(R7),A=(R1) release storage
*
* Return to caller
*
RETURN   L     R13,4(,R13)      caller's save area pointer
         RETURN (14,12),RC=0    restore registers and return
*
* Data area
*
SAVEA    DS    18F              save area
LOADED   DC    A(INIPRIME)      our own address
INIT     DC    X'01000000'      array initialization pattern
ARRAY    DS    F                array address
SIZE     DS    F                array size
R0       EQU   0                Register  0
R1       EQU   1                Register  1
R2       EQU   2                Register  2
R3       EQU   3                Register  3
R4       EQU   4                Register  4
R5       EQU   5                Register  5
R6       EQU   6                Register  6
R7       EQU   7                Register  7
R8       EQU   8                Register  8
R9       EQU   9                Register  9
R10      EQU   10               Register 10
R11      EQU   11               Register 11
R12      EQU   12               Register 12
R13      EQU   13               Register 13
R14      EQU   14               Register 14
R15      EQU   15               Register 15
         END   INIPRIME         end of INIPRIME
/*
//ASM.SYSGO DD UNIT=VIO,SPACE=(800,(1,1)),DISP=(,PASS),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800),DSN=&&INIPRIME
//PRIMES   EXEC COBUCG,
//         PARM.COB='FLAGW,LOAD,SUPMAP,SIZE=2048K,BUF=1024K'
//COB.SYSPUNCH DD DUMMY
//COB.SYSIN    DD *
   10 * //////////////////////////////////////////////////////////
   20 * // Name: Peter M. Maurer
   30 * // Program: Sieve of Eratosthenes
   40 * // Due: Never
   50 * // Language: COBOL
   60 * //
   70 * // Changes:
   80 * // - Juergen Winkelmann, 2014/10/25, o adaption to IBM OS COBOL
   90 * //                                   o read limit from SYSIN
  100 * //                                   o n**2 (sqrt) shortcut
  110 * //                                   o skip even numbers
  120 * //                                   o compact output format
  130 * //                                   o dynamic prime flags
  140 * //////////////////////////////////////////////////////////
  150 ***
  160 ***
  170 ***
  180  IDENTIFICATION DIVISION.
  190  PROGRAM-ID.  'PRIMES'.
  200 ***
  210 ***
  220 ***
  230  ENVIRONMENT DIVISION.
  240 **
  250 **
  260  CONFIGURATION SECTION.
  270  SOURCE-COMPUTER.  IBM-360.
  280  OBJECT-COMPUTER.  IBM-360.
  290 **
  300 **
  310  INPUT-OUTPUT SECTION.
  320  FILE-CONTROL.
  330      SELECT PRIMES-SYSIN
  340         ASSIGN TO UT-S-SYSIN.
  350 ***
  360 ***
  370 ***
  380  DATA DIVISION.
  390 **
  400 **
  410  FILE SECTION.
  420  FD  PRIMES-SYSIN
  430      RECORDING MODE IS F
  440      RECORD CONTAINS 80 CHARACTERS
  450      BLOCK  CONTAINS  1 RECORDS
  460      LABEL RECORDS ARE OMITTED
  470      DATA RECORD IS PRIMES-SYSIN-RECORD.
  480  01  PRIMES-SYSIN-RECORD.
  490   02 PRIMES-SYSIN-NUMBER PIC 99999999 OCCURS 10.
  500 **
  510 **
  520  WORKING-STORAGE SECTION.
  530      77 I PIC 99999999 COMP VALUE 1.
  540      77 J PIC 99999999 COMP.
  550      77 K PIC 99999999 COMP VALUE 1.
  560      77 N PIC 99999999 COMP.
  570      77 N-2 PIC 99999999 COMP.
  580      77 SQRTN PIC 99999999 COMP.
  590      77 PRODUCT PIC 99999999 COMP.
  600      77 ISPRIME PIC 9 VALUE 1 COMP.
  610      77 NOTPRIME PIC 9 VALUE 0 COMP.
  620      01 BLANK-LINE PIC A(160) VALUE ' '.
  630      01 OUT-INTEGER.
  640       02 SHOWIT PIC ZZZZZZZZ OCCURS 20.
  650      01 OUT REDEFINES OUT-INTEGER.
  660       02 OUT-LINE PIC X(160).
  670 ***
  680 ***
  690 ***
  700  PROCEDURE DIVISION.
  710 **
  720 **
  730  MAIN-PART.
  740      OPEN INPUT PRIMES-SYSIN.
  750      READ PRIMES-SYSIN AT END DISPLAY '** EOF on SYSIN **'.
  760      MOVE PRIMES-SYSIN-NUMBER (1) TO N.
  770      CLOSE PRIMES-SYSIN.
  780      SUBTRACT 2 FROM N GIVING N-2.
  790 *
  800      PERFORM NEXT-SQUARE UNTIL SQRTN GREATER N.
  810      MOVE I TO SQRTN.
  820 *
  830      MOVE 3 TO I.
  840      CALL 'INIPRIME' USING N.
  850      PERFORM CHECK-NUMBER UNTIL I GREATER SQRTN OR EQUAL SQRTN.
  860 *
  870      MOVE 3 TO I.
  880      MOVE 2 TO J.
  890      MOVE J TO SHOWIT (K).
  900      PERFORM PRINT UNTIL I GREATER N.
  910      CALL 'RLSPRIME'
  920 *
  930      MOVE K TO SHOWIT (1).
  940      MOVE N TO SHOWIT (2).
  950      DISPLAY ' '.
  960      DISPLAY SHOWIT (1), ' primes up to ', SHOWIT (2), ' found.'.
  970      STOP RUN.
  980 **
  990 **
 1000  CHECK-NUMBER.
 1010      PERFORM ADVANCE UNTIL I GREATER THAN SQRTN OR EQUAL TO SQRT
 1020 -     N OR ISPRIME EQUAL TO 1.
 1030      IF ISPRIME EQUAL TO 1
 1040          ADD I I GIVING J
 1050          MULTIPLY I BY I GIVING PRODUCT
 1060          PERFORM CROSS-OUT UNTIL PRODUCT GREATER THAN N.
 1070      MOVE 0 TO ISPRIME.
 1080 **
 1090 **
 1100  ADVANCE.
 1110      ADD 2 TO I.
 1120      CALL 'ISPRIME' USING I ISPRIME.
 1130 **
 1140 **
 1150  CROSS-OUT.
 1160      CALL 'SETPRIME' USING PRODUCT NOTPRIME.
 1170      ADD J TO PRODUCT.
 1180 **
 1190 **
 1200  NEXT-SQUARE.
 1210      ADD 1 TO I.
 1220      MULTIPLY I BY I GIVING SQRTN.
 1230 **
 1240 **
 1250  PRINT.
 1260      CALL 'ISPRIME' USING I ISPRIME.
 1270      IF ISPRIME EQUAL TO 1
 1280          MOVE I TO SHOWIT (J)
 1290          ADD 1 TO K
 1300          ADD 1 TO J
 1310          IF J GREATER 20
 1320              DISPLAY OUT-LINE
 1330              MOVE BLANK-LINE TO OUT-LINE
 1340              MOVE 1 TO J.
 1350      IF I GREATER N-2 AND J NOT EQUAL 1 DISPLAY OUT-LINE.
 1360      ADD 2 TO I.
/*
//COB.SYSLIB   DD DSNAME=SYS1.COBLIB,DISP=SHR
//GO.SYSLIN   DD
//            DD DSN=&&INIPRIME,DISP=(OLD,DELETE)
//GO.SYSOUT   DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)
//GO.SYSIN    DD *
    2000
/*
//
