//PRIMPL1  JOB (PL1),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMPL1)
//*
//* Desc: Sieve of Eratosthenes programmed in PL/1.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//********************************************************************
//PRIMES   EXEC PL1LFCG,PARM.PL1L='LOAD,NODECK,OPT=02'
//PL1L.SYSLIN DD UNIT=SYSDA
//PL1L.SYSIN DD *
 ERATOS: PROC OPTIONS (MAIN) REORDER;

 DECLARE I BINARY FIXED (31);
 DECLARE J BINARY FIXED (31);
 DECLARE N BINARY FIXED (31);
 DECLARE SN BINARY FIXED (31);
 DECLARE P BINARY FIXED (31);
 DECLARE Q BINARY FIXED (31);

 DECLARE SQRT BUILTIN;

 DECLARE SYSIN FILE;
 DECLARE SYSPRINT FILE;

 GET LIST (N) FILE(SYSIN);
 SN = SQRT(N);

 P = 1 + N / 32767;
 IF (MOD(N,32767) = 0) THEN P = P - 1;

 BEGIN;

   DECLARE PRIMES(P,32767) BIT (1) ALIGNED;
   P = 1;
   Q = 1;
   DO I = 3 BY 2 TO N;
     Q = Q + 2;
     IF (Q > 32767) THEN DO;
       Q = Q - 32767;
       P = P + 1;
     END;
     PRIMES(P,Q) = '1'B;
   END;

   I = 3;

   DO WHILE(I <= SN);
     DO J = I ** 2 BY I * 2 TO N;
       P = 1 + J / 32767;
       Q = MOD(J,32767);
       IF (Q = 0) THEN DO;
         P = P - 1;
         Q = 32767;
       END;
       PRIMES(P,Q) = '0'B;
      END;

     P = 1 + (I+2) / 32767;
     Q = MOD((I+2),32767);
     IF (Q = 0) THEN DO;
       P = P - 1;
       Q = 32767;
     END;
     DO I = I + 2 BY 2 TO SN WHILE(PRIMES(P,Q) = '0'B);
       Q = Q + 2;
       IF (Q > 32767) THEN DO;
         Q = Q - 32767;
         P = P + 1;
       END;
     END;
   END;

   J = 1;
   P = 1;
   Q = 1;
   PUT EDIT (2) (F(8,0)) FILE(SYSPRINT);
   DO I = 3 BY 2 TO N;
     Q = Q + 2;
     IF (Q > 32767) THEN DO;
       Q = Q - 32767;
       P = P + 1;
     END;
     IF PRIMES(P,Q) THEN DO;
         PUT EDIT (I) (F(8,0)) FILE(SYSPRINT);
         J = J + 1;
       END;
   END;
   PUT SKIP (2) FILE(SYSPRINT);
   PUT EDIT (J,' primes up to ',N,' found') (F(8,0),A(14),F(8,0),A(6))
    FILE(SYSPRINT);
 END;
 END ERATOS;
/*
//GO.SYSPRINT DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)
//GO.SYSIN DD *
2000
/*
//
