//GREGSPY  JOB (S),G.PRICE,CLASS=A,COND=(0,NE),
//             MSGCLASS=X,NOTIFY=GREG
//* ********************************************************
//* *                                                      *
//* *      INSTALL THE 'SPY' TSO COMMAND                   *
//* *                                                      *
//* ********************************************************
//ASMLKD EXEC ASMFCL,MAC1='SYS1.AMODGEN',MAC2='MVSSRC.SYM101.F01',
//             PARM.ASM='OBJECT,NODECK,TERM,XREF(SHORT)',
//             PARM.LKED='LIST,MAP,NCAL,AC=1'
//ASM.SYSIN DD *
         LCLB  &USERSVC
         AIF   ('&SYSPARM' EQ 'SVC').SVC
&USERSVC SETB  0       USE INTERNAL READER WHEN NOT APF AUTHORIZED
         AGO   .GO
.SVC     ANOP
&USERSVC SETB  1       USE A USER SVC WHEN NOT APF AUTHORIZED
.GO      ANOP
         TITLE 'S P Y --  MVS CONSOLE SPY PROGRAM  --  VERSION 2.5'
***********************************************************************
*                                                                     *
*                                 S P Y                               *
*                                                                     *
*                               22/05/79                              *
*                                                                     *
*                       OPERATOR CONSOLE MONITOR                      *
*                                                                     *
*     THIS PROGRAM DISPLAYS ALL ACTIVE OPERATORS CONSOLES ON          *
*     A 3270 TSO TERMINAL. SINCE THIS BUFFER CAN BE 35 LINES LONG,    *
*     IT MUST BE DISPLAYED IN TWO 'PAGES'. VARIOUS CONTROL            *
*     COMMANDS ARE AVAILABLE AND ARE DESCRIBED BELOW.                 *
*                                                                     *
*     COMMAND      DESCRIPTION                                        *
*                                                                     *
*        ?         DISPLAYS HELP FOR SPY                              *
*        H         DISPLAYS HELP FOR SPY                              *
*        1         SHIFT TO DISPLAY MODE 1                            *
*        2         SHIFT TO DISPLAY MODE 2                            *
*        B         BYE; END THE PROGRAM                               *
*        E         END; END THE PROGRAM                               *
*        F         FREEZE DISPLAY ON THE CURRENT PAGE                 *
*        R         RELEASE DISPLAY; SHOW ALTERNATING PAGES            *
*        Wnn       AUTOMATICALLY REFRESH THE SCREEN                   *
*                  nn TIMES, THEN RETURN TO NORMAL MODE.              *
*                  IF nn IS NOT ENTERED, 30 ITERATIONS IS ASSUMED.    *
*                  IF NN = 0, TIMER WILL CONTINUE UNTIL INTERRUPT     *
*                  IS PRESSED.                                        *
*        Cnn       SWITCH DISPLAY TO SYSTEM CONSOLE nn                *
*                  IF nn IS NOT A VALID CONSOLE, '1' IS ASSUMED       *
*        Dnn       SET DELAY TIME BETWEEN REFRESHES TO nn TENTHS      *
*                  OF A SECOND.                                       *
*        Knn       ISSUE DELETE OPERATOR MESSAGE (DOM) FOR MESSAGE    *
*                  ON LINE NO. nn OF THIS CONSOLE.  (OF COURSE, THIS  *
*                  MESSAGE WILL REVERT TO LOW INTENSITY ON ALL        *
*                  CONSOLES ON WHICH IT APPEARS.) (USER MUST BE A VIP)*
*                  (NOTE THAT /K E,nn IS "INVALID FROM SUBSYSTEM      *
*                  CONSOLE".)                                         *
*        N         NOTIFY OPERATOR VIA ACTION MESSAGE (FOR VIPS)      *
*                                                                     *
*     PROGRAM FUNCTION KEY SUPPORT ADDED 08/10/82 WITH EXTRA HELP.    *
*     CHIMP CAN BE INVOKED WITH PFK 2/14.                             *
*                                                                     *
*     TERMINAL (IF APF AUTH), USERID, DATE AND TIME ADDED 26/08/83.   *
*                                                                     *
*     DISPLAY MODE 1 - PAGE 1 = TOP 22 LINES                          *
*                      PAGE 2 = BOTTOM 12 LINES                       *
*     DISPLAY MODE 2 - PAGE 1 = TOP 22 LINES                          *
*                      PAGE 2 = BOTTOM 22 LINES                       *
*                                                                     *
*     HITTING THE ATTENTION KEY WHILE IN TIMER MODE WILL CAUSE        *
*     THE TIMER TO BE RESET TO ZERO AND WAIT MODE TERMINATED.         *
*                                                                     *
*     SPY GIVES A TSO USER THE CAPABILITY TO ENTER SYSTEM AND JES     *
*     OPERATOR COMMANDS. THIS FACILITY IS PROTECTED BY A SIMPLE       *
*     3 CHARACTER PASSWORD (IN VARIABLE VIPWORD) TO PREVENT YOU       *
*     FROM ACCIDENTALLY ENTERING AN OPERATOR COMMAND. THE SYNTAX IS   *
*                                                                     *
*     JES COMMAND:  $...  ANY JES COMMAND ...                         *
*     OPER COMMAND: /...  ANY OPER COMMAND ...                        *
*     AOF COMMAND:  #...  ANY AOF COMMAND ...                         *
*                                                                     *
*     TYPING THE 3-LETTER VIP PASSWORD 'TOGGLES' THE VIP FLAG.        *
*     THE AUTHORIZATION LEVEL OF COMMANDS YOU CAN ISSUE DEPENDS ON    *
*     HOW YOUR INSTALLATION HAS SYSGENED ITS INTERNAL READERS.        *
*     ACCOUNT AUTHORIZED USERS DEFAULT TO VIP MODE UPON ENTRY.        *
*     THIS FACILITY WORKS BY DYNAMICALLY ALLOCATING AN INTERNAL       *
*     READER AND THROWING THE COMMAND THROUGH IT.                     *
*                                                                     *
*     MODIFIED ON 11/10/82 BY GP@SECV SO THAT WHEN AUTHORIZED,        *
*     COMMANDS ARE ISSUED THROUGH SVC 34 WHICH IS FASTER THAN INTRDR. *
*     MODIFIED ON 27/05/83 BY GP@SECV SO THAT WHEN NOT AUTHORIZED,    *
*     COMMANDS ARE ISSUED THROUGH SVC 241 WHICH ISSUES SVC 34.        *
*     MODIFIED ON 09/08/84 BY GP@SECV SO THAT SYSPARM CAN BE USED     *
*     TO DETERMINE UNAUTHORIZED COMMAND ISSUING MODE.                 *
*     MODIFIED ON 17/02/86 BY GP@SECV SO USER SVC 213 WHICH FLIPS     *
*     JSCBAUTH BIT IS USED, ALLOWING NORMAL SVC 34 PROCESSING.        *
*     LINK TO SWAP REMOVED.                                           *
*                                                                     *
*     MODEFLAG CONVENTION FOR ISSUING OPERATOR COMMANDS:              *
*                       *  ==>  SVC 34                                *
*                       +  ==>  SVC 34 - AUTHORIZED VIA SVC 213       *
*                       $  ==>  INTRDR                                *
*                                                                     *
*     THIS PROGRAM WILL PROBABLY REQUIRE BOTH THE SYS1.AMODGEN AND    *
*     SYS1.APVTMACS MACRO LIBRARIES TO ASSEMBLE PROPERLY.             *
*     SPY WAS DEVELOPED ON A 370/168 MVS RELEASE 3.7; IT WILL         *
*     PROBABLY *NOT* WORK ON ANYTHING BUT MVS...                      *
*                                                                     *
*                        STEVE LANGLEY                                *
*                        SOUTHERN CALIF. EDISON                       *
*                        ROSEMEAD, CALIF   91770                      *
*                        213-572-3521                                 *
*                                                                     *
*                                                                     *
***********************************************************************
         EJECT
R0       EQU   0
R1       EQU   1
R2       EQU   2
R3       EQU   3
R4       EQU   4
R5       EQU   5
R6       EQU   6
R7       EQU   7
R8       EQU   8
R9       EQU   9
R10      EQU   10
R11      EQU   11
R12      EQU   12
R13      EQU   13
R14      EQU   14
R15      EQU   15
         EJECT
SPY      CSECT
         B     100(R15)           BRANCH AROUND SAVE AREAS
         DC    CL9'SPY'           IDENTIFIER
         DC    CL9'&SYSDATE'
         DC    CL6'&SYSTIME'
SAVE     DC    18F'0'             SAVE AREA
         STM   R14,R12,12(R13)    SAVE REGISTERS
         LR    R12,R15            R12 = ADDR OF ENTRY POINT
         USING SPY,R12,R11        ADDRESABILITY TO CSECT
         LA    R11,SAVE           R11 = ADDR OF OUR SAVE AREA
         ST    R13,SAVE+4         SAVE POINTER TO CALLERS SAVE AREA
         ST    R11,8(R13)         SAVE PTR TO OUR SAVE AREA IN CALLER'S
         LR    R13,R11            R13 = ADDR OF OUR SAVE AREA
         LA    R11,4095(R12)      R11 WILL BE
         LA    R11,1(R11)         SECOND BASE REGISTER
         SPACE 3
***********************************************************************
*                                                                     *
*                       PROGRAM INITIALIZATION                        *
*                                                                     *
***********************************************************************
         EXTRACT MF=(E,EXTRPSCB)                                GP@SECV
         L     R1,ANSWER                                        GP@SECV
         USING PSCB,R1                                          GP@SECV
         TM    PSCBATR1,PSCBCTRL  OPERATOR PRIVILEGED TSO USER? GP@SECV
         BO    ACCTCHK            YES, CONTINUE                 GP@SECV
         TPUT  NOGOMSG,38         NO                            GP@SECV
         B     ALLDONE                                          GP@SECV
ANSWER   DC    F'0'               ADDRESS OF PSCB               GP@SECV
OKOK     DC    C'OKOK'            VIP PREVIOUSLY TEST DATA      GP@SECV
ACCTCHK  TM    PSCBATR1,PSCBACCT  ACCOUNT PRIVILEGED TSO USER?  GP@SECV
         BNO   OPEROK             NO, CHECK CHIMP CONNECTION    GP@SECV
         MVI   BADJUMP1+1,0       YES, ALLOWED TO ISSUE         GP@SECV
         MVI   BADJUMP2+1,0            AN OS RESET COMMAND      GP@SECV
         B     ISAVIP             AUTOMATIC VIP MODE            GP@SECV
OPEROK   C     R2,OKOK            CHECK CONTENTS OF R2          GP@SECV
         BNE   NOTVIP             HAS TO TYPE IN VIP WORD       GP@SECV
ISAVIP   MVI   VIPFLAG,X'FF'      VIP CAME FROM CHIMP FROM SPY  GP@SECV
NOTVIP   LA    R3,STAXLIST        R3 = ADDRESS OF STAX LIST MACRO
         STAX  ATTNEXIT,MF=(E,(3)) ATTN EXIT TRAP
         LA    R6,3270            GET VALUE FOR COMPARE         GP@SECV
         CR    R4,R6              DID WE COME FROM CHIMPNSE?    GP@SECV
         BNE   TSTAUTH            NO                            GP@SECV
         MVC   CHIMPSUF,=C'NSE'   YES, REMEMBER FOR XCTL        GP@SECV
TSTAUTH  TESTAUTH FCTN=1          APF AUTHORIZED?               GP@SECV
         USING PSA,0                                            GP@SECV
         L     R1,PSAAOLD         POINT TO ASCB                 GP@SECV
         USING ASCB,R1                                          GP@SECV
         ICM   R4,15,ASCBTSB      POINT TO TSB                  GP@SECV
         BZ    ALLDONE            NOT TIME SHARING USER SO EXIT GP@SECV
         USING TSB,R4                                           GP@SECV
         MVI   MODEFLAG,C'*'      INDICATE AUTHORITY            GP@SECV
         LTR   R15,R15                                          GP@SECV
         BZ    AC1                YES, ALLOWED TO USE SVC34     GP@SECV
         AIF   (&USERSVC EQ 1).GETRMID
         MVI   MODEFLAG,C'$'      NO, USE INTRDR FOR COMMANDS   GP@SECV
         MVC   TERMMARK,BLANKS    CAN'T GET VTAM TERMINAL NAME  GP@SECV
         B     AC0                                              GP@SECV
         AGO   .AC1
.GETRMID ANOP
         LA    R1,AUTHCHEK        POINT TO USER SVC PASSWORD    GP@SECV
         SVC   213  **USER SVC**  ALLOW MODESET FOR JOB STEP    GP@SECV
         MVI   MODEFLAG,C'+'      INDICATE USER SVC USAGE       GP@SECV
.AC1     ANOP
AC1      MODESET KEY=ZERO                                       GP@SECV
         MVC   TERMINAL,TSBTRMID  MOVE IN VTAM TERMINAL NAME    GP@SECV
         DROP  R4                                               GP@SECV
         MODESET KEY=NZERO                                      GP@SECV
AC0      DS    0H                                               GP@SECV
         L     R1,PSATOLD         FIND CURRENT TCB              GP@SECV
         USING TCB,R1                                           GP@SECV
         L     R1,TCBTIO          POINT TO TIOT                 GP@SECV
         DROP  R1                                               GP@SECV
         MVC   USERID,0(R1)       MOVE IN USERID                GP@SECV
         SPACE 2
         GTSIZE
         LTR   R0,R0              R0 = NUMBER OF LINES PER SCREEN
         BZ    HARDCOPY           IF NONZERO ASSUME A CRT IS IN USE
         SPACE
CRT      STH   R0,LPSCREEN        R0 = LINES PER SCREEN
         STH   R1,CPLINE          R1 = CHARACTERS PER LINE
         CH    R0,=H'24'          IS USER ON A 3277?
         BE    FLSCREEN           YES, JUST CONTINUE
         MVI   MOD4FLG,X'FF'      SET 3278-4 FLAG ON
         MVC   CMDCTRL2(3),R41C1  ROW 41, COL 1
         MVC   PHEADING(3),R42C1  ROW 42, COL 1
         MVC   R24C1(3),R43C1     ROW 43, COL 1
FLSCREEN STFSMODE ON,INITIAL=YES  TURN ON VTAM FULL SCREEN MODE
         B     BLDUCMS
         SPACE
HARDCOPY STSIZE SIZE=80           OTHERWISE, HARDCOPY; SET LSIZE=80
         MVI   CRTFLAG,X'00'      WE ARE USING A HARDCOPY
         MVC   CMDCTRL1(6),BLANKS ZAP OUT 3277 CNTRL CHARS
         MVC   CMDCTRL2(6),BLANKS ZAP OUT 3277 CNTRL CHARS
         MVC   PHEADING(6),BLANKS ZAP OUT 3277 CNTRL CHARS
         MVC   HELP(14),BLANKS    ZAP OUT 3277 CNTRL CHARS
         SPACE 3
***********************************************************************
*                                                                     *
*          BUILD A TABLE OF UCM ADDRESSES (ONE PER CONSOLE)           *
*                                                                     *
***********************************************************************
BLDUCMS  L     R4,16              R4 = ADDR OF CVT
         USING CVT,R4
         L     R4,CVTCUCB         R4 = ADDR OF 'CUCB' (UCM BASE)
         DROP  R4
         USING UCM,R4
         L     R5,UCMVEA          R5 = ADDR OF FIRST UCM ENTRY
         L     R6,UCMVEZ          R6 = LENGTH OF EACH UCM ENTRY
         L     R7,UCMVEL          R7 = ADDR OF LAST UCM ENTRY
         LA    R8,UCMTAB+4        R8 = ADDR OF UCMTAB
         LA    R9,UCMTABE         R9 = ADDR OF END OF UCMTAB
         XR    R10,R10            R10 = 0 (NUMBER OF VALID UCMS)
UCMLOOP  ST    R5,0(R8)           SAVE UCM ADDRESS IN UCMTAB
         LA    R10,1(R10)         R10 = R10 + 1  (ONE MORE UCM)
         LA    R8,4(R8)           R8 = ADDR OF NEXT UCMTAB ENTRY
         CR    R8,R9              DOES R8 POINT PAST END OF UCMTAB?
         BH    UCMDONE            YES; LEAVE LOOP
         AR    R5,R6              R5 = ADDR OF NEXT UCM ENTRY
         CR    R5,R7              DOES R5 POINT PAST UCM ENTRIES?
         BL    UCMLOOP            NOPE; KEEP GOING
UCMDONE  LA    R10,1(R10)         ALLOW FOR ONE NON-CRT CONSOLE GP@SECV
         STH   R10,NUMUCMS        SAVE NUMBER OF UCMS FOUND
         DROP  R4
         SPACE 3
***********************************************************************
*                                                                     *
*                            TOP OF LOOP                              *
*              LOCATE SCREEN BUFFER AND PREPARE TO TPUT               *
*                                                                     *
***********************************************************************
NEXTPAGE CLI   ATTNFLG,X'00'      WAS ATTN HIT?
         BE    NOATTN             NO
*                                 ATTENTION KEY HIT; PROCESS IT
         MVI   ATTNFLG,X'00'      YES, RESET FLAG
         MVC   TIME(3),BLANKS     BLANK OUT TIMER FIELD
         MVI   WAITFLG,X'00'      TURN OFF WAIT FLAG
         XC    CLOCK,CLOCK        SET TIMER TO 0
         STFSMODE ON              RESTORE VTAM FULL SCREEN MODE
NOATTN   EQU   *
         LA    R5,UCMTAB          R5 = ADDR OF UCMTAB
         L     R4,CONSOLE         R4 = CONSOLE TO BE DISPLAYED
         CH    R4,NUMUCMS         IS NUMBER TOO HIGH?
         BNH   GETUCM             NO, CONTINUE
         MVC   ERROR(26),ERRMSG1  CONSOLE NUMBER INVALID
RESETCN  L     R4,OLDCONS         RESET TO OLD CONSOLE
         ST    R4,CONSOLE         AND SAVE IT
GETUCM   SLL   R4,2               MULTIPLY BY 4
         LA    R5,0(R5,R4)        R5 = ADDR OF ADDR OF UCM
         L     R5,0(R5)           R5 = ADDR OF UCM
         USING UCMLIST,R5
         L     R6,UCMXB           R6 = ADDR OF RDCM
         USING DCMTSRT,R6
         LTR   R6,R6              IS THIS A GRAPHICS CONSOLE?
         BP    GRAPHICS           YES
         LA    R5,UCMTAB          R5 = ADDR OF UCMTAB
         MVC   ERROR(26),ERRMSG4  NON-GRAPHIC CONSOLE
         B     RESETCN            RESET THE CONSOLE NUMBER
         SPACE
GRAPHICS EQU   *
         MVC   CTYPE(28),BLANKS   BLANK OUT CONSOLE TYPE FIELD
         TM    UCMDISP1,UCMDISPA  IS THIS A MASTER CONSOLE?
         BNO   AUTH               NO
         MVC   MASTER(6),=CL6'MASTER' YES
AUTH     TM    UCMAUTHA,UCMAUTH1  IS THIS CONSOLE SYSTEM AUTHORIZED?
         BNO   AUTH1              NO
         MVC   SYS(3),=CL3'SYS'   YES
AUTH1    TM    UCMAUTHA,UCMAUTH2  IS IT I/O AUTHOZRIZED?
         BNO   AUTH2              NO
         MVC   IO(3),=CL3'I/O'    YES
AUTH2    TM    UCMAUTHA,UCMAUTH3  IS IT CONS AUTHORIZED?
         BNO   AUTHDONE           NO
         MVC   CONS(4),=CL4'CONS' YES
AUTHDONE EQU   *
         L     R7,UCMUCB          R7 = ADDR OF UCB
         MVC   UNIT(3),13(R7)     MOVE UNIT ADDR INTO LINE
         L     R7,DCMADTRN        R7 = ADDR OF TDCM
         USING STRTDCM,R7                                       GP@SECV
         SPACE
***********************************************************************
*                                                                     *
*                 FILLIN TRAILER AT BOTTOM OF SCREEN                  *
*                                                                     *
***********************************************************************
         MODESET KEY=ZERO                                       GP@P6
         L     R3,CONSOLE         LOAD THE CONSOLE NUMBER
         CVD   R3,WORK            CONVERT TO DECIMAL IN WORK
         MVC   SCRATCH(4),PATTERN MOVE IN EDIT PATTERN
         ED    SCRATCH(4),WORK+6  EDIT IN CONSOLE NUMBER
         MVC   CONNUM(2),SCRATCH+2 MOVE CONSOLE NUMBER INTO PLACE
         MVC   LASTLINE(79),DCMINPUT   MOVE IN INPUT BUFFER LINE
         MVI   MODE+1,C' '        BLANK OUT VIP INDICATOR
         CLI   VIPFLAG,X'FF'      IS THE VIP FLAG ON?
         BNE   CHKINTEG           NOPE
         MVC   MODE+1(1),MODEFLAG TURN ON VIP INDICATOR         GP@SECV
         SPACE 1
***********************************************************************
*                                                                     *
*                    CHECK FOR INTEGRATED CONSOLE                     *
*                                                                     *
*     IF THIS IS A INTEGRATED CONSOLE, CHECK IF THE USER HAS A        *
*     327X-2 OR THE LARGE-SCREEN 327X-4.                              *
*                                                                     *
***********************************************************************
CHKINTEG MVI   INTEGFLG,X'FF'     TURN ON INTEGRATED CONSOLE FLAG
*        TM    UCMDISP,UCMDISPH   IS THIS REALLY INTEGRATED CONSOLE?DCT
*        BO    CHKMODEL           YES                               DCT
         CLC   DCMMSGAL(2),=H'30' CHECK FOR 30-LINE 168 INTEG CONS  DCT
         BNL   CHKMODEL     YES                                     DCT
         MVI   INTEGFLG,X'00'     NO; TURN OFF INTEGRATED CONSOLE FLAG
         MVI   FREEZE,C'F'        FREEZE DISPLAY
         MVI   PAGE,C'1'          ON PAGE 1
         MVC   TPUTLEN(4),MOD2TPUT SET TPUT LENGTH FOR SHORT SCREEN
         B     MOD2               AND TREAT AS MOD2 FOR NOW
         SPACE 1
CHKMODEL CLI   MOD4FLG,X'FF'      IS THIS A 3278-4?
         BNE   MOD2               NO - MUST BE A MOD2
         MVI   FREEZE,C'F'        FREEZE DISPLAY
         MVI   PAGE,C'1'          ON PAGE 1
         MVC   TPUTLEN(4),MOD4TPUT SET LENGTH FOR FULL 3278-4 SCREEN
         L     R8,DCMASCRN        R8 = ADDR OF SCREEN BUFFER
         LA    R4,BUF             R4 = ADDR OF OUTPUT BUFFER
         LA    R5,M4BUFLEN        R5 = 3278-4 BUFFER LEN (35 LINES)
         LA    R9,M4BUFLEN        R9 = 3278-4 BUFFER LEN (35 LINES)
         B     MOVEBUFF
         SPACE 2
MOD2     CLI   PAGE,C'1'          ARE WE ON PAGE 1?
         BNE   ONTWO              NO, SO WE MUST BE ON 2
         CLI   FREEZE,C'F'        ARE WE FROZEN ON PAGE 1?
         BNE   PAGE2              NO, SO DISPLAY PAGE 2
         B     PAGE1              YES, SO DISPLAY PAGE 1
ONTWO    CLI   FREEZE,C'F'        ARE WE FROZEN ON PAGE 2?
         BE    PAGE2              YES, SO DISPLAY PAGE 2
PAGE1    MVI   PAGE,C'1'          PAGE = 1
         L     R8,DCMASCRN        R8 = ADDR OF SCREEN IMAGE BUFFER
         LA    R4,BUF             R4 = ADDR OF OUTPUT BUFFER
         LA    R5,M2BUFLEN        R5 = LENGTH OF OUTPUT BUF (21 LINES)
         LA    R9,M2BUFLEN        R9 = CONSOLE BUFFER LEN   (21 LINES)
         B     MVETRAIL           GO MOVE THE BUFFER
PAGE2    MVI   PAGE,C'2'          PAGE = 2
         L     R8,DCMASCRN        R8 = ADDR OF SCREEN IMAGE BUFFER
         CLI   MODE,C'2'          ARE WE IN DISPLAY MODE 2?
         BE    DMODE2             YES, BRANCH TO DMODE2
DMODE1   LA    R8,LEN22(R8)       MOVE POINTER DOWN 23 LINES
         LA    R9,LEN13           R9 = LENGTH OF LAST 12 LINES
         B     CONTINUE           JUMP AROUND MODE 2 DISPLAY
DMODE2   LA    R8,LEN9(R8)        MOVE POINTER DOWN 9 LINES
         LA    R9,LEN21           R9 = LENGTH OF SOURCE BUFFER
CONTINUE LA    R4,BUF             R4 = ADDR OF OUTPUT BUFFER
         LA    R5,M2BUFLEN        R5 = LENGTH OF OUTPUT BUFFER
         SPACE
MVETRAIL TIME  DEC                GET DATE AND TIME             GP@SECV
         ST    R1,WORK+4          STORE YYDDDF                  GP@SECV
         MVC   DECDATE,=X'40212061202020'                       GP@SECV
         ED    DECDATE,WORK+5     EDIT DATE TO YY/DDD           GP@SECV
         XC    WORK,WORK          ERASE CONTENTS OF WORK        GP@SECV
         STCM  R0,15,WORK+3       STORE HHMMSSSS                GP@SECV
         MVI   WORK+7,X'0F'       ENSURE VALID SIGN             GP@SECV
         DP    WORK,=P'10'        DIVIDE BY TEN                 GP@SECV
         OI    WORK+7,X'0F'       ENSURE 0HHMMSSSSF             GP@SECV
         MVC   DECTIME,=X'402120207A20207A20204B2020'           GP@SECV
         ED    DECTIME,WORK+1     DISPLAY HH:MM:SS.SS           GP@SECV
         MVC   ENDMOD2(256),CMDCTRL1 MOVE IN TRAILER
         MVC   ENDMOD2+256(TRAILEN-256),CMDCTRL1+256 MOVE IN TRAILER
         SH    R8,=H'6'           SUBTRACT THE FUDGE FACTOR     GP@SECV
         CLI   0(R8),X'11'        3270 SBA ORDER?               GP@SECV
         BE    ADJUST             YES, MAKE ADJUSTMENTS         GP@SECV
         LA    R8,6(0,R8)         NO, RESTORE R8                GP@SECV
         B     MOVEBUFF           GO MOVE THE BUFFER.           GP@SECV
ADJUST   SH    R4,=H'6'           ADJUST REGISTERS SO THE       GP@SECV
         LA    R5,6(,R5)          THE SBA AND ATTRIBUTE BYTES   GP@SECV
         LA    R9,6(,R9)          FOR THE FIRST LINE ARE USED.  GP@SECV
MOVEBUFF ICM   R9,8,PAD           MAKE BLANK THE PAD CHARACTER
         MVCL  R4,R8              MOVE CONSOLE BUFFER TO OUTPUT BUFFER
         L     R7,DCMDOMPK        SAVE DOM TABLE ADDRESS        GP@SECV
         ST    R7,DOM#ADDR             FOR THIS CONSOLE         GP@SECV
         DROP  R5,R6,R7
         MODESET KEY=NZERO                                      GP@P6
         CLI   CRTFLAG,X'FF'      IS THIS A CRT?
         BE    TPUTCRT            YES
         SPACE 5
***********************************************************************
*                                                                     *
*      DISPLAY THE OPERATOR'S SCREEN ON A TSO HARDCOPY TERMINAL       *
*                                                                     *
***********************************************************************
         XR    R8,R8              R8 = COUNTER = 0
         LA    R1,BUF             SET POINTER TO FIRST LINE
         ICM   R1,8,EDITFLG       EDIT MODE
         L     R0,=F'78'          R0 LENGTH OF OUTPUT LINE
NEXTL    LR    R3,R1              SAVE R1 SINCE TPUT ZAPS IT
         TPUT  (1),(0),R          PRINT ONE LINE ON HARDCOPY
         LA    R8,1(R8)           ADD 1 TO COUNTER
         C     R8,=F'21'          HAVE WE PRINTED LAST LINE?
         BE    DOLAST2            YES, CONTINUE
         LA    R1,80(R3)          NOPE, POINT TO NEXT LINE
         CLI   INTEGFLG,X'FF'     IS THIS AN INTEGRATED CONSOLE?
         BE    NOT3270            YES
         MVC   0(5,R1),BLANKS     BLANK OUT 3270 CTRL CHARS
         LA    R1,4(R1)           ADD 4 EXTRA BYTES TO SKIP CTRL CHARS
NOT3270  L     R0,=F'78'          LOAD LENGTH OF LINE
         ICM   R1,8,EDITFLG       EDIT MODE
         B     NEXTL              PRINT NEXT LINE
DOLAST2  TPUT  LASTLINE,79,EDIT   DISPLAY OPER CMD LINE
         TPUT  HEADING,79,EDIT    DISPLAY CONSOLE STATUS LINE
         TPUT  USERLINE,79,EDIT   DISPLAY USER CMD LINE
         B     INPUT
         SPACE 5
         EJECT
***********************************************************************
*                                                                     *
*               DISPLAY THE OPERATORS SCREEN ON A 3277                *
*                                                                     *
***********************************************************************
         SPACE
TPUTCRT  LA    R1,CLEAR           R1 = ADDR OF OUTPUT STREAM
         L     R0,TPUTLEN         R0 = LENGTH OF TPUT
         ICM   R1,8,FULLSCR       SET ASIS TYPE FOR TPUT
         TPUT  (1),(0),R          DISPLAY ENTIRE SCREEN
INPUT    MVC   USERLINE,BLANKS    BLANK OUT REPLY LINE          GP@SECV
         XC    ERROR,ERROR        LEAVE NULLS FOR INSERT MODE   GP@SECV
         MVI   INSRTCSR,X'13'     IN CASE OVERWRITTEN BY PFK    GP@SECV
         CLI   WAITFLG,X'FF'      IS THE WAIT FLAG ON?
         BNE   READCHAR           NO, SO GO GET A COMMAND
         STIMER WAIT,BINTVL=DELAY WAIT FOR DELAY*.01 SECONDS
         L     R2,CLOCK           R2 = CURRENT VALUE OF TIMER
         BCTR  R2,0               TIMER = TIMER - 1
         ST    R2,CLOCK           STORE NEW VALUE OF TIMER
         CVD   R2,WORK            CONVERT TO DECIMAL.
         MVC   SCRATCH(4),PATTERN MOVE IN EDIT PATTERN
         ED    SCRATCH(4),WORK+6  EDIT IN CONSOLE NUMBER
         MVC   TIME(3),SCRATCH+1  MOVE TIME LEFT INTO PLACE
         LTR   R2,R2              HAS TIMER HIT ZERO?
         BNZ   NEXTPAGE           NO, CONTINUE TO COUNT
         MVC   TIME(3),BLANKS     CLEAR COUNTER FIELD
         XI    WAITFLG,X'FF'      TOGGLE WAIT FLAG OFF
         B     NEXTPAGE           AND GO ON AS IF NOTHING HAPPENED..
         EJECT
***********************************************************************
*                                                                     *
*                       READ COMMAND FROM USER                        *
*                                                                     *
***********************************************************************
READCHAR XC    REPLY,REPLY        ERASE PREVIOUS REPLY          GP@SECV
         MVI   REPLY,C' '         JUST FOR CHKBLANK TEST        GP@SECV
         TGET  TGETCNTL,85,ASIS   GET 79 CHARACTERS FROM TERMINAL
         CLI   TGETCNTL+1,X'00'   ANY PA KEY (VTAM SHORT READ)? GP@SECV
         BE    NEXTPAGE           YES, JUST GO REFRESH (CNCL)
         CLI   TGETCNTL,X'7D'     ENTER?                        GP@SECV
         BE    CHKBLANK           YES, LOOK AT INPUT TEXT       GP@SECV
         CLI   TGETCNTL,X'F1'     HELP?                         GP@SECV
         BE    PF1ENTRY           YES, SHOW HELP PAGE  (PF01)   GP@SECV
         CLI   TGETCNTL,X'C1'     HELP?                         GP@SECV
         BE    PF1ENTRY           YES, SHOW HELP PAGE  (PF13)   GP@SECV
         CLI   TGETCNTL,X'F2'     HELP?                         GP@SECV
         BE    CHIMP              YES, GO TO IT        (PF02)   GP@SECV
         CLI   TGETCNTL,X'C2'     HELP?                         GP@SECV
         BNE   CHKPFK03           NO, CONTINUE                  GP@SECV
CHIMP    DS    0H                 TRANSFER CONTROL TO CHIMP     GP@SECV
         AIF   (&USERSVC EQ 0).UNZAPD1
         CLI   MODEFLAG,C'+'      WAS THE USER SVC USED?        GP@SECV
         BNE   UNZAPED1           NO, NO NEED TO RESET JSCBAUTH GP@SECV
         XC    AUTHCHEK,AUTHCHEK  DON'T USE APF-ON PLIST        GP@SECV
         LA    R1,AUTHCHEK        POINT TO USER SVC PLIST       GP@SECV
         SVC   213  **USER SVC**  DON'T ALLOW MODESET ANY MORE  GP@SECV
UNZAPED1 DS    0H                 USER SVC PROCESSING DONE      GP@SECV
.UNZAPD1 ANOP
         L     R13,SAVE+4         CALLERS SAVE AREA    (PF14)   GP@SECV
         NC    OKOK(1),VIPFLAG    PREPARE TO PASS VIP MODE TO   GP@SECV
         MVC   28(4,R13),OKOK         SUBSEQUENT SPY INVOCATION GP@SECV
         XCTL  (2,12),EPLOC=CHIMPNAM  XCTL TO CHIMP             GP@SECV
CHKPFK03 CLI   TGETCNTL,X'F3'     END?                          GP@SECV
         BE    DONE               YES, SAY BYE BYE     (PF03)   GP@SECV
         CLI   TGETCNTL,X'C3'     END?                          GP@SECV
         BE    DONE               YES, SAY BYE BYE     (PF15)   GP@SECV
         CLI   VIPFLAG,X'00'      IS HE A VIP?                  GP@SECV
         BE    CHKBLANK           NO, SO FORGET CMND PFKS       GP@SECV
         CLI   TGETCNTL,X'F4'     DISPLAY WORKSTATIONS?         GP@SECV
         BE    FAIMDWS            YES                  (PF04)   GP@SECV
         CLI   TGETCNTL,X'C4'     DISPLAY WORKSTATIONS?         GP@SECV
         BNE   CHKPFK05           NO, CONTINUE                  GP@SECV
FAIMDWS  MVC   INSRTCSR(21),PF04  F AIM,D WS,MODE=ALL  (PF16)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK05 CLI   TGETCNTL,X'F5'     SLOGON A WORKSTATION?         GP@SECV
         BE    SLOGON             YES                  (PF05)   GP@SECV
         CLI   TGETCNTL,X'C5'     SLOGON A WORKSTATION?         GP@SECV
         BNE   CHKPFK06           NO, CONTINUE                  GP@SECV
SLOGON   MVC   INSRTCSR(15),PF05  F AIM,SLOGON _       (PF17)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK06 CLI   TGETCNTL,X'F6'     SLOGOFF A WORKSTATION?        GP@SECV
         BE    SLOGOFF            YES                  (PF06)   GP@SECV
         CLI   TGETCNTL,X'C6'     SLOGOFF A WORKSTATION?        GP@SECV
         BNE   CHKPFK07           NO, CONTINUE                  GP@SECV
SLOGOFF  MVC   INSRTCSR(16),PF06  F AIM,SLOGOFF _      (PF18)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK07 CLI   TGETCNTL,X'F7'     MODIFY AIM?                   GP@SECV
         BE    FAIM               YES                  (PF07)   GP@SECV
         CLI   TGETCNTL,X'C7'     MODIFY AIM?                   GP@SECV
         BNE   CHKPFK08           NO, CONTINUE                  GP@SECV
FAIM     MVC   INSRTCSR(8),PF07   F AIM,_              (PF19)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK08 CLI   TGETCNTL,X'F8'     POST END?                     GP@SECV
         BE    POSTEND            YES                  (PF08)   GP@SECV
         CLI   TGETCNTL,X'C8'     POST END?                     GP@SECV
         BNE   CHKPFK09           NO, CONTINUE                  GP@SECV
POSTEND  MVC   INSRTCSR(15),PF08  F AIM,PO END,_       (PF20)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK09 CLI   TGETCNTL,X'F9'     VTAM ACTIVATION?              GP@SECV
         BE    VACT               YES                  (PF09)   GP@SECV
         CLI   TGETCNTL,X'C9'     VTAM ACTIVATION?              GP@SECV
         BNE   CHKPFK10           NO, CONTINUE                  GP@SECV
VACT     MVC   INSRTCSR(15),PF09  V NET,ACT,ID=_       (PF21)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK10 CLI   TGETCNTL,X'7A'     VTAM DEACTIVATION?            GP@SECV
         BE    VINACT             YES                  (PF10)   GP@SECV
         CLI   TGETCNTL,X'4A'     VTAM DEACTIVATION?            GP@SECV
         BNE   CHKPFK11           NO, CONTINUE                  GP@SECV
VINACT   MVC   INSRTCSR(19),PF10  V NET,INACT,I,ID=_   (PF22)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK11 CLI   TGETCNTL,X'7B'     VTAM ACCQUIRE?                GP@SECV
         BE    VLOGON             YES                  (PF11)   GP@SECV
         CLI   TGETCNTL,X'4B'     VTAM ACCQUIRE?                GP@SECV
         BNE   CHKPFK12           NO, CONTINUE                  GP@SECV
VLOGON   MVC   INSRTCSR(25),PF11  V NET,INACT,I,ID=_   (PF23)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKPFK12 CLI   TGETCNTL,X'7C'     DUP PREVIOUS CMND FOR EDIT?   GP@SECV
         BE    SAMECMND           YES, RESHOW COMMAND  (PF12)   GP@SECV
         CLI   TGETCNTL,X'4C'     DUP PREVIOUS CMND FOR EDIT?   GP@SECV
         BNE   CHKBLANK           NO, CONTINUE                  GP@SECV
SAMECMND MVC   USERLINE(79),OLDREPLY REDISPLAY COMMAND (PF24)   GP@SECV
         B     NEXTPAGE           GO REFRESH                    GP@SECV
CHKBLANK CLI   REPLY,C' '         JUST A BLANK?
         BE    NEXTPAGE           YES, JUST GO REFRESH
         MVC   OLDREPLY,REPLY     SAVE LAST COMMAND             GP@SECV
         OC    REPLY(79),BLANKS   CONVERT CHARS TO UPPER CASE
         EJECT
***********************************************************************
*                                                                     *
*                       W  --  ENTER WAIT MODE                        *
*                                                                     *
***********************************************************************
         CLI   REPLY,C'W'         DO WE SHIFT TO WAIT MODE?
         BNE   CDELAY             NO, SO CONTINUE
         XI    WAITFLG,X'FF'      TURN ON WAIT FLAG
         LA    R2,30              SET DEFAULT VALUE = 30
         LA    R15,CONVBIN        BRANCH TO CONVERSION RTN
         BALR  R14,R15            EBCDIC TO BINARY
         MVC   SCRATCH(4),PATTERN MOVE IN EDIT PATTERN
         ED    SCRATCH(4),WORK+6  EDIT IN CONSOLE NUMBER
         MVC   TIME(3),SCRATCH+1  MOVE TIME LEFT INTO PLACE
         ST    R2,CLOCK           STORE STARTING TIMER VALUE
         B     NEXTPAGE           ALL SET - GO DISPLAY NEXT PAGE
***********************************************************************
*                                                                     *
*            D  --  SET TIMER DELAY IN TENTHS OF A SECOND             *
*                                                                     *
***********************************************************************
CDELAY   CLI   REPLY,C'D'         ARE WE CHANGING THE TIME DELAY?
         BNE   CCONSOLE           NO, SO CONTINUE
         LA    R2,10              SET DEFAULT VALUE = 10 TENTHS SECOND
         LA    R15,CONVBIN        BRANCH TO CONVERSION RTN
         BALR  R14,R15            EBCDIC TO BINARY
         MVC   SCRATCH(5),DPATTRN MOVE IN EDIT PATTERN
         ED    SCRATCH(5),WORK+6  EDIT IN DELAY TIME
         MVC   PAUSE(3),SCRATCH+2 MOVE TIME LEFT INTO PLACE
         MH    R2,=H'10'          CONVERT TO 100THS OF A SECOND
         ST    R2,DELAY           STORE WAIT DELAY VALUE
         B     NEXTPAGE           ALL SET - GO DISPLAY NEXT PAGE
         EJECT
***********************************************************************
*                                                                     *
*                    C  --  SET CONSOLE NUMBER                        *
*                                                                     *
***********************************************************************
CCONSOLE CLI   REPLY,C'C'         DO WE CHANGE CONSOLES?
         BNE   KCONTROL           NO, SO CONTINUE
         L     R2,CONSOLE         SET DEFAULT CONSOLE
         ST    R2,OLDCONS         SAVE OLD CONSOLE #
         LA    R15,CONVBIN        BRANCH TO
         BALR  R14,R15            EBCDIC->BINARY CONVERTOR
         ST    R2,CONSOLE         STORE R2 AWAY AS CONSOLE NUMBER
         B     NEXTPAGE           CONTINUE
***********************************************************************
*                                                       THIS FUNCTION *
*        K  --  DELETE A HIGH INTENSITY MESSAGE         ADDED 17/9/82 *
*                                                          BY GP@SECV *
***********************************************************************
KCONTROL CLI   REPLY,C'K'         DO WE DOM A MESSAGE?
         BNE   NTFYOPER           NO, SO CONTINUE
         CLI   VIPFLAG,X'FF'      ARE WE IN VIP MODE?
         BNE   BADCMD             NO, SO SKIP IT
         LA    R2,1               MAKE R2 NON-ZERO
         LNR   R2,R2              MAKE R2 NEGATIVE
         LA    R15,CONVBIN        BRANCH TO
         BALR  R14,R15            EBCDIC->BINARY CONVERTOR
         LTR   R2,R2              IS R2 POSITIVE?
         BM    NEXTPAGE           NEGATIVE ==> CONVBIN FOUND ERROR
         BZ    BADCMD             ZERO ==> INVALID COMMAND
         C     R2,=F'19'          IS THE LINE NUMBER TOO LARGE?
         BH    BADCMD             YES, SO SKIP IT
         BCTR  R2,0   '           PREPARE R2 AS INDEX
         SLA   R2,3               ... 8 BYTES PER CONSOLE LINE ENTRY
         A     R2,DOM#ADDR        GET ADDR OF ENTRY FOR THIS LINE
         MODESET KEY=ZERO
         L     R2,4(0,R2)         LOAD R2 WITH MESSAGE NO. FOR DOM
         MODESET KEY=NZERO
         DOM   MSG=(R2)
         B     NEXTPAGE           CONTINUE
***********************************************************************
*                                                       THIS FUNCTION *
*        N  --  DISPLAY A HIGH INTENSITY MESSAGE        ADDED 17/9/82 *
*                                                          BY GP@SECV *
***********************************************************************
NTFYOPER CLI   REPLY,C'N'         DO WE WRITE A MESSAGE?
         BNE   BYE                NO, SO CONTINUE
         CLI   VIPFLAG,X'FF'      ARE WE IN VIP MODE?
         BNE   BADCMD             NO, SO SKIP IT
         MVC   OPERMSG(64),REPLY+1    PREPARE MESSAGE TEXT
         WTO   MF=(E,NOTIFY)      DISPLAY HIGH INTENSITY MESSAGE
         B     NEXTPAGE           CONTINUE
         EJECT
***********************************************************************
*                                                                     *
*                        B  --  TERMINATE SPY                         *
*                                                                     *
***********************************************************************
BYE      CLI   REPLY,C'B'         IS IT A 'B'?
         BE    DONE               YES, SO QUIT
***********************************************************************
*                                                                     *
*                        E  --  TERMINATE SPY                         *
*                                                                     *
***********************************************************************
END      CLI   REPLY,C'E'         IS IT AN 'E'?
         BE    DONE               YES, SO QUIT
***********************************************************************
*                                                                     *
*               F  --  FREEZE DISPLAY ON CURRENT PAGE                 *
*                                                                     *
***********************************************************************
F        CLI   REPLY,C'F'         IS IT AN 'F'?
         BNE   R                  NO, SO CONTINUE ON
         MVI   FREEZE,C'F'        TURN ON FREEZE INDICATOR
         B     NEXTPAGE           CONTINUE
***********************************************************************
*                                                                     *
*           R  --  RELEASE FREEZE ON CURRENT PAGE DISPLAY             *
*                                                                     *
***********************************************************************
R        CLI   REPLY,C'R'         IS IT AN 'R'?
         BNE   MODE1              NO, SO CONTINUE ON
         MVI   FREEZE,C'R'        TURN OFF FREEZE INDICATOR
         B     NEXTPAGE           CONTINUE
***********************************************************************
*                                                                     *
*                1  --  SHIFT TO MODE 1 TYPE DISPLAY                  *
*                                                                     *
***********************************************************************
MODE1    CLI   REPLY,C'1'         DO WE SHIFT TO MODE 1 DISPLAY?
         BNE   MODE2              NO, SO CONTINUE
         MVI   MODE,C'1'          SET MODE INDICATOR
         B     NEXTPAGE
***********************************************************************
*                                                                     *
*                2  --  SHIFT TO MODE 2 TYPE DISPLAY                  *
*                                                                     *
***********************************************************************
MODE2    CLI   REPLY,C'2'         DO WE SHIFT TO MODE 2 DISPLAY?
         BNE   GETHELP            NO, SO CONTINUE
         MVI   MODE,C'2'          SET MODE INDICATOR
         B     NEXTPAGE
         EJECT
***********************************************************************
*                                                                     *
*           ?  --  LIST HELP FOR SPY COMMANDS ON TERMINAL             *
*                                                                     *
***********************************************************************
GETHELP  CLI   REPLY,C'?'         IS HE ASKING FOR HELP?
         BE    PF1ENTRY           YES, SO DO IT                 GP@SECV
         CLI   REPLY,C'H'         IS HE ASKING FOR HELP?        GP@SECV
         BNE   VIP                NO, SO CONTINUE
PF1ENTRY LA    R0,HLENGTH2        R0 = LENGTH OF HELP PAGE      GP@SECV
         CLI   VIPFLAG,X'FF'      IN VIP MODE?                  GP@SECV
         BNE   HELPPAGE           NO, DON'T DISPLAY FULL HELP   GP@SECV
         LA    R0,HLENGTH1        R0 = LENGTH OF HELP PAGE
HELPPAGE LA    R1,HELP            R1 = ADDR OF HELP PAGE
         ICM   R1,8,FULLSCR       INSERT ASIS CNTL CHARS
         TPUT  (1),(0),R          DISPLAY HELP
         B     READCHAR
         EJECT
***********************************************************************
*                                                                     *
*                       CHECK FOR VIP PASSWORD                        *
*                                                                     *
***********************************************************************
VIP      CLC   REPLY(3),VIPWORD   WAS VIP PASSWORD ENTERED?
         BNE   JESOPER            NO, CONTINUE
         XI    VIPFLAG,X'FF'      TOGGLE VIP FLAG
         B     NEXTPAGE
***********************************************************************
*                                                                     *
*                      SYSTEM OPERATOR COMMANDS                       *
*                                                                     *
***********************************************************************
JESOPER  CLI   VIPFLAG,X'FF'      ARE WE IN VIP MODE?
         BNE   BADCMD             NO, SO CONTINUE
OPER     CLI   REPLY,C'/'         IS THIS AN OPERATOR COMMAND?
         AIF   (&USERSVC EQ 0).$VS1
         BE    MGCR               YES, USE SVC 34               GP@SECV
         AGO   .JES
.$VS1    ANOP
         BE    OSCMD              YES
         CLI   REPLY,C'#'         IS THIS AN AOF COMMAND?
         BNE   JES                NO, SO TRY FOR JES COMMAND
         LA    R1,REPLY           R1 = ADDR OF FIRST CHAR IN COMMAND
         B     AOFCMD
OSCMD    LA    R1,REPLY+1         R1 = ADDR OF FIRST CHAR IN COMMAND
AOFCMD   LA    R7,OPERCMD         R7 = ADDR OF FIRST CHAR IN RECORD
         CLI   MODEFLAG,C'*'      ARE WE APF AUTHORIZED?
         BE    MGCR               YES, FORGET ALL THIS RUBBISH
         LA    R3,N1              R3 = ADDR OF COLUMN 72 IN RECORD
CHKCHAR  CLI   0(R1),C''''        IS THIS A TICK MARK?
         BNE   MOVECHAR           NOPE; GO ON
         MVI   0(R7),C''''        TUCK IN AN EXTRA TICK
         LA    R7,1(R7)           R7 = NEXT CHAR IN RECORD
MOVECHAR MVC   0(1,R7),0(R1)      MOVE ONE CHAR INTO BUFFER
         LA    R7,1(R7)           R7 = NEXT CHAR IN RECORD
         LA    R1,1(R1)           POINT TO NEXT CHAR IN BUFFER
         CR    R7,R3              ARE WE POINTING TO THE 'N'?
         BL    CHKCHAR            NO, GO GET ANOTHER CHAR
         MVC   REPLY(79),BLANKS   YES; QUIT AND BLANK OUT REPLY FIELD
NCHAR    BCTR  R3,0               R3 = R3 - 1
         CLI   0(R3),C' '         IS THIS CHAR A BLANK?
         BE    NCHAR              YES, BACK UP ANOTHER CHAR
         MVI   1(R3),C''''        MAKE A ' THE LAST CHAR IN THE CMD
         LA    R3,OPERCARD        R3 = ADDR OF OPER COMMAND
         B     DYNA               BRANCH TO DYNAMIC ALLOCATE
.JES     ANOP
         EJECT
***********************************************************************
*                                                                     *
*                       JES OPERATOR COMMANDS                         *
*                                                                     *
***********************************************************************
JES      CLI   REPLY,C'$'         IS THIS A JES COMMAND?
         AIF   (&USERSVC EQ 0).USEINRD
         BE    MGCR               YES
         CLI   REPLY,C'#'         IS THIS AN AOF COMMAND?       GP@SECV
         BE    MGCR               YES                           GP@SECV
         AGO   .BADCMD
.USEINRD ANOP
         BNE   BADCMD             NO, MUST BE INVALID
         CLI   MODEFLAG,C'*'      APF AUTHORIZED?               GP@SECV
         BE    MGCR               YES, USE SVC 34               GP@SECV
**** JES COMMANDS FROM SPY ARE NOT LOGGED UNLESS ISSUED VIA $VS *******
*        WRITE TO LOG CODING ADDED BY GP@SECV 21/9/82
         MVC   LOGMSG(70),REPLY   GET COMMAND AS ENTERED
         L     R3,PSATOLD         FIND CURRENT TCB
         USING TCB,R3
         L     R3,TCBJSCB         POINT TO JOB STEP CONTROL BLOCK
         DROP  R3
         USING IEZJSCB,R3
         L     R3,JSCBSSIB        POINT TO SUBSYSTEM ID BLOCK
         DROP  R3
         USING SSIB,R3
         MVC   JOBID,SSIBJBID     LOAD JES JOB ID INTO MESSAGE
         DROP  R3
         TIME  DEC
         IC    R0,=C'0'           MAKE R0 PRINTABLE DECIMAL
         SRA   R0,4
         ST    R0,WORK+4
         SR    R0,R0
         ST    R0,WORK
         MVC   LOGTIME,=X'402120204B20204B2020'
         ED    LOGTIME(10),WORK+4
         WTL   MF=(E,LOGCMD)      WRITE COMMAND TO SYSLOG (NOT CNSLS) "
         MVC   JESCMD(69),REPLY   MOVE COMMAND INTO PLACE
         MVC   REPLY(79),BLANKS   BLANK OUT REPLY FIELD
         LA    R3,JESCARD         R3 = ADDR OF JES COMMAND
DYNA     LA    R1,RBPTR           R1 = ADDR OF RB POINTER
         DYNALLOC                 <<< DYNAMIC ALLOCATION >>>
         LA    R7,READER          R7 = ADDR OF READER DCB
         USING IHADCB,R7
         MVC   DCBDDNAM,DDNAME    MOVE DDNAME INTO DCB
         DROP  R7
         OPEN  (READER,OUTPUT)    OPEN INTRDR FOR OUTPUT
         PUT   READER,(3)         PUT OPER CMD TO INTRDR
         CLOSE READER             CLOSE AND FREE INTERNAL READER
         B     NEXTPAGE
.BADCMD  ANOP
***********************************************************************
*                                                                     *
*                      COMMAND WAS INVALID                            *
*                                                                     *
***********************************************************************
BADCMD   MVC   ERROR(26),ERRMSG3  COMMAND WAS INVALID
         B     NEXTPAGE
         EJECT
DONE     DS    0H                 PROGRAM TERMINATION
         AIF   (&USERSVC EQ 0).UNZAPD2
         CLI   MODEFLAG,C'+'      WAS THE USER SVC USED?        GP@SECV
         BNE   UNZAPED2           NO, NO NEED TO RESET JSCBAUTH GP@SECV
         XC    AUTHCHEK,AUTHCHEK  DON'T USE APF-ON PLIST        GP@SECV
         LA    R1,AUTHCHEK        POINT TO USER SVC PLIST       GP@SECV
         SVC   213  **USER SVC**  DON'T ALLOW MODESET ANY MORE  GP@SECV
UNZAPED2 DS    0H                 USER SVC PROCESSING DONE      GP@SECV
.UNZAPD2 ANOP
         CLI   CRTFLAG,X'00'      IS THIS A HARDCOPY?
         BE    ALLDONE            YES
         TPUT  CLR,CLRLEN,FULLSCR NO, LETS CLEAR THE SCREEN FIRST
         STFSMODE OFF             TURN OFF FS MODE
         TCLEARQ INPUT            CLEAR UNWANTED INPUT          GP@SECV
ALLDONE  L     R13,SAVE+4         RESTORE POINTER TO CALLER'S SAVE AREA
         LM    R14,R12,12(R13)    RESTORE REGISTERS
         LA    R15,0
         BR    R14                RETURN TO SYSTEM
         EJECT
***********************************************************************
*                                                            ADDED BY *
*                  USE SVC 34/241 FOR COMMANDS               GP@SECV  *
*                                                            11/10/82 *
***********************************************************************
MGCR     CLI   REPLY,C'/'         O/S COMMAND?
         BE    SVC34OS            YES
         MVC   CMDBUF,REPLY       LOAD COMMAND BUFFER WITH JES COMMAND
         B     SVC34JES                                 OR AOF COMMAND
SVC34OS  MVC   CMDBUF,REPLY+1     LOAD COMMAND BUFFER WITH O/S COMMAND
SVC34JES LA    R3,79              AVOID INFINITE LOOP
BLNKLOOP CLI   CMDBUF,C' '        LEADING BLANK(S)?
         BNE   CHECKCMD           NO, CHECK COMMAND TEXT
         MVC   CMDBUF(L'CMDBUF-1),CMDBUF+1  SHIFT COMMAND TEXT LEFT
         MVI   CMDEND,C' '        BLANK OUT OLD LAST CHARACTER
         BCT   R3,BLNKLOOP        CHECK FOR ANOTHER BLANK
CHECKCMD CLC   =C'E ',CMDBUF      RESET COMMAND?
BADJUMP1 BE    BADCMD             YES, NOT ALLOWED TO DO IT.
         CLC   =C'RESET ',CMDBUF  RESET COMMAND?
BADJUMP2 BE    BADCMD             YES, NOT ALLOWED TO DO IT.
         LA    R3,CMDEND
         LA    R2,79
PARSLOOP CLI   0(R3),C' '         BLANK CHARACTER?
         BNE   STORELEN           NO, FOUND LAST CHARACTER OF COMMAND
         BCTR  R3,0               YES, POINT TO PREVIOUS CHARACTER
         BCT   R2,PARSLOOP        IF R2 IS 0 ONLY / WAS ENTERED
         B     BADCMD             TRY AGAIN
STORELEN LA    R2,4(0,R2)         MAKE THE LAST CHARACTER A BLANK
         STH   R2,CMDLEN
         SPACE
         MODESET KEY=ZERO
         LA    R1,CMDLEN          COMMAND BUFFER ADDRESS
         L     R0,CONSOLE         CONSOLE ID
         SVC   34
         MODESET KEY=NZERO
         B     NEXTPAGE
         EJECT
***********************************************************************
*                                                                     *
*            CONVERT EBCDIC NUMBERS FROM USER INTO BINARY             *
*                                                                     *
***********************************************************************
CONVBIN  CVD   R2,WORK            CONVERT TO DECIMAL.
         CLI   REPLY+1,C' '       DID HE ENTER A NUMBER?
         BE    RTRN               NO, USE THE DEFAULT
         CLI   REPLY+1,C'0'       IS THE HEX CODE < 'F0' ?
         BL    BADCHAR            YES, ERROR
         CLI   REPLY+1,C'9'       IS THE HEX CODE > 'F9' ?
         BH    BADCHAR            YES, ERROR
         PACK  WORK(8),REPLY+1(1) PACK EBCDIC (ASSUME 1 DIGIT)
         CLI   REPLY+2,C' '       DID HE ENTER 2 DIGITS?
         BE    CVB                NO, DONT DO THE 2 DIGIT PACK
         CLI   REPLY+2,C'0'       IS THE HEX CODE < 'F0' ?
         BL    BADCHAR            YES, ERROR
         CLI   REPLY+2,C'9'       IS THE HEX CODE > 'F9' ?
         BH    BADCHAR            YES, ERROR
         PACK  WORK(8),REPLY+1(2) PACK AGAIN, WITH 2 DIGITS THIS TIME
CVB      CVB   R2,WORK            GET BINARY
RTRN     BR    R14                RETURN TO MAINLINE
BADCHAR  MVC   ERROR(26),ERRMSG2  CONSOLE NUMBER ERROR
         B     RTRN
         DROP  12
         EJECT
***********************************************************************
*                                                                     *
*                          A T T N E X I T                            *
*                                                                     *
*         TRAP USERS ATTENTION INTERRUPTS AND FLAG FOR RESET          *
*                                                                     *
***********************************************************************
ATTNEXIT LR    R7,R15             ESTABLISH
         USING ATTNEXIT,R7        ADDRESSABILITY.
         MVI   ATTNFLG,X'FF'      SET ATTN FLAG
         BR    R14                RETURN TO CALLER
         DROP  R7
         EJECT
***********************************************************************
*                                                                     *
*                         C O N S T A N T S                           *
*                                                                     *
***********************************************************************
         AIF   (&USERSVC EQ 0).NOSVCPW
AUTHCHEK DC    X'4130077F91823000' SVC 213 PASSWORD
.NOSVCPW ANOP
WORK     DS    D                   WORK AREA FOR PACKS
SCRATCH  DS    D                   SCRATCH AREA FOR CHAR. MANIP
CHIMPNAM DC    CL5'CHIMP'          NAME OF CHIMP PROGRAM
CHIMPSUF DC    CL3'   '            PROGRAM NAME SUFFIX (NSE FOR F9525)
DOM#ADDR DS    F                   ADDRESS OF DOM # TABLE FOR THIS CNSL
OLDCONS  DC    F'1'                PREVIOUS CONSOLE NUMBER
CONSOLE  DC    F'1'                CONSOLE TO BE LOOKED AT
TPUTLEN  DC    A(MOD2LEN)          LENGTH OF MOD 2 TPUT
MOD4TPUT DC    A(MOD4LEN)          LENGTH OF MOD4 TPUT
MOD2TPUT DC    A(MOD2LEN)          LENGTH OF MOD2 TPUT
LPSCREEN DC    H'0'                LINES PER SCREEN
CPLINE   DC    H'0'                CHARACTERS PER LINE
CLOCK    DC    F'30'               SECONDS LEFT ON TIMER
DELAY    DC    F'100'              DELAY FOR 100 HUNDREDTHS OF A SECOND
CMDLEN   DC    2H'0'               HALFWORD LENGTH INDICATOR    GP@SECV
CMDBUF   DC    CL78' '             SVC 34 COMMAND BUFFER        GP@SECV
CMDEND   DC    CL2' '              END OF COMMAND BUFFER        GP@SECV
TGETCNTL DC    CL6' '              TGET ASIS CONTROL BYTES      GP@SECV
REPLY    DC    CL80' '             USERS COMMAND INPUT FIELD
OLDREPLY DC    CL80' '             PREVIOUS REPLY               GP@SECV
MOD4FLG  DC    X'00'               X'FF' INDICATES 3278-4 IN USE
ATTNFLG  DC    X'00'               X'FF' INDICATES ATTN WAS TRAPPED
CRTFLAG  DC    X'FF'               X'FF' INDICATES CRT IN USE
WAITFLG  DC    X'00'               X'00' INDICATES NOT IN WAIT MODE
VIPFLAG  DC    X'00'               X'FF' INDICATES VIP MODE
INTEGFLG DC    X'00'               INTEGRATED CONSOLE FLAG
FULLSCR  DC    X'03'               TPUT ASIS FLAG
EDITFLG  DC    X'00'               TPUT EDIT FLAG
VIPWORD  DC    C'GAK'              VIP PASSWORD
MODEFLAG DC    C'?'                * ==> AC=1; $ OR + ==> AC=0  GP@SECV
NOGOMSG  DC    C'OPERATOR PRIVILEGE IS REQUIRED FOR SPY'        GP@SECV
* NOTE: IF THESE COMMANDS ARE CHANGED THEN ADJUST THE LENGTH    GP@SECV
*       OPERANDS OF THE APPROPRIATE MVC INTRUCTIONS ABOVE.      GP@SECV
PF04     DC    C'/f aim,d ws,mode=all',X'13'                    GP@SECV
PF05     DC    C'/f aim,slogon ',X'13'                          GP@SECV
PF06     DC    C'/f aim,slogoff ',X'13'                         GP@SECV
PF07     DC    C'/f aim,',X'13'                                 GP@SECV
PF08     DC    C'/f aim,po end,',X'13'                          GP@SECV
PF09     DC    C'/v net,act,id=',X'13'                          GP@SECV
PF10     DC    C'/v net,inact,i,id=',X'13'                      GP@SECV
PF11     DC    C'/v net,logon=kcbntsl,id=',X'13'                GP@SECV
R41C1    DC    X'11F240'           3278-4  --  ROW 41, COL 1
R42C1    DC    X'11F350'           3278-4  --  ROW 42, COL 1
R43C1    DC    X'11F460'           3278-4  --  ROW 43, COL 1
PATTERN  DC    X'40202020'         EDIT PATTERN FIELD
DPATTRN  DC    X'4021204B20'       EDIT PATTERN FIELD
PAD      DC    C' '                PAD CHARACTER FOR MOVEBUFF MVCL
STAXLIST STAX  ATTNEXIT,MF=L
EXTRPSCB EXTRACT ANSWER,'S',FIELDS=(PSB),MF=L                   GP@SECV
NOTIFY   WTO   '123456789.123456789.123456789.123456789.123456789.12345+
               6789.1234',MF=L,DESC=(2)                         GP@SECV
         ORG   NOTIFY+4                                         GP@SECV
OPERMSG  DS    CL64                                             GP@SECV
         ORG
         AIF   (&USERSVC EQ 1).BLANKS
LOGCMD   WTL   '              SPY OPER  123456789.123456789.123456789.1+
               23456789.123456789.123456789.123456789 ',MF=L    GP@SECV
         ORG   LOGCMD+4                                         GP@SECV
         DS    CL3                                              GP@SECV
LOGTIME  DS    CL10               PAD+0HH.MM.SS                 GP@SECV
         DS    CL1                                              GP@SECV
JOBID    DS    CL8                                              GP@SECV
         DS    CL2                                              GP@SECV
LOGMSG   DS    CL70                                             GP@SECV
         ORG
.BLANKS  ANOP
BLANKS   DC    CL80' '
         SPACE 5
         AIF   (&USERSVC EQ 1).NODYNAL
***********************************************************************
*                                                                     *
*        PARAMETERS FOR DYNAMIC ALLOCATION OF INTERNAL READER         *
*                                                                     *
***********************************************************************
         DS    0F
RBPTR    DC    X'80'
         DC    AL3(RB)
RB       DC    X'14'              RB LENGTH
         DC    X'01'              DSNAME ALLOCATION REQUESTED
         DC    X'1000'            FLAGS1
INFOCODE DC    H'0'               ERROR CODE
ERORCODE DC    H'0'               INFORMATION BYTES
         DC    A(TXTUNITS)        ADDR OF TEXT UNIT POINTERS
         DC    2F'0'
TXTUNITS DC    A(TU1)
         DC    A(TU2)
         DC    A(TU3)
         DC    X'80',AL3(TU4)
TU1      DC    X'0019'            SYSOUT INTRDR REQUESTED
         DC    X'0001'
         DC    X'0006'
         DC    CL8'INTRDR'
TU2      DC    X'001C'            FREE DDNAME AT CLOSE
         DC    X'0000'
TU3      DC    X'0018'            RETURN GENERATED DDNAME
         DC    X'0001'
         DC    X'0001'
         DC    CL1'A'             DDNAME RETURN  HERE
TU4      DC    X'0055'            RETURN GENERATED DDNAME
         DC    X'0001'
         DC    X'0008'
DDNAME   DC    CL8' '             DDNAME RETURN  HERE
         SPACE 2
***********************************************************************
*                                                                     *
*                      DCB AND COMMAND BUFFERS                        *
*                                                                     *
***********************************************************************
READER   DCB   DSORG=PS,MACRF=PM,RECFM=F,LRECL=80,BLKSIZE=80,DDNAME=X
         SPACE 2
JESCARD  DC    C'/*'
JESCMD   DC    CL69' '
N        DC    CL9'N'             SUPRESS ECHO OF COMMAND
         SPACE 2
OPERCARD DC    CL7'/*$VS,'''
OPERCMD  DC    CL64' '
N1       DC    CL9'N'             SUPRESS ECHO OF COMMAND
         SPACE 2
.NODYNAL ANOP
***********************************************************************
*                                                                     *
*               327X SCREEN CLEAR CONTROL CHARACTERS                  *
*                                                                     *
***********************************************************************
CLR      DC    X'C1'              WCC - CLEAR SCREEN
*        DC    X'115D7E'          SBA TO ROW 24, COL 80 (FSE 5.0)
         DC    X'114040'          SBA TO ROW 1, COL 1
         DC    X'3C404000'        FILL SCREEN WITH NULLS
         DC    X'114040'          SBA TO ROW 1, COL 1
         DC    X'13'              INSERT CURSOR
CLRLEN   EQU   *-CLR
         SPACE 5
***********************************************************************
*                                                                     *
*                  DISPLAY SCREEN - HEADER SECTION                    *
*                                                                     *
***********************************************************************
HEADER   EQU   *
CLEAR    DC    X'C1'              WCC
*        DC    X'115D7F'          SBA TO ROW 24, COL 80 (FSE 5.0)
         DC    X'114040'          SBA TO ROW 1, COL 1
*        DC    X'3C404000'        FILL SCREEN WITH NULLS
*        DC    X'114040'          SBA TO ROW 1, COL 1
         DC    X'1DE4'            ATTR BYTE - PROTECTED FIELD
         DC    X'40'
***********************************************************************
*                                                                     *
*               DISPLAY SCREEN - IMAGE BUFFER SECTION                 *
*                                                                     *
***********************************************************************
BUF      DC    21CL80' '          OPERATORS SCREEN BUFFER
         DC    14CL80' '          PLUS EXTRA FOR 3278-4
***********************************************************************
*                                                                     *
*               DISPLAY SCREEN - TRAILER SECTION                      *
*                                                                     *
***********************************************************************
TRAILER  EQU   *
CMDCTRL1 DC    X'11D940'          SBA TO ROW 21, COL 1
         DC    X'1DE8'            ATTR BYTE - PROTECTED, HIGH INTENSITY
         DC    CL6'Date: '
DECDATE  DC    CL7' '              YY/DDD
         DC    CL3' '
         DC    CL5'Time:'
DECTIME  DC    CL13' '             HH:MM:SS.SS
         DC    CL4' '
         DC    CL9'Userid:  '
USERID   DC    CL8' '             TSO USERID
         DC    CL3' '
TERMMARK DC    CL11'Terminal:  '
TERMINAL DC    CL8' '
CMDCTRL2 DC    X'115A50'          SBA TO ROW 22, COL 1
         DC    X'1DE8'            ATTR BYTE - PROTECTED, HIGH INTENSITY
LASTLINE DC    CL79' '            SYSTEM OPERATOR'S COMMAND INPUT LINE
PHEADING DC    X'115B60'          SBA TO ROW 23, COL 1
         DC    X'1DE8'            ATTR BYTE - PROTECTED, HIGH INTENSITY
HEADING  DC    CL8'Console '
CONNUM   DC    CL2' 1'            CONSOLE NUMBER
CTYPE    DC    CL4' '
MASTER   DC    CL8' '             MASTER CONSOLE
SYS      DC    CL4' '             SYS  AUTHORIZATION
IO       DC    CL4' '             I/O  AUTHORIZATION
CONS     DC    CL5' '             CONS AUTHORIZATION
         DC    CL3' '
         DC    CL5'Unit'
UNIT     DC    CL4' '             UNIT ADDR OF CONSOLE
HEADING1 DC    CL7'Timer: '
TIME     DC    CL3' '             SECONDS REMAINING ON TIMER
SLASH    DC    CL1'/'
PAUSE    DC    CL3'1.0'           DELAY IN SECONDS
         DC    CL2' '
HEADING2 DC    CL6'Mode: '
FREEZE   DC    C'F'               FREEZE/RELEASE MODE
MODE     DC    CL1'2'             DISPLAY MODE 2/1
         DC    CL2' '
         DC    CL5'Page '
PAGE     DC    CL1'2'             PAGE NUMBER
R24C1    DC    X'115CF0'          SBA TO ROW 24, COL 1
         DC    X'1D40'            ATTR BYTE - UNPROTECTED, LOW INTENS.
INSRTCSR DC    X'13'              INSERT CURSOR
USERLINE DC    CL13' '            USERS COMMAND INPUT LINE
ERROR    DC    XL66'00'           ERROR MSG FIELD  (NULLS FOR INSERTS)
ENDTRAIL EQU   *
         SPACE 5
         LTORG
         SPACE 5
         DS    0F
UCMTAB   DS    F
         DS    20F                PROVIDE SPACE FOR 20 UCM ADDRESSES
UCMTABE  EQU   *
NUMUCMS  DS    H
         SPACE 5
ERRMSG1  DC    CL26'ERROR - Console ID invalid'
ERRMSG2  DC    CL26'ERROR - Non-numeric value '
ERRMSG3  DC    CL26'ERROR - Invalid command   '
ERRMSG4  DC    CL26'ERROR - Non-CRT console   '
         SPACE 5
***********************************************************************
*                                                                     *
*                           USER HELP PAGE                            *
*                                                                     *
***********************************************************************
HELP     DC    X'C1'               WCC
*        DC    X'115D7F'           SBA TO ROW 24, COL 80 (FSE 5.0)
         DC    X'114040'           SBA TO ROW 1, COL 1
         DC    X'3C404000'         FILL SCREEN WITH NULLS
         DC    X'114040',X'1DF8',C'COMMAND    DESCRIPTION'
         DC    CL28' ',C'SECV VERSION - &SYSDATE'               GP@SECV
         DC    X'11C150'
         DC    X'11C260',C'   B        End SPY'
         DC    X'11C3F0',C'   C        Switch monitor to console 1'
         DC    X'11C540',C'   Cnn      Switch monitor to console nn'
         DC    X'11C650',C'   Dnn      Set delay to nn tenths seconds'
         DC    X'11C760',C'   E        End SPY'
         DC    X'11C8F0',C'   F        Freeze display on current page'
         DC    X'114A40',C'   R        Release Display'
         DC    X'114B50',C'   W        Start timer mode for 30 seconds'
         DC    X'114C60',C'   Wnn      Start timer mode for nn seconds'
         DC    X'114DF0',C'   W0       Start timer mode until '
         DC    C'interrupt'
         DC    X'114F40',C'   ?        Display this page'
         DC    X'115050',C'   1        Display mode 1'
         DC    X'11D160',C'   2        Display mode 2'
*        DC    X'11D940'
         DC    X'115A50',C'Hitting INTERRUPT will stop the wait timer'
*        DC    X'115B60'
         DC    X'115CF0'        ROW 24, COL 1
         DC    C'Hit ENTER to continue'
         DC    X'115DC6'        ROW 24, COL 23
         DC    X'1D40'
         DC    X'1340'
         DC    X'1DF8'
*                                    HELP FOR PF KEYS ADDED BY GP@SECV
* COLUMNS 50 TO 80, ROWS 3 TO 14; USING FACOM EXTENDED ATTR BYTES (X1B)
* TO CONVERT TO IBM COMPATIBLE ATTRIBUTES CHANGE 1BXXYY TO 1DXX .
         AGO   .SKIP1B
         DC    X'11C3D11BF8CA',C' PF01/13 ',X'1BF8CA'
         DC    C' PF02/14 ',X'1BF8CA',C' PF03/15 ',X'1BF8C2'
         DC    X'11C4611BF8C2',C'         ',X'1BF8C2'
         DC    C'         ',X'1BF8C2',C'         ',X'1BF8C2'
         DC    X'11C5F11BF8C6',C'   HELP  ',X'1BF8C6'
         DC    C'  CHIMP  ',X'1BF8C6',C'   END   ',X'1BF8C2'
*MARKER2  EQU   *
         SPACE
         DC    X'11C7C11BF8C2',C' PF04/16 ',X'1BF8C2'
         DC    C' PF05/17 ',X'1BF8C2',C' PF06/18 ',X'1BF8C2'
         DC    X'11C8D11BF8C2',C'   AIM   ',X'1BF8C2'
         DC    C'   AIM   ',X'1BF8C2',C'   AIM   ',X'1BF8C2'
         DC    X'11C9611BF8C6',C'   D WS  ',X'1BF8C6'
         DC    C'  SLOGON ',X'1BF8C6',C' SLOGOFF ',X'1BF8C2'
         SPACE
         DC    X'114AF11BF8C2',C' PF07/19 ',X'1BF8C2'
         DC    C' PF08/20 ',X'1BF8C2',C' PF09/21 ',X'1BF8C2'
         DC    X'114CC11BF8C2',C'         ',X'1BF8C2'
         DC    C'   POST  ',X'1BF8C2',C'   VTAM  ',X'1BF8C2'
         DC    X'114DD11BF8C6',C'  F AIM  ',X'1BF8C6'
         DC    C'   END   ',X'1BF8C6',C'   ACT   ',X'1BF8C2'
         SPACE
         DC    X'114E611BF8C2',C' PF10/22 ',X'1BF8C2'
         DC    C' PF11/23 ',X'1BF8C2',C' PF12/24 ',X'1BF8C2'
         DC    X'114FF11BF8C2',C'   VTAM  ',X'1BF8C2'
         DC    C'   VTAM  ',X'1BF8C2',C'         ',X'1BF8C2'
         DC    X'11D1C11BF8C6',C'  INACT  ',X'1BF8C6'
         DC    C'  LOGON  ',X'1BF8C6',C'   DUP   ',X'1BF8C2'
*        HELP FOR PA2 - COLUMNS 60 TO 70, ROWS 21 TO 23
         DC    X'11D97B1BF8CA',C'   PA2   ',X'1BF8C2'
         DC    X'115B4B1BF8C2',C'         ',X'1BF8C2'
         DC    X'115C5B1BF8C6',C'  CANCEL ',X'1BF8C2'
.SKIP1B  ANOP
*        HELP TEXT FOR VIP COMMANDS: K, N, $ (JES) AND / (OS)
         DC    X'11D2F0'
         DC    C'   Ntext... Notify operator via action message' GP@SEC
         DC    X'11D440'
         DC    C'   Knn      Revert message on line nn to low intensity+
                (excl WTORs) '                                  GP@SECV
         DC    X'11D550'
         DC    C'   $cmnd    Issue JES command'                 GP@SECV
         DC    X'11D660'
         DC    C'   #cmnd    Issue AOF command'                 GP@SECV
         DC    X'11D7F0'
         DC    C'   /cmnd    Issue O/S command'                 GP@SECV
MARKER1  EQU   *
MARKER2  EQU   *
HLENGTH1 EQU   MARKER1-HELP     LENGTH OF HELP TPUT (VIP MODE)
HLENGTH2 EQU   MARKER2-HELP     LENGTH OF HELP TPUT (NOT VIP MODE)
         EJECT
***********************************************************************
*                                                                     *
*                           E Q U A T E S                             *
*                                                                     *
***********************************************************************
LEN9     EQU   9*80             NUMBER OF BYTES IN  9 LINES
LEN21    EQU   21*80            NUMBER OF BYTES IN 21 LINES
LEN22    EQU   22*80            NUMBER OF BYTES IN 22 LINES
LEN13    EQU   13*80            NUMBER OF BYTES IN 13 LINES
LEN14    EQU   14*80            NUMBER OF BYTES IN 14 LINES
M2BUFLEN EQU   21*80            LENGTH OF BUFFER 3278-2
M4BUFLEN EQU   35*80            LENGTH OF BUFFER 3278-4
HEADLEN  EQU   BUF-HEADER       LENGTH OF HEADER
TRAILEN  EQU   ENDTRAIL-TRAILER LENGTH OF TRAILER
MOD4LEN  EQU   ENDTRAIL-HEADER  LENGTH OF TPUT FOR MOD4
MOD2LEN  EQU   MOD4LEN-LEN14    LENGTH OF TPUT FOR MOD2
ENDMOD2  EQU   BUF+M2BUFLEN     ADDR OF TRAILER FOR 3278-2
         EJECT
         PRINT NOGEN
         SPACE 3
         AIF   (&USERSVC EQ 1).NODCBD
         DCBD  DSORG=BS,DEVD=DA
         SPACE 3
.NODCBD  ANOP
         CVT   DSECT=YES
         SPACE 3
         AIF   (&USERSVC EQ 1).LESBLKS
         IEZJSCB                                                GP@SECV
         SPACE 3
         IEFJSSIB                                               GP@SECV
         SPACE 3
.LESBLKS ANOP
         IKJTCB                                                 GP@SECV
         SPACE 3
         IHAPSA                                                 GP@SECV
         SPACE 3
         IKJTSB                                                 GP@SECV
         SPACE 3
         PRINT GEN
         SPACE 3
         IHAASCB                                                GP@SECV
         EJECT
         IEERDCM                                                GP@SECV
         EJECT
         IEECDCM                                                GP@SECV
         EJECT
         IEECUCM FORMAT=NEW                                     GP@SECV
         EJECT
         IKJPSCB                                                GP@SECV
         END   SPY
//LKED.SYSLMOD DD DSN=SYS1.PPLIB(SPY),DISP=SHR
