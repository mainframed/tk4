(*$N+,D-****************************************************************
*                                                                      *
*                                                                      *
*   A LINE EDITOR FOR PASCAL                                           *
*                                                                      *
*       The EDITOR program is a simple text editor that can  insert,   *
*   delete and replace entire lines in a file. PRD is the file to be   *
*   edited,  INPUT  is  the  file  containing  editor  commands. The   *
*   resulting edited file is transmitted to the PRR  file.  Messages   *
*   and a summary of the changes are printed on the OUTPUT file.       *
*       The INPUT file consists of commands and cards to be inserted   *
*   into the PRD  file.  Commands  are  distinguished  by  having  a   *
*   percent  character  in  column  one. Cards that do not have this   *
*   character in column one are automatically inserted.                *
*       There are only four commands. Three of the commands have  an   *
*   operand  consisting  of an arbitrary string of characters. These   *
*   text string operands are "matched" against cards read  from  the   *
*   PRD  file.  The  definition  of  "match" will be given after the   *
*   commands are explained.                                            *
*                                                                      *
*   Find Line Command: %FL <text>                                      *
*       Cards are copied from the PRD file to the PRR  file,  up  to   *
*   and including the first card that "matches" <text>.                *
*                                                                      *
*   Replace Line Command: %RL <text>                                   *
*       Cards are copied fom the PRD file to the PRR file, up to but   *
*   not including the first card that "matches" <text>. That is, the   *
*   card that matches is effectively deleted.                          *
*                                                                      *
*   Delete Lines Command: %DL <text>                                   *
*       Cards are read from the PRD file, up to  and  including  the   *
*   first  card  that  "matches" <text>. These cards are effectively   *
*   deleted because they are not passed on to the PRR file.            *
*                                                                      *
*   End of Editing Command: %END                                       *
*       All remaining cards in the PRD file are copied  to  the  PRR   *
*   file.                                                              *
*                                                                      *
*   The <text> operand of a command "matches" a card read  from  PRD   *
*   if that card begins with the exact same character sequence given   *
*   in  <text>.  Blanks  are  totally  ignored,  in  both the <text>   *
*   operand  and  the  PRD  card,  when   making   the   comparison.   *
*   Furthermore,  some  character  equivalences  are  acceptable (in   *
*   case the INPUT file is entered  from  a  device  that  does  not   *
*   support the special characters). The equivalences are:             *
*       Upper-case letters in INPUT match corresponding                *
*                     lower-case letters in PRD                        *
*       "(/" in INPUT matches "[" (left square bracket) in PRD         *
*       "/)" in INPUT matches "]" (right square bracket) in PRD        *
*       "(*" in INPUT matches "¯" (left brace) in PRD                  *
*       "*)" in INPUT matches "ò" (right brace) in PRD                 *
*       "" (i.e. nothing) in INPUT matches "#" in PRD                  *
*   It should be noted that these equivalences are defined  to  work   *
*   in one direction only.  That is, a left square bracket in a text   *
*   operand will not match "(/" occurring  in  the  PRD  file.   The   *
*   meaning  of the last equivalence above is that the "#" character   *
*   in the PRD file is ignored if it does not match  a  "#"  in  the   *
*   <text> operand.                                                    *
*       It is an error if no card is found in  PRD  that  matches  a   *
*   <text>  operand. The EDITOR program will print a warning message   *
*   and return a non-zero return code to signal this  event.  It  is   *
*   mandatory  that  the  last  card  in  the  INPUT  file be a %END   *
*   command.                                                           *
*                                                                      *
*         An Example Editing Session                                   *
*                                                                      *
*   1. The Editing Commands in the INPUT file:                         *
*                                                                      *
*       %FL I := I                                                     *
*          J := J + 1;                                                 *
*          K := K + 1;                                                 *
*       %RL A(/K                                                       *
*          A(/K/) := CHR(K);                                           *
*       %FL WRI                                                        *
*       %FL WRI                                                        *
*       %DL CALL                                                       *
*          WRITELN ( 'A3 =', A(/K/) );                                 *
*          EXIT( 10 );                                                 *
*       %END                                                           *
*                                                                      *
*   2. The Contents of the PRD File:                                   *
*                                                                      *
*       PROGRAM NONSENSE( OUTPUT );                                    *
*       VAR I,J,K: INTEGER; A: ARRAY[1..3] OF CHAR;                    *
*       BEGIN                                                          *
*          I := 0; J := 1; K := 2;                                     *
*          I := I + 1;                                                 *
*          A[I] := CHR(I);                                             *
*          A[J] *= CHR(J);                                             *
*          A[K] *= ORD(K);                                             *
*          WRITELN( 'A1 =', A[1] );                                    *
*          WRITELN( 'A2 =', A[2] );                                    *
*          WRITELN( 'A3 =', A[3] );                                    *
*          CALL EXIT(10);                                              *
*       END.                                                           *
*                                                                      *
*   3. Resulting Output to PRR File:                                   *
*                                                                      *
*       PROGRAM NONSENSE( OUTPUT );                                    *
*       VAR I,J,K: INTEGER; A: ARRAY[1..3] OF CHAR;                    *
*       BEGIN                                                          *
*          I := 0; J := 1; K := 2;                                     *
*          I := I + 1;                                                 *
*          J := J + 1;                                                 *
*          K := K + 1;                                                 *
*          A[I] := CHR(I);                                             *
*          A[J] := CHR(J);                                             *
*          A(/K/) := CHR(K);                                           *
*          WRITELN( 'A1 =', A[1] );                                    *
*          WRITELN( 'A2 =', A[2] );                                    *
*          WRITELN( 'A3 =', A(/K/) );                                  *
*          EXIT( 10 );                                                 *
*       END.                                                           *
*                                                                      *
*   Comments:                                                          *
*       As can be seen in the example, %FL is used to search through   *
*   the PRD file. When there are many lines in PRD that  begin  with   *
*   similar text, two or more %FL commands can be used successively.   *
*   Generally,  %FL  is used to locate a position at which cards are   *
*   to be inserted or from which lines are to be deleted.              *
*       %RL is actually a redundant command  -  its  effect  can  be   *
*   obtained   with  %FL  and  %DL  commands.  However  it  is  most   *
*   convenient when a single line in PRD is to be deleted or  to  be   *
*   replaced  by  one  or  more  cards from INPUT. It should also be   *
*   apparent from the command descriptions that the commands must be   *
*   presented in  the  correct  order.  I.e.,  all  the  editing  is   *
*   performed in a single pass through PRD.                            *
*                                                                      *
*                                                                      *
*                                      R. Nigel Horspool               *
*                                                                      *
*                                      School of Computer Science      *
*                                      McGill University               *
*                                                                      *
*                                                                      *
***********************************************************************)


PROGRAM EDITOR(INPUT,OUTPUT,PRD,PRR);
CONST   CARDLEN = 80;
        CONTROL = '%';

TYPE    CARD = ARRAY(/ 1 .. CARDLEN /) OF CHAR;
        CHAR_TYPE = (NULL,LOWER_CASE,LSQ,RSQ,LBRACE,RBRACE,SHARP);

VAR     SOURCE, EDITS : CARD;
        CLASS :         ARRAY(/CHAR/) OF CHAR_TYPE;
        EOF_OK        : BOOLEAN;
        ERRS, INNUM, OUTNUM, PATLEN : INTEGER;

FUNCTION MATCH: BOOLEAN;
  LABEL 10;
  VAR   IX1, IX2: INTEGER;
        CH1, CH2: CHAR;
  BEGIN
    MATCH := FALSE;  IX1 := 1;  IX2 := 4;
    REPEAT
       CH1 := SOURCE(/IX1/);  CH2 := EDITS(/IX2/);
       IF CH2 = ' ' THEN IX2 := IX2 + 1
       ELSE IF CH1 = ' ' THEN IX1 := IX1 + 1
       ELSE BEGIN
          IF CH1 <> CH2 THEN
             CASE CLASS(/CH1/) OF
    LOWER_CASE:  IF (ORD(CH2)-ORD(CH1)) <> 64 THEN GOTO 10;
    LSQ:         IF CH2 <> '(' THEN GOTO 10 ELSE IX2 := IX2 + 1;
    RSQ:         IF CH2 <> '/' THEN GOTO 10 ELSE IX2 := IX2 + 1;
    LBRACE:      IF CH2 <> '(' THEN GOTO 10 ELSE IX2 := IX2 + 1;
    RBRACE:      IF CH2 <> '*' THEN GOTO 10 ELSE IX2 := IX2 + 1;
    SHARP:       IX2 := IX2 - 1;
    NULL:        GOTO 10
             END;
          IX1 := IX1 + 1;  IX2 := IX2 + 1;
       END;
    UNTIL (IX1 > CARDLEN) OR (IX2 > PATLEN);
    IF IX2 > PATLEN THEN MATCH := TRUE;
10:
  END (* MATCH *) ;

PROCEDURE INITIALIZE;
VAR C : CHAR;
BEGIN
   FOR C := CHR(0) TO CHR(255) DO CLASS(/C/) := NULL;
   FOR C := 'a' TO 'i' DO CLASS(/C/) := LOWER_CASE;
   FOR C := 'j' TO 'r' DO CLASS(/C/) := LOWER_CASE;
   FOR C := 's' to 'z' DO CLASS(/C/) := LOWER_CASE;
   CLASS(/ CHR(173) /) := LSQ;     CLASS(/ CHR(189) /) := RSQ;
   CLASS(/ CHR(139) /) := LBRACE;  CLASS(/ CHR(155) /) := RBRACE;
   CLASS(/ '#' /) := SHARP;
END;

BEGIN
  ERRS := 0;  INNUM := 0;  OUTNUM := 0;  EOF_OK := FALSE;
  INITIALIZE;
  REPEAT
    READLN(INPUT,EDITS);
    IF EDITS(/1/) = CONTROL THEN
       BEGIN
          WRITELN();  WRITELN(' %% CONTROL CARD : ', EDITS );
          PATLEN := CARDLEN;
          WHILE EDITS(/PATLEN/) = ' ' DO PATLEN := PATLEN - 1;
          IF EDITS(/2/) = 'D' THEN  (* DL COMMAND *)
             REPEAT
                READLN(PRD,SOURCE);  INNUM := INNUM + 1;
                WRITELN(' -- DELETED  (',INNUM:5,') ------- ×',
                     SOURCE,'× --' );
             UNTIL MATCH OR EOF(PRD)
          ELSE IF EDITS(/2/) = 'F' THEN (* FL COMMAND *)
             REPEAT
                READLN(PRD,SOURCE);  INNUM := INNUM + 1;
                WRITE(PRR,SOURCE); OUTNUM := OUTNUM + 1;
             UNTIL MATCH OR EOF(PRD)
          ELSE IF EDITS(/2/) = 'R' THEN (* RL COMMAND *)
             BEGIN
                READLN(PRD,SOURCE);  INNUM := INNUM + 1;
                WHILE NOT MATCH AND NOT EOF(PRD) DO
                   BEGIN
                      WRITE(PRR,SOURCE);  OUTNUM := OUTNUM + 1;
                      READLN(PRD,SOURCE);   INNUM  := INNUM  + 1;
                   END;
                IF NOT EOF(PRD) THEN
                   WRITELN(' -- DELETED  (',INNUM:5,') ------- ×',
                           SOURCE,'× --');
            END
          ELSE IF EDITS(/2/) = 'E' THEN (* END COMMAND *)
             BEGIN
                REPEAT
                   READLN(PRD,SOURCE);  INNUM := INNUM + 1;
                   WRITE(PRR,SOURCE); OUTNUM := OUTNUM + 1;
                UNTIL EOF(PRD);
                EOF_OK := TRUE;
             END
          ELSE BEGIN
             WRITELN(' ***** BAD CONTROL CARD - IGNORED.');
             WRITELN();  ERRS := ERRS + 1;
          END
       END
    ELSE BEGIN  (* INSERTED CODE *)
       WRITE(PRR,EDITS);  OUTNUM := OUTNUM + 1;
       WRITELN(' ++ INSERTED +++++++ (',OUTNUM:5,') ×',EDITS,'× ++' );
    END;
  UNTIL EOF(PRD) OR EOF(INPUT);

  WRITELN();
  IF NOT EOF_OK THEN
     BEGIN
       IF EOF(PRD) THEN
          WRITELN(' ***** LINE PREFIX NOT FOUND IN SOURCE FILE');
       IF EOF(INPUT) THEN
          WRITELN(' ***** MISSING %END CARD IN EDIT FILE');
       ERRS := ERRS + 1;
     END;
  WRITELN;  WRITELN(' * EDITING FINISHED;', INNUM:7, ' CARDS INPUT;',
                     OUTNUM:7, ' CARDS OUTPUT.' );
  EXIT( ERRS );
END.
