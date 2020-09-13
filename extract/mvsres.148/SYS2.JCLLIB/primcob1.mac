//PRIMCOB1 JOB (COBOL),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMCOB1)
//*
//* Desc: Sieve of Eratosthenes programmed in COBOL.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed. Due to a COBOL
//*       implementation limitation a maximum limit
//*       of 32767 can be entered.
//*
//********************************************************************
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
  130 * //                                   o 32767 prime flags
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
  600      01 BLANK-LINE PIC X(160).
  610      01 OUT-INTEGER.
  620       02 SHOWIT PIC ZZZZZZZZ OCCURS 20.
  630      01 OUT REDEFINES OUT-INTEGER.
  640       02 OUT-LINE PIC X(160).
  650      01 PRIME-FLAGS.
  660       02 ISPRIME PIC 9 OCCURS 32767.
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
  840      PERFORM INIT-1 UNTIL I GREATER N.
  850 *
  860      MOVE 3 TO I.
  870      PERFORM CHECK-NUMBER UNTIL I GREATER SQRTN OR EQUAL SQRTN.
  880 *
  890      MOVE 3 TO I.
  900      MOVE 2 TO J.
  910      MOVE J TO SHOWIT (K).
  920      PERFORM PRINT UNTIL I GREATER N.
  930 *
  940      MOVE K TO SHOWIT (1).
  950      MOVE N TO SHOWIT (2).
  960      DISPLAY ' '.
  970      DISPLAY SHOWIT (1), ' primes up to ', SHOWIT (2), ' found.'.
  980      STOP RUN.
  990 **
 1000 **
 1010  INIT-1.
 1020      MOVE 1 TO ISPRIME (I).
 1030      ADD 2 TO I.
 1040 **
 1050 **
 1060  CHECK-NUMBER.
 1070      PERFORM ADVANCE UNTIL I GREATER THAN SQRTN OR EQUAL TO SQRT
 1080 -     N OR ISPRIME (I) EQUAL TO 1.
 1090      IF ISPRIME (I) EQUAL TO 1
 1100          ADD I I GIVING J
 1110          MULTIPLY I BY I GIVING PRODUCT
 1120          PERFORM CROSS-OUT UNTIL PRODUCT GREATER THAN N.
 1130      ADD 2 TO I.
 1140 **
 1150 **
 1160  ADVANCE.
 1170      ADD 2 TO I.
 1180 **
 1190 **
 1200  CROSS-OUT.
 1210      MOVE 0 TO ISPRIME (PRODUCT).
 1220      ADD J TO PRODUCT.
 1230 **
 1240 **
 1250  NEXT-SQUARE.
 1260      ADD 1 TO I.
 1270      MULTIPLY I BY I GIVING SQRTN.
 1280 **
 1290 **
 1300  PRINT.
 1310      IF ISPRIME (I) EQUAL TO 1
 1320          MOVE I TO SHOWIT (J)
 1330          ADD 1 TO K
 1340          ADD 1 TO J
 1350          IF J GREATER 20
 1360              DISPLAY OUT-LINE
 1370              MOVE BLANK-LINE TO OUT-LINE
 1380              MOVE 1 TO J.
 1390      IF I GREATER N-2 AND J NOT EQUAL 1 DISPLAY OUT-LINE.
 1400      ADD 2 TO I.
/*
//COB.SYSLIB   DD DSNAME=SYS1.COBLIB,DISP=SHR
//GO.SYSOUT   DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)
//GO.SYSIN    DD *
    2000
/*
//
