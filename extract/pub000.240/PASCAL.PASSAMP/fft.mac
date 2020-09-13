(*$L+,C+,M-,D-*)
PROGRAM OSCAR(OUTPUT) ;

(* FAST FOURIER TRANSFER PROGRAM AFTER OSCAR BUENMAN, S. HAZEGHI. *)

CONST TWO_K = 1024 ;  TWO_K_2 = 513  ;  TWO_TO_15 = 32768 ;

TYPE COMPLEX = RECORD  RP: REAL ;  IP: REAL  END ;
     C_K_ARRAY = ARRAY [1..TWO_K] OF COMPLEX ;
     C_K_2_ARRAY = ARRAY [1..TWO_K_2] OF COMPLEX ;
     ALPHA = ARRAY [1..8] OF CHAR ;

VAR
     SEED, I: INTEGER ;
     Z, W : C_K_ARRAY ;
     E    : C_K_2_ARRAY ;

FUNCTION UNIFORM_10_10 : REAL ;
    VAR T : INTEGER ;
         BEGIN
         SEED := (14159269*SEED+231818041) MOD TWO_TO_15 ;
         UNIFORM_10_10 := 20.0*SEED/TWO_TO_15 - 10.0 ;
         END (* UNIFORM *) ;

PROCEDURE EXPTAB(N: INTEGER; VAR E: C_K_2_ARRAY) ;

    VAR  H: ARRAY [1..13] OF REAL ;
         HT: ARRAY ['A'..'9'] OF  0..15 ;
         I, J, K, L, M: INTEGER ;
         C : CHAR ;

    FUNCTION Z(HEX_STR: ALPHA): REAL ;
         VAR T: REAL ;  I: INTEGER ;
              BEGIN  T := 0.0;
              FOR I := 8 DOWNTO 2 DO T := HT[HEX_STR[I]]+T/16.0 ;
              Z := T
              END ;

         BEGIN (* EXPTAB *)
         FOR C := 'A' TO 'F' DO HT[C] := ORD(C)-ORD('A')+10 ;
         FOR C := '0' TO '9' DO HT[C] := ORD(C)-ORD('0') ;
         H[1] := Z('40B504F3'); H[2] := Z('408A8BD4') ;
         H[3] := Z('408281F7'); H[4] := Z('40809E8D') ;
         H[5] := Z('40802785'); H[6] := Z('408009DF') ;
         H[7] := Z('40800278'); H[8] := Z('4080009E');
         H[9] := Z('40800027'); H[10] := Z('4080000A');
         H[11] := Z('40800002'); H[12] := Z('40800001');
         H[13] := Z('40800000');
         M := N DIV 2 ;  L := M DIV 2 ;  J := 1 ;
         E[1].RP := 1.0 ;  E[1].IP := 0.0; E[L+1].RP := 0.0;
         E[L+1].IP := 1.0 ;  E[M+1].RP := -1.0 ; E[M+1].IP := 0.0 ;

              REPEAT I := L DIV 2 ;  K := I ;

                   REPEAT
                   E[K+1].RP := H[J]*(E[K+I+1].RP+E[K-I+1].RP) ;
                   E[K+1].IP := H[J]*(E[K+I+1].IP+E[K-I+1].IP) ;
                   K := K+L ;
                   UNTIL K > M ;

              IF J > 12 THEN J := 13  ELSE J := J+1 ;
              L := I ;
              UNTIL L <= 1 ;

         END (* EXPTAB *) ;

PROCEDURE FFT( N: INTEGER ;VAR Z, W: C_K_ARRAY ;
              VAR E: C_K_2_ARRAY ; SQRINV: REAL) ;

    VAR  I, J, K, L, M: INTEGER ;

         BEGIN  M := N DIV 2 ;  L := 1 ;

              REPEAT  K := 0 ;  J := L ;  I := 1 ;

                   REPEAT

                        REPEAT
                        W[I+K].RP := Z[I].RP+Z[M+I].RP ;
                        W[I+K].IP := Z[I].IP+Z[M+I].IP ;
                        W[I+J].RP := E[K+1].RP*(Z[I].RP-Z[I+M].RP)
                                     -E[K+1].IP*(Z[I].IP-Z[I+M].IP) ;
                        W[I+J].IP := E[K+1].RP*(Z[I].IP-Z[I+M].IP)
                                     +E[K+1].IP*(Z[I].RP-Z[I+M].RP) ;
                        I := I+1 ;
                        UNTIL I > J ;

                   K := J ;  J := K+L ;
                   UNTIL J > M ;

              Z := W ; (*FOR I := 1 TO N DO  Z[I] := W[I]  ;*)
              L := L+L ;
              UNTIL L > M ;

         FOR I := 1 TO N DO

              BEGIN
              Z[I].RP := SQRINV*Z[I].RP ;  Z[I].IP := -SQRINV*Z[I].IP
              END ;

         END ;

PROCEDURE PRINT_COMPLEX ;

    VAR I, J: INTEGER ;

         BEGIN  WRITELN() ;  I := 1 ;  J := 0 ;

              REPEAT  J := J+1 ;
              WRITE('    ',Z[I].RP:10,'  ',Z[I].IP:10) ;
              IF (J MOD 4) = 0 THEN WRITELN() ;
              I := I+17 ;
              UNTIL I > TWO_K ;

         WRITELN() ;
         END ;

    BEGIN (* OSCAR *)

    EXPTAB(TWO_K,E) ;
    SEED := 12345 ;
    FOR I := 1 TO TWO_K DO

         BEGIN
         Z[I].RP := UNIFORM_10_10 ;  Z[I].IP := UNIFORM_10_10 ;
         END ;

    PRINT_COMPLEX ;
    FFT(TWO_K,Z,W,E,SQRT(1.0/TWO_K)) ;  PRINT_COMPLEX ;
    FFT(TWO_K,Z,W,E,SQRT(1.0/TWO_K)) ;  PRINT_COMPLEX ;
    END (* OSCAR *) .
