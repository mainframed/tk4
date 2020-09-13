(* after a program published in Pascal News, DEW Jan. 79 *)

PROGRAM PRINTME(OUTPUT);

   TYPE ALPHA=ARRAY(/1..50/) OF CHAR;

   VAR  A: ARRAY(/1..31/) OF ALPHA;
        B: ARRAY(/1..10/) OF CHAR;
        I: INTEGER;


BEGIN

B(/ 1/):='''';
B(/ 2/):='A';
B(/ 3/):='B';
B(/ 4/):=' ';
B(/ 5/):=';';
B(/ 6/):='/';
B(/ 7/):=')';
B(/ 8/):='(';
B(/ 9/):=':';
B(/10/):='=';
A(/ 1/):='PROGRAM PRINTME(OUTPUT);                          ';
A(/ 2/):='                                                  ';
A(/ 3/):='   TYPE ALPHA=ARRAY(/1..50/) OF CHAR;             ';
A(/ 4/):='                                                  ';
A(/ 5/):='   VAR  A: ARRAY(/1..31/) OF ALPHA;               ';
A(/ 6/):='        B: ARRAY(/1..10/) OF CHAR;                ';
A(/ 7/):='        I: INTEGER;                               ';
A(/ 8/):='                                                  ';
A(/ 9/):='                                                  ';
A(/10/):='BEGIN                                             ';
A(/11/):='                                                  ';
A(/12/):='FOR I:=1 TO 11 DO WRITELN(OUTPUT,B(/4/),A(/I/));  ';
A(/13/):='                                                  ';
A(/14/):='I:=1;                                             ';
A(/15/):='WRITELN(OUTPUT,B(/4/),B(/3/),B(/8/),B(/6/),I:2,   ';
A(/16/):='       B(/6/),B(/7/),B(/9/),B(/10/),B(/1/),B(/1/),';
A(/17/):='       B(/1/),B(/1/),B(/5/) );                    ';
A(/18/):='                                                  ';
A(/19/):='FOR I:=2 TO 10 DO WRITELN(OUTPUT,B(/4/),B(/3/),   ';
A(/20/):='                  B(/8/),B(/6/),I:2,B(/6/),B(/7/),';
A(/21/):='                  B(/9/),B(/10/),B(/1/),B(/I/),   ';
A(/22/):='                  B(/1/),B(/5/) );                ';
A(/23/):='                                                  ';
A(/24/):='FOR I:=1 TO 31 DO WRITELN(OUTPUT,B(/4/),B(/2/),   ';
A(/25/):='                  B(/8/),B(/6/),I:2,B(/6/),B(/7/),';
A(/26/):='                  B(/9/),B(/10/),B(/1/),A(/I/),   ';
A(/27/):='                  B(/1/),B(/5/) );                ';
A(/28/):='                                                  ';
A(/29/):='FOR I:=11 TO 31 DO WRITELN(OUTPUT,B(/4/),A(/I/)); ';
A(/30/):='                                                  ';
A(/31/):='END.                                              ';

FOR I:=1 TO 11 DO WRITELN(OUTPUT,B(/4/),A(/I/));

I:=1;
WRITELN(OUTPUT,B(/4/),B(/3/),B(/8/),B(/6/),I:2,
       B(/6/),B(/7/),B(/9/),B(/10/),B(/1/),B(/1/),
       B(/1/),B(/1/),B(/5/) );

FOR I:=2 TO 10 DO WRITELN(OUTPUT,B(/4/),B(/3/),
                  B(/8/),B(/6/),I:2,B(/6/),B(/7/),
                  B(/9/),B(/10/),B(/1/),B(/I/),
                  B(/1/),B(/5/) );

FOR I:=1 TO 31 DO WRITELN(OUTPUT,B(/4/),B(/2/),
                  B(/8/),B(/6/),I:2,B(/6/),B(/7/),
                  B(/9/),B(/10/),B(/1/),A(/I/),
                  B(/1/),B(/5/) );

FOR I:=11 TO 31 DO WRITELN(OUTPUT,B(/4/),A(/I/));

END.
