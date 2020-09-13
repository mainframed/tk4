//PRIMFORG JOB (FORTRAN),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=9000K,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMFORG)
//*
//* Desc: Sieve of Eratosthenes programmed in FORTRAN,
//*       compiled using the IBM OS/360 FORTRAN G Level 21 compiler.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//********************************************************************
//PRIMES    EXEC FORTGCLD,PARM.GO='SIZE=9000000'
//FORT.SYSIN DD *
C /*-----------------------------------------------------------------*/
C /*   Sieve of Eratosthenes.                                        */
C /*-----------------------------------------------------------------*/
C
C /*-----------------------------------------------------------------*/
C /*   Formats for output.                                           */
C /*-----------------------------------------------------------------*/
3     FORMAT (' ')
4     FORMAT (  3X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7,
     11X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7, 1X, I7, 1X
     1, I7, 1X, I7, 1X, I7)
5     FORMAT (' Sieve of Eratosthenes generated using OS/360 FORTRAN G L
     1evel 21')
6     FORMAT (' Upper limit of test range = ', I12)
7     FORMAT (' Number of primes in range = ', I12)
8     FORMAT (I7)
993   FORMAT (' DEBUG: marking as non prime: ', I4)
994   FORMAT (' DEBUG: starting p=', I4, '    j=', I4)
C
C /*-----------------------------------------------------------------*/
C /*   Define array of flags, one for each integer in the range      */
C /*   we will test.  If the flag is on, the corresponding           */
C /*   number is prime.  If it's off, the number is not prime.       */
C /*   We will initialize all the flags to on (assuming every        */
C /*   number is prime) and turn them off as we determine the        */
C /*   corresponding number is not prime.                            */
C /*-----------------------------------------------------------------*/
      LOGICAL*1 FLAGS(5000002)
C
C /*-----------------------------------------------------------------*/
C /*   The PRIME array will hold all the prime numbers we have       */
C /*   identified, and CPRIME will contain the number of primes      */
C /*   we've found.                                                  */
C /*-----------------------------------------------------------------*/
      INTEGER*4 PRIME(350000)
      INTEGER*4 CPRIME
C
C /*-----------------------------------------------------------------*/
C /*   J is a loop counter and work variable.                        */
C /*-----------------------------------------------------------------*/
      INTEGER*4 J
C
C /*-----------------------------------------------------------------*/
C /*   K is the step amount for crossing out prime multiples         */
C /*-----------------------------------------------------------------*/
      INTEGER*4 K
C
C /*-----------------------------------------------------------------*/
C /*   P is the number that we've most recently determined           */
C /*   definitely to be prime.                                       */
C /*-----------------------------------------------------------------*/
      INTEGER*4 P
C
C /*-----------------------------------------------------------------*/
C /*   The DEBUG flag is set to TRUE if debugging messages are to    */
C /*   be issued and FALSE otherwise.                                */
C /*-----------------------------------------------------------------*/
      LOGICAL*1 DEBUG
C
C /*-----------------------------------------------------------------*/
C /*   LIMIT sets the upper bound of the range of numbers we         */
C /*   will test.                                                    */
C /*-----------------------------------------------------------------*/
      INTEGER*4 LIMIT
C
C /*-----------------------------------------------------------------*/
C /*   REPEAT is the number of times that the entire prime           */
C /*   generation process is to be repeated, and is useful           */
C /*   for benchmarking (otherwise it should be 1).                  */
C /*-----------------------------------------------------------------*/
      INTEGER*4 REPEAT
C
C /*-----------------------------------------------------------------*/
C /*   Initialize LIMIT, DEBUG and REPEAT.                           */
C /*-----------------------------------------------------------------*/
      READ (5, 8) LIMIT
C     DEBUG = .TRUE.
      DEBUG = .FALSE.
      REPEAT = 1
C
C *--------------------------------------------------------------*
C *    THIS IS THE TOP OF THE LOOP FOR BENCHMARK TESTING.
C *--------------------------------------------------------------*
100   CONTINUE
      REPEAT = REPEAT - 1
      IF (REPEAT .LT. 0) GO TO 999
C
C /*-----------------------------------------------------------------*/
C /*   Initialize all flags to on.  We optimistically assume         */
C /*   all numbers are prime, and will subsequently turn flags       */
C /*   off as reality sets in.                                       */
C /*-----------------------------------------------------------------*/
      DO 200 J = 3, LIMIT, 2
        FLAGS(J) = .TRUE.
200   CONTINUE
C
C /*-----------------------------------------------------------------*/
C /*   The first prime number is 3, the 2 is handled manually        */
C /*-----------------------------------------------------------------*/
      P = 3
C
C  /*-----------------------------------------------------------------*/
C  /*   Start of the main loop.  P is the prime number we're          */
C  /*   currently working on.  If P*P is greater than the limit       */
C  /*   value, we're done (all the numbers between P and the limit    */
C  /*   inclusive have already been marked appropriately).  Any       */
C  /*   non-prime less than P*P has also already been marked          */
C  /*   appropriately, so we will start this pass marking with        */
C  /*   P*P (which we will call J).                                   */
C  /*-----------------------------------------------------------------*/
300   CONTINUE
      J = P * P
      K = 2 * P
      IF (J .GE. LIMIT) GO TO 700
        IF (.NOT. DEBUG) GO TO 400
          WRITE (6, 994) P, J
C
C /*-----------------------------------------------------------------*/
C /*   By definition, all multiples of prime number P are not        */
C /*   prime.  Turn off the flags for the multiples of P to          */
C /*   mark them as non-prime. Note: Even numbers are skipped.       */
C /*-----------------------------------------------------------------*/
400   CONTINUE
        IF (J .GT. LIMIT) GO TO 500
        IF (.NOT. DEBUG) GO TO 420
          WRITE (6, 993) J
420     FLAGS(J) = .FALSE.
        J = J + K
      GO TO 400
C
C /*-----------------------------------------------------------------*/
C /*   Done marking all multiples of J as not prime.  Find the       */
C /*   next prime number after J, set it to P and loop back to       */
C /*   process it. Note: Even numbers are skipped.                   */
C /*-----------------------------------------------------------------*/
500   CONTINUE
        P = P + 2
        IF (FLAGS(P)) GO TO 600
      GO TO 500
C
C /*-----------------------------------------------------------------*/
C /*   Bottom of the main loop.                                      */
C /*-----------------------------------------------------------------*/
600   CONTINUE
      GO TO 300
C
C /*-----------------------------------------------------------------*/
C /*   Bottom of the benchmark loop.                                 */
C /*-----------------------------------------------------------------*/
700   CONTINUE
      GO TO 100
999   CONTINUE
C
C /*-----------------------------------------------------------------*/
C /*   Set the prime numbers we have found in the PRIME array.       */
C /*-----------------------------------------------------------------*/
      CPRIME = 1
      PRIME(CPRIME) = 2
      DO 800 J = 3, LIMIT, 2
        IF (.NOT. FLAGS(J)) GO TO 800
          CPRIME = CPRIME + 1
          PRIME(CPRIME) = J
800   CONTINUE
C
C /*-----------------------------------------------------------------*/
C /*   Display the results.                                          */
C /*-----------------------------------------------------------------*/
      WRITE (6, 3)
      WRITE (6, 5)
      WRITE (6, 6) LIMIT
      WRITE (6, 7) CPRIME
      WRITE (6, 3)
      WRITE (6, 4) (PRIME(J), J = 1, CPRIME)
      WRITE (6, 3)
C
C /*-----------------------------------------------------------------*/
C /*   End of program.                                               */
C /*-----------------------------------------------------------------*/
      STOP
      END
/*
//GO.FT06F001 DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=166,BLKSIZE=16600)
//GO.SYSIN DD *
   2000
/*
//
