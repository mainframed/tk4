//PL3CMPGO JOB  DUMMY,DUMMY,CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1)
//STEP1 EXEC PL360CG
//STEPLIB DD DSN=SYS1.PL360LIB,DISP=SHR
//SYSIN   DD *
|01|  BEGIN  ARRAY 133 BYTE LINE = 133(" ");  |-- OUTPUT LINE AREA --|
|02|     ARRAY 256 INTEGER XX;  |-- SPACE FOR UP TO 16 BY 16 SQUARE --|
|03|     INTEGER SIZE, LIMIT;  |-- SQUARE SIZE AND SUB-SQUARE LIMIT --|
|04|     PROCEDURE MAGIC (R6);   |-- MAGIC SQUARE GENERATOR --|
|05|     BEGIN SHORT INTEGER NSQR;  |-- CURRENT SQUARE SIZE --|
|06|        INTEGER REGISTER N SYN R0, I SYN R1, J SYN R2,
|07|                         X SYN R3, IJ SYN R4, K SYN R5;
|08|        NSQR := N;  I := N * NSQR;  NSQR := I;
|09|        I := 1 + N SHRL 1;  J := N;
|10|        FOR K := 1 STEP 1 UNTIL NSQR DO
|11|        BEGIN  IJ := I SHLL 4 + J SHLL 2;
|12|           X := XX(IJ-68);  IF X ~= 0 THEN
|13|           BEGIN I := I - 1;  J := J - 2;
|14|              IF I <= 0 THEN I := I + N;
|15|              IF J <= 0 THEN J := J + N;
|16|              IJ := I SHLL 4 + J SHLL 2;
|17|           END;  XX(IJ-68) := K;  I := I + 1;
|18|           IF I > N THEN I := I - N;
|19|           J := J + 1;  IF J > N THEN J := J - N;
|20|        END;
|21|     END;
|22|
|23|  |-- MAIN PROGRAM CODE STARTS HERE --|
|24|     R0 := 15 =: SIZE;   |-- ESTABLISH INITIAL 15 BY 15 --|
|25|     WHILE R0 > 1 DO  |-- MAIN LOOP FOR SQUARE GENERATION --|
|26|     BEGIN  R1 := 16 - SIZE SHLA 2 =: LIMIT;
|27|        XX := 0;  XX(4/256) := XX;     |-- ZERO OUT --|
|28|        XX(260/256) := XX;             |-- THE WORK --|
|29|        XX(516/256) := XX;             |--  SPACE.  --|
|30|        XX(772/252) := XX;
|31|        R0 := SIZE;  MAGIC;   |-- FORM MAGIC SQUARE --|
|32|        R2 := 1;  R4 := R4-R4;  R7 := R4;  R3 := 5;
|33|        R6 := SIZE;  WHILE R4 < R6 DO  |-- OUTPUT LINES --|
|34|        BEGIN  R1 := @LINE;  R5 := R5-R5;  WHILE R5 < R6 DO
|35|           BEGIN R0 := XX(R7);  VALTOBCD;  R5 := @B5(1);
|36|              R7 := @B7(4);  R1 := @B1(R3);
|37|           END;  R0 := @LINE;  WRITE;  R7 := R7 + LIMIT;
|38|           R4 := @B4(1);  |-- BUMP LINE COUNTER --|
|39|        END;  LINE := " ";  LINE(1/132) := LINE;
|40|        R0 := @LINE;  WRITE;  |-- WRITE BLANK LINE --|
|41|        R0 := SIZE - 2 =: SIZE;  |-- REDUCE SIZE BY 2 --|
|42|     END;  |-- OF MAIN WHILE LOOP --|
|43|  END.
/*
//