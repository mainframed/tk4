//PRIMALGO JOB (ALGOL),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMALGO)
//*
//* Desc: Sieve of Eratosthenes programmed in ALGOL.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//********************************************************************
//PRIMES   EXEC ALGOFCG,REGION.ALGOL=384K,REGION.GO=9000K
//ALGOL.SYSIN DD *
'BEGIN'
 'COMMENT'
 //////////////////////////////////////////////////////////
 // NAME: PETER M. MAURER
 // PROGRAM: SIEVE OF ERATOSTHENES
 // DUE: NEVER
 // LANGUAGE: ALGOL 60 ALA IBM 360
 //
 // Changes:
 //  - Juergen Winkelmann, 2014/07/12, Performance and Output
 //                                    Optimization
 //////////////////////////////////////////////////////////
 ;
    'COMMENT' DEFINE THE SIEVE DATA STRUCTURE ;
    'BOOLEAN' 'ARRAY' CANDIDATES(/0..8400000/);
    'INTEGER' I,J,K,LIMIT;
    'COMMENT' SET LINE-LENGTH=120,SET LINES-PER-PAGE=62,OPEN
    SYSACT(1,6,120);
    SYSACT(1,8,62);
    SYSACT(1,12,1);
    ININTEGER(0,LIMIT);
    'FOR' I := 3 'STEP' 2 'UNTIL' LIMIT 'DO'
    'BEGIN'
        'COMMENT' EVERYTHING IS POTENTIALLY PRIME
                  UNTIL PROVEN OTHERWISE ;
        CANDIDATES(/I/) := 'TRUE';
    'END';
    'COMMENT' START THE SIEVE WITH THE INTEGER 3 ;
    I := 3;
    K := 9;
    'FOR' I := I 'WHILE' K 'LESS' LIMIT 'DO'
    'BEGIN'
        'COMMENT' ADVANCE TO THE NEXT UN-CROSSED OUT. ;
        'COMMENT' THIS NUMBER MUST BE A PRIME;
        'FOR' I := I 'WHILE' K 'LESS' LIMIT
                            'AND' 'NOT' CANDIDATES(/I/) 'DO'
        'BEGIN'
            I := I+2;
            K := I*I;
        'END';
        'COMMENT' INSURE AGAINST RUNNING OFF THE END;
        'IF' K 'LESS' LIMIT 'THEN'
        'BEGIN'
            'COMMENT' CROSS OUT ALL MULTIPLES OF THE PRIME.;
            'FOR' K := K 'WHILE' K 'LESS' LIMIT 'DO'
            'BEGIN'
                CANDIDATES(/K/) := 'FALSE';
                K := K+I+I;
            'END';
            'COMMENT' ADVANCE TO THE NEXT CANDIDATE ;
            I := I+2;
            K := I*I;
            'END'
        'END';
        'COMMENT' ALL UNCROSSED OUT NUMBERS ARE PRIME;
        'COMMENT' PRINT ALL PRIMES ;
        J := 1;
        K := 1;
        OUTINTEGER(1,2);
        'FOR' I := 3 'STEP' 2 'UNTIL' LIMIT-1 'DO'
        'BEGIN'
        'IF' CANDIDATES(/I/) 'THEN'
        'BEGIN'
            J := J + 1;
            K := K + 1;
            OUTINTEGER(1,I);
           'IF' J 'EQUAL' 9 'THEN' J := 0;
        'END';
    'END';
    'IF' J 'NOTEQUAL' 0  'THEN' SYSACT(1,14,1);
    SYSACT(1,14,1);
    OUTINTEGER(1,K);
    OUTSTRING(1,'(' primes up to ')');
    OUTINTEGER(1,LIMIT);
    OUTSTRING(1,'(' found')');
    SYSACT(1,14,1);
'END'
/*
//GO.ALGLDD01 DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=121,BLKSIZE=12100)
//GO.SYSIN    DD *
2000
/*
//
