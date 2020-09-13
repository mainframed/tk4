//PRIMASM  JOB (BAL),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMASM)
//*
//* Desc: Sieve of Eratosthenes programmed in Basic Assembler Language
//*       All prime numbers up to the value entered via PARM.GO
//*       are computed.
//*
//********************************************************************
//PRIMES  EXEC ASMFCG,PARM.ASM=(OBJ,NODECK),MAC1='SYS2.MACLIB',
//             REGION.GO=128K,PARM.GO='/2000'
//ASM.SYSIN DD *
PRIMASM  TITLE 'Sieve of Eratosthenes: Find Prime Numbers'
***********************************************************************
***                                                                 ***
*** Program:  PRIMASM                                               ***
***                                                                 ***
*** Purpose:  Find all prime numbers up to a given limit            ***
***           using Eratothenes' sieve algorithm.                   ***
***                                                                 ***
*** Usage:    The following JCL is required to run PRIMASM:         ***
***                                                                 ***
***           //PRIMASM EXEC PGM=PRIMASM,REGION=<size>,PARM=<limit> ***
***           //STEPLIB  DD  DSN=<loadlib>,DISP=SHR                 ***
***           //SYSPRINT DD  SYSOUT=*                               ***
***                                                                 ***
***           The parameters are defined as follows:                ***
***                                                                 ***
***           <limit>   the largest number to sieve. All primes     ***
***                     up to this number will be found. If the     ***
***                     limit given is too high for the algorithm   ***
***                     to execute within the bounds of the         ***
***                     available virtual storage, <limit> will be  ***
***                     adjusted to fit into the given region. If   ***
***                     no PARM value is given, a default limit of  ***
***                     2000 will be used.                          ***
***                                                                 ***
***           <size>    the amount of virtual storage the program   ***
***                     is allowed to use. The program will always  ***
***                     allocate the maximum amount of storage      ***
***                     allowed by the REGION parameter. If no      ***
***                     REGION parameter is specified, results will ***
***                     be unpredictable.                           ***
***                                                                 ***
***           <loadlib> the load library containing the PRIMASM     ***
***                     program.                                    ***
***                                                                 ***
*** Function: 1. Allocate all virtual storage available and adjust  ***
***              the sieve limit if necessary. This storage is      ***
***              used as flags, where each bit indicates whether    ***
***              the odd number corresponding to the bit's position ***
***              is prime or not. Odd numbers are assigned to these ***
***              bits in sequence, i.e. numbers 1,3,5,7,9,11,13,15  ***
***              correspond to bits 0,1,2,3,4,5,6,7 and so forth.   ***
***                                                                 ***
***           2. Set all prime flags to one, except the first.      ***
***              The first flag corresponds to the number one,      ***
***              which isn't prime. Note that there don't exist     ***
***              flags for even numbers, because even numbers       ***
***              (except the two) are never prime.                  ***
***                                                                 ***
***           3. Run Eratothenes' sieve which will result in        ***
***              clearing the prime flags of all none prime numbers ***
***              up to the given limit.                             ***
***                                                                 ***
***           4. Print all numbers having their prime flag set to   ***
***              SYSPRINT. The "irregular" two is printed manually  ***
***              for the sake of completeness.                      ***
***                                                                 ***
***           5. Print a summary message indicating the number of   ***
***              primes found up to the given limit to SYSPRINT and ***
***              to the job log.                                    ***
***                                                                 ***
***           6. Release the allocated storage.                     ***
***                                                                 ***
***           7. Exit.                                              ***
***                                                                 ***
*** Updates:  2014/07/18 original implementation.                   ***
***           2014/07/21 eliminate even numbers from prime flags.   ***
***                                                                 ***
*** Author:   Juergen Winkelmann, ETH Zuerich.                      ***
***                                                                 ***
***********************************************************************
PRIMASM  CSECT
         SAVE  (14,12),,*       save registers
         LR    R12,R15          establish module addressability
         USING PRIMASM,R12      tell assembler of base
         LA    R2,SAVEA         chain ..
         ST    R13,4(,R2)         .. the ..
         ST    R2,8(,R13)           .. save ..
         LR    R13,R2                 .. areas
*
* Initialize sieve limit and virtual storage
*
         L     R2,0(,R1)        parameter list address
         LH    R1,0(,R2)        length of PARM field
         LTR   R1,R1            PARM field specified?
         BZ    NOPARM           no, use default sieve limit
         L     R3,HIGHLIM       maximum PARM allowed
         LA    R4,10            maximum PARM length allowed
         CR    R1,R4            maximum PARM length exceeded?
         BH    HIGHPARM         yes -> use maximum as sieve limit
         LA    R3,PARM+10       right justify ..
         SR    R3,R1              .. to 10 digits
         BCTR  R1,0             decrement for EXecute
         EX    R1,MOVEPARM      get PARM
         PACK  NUMDEC(8),PARM(10) pack PARM and ..
         CVB   R3,NUMDEC            .. convert to binary
HIGHPARM ST    R3,LIMIT         set sieve limit
NOPARM   OPEN  (SYSPRINT,OUTPUT) open SYSPRINT
         GETMAIN VU,LA=GETMAX,A=ISPRIME allocate all available storage
         L     R7,MAXMEM        storage amount obtained times 16 ..
         SLL   R7,4               .. is maximum sieve limit possible
         C     R7,LIMIT         does requested limit fit into storage?
         BNL   *+8              yes -> use requested limit
         ST    R7,LIMIT         no  -> use maximum possible
         L     R6,ISPRIME       address of storage obtained
         L     R8,LIMIT         sieve limit
         XR    R9,R9            clear R9 for modulo
         SRDL  R8,4             divide sieve limit by 16
         LR    R7,R8            amount of storage to be initialized
         LTR   R9,R9            sieve limit modulo 16 = 0?
         BZ    *+8              yes -> use computed storage amount
         LA    R7,1(,R7)        no  -> increment amount by one
         XR    R8,R8            clear R8 for MVCL
         L     R9,FF            get initialization pattern for MVCL
         MVCL  R6,R8            initialize prime indication flags
         L     R6,ISPRIME       start of prime indication flags
         MVI   0(R6),X'7F'      make one not prime
*
* Sieve of Eratosthenes
*
         L     R1,ISPRIME       address of prime flag array
         LA    R2,CROSSOUT      masks to cross out primes
         XR    R3,R3            clear for prime test EXecuted later
         LA    R4,PRIMFLGS      masks for prime test
         LA    R5,1             candidate bit offset \  sieve starts
         LR    R6,R1            candidate address     >      at
         LA    R7,3             candidate value      /     three
         LA    R14,2            incrementor for large numbers
SIEVE    LR    R9,R7            is square of ..
         MR    R8,R7              .. candidate value ..
         C     R9,LIMIT             .. higher than sieve limit?
         BH    PRNTPRIM         yes -> sieve complete, go print
         IC    R3,0(R5,R4)      is prime flag for ..
         EX    R3,TESTPRIM        .. this candidate set?
         BNO   SIEVENXT         no  -> check next candidate
CLRMULT  SLL   R7,1             only odd multiples need to be cleared
CLRMULTL LR    R10,R9           current prime multiple
         BCTR  R10,0            decrement for addressing
         SRL   R10,1            divide by two (address compression)
         SRDL  R10,3            divide by eight
         AR    R10,R1           address of prime multiple
         SRL   R11,29           bit offset of prime multiple
         IC    R3,0(R11,R2)     get cross out mask
         EX    R3,CLRPRIM       cross out prime multiple
         AR    R9,R7            is next odd prime multiple ..
         C     R9,LIMIT           .. not higher than sieve limit?
         BNH   CLRMULTL         yes -> go cross it out
         SRL   R7,1             restore candidate value
SIEVENXT AR    R7,R14           next please, skip even numbers
         LA    R5,1(,R5)        next bit position
         CH    R5,EIGHT         end of byte reached
         BL    SIEVE            no  -> check candidate
         LA    R5,0             yes -> reset candidate bit offset ..
         LA    R6,1(,R6)                 .. and increment to next byte
         B     SIEVE            go check it
*
* Print primes
*
PRNTPRIM LA    R5,1             candidate bit offset \  print starts
         LR    R6,R1            candidate address     >      at
         LA    R7,3             candidate value      /     three
         LA    R2,2             incrementor for large limits
         LA    R8,1             number of primes found, the two is ..
         LA    R10,1              .. pre set and ..
         LA    R9,PRNTLINE+11     .. pre printed
         XR    R11,R11          no lines printed on this page yet
         B     *+16             skip page initialization on first page
NEWLINE  MVC   CC(166),NL       new line
         LA    R9,PRNTLINE      current print position
         XR    R10,R10          no numbers printed on this line yet
         CH    R11,LPP          page full?
         BNE   CHKPRIME         no -> check next number
         XR    R11,R11          no lines printed on this page yet
         MVI   CC,C'1'          next line starts a new page
CHKPRIME C     R7,LIMIT         sieve limit reached?
         BH    LASTLINE         yes -> print last line
         IC    R3,0(R5,R4)      is prime flag for ..
         EX    R3,TESTPRIM        .. this candidate set?
         BNO   CHKNEXT          no  -> check next candidate
         LA    R8,1(,R8)        yes -> increment number of primes found
         CVD   R7,NUMDEC        convert prime to decimal
         MVC   0(11,R9),EDIT    get print format into print position
         ED    1(11,R9),NUMDEC+3 format prime
         LA    R10,1(,R10)      increment number of primes and ..
         LA    R9,11(,R9)         .. print position
         CH    R10,NPL          is current line filled up?
         BNE   CHKNEXT          no  -> check next candidate
         PUT   SYSPRINT,CC      yes -> print line
         LA    R11,1(,R11)      increment number of lines on this page
         LA    R15,NEWLINE      next loop initializes a new line
         B     *+8              skip adding to current line
CHKNEXT  LA    R15,CHKPRIME     next loop adds to current line
         AR    R7,R2            next please, skip even numbers
         LA    R5,1(,R5)        next bit position
         CH    R5,EIGHT         end of byte reached
         BLR   R15              no  -> check candidate
         LA    R5,0             yes -> reset candidate bit offset ..
         LA    R6,1(,R6)                 .. and increment to next byte
         BR    R15              go check it
LASTLINE LTR   R10,R10          not yet printed primes in this line?
         BZ    SUMMARY          no  -> print summary
         PUT   SYSPRINT,CC      yes -> print last primes
         MVC   CC(166),NL       new line
         LA    R11,1(,R11)      increment number of lines on this page
SUMMARY  CLI   CC,C'1'          new page already started?
         BE    PRINTSUM         yes -> print summary line
         LA    R11,1(,R11)      no  -> increment number of lines
         CH    R11,LPP          page almost full?
         BNL   *+12             yes -> start new page
         MVI   CC,C'0'          no  -> skip one line
         B     *+8              print summary
         MVI   CC,C'1'          start new page
PRINTSUM CVD   R8,NUMDEC        convert number of primes to decimal
         MVC   PRNTLINE(LSUMMARY),EDIT get summary line and formats
         ED    PRNTLINE+1(11),NUMDEC+3 format number of lines
         L     R8,LIMIT         get sieve limit
         CVD   R8,NUMDEC        convert to decimal
         ED    PRNTLINE+LIMITEBC+1(11),NUMDEC+3 format sieve limit
         PUT   SYSPRINT,CC      print number of primes and sieve limit
         MVC   TELLUSER(4),SUMWTOP get WTO prefix and suffix ..
         MVC   PRNTLINE+LSUMMARY(4),SUMWTOS .. around summary line
         WTO   MF=(E,TELLUSER)  print summary line in job log
*
* Cleanup and return
*
         FREEMAIN VU,A=ISPRIME  release storage
         CLOSE SYSPRINT         close printer
         L     R13,4(,R13)      caller's save area pointer
         RETURN (14,12),RC=0    restore registers and return
*
* Data area
*
SAVEA    DS    18F              save area
MOVEPARM MVC   0(1,R3),2(R2)    EXecuted to retrieve PARM field
TESTPRIM TM    0(R6),0          EXecuted to test for being prime
CLRPRIM  NI    0(R10),0         EXecuted to cross out a prime multiple
NUMDEC   DS    D                target for decimal conversion
HIGHLIM  DC    F'2147483647'    highest possible fullword value
LIMIT    DC    F'2000'          default sieve limit
FF       DC    X'FF000000'      prime flags initialization pattern
LPP      DC    H'64'            lines to print per page
NPL      DC    H'15'            prime numbers to print per line
EIGHT    DC    H'8'             used for loops and comparisons
PARM     DC    10C' '           PARM field goes here
PRIMFLGS DC    B'10000000'      .. the set      ..
         DC    B'01000000'        .. bit's        ..
         DC    B'00100000'          .. position     ..
         DC    B'00010000'            .. represents   ..
         DC    B'00001000'              .. a            ..
         DC    B'00000100'                .. potential    ..
         DC    B'00000010'                  .. prime        ..
         DC    B'00000001'                    .. number       ..
CROSSOUT DC    B'01111111'      .. masks        ..
         DC    B'10111111'        .. used         ..
         DC    B'11011111'          .. to           ..
         DC    B'11101111'            .. cross        ..
         DC    B'11110111'              .. out          ..
         DC    B'11111011'                .. none         ..
         DC    B'11111101'                  .. prime        ..
         DC    B'11111110'                    .. numbers      ..
         DS    0F
TELLUSER DS    H                WTO plist for summary message goes here
NL       DC    C' '             newline carriage control
CC       DC    C'1'             formfeed on first output line
PRNTLINE DC    10C' '           line to be printed ..
         DC    C'2'               .. the prime two is ..
         DC    154C' '            .. pre printed on initial line
         DC    C' '             filler to receive EDit garbage
SUMWTOP  DC    X'002D8000'      prefix for summary message WTO
SUMWTOS  DC    X'02000020'      suffix for summery message WTO
EDIT     DC    2C' ',9X'20'     EDit pattern to format 9 digits
         DC    C' primes up to' .. skeleton ..
LIMITEBC EQU   *-EDIT             .. for      ..
         DC    2C' ',9X'20'         .. summary  ..
         DC    C' found'              .. line     ..
LSUMMARY EQU   *-EDIT           summary line length
SYSPRINT DCB   DSORG=PS,MACRF=PM,DDNAME=SYSPRINT,                      X
               RECFM=FBA,LRECL=166,BLKSIZE=16600  DCB for SYSPRINT
GETMAX   DC    F'8'             GETMAIN plist to obtain maximum ..
         DC    X'00FFFFF8'        .. storage available in region
ISPRIME  DS    F                address of allocated storage
MAXMEM   DS    F                amount of storage allocated
         YREGS ,                register equates
         END   PRIMASM          end of PRIMASM
/*
//GO.SYSPRINT DD SYSOUT=*
//
