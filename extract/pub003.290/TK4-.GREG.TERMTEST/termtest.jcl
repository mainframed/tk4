//GREGTT   JOB (SYS),G.PRICE,CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),
//             NOTIFY=GREG,REGION=2048K,COND=(0,NE)
//* ********************************************************
//* *                                                      *
//* *      INSTALL THE 'TERMTEST' TSO COMMAND              *
//* *                                                      *
//* ********************************************************
//UPDATE  EXEC PGM=IEBUPDTE,PARM=NEW
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=&&MACLIB,DISP=(NEW,PASS),
//             UNIT=VIO,SPACE=(TRK,(10,10,10)),
//             DCB=SYS1.MACLIB
//SYSIN    DD  *
./ ADD NAME=TERMTYPE
         MACRO
&NAME    TERMTYPE &TERMIDL=
         CNOP 0,4
&NAME    DS   0H
         SR   1,1                  ZERO REGISTER 1
         LA   0,&TERMIDL           LOAD TERMINAL ID LOCATION
         LA   15,2                 LOAD ENTRY CODE
         SLL  15,24                SHIFT TO TOP BYTE
         OR   0,15                 GATE INTO REGISTER 0
         LNR  0,0                  MAKE NEGATIVE
         SVC  94                   ISSUE TERMINAL CONTROL SVC
         MEXIT
         MEND
./ ADD NAME=DCS
         MACRO
&NAME    DCS
.**********************************************************************
.*                                                                    *
.*        DCS  -  DEFINE CONSTANT FOR SCREEN                          *
.*                                                                    *
.*        WRITTEN BY BILL GODFREY                                     *
.*        PLANNING RESEARCH CORPORATION                               *
.*        PRC COMPUTER CENTER, MCLEAN VA 22101                        *
.*        DATE WRITTEN: JANUARY 8 1981.                               *
.*        DATE UPDATED: MARCH 18 1982. (ROW AND COL IN PARENS)        *
.*        GP@P6          JULY 25 1986. (EXTENDED ATTRS, MEDIUM INTENS)*
.*        GP@P6     SEPTEMBER 23 1986. (ESCAPES, WRITES, RA, MFA, MF) *
.*        GP@P6        AUGUST 24 1987. (EAU, WSF, RB, RM, RMA)        *
.*        GP@P6       OCTOBER 15 1987. (3270 AND GRAPHIC EXTRAS)      *
.*                                                                    *
.*        THIS MACRO IS USED FOR CODING A FULLSCREEN 3270 DISPLAY.    *
.*                                                                    *
.*        SAMPLE                                                      *
.*           DCS    AL1(WCC),SBA,(1,1),RTA,(7,1),X'00',IC             *
.*                                                                    *
.*        IT SIMPLIFIES THE CODING OF A SCREEN IN THE FOLLOWING WAYS. *
.*        .  BUFFER ADDRESSES ARE SPECIFIED AS ROW AND COLUMN NUM-    *
.*           BER.  THE MACRO TRANSLATES THEM INTO THE 3270 CODE.      *
.*        .  ORDERS ARE SPECIFIED BY NAME, SUCH AS 'SBA' AND 'SF',    *
.*           SO YOU DONT HAVE TO KNOW THE HEX CODES FOR THEM,         *
.*        .  COMMONLY USED ATTRIBUTE BYTES ARE SPECIFIED BY NAME      *
.*           (A SET OF RESERVED NAMES) SO YOU DONT HAVE TO KNOW       *
.*           THE HEX CODES FOR THEM.                                  *
.*        .  IT SAVES A LOT OF DOCUMENTATION WORK, AND MAKES          *
.*           THE CODE EASIER FOR OTHERS TO UNDERSTAND.                *
.*                                                                    *
.*        THE USER OF THE MACRO MUST STILL UNDERSTAND HOW A SCREEN    *
.*        IS CONSTRUCTED BEFORE USING IT. THE MACRO MERELY MAKES IT   *
.*        EASIER TO SPECIFY THE VALUES.  IT DOES VERY LITTLE ERROR    *
.*        CHECKING.  FOR INSTANCE, IT DOES NOT CHECK TO SEE IF        *
.*        YOU FOLLOW AN 'SBA' WITH A BUFFER ADDRESS.  IT IS POSSIBLE  *
.*        TO CODE A THOROUGHLY INVALID SCREEN.                        *
.*                                                                    *
.*        THE MACRO MAY HAVE ANY NUMBER OF OPERANDS, CONSISTING OF    *
.*        ANY COMBINATION OF THE FOLLOWING.                           *
.*                                                                    *
.*        .  AN ESCAPE CHARACTER.                                     *
.*           VALID ESCAPE CHARACTERS ARE:                             *
.*           ESC - ESCAPE                                             *
.*           GE  - GRAPHIC ESCAPE                                     *
.*        .  A WRITE COMMAND.                                         *
.*           VALID WRITE COMMANDS ARE:                                *
.*           WR  - WRITE (WRT)                                        *
.*           EW  - ERASE/WRITE                                        *
.*           EWA - ERASE/WRITE ALTERNATE                              *
.*           EAU - ERASE ALL UNPROTECTED                              *
.*           WSF - WRITE STRUCTURED FIELD                             *
.*        .  A READ COMMAND.                                          *
.*           VALID READ COMMANDS ARE:                                 *
.*           RB  - READ BUFFER                                        *
.*           RM  - READ MODIFIED                                      *
.*           RMA - READ MODIFIED ALL                                  *
.*        .  A 3270 ORDER.                                            *
.*           VALID 3270 ORDERS ARE:                                   *
.*           SBA, SF, RA (RTA), IC, PT (HT), EUA, SA, SFE, MF (MFA).  *
.*        .  A BUFFER ADDRESS IN PARENTHESES.                         *
.*           IF AN OPERAND IS IN PARENTHESES, IT IS ASSUMED THAT      *
.*           THE ROW AND COLUMN NUMBER ARE BETWEEN THE PARENS,        *
.*           SEPARATED BY A COMMA.  EXAMPLE: (1,1)                    *
.*           THIS FORM OF BUFFER ADDRESS IS NEW AS OF MARCH 18 1982.  *
.*        .  A ROW OR COLUMN NUMBER OF A BUFFER ADDRESS (OLD FORMAT). *
.*           IF AN OPERAND IS NUMERIC, IT IS ASSUMED TO BE            *
.*           A ROW OR COLUMN NUMBER.  IT TAKES 2 OPERANDS TO          *
.*           SPECIFY THE BUFFER ADDRESS (ROW AND COLUMN) SO NUMERIC   *
.*           OPERANDS MUST ALWAYS BE SPECIFIED IN PAIRS, THE          *
.*           FIRST BEING THE ROW AND THE SECOND BEING THE COLUMN.     *
.*           THIS FORMAT IS SUPPORTED ONLY FOR COMPATIBILITY WITH     *
.*           THE ORIGINAL VERSION OF THIS MACRO.                      *
.*        .  AN ATTRIBUTE BYTE.                                       *
.*           VALID ATTRIBUTE BYTES ARE:                               *
.*           UNPLO  - UNPROTECTED NORMAL INTENSITY                    *
.*           UNPMD  - UNPROTECTED MEDIUM INTENSITY                    *
.*           UNPHI  - UNPROTECTED HIGH INTENSITY                      *
.*           UNPNP  - UNPROTECTED NO-DISPLAY                          *
.*           PROLO  - PROTECTED NORMAL INTENSITY                      *
.*           PROLOS - PROTECTED NORMAL INTENSITY AUTO-SKIP            *
.*           PROMD  - PROTECTED MEDIUM INTENSITY                      *
.*           PROMDS - PROTECTED MEDIUM INTENSITY AUTO-SKIP            *
.*           PROHI  - PROTECTED HIGH INTENSITY                        *
.*           PROHIS - PROTECTED HIGH INTENSITY AUTO-SKIP              *
.*        .  AN EXTENDED ATTRIBUTE TYPE.                              *
.*           VALID ATTRIBUTE TYPES ARE:                               *
.*           FIELD, VALIDN, OUTLIN, HILITE, COLOUR, PGMSYM, BKCOLR    *
.*           AND TRANSP.                                              *
.*        .  AN EXTENDED HIGHLIGHTING SPECIFICATION.                  *
.*           VALID HIGHLIGHTINGS ARE:                                 *
.*           NORMAL, BLINK, REVERSE AND USCORE.                       *
.*        .  AN EXTENDED COLOUR SPECIFICATION.                        *
.*           VALID COLOURS ARE:                                       *
.*           BLUE, RED, PINK, GREEN, TURQ, YELLOW, WHITE AND NORMAL.  *
.*        .  A BACKGROUND TRANSPARENCY SPECIFICATION.                 *
.*           VALID TRANSPARENCIES ARE:                                *
.*           NORMAL (TRANSPARENT) AND OPAQUE (NON-TRANSPARENT).       *
.*        .  A FORMAT CONTROL ORDER.                                  *
.*           VALID FORMAT CONTROL ORDERS ARE:                         *
.*           NUL, SUB, DUP, FM, FF, CR, NL, EM, EO, BYP, RES, SI, SO. *
.*        .  A GRAPHIC ORDER.                                         *
.*           VALID GRAPHIC ORDERS ARE TOO NUMEROUS TO MENTION.        *
.*        .  A HEX, CHARACTER, OR ADDRESS CONSTANT.                   *
.*           FOR EXAMPLE, X'00', OR C'ENTER SIGNON'                   *
.*           THIS CAN BE USED FOR DATA WITHIN FIELDS OR FOR           *
.*           ATTRIBUTE BYTES, ORDERS, THE 'WCC', OR BUFFER            *
.*           ADDRESSES (IF YOU WANT TO FIGURE THEM OUT).              *
.*                                                                    *
.*        IF THE OPERANDS DO NOT ALL FIT ON ONE LINE, YOU CAN         *
.*        EITHER CONTINUE THE LINE IN THE STANDARD ASSEMBLER WAY      *
.*        OR CODE THE MACRO AGAIN ON THE NEXT LINE WITH THE           *
.*        REMAINING OPERANDS.  THE RESULT IS THE SAME EITHER WAY.     *
.*                                                                    *
.*        THE BUFFER ADDRESS CONVERSIONS ARE FOR A                    *
.*        SCREEN SIZE OF 24 ROWS BY 80 COLUMNS. FOR SCREENS           *
.*        OF OTHER DIMENSIONS (43 BY 80, 12 BY 40) THE MACRO          *
.*        NEEDS ONLY A FEW CHANGES.                                   *
.*                                                                    *
.*        WARNING: IF YOU CODE THE MACRO WITH A LABEL IN COLUMN 1,    *
.*        AND YOU LIKE USING LENGTH ATTRIBUTES, BEWARE THAT THE       *
.*        LENGTH ATTRIBUTE OF THE LABEL IS NOT NECESSARILY THE        *
.*        TOTAL LENGTH OF THE DATA GENERATED BY THE MACRO.            *
.*                                                                    *
.*        PROGRAMMING NOTE:                                           *
.*        SA,NORMAL,NORMAL     WILL DO IN THREE BYTES WHAT            *
.*        SA,HILITE,NORMAL,SA,COLOUR,NORMAL,SA,PGMSYM,NORMAL          *
.*                             WILL DO IN NINE BYTES.                 *
.*                                                                    *
.*        TECHNICAL NOTES:                                            *
.*        ATTRIBUTES WITH CODES IN THE RANGE X'00' TO X'7F' HAVE      *
.*        VALUES GIVEN BY A 1-BYTE BINARY NUMBER.  EG. X'42' (COLOUR) *
.*        ATTRIBUTES WITH CODES IN THE RANGE X'C0' TO X'FF' HAVE      *
.*        BIT-ENCODED VALUES.  EG. X'C0' (3270 FIELD ATTRIBUTE)       *
.*        CHARACTER SETS:                                             *
.*        X'00' - DEFAULT               X'40'-X'EF' - LOADABLE LCID   *
.*        X'F0'-X'F7' - NON-LOADABLE LCID   X'F8'-X'FE' - DBCS LCID   *
.*        FIELD VALIDATION:                                           *
.*        SPECIFY A BYTE IN THE RANGE X'00' TO X'07' ON THE BASIS OF  *
.*        X'01' ON FOR TRIGGER, X'02' ON FOR MANDATORY ENTRY AND      *
.*        X'04' ON FOR MANDATORY FILL.                                *
.*        FIELD OUTLINING:                                            *
.*        SPECIFY A BYTE IN THE RANGE X'00' TO X'0F' ON THE BASIS OF  *
.*        X'01' ON FOR UNDERLINE, X'02' ON FOR RIGHT VERTICAL LINE,   *
.*        X'04' ON FOR OVERLINE AND X'08' ON FOR LEFT VERTICAL LINE.  *
.*                                                                    *
.**********************************************************************
.*
         LCLA  &R,&C,&P,&Q
         LCLA  &AN,&AS,&AL
         LCLB  &B,&NUMERIC,&INTEGER
         LCLC  &T(64)
         LCLC  &N,&ROW,&COL
         LCLC  &CS,&STRING
&T(1)    SETC  '40'
&T(2)    SETC  'C1'
&T(3)    SETC  'C2'
&T(4)    SETC  'C3'
&T(5)    SETC  'C4'
&T(6)    SETC  'C5'
&T(7)    SETC  'C6'
&T(8)    SETC  'C7'
&T(9)    SETC  'C8'
&T(10)   SETC  'C9'
&T(11)   SETC  '4A'
&T(12)   SETC  '4B'
&T(13)   SETC  '4C'
&T(14)   SETC  '4D'
&T(15)   SETC  '4E'
&T(16)   SETC  '4F'
.*
&T(17)   SETC  '50'
&T(18)   SETC  'D1'
&T(19)   SETC  'D2'
&T(20)   SETC  'D3'
&T(21)   SETC  'D4'
&T(22)   SETC  'D5'
&T(23)   SETC  'D6'
&T(24)   SETC  'D7'
&T(25)   SETC  'D8'
&T(26)   SETC  'D9'
&T(27)   SETC  '5A'
&T(28)   SETC  '5B'
&T(29)   SETC  '5C'
&T(30)   SETC  '5D'
&T(31)   SETC  '5E'
&T(32)   SETC  '5F'
.*
&T(33)   SETC  '60'
&T(34)   SETC  '61'
&T(35)   SETC  'E2'
&T(36)   SETC  'E3'
&T(37)   SETC  'E4'
&T(38)   SETC  'E5'
&T(39)   SETC  'E6'
&T(40)   SETC  'E7'
&T(41)   SETC  'E8'
&T(42)   SETC  'E9'
&T(43)   SETC  '6A'
&T(44)   SETC  '6B'
&T(45)   SETC  '6C'
&T(46)   SETC  '6D'
&T(47)   SETC  '6E'
&T(48)   SETC  '6F'
.*
&T(49)   SETC  'F0'
&T(50)   SETC  'F1'
&T(51)   SETC  'F2'
&T(52)   SETC  'F3'
&T(53)   SETC  'F4'
&T(54)   SETC  'F5'
&T(55)   SETC  'F6'
&T(56)   SETC  'F7'
&T(57)   SETC  'F8'
&T(58)   SETC  'F9'
&T(59)   SETC  '7A'
&T(60)   SETC  '7B'
&T(61)   SETC  '7C'
&T(62)   SETC  '7D'
&T(63)   SETC  '7E'
&T(64)   SETC  '7F'
.*
&N       SETC  '&NAME'
&AN      SETA  N'&SYSLIST          NUMBER OF OPERANDS
&AS      SETA  0
&B       SETB  0 FALSE
.EACH    AIF   (&AN EQ 0).EPILOG
&AS      SETA  &AS+1
&CS      SETC  '&AS'
&AL      SETA  K'&SYSLIST(&AS)
         AIF   (T'&SYSLIST(&AS) EQ 'O').NEXT
         AIF   ('&SYSLIST(&AS)'(1,1) EQ '(').PAIR
&NUMERIC SETB  (T'&SYSLIST(&AS) EQ 'N')
&INTEGER SETB  ('&SYSLIST(&AS)'(1,1) GE '0')
         AIF   (&NUMERIC AND &INTEGER).ROWCOL
         AIF   (NOT &B).ROWCOLX
         MNOTE 4,'             &CS.) MISSING COLUMN NUMBER'
&B       SETB  0 FALSE
.ROWCOLX ANOP
&STRING  SETC  '&SYSLIST(&AS)'
.*             ESCAPES
         AIF   ('&STRING' EQ 'ESC').ESC
         AIF   ('&STRING' EQ 'GE').GE
.*             WRITES
         AIF   ('&STRING' EQ 'WR').WR
         AIF   ('&STRING' EQ 'WRT').WR
         AIF   ('&STRING' EQ 'EW').EW
         AIF   ('&STRING' EQ 'EWA').EWA
         AIF   ('&STRING' EQ 'EAU').EAU
         AIF   ('&STRING' EQ 'WSF').WSF
.*             READS
         AIF   ('&STRING' EQ 'RB').RB
         AIF   ('&STRING' EQ 'RM').RM
         AIF   ('&STRING' EQ 'RMA').RMA
.*             3270 ORDERS
         AIF   ('&STRING' EQ 'SBA').SBA
         AIF   ('&STRING' EQ 'SF').SF
         AIF   ('&STRING' EQ 'SFE').SFE
         AIF   ('&STRING' EQ 'RA').RA
         AIF   ('&STRING' EQ 'RTA').RA
         AIF   ('&STRING' EQ 'IC').IC
         AIF   ('&STRING' EQ 'PT').PT
         AIF   ('&STRING' EQ 'HT').PT
         AIF   ('&STRING' EQ 'EUA').EUA
         AIF   ('&STRING' EQ 'SA').SA
         AIF   ('&STRING' EQ 'MF').MF
         AIF   ('&STRING' EQ 'MFA').MF
.*             ATTRIBUTES
         AIF   ('&STRING' EQ 'UNPLO').UNPLO
         AIF   ('&STRING' EQ 'UNPMD').UNPMD
         AIF   ('&STRING' EQ 'UNPHI').UNPHI
         AIF   ('&STRING' EQ 'UNPNP').UNPNP
         AIF   ('&STRING' EQ 'PROLO').PROLO
         AIF   ('&STRING' EQ 'PROLOS').PROLOS
         AIF   ('&STRING' EQ 'PROMD').PROMD
         AIF   ('&STRING' EQ 'PROMDS').PROMDS
         AIF   ('&STRING' EQ 'PROHI').PROHI
         AIF   ('&STRING' EQ 'PROHIS').PROHIS
.*             EXTENDED ATTRIBUTE TYPES
         AIF   ('&STRING' EQ 'FIELD').FIELD
         AIF   ('&STRING' EQ 'VALIDN').VALIDN
         AIF   ('&STRING' EQ 'OUTLIN').OUTLIN
         AIF   ('&STRING' EQ 'HILITE').HILITE
         AIF   ('&STRING' EQ 'COLOUR').COLOUR
         AIF   ('&STRING' EQ 'PGMSYM').PGMSYM
         AIF   ('&STRING' EQ 'BKCOLR').BKCOLR
         AIF   ('&STRING' EQ 'TRANSP').TRANSP
.*             HIGHLIGHTING
         AIF   ('&STRING' EQ 'NORMAL').NORMAL
         AIF   ('&STRING' EQ 'BLINK').BLINK
         AIF   ('&STRING' EQ 'REVERSE').REVERSE
         AIF   ('&STRING' EQ 'USCORE').USCORE
.*             COLOURS
         AIF   ('&STRING' EQ 'BLUE').BLUE
         AIF   ('&STRING' EQ 'RED').RED
         AIF   ('&STRING' EQ 'PINK').PINK
         AIF   ('&STRING' EQ 'GREEN').GREEN
         AIF   ('&STRING' EQ 'TURQ').TURQ
         AIF   ('&STRING' EQ 'YELLOW').YELLOW
         AIF   ('&STRING' EQ 'WHITE').WHITE
.*             TRANSPARENCIES
         AIF   ('&STRING' EQ 'OPAQUE').OPAQUE
.*             FORMAT CONTROL ORDERS
         AIF   ('&STRING' EQ 'NUL').NUL
         AIF   ('&STRING' EQ 'SUB').SUB
         AIF   ('&STRING' EQ 'DUP').DUP
         AIF   ('&STRING' EQ 'FM').FM
         AIF   ('&STRING' EQ 'FF').FF
         AIF   ('&STRING' EQ 'CR').CR
         AIF   ('&STRING' EQ 'NL').NL
         AIF   ('&STRING' EQ 'EM').EM
         AIF   ('&STRING' EQ 'EO').EO
         AIF   ('&STRING' EQ 'BYP').BYP
         AIF   ('&STRING' EQ 'RES').RES
         AIF   ('&STRING' EQ 'SI').SI
         AIF   ('&STRING' EQ 'SO').SO
.*             GRAPHIC ORDERS
         AIF   ('&STRING' EQ 'GBAR').GBAR
         AIF   ('&STRING' EQ 'GBIMG').GBIMG
         AIF   ('&STRING' EQ 'GCBIMG').GCBIMG
         AIF   ('&STRING' EQ 'GCHST').GCHST
         AIF   ('&STRING' EQ 'GCCHST').GCCHST
         AIF   ('&STRING' EQ 'GEAR').GEAR
         AIF   ('&STRING' EQ 'GEIMG').GEIMG
         AIF   ('&STRING' EQ 'GFLT').GFLT
         AIF   ('&STRING' EQ 'GCFLT').GCFLT
         AIF   ('&STRING' EQ 'GFARC').GFARC
         AIF   ('&STRING' EQ 'GCFARC').GCFARC
         AIF   ('&STRING' EQ 'GIMD').GIMD
         AIF   ('&STRING' EQ 'GLINE').GLINE
         AIF   ('&STRING' EQ 'GCLINE').GCLINE
         AIF   ('&STRING' EQ 'GMRK').GMRK
         AIF   ('&STRING' EQ 'GRLINE').GRLINE
         AIF   ('&STRING' EQ 'GCRLINE').GCRLINE
         AIF   ('&STRING' EQ 'GSBMX').GSBMX
         AIF   ('&STRING' EQ 'GSCA').GSCA
         AIF   ('&STRING' EQ 'GSCC').GSCC
         AIF   ('&STRING' EQ 'GSCD').GSCD
         AIF   ('&STRING' EQ 'GSCR').GSCR
         AIF   ('&STRING' EQ 'GSCS').GSCS
         AIF   ('&STRING' EQ 'GSCH').GSCH
         AIF   ('&STRING' EQ 'GSCOL').GSCOL
         AIF   ('&STRING' EQ 'GSECOL').GSECOL
         AIF   ('&STRING' EQ 'GSLT').GSLT
         AIF   ('&STRING' EQ 'GSLW').GSLW
         AIF   ('&STRING' EQ 'GSMC').GSMC
         AIF   ('&STRING' EQ 'GSMP').GSMP
         AIF   ('&STRING' EQ 'GSMS').GSMS
         AIF   ('&STRING' EQ 'GSMT').GSMT
         AIF   ('&STRING' EQ 'GSMX').GSMX
         AIF   ('&STRING' EQ 'GSPS').GSPS
         AIF   ('&STRING' EQ 'GSPT').GSPT
         AIF   ('&STRING' EQ 'GCOMT').GCOMT
         AIF   ('&STRING' EQ 'GSAP').GSAP
         AIF   ('&STRING' EQ 'GSCP').GSCP
         AIF   ('&STRING' EQ 'GSGCH').GSGCH
         AIF   ('&STRING' EQ 'GEPROL').GEPROL
         AIF   ('&STRING' EQ 'GESD').GESD
         AIF   ('&STRING' EQ 'GERASE').GERASE
         AIF   ('&STRING' EQ 'GSTOPDR').GSTOPDR
         AIF   ('&STRING' EQ 'GATTCUR').GATTCUR
         AIF   ('&STRING' EQ 'GDETCUR').GDETCUR
         AIF   ('&STRING' EQ 'GSETCUR').GSETCUR
         AIF   ('&STRING' EQ 'GSCUDEF').GSCUDEF
         AIF   ('&STRING' EQ 'GNOP1').GNOP1
.*             CONSTANTS
.*             IF THE OPERAND IS NONE OF THE ABOVE, IT IS
.*             PRESUMED TO BE ANY VALID 'DC' CONSTANT.
.DC      ANOP
&N       DC    &STRING
         AGO   .NEXT
.ESC     ANOP
&N       DC    X'27'               ESCAPE
         AGO   .NEXT
.GE      ANOP
&N       DC    X'08'               GRAPHIC ESCAPE
         AGO   .NEXT
.WR      ANOP
&N       DC    X'F1'               WRITE
         AGO   .NEXT
.EW      ANOP
&N       DC    X'F5'               ERASE/WRITE
         AGO   .NEXT
.EWA     ANOP
&N       DC    X'7E'               ERASE/WRITE ALTERNATE
         AGO   .NEXT
.EAU     ANOP
&N       DC    X'6F'               ERASE ALL UNPROTECTED
         AGO   .NEXT
.WSF     ANOP
&N       DC    X'F3'               WRITE STRUCTURED FIELD
         AGO   .NEXT
.RB      ANOP
&N       DC    X'F2'               READ BUFFER
         AGO   .NEXT
.RM      ANOP
&N       DC    X'F6'               READ MODIFIED
         AGO   .NEXT
.RMA     ANOP
&N       DC    X'6E'               READ MODIFIED ALL
         AGO   .NEXT
.SBA     ANOP
&N       DC    X'11'               SET BUFFER ADDRESS
         AGO   .NEXT
.SF      ANOP
&N       DC    X'1D'               START FIELD
         AGO   .NEXT
.RA      ANOP
&N       DC    X'3C'               REPEAT TO ADDRESS
         AGO   .NEXT
.IC      ANOP
&N       DC    X'13'               INSERT CURSOR
         AGO   .NEXT
.PT      ANOP
&N       DC    X'05'               PROGRAM TAB  (HORIZONTAL TAB)
         AGO   .NEXT
.EUA     ANOP
&N       DC    X'12'               ERASE UNPROTECTED TO ADDRESS
         AGO   .NEXT
.SA      ANOP
&N       DC    X'28'               SET ATTRIBUTE
         AGO   .NEXT
.SFE     ANOP
&N       DC    X'29'               START FIELD EXTENDED
         AGO   .NEXT
.MF      ANOP
&N       DC    X'2C'               MODIFY FIELD ATTRIBUTES
         AGO   .NEXT
.UNPLO   ANOP
&N       DC    X'40'               UNPROTECTED NORMAL INTENSITY
         AGO   .NEXT
.UNPMD   ANOP
&N       DC    X'C4'               UNPROTECTED MEDIUM INTENSITY
         AGO   .NEXT
.UNPHI   ANOP
&N       DC    X'C8'               UNPROTECTED HIGH INTENSITY
         AGO   .NEXT
.UNPNP   ANOP
&N       DC    X'4C'               UNPROTECTED NO-DISPLAY
         AGO   .NEXT
.PROLO   ANOP
&N       DC    X'60'               PROTECTED NORMAL INTENSITY
         AGO   .NEXT
.PROLOS  ANOP
&N       DC    X'F0'               PROTECTED NORMAL INTENSITY SKIP
         AGO   .NEXT
.PROMD   ANOP
&N       DC    X'E4'               PROTECTED MEDIUM INTENSITY
         AGO   .NEXT
.PROMDS  ANOP
&N       DC    X'F4'               PROTECTED MEDIUM INTENSITY SKIP
         AGO   .NEXT
.PROHI   ANOP
&N       DC    X'E8'               PROTECTED HIGH INTENSITY
         AGO   .NEXT
.PROHIS  ANOP
&N       DC    X'F8'               PROTECTED HIGH INTENSITY SKIP
         AGO   .NEXT
.FIELD   ANOP
&N       DC    X'C0'               3270 FIELD ATTRIBUTE
         AGO   .NEXT
.VALIDN  ANOP
&N       DC    X'C1'               FIELD VALIDATION
         AGO   .NEXT
.OUTLIN  ANOP
&N       DC    X'C2'               FIELD OUTLINING
         AGO   .NEXT
.HILITE  ANOP
&N       DC    X'41'               EXTENDED HIGHLIGHTING
         AGO   .NEXT
.COLOUR  ANOP
&N       DC    X'42'               EXTENDED COLOUR
         AGO   .NEXT
.PGMSYM  ANOP
&N       DC    X'43'               PROGRAMMED SYMBOLS
         AGO   .NEXT
.BKCOLR  ANOP
&N       DC    X'45'               BACKGROUND COLOUR
         AGO   .NEXT
.TRANSP  ANOP
&N       DC    X'46'               BACKGROUND TRANSPARENCY
         AGO   .NEXT
.NORMAL  ANOP
&N       DC    X'00'               CHARACTER ATTRIBUTE RESET (DEFAULT)
         AGO   .NEXT
.BLINK   ANOP
&N       DC    X'F1'               BLINK HIGHLIGHTING
         AGO   .NEXT
.REVERSE ANOP
&N       DC    X'F2'               REVERSE VIDEO HIGHLIGHTING
         AGO   .NEXT
.USCORE  ANOP
&N       DC    X'F4'               UNDERSCORE HIGHLIGHTING
         AGO   .NEXT
.BLUE    ANOP
&N       DC    X'F1'               BLUE COLOUR
         AGO   .NEXT
.RED     ANOP
&N       DC    X'F2'               RED COLOUR
         AGO   .NEXT
.PINK    ANOP
&N       DC    X'F3'               PINK COLOUR
         AGO   .NEXT
.GREEN   ANOP
&N       DC    X'F4'               GREEN COLOUR
         AGO   .NEXT
.TURQ    ANOP
&N       DC    X'F5'               TURQUOISE COLOUR
         AGO   .NEXT
.YELLOW  ANOP
&N       DC    X'F6'               YELLOW COLOUR
         AGO   .NEXT
.WHITE   ANOP
&N       DC    X'F7'               WHITE COLOUR
         AGO   .NEXT
.OPAQUE  ANOP
&N       DC    X'FF'               OPAQUE (NON-TRANSPARENT)
         AGO   .NEXT
.NUL     ANOP
&N       DC    X'00'               NULL
         AGO   .NEXT
.SUB     ANOP
&N       DC    X'3F'               SUBSTITUTE
         AGO   .NEXT
.DUP     ANOP
&N       DC    X'1C'               DUPLICATE
         AGO   .NEXT
.FM      ANOP
&N       DC    X'1E'               FIELD MARK
         AGO   .NEXT
.FF      ANOP
&N       DC    X'0C'               FORM FEED
         AGO   .NEXT
.CR      ANOP
&N       DC    X'0D'               CARRIAGE RETURN
         AGO   .NEXT
.NL      ANOP
&N       DC    X'15'               NEW LINE
         AGO   .NEXT
.EM      ANOP
&N       DC    X'19'               END OF MESSAGE
         AGO   .NEXT
.EO      ANOP
&N       DC    X'FF'               EIGHT ONES
         AGO   .NEXT
.BYP     ANOP
&N       DC    X'24'               BYPASS  (INHIBIT PRESENTATION)
         AGO   .NEXT
.RES     ANOP
&N       DC    X'14'               RESTORE  (ENABLE PRESENTATION)
         AGO   .NEXT
.SI      ANOP
&N       DC    X'0F'               SHIFT IN
         AGO   .NEXT
.SO      ANOP
&N       DC    X'0E'               SHIFT OUT
         AGO   .NEXT
.GBAR    ANOP
&N       DC    X'68'               BEGIN AREA
         AGO   .NEXT
.GBIMG   ANOP
&N       DC    X'D1'               BEGIN IMAGE
         AGO   .NEXT
.GCBIMG  ANOP
&N       DC    X'91'               BEGIN IMAGE
         AGO   .NEXT
.GCHST   ANOP
&N       DC    X'C3'               CHARACTER STRING
         AGO   .NEXT
.GCCHST  ANOP
&N       DC    X'83'               CHARACTER STRING
         AGO   .NEXT
.GEAR    ANOP
&N       DC    X'60'               END AREA
         AGO   .NEXT
.GEIMG   ANOP
&N       DC    X'93'               END IMAGE
         AGO   .NEXT
.GFLT    ANOP
&N       DC    X'C5'               FILLET
         AGO   .NEXT
.GCFLT   ANOP
&N       DC    X'85'               FILLET
         AGO   .NEXT
.GFARC   ANOP
&N       DC    X'C7'               FULL ARC
         AGO   .NEXT
.GCFARC  ANOP
&N       DC    X'87'               FULL ARC
         AGO   .NEXT
.GIMD    ANOP
&N       DC    X'92'               IMAGE DATA
         AGO   .NEXT
.GLINE   ANOP
&N       DC    X'C1'               LINE
         AGO   .NEXT
.GCLINE  ANOP
&N       DC    X'81'               LINE
         AGO   .NEXT
.GMRK    ANOP
&N       DC    X'C3'               MARKER
         AGO   .NEXT
.GRLINE  ANOP
&N       DC    X'E1'               RELATIVE LINE
         AGO   .NEXT
.GCRLINE ANOP
&N       DC    X'A1'               RELATIVE LINE
         AGO   .NEXT
.GSBMX   ANOP
&N       DC    X'0D'               SET BACKGROUND MIX
         AGO   .NEXT
.GSCA    ANOP
&N       DC    X'34'               SET CHARACTER ANGLE
         AGO   .NEXT
.GSCC    ANOP
&N       DC    X'33'               SET CHARACTER CELL
         AGO   .NEXT
.GSCD    ANOP
&N       DC    X'3A'               SET CHARACTER DIRECTION
         AGO   .NEXT
.GSCR    ANOP
&N       DC    X'39'               SET CHARACTER PRECISION
         AGO   .NEXT
.GSCS    ANOP
&N       DC    X'38'               SET CHARACTER SET
         AGO   .NEXT
.GSCH    ANOP
&N       DC    X'35'               SET CHARACTER SHEAR
         AGO   .NEXT
.GSCOL   ANOP
&N       DC    X'0A'               SET COLOUR
         AGO   .NEXT
.GSECOL  ANOP
&N       DC    X'26'               SET EXTENDED COLOUR
         AGO   .NEXT
.GSLT    ANOP
&N       DC    X'18'               SET LINE TYPE
         AGO   .NEXT
.GSLW    ANOP
&N       DC    X'19'               SET LINE WIDTH
         AGO   .NEXT
.GSMC    ANOP
&N       DC    X'37'               SET MARKER CELL
         AGO   .NEXT
.GSMP    ANOP
&N       DC    X'3B'               SET MARKER PRECISION
         AGO   .NEXT
.GSMS    ANOP
&N       DC    X'3C'               SET MARKER SET
         AGO   .NEXT
.GSMT    ANOP
&N       DC    X'29'               SET MARKER SYMBOL
         AGO   .NEXT
.GSMX    ANOP
&N       DC    X'0C'               SET MIX
         AGO   .NEXT
.GSPS    ANOP
&N       DC    X'08'               SET PATTERN SET
         AGO   .NEXT
.GSPT    ANOP
&N       DC    X'28'               SET PATTERN SYMBOL
         AGO   .NEXT
.GCOMT   ANOP
&N       DC    X'01'               COMMENT
         AGO   .NEXT
.GSAP    ANOP
&N       DC    X'22'               SET ARC PARAMETERS
         AGO   .NEXT
.GSCP    ANOP
&N       DC    X'21'               SET CURRENT POSITION
         AGO   .NEXT
.GSGCH   ANOP
&N       DC    X'04'               SEGMENT CHARACTERISTICS
         AGO   .NEXT
.GEPROL  ANOP
&N       DC    X'3E'               END PROLOGUE
         AGO   .NEXT
.GESD    ANOP
&N       DC    X'FF'               END OF SYMBOL DEFINITION
         AGO   .NEXT
.GERASE  ANOP
&N       DC    X'0A'               ERASE GRAPHIC PRESENTATION SPACE
         AGO   .NEXT
.GSTOPDR ANOP
&N       DC    X'0F'               STOP DRAW
         AGO   .NEXT
.GATTCUR ANOP
&N       DC    X'08'               ATTACH GRAPHIC CURSOR
         AGO   .NEXT
.GDETCUR ANOP
&N       DC    X'09'               DETACH GRAPHIC CURSOR
         AGO   .NEXT
.GSETCUR ANOP
&N       DC    X'31'               SET GRAPHIC CURSOR POSITION
         AGO   .NEXT
.GSCUDEF ANOP
&N       DC    X'21'               SET CURRENT DEFAULTS
         AGO   .NEXT
.GNOP1   ANOP
&N       DC    X'00'               NO OPERATION
         AGO   .NEXT
.**********************************************************************
.PAIR    ANOP
         AIF   (N'&SYSLIST(&AS) NE 2).PERR1
&NUMERIC SETB  (T'&SYSLIST(&AS,1) EQ 'N')
&INTEGER SETB  ('&SYSLIST(&AS,1)'(1,1) GE '0')
         AIF   (NOT &NUMERIC OR NOT &INTEGER).PERR2
&R       SETA  &SYSLIST(&AS,1)
&NUMERIC SETB  (T'&SYSLIST(&AS,2) EQ 'N')
&INTEGER SETB  ('&SYSLIST(&AS,2)'(1,1) GE '0')
         AIF   (NOT &NUMERIC OR NOT &INTEGER).PERR2
&C       SETA  &SYSLIST(&AS,2)
         AIF   (&R LT 1 OR &R GT 24).ROWERR
         AIF   (&C LT 1 OR &C GT 80).COLERR
&P       SETA  (&R-1)*80+&C-1
&Q       SETA  &P/64               QUOTIENT
&R       SETA  &P-&Q*64+1          REMAINDER+1
&Q       SETA  &Q+1                QUOTIENT+1
&N       DC    X'&T(&Q)&T(&R)'     ROW AND COLUMN
         AGO   .NEXT
.PERR1   MNOTE 4,'             &CS.) PARENS FOUND BUT NOT 2 NUMBERS'
         MEXIT
.PERR2   MNOTE 4,'             &CS.) NON NUMERIC ROW/COLUMN'
         MEXIT
.**********************************************************************
.ROWCOL  ANOP
         AIF   (&B).COL            BRANCH IF ROW HAS BEEN CAPTURED
&R       SETA  &SYSLIST(&AS)
&B       SETB  1 TRUE              SET ROW-HAS-BEEN-CAPTURED
         AGO   .NEXTR
.COL     ANOP
&C       SETA  &SYSLIST(&AS)
&B       SETB  0 FALSE             RESET SWITCH
         AIF   (&R LT 1 OR &R GT 24).ROWERR
         AIF   (&C LT 1 OR &C GT 80).COLERR
&P       SETA  (&R-1)*80+&C-1
&Q       SETA  &P/64               QUOTIENT
&R       SETA  &P-&Q*64+1          REMAINDER+1
&Q       SETA  &Q+1                QUOTIENT+1
&N       DC    X'&T(&Q)&T(&R)'     ROW AND COLUMN
         AGO   .NEXT
.ROWERR  MNOTE 4,'             &CS.) VALUE &R INVALID, MUST BE 1 TO 24'
         AGO   .NEXT
.COLERR  MNOTE 4,'             &CS.) VALUE &C INVALID, MUST BE 1 TO 80'
.NEXT    ANOP
&N       SETC  ''                  TURN OFF NAME
.NEXTR   ANOP
&AN      SETA  &AN-1
         AGO   .EACH
.EPILOG  ANOP
         MEND
./ ADD NAME=GTTERM
         MACRO
&NAME    GTTERM &PRMSZE=,&ALTSZE=,&ATTRIB=,&TERMID=,&MF=I      @G76XRYU
.*                                                             @OW03892
.* A000000-999999                                              @G76XR00
.* A034000                                                     @OZ90350
.* NOCHANGE SHIPPED WITH JCLIN                                 @OY20024
.* NOCHANGE SHIPPED WITH JCLIN                                 @OY26821
.* ADDED TERMID PARAMETER                                      @OW03892
.*
         LCLC  &NDX                                            @G76XRYU
&NDX     SETC  '&SYSNDX'                                       @G76XRYU
         AIF   ('&MF' EQ 'I' AND '&PRMSZE' EQ '' AND '&ATTRIB' EQ '' AN-
               D '&TERMID' EQ '').ERROR1              @G76XRYU @OW03892
         AIF   ('&MF' EQ 'L').LFORM
         AIF   ('&MF(1)' EQ 'E').EFORM
         AIF   ('&MF' NE 'I').ERROR2
.*********************I -FORM OF MACRO*********************************
&NAME    CNOP  0,4
         BAL   1,*+20                   BRANCH AROUND PARMS    @G76XRYU
.*                                                             @OW03892
GTRM&NDX DC    A(0)                     ADDRESS OF PRIMARY     @G76XRYU
         DC    A(0)                     ADDRESS OF ALTERNATE
         DC    A(0)                     ADDRESS OF ATTRIBUTE   @G76XRYU
         DC    A(0)                     ADDRESS OF TERMINAL ID @OW03892
         AGO   .STADDR
.EFORM   ANOP
&NAME    CNOP  0,4                                             @OZ90350
         IHBOPLST ,,&NAME,MF=&MF
.STADDR  ANOP
.*********COMMON CODE FOR BOTH I AND E FORM OF MACRO******************
         AIF   ('&PRMSZE' EQ '').LABEL2
         AIF   ('&PRMSZE'(1,1) NE '(').LOADPRM
         ST    &PRMSZE(1),0(,1)         STORE PRIMARY ADDRESS
         AGO   .LABEL2
.LOADPRM ANOP
         AIF   ('&PRMSZE'(K'&PRMSZE,1) EQ ')' OR '&MF' NE 'I').LPARM
         ORG   GTRM&NDX                 PUT ADDR OF PRIMARY    @G76XRYU
         DC    A(&PRMSZE)               IN PARM LIST           @G76XRYU
         ORG
         AGO   .LABEL2                                         @G76XRYU
.LPARM   ANOP                      ..LA ADDR OR EXECUTE FORM   @G76XRYU
         LA    0,&PRMSZE                LOAD ADDRESS OF PRIMARY
         ST    0,0(,1)                  STORE ADDRESS OF PRIMARY
.LABEL2  ANOP
         AIF   ('&ALTSZE' EQ '').IEATRCK                       @G76XRYU
         AIF   ('&ALTSZE'(1,1) NE '(').LOADALT
         ST    &ALTSZE(1),4(,1)         STORE ADDRESS OF ALTERNATE
         AGO   .IEATRCK                                        @G76XRYU
.LOADALT ANOP
         AIF   ('&ALTSZE'(K'&ALTSZE,1) EQ ')' OR '&MF' NE 'I').LAALT
         ORG   GTRM&NDX+4               PUT ALTERNATE SIZE     @G76XRYU
         DC    A(&ALTSZE)               IN PARM LIST           @G76XRYU
         ORG
         AGO   .IEATRCK                                        @G76XRYU
.LAALT   ANOP                     ...LA ADDR OR EXECUTE FORM   @G76XRYU
         LA    0,&ALTSZE                LOAD ADDR OF ALTERNATE @G76XRYU
         ST    0,4(,1)                  STORE ADD OF ALTERNATE @G76XRYU
.*  PROCESS ATTRIBUTE PARM FOR I AND E FORMS WHEN NOT NULL     @G76XRYU
.IEATRCK ANOP                                                  @G76XRYU
         AIF   ('&ATTRIB' EQ '').LABEL3               @G76XRYU @OW03892
         AIF   ('&ATTRIB'(1,1) EQ '(').REGATR                  @G76XRYU
         AIF   ('&ATTRIB'(K'&ATTRIB,1) EQ ')' OR '&MF' NE 'I').LAATRIB
         ORG   GTRM&NDX+8               PUT ATTRIB BYTE ADDR   @G76XRYU
         DC    A(&ATTRIB)               IN PARM LIST           @G76XRYU
         ORG
         AGO   .LABEL3                                @G76XRYU @OW03892
.LAATRIB ANOP                       .. LA ADDR OR EXECUTE FORM @G76XRYU
         LA    0,&ATTRIB                GET ADR OF ATTRIB BYTE @G76XRYU
         ST    0,8(1)                   PUT IN 3RD PARM WORD   @G76XRYU
         AGO   .LABEL3                                @G76XRYU @OW03892
.REGATR  ANOP                                                  @G76XRYU
         ST    &ATTRIB(1),8(1)          REG => 3RD PARM WORD   @G76XRYU
.*  PROCESS TERMINAL ID PARM FOR I AND E FORMS WHEN NOT NULL   @OW03892
.LABEL3  ANOP                                                  @OW03892
         AIF   ('&TERMID' EQ '').SVCENTY                       @OW03892
         AIF   ('&TERMID'(1,1) NE '(').LOTRMID                 @OW03892
         ST    &TERMID(1),12(,1)        STORE PRIMARY ADDRESS  @OW03892
         OI    12(1),128                END OF LIST INDICATOR  @OW03892
         AGO   .SVCENT2                                        @OW03892
.LOTRMID ANOP                                                  @OW03892
         AIF   ('&TERMID'(K'&TERMID,1) EQ ')' OR '&MF' NE 'I').LTERM
.*                                                             @OW03892
         ORG   GTRM&NDX+12              PUT ADDR OF TERMID IN  @OW03892
         DC    XL1'80',AL3(&TERMID)     PARM LIST WITH END OF  @OW03892
.*                                      LIST INDICATOR         @OW03892
         ORG
         AGO   .SVCENT2                                        @OW03892
.LTERM   ANOP                      ..LA ADDR OR EXECUTE FORM   @OW03892
         LA    0,&TERMID                LOAD ADDRESS OF TERMINAL ID
.*                                                             @OW03892
         ST    0,12(,1)                 STORE ADDRESS OF TERMINAL ID
.*                                                             @OW03892
         OI    12(1),128                END OF LIST INDICATOR  @OW03892
         AGO   .SVCENT2                                        @OW03892
.SVCENTY ANOP
         OI    8(1),128                 END OF LIST INDICATOR  @G76XRYU
.SVCENT2 ANOP
         LA    0,17                     ENTRY CODE
         SLL   0,24                     SHIFT TO HIGH ORDER BYTE
         SVC   94                       ISSUE SVC
         MEXIT
.***************  L  - FORM  ***************************
.LFORM   ANOP
&NAME    DS    0F
         AIF   ('&PRMSZE' EQ '').NOPRMAD
         AIF   ('&PRMSZE'(1,1) EQ '(').NOPRMAD
         DC    A(&PRMSZE)               ADDRESS OF PRIMARY PARM ADDR
         AGO   .CHKALT
.NOPRMAD ANOP
         DC    A(0)                     ADDRESS OF PRIMARY PARM ADDR
.CHKALT  AIF   ('&ALTSZE' EQ '').NOALTAD
         AIF   ('&ALTSZE'(1,1) EQ '(').NOALTAD
         DC    A(&ALTSZE)               ADDRESS OF ALTERNATE ADDR
         AGO   .LATTCK                                         @G76XRYU
.NOALTAD ANOP
         DC    A(0)                     ADDR OF ALTERNATE      @G76XRYU
.*  PROCESS ATTRIBUTE PARM FOR LIST FORM                       @G76XRYU
.LATTCK  ANOP                                                  @G76XRYU
         AIF   ('&ATTRIB' NE '').CKATTR                        @G76XRYU
         DC    A(0)                     L-FORM--ATTRIB BYTE    @G76XRYU
         AGO   .CKTERM                                @G76XRYU @OW03892
.CKATTR  ANOP                                                  @G76XRYU
         AIF   ('&ATTRIB'(1,1) NE '(').ATTROK                  @G76XRYU
         MNOTE 12,'IHB300 INCOMPATIBLE OPERANDS: MF=L AND ATTRIB=&ATTRI*
               B'                                              @G76XRYU
         AGO   .CKTERM                                @G76XRYU @OW03892
.ATTROK  ANOP                                                  @G76XRYU
         DC    A(&ATTRIB)               L-FORM--A(ATTR BYTE)   @G76XRYU
         AGO   .CKTERM                                         @OW03892
.CKTERM  AIF   ('&TERMID' EQ '').NOTRMAD                       @OW03892
         AIF   ('&TERMID'(1,1) EQ '(').NOTRMAD                 @OW03892
         DC    A(&TERMID)               ADDRESS OF TERMINAL ID ADDR
.*                                                             @OW03892
         MEXIT                                                 @OW03892
.NOTRMAD ANOP                                                  @OW03892
         DC    A(0)                     ADDRESS OF TERMINAL ID ADDR
.*                                                             @OW03892
         MEXIT                                                 @OW03892
.ERROR1  ANOP
         IHBERMAC 1006,PRMSZE
         MEXIT
.ERROR2  IHBERMAC 54,,&MF
         MEXIT
         MEND
./ ENDUP
/*
//ASM     EXEC PGM=IFOX00,PARM='NODECK,LOAD,TERM'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=&&MACLIB,DISP=(OLD,DELETE)
//         DD  DSN=SYS1.MACLIB,DISP=SHR
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  *
TERMTEST TITLE ' TERMINAL CHARACTERISTICS TEST PROGRAM FOR TSO '
***********************************************************************
*                                                                     *
*     WRITTEN 24 AUGUST 1987 BY GREG PRICE OF PRYCROFT SIX PTY LTD.   *
*                                                                     *
*     TERMINAL TESTING AND FULLSCREEN PROGRAM DEVELOPMENT TOOL FOR    *
*     3270-FAMILY AND COMPATIBLE TERMINALS.                           *
*                                                                     *
*     OPERATIONAL ENVIRONMENT:                                        *
*     1) TSO OR TSO/E UNDER ANY RELEASE OF MVS (IBM OS/VS2).          *
*     2) TSS OR TSS/E UNDER ANY RELEASE OF MSP (FUJITSU OSIV/F4).     *
*                                                                     *
*     OPERATIONAL CHARACTERISTICS:                                    *
*        STRICTLY 24-BIT MODE ADDRESSING AND RESIDENCY.               *
*        TERMTEST IS NEITHER RE-ENTRANT NOR SERIALLY REUSEABLE.       *
*        TERMTEST USES TGET, TPUT AND TPG MACROS TO TRANSMIT TO       *
*        AND RECEIVE FROM THE TERMINAL BOTH FULLSCREEN DATA AND       *
*        STRUCTURED FIELD INFORMATION.                                *
*        TERMTEST MAY BE CALLED AS A PROGRAM OR INVOKED AS A          *
*        COMMAND PROCESSOR.                                           *
*                                                                     *
*     INSTALLATION RECOMENDATION:                                     *
*        INSTALL INTO LINKLIST SO THAT ANY USER CAN USE IT ON         *
*        HIS/HER OWN TERMINAL WHILE IN DIAGNOSTIC TELEPHONIC          *
*        DIALOG WITH SYSTEM/NETWORK SUPPORT.                          *
*        (EG. IS THE QUERY BIT ON?                                    *
*             WHAT SCREEN SIZES DOES THE LOGMODE ALLOW?               *
*             WHICH APL CHARACTERS ARE CORRECTLY SUPPORTED?           *
*             ETC.)                                                   *
*                                                                     *
*     NEEDLESS TO SAY, FULL-SCREEN PROGRAM DEVELOPERS MAY FIND        *
*     TERMTEST HANDY TO DETERMINE OR VERIFY THE CODES FOR             *
*     SPECIFIC SCREEN LOCATIONS, GRAPHIC CHARACTERS AND ATTENTION     *
*     IDENTIFIERS.  ON THE OTHER HAND, SOMEONE MAY JUST WANT TO       *
*     PLAY AROUND WITH FEATURES OF THE TERMINAL HARDWARE.             *
*                                                                     *
*     FILE PROCESSING:                                                *
*     1) ISPPROF (PARTITIONED - BPAM) -                               *
*        THE MEMBER 'PROGSYMA' OF THIS FILE IS USED TO SAVE           *
*        USER-DESIGNED SYMBOLS ON DISK BETWEEN TERMTEST SESSIONS.     *
*     2) SYSPUNCH (SEQUENTIAL - QSAM) -                               *
*        THIS IS AN OUTPUT-ONLY CARD IMAGE FILE.  THE 'PUNCH'         *
*        AND 'PUNCHX' TERMTEST SUBCOMMANDS INITIATE THE WRITING       *
*        OF THE ASSEMBLER SOURCE FOR THE USER-DESIGNED SYMBOLS        *
*        TO THIS FILE, THUS MAKING THOSE SYMBOLS AVAILABLE FOR        *
*        USE IN USER-WRITTEN ASSEMBLER FULL-SCREEN APPLICATIONS.      *
*     THE FILES WILL NOT BE USED UNLESS THEY ARE ALLOCATED BEFORE     *
*     THE TERMTEST SESSION.                                           *
*                                                                     *
*     ASSEMBLER ENVIRONMENT:                                          *
*     1) MVS.                                                         *
*        TERMTEST REQUIRES MACROS FROM SYS1.MACLIB                    *
*        AND THE LOCAL 'DCS' AND 'TERMTYPE' MACROS.                   *
*     2) MSP.                                                         *
*        TERMTEST REQUIRES MACROS FROM SYS1.MACLIB                    *
*        AND THE LOCAL 'DCS' MACRO.                                   *
*        REMOVE THE TERMID OPERAND FROM THE GTTERM MACRO.             *
*        (TERMTYPE IS IN SYS1.MACLIB.)                                *
*                                                                     *
*     RELEASE DETAILS:                                                *
*        4.0  -  24  OCTOBER    1988                                  *
*        5.0  -  03  JANUARY    1990                                  *
*        6.0  -  18  JUNE       1990                                  *
*        7.0  -  25  SEPTEMBER  1990                                  *
*        8.0  -  23  NOVEMBER   1990                                  *
*        9.0  -  18  MARCH      1991                                  *
*        9.1  -  20  JUNE       1991                                  *
*        9.2  -  16  JUNE       1992                                  *
*        9.3  -  26  JUNE       1992                                  *
*        9.4  -  22  JULY       1992                                  *
*       10.0  -  12  OCTOBER    1993                                  *
*       10.1  -  07  JULY       1995                                  *
*       11.0  -  29  NOVEMBER   1996                                  *
*       11.1  -  04  DECEMBER   1999                                  *
*       11.2  -  10  APRIL      2001                                  *
*       11.3  -  17  OCTOBER    2003  -  FIX SB00 ABEND.              *
*                                                                     *
***********************************************************************
         LCLC  &TRMDATE
         LCLC  &DD
         LCLC  &MM
         LCLC  &YY
         LCLC  &REL
&TRMDATE SETC  '&SYSDATE'
         AIF   ('&TRMDATE'(3,1) NE '/').GOTDATE
&MM      SETC  '&TRMDATE'(1,2)          GET MM.
&DD      SETC  '&TRMDATE'(4,2)          GET DD.
&YY      SETC  '&TRMDATE'(7,2)          GET YY.
&TRMDATE SETC  '&YY..&MM..&DD'          GET YY.MM.DD (FACOM &SYSDATE).
.GOTDATE ANOP
&REL     SETC  '11.3'                   TERMTEST RELEASE NUMBER.
TERMTEST CSECT
         STM   R14,R12,12(R13)    SAVE REGISTERS.
         LR    R12,R15            BASE REGISTERS.
         LA    R11,2048(,R12)
         LA    R11,2048(,R11)
         LA    R10,2048(,R11)
         LA    R10,2048(,R10)
         LA    R9,2048(,R10)
         LA    R9,2048(,R9)
         USING TERMTEST,R12,R11,R10,R9
         L     R1,=V(TERMBUFR)
         ST    R1,8(,R13)         CHAIN SAVE AREAS.
         ST    R13,4(,R1)
         LR    R13,R1             POINT TO DYNAMIC AREA.
         USING TERMBUFR,R13
         MVC   WSFPSA,PSAWSF      INITIALIZE PSA WSF DATA.
         LA    R2,((X'EA'-X'41')*18)  LOAD PSA SAMPLE SYMBOLS OFFSET.
         LA    R2,BPAMBUFR(R2)    GET CORRESPONDING SPOT IN WHOLE SET.
         MVC   0(256,R2),PRIMEPSA LOAD FIRST 256 BYTES OF PRIMER.
         MVC   256(PRIMELEN-256,R2),PRIMEPSA+256 LOAD THE REST.
         SLR   R5,R5
         L     R4,540             GET POINTER TO CURRENT TCB.
         L     R4,12(,R4)         POINT TO TIOT.
         LA    R4,24(,R4)         POINT TO TIOELNGH.
CHKDDNAM CLC   4(8,R4),ISPPROF+DCBDDNAM-IHADCB
         BE    OPENFILE           FILE EXISTS SO GO AND OPEN IT.
         IC    R5,0(,R4)          GET TIOT ENTRY LENGTH.
         AR    R4,R5              POINT TO NEXT TIOT ENTRY.
         CLI   0(R4),0            ZERO LENGTH ENTRY?
         BNE   CHKDDNAM           NO, CHECK OUT THIS ENTRY.
         B     NOEDINIT           YES, NOT IN TIOT SO NO PSA PROFILE.
OPENFILE OPEN (ISPPROF,(INPUT)),MF=(E,OPNCLOSE)
         LA    R0,BILDLIST        POINT TO BLDL PARAMETERS.
         BLDL  ISPPROF,(0)        VERIFY EXISTENCE OF MEMBER PROGSYMA.
         LTR   R15,R15            DOES MEMBER PROGSYMA EXIST?
         BNZ   EODAD              NO.
         CLI   BILDK,0            MEMBER FROM A CONCATENATION?
         BNE   CLOSEIN            YES, CAN'T WRITE TO IT.
         FIND  ISPPROF,BILDTTR,C  POINT TO MEMBER FOR FIRST READ.
         SLR   R3,R3              ZERO INDEX.
PSAINPUT LA    R2,BPAMBUFR(R3)    POINT TO BUFFER AREA.
         READ  DYNDECB,SF,,(2),'S',MF=E
         CHECK DYNDECB            WAIT FOR THE READ.
         TM    PROFSW,IOERR       I/O ERROR?
         BO    IOERROR            YES.
         LH    R2,ISPPROF+DCBBLKSI-IHADCB
         L     R1,DYNDECB+16      POINT TO THE IOB.
         SH    R2,14(,R1)         GET LENGTH OF BLOCK READ.
         AR    R3,R2              ACCUMULUATE BYTE COUNT SO FAR.
         CH    R3,MEMBRSIZ        READ ENOUGH YET?
         BL    PSAINPUT           NO, READ ANOTHER BLOCK.
         OI    PROFSW,SYMA        REMEMBER THAT MEMBER WAS READ OKAY.
EODAD    OI    PROFSW,DDOK        SEEMS LIKE FILE IS GOOD.
CLOSEIN  CLOSE ISPPROF,MF=(E,OPNCLOSE)
NOPROF   TM    PROFSW,DDOK        USEABLE PROFILE FILE?
         BZ    NOEDINIT           NO, LEAVE NOSAVMSG AS IS.
         MVC   NOSAVMSG+1(L'NOSAVMSG-1),NOSAVMSG YES, CAN SAVE UPDATES.
NOEDINIT MVC   NOEDDATA(2),WRTWCC INITIALIZE NOEDIT DATA FOR LATER.
         GTSIZE
         CVD   R0,WORK            DISPLAY THE NUMBER OF LINES.
         MVC   LINSMSG,ED3
         ED    LINSMSG,WORK+6
         CVD   R1,WORK            DISPLAY THE NUMBER OF COLUMNS.
         MVC   COLSMSG,ED3
         ED    COLSMSG,WORK+6
         STM   R15,R1,WORK        SAVE GTSIZE RESULTS.
         UNPK  GTSIZERC(9),WORK(5)
         TR    GTSIZERC,HEX-C'0'
         MVI   GTSIZERC+8,C' '
         UNPK  GTSIZER0(9),WORK+4(5)
         TR    GTSIZER0,HEX-C'0'
         MVI   GTSIZER0+8,C' '
         UNPK  GTSIZER1(9),WORK+8(5)
         TR    GTSIZER1,HEX-C'0'
         MVI   GTSIZER1+8,C' '
         STM   R0,R1,LINES        SAVE CURRENT SCREEN SIZE.
         CH    R0,=H'24'          AT LEAST 24 LINES?
         BL    SCRNNOGO           NO, NOT BIG ENOUGH.
         CH    R1,=H'80'          AT LEAST 80 COLUMNS?
         BL    SCRNNOGO           NO, NOT BIG ENOUGH.
         BE    GETTERM            80-COLUMN 12-BIT ADDRS PRE-CODED.
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW2
         STCM  R0,3,PAGROW2
         SLL   R1,1
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW3
         STCM  R0,3,HLPROW3
         STCM  R0,3,NEWROW3
         STCM  R0,3,PAGROW3
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW4
         STCM  R0,3,NEWROW4
         STCM  R0,3,PAGROW4
         LR    R15,R1
         LA    R1,1(,R1)
         BAL   R14,CALCPOSI
         STCM  R0,3,INSRTCSR
         LR    R1,R15
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW5
         STCM  R0,3,HLPROW5
         STCM  R0,3,NEWROW5
         STCM  R0,3,PAGROW5
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW6
         STCM  R0,3,HLPROW6
         STCM  R0,3,NEWROW6
         STCM  R0,3,PAGROW6
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW7
         STCM  R0,3,HLPROW7
         STCM  R0,3,NEWROW7
         STCM  R0,3,PAGROW7
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW8
         STCM  R0,3,HLPROW8
         STCM  R0,3,NEWROW8
         STCM  R0,3,PAGROW8
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW9
         STCM  R0,3,HLPROW9
         STCM  R0,3,NEWROW9
         STCM  R0,3,PAGROW9
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW10
         STCM  R0,3,HLPROW10
         STCM  R0,3,NEWROW10
         STCM  R0,3,PAGROW10
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW11
         STCM  R0,3,HLPROW11
         STCM  R0,3,NEWROW11
         STCM  R0,3,PAGROW11
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW12
         STCM  R0,3,HLPROW12
         STCM  R0,3,NEWROW12
         STCM  R0,3,PAGROW12
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW13
         STCM  R0,3,HLPROW13
         STCM  R0,3,NEWROW13
         STCM  R0,3,PAGROW13
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW14
         STCM  R0,3,HLPROW14
         STCM  R0,3,NEWROW14
         STCM  R0,3,PAGROW14
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW15
         STCM  R0,3,NEWROW15
         STCM  R0,3,PAGROW15
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW16
         STCM  R0,3,HLPROW16
         STCM  R0,3,NEWROW16
         STCM  R0,3,PAGROW16
         LR    R15,R1
         LA    R1,7*80(,R1)
         BAL   R14,CALCPOSI
         STCM  R0,3,HILITTRL
         LR    R1,R15
         LA    R1,8*80+SACOLRLN-21(,R1)
         BAL   R14,CALCPOSI
         STCM  R0,3,CROSPOSI
         LR    R1,R15
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,SYMROW17
         STCM  R0,3,HLPROW17
         STCM  R0,3,NEWROW17
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,NEWROW18
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW19
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW20
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW21
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW22
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW23
         A     R1,COLUMNS
         BAL   R14,CALCPOSI
         STCM  R0,3,HLPROW24
GETTERM  GTTERM PRMSZE=PRIMSIZE,ALTSZE=ALTSIZE,ATTRIB=TERMATTR,        +
               TERMID=TRMNETID,MF=(E,GTTERML)
         ST    R15,WORK           SAVE GTTERM RETURN CODE.
         UNPK  GTTERMSZ(9),PRIMSIZE(5)
         TR    GTTERMSZ,HEX-C'0'
         MVI   GTTERMSZ+8,C' '
         UNPK  GTTERMAT(9),TERMATTR(5)
         TR    GTTERMAT,HEX-C'0'
         MVI   GTTERMAT+8,C' '
         UNPK  GTTERMRC(9),WORK(5)
         TR    GTTERMRC,HEX-C'0'
         MVI   GTTERMRC+8,C' '
         TM    TERMATTR+3,X'02'   EBCDIC TERMINAL?
         BZ    LANGOKAY           YES.
         MVC   TERMLANG,ASCII
LANGOKAY TM    TERMATTR+3,X'01'   QUERY BIT ON?
         BO    QSWTCHOK           YES.
         MVC   QSWITCH,OFF        NO.
QSWTCHOK STCOM NO                 TURN OFF INTERCOM.
         ST    R15,WORK           SAVE STCOM RETURN CODE.
         UNPK  STCOMRC(9),WORK(5)
         TR    STCOMRC,HEX-C'0'
         MVI   STCOMRC+8,C' '
         CLC   LINES+3(1),ALTSIZE ALTERNATE SIZE SET?
         BNE   FSMODEON           NO, ERASE/WRITE IS OKAY.
         CLC   COLUMNS+3(1),ALTSIZE+1 ALTERNATE SIZE SET?
         BNE   FSMODEON           NO, ERASE/WRITE IS OKAY.
         MVI   RESETAID+1,X'7E'   YES, USE ERASE/WRITE ALTERNATE.
FSMODEON STFSMODE ON,INITIAL=YES,NOEDIT=YES  TURN ON FULL-SCREEN MODE.
         ST    R15,WORK           SAVE STFSMODE RETURN CODE.
         UNPK  STFSMDRC(9),WORK(5)
         TR    STFSMDRC,HEX-C'0'
         MVI   STFSMDRC+8,C' '
         STTMPMD ON,KEYS=ALL      DISABLE SESSION MANAGER.
         ST    R15,WORK           SAVE STTMPMD RETURN CODE.
         UNPK  STMPMDRC(9),WORK(5)
         TR    STMPMDRC,HEX-C'0'
         MVI   STMPMDRC+8,C' '
         L     R1,16              POINT TO THE CVT.
         TM    116(R1),X'13'      MVS?
         BNO   DOTRMTYP           NO, PERFORM MSP TSS PROCESSING.
         MVC   GTTERM2,GTTERM1    INDICATE TERMID IS FROM GTTERM.
         MVC   TRMTYPR0,=C'TERMID= '  SHOW DATA IS FROM TERMID OPERAND.
         MVC   TRMTYPR1,TRMNETID  SHOW TERMINAL NAME
         MVC   TRMTYPRC,TRMNETID+8 AND NETNAME FOR VTAM V4 AND LATER.
         B     TRMTYPOK           SKIP THE TERMTYPE MACRO.
DOTRMTYP MVI   SCRNHDG+2,C'S'     NO, CHANGE 'TSO' TO 'TSS'.
         MVI   MACROHDG+4,C'S'
         TERMTYPE TERMIDL=TERMNAME
         STM   R15,R1,WORK        SAVE TERMTYPE RESULTS.
         UNPK  TRMTYPRC(9),WORK(5)
         TR    TRMTYPRC,HEX-C'0'
         MVI   TRMTYPRC+8,C' '
         UNPK  TRMTYPR0(9),WORK+4(5)
         TR    TRMTYPR0,HEX-C'0'
         MVI   TRMTYPR0+8,C' '
         UNPK  TRMTYPR1(9),WORK+8(5)
         TR    TRMTYPR1,HEX-C'0'
         MVI   TRMTYPR1+8,C' '
TRMTYPOK TM    TERMATTR+3,X'01'   IS THE QUERY BIT ON?
         BZ    DONEQERY           NO, CAN'T DO A QUERY.
REINITQ  MVI   TTFLAGS,0          ZERO FLAGS IN CASE OF REINITQ CMD.
         MVC   CHARMSG,BLANKS     ERASE MESSAGES FOR REINITQ CMD.
         MVC   ADDRMSG,BLANKS
         MVC   DSSFMSG,BLANKS
         MVC   QLSTMSG,BLANKS
         MVC   POSIHEX(8),BLANKS  ERASE CURSOR POSITION DATA.
         LA    R1,2
         ST    R1,NOEDLNTH        DISCARD ALL MODIFY FIELD DATA.
         XC    SYMSETS(8),SYMSETS ERASE SYMBOL-SET DETAILS.
         MVI   SYMSETS+1,X'3F'
         MVC   SYMSETS+8(56),SYMSETS
         MVC   INPUTHDG,QUERYHDG  ENSURE CORRECT HEADING.
         LA    R1,RESETAID
         LA    R0,L'RESETAID
         ICM   R1,8,TPUTFLGH      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          RESET THE ATTENTION IDENTIFIER.
         TPG   QUERY,L'QUERY,NOEDIT,WAIT   ISSUE QUERY.
         ST    R15,WORK           SAVE TPG RETURN CODE.
         MVC   WRITEMAC,TPGMAC    LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
QRYREGET LA    R1,INBUFF          POINT TO INPUT BUFFER.
         LA    R0,L'INBUFF        GET MAXIMUM LENGTH OF INPUT.
         ICM   R1,8,TGETFLAG      LOAD FLAGS FOR ASIS,WAIT TGET.
         TGET  (1),(0),R          READ QUERY RESPONSE.
         ST    R15,WORK           SAVE TGET RETURN CODE.
         UNPK  TGETRC(9),WORK(5)
         TR    TGETRC,HEX-C'0'
         MVI   TGETRC+8,C' '
         ST    R1,WORK            SAVE TGET DATA LENGTH.
         UNPK  TGETR1(9),WORK(5)
         TR    TGETR1,HEX-C'0'
         MVI   TGETR1+8,C' '
         UNPK  AIDHEX(3),INBUFF(2)
         TR    AIDHEX,HEX-C'0'    REPORT THE AID RETURNED.
         MVI   AIDHEX+2,C'('
         MVC   AIDCHAR,INBUFF
         CLI   INBUFF,X'6B'       VTAM RESHOW REQUEST (PA/CLEAR KEY)?
         BL    DONEQERY           NO, ASSUME QUERY NOT FUNCTIONAL.
         CLI   INBUFF,X'6F'
         BL    QRYREGET           YES, IGNORE AND GET QUERY RESPONSE.
         CLI   INBUFF,X'88'       QUERY RESPONSE AID?
         BNE   DONEQERY           NO, FORGET ABOUT SUB-FIELD PARSING.
         BCT   R1,CONTINUE
         B     DONEQERY           JUST IN CASE.
         SPACE
AUXDVCHK DS    0H
SUMRYCHK CLI   QLSTMSG+25,C' '    MESSAGE ALREADY ADJUSTED?
         BE    DONECHKS           YES, DON'T DO IT TWICE.
         MVC   QLSTMSG+15(10),QLSTMSG+19
         MVC   QLSTMSG+25(4),BLANKS
         B     DONECHKS           SAY THAT QUERY LIST IS SUPPORTED.
COLORCHK CLI   5(R5),8            HANDLING OF AT LEAST 8 PAIRS?
         BL    DONECHKS           NO.
         OI    TTFLAGS,COLR       YES, FLAG IT.
         B     DONECHKS
HILITCHK CLI   4(R5),4            HANDLING OF AT LEAST 4 PAIRS?
         BL    DONECHKS           NO.
         OI    TTFLAGS,HLIT       YES, FLAG IT.
         B     DONECHKS
REPLYCHK MVC   REPLIES,3(R5)      SAVE SOME REPLY MODE DETAILS.
         B     DONECHKS
SYMBLCHK OI    TTFLAGS,SYMSET+CMP SYMBOL-SETS SUB-FIELD WAS RETURNED.
         MVC   BYTE4,4(R5)        SAVE BYTE 4 OF THE SUB-FIELD.
         TM    BYTE4,X'80'        GRAPHIC ESCAPE SUPPORTED?
         BZ    GOTGEBIT           NO.
         OI    TTFLAGS,GEOK       YES, FLAG IT.
         MVC   MSGL(8),BLANKS     PF8 IS NOT INACTIVE.
         MVI   MSGL+8,C'('
GOTGEBIT SLR   R0,R0
         IC    R0,12(,R5)         GET THE LENGTH OF SYMSET DESCRIPTORS.
         STH   R0,WORK            SAVE IT.
         ICM   R0,3,0(R5)         GET LENGTH OF WHOLE SUB-FIELD.
         SH    R0,=H'13'          GET LENGTH OF ALL DESCRIPTORS.
         BNP   DONECHKS           IN CASE NO SYMBOL-SET DESCRIPTORS.
         LA    R7,13(,R5)         POINT TO FIRST SYMBOL-SET DESCRIPTOR.
PGMSYMID SLR   R15,R15
         IC    R15,0(,R7)         GET TERMINAL STORAGE ID.
         SLL   R15,3              GET INDEX INTO SYMSETS.
         LA    R15,SYMSETS(R15)   POINT TO RIGHT FLAG BYTE.
         MVC   0(2,R15),1(R7)     SAVE SYMBOL-SET FLAGS AND ID.
         XC    2(4,R15),2(R15)    ERASE CGCSGID.
         TM    4(R5),X'02'        CGCSGID PRESENT?
         BZ    CSIDLDOK           NO.
         CLI   12(R5),7           YES, ARE DESCRIPTORS LONG ENOUGH?
         BL    CSIDLDOK           NO, CAN'T REALLY BE PRESENT.
         MVC   2(4,R15),3(R7)     YES, LOAD CGCSGID.
         TM    4(R5),X'04'        DBCS SUPPORTED?
         BZ    CSIDLDOK           NO, LOAD DONE CORRECTLY.
         CLI   12(R5),11          YES, ARE DESCRIPTORS LONG ENOUGH?
         BL    CSIDLDOK           NO, CAN'T REALLY BE PRESENT.
         MVC   2(4,R15),7(R7)     YES, LOAD CGCSGID.
CSIDLDOK AH    R7,WORK            POINT TO NEXT DESCRIPTOR.
         SH    R0,WORK            SUBTRACT LENGTH OF DESCRIPTOR.
         BP    PGMSYMID           PROCESS NEXT DESCRIPTOR.
         LA    R0,8               MAXIMUM NUMBER OF SYMBOL-SETS.
         SLR   R7,R7              ZERO VALID SYMBOL-SET COUNTER.
         LA    R15,SYMSETS        POINT TO SYMBOL-SET BYTES.
VALIDSYM CLI   1(R15),X'3F'       IS THIS A VALID SYMBOL-SET?
         BE    EOSYMSTS           NO.
         LA    R7,1(,R7)          YES, INCREMENT SYMBOL-SET COUNTER.
         LA    R15,8(,R15)        YES, INCREMENT SYMBOL-SET POINTER.
         BCT   R0,VALIDSYM        TRY NEXT SYMBOL-SET.
EOSYMSTS BCTR  R7,0               CONVERT COUNT TO TERMINAL STORAGE ID.
         STC   R7,TOPSYMID        SAVE MAXIMUM SYMBOL-SET STORAGE ID.
         OI    TOPSYMID,X'F0'     MAKE NUMERIC CHARACTER.
         MVC   MSGL,PGMSYMSG      LOAD SYMSET# STATUS MESSAGE.
         B     DONECHKS           PROCESSED ALL DESCRIPTORS.
CMPCHECK OI    TTFLAGS,CMP        FLAG IBM COMPATIBILITY.
         B     DONECHKS
USABLCHK MVC   CHARMSG(L'NOMATMSG),NOMATMSG
         TM    5(R5),X'40'        NON-MATRIX CHARACTERS?
         BO    MATRIXOK           YES, ALREADY LOADED THE MESSAGE.
         SLR   R0,R0
         IC    R0,19(,R5)         LOAD DOT WIDTH COUNT.
         CVD   R0,WORK
         MVC   MATRXWID,ED3
         ED    MATRXWID,WORK+6
         IC    R0,20(,R5)         LOAD DOT DEPTH COUNT.
         CVD   R0,WORK
         MVC   MATRXDEP,ED3
         ED    MATRXDEP,WORK+6
         MVC   CHARMSG,MATRXMSG   LOAD MESSAGE INTO SCREEN.
MATRIXOK MVC   ADDRMSG(18),=CL18'(BUF-ADDR: 12-BIT)'
         LA    R15,ADDRMSG+17
         TM    4(R5),X'01'        14-BIT ADDRESSING SUPPORTED?
         BZ    ADDR14OK           NO.
         MVC   0(8,R15),=C'/14-BIT)'
         LA    R15,7(,R15)
ADDR14OK TM    4(R5),X'02'        16-BIT ADDRESSING SUPPORTED?
         BZ    ADDR16OK           NO.
         MVC   0(8,R15),=C'/16-BIT)'
         LA    R15,7(,R15)
ADDR16OK MVC   DSSFMSG(20),=CL20'(3270DS STRUC. FIELD'
         LA    R15,DSSFMSG+20
         TM    4(R5),X'20'        3270DS STRUCTURED FIELD SUPPORTED?
         BZ    DSSFOKAY           YES.
         MVC   1(3,R15),=C'NOT'   NO.
         LA    R15,4(,R15)
DSSFOKAY MVC   1(10,R15),=C'SUPPORTED)'
         B     DONECHKS
         SPACE
CONTINUE LA    R5,INBUFF+1        POINT PAST AID.
         MVC   QLSTMSG(29),=CL29'(QUERY LIST IS NOT SUPPORTED)'
         SLR   R0,R0              CLEAR FOR INSERTS.
QVFYSUBF CLI   2(R5),X'81'        LOOKS LIKE A QUERY SUB-FIELD?
         BE    QVFYCONT           YES.
QBADSUBF LA    R0,1               SET NOT-THE-FIRST-BLOCK FLAG.
         LA    R5,1(,R5)          NO, POINT TO NEXT BYTE.
         BCT   R1,QVFYSUBF        DECREMENT LENGTH AND TRY AGAIN.
         B     DONEQERY           JUST IN CASE.
QVFYCONT DS    0H
*        TM    3(R5),X'80'        QCODE IN X'80' TO X'FF' RANGE?
*        BZ    QBADSUBF           NO, PROBABLY INVALID.
*        CLI   0(R5),0            SUB-FIELD LENGTH < 256?
*        BNE   QBADSUBF           NO, PROBABLY INVALID.
         LTR   R0,R0              FIRST TGET BLOCK?
         BNZ   NEWQBIT            NO, CONTINUE FROM PREVIOUS SPOT.
         LA    R4,9               SHOW A MAXIMUM OF NINE SUB-FIELDS.
         LA    R3,TGETDTLS        POINT TO OUTPUT AREA.
         MVI   0(R3),C' '
         MVC   1(79,R3),0(R3)     BLANK LINE TO FORCE OVERWRITE.
NEWQBIT  LTR   R4,R4              STILL FORMATTING DISPLAY LINES?
         BNP   SBFLDCHK           NO, SKIP SOME FORMATTING STUFF.
         CLI   1(R3),C' '         PREVIOUS LINE'S DATA OVERRUN?
         BNE   SKIPLINE           YES, USE THE NEXT SCREEN LINE.
         UNPK  1(5,R3),0(3,R5)    NO, FORMAT SOME DATA HERE.
         TR    1(4,R3),HEX-C'0'
         MVI   5(R3),C' '         DISPLAY LENGTH BYTES.
         UNPK  6(5,R3),2(3,R5)
         TR    6(4,R3),HEX-C'0'
         MVI   10(R3),C' '        DISPLAY ID BYTES.
SBFLDCHK CLI   3(R5),X'86'        COLOUR SUB-FIELD?
         BE    COLORCHK           YES.
         CLI   3(R5),X'87'        HIGHLIGHTING SUB-FIELD?
         BE    HILITCHK           YES.
         CLI   3(R5),X'85'        SYMBOL-SETS SUB-FIELD?
         BE    SYMBLCHK           YES.
         CLI   3(R5),X'88'        REPLY-MODE SUB-FIELD?
         BE    REPLYCHK           YES.
         CLI   3(R5),X'93'        PC ATTACHMENT FACILITY SUB-FIELD?
         BE    CMPCHECK           YES.
         CLI   3(R5),X'A6'        IMPLICIT PARTITION SUB-FIELD?
         BE    CMPCHECK           YES.
         CLI   3(R5),X'81'        USABLE AREA SUB-FIELD?
         BE    USABLCHK           YES.
         CLI   3(R5),X'80'        SUMMARY SUB-FIELD?
         BE    SUMRYCHK           YES.
         CLI   3(R5),X'99'        AUXILIARY DEVICE SUB-FIELD?
         BE    AUXDVCHK           YES.
DONECHKS LA    R6,11(,R3)         POINT TO START OF DETAIL AREA.
         ICM   R0,3,0(R5)         GET LENGTH OF THIS BIT.
         LR    R7,R0              SAVE IT.
         LA    R15,4              LENGTH OF LENGTH AND ID BYTES.
         AR    R5,R15             POINT PAST LENGTH AND ID.
         SR    R0,R15
         BZ    SUBFLDOK           CATER FOR NULL REPLY.
         LTR   R4,R4              STILL FORMATTING DISPLAY LINES?
         BP    QHEXLOOP           YES.
         AR    R5,R0              NO, POINT PAST THIS SUB-FIELD.
         B     SUBFLDOK           SKIP SOME MORE FORMATTING STUFF.
QHEXLOOP CLC   0(3,R6),BLANKS     ROOM TO UNPACK ANOTHER BYTE?
         BE    QHEXUNPK           YES, SO DO IT.
         MVI   0(R6),C'+'         NO, SHOW THAT THERE WAS MORE DATA.
         AR    R5,R0              POINT PAST THIS SUB-FIELD.
         SLR   R4,R4              SUPPRESS FURTHER RESPONSE FORMATTING.
         B     SUBFLDOK           SKIP SOME MORE FORMATTING STUFF.
QHEXUNPK UNPK  0(3,R6),0(2,R5)    UNPACK A BYTE.
         TR    0(2,R6),HEX-C'0'   MAKE DISPLAYABLE.
         MVI   2(R6),C' '         ERASE GARBAGE.
         LA    R6,2(,R6)          ADJUST OUTPUT POINTER.
         LA    R5,1(,R5)          ADJUST INPUT POINTER.
         BCT   R0,QHEXLOOP        DECREMENT RESIDUAL BIT BYTE COUNTER.
SUBFLDOK SR    R1,R7              ANY MORE SUB-FIELDS?
         BZ    DONEQERY           NO.
         BM    QRYREGET           MAYBE, BUT HAVE TO GET THEM FIRST.
         LTR   R4,R4              STILL FORMATTING DISPLAY LINES?
         BNP   SBFLDCHK           NO, BUT LOOK FOR USEFUL DATA ANYWAY.
SKIPLINE LA    R3,80(,R3)         POINT TO NEW OUTPUT AREA.
         BCT   R4,NEWQBIT         YES, FORMAT ANOTHER LINE.
         BCTR  R3,0               POINT TO LINE 24 COLUMN 80.
         MVI   0(R3),C'+'         INDICATE TRUNCATION.
         AR    R5,R0              POINT PAST THIS SUB-FIELD.
         B     SBFLDCHK           DO SUB-FIELD DATA EXTRACTION ONLY.
DONEQERY LA    R0,X'28'           ASSUME IBM SET ATTRIBUTE TO BE USED.
         L     R1,16              POINT TO THE CVT.
         TM    116(R1),X'13'      MVS?  (HOPE NO-ONE RUNS SVS.)
         BO    HAVESETA           YES, ASSUME NOT FACOM VDU ON IBM OS.
         TM    TTFLAGS,CMP        ANY NON-FUJITSU SUB-FIELD RETURNED?
         BO    HAVESETA           YES, CAN'T BE FACOM HARDWARE.
         LA    R0,X'0E'           USE FACOM SET ATTRIBUTE ORDER CODE.
HAVESETA STC   R0,SACOLR          PUT CORRECT SA IN DATA STREAMS.
         STC   R0,SACOLR2
         STC   R0,SACOLR3
         STC   R0,SACOLR4
         STC   R0,SACOLR5
         STC   R0,SACOLR6
         STC   R0,SACOLR7
         STC   R0,SANORMAL
         STC   R0,SAHILIT1
         STC   R0,SAHILIT2
         STC   R0,SAHILIT4
         STC   R0,SAHILIT0
         STC   R0,SASYM
         STC   R0,SANOSYM
         STC   R0,SAHILIT
         CLI   SYMSETS+17,X'FF'   TERMINAL STORAGE 02 THERE AND UNUSED?
         BNE   TRYTRIPL           NO, CHECK OUT STORAGE 04.
         TM    SYMSETS+16,X'80'   YES, IS IT LOADABLE?
         BZ    TRYTRIPL           NO, CHECK OUT STORAGE 04.
         TM    PROFSW,SYMA        WAS MEMBER PROGSYMA READ?
         BO    BIGWRITE           YES, SEND ALL OF PSA TO THE TERMINAL.
         TPUT  SINGLSYM,SINGLEN,NOEDIT,WAIT
         B     SINGLED            PSA NOW LOADED.
BIGWRITE TPUT  WSFPSA,190*18+8,NOEDIT,WAIT
SINGLED  MVI   SYMSETS+15,X'DA'   LOADED SOME SYMBOLS INTO ID X'DA'.
TRYTRIPL CLI   SYMSETS+33,X'FF'   TERMINAL STORAGE 04 THERE AND UNUSED?
         BNE   DONEINIT           NO, INITIALIZATION COMPLETE.
         TM    SYMSETS+32,X'C0'   YES, IS IT LOADABLE TRIPLE-PLANE?
         BNO   DONEINIT           NO, INITIALIZATION COMPLETE.
         TPUT  TRIPLSYM,TRIPLEN,NOEDIT,WAIT
         MVI   SYMSETS+33,X'DC'   YES, LOAD SOME SYMBOLS INTO ID X'DC'.
DONEINIT LA    R0,SCRNLNTH        GET MAXIMUM LENGTH OF OUTPUT.
         TM    TTFLAGS,COLR+HLIT+GEOK ANY EXTENDED CAPABILITY?
         BNZ   DOTPUT             YES, DISPLAY QUERY RESULTS.
         MVC   FIELDPFK+1(L'FIELDPFK-1),FIELDPFK NO, ERASE PFK HELP.
         MVI   MSGL,C' '          ERASE PF8/SYMSET MESSAGE.
         MVC   MSGL+1(L'MSGL-1),MSGL
         B     DOTPUT             DISPLAY QUERY RESULTS.
TGETLOOP LA    R0,SCRNLNTH        GET MAXIMUM LENGTH OF OUTPUT.
         TM    TTFLAGS,HLIT       EXTENDED HIGHLIGHTING SUPPORTED?
         BZ    DOTPUT             NO, PROBABLY CAN'T DO GE EITHER.
         LA    R0,SCRNLNTH+SAHLITLN
         TM    TTFLAGS,GEOK       GRAPHIC ESCAPE SUPPORTED?
         BZ    DOTPUT             NO.
         LA    R0,SCRNLNTH+SAHLITLN+SASYMLEN
DOTPUT   LA    R1,SCREEN          POINT TO OUTPUT BUFFER.
TPUTFSCR ICM   R1,8,TPUTFLAG      LOAD FLAGS FOR FULLSCREEN TPUT.
         TPUT  (1),(0),R          SHOW THE SCREEN FULL OF DATA.
         ST    R15,WORK           SAVE TPUT RETURN CODE.
         MVC   WRITEMAC,TPUTFMAC  LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
         MVC   INPUTHDG,TGETHDNG  ENSURE CORRECT HEADING.
         MVI   TGETDTLS,C' '
         MVC   TGETDTLS+1(79),TGETDTLS
         LA    R1,TGETDTLS
         LA    R0,7
         TM    TTFLAGS,CLR7       7-COLOUR DATA ON SCREEN?
         BO    BLNKLOOP           YES.
         LA    R0,8               NO, BLANK 24TH LINE AS WELL.
BLNKLOOP MVC   80(80,R1),0(R1)    BLANK TGET FORMATING AREA.
         LA    R1,80(,R1)         POINT TO NEXT LINE.
         BCT   R0,BLNKLOOP
         TM    TTFLAGS,NONOED     IS A NOEDIT TPUT SUPPRESSED?
         BO    TPUTOVER           YES, TPUTING ALL OVER FOR NOW.
         TM    TTFLAGS,NOED       IS A NOEDIT TPUT REQUIRED?
         BZ    TPUTOVER           NO, TPUTING ALL OVER FOR NOW.
         L     R5,NOEDLNTH        YES, GET DATA STREAM LENGTH.
         TPUT  NOEDDATA,(5),NOEDIT,WAIT
         ST    R15,WORK           SAVE TPUT RETURN CODE.
         MVC   WRITEMAC,TPUTNMAC  LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
TPUTOVER NI    TTFLAGS,255-NONOED STOP NOEDIT TPUT SUPPRESSION.
         XC    INBUFF(256),INBUFF ERASE PREVIOUS INPUT.
         MVC   ERRMSG,BLANKS      RESET ERROR MESSAGE.
         LA    R1,INBUFF          POINT TO INPUT BUFFER.
         LA    R0,L'INBUFF        GET MAXIMUM LENGTH OF INPUT.
         ICM   R1,8,TGETFLAG      LOAD FLAGS FOR ASIS,WAIT TGET.
         TGET  (1),(0),R          READ TERMINAL INPUT.
         ST    R15,WORK           SAVE TGET RETURN CODE.
         UNPK  TGETRC(9),WORK(5)
         TR    TGETRC,HEX-C'0'
         MVI   TGETRC+8,C' '
         ST    R1,WORK            SAVE TGET DATA LENGTH.
         UNPK  TGETR1(9),WORK(5)
         TR    TGETR1,HEX-C'0'
         MVI   TGETR1+8,C' '
         UNPK  AIDHEX(3),INBUFF(2)
         TR    AIDHEX,HEX-C'0'    REPORT THE AID RETURNED.
         MVI   AIDHEX+2,C'('
         MVC   AIDCHAR,INBUFF
         MVC   POSIHEX(8),BLANKS
         LA    R0,3
         CR    R1,R0              IS THE WHOLE READ HEADER THERE?
         BL    SHOWTGET           NO.
         CLI   AIDCHAR,X'88'      QUERY RESPONSE?
         BE    READPART           YES, USE WHOLE SCREEN.
         CLI   AIDCHAR,X'60'      READ BUFFER RESPONSE?
         BE    READPART           YES, USE WHOLE SCREEN.
         TM    PROFSW,RDBF        READ BUFFER ACTIVE?
         BO    READPART           YES, USE WHOLE SCREEN.
         UNPK  POSIHEX(5),INBUFF+1(3)
         TR    POSIHEX,HEX-C'0'   YES, REPORT THE CURSOR POSITION.
         MVI   POSIHEX+4,C' '
         TM    INBUFF+1,X'40'     USING 12-BIT ADDRESSING?
         BZ    SHOWTGET           NO, 14-BIT SO NOT EBCDIC CHARACTERS.
         MVI   POSIHEX+4,C'('
         MVC   POSICHAR,INBUFF+1
         MVI   POSICHAR+2,C')'
SHOWTGET LTR   R1,R1              ANY INPUT?
         BZ    TGETLOOP           NO, SHOULDN'T HAPPEN.
         LA    R5,TGETDTLS        POINT TO OUTPUT AREA.
         LA    R6,INBUFF          POINT TO INPUT AREA.
UNPKLOOP UNPK  0(3,R5),0(2,R6)    UNPACK A BYTE.
         TR    0(2,R5),HEX-C'0'   MAKE IT DISPLAYABLE.
         MVI   2(R5),C' '         ERASE GARBAGE.
         CLI   1(R6),X'11'        IS A SET BUFFER ADDRESS ORDER NEXT?
         BNE   NOTSBA             NO.
         CLI   AIDCHAR,X'88'      QUERY RESPONSE DATA?
         BE    NOTSBA             YES, JUST HAPPENS TO BE HEX 11.
         LA    R5,2(,R5)          YES, LEAVE A COUPLE OF BLANKS.
NOTSBA   LA    R5,2(,R5)          POINT TO NEXT FORMAT AREA.
         LA    R6,1(,R6)          POINT TO NEXT INPUT BYTE.
         BCT   R1,UNPKLOOP        UNPACK ANOTHER BYTE.
         TM    PROFSW,DOSYM       NEW SYMBOL INPUT?
         BOR   R14                YES, RETURN TO CALLER.
         CLI   INBUFF,X'6D'       CLEAR BUTTON USED?
         BE    CLRNOED            YES, CLEAR EXTENDED UPDATES.
         OC    INBUFF+6(8),BLANKS
         CLC   INBUFF+6(3),END
         BE    DONETEST           END IF END REQUESTED.
         CLC   INBUFF+6(3),CAN
         BE    CANCEL             CAN IF CAN REQUESTED.
         CLI   INBUFF+6,C'Z'
         BE    DONETEST           END IF END REQUESTED.
         CLC   INBUFF+6(7),REINITQC
         BE    REINITQ            FORCE QUERY RE-INITIALIZATION.
         CLC   INBUFF+6(7),REPLYMDC
         BE    RPLYMODE           CHANGE REPLY MODE.
         CLC   INBUFF+6(6),SYMSETCM
         BE    SYMSETST           CHECK OUT SYMBOL-SET DISPLAY REQUEST.
         CLC   INBUFF+6(6),DELSYMCM
         BE    DELSETST           CHECK OUT SYMBOL-SET DELETE REQUEST.
         CLC   INBUFF+6(6),NEWSYMCM
         BE    NEWSYM##           CHECK OUT NEW-SYMBOL REQUEST.
         CLC   INBUFF+6(5),QUERYCM
         BE    TRYQUERY           FORCE QUERY ATTEMPT.
         CLC   INBUFF+6(8),QLISTALL
         BE    TRYQLIST           FORCE QUERY LIST ALL.
         CLC   INBUFF+6(5),QLISTALL
         BE    TRYQCODE           FORCE QUERY LIST.
         CLI   INBUFF+6,C'?'
         BE    SHOWHELP           DISPLAY HELP INFORMATION.
         CLC   INBUFF+6(4),HELPCM
         BE    SHOWHELP           DISPLAY HELP INFORMATION.
         CLC   INBUFF+6(5),PUNCHCMD
         BE    PUNCHSYM           PRODUCE ASSEMBLER SOURCE OF SYMBOLS.
         CLC   INBUFF+6(8),READBUFF
         BE    TRYRDBUF           PERFORM A READ BUFFER.
NOCOMAND CLI   INBUFF+3,X'11'     WAS AN INPUT FIELD UPDATED?
         BNE   TGETLOOP           NO.
         CLI   INBUFF,X'7A'       PF 10,11 OR 12?
         BL    TGETLOOP
         CLI   INBUFF,X'7C'
         BNH   WANTNOED           YES.
         CLI   INBUFF,X'F8'       PF 1,2,3,4,5,6,7 OR 8?
         BH    TGETLOOP
         CLI   INBUFF,X'F1'
         BL    TGETLOOP           NO.
WANTNOED CLI   NOEDLNTH+3,249     ANY ROOM LEFT IN UPDATE BUFFER?
         BH    WRONGPFK           NO, FORGET ABOUT THIS BIT.
         L     R15,NOEDLNTH       YES, GET NOEDIT DATA LENGTH.
         LA    R1,NOEDDATA(R15)   POINT TO NEXT VACANT POSITION.
         MVI   0(R1),X'11'        LOAD AN SBA.
         MVC   1(2,R1),INBUFF+4   SUPPLY AN ADDRESS.
         CLI   INBUFF,X'F8'       PF 8?
         BNE   NOTSYMS            NO, NOTHING TO DO WITH SYMBOL-SETS.
         TM    TTFLAGS,GEOK       IS GRAPHIC ESCAPE SUPPORTED?
         BZ    WRONGPFK           NO, FORGET ALL OF THIS.
         MVC   3(16,R1),APLCHARS  YES, SHOW SOME APL CHARACTERS.
         LA    R15,19(,R15)       UPDATE COUNTER.
         B     GONOEDIT           YES.
NOTSYMS  IC    R0,2(,R1)          LOAD SECOND ADDRESS BYTE.
         BCTR  0,0                DECREMENT IT TO POINT TO SF.
         STC   R0,2(,R1)          REPLACE IT.
         MVC   3(3,R1),COLOUR     LOAD MF ORDER.
         CLI   INBUFF,X'F1'       PF 1,2,3,4,5,6 OR 7?
         BL    NOTCOLOR           NO, NOTHING TO DO WITH COLOUR.
         TM    TTFLAGS,COLR       IS EXTENDED COLOUR SUPPORTED?
         BZ    WRONGPFK           NO, FORGET ALL OF THIS.
         MVI   5(R1),X'42'        INDICATE COLOUR.
         MVC   6(1,R1),INBUFF     USE AID AS COLOUR CODE.
         MVC   FILCOLOR,INBUFF    ALSO USE IT FOR CROSSHATCHES COLOUR.
         MVC   FILCLRSA,SACOLR    SUPPLY SA,COLOUR ORDERS.
         TM    TTFLAGS,CLR7       ALREADY SENDING SOME COLOUR STUFF?
         BO    NOEDITOK           YES.
         OI    TTFLAGS,CLR7       NO, ARE NOW.
         MVC   COLORTRL(SACOLRLN),SACOLR
         B     NOEDITOK           NO, ALSO SHOW CHAR ATTR COLOUR.
NOTCOLOR TM    TTFLAGS,HLIT       IS EXTENDED HIGHLIGHTING SUPPORTED?
         BZ    WRONGPFK           NO, FORGET ALL OF THIS.
         MVI   5(R1),X'41'        INDICATE HIGHLIGHTING.
         IC    R5,INBUFF          GET THE AID.
         LA    R5,X'F1'-X'7A'(,R5)
         STC   R5,6(,R1)          CONVERT TO HIGHLIGHT CODE.
         STC   R5,FILHILIT        COPY FOR CROSSHATCHES.
         CLI   6(R1),X'F3'        IS THIS 3?
         BNE   NOEDITOK           NO.
         MVI   6(R1),X'F4'        YES, IT SHOULD BE 4.
         MVI   FILHILIT,X'F4'     COPY FOR CROSSHATCHES.
NOEDITOK LA    R15,7(,R15)
GONOEDIT ST    R15,NOEDLNTH       UPDATE LENGTH COUNTER.
         OI    TTFLAGS,NOED       A NOEDIT TPUT IS NOW REQUIRED.
         B     TGETLOOP
         SPACE
CLRNOED  NI    TTFLAGS,255-NOED-CLR7 TURN OFF NOEDIT TPUT NEEDED FLAG.
         MVI   COLORTRL,C' '      BLANK OUT COLOUR CHAR ATTRS.
         MVC   FILCLRSA(3),BLANKS DELETE COLOUR FROM CROSSHATCHES.
         MVI   FILHILIT,X'00'     DELETE HILIGHTING FROM CROSSHATCHES.
         MVC   COLORTRL+1(79),COLORTRL
         LA    R0,2               RESET DATA STREAM LENGTH.
         ST    R0,NOEDLNTH
         CLI   RESETAID+1,X'7E'   USING ALTERNATE SCREEN SIZE?
         BNE   TGETLOOP           NO, PRIMARY SIZE OKAY.
         LA    R1,RESETAID        YES, CLEAR BUTTON WOULD RESET SCREEN
         LA    R0,L'RESETAID      TO PRIMARY, SO SET IT BACK AGAIN.
         ICM   R1,8,TPUTFLAG      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          SET SCREEN SIZE TO ALTERNATE.
         B     TGETLOOP
         SPACE
TRYRDBUF IC    R4,RESETAID+1      SAVE EW/EWA CODE.
         MVI   RESETAID+1,X'F1'   DO NOT CLEAR THE SCREEN.
         LA    R1,RESETAID        FORCE A READ BUFFER BUT DO NOT
         LA    R0,L'RESETAID      INTERPRET THE RESULTS.
         ICM   R1,8,TPUTFLGH      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          RESET THE ATTENTION IDENTIFIER.
         STC   R4,RESETAID+1      RESTORE EW/EWA CODE.
         TPG   HEX+2,1,NOEDIT,WAIT ISSUE READ BUFFER.
         OI    PROFSW,RDBF        SIGNAL READ BUFFER IS ACTIVE.
         B     DONQUERY           HANDLE FEEDBACK NICETIES.
         SPACE
TRYQUERY LA    R1,RESETAID        FORCE A QUERY ATTEMPT BUT DO NOT
         LA    R0,L'RESETAID      INTERPRET THE RESULTS.
         ICM   R1,8,TPUTFLGH      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          RESET THE ATTENTION IDENTIFIER.
         TPG   QUERY,L'QUERY,NOEDIT,WAIT   ISSUE QUERY.
DONQUERY ST    R15,WORK           SAVE TPG RETURN CODE.
         MVC   WRITEMAC,TPGMAC    LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)  IT IS OF MORE INTEREST THAN TPUT RC.
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
         B     TPUTOVER           DO NORMAL TGET PROCESSING.
         SPACE
TRYQLIST LA    R1,RESETAID        FORCE A QUERY LIST ALL BUT DO NOT
         LA    R0,L'RESETAID      INTERPRET THE RESULTS.
         ICM   R1,8,TPUTFLGH      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          RESET THE ATTENTION IDENTIFIER.
         TPG   QUERYLA,L'QUERYLA,NOEDIT,WAIT    ISSUE QUERY LIST ALL.
         B     DONQUERY           HANDLE FEEDBACK NICETIES.
         SPACE
TRYQCODE TR    INBUFF+11(2),XLATEHEX
         CLI   INBUFF+11,15       INVALID HEX?
         BH    WRONGHEX           YES.
         CLI   INBUFF+12,15       INVALID HEX?
         BH    WRONGHEX           YES.
         PACK  WORK(2),INBUFF+11(3)
         MVC   QCODE,WORK         LOAD QCODE LIST INTO DATA STREAM.
         LA    R1,RESETAID        FORCE A QUERY LIST BUT DO NOT
         LA    R0,L'RESETAID      INTERPRET THE RESULTS.
         ICM   R1,8,TPUTFLGH      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          RESET THE ATTENTION IDENTIFIER.
         TPG   QCODELST,QCODELEN,NOEDIT,WAIT    ISSUE QUERY LIST.
         B     DONQUERY           HANDLE FEEDBACK NICETIES.
         SPACE
SHOWHELP LA    R1,HELPPAGE        DISPLAY THE HELP PANEL.
         LA    R0,HELPGLEN
         OI    TTFLAGS,NONOED     NOBBLE MODIFY FIELD TPUT.
         B     TPUTFSCR           PERFORM FULLSCREEN TPUT.
         SPACE
WRONGHEX MVC   ERRMSG,HEXTEXT     INDICATE THAT COMMAND WAS IGNORED.
         B     NOCOMAND
         SPACE
WRONGCMD MVC   ERRMSG,ERRTEXT     INDICATE THAT COMMAND WAS IGNORED.
         B     NOCOMAND
         SPACE
WRONGPFK MVC   ERRMSG,PFKTEXT     INDICATE THAT COMMAND WAS IGNORED.
         B     TGETLOOP
         SPACE
PUNCHSYM L     R15,=V(SYMPUNCH)   GET CSECT ENTRY POINT ADDRESS.
         BALR  R14,R15            CALL SYMBOL-PUNCH SUBROUTINE.
         LTR   R15,R15            ZERO RETURN CODE?
         BZ    NOCOMAND           YES, BUT ALSO PROCESS ANY PF KEYS.
         MVC   ERRMSG,PCHTEXT     INDICATE THAT COMMAND WAS IGNORED.
         B     NOCOMAND
         SPACE
RPLYMODE CLI   REPLIES,X'88'      WAS REPLY MODE SUB-FIELD RETURNED?
         BNE   WRONGCMD           NO.
         CLI   INBUFF+13,C'0'     INVALID REPLY MODE NUMBER?
         BL    WRONGCMD           YES.
         CLI   INBUFF+13,C'2'     INVALID REPLY MODE NUMBER?
         BH    WRONGCMD           YES.
         MVC   REPLYMD#,INBUFF+13 LOAD IT INTO DATA STREAM.
         NI    REPLYMD#,X'0F'     JUST KEEP NUMERIC PART.
         SLR   R15,R15
         IC    R15,REPLYMD#
         LA    R15,REPLIES+1(R15)
         CLC   REPLYMD#,0(R15)    THIS REPLY MODE SUPPORTED?
         BNE   WRONGCMD           NO.
         LA    R5,STRMDLEN        GET DATA STREAM LENGTH.
         MVI   STRPLYMD+2,5       SUPPLY STRUCTURED FIELD SIZE.
         CLI   REPLYMD#,2         CHARACTER-MODE?
         BNE   GOTRMODE           NO.
         TM    TTFLAGS,HLIT       EXTENDED HIGHLIGHTING SUPPORTED?
         BZ    WRONGCMD           NO.
         MVI   STRPLYMD+2,6       SUPPLY STRUCTURED FIELD SIZE.
         LA    R5,1(,R5)          INCREMENT DATA STREAM LENGTH.
         TM    TTFLAGS,COLR       EXTENDED COLOUR SUPPORTED?
         BZ    GOTRMODE           NO.
         MVI   STRPLYMD+2,7       SUPPLY STRUCTURED FIELD SIZE.
         LA    R5,1(,R5)          INCREMENT DATA STREAM LENGTH.
         TM    TTFLAGS,SYMSET     SYMBOL-SETS SUPPORTED?
         BZ    GOTRMODE           NO.
         MVI   STRPLYMD+2,8       SUPPLY STRUCTURED FIELD SIZE.
         LA    R5,1(,R5)          INCREMENT DATA STREAM LENGTH.
GOTRMODE TPUT  STRPLYMD,(5),NOEDIT,WAIT
         ST    R15,WORK           SAVE TPUT RETURN CODE.
         MVC   WRITEMAC,TPUTNMAC  LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
         B     TGETLOOP
         SPACE
NEWSYM## MVC   CODEPNT,INBUFF+12  DISPLAY THE SPECIFIED CODE POINT.
         TR    INBUFF+12(2),XLATEHEX
         CLI   INBUFF+12,15       INVALID HEX?
         BH    WRONGHEX           YES.
         CLI   INBUFF+13,15       INVALID HEX?
         BH    WRONGHEX           YES.
         PACK  WORK(2),INBUFF+12(3)
         CLI   WORK,X'40'         INVALID CODE POINT?
         BNH   WRONGCMD           YES.
         CLI   WORK,X'FF'         INVALID CODE POINT?
         BE    WRONGCMD           YES.
         MVC   NEWCDPNT,WORK      SUPPLY CODE POINT IN DATA STREAM.
         CLI   SYMSETS+17,X'FF'   TERMINAL STORAGE 02 THERE AND UNUSED?
         BNE   NEWADDOK           NO.
         TM    SYMSETS+16,X'80'   YES, IS IT LOADABLE?
         BZ    NEWADDOK           NO.
         TPUT  WSFPSA,190*18+8,NOEDIT,WAIT
         MVI   SYMSETS+17,X'DA'   STORAGE 02 IS NOW ID X'DA'.
NEWADDOK SLR   R3,R3
         IC    R3,NEWCDPNT        GET CODE POINT.
         LA    R0,X'41'           GET FIRST VALID CODE POINT.
         SLR   R3,R0              GET CODE POINT OFFSET.
         MH    R3,=H'18'          GET BPAMBUFR OFFSET.
         LA    R3,BPAMBUFR(R3)    POINT TO OLD CODE POINT BIT PATTERN.
         LA    R15,16             NUMBER OF BITS IN THE FIRST SLICE.
         ICM   R0,3,0(R3)         LOAD BITS FOR LEFT SLICE.
         LA    R2,INBUFF          POINT TO DECODING WORK AREA.
PUTSLICE SLL   R0,1               PROMOTE BIT TO SECOND BYTE.
         STCM  R0,4,0(R2)         STORE BIT.
         NI    0(R2),C'1'         ENSURE RESULT IS EITHER A
         OI    0(R2),C'0'         CHARACTER '0' OR '1'.
         LA    R2,9(,R2)          POINT TO NEXT SLICE OUTPUT BYTE.
         BCT   R15,PUTSLICE       PROCESS NEXT BIT.
         LA    R2,INBUFF+1        POINT TO FIRST ROW OUTPUT BYTE.
         LA    R3,2(,R3)          POINT PAST SLICE BYTES.
         LA    R15,16             NUMBER OF ROWS.
PUTNXTRW IC    R0,0(,R3)          LOAD ROW TO DECODE.
         LA    R3,1(,R3)          POINT TO NEXT ROW.
         LA    R1,8               NUMBER OF BITS PER ROW.
PUTROWBT SLL   R0,1               PROMOTE BIT TO THIRD BYTE.
         STCM  R0,2,0(R2)         STORE BIT.
         NI    0(R2),C'1'         ENSURE RESULT IS EITHER A
         OI    0(R2),C'0'         CHARACTER '0' OR '1'.
         LA    R2,1(,R2)          POINT TO NEXT OUTPUT BYTE FOR ROW.
         BCT   R1,PUTROWBT        PROCESS NEXT BIT.
         LA    R2,1(,R2)          SKIP OVER SLICE OUTPUT BYTE.
         BCT   R15,PUTNXTRW       PROCESS NEXT ROW.
         MVC   NEWROW3+5(9),INBUFF
         MVC   NEWROW4+4(9),INBUFF+9
         MVC   NEWROW5+4(9),INBUFF+18
         MVC   NEWROW6+4(9),INBUFF+27
         MVC   NEWROW7+4(9),INBUFF+36
         MVC   NEWROW8+4(9),INBUFF+45
         MVC   NEWROW9+4(9),INBUFF+54
         MVC   NEWROW10+4(9),INBUFF+63
         MVC   NEWROW11+4(9),INBUFF+72
         MVC   NEWROW12+4(9),INBUFF+81
         MVC   NEWROW13+4(9),INBUFF+90
         MVC   NEWROW14+4(9),INBUFF+99
         MVC   NEWROW15+4(9),INBUFF+108
         MVC   NEWROW16+4(9),INBUFF+117
         MVC   NEWROW17+4(9),INBUFF+126
         MVC   NEWROW18+4(9),INBUFF+135
         LA    R1,NEWSYMPG        DISPLAY THE PROMPT PANEL.
         LA    R0,NEWSYMLN
         ICM   R1,8,TPUTFLAG      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R
         ST    R15,WORK           SAVE TPUT RETURN CODE.
         MVC   WRITEMAC,TPUTFMAC  LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
         LA    R1,TGETDTLS
         MVI   0(R1),C' '
         MVC   1(79,R1),0(R1)     BLANK LINE.
         LA    R0,7  <--------+---KEEP IN SYNC WITH INPUT SHOW LINES!
         TM    TTFLAGS,CLR7   |   7-COLOUR DATA ON SCREEN?
         BO    BLANKLP        |   YES.
         LA    R0,8  <--------+   NO, BLANK 24TH LINE AS WELL.
BLANKLP  MVC   80(80,R1),0(R1)    BLANK TGET FORMATING AREA.
         LA    R1,80(,R1)         POINT TO NEXT LINE.
         BCT   R0,BLANKLP
         OI    PROFSW,DOSYM       TELL TGET ROUTINE TO COME BACK HERE.
         BAL   R14,TPUTOVER       DO NORMAL TGET PROCESSING.
         NI    PROFSW,255-DOSYM   RESET FLAG.
         CLC   TGETR1+6(2),=C'C3' CORRECT LENGTH INPUT?
         BNE   WRONGCMD           NO, FORGET THE WHOLE THING.
         CLI   INBUFF,X'F3'       PF3?
         BE    TGETLOOP           YES, CANCEL SYMBOL EDIT REQUEST.
         CLI   INBUFF,X'C3'       PF15?
         BE    TGETLOOP           YES, CANCEL SYMBOL EDIT REQUEST.
         LA    R0,16              LENGTH OF FIRST STRIP.
         LA    R1,INBUFF+6
         SLR   R15,R15            CLEAR ACCUMULATOR.
         XC    WORK,WORK
STRIPLP  SLL   R15,1              MAKE ROOM FOR NEXT BIT.
         MVC   WORK+3(1),0(R1)    MOVE INPUT BYTE.
         NI    WORK+3,1           KEEP LAST BIT AS IS.
         O     R15,WORK           PUT IT INTO ACCUMULATOR.
         LA    R1,12(,R1)         POINT TO NEXT INPUT BYTE.
         BCT   R0,STRIPLP
         STCM  R15,3,NEWBITS      SUPPLY FIRST TWO BYTES OF SYMBOL.
         LA    R0,16              SIXTEEN INPUT LINES.
         LA    R1,INBUFF+7        POINT TO FIRST BYTE LEFT.
         LA    R2,NEWBITS+2       NEXT OUTPUT BYTE.
         SLR   R15,R15            CLEAR ACCUMULATOR.
BIGLOOP  LA    R3,8               EIGHT BYTES LEFT PER LINE.
BITLOOP  SLL   R15,1              MAKE ROOM FOR NEXT BIT.
         MVC   WORK+3(1),0(R1)    MOVE INPUT BYTE.
         NI    WORK+3,1           KEEP LAST BIT AS IS.
         O     R15,WORK           PUT IT INTO ACCUMULATOR.
         LA    R1,1(,R1)          POINT TO NEXT INPUT BYTE.
         BCT   R3,BITLOOP         GET NEXT INPUT BYTE.
         STC   R15,0(,R2)         STORE NEXT OUTPUT BYTE.
         LA    R2,1(,R2)          POINT TO NEXT OUTPUT BYTE.
         LA    R1,4(,R1)          POINT TO NEXT INPUT FIELD.
         BCT   R0,BIGLOOP         GET NEXT INPUT FIELD.
         SLR   R3,R3
         IC    R3,NEWCDPNT        GET CODE POINT.
         LA    R0,X'41'           GET FIRST VALID CODE POINT.
         SLR   R3,R0              GET CODE POINT OFFSET.
         MH    R3,=H'18'          GET BPAMBUFR OFFSET.
         LA    R3,BPAMBUFR(R3)    POINT TO OLD CODE POINT BIT PATTERN.
         CLC   0(18,R3),NEWBITS   ANY CHANGE IN SYMBOL SPECIFICATION?
         BE    TGETLOOP           NO, FORGET ABOUT UPDATES.
         MVC   0(18,R3),NEWBITS   OVERWRITE WITH NEW BIT PATTERN.
         OI    PROFSW,CHNGD       FLAG PROFILE NOW UPDATED.
         TM    SYMSETS+16,X'80'   CAN PSA BE LOADED?
         BZ    TGETLOOP           NO, NO POINT TRYING.
         MVC   NEWSTGID,SYMSETS+17  LOAD SYMBOL-SET ID.
         TPUT  NEWSYMSF,SYMWRTLN,NOEDIT,WAIT
         ST    R15,WORK           SAVE TPUT RETURN CODE.
         MVC   WRITEMAC,TPUTNMAC  LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
         B     TGETLOOP
         SPACE
DELSETST CLI   INBUFF+12,C'2'     NONE, DEFAULT OR APL SPECIFIED?
         BL    WRONGCMD           YES, IGNORE THE COMMAND.
         MVC   FREEID,INBUFF+12   GET THE NUMBER.
         CLC   FREEID,TOPSYMID    NUMBER GREATER THAN MAXIMUM?
         BH    WRONGCMD           YES, IGNORE THE COMMAND.
         NI    FREEID,X'0F'       GET THE BINARY NUMBER.
         TPUT  FREESYM,FREESYML,NOEDIT,WAIT
         ST    R15,WORK           SAVE TPUT RETURN CODE.
         MVC   WRITEMAC,TPUTNMAC  LABEL OUTPUT MACRO CORRECTLY.
         UNPK  TPUTRC(9),WORK(5)
         TR    TPUTRC,HEX-C'0'
         MVI   TPUTRC+8,C' '
         IC    R15,FREEID         LOAD THE NUMBER.
         SLL   R15,3              GET THE INDEX INTO SYMSETS.
         LA    R15,SYMSETS(R15)   POINT TO SYMSETS ELEMENT.
         XC    2(6,R15),2(R15)    ERASE ENTRY.
         MVI   1(R15),X'FF'       REMEMBER THAT IT IS NOW FREE.
         B     NOCOMAND           RESHOW SCREEN.
         SPACE
SYMSETST CLI   SYMSETS+1,C'1'     ANY VALID SYMBOL-SETS?
         BH    WRONGCMD           NO, IGNORE THE COMMAND.
         MVI   WORK,C'0'          ASSUME DEFAULT SYMBOL-SET.
         CLI   INBUFF+12,C'1'     NUMBER GREATER THAN ZERO SPECIFIED?
         BL    GOTSYMNO           NO, ASSUMPTION WAS CORRECT.
         MVC   WORK(1),INBUFF+12  YES, GET THE NUMBER.
         CLC   WORK(1),TOPSYMID   NUMBER GREATER THAN MAXIMUM?
         BH    WRONGCMD           YES, IGNORE THE COMMAND.
GOTSYMNO MVC   STORAGID,WORK      REPORT THE TERMINAL STORAGE ID.
         NI    WORK,X'0F'         GET THE BINARY NUMBER.
         SLR   R15,R15            CLEAR WORK REGISTER.
         IC    R15,WORK           LOAD THE NUMBER.
         SLL   R15,3              GET THE INDEX INTO SYMSETS.
         LA    R15,SYMSETS(R15)   POINT TO SYMSETS ELEMENT.
         MVC   READLOAD,=C'READ-ONLY'
         TM    0(R15),X'80'       READ-ONLY STORAGE?
         BZ    ROSYMSET           YES.
         MVC   READLOAD,=C' LOADABLE'
ROSYMSET MVC   PLANENUM,=C'SING'
         MVC   TRIPLCLR,BLANKS
         TM    0(R15),X'40'       SINGLE-PLANE STORAGE?
         BZ    ONEPLANE           YES.
         MVC   PLANENUM,=C'TRIP'  NO, TRIPLE-PLANE SO 7-COLOUR OKAY.
         MVC   TRIPLCLR,SACOLR7   SAY WHITE TO GET MULTI-COLOUR CHARS.
ONEPLANE MVC   CSIDMSG+1(L'CSIDMSG-1),CSIDMSG
         OC    2(4,R15),2(R15)    ANY CGCSGID PRESENT?
         BZ    CSIDOKAY           NO.
         MVC   CSIDMSG(11),=C' - CGCSGID='
         UNPK  CSIDMSG+11(5),2(3,R15)
         TR    CSIDMSG+11(4),HEX-C'0'
         MVI   CSIDMSG+15,C'-'
         UNPK  CSIDMSG+16(5),4(3,R15)
         TR    CSIDMSG+16(4),HEX-C'0'
         MVI   CSIDMSG+20,C' '
CSIDOKAY UNPK  SYMIDENT,1(2,R15)  SHOW THE SYMBOL-SET ID.
         TR    SYMIDENT(2),HEX-C'0'
         MVI   SYMIDENT+2,C''''
         LA    R0,SYMHDLEN        GET LENGTH OF TPUT SO FAR.
         CLI   1(R15),X'FF'       ANY SYMBOLS IN THIS STORAGE?
         BE    PUTSYMPG           NO, SHOW THIS MUCH ONLY.
         IC    R1,1(,R15)         GET SYMBOL-SET ID.
         STC   R1,ROW6SYM         INSERT IT INTO DATA STREAM.
         STC   R1,ROW7SYM
         STC   R1,ROW8SYM
         STC   R1,ROW9SYM
         STC   R1,ROW10SYM
         STC   R1,ROW11SYM
         STC   R1,ROW12SYM
         STC   R1,ROW13SYM
         STC   R1,ROW14SYM
         STC   R1,ROW15SYM
         STC   R1,ROW16SYM
         STC   R1,ROW17SYM
         LA    R0,SYMPGLEN        GET LENGTH OF WHOLE SCREEN IMAGE.
         TM    0(R15),X'80'       READ-ONLY STORAGE?
         BZ    PUTSYMPG           YES.
         LA    R0,SYMSGLEN        NO, INCLUDE DELSYM# MESSAGE.
         MVC   DELSYMID(1),STORAGID   REPORT THE TERMINAL STORAGE ID.
PUTSYMPG OI    TTFLAGS,NONOED     NOBBLE MODIFY FIELD TPUT.
         LA    R1,SYMBOLPG        POINT TO SYMBOL-SET DISPLAY PAGE.
         B     TPUTFSCR           PERFORM FULLSCREEN TPUT.
         SPACE
READPART LR    R0,R15             SAVE TGET RETURN CODE.
         NI    PROFSW,255-RDBF    RESET READ BUFFER ACTIVE FLAG.
         L     R15,=V(QUERYFMT)   GET FORMAT SUBROUTINE ENTRY POINT.
         BALR  R14,R15            CALL QUERY RESPONSE FORMAT ROUTINE.
         B     TPUTOVER           WAIT FOR USER'S RESPONSE.
         SPACE
CANCEL   NI    PROFSW,255-CHNGD   DO NOT SAVE PSA UPDATES.
DONETEST CLI   GTTERMRC+7,C'0'    ANY PROBLEMS WITH GTTERM?
         BE    FASTEXIT           NO, SHOULD NOT NEED TO CLEAR SCREEN.
         MVI   RESETAID+2,X'C2'   YES, ACF/VTAM MIGHT NOT BE INSTALLED.
         LA    R1,RESETAID
         LA    R0,L'RESETAID
         ICM   R1,8,TPUTFLGH      LOAD TPUT FLAG BYTE.
         TPUT  (1),(0),R          CLEAR THE SCREEN FOR TMP.
FASTEXIT STLINENO LINE=1,MODE=OFF GET OUT OF FULLSCREEN MODE.
         STTMPMD OFF              MAYBE RESTORE SESSION MANAGER.
         STCOM YES                TURN INTERCOM ON.
         TM    PROFSW,DDOK+CHNGD  USEABLE FILE AND PROFILE ALTERED?
         BNO   CLOSEDUP           NO, SKIP FILE I/O.
         LA    R3,190*18          GET USED DATA SIZE.
         LA    R3,BPAMBUFR(R3)    POINT PAST PSA DATA.
         TIME  DEC                GET TIME AND DATE.
         STM   R0,R1,WORK         PUT INTO WORK AREA.
         UNPK  0(15,R3),WORK(8)   PUT TIMESTAMP INTO MEMBER CONTENTS.
         MVC   15(5,R3),AUTHORID  SUPPLY DATA IDENTIFIER.
         TM    PROFSW,SYMA        WAS THE MEMBER READ IN?
         BZ    NEWMEMBR           NO, GO OPEN FOR OUTPUT.
         OPEN (ISPPROF,(UPDAT)),MF=(E,OPNCLOSE)
         LH    R0,ISPPROF+DCBBLKSI-IHADCB
         ST    R0,GMREG0          SAVE INPUT BUFFER SIZE AND SUBPOOL.
         GETMAIN R,LV=(0)         GET A BUFFER TO THROW AWAY INPUT.
         ST    R1,GMREG1          SAVE BUFFER ADDRESS.
         LR    R7,R1              POINT TO INPUT BUFFER.
         FIND  ISPPROF,BILDTTR,C  POINT TO MEMBER FOR FIRST READ.
         SLR   R3,R3              ZERO INDEX.
ZAPSYMA  LA    R2,BPAMBUFR(R3)    POINT TO BUFFER AREA.
         READ  DYNDECB,SF,,(7),'S',MF=E
         CHECK DYNDECB            WAIT FOR THE READ.
         TM    PROFSW,IOERR       I/O ERROR?
         BO    IOERROR            YES.
         LH    R0,ISPPROF+DCBBLKSI-IHADCB
         L     R1,DYNDECB+16      POINT TO THE IOB.
         SH    R0,14(,R1)         GET LENGTH OF BLOCK READ.
         AR    R3,R0              ACCUMULUATE BYTE COUNT SO FAR.
         WRITE DYNDECB,SF,,(2),'S',MF=E
         CHECK DYNDECB            WAIT FOR THE WRITE.
         TM    PROFSW,IOERR       I/O ERROR?
         BO    IOERROR            YES.
         CH    R3,MEMBRSIZ        DONE ENOUGH UPDATING YET?
         BL    ZAPSYMA            NO, PROCESS ANOTHER BLOCK.
         LM    R0,R1,GMREGS       RESTORE REGISTERS FOR FREEMAIN.
         FREEMAIN R,LV=(0),A=(1)  FREE THE INPUT BUFFER.
         B     CLOSEOUT           CLOSE THE PROFILE DATA SET.
NEWMEMBR OPEN (ISPPROF,(OUTPUT)),MF=(E,OPNCLOSE)
         LH    R4,MEMBRSIZ        GET NUMBER OF BYTES TO WRITE.
         SLR   R3,R3              ZERO INDEX.
MAKESYMA LA    R2,BPAMBUFR(R3)    POINT TO BUFFER AREA.
         LH    R5,ISPPROF+DCBBLKSI-IHADCB
         CR    R4,R5              BYTES TO WRITE LESS THAN BLKSIZE?
         BNL   BLOCKOK            NO.
         LR    R5,R4              YES, MAKE THIS THE BLOCK SIZE.
         STH   R5,ISPPROF+DCBBLKSI-IHADCB
BLOCKOK  SR    R4,R5              UPDATE BYTES TO WRITE COUNTER.
         AR    R3,R5              UPDATE INDEX TO NEXT BLOCK'S DATA.
         WRITE DYNDECB,SF,,(2),'S',MF=E
         CHECK DYNDECB            WAIT FOR THE WRITE.
         TM    PROFSW,IOERR       I/O ERROR?
         BO    IOERROR            YES.
         LTR   R4,R4              ANY BYTES STILL TO WRITE?
         BP    MAKESYMA           YES, WRITE ANOTHER BLOCK.
         STOW  ISPPROF,BILDNAME,A CREATE MEMBER DIRECTORY ENTRY.
CLOSEOUT CLOSE ISPPROF,MF=(E,OPNCLOSE)
CLOSEDUP L     R13,SAVEAREA+4     POINT TO CALLER'S SAVE AREA.
         LM    R14,R12,12(R13)    RESTORE REGISTERS.
         SLR   R15,R15            ZERO RETURN CODE.
         BR    R14                RETURN.
         SPACE 2
CALCPOSI LR    R0,R1              GET CODE FOR 3270 BUFFER ADDRESS.
         CH    R0,=H'4095'        LOCATION GREATER THAN 4K (12 BITS)?
         BHR   R14                YES, NO CONVERSION TO BE DONE.
         STC   R0,WORK+1          NO, DO ORIGINAL 3270 ADDRESSING.
         NI    WORK+1,B'00111111' GET LOW-ORDER SIX-BIT NUMBER.
         SRL   R0,6
         STC   R0,WORK            GET HIGH-ORDER SIX-BIT NUMBER.
         TR    WORK(2),TABLE      CONVERT TO 3270 DATA STREAM CHARS.
         ICM   R0,X'3',WORK       SAVE IN BOTTOM TWO BYTES OF R0.
         BR    R14                RETURN TO MAINLINE.
         SPACE 2
SCRNNOGO LA    R0,L'NOGOMSG
         LA    R1,NOGOMSG
         TPUT  (1),(0),R          DISPLAY SCREEN NO-GO MESSAGE.
         L     R13,SAVEAREA+4     POINT TO CALLER'S SAVE AREA.
         LM    R14,R12,12(R13)    RESTORE REGISTERS.
         LA    R15,8              RETURN CODE 8.
         BR    R14                RETURN.
         SPACE 2
SYNAD    SYNADAF ACSMETH=BPAM     ANALYZE ERROR.
         MVC   SYNADMSG,50(R1)    GET ERROR MESSAGE.
         OI    PROFSW,IOERR       FLAG I/O ERROR OCCURRENCE.
         SYNADRLS
         BR    R14
         SPACE 2
IOERROR  LA    R1,SYNADMSG        POINT TO ERROR MESSAGE.
         LA    R0,L'SYNADMSG      GET ERROR MESSAGE LENGTH.
         TPUT  (1),(0),R          DISPLAY THE MESSAGE.
         TM    OPNCLOSE,X'0F'     OPENED FOR INPUT?
         BZ    CLOSEIN            YES, CLOSE AND CONTINUE.
         L     R13,SAVEAREA+4     NO, POINT TO CALLER'S SAVE AREA.
         LM    R14,R12,12(R13)    RESTORE REGISTERS.
         LA    R15,12             NON-ZERO RETURN CODE.
         BR    R14                LET TASK TERMINATION CLOSE IT.
         EJECT
DYNREAD  READ  DYNDECB,SF,ISPPROF,0,'S',MF=L
OPNCLOSE DC    X'80000000'        SINGLE-ENTRY DCB LIST.
NOEDLNTH DC    F'2'               LENGTH OF NOEDIT TPUT DATA STREAM.
HEX      DC    C'0123456789ABCDEF'
ED3      DC    X'40202120'
APLCHARS DC    X'08E108E208E308920893089408950891'
BILDLIST DC    H'1',H'14'         ONE 14-BYTE ENTRY.
BILDNAME DC    C'PROGSYMA'        MEMBER NAME.
BILDTTR  DC    XL3'000000'        MEMBER RELATIVE TRACK ADDRESS.
BILDK    DC    XL1'00'            CONCATENATION NUMBER.
BILDZ    DC    XL1'00'            LOCATION CODE.
BILDC    DC    XL1'00'            ALIAS AND USER DATA FLAGS.
MEMBRSIZ DC    H'3440'            NUMBER OF BYTES IN MEMBER PROGSYMA.
SYNADMSG DC    CL78' '            I/O ERROR MESSAGE.
NOGOMSG  DC    C'TERMTEST REQUIRES A 3270-TYPE VDU WITH AT LEAST 24 LIN+
               ES AND 80 COLUMNS.'
NOMATMSG DC    CL23'(NON-MATRIX CHARACTERS)'
MATRXMSG DC    CL33'(CHAR. MATRIX: 000 WIDE 000 DEEP)'
MATRXWID EQU   MATRXMSG+14,4
MATRXDEP EQU   MATRXMSG+23,4
BLANKS   DC    CL35' '            EXTEND IF NECESSARY.
ASCII    DC    C' ASCII'
WRTWCC   DC    X'F1C3'            WRITE, WCC.
OFF      DC    C'OFF'
END      DC    C'END'
CAN      DC    C'CAN'
SYMSETCM DC    C'SYMSET'
DELSYMCM DC    C'DELSYM'
NEWSYMCM DC    C'NEWSYM'
QUERYCM  DC    C'QUERY'
QLISTALL DC    C'QLISTALL'
REINITQC DC    C'REINITQ'
REPLYMDC DC    C'REPLYMD'
HELPCM   DC    C'HELP'
PUNCHCMD DC    C'PUNCH'
READBUFF DC    C'READBUFF'
ERRTEXT  DC    CL18'ERR-INPUT IGNORED '
PFKTEXT  DC    CL18'ERROR-PFK IGNORED '
PCHTEXT  DC    CL18'SYSPUNCH DD ERROR '
HEXTEXT  DC    CL18'ERR-BAD HEX DIGIT '
TPUTFMAC DC    CL34'  TPUT     FULLSCR,WAIT           '
TPUTNMAC DC    CL34'  TPUT     NOEDIT,WAIT            '
TPGMAC   DC    CL34'  TPG      NOEDIT,WAIT            '
AUTHORID DC    X'C7D77CD7F6'
COLOUR   DC    X'2C0142'          MF, 1 PAIR, COLOUR.
TGETFLAG DC    X'81'              FLAG BYTE FOR TGET ASIS,WAIT.
TPUTFLAG DC    X'03'              FLAG BYTE FOR TPUT FULLSCR,WAIT.
TPUTFLGH DC    X'0B'              FLAG BYTE FOR TPUT FULLSCR,WAIT,HOLD.
TTFLAGS  DC    X'00'              FLAG BYTE FOR TERMTEST PROCESSING.
COLR     EQU   X'80'              ENTENDED COLOUR SUPPORTED.
HLIT     EQU   X'40'              ENTENDED HIGHLIGHTING SUPPORTED.
GEOK     EQU   X'20'              GRAPHIC ESCAPE SUPPORTED.
NOED     EQU   X'10'              A NOEDIT TPUT IS REQUIRED.
CLR7     EQU   X'08'              SOME COLOUR DATA BEING SENT.
SYMSET   EQU   X'04'              SYMBOL-SETS SUB-FIELD RETURNED.
NONOED   EQU   X'02'              DON'T DO THE NOEDIT TPUT.
CMP      EQU   X'01'              NON-FUJITSU SUB-FIELD RETURNED.
PROFSW   DC    X'00'              PROFILE SWITCHES.
DDOK     EQU   X'80'              DDNAME=ISPPROF IS ALLOCATED.
SYMA     EQU   X'40'              MEMBER PROGSYMA EXISTS.
CHNGD    EQU   X'20'              THE PSA PROFILE HAS BEEN CHANGED.
IOERR    EQU   X'10'              AN I/O ERROR HAS BEEN ENCOUNTERED.
DOSYM    EQU   X'08'              MAKING A NEW SYMBOL.
RDBF     EQU   X'04'              PERFORMING A READ BUFFER.
BYTE4    DC    X'00'              BYTE 4 OF SYMBOL-SETS SUB-FIELD.
QUERY    DC    X'F3000501FF02'    READ PARTITION STRUCTURED FIELD.
QUERYLA  DC    X'F3000601FF0380'  READ PARTITION STRUCTURED FIELD.
QCODELST DC    X'F3000701FF0300'  READ PARTITION STRUCTURED FIELD.
QCODE    DC    X'FF'              QUERY REPLY CODE LIST.
QCODELEN EQU   *-QCODELST
FREESYM  DC    X'F300070641FF41'  FREE SYMBOL SET.
FREEID   DC    X'00'              LOADABLE TERMINAL STG ID TO BE FREED.
FREESYML EQU   *-FREESYM
STRPLYMD DC    X'F300050900'      SET REPLY MODE.
REPLYMD# DC    X'00'              REPLY MODE TO BE SET.
STRMDLEN EQU   *-STRPLYMD
         DC    X'41424346'        POSSIBLE ATTRIBUTES.
PSAWSF   DC    X'F3'              WSF TO LOAD ENTIRE 190 BYTES OF PSA.
         DC    AL2(190*18+7)      SINGLE PLANE.
         DC    X'06'              LPS ID.
         DC    X'41'              BASIC; CLEAR; DISPLAY TYPE 1.
         DC    X'DA'              SYMBOL-SET ID.
         DC    X'41'              FIRST CODE POINT TO BE ADDED.
         DC    X'02'              LOADABLE TERMINAL STORAGE ID.
NEWSYMSF DC    X'F3'              PSA NEW SYMBOL ADDITION.
SYMFIELD DC    AL2(ADDSYMLN)      SINGLE PLANE.
         DC    X'06'              LPS ID.
         DC    X'01'              BASIC; DO NOT CLEAR; DISPLAY TYPE 1.
NEWSTGID DC    X'DA'              SYMBOL-SET ID.
NEWCDPNT DC    X'00'              CODE POINT TO BE ADDED.
         DC    X'02'              LOADABLE TERMINAL STORAGE ID.
NEWBITS  DC    18X'00'            BIT PATTERN DEFINING SYMBOL.
SYMWRTLN EQU   *-NEWSYMSF
ADDSYMLN EQU   *-SYMFIELD
SINGLSYM DC    X'F3'              PSA DEMONSTRATION (X'DA').
PLANE1   DC    AL2(PLANE1LN)      SINGLE PLANE.
         DC    X'0641DAEA02'
PRIMEPSA DC    B'1111000011110000'                       X'EA'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'0000111100001111'                       X'EB'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'1111000011110000'                       X'EC'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'0000111100001111'                       X'ED'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'1000100010001000'                       X'EE'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'1010101010101010'                       X'EF'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'0000000000100000'                       X'F0'
         DC    B'00000000',B'00000000',B'00000001',B'00111010'
         DC    B'01000100',B'10001010',B'10010010',B'10100010'
         DC    B'01000100',B'10111000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'1111111111111111'                       X'F1'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'1111111111111111'                       X'F2'
         DC    B'10000000',B'10000000',B'10000000',B'10000000'
         DC    B'10000000',B'10000000',B'10000000',B'10000000'
         DC    B'10000000',B'10000000',B'10000000',B'10000000'
         DC    B'10000000',B'10000000',B'10000000',B'10000000'
         DC    B'1111111111111111'                       X'F3'
         DC    B'11000000',B'11000000',B'11000000',B'11000000'
         DC    B'11000000',B'11000000',B'11000000',B'11000000'
         DC    B'11000000',B'11000000',B'11000000',B'11000000'
         DC    B'11000000',B'11000000',B'11000000',B'11000000'
         DC    B'1111111111111111'                       X'F4'
         DC    B'11100000',B'11100000',B'11100000',B'11100000'
         DC    B'11100000',B'11100000',B'11100000',B'11100000'
         DC    B'11100000',B'11100000',B'11100000',B'11100000'
         DC    B'11100000',B'11100000',B'11100000',B'11100000'
         DC    B'1111111111111111'                       X'F5'
         DC    B'11110000',B'11110000',B'11110000',B'11110000'
         DC    B'11110000',B'11110000',B'11110000',B'11110000'
         DC    B'11110000',B'11110000',B'11110000',B'11110000'
         DC    B'11110000',B'11110000',B'11110000',B'11110000'
         DC    B'1111111111111111'                       X'F6'
         DC    B'11111000',B'11111000',B'11111000',B'11111000'
         DC    B'11111000',B'11111000',B'11111000',B'11111000'
         DC    B'11111000',B'11111000',B'11111000',B'11111000'
         DC    B'11111000',B'11111000',B'11111000',B'11111000'
         DC    B'1111111111111111'                       X'F7'
         DC    B'11111100',B'11111100',B'11111100',B'11111100'
         DC    B'11111100',B'11111100',B'11111100',B'11111100'
         DC    B'11111100',B'11111100',B'11111100',B'11111100'
         DC    B'11111100',B'11111100',B'11111100',B'11111100'
         DC    B'1111111111111111'                       X'F8'
         DC    B'11111110',B'11111110',B'11111110',B'11111110'
         DC    B'11111110',B'11111110',B'11111110',B'11111110'
         DC    B'11111110',B'11111110',B'11111110',B'11111110'
         DC    B'11111110',B'11111110',B'11111110',B'11111110'
         DC    B'1111111111111111'                       X'F9'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'1111000011110000'                       X'FA'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'0000111100001111'                       X'FB'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'0000111100001111'                       X'FC'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'1111000011110000'                       X'FD'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'11000111',B'11000111',B'11000111',B'11000111'
         DC    B'00111000',B'00111000',B'00111000',B'00111000'
         DC    B'1000100010001000'                       X'FE'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
         DC    B'00010001',B'10101010',B'01000100',B'10101010'
PRIMELEN EQU   *-PRIMEPSA
PLANE1LN EQU   *-PLANE1
SINGLEN  EQU   *-SINGLSYM
TRIPLSYM DC    X'F3'              PSC DEMONSTRATION (X'DC').
PLANEB   DC    AL2(PLANEBLN)      BLUE PLANE.
         DC    X'06C1DCF004060009100001'
         DC    B'1010101001010101'      "LAYERS"         X'F0'
         DC    B'11111111',B'00000000',B'11111111',B'00000000'
         DC    B'11111111',B'00000000',B'11111111',B'00000000'
         DC    B'00000000',B'11111111',B'00000000',B'11111111'
         DC    B'00000000',B'11111111',B'00000000',B'11111111'
         DC    B'1111111111111111'      "LILAC"          X'F1'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'0000000000000000'      "ORANGE"         X'F2'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0000000000000000'      "MUSTARD"        X'F3'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'1010101010101010'      "AQUAMARINE"     X'F4'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'1010101010101010'      "PURPLE"         X'F5'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'1001001001001001'      "GREY"           X'F6'
         DC    B'00100100',B'01001001',B'10010010',B'00100100'
         DC    B'01001001',B'10010010',B'00100100',B'01001001'
         DC    B'10010010',B'00100100',B'01001001',B'10010010'
         DC    B'00100100',B'01001001',B'10010010',B'00100100'
         DC    B'1111111111111111'  "STATE BANK LEFT"    X'F7'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'1111111111111111'  "STATE BANK RIGHT"   X'F8'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'1111111111111111'      "STATE BANK"     X'F9'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
PLANEBLN EQU   *-PLANEB
PLANER   DC    AL2(PLANERLN)      RED PLANE.
         DC    X'06C1DCF004060009100002'
         DC    B'1100110000110011'      "LAYERS"         X'F0'
         DC    B'11111111',B'11111111',B'00000000',B'00000000'
         DC    B'11111111',B'11111111',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'11111111',B'11111111'
         DC    B'00000000',B'00000000',B'11111111',B'11111111'
         DC    B'1010101010101010'      "LILAC"          X'F1'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'1111111111111111'      "ORANGE"         X'F2'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'1010101010101010'      "MUSTARD"        X'F3'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'0000000000000000'      "AQUAMARINE"     X'F4'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0101010101010101'      "PURPLE"         X'F5'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'0100100100100100'      "GREY"           X'F6'
         DC    B'10010010',B'00100100',B'01001001',B'10010010'
         DC    B'00100100',B'01001001',B'10010010',B'00100100'
         DC    B'01001001',B'10010010',B'00100100',B'01001001'
         DC    B'10010010',B'00100100',B'01001001',B'10010010'
         DC    B'0000000000000000'  "STATE BANK LEFT"    X'F7'
         DC    B'00000000',B'00000000',B'00000000',B'11111111'
         DC    B'01111111',B'00111111',B'00011111',B'00001111'
         DC    B'00000111',B'00000011',B'00000001',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0001111111100000'  "STATE BANK RIGHT"   X'F8'
         DC    B'00000000',B'00000000',B'00000000',B'11111110'
         DC    B'11111100',B'11111000',B'11110000',B'11100000'
         DC    B'11000000',B'10000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0000000000000000'      "STATE BANK"     X'F9'
         DC    B'00000000',B'00000000',B'11111110',B'11111110'
         DC    B'01111100',B'01111100',B'00111000',B'00111000'
         DC    B'00010000',B'00010000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
PLANERLN EQU   *-PLANER
PLANEG   DC    AL2(PLANEGLN)      GREEN PLANE.
         DC    X'06C1DCF004060009100004'
         DC    B'1111000000001111'      "LAYERS"         X'F0'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'0000000000000000'      "LILAC"          X'F1'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'1010101010101010'      "ORANGE"         X'F2'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'01010101',B'10101010',B'01010101',B'10101010'
         DC    B'0101010101010101'      "MUSTARD"        X'F3'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'10101010',B'01010101',B'10101010',B'01010101'
         DC    B'1111111111111111'      "AQUAMARINE"     X'F4'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'0000000000000000'      "PURPLE"         X'F5'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0010010010010010'      "GREY"           X'F6'
         DC    B'01001001',B'10010010',B'00100100',B'01001001'
         DC    B'10010010',B'00100100',B'01001001',B'10010010'
         DC    B'00100100',B'01001001',B'10010010',B'00100100'
         DC    B'01001001',B'10010010',B'00100100',B'01001001'
         DC    B'0000000000000000'  "STATE BANK LEFT"    X'F7'
         DC    B'00000000',B'00000000',B'00000000',B'11111111'
         DC    B'01111111',B'00111111',B'00011111',B'00001111'
         DC    B'00000111',B'00000011',B'00000001',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0001111111100000'  "STATE BANK RIGHT"   X'F8'
         DC    B'00000000',B'00000000',B'00000000',B'11111110'
         DC    B'11111100',B'11111000',B'11110000',B'11100000'
         DC    B'11000000',B'10000000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
         DC    B'0000000000000000'      "STATE BANK"     X'F9'
         DC    B'00000000',B'00000000',B'11111110',B'11111110'
         DC    B'01111100',B'01111100',B'00111000',B'00111000'
         DC    B'00010000',B'00010000',B'00000000',B'00000000'
         DC    B'00000000',B'00000000',B'00000000',B'00000000'
PLANEGLN EQU   *-PLANEG
TRIPLEN  EQU   *-TRIPLSYM
RESETAID DC    X'27F5C3'
SYMSETS  DC    8XL8'003F'         SYMBOL-SET CONTENTS AND IDENTIFIERS.
REPLIES  DC    CL4' '
TGETHDNG DC    C'TERMINAL INPUT DATA (IN HEX):      '
QUERYHDG DC    C'LENG Q-ID QUERY-REPLY-FIELD-DETAILS'
SACOLR   DCS   SA,COLOUR,BLUE
         DC    C'BLUE(1)'
SACOLR2  DCS   SA,COLOUR,RED
         DC    C'RED(2)'
SACOLR3  DCS   SA,COLOUR,PINK
         DC    C'PINK(3)'
SACOLR4  DCS   SA,COLOUR,GREEN
         DC    C'GREEN(4)'
SACOLR5  DCS   SA,COLOUR,TURQ
         DC    C'TURQUOISE(5)'
SACOLR6  DCS   SA,COLOUR,YELLOW
         DC    C'YELLOW(6)'
SACOLR7  DCS   SA,COLOUR,WHITE
         DC    C'WHITE(7)'
SACOLRLN EQU   *-SACOLR
PGMSYMSG DC    CL31'(''SYMSET#'' = SHOW SYMBOL SET # '
         DC    CL21'WHERE # IS FROM 0 TO '
TOPSYMID DC    CL3'?.)'
SCREEN   DCS   X'C1',SBA,(1,1),SF,PROHIS
SCRNHDG  DC    C'TSO 3270 VDU TEST'
         DCS   SF,PROMDS
         DC    C' (''Z''|''END'' = EXIT.  '
         DC    C'''HELP'' = DISPLAY HELP SCREEN.)'
         DCS   RA
PAGROW2  DCS   (2,1)
         DC    C' '
         DCS   SF,PROHIS
ERRMSG   DC    CL18' '
         DCS   SF,PROMDS
MSGL     DC    CL55'(PF8 AND SYMSET COMMANDS NOT ACTIVE FOR THIS SCREEN+
               .)  '
         DCS   RA
PAGROW3  DCS   (3,1)
         DCS   C' ',SF,PROHIS
         DC    C'UNMODIFIED-FIELD-ATTRIBUTE-BYTES: '
         DC    C' ,-,D,U,H,Y,<,%,&&,0,M,4,Q,8,*,@.'
         DCS   RA
PAGROW4  DCS   (4,1)
         DC    C' '
         DC    X'1D',9C' ',X'1D',9C'-',X'1D',9C'D',X'1D',9C'U'
         DC    X'1D',9C'H',X'1D',9C'Y',X'1D',9C'<',X'1D',9C'%'
         DCS   RA
PAGROW5  DCS   (5,1)
         DC    C' '
         DC    X'1D',9C'&&',X'1D',9C'0',X'1D',9C'M',X'1D',9C'4'
         DC    X'1D',9C'Q',X'1D',9C'8',X'1D',9C'*',X'1D',9C'@'
         DCS   SF,PROHIS,RA
PAGROW6  DCS   (6,2)
MACROHDG DC    C'  TSO-MACRO   WORD0/R0  WORD1/R1  RTCD/R15'
         DCS   SF,PROLOS,RA
PAGROW7  DCS   (7,2)
         DC    CL14'  GTSIZE      '
GTSIZER0 DC    CL8' '
         DC    CL2' '
GTSIZER1 DC    CL8' '
         DC    CL2' '
GTSIZERC DC    CL8' '
LINSMSG  DC    CL4' '
         DC    C' LINES '
COLSMSG  DC    CL4' '
         DC    C' COLUMNS'
         DCS   RA
PAGROW8  DCS   (8,2)
GTTERM1  DC    CL14'  GTTERM      '
GTTERMSZ DC    CL8' '
         DC    CL2' '
GTTERMAT DC    CL8' '
         DC    CL2' '
GTTERMRC DC    CL8' '
         DC    CL2' '
TERMLANG DC    CL6'EBCDIC'
         DC    C' TERMINAL  QUERY BIT '
QSWITCH  DC    CL3'ON '
         DCS   RA
PAGROW9  DCS   (9,2)
         DC    CL34'  STCOM    NO                     '
STCOMRC  DC    CL8' '
         DC    CL2' '
CHARMSG  DC    CL33' '
         DCS   RA
PAGROW10 DCS   (10,2)
         DC    CL34'  STFSMODE ON,INITIAL+NOEDIT=YES  '
STFSMDRC DC    CL8' '
         DC    CL2' '
ADDRMSG  DC    CL32' '
         DCS   RA
PAGROW11 DCS   (11,2)
         DC    CL34'  STTMPMD  ON,KEYS=ALL            '
STMPMDRC DC    CL8' '
         DC    CL2' '
DSSFMSG  DC    CL35' '
         DCS   RA
PAGROW12 DCS   (12,2)
GTTERM2  DC    CL14'  TERMTYPE    '
TRMTYPR0 DC    CL8' NON-MVS'
         DC    CL2' '
TRMTYPR1 DC    CL8'MACRO   '
         DC    CL2' '
TRMTYPRC DC    CL8'MSP ONLY'
         DC    CL2' '
TERMNAME DC    CL8' '
         DCS   RA
PAGROW13 DCS   (13,2)
         DC    CL24'  TGET     ASIS,WAIT    '
TGETR1   DC    CL8' '
         DC    CL2' '
TGETRC   DC    CL8' '
         DC    C'  AID='
AIDHEX   DC    C'  '
         DC    C'('
AIDCHAR  DC    C' '
         DC    C')  CURSOR-POSITION='
POSIHEX  DC    C'    '
         DC    C' ' (
POSICHAR DC    C'  '
         DC    C' ' )
         DCS   RA
PAGROW14 DCS   (14,2)
WRITEMAC DC    CL34'  TPUT     FULLSCR,WAIT           '
TPUTRC   DC    CL8' '
         DC    CL2' '
QLSTMSG  DC    CL29' '
         DCS   RA
PAGROW15 DCS   (15,1)
         DCS   C' ',SF,PROHIS
INPUTHDG DC    C'TERMINAL INPUT DATA (IN HEX):      '
         DCS   SF,PROMDS
FIELDPFK DC    C' (FIELD TEST PFKS: 10-12, 1-7, 8(GE))'
         DCS   SF,PROLOS,RA
PAGROW16 DCS   (16,1)
         DC    C' '
TGETDTLS DC    CL80' N/A (QUERY NOT SUPPORTED) '
         DC    7CL80' '
COLORTRL DC    CL80' '
         DCS   SBA
INSRTCSR DCS   (4,2)
         DCS   IC
SCRNLNTH EQU   *-SCREEN
SAHLIT   DCS   SBA
HILITTRL DCS   (23,1)
SANORMAL DCS   SA,NORMAL,NORMAL,SF,PROHIS
         DCS   C'CHARACTER ATTRIBUTES:',SF,PROLOS
         DC    C'NORMAL'
SAHILIT1 DCS   SA,HILITE,BLINK
         DC    C'BLINK'
SAHILIT2 DCS   SA,HILITE,REVERSE
         DC    C'REVERSE'
SAHILIT4 DCS   SA,HILITE,USCORE
         DC    C'UNDERSCORE'
SAHILIT0 DCS   SA,HILITE,NORMAL
SAHLITLN EQU   *-SAHLIT
SASYM    DCS   SA,PGMSYM,X'F1'
         DC    X'4157538A8B8F9FC2D2B6B89A9BAAAB9DBABBC3'
         DC    C'0123456789'
SANOSYM  DCS   SA,PGMSYM,NORMAL
SAHILIT  DCS   SA,HILITE
FILHILIT DCS   NORMAL
FILCLRSA DC    C'  '
FILCOLOR DCS   NORMAL
         DCS   SBA
CROSPOSI DCS   (24,58)
         DCS   RA,(1,1),GE,C'L'
SASYMLEN EQU   *-SASYM
         SPACE
SYMBOLPG DC    X'C11140403C404040131DF8'
         DC    C'PROGRAM SYMBOL-SET DISPLAY - TERMINAL STORAGE ID=0'
STORAGID DC    C'?'
         DC    X'11'
SYMROW2  DCS   (2,1)
         DC    C' '
READLOAD DC    CL9' '
         DC    C' '
PLANENUM DC    CL4' '
         DC    C'LE-PLANE STORAGE - SYMBOL-SET ID=X'''
SYMIDENT DC    C'???'
CSIDMSG  DC    C' - CGCSGID=0000-0000 '
         DC    X'11'
SYMROW3  DCS   (3,1)
         DC    X'1DF0'
         DC    C'(SYMBOL-SET ID=X''FF'' INDICATES STORAGE UNASSOCIATED +
               WITH ANY SYMBOL-SET.)'
SYMHDLEN EQU   *-SYMBOLPG
TRIPLCLR DC    CL3' '
         DC    X'11'
SYMROW5  DCS   (5,1)
         DC    X'1DF8',C'  0123456789ABCDEF',X'1DF0',CL5' '
         DC    C'(ONLY CODES FROM X''40'' TO X''FE'' ARE DISPLAYABLE.)'
         DC    X'11'
SYMROW6  DCS   (6,1)
         DC    X'1DF8',C'4',X'1DF02843'
ROW6SYM  DC    X'00'
         DC    X'404142434445464748494A4B4C4D4E4F28430011'
SYMROW7  DCS   (7,1)
         DC    X'1DF8',C'5',X'1DF02843'
ROW7SYM  DC    X'00'
         DC    X'505152535455565758595A5B5C5D5E5F28430011'
SYMROW8  DCS   (8,1)
         DC    X'1DF8',C'6',X'1DF02843'
ROW8SYM  DC    X'00'
         DC    X'606162636465666768696A6B6C6D6E6F28430011'
SYMROW9  DCS   (9,1)
         DC    X'1DF8',C'7',X'1DF02843'
ROW9SYM  DC    X'00'
         DC    X'707172737475767778797A7B7C7D7E7F28430011'
SYMROW10 DCS   (10,1)
         DC    X'1DF8',C'8',X'1DF02843'
ROW10SYM DC    X'00'
         DC    X'808182838485868788898A8B8C8D8E8F28430011'
SYMROW11 DCS   (11,1)
         DC    X'1DF8',C'9',X'1DF02843'
ROW11SYM DC    X'00'
         DC    X'909192939495969798999A9B9C9D9E9F28430011'
SYMROW12 DCS   (12,1)
         DC    X'1DF8',C'A',X'1DF02843'
ROW12SYM DC    X'00'
         DC    X'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF28430011'
SYMROW13 DCS   (13,1)
         DC    X'1DF8',C'B',X'1DF02843'
ROW13SYM DC    X'00'
         DC    X'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF28430011'
SYMROW14 DCS   (14,1)
         DC    X'1DF8',C'C',X'1DF02843'
ROW14SYM DC    X'00'
         DC    X'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF28430011'
SYMROW15 DCS   (15,1)
         DC    X'1DF8',C'D',X'1DF02843'
ROW15SYM DC    X'00'
         DC    X'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF28430011'
SYMROW16 DCS   (16,1)
         DC    X'1DF8',C'E',X'1DF02843'
ROW16SYM DC    X'00'
         DC    X'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF28430011'
SYMROW17 DCS   (17,1)
         DC    X'1DF8',C'F',X'1DF02843'
ROW17SYM DC    X'00'
         DC    X'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFE284300'
SYMPGLEN EQU   *-SYMBOLPG
         DC    X'1DF8',C'      (''DELSYM'
DELSYMID DC    C'?'' = FREE THIS SYMBOL STORAGE.)'
SYMSGLEN EQU   *-SYMBOLPG
HELPPAGE DC    X'C11140403C404040131DF8'
         DC    C'TERMTEST &REL  -  LIST OF SUBCOMMANDS  -  &TRMDATE'
         DC    X'1DF411'
HLPROW3  DCS   (3,1)
         DC    C'END  (Z) - TERMINATE TERMTEST.            '
         DC    C'HELP (?) - DISPLAY THIS PAGE. ',X'11'
HLPROW4  DCS   (4,1)
         DC    C'CAN      - TERMINATE TERMTEST WITHOUT SAVING CHANGES T+
               O THE PSA PROFILE.',X'11'
HLPROW5  DCS   (5,1)
         DC    C'REPLYMD# - SET TERMINAL REPLY MODE.  (#: 0=FIELD(DFLT)+
                1=EXT-FIELD 2=CHAR-ATTR)',X'11'
HLPROW6  DCS   (6,1)
         DC    C'READBUFF - ISSUE A READ BUFFER COMMAND.',X'11'
HLPROW7  DCS   (7,1)
         DC    C'SYMSET#  - DISPLAY SYMBOL-SET # IF SYMBOL-SETS ARE SUP+
               PORTED.',X'11'
HLPROW8  DCS   (8,1)
         DC    C'DELSYM#  - FREE PROGRAM-LOADABLE SYMBOL-SET #.',X'11'
HLPROW9  DCS   (9,1)
         DC    C'NEWSYM## - SPECIFY SYMBOL X''##'' IN SYMBOL-SET 2 (PSA+
               ).',X'11'
HLPROW10 DCS   (10,1)
         DC    C'PUNCH{X} - WRITE ASSEMBLER {HEX} SOURCE OF SYMBOL-SET +
               2 (PSA) TO SYSPUNCH.',X'11'
HLPROW11 DCS   (11,1)
         DC    C'QUERY    - FORCE A TERMINAL QUERY.  CAREFUL!  (RESULTS+
                LOGICALLY IGNORED.)',X'11'
HLPROW12 DCS   (12,1)
         DC    C'REINITQ  - RE-INITIALIZE AS IF THE QUERY BIT IS ON.  E+
               RRORS ARE YOUR PROBLEM.',X'11'
HLPROW13 DCS   (13,1)
         DC    C'QLISTALL - FORCE A QUERY LIST ALL.  WATCH OUT IF QUERY+
                IS NOT SUPPORTED.',X'11'
HLPROW14 DCS   (14,1)
         DC    C'QLIST##  - FORCE A QUERY LIST FOR QCODE X''##''.  QUER+
               Y LIST SUPPORT IS ESSENTIAL.',X'11'
HLPROW16 DCS   (16,1)
         DC    C'IF SYMBOL-SETS 2 (PSA) AND/OR 4 (PSC) ARE FREE THEY WI+
               LL BE LOADED BY',X'11'
HLPROW17 DCS   (17,1)
         DC    C'TERMTEST WITH SOME SAMPLE CHARACTER SYMBOLS.',X'11'
HLPROW19 DCS   (19,1)
         DC    C'IF A FIELD IS MODIFIED AND ENTERED WITH A FIELD-TEST P+
               FK, THE CORRESPONDING',X'11'
HLPROW20 DCS   (20,1)
         DC    C'ATTRIBUTE OF THAT FIELD WILL BE CHANGED.  SINCE APL IS+
                NOT A VALID FIELD',X'11'
HLPROW21 DCS   (21,1)
         DC    C'ATTRIBUTE, GRAPHIC ESCAPE (GE) CODES WILL BE USED WITH+
                SAMPLE OUTPUT DATA',X'11'
HLPROW22 DCS   (22,1)
         DC    C'INSTEAD.  THE CLEAR BUTTON MAY BE USED TO CLEAR PFK-SP+
               ECIFIED MODIFICATIONS.',X'11'
HLPROW23 DCS   (23,1)
         DC    C'7-COLOUR SCREENS SHOULD ALSO REVERT TO 4-COLOUR MODE B+
               ECAUSE ALL EXTENDED',X'11'
HLPROW24 DCS   (24,1)
         DC    C'COLOUR DATA WILL ALSO BE CLEARED.'
HELPGLEN EQU   *-HELPPAGE
NEWSYMPG DC    X'C11140403C4040001DF8'
         DC    C'SPECIFY NEW SYMBOL FOR CODE POINT X'''
CODEPNT  DC    C'??'
         DC    C'''.  ENTER ''SYMSET2'' TO DISPLAY IT.'
         DC    X'1DF011'
NEWROW3  DCS   (3,1)
         DC    X'1DD113',9C'0',X'1DF4'
         DC    C'   DENOTE ELECTRON TARGET LOCATIONS WITH A ''1''.'
         DC    X'11'
NEWROW4  DCS   (4,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW5  DCS   (5,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW6  DCS   (6,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW7  DCS   (7,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW8  DCS   (8,1)
         DC    X'1DD1',9C'0',X'1DF8'
NOSAVMSG DC    C'   SYMBOL SET UPDATES WILL NOT BE SAVED.'
         DC    X'11'
NEWROW9  DCS   (9,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW10 DCS   (10,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW11 DCS   (11,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW12 DCS   (12,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW13 DCS   (13,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW14 DCS   (14,1)
         DC    X'1DD1',9C'0',X'1DF4'
         DC    C'___DATA BELOW THIS LINE IS NOT SHOWN IN 32-LINE MODE.'
         DC    X'11'
NEWROW15 DCS   (15,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW16 DCS   (16,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW17 DCS   (17,1)
         DC    X'1DD1',9C'0',X'1DF411'
NEWROW18 DCS   (18,1)
         DC    X'1DD1',9C'0',X'1DF8'
         DC    C'   USE PF3/15 TO CANCEL SYMBOL UPDATE.'
NEWSYMLN EQU   *-NEWSYMPG
         SPACE
         PRINT NOGEN
ISPPROF  DCB   DSORG=PO,DDNAME=ISPPROF,MACRF=(R,W),RECFM=FB,LRECL=80,  +
               EODAD=EODAD,SYNAD=SYNAD
         PRINT GEN
         SPACE
         LTORG
         DS    0D
TABLE    DC    X'40C1C2C3C4C5C6C7C8C94A4B4C4D4E4F'
         DC    X'50D1D2D3D4D5D6D7D8D95A5B5C5D5E5F'
         DC    X'6061E2E3E4E5E6E7E8E96A6B6C6D6E6F'
         DC    X'F0F1F2F3F4F5F6F7F8F97A7B7C7D7E7F'
XLATEHEX DC    193X'FF',X'0A0B0C0D0E0F',41X'FF'
         DC    X'00010203040506070809',6X'FF'
         DS    0D
         DC    C'   ANOTHER QUALITY PRODUCT FOR TSO BY GREG PRICE'
         DC    C' OF PRYCROFT SIX PTY LTD'
         DS    0D                 END OF CSECT.
         SPACE
         DROP  R9,R10,R11,R12     TERMTEST.
         TITLE ' READ PARTITION RESPONSE FORMATTING SUBROUTINE '
QUERYFMT CSECT
         STM   R14,R12,SAVEAREA+12
         LR    R11,R15
         USING QUERYFMT,R11       THE USUAL....
         ST    R0,WORK            SAVE TGET RETURN CODE.
         UNPK  QGETRC(9),WORK(5)
         TR    QGETRC,QHEX-C'0'
         MVI   QGETRC+8,C' '
         ST    R1,WORK            SAVE TGET DATA LENGTH.
         UNPK  QGETLEN(9),WORK(5)
         TR    QGETLEN,QHEX-C'0'
         MVI   QGETLEN+8,C' '
         UNPK  QAIDHEX(3),INBUFF(2)
         TR    QAIDHEX,QHEX-C'0'  REPORT THE AID RETURNED.
         MVI   QAIDHEX+2,C'('
         MVC   QAIDCHAR,INBUFF
         TCLEARQ INPUT            CLEAR UNWANTED INPUT.
         L     R1,WORK            RESTORE TGET DATA LENGTH.
         CLI   COLUMNS+3,80       EIGHTY COLUMN SCREEN?
         BE    QROW3OK            YES.
         L     R0,COLUMNS         NO, GET THE NUMBER OF COLUMNS.
         SLL   R0,1               DOUBLE IT.
         STCM  R0,3,QROW3         MAKE DETAILS START ON ROW THREE.
         SLL   R0,2
         STCM  R0,2,QROW3
         NI    QROW3+1,X'3F'      USE 12-BIT ADDRESS FORMAT.
         TR    QROW3,TABLEFMT
QROW3OK  LA    R5,INBUFF+1        POINT PAST AID.
         SLR   R0,R0              CLEAR FOR INSERTS.
         BCTR  R1,0               GET DATA STREAM LENGTH AFTER AID.
         SPACE
RDBFPAGE LA    R3,TEMPSCRN-8190
         LA    R3,4095(,R3)
         LA    R3,4095(,R3)       POINT TO SCREEN IMAGE.
         MVC   0(FMTHDRLN,R3),FMTHDR
         LA    R3,FMTHDRLN(,R3)
         CLI   INBUFF,X'88'       QUERY FORMAT REQUEST?
         BE    QNEWQBIT           YES, PROCESS FIRST SUB-FIELD.
         L     R0,LINES           GET THE NUMBER OF SCREEN LINES.
         SLL   R0,5               MULTIPLY BY THIRTY-TWO.
         SR    R1,R0              UPDATE LENGTH FOR FOLLOWING PAGES.
         BNM   RDBFLOOP           A WHOLE PAGE IS OKAY SO PROCEED.
         AR    R1,R0              RESTORE REMAINING LENGTH.
         LR    R0,R1              COPY THE LENGTH FOR THIS PAGE.
         SLR   R1,R1              RESET LENGTH FOR FOLLOWING PAGES.
         SPACE
RDBFLOOP CLI   0(R5),X'1D'        START FIELD?
         BE    RDBFIELD           YES.
         CLI   0(R5),X'29'        START FIELD EXTENDED?
         BNE   RDBFBYTE           NO.
RDBFIELD MVC   0(2,R3),=C'  '     YES, LEAVE TWO BLANKS FOR NEW FIELD.
         LA    R3,2(,R3)          ADJUST OUTPUT POINTER.
RDBFBYTE UNPK  0(3,R3),0(2,R5)    UNPACK THE JUNK BYTE.
         TR    0(2,R3),QHEX-C'0'
         LA    R3,2(,R3)          ADJUST OUTPUT POINTER.
         LA    R5,1(,R5)          ADJUST INPUT POINTER.
         BCT   R0,RDBFLOOP        DECREMENT PAGE DATA STREAM COUNTER.
         B     DONEFMT
         SPACE
QNEWQBAD LTR   R0,R0              ON SUB-FIELD BOUNDARY?
         BNZ   QJUNKGUF           NO.
         LA    R0,1               YES, BUT NOT NOW.
         MVC   0(2,R3),=C'  '     LEAVE TWO BLANKS FOR NEW SUB-FIELD.
         LA    R3,2(,R3)          ADJUST OUTPUT POINTER.
QJUNKGUF UNPK  0(3,R3),0(2,R5)    UNPACK THE JUNK BYTE.
         TR    0(2,R3),QHEX-C'0'
         LA    R3,2(,R3)          ADJUST OUTPUT POINTER.
         LA    R5,1(,R5)          ADJUST INPUT POINTER.
         BCT   R1,QNEWQFIX        DECREMENT DATA STREAM COUNTER.
         B     DONEFMT            JUST IN CASE.
QNEWQFIX TM    3(R5),X'80'        QUERY REPLY SUB-FIELD?
         BNO   QNEWQBAD           NO, UNPACK A STRAY BYTE.
         CLI   0(R5),X'00'        QUERY REPLY SUB-FIELD?
         BNE   QNEWQBAD           NO, HOPE REALLY NOT LONGER THAN 255.
QNEWQBIT CLI   2(R5),X'81'        QUERY REPLY SUB-FIELD?
         BNE   QNEWQBAD           NO, UNPACK A STRAY BYTE.
         MVC   0(2,R3),=C'  '     LEAVE TWO BLANKS FOR NEW SUB-FIELD.
         UNPK  2(5,R3),0(3,R5)    FORMAT SOME DATA HERE.
         TR    2(4,R3),QHEX-C'0'
         MVC   6(2,R3),QPROHIS    DISPLAY LENGTH BYTES.
         UNPK  8(5,R3),2(3,R5)
         TR    8(4,R3),QHEX-C'0'
         MVC   12(2,R3),QPROLOS   DISPLAY ID BYTES.
         LA    R3,14(,R3)         POINT TO START OF DETAIL AREA.
         ICM   R0,3,0(R5)         GET LENGTH OF THIS BIT.
         CR    R1,R0              SUB-FIELD LONGER THAN REST OF DATA?
         BNL   QBITLNOK           NO.
         LR    R0,R1              YES, REDUCE SUB-FIELD LENGTH.
QBITLNOK LR    R7,R0              SAVE IT.
         LA    R15,4              LENGTH OF LENGTH AND ID BYTES.
         AR    R5,R15             POINT PAST LENGTH AND ID.
         SR    R0,R15
         BNP   QNOSBFLD           CATER FOR NULL REPLY.
QHEXBYTE UNPK  0(3,R3),0(2,R5)    UNPACK A BYTE.
         TR    0(2,R3),QHEX-C'0'  MAKE DISPLAYABLE.
         LA    R3,2(,R3)          ADJUST OUTPUT POINTER.
         LA    R5,1(,R5)          ADJUST INPUT POINTER.
         BCT   R0,QHEXBYTE        DECREMENT RESIDUAL BIT BYTE COUNTER.
QNOSBFLD SR    R1,R7              ANY MORE SUB-FIELDS?
         BP    QNEWQBIT           YES.
         SPACE
DONEFMT  ST    R1,WORK            SAVE DATA STREAM PROCESSING STATUS.
         LTR   R1,R1              ANY MORE DATA?
         BNP   DONEFMTL           NO, THIS IS THE LAST PAGE.
         MVC   0(MOREFMTL,R3),MOREFMT
         LA    R3,MOREFMTL(,R3)   YES, INDICATE THIS.
DONEFMTL LA    R1,TEMPSCRN-8190
         LA    R1,4095(,R1)
         LA    R1,4095(,R1)       POINT TO SCREEN IMAGE.
         LR    R0,R3              POINT PAST END OF DATA.
         SR    R0,R1              GET DATA STREAM LENGTH.
         ICM   R1,8,=X'03'        LOAD FULLSCREEN TPUT FLAGS.
         TPUT  (1),(0),R          SHOW HEX OF QUERY RESPONSE.
         ICM   R1,15,WORK         LOAD DATA STREAM PROCESSING STATUS.
         BNP   DONEFMTX           EXIT IF FINISHED.
         LA    R1,TEMPSCRN-8190
         LA    R1,4095(,R1)
         LA    R1,4095(,R1)       POINT TO INPUT BUFFER.
         LA    R0,L'TEMPSCRN      GET MAXIMUM LENGTH OF INPUT.
         ICM   R1,8,=X'81'        LOAD FLAGS FOR ASIS,WAIT TGET.
         TGET  (1),(0),R          READ TERMINAL INPUT.
         L     R1,WORK            LOAD DATA STREAM PROCESSING STATUS.
         B     RDBFPAGE           OUTPUT NEXT PAGE.
DONEFMTX LM    R14,R12,SAVEAREA+12
         BR    R14                HAVE A GUESS....
         TITLE ' FORMAT SUBROUTINE VARIABLES AND CONSTANTS '
TABLEFMT DC    X'40C1C2C3C4C5C6C7C8C94A4B4C4D4E4F'
         DC    X'50D1D2D3D4D5D6D7D8D95A5B5C5D5E5F'
         DC    X'6061E2E3E4E5E6E7E8E96A6B6C6D6E6F'
         DC    X'F0F1F2F3F4F5F6F7F8F97A7B7C7D7E7F'
MOREFMT  DCS   SF,PROHIS,C'   + ',IC
MOREFMTL EQU   *-MOREFMT
FMTHDR   DCS   X'C3',SBA,(1,1),RTA,(1,1),X'00',IC
QPROHIS  DCS   SF,PROHIS
         DC    C'READ PARTITION (QUERY) TGET RESULTS:'
         DCS   SF,PROMDS
         DC    C' RC='
QGETRC   DC    C'00000000'
         DC    C' LEN='
QGETLEN  DC    C'00000000'
         DC    C' AID='
QAIDHEX  DC    C'88'
         DC    C'('
QAIDCHAR DC    X'88'
         DC    C')'
QPROLOS  DCS   SF,PROLOS,SBA
QROW3    DCS   (3,1)
FMTHDRLN EQU   *-FMTHDR
         SPACE
         LTORG
         SPACE
         DS    0D
QHEX     DC    C'0123456789ABCDEF'
         DS    0D                 END OF CSECT.
         SPACE
         DROP  R11                QUERYFMT.
         TITLE ' SYMBOL ASSEMBLER SOURCE OUTPUT SUBROUTINE '
SYMPUNCH CSECT
         STM   R14,R12,SAVEAREA+12
         LR    R11,R15
         USING SYMPUNCH,R11       THE USUAL....
         LA    R1,SAVAREA2
         ST    R13,SAVAREA2+4     CHAIN SAVE AREAS.
         ST    R1,SAVEAREA+8
         DROP  R13                TERMBUFR.
         LR    R13,R1
         USING SAVAREA2,R13
         LA    R15,8              PREPARE FOR MISSING DD CARD.
         SLR   R5,R5
         L     R4,540             GET POINTER TO CURRENT TCB.
         L     R4,12(,R4)         POINT TO TIOT.
         LA    R4,24(,R4)         POINT TO TIOELNGH.
CHKPUNCH CLC   4(8,R4),SYSPUNCH+DCBDDNAM-IHADCB
         BE    OPNPUNCH           FILE EXISTS SO GO AND OPEN IT.
         IC    R5,0(,R4)          GET TIOT ENTRY LENGTH.
         AR    R4,R5              POINT TO NEXT TIOT ENTRY.
         CLI   0(R4),0            ZERO LENGTH ENTRY?
         BNE   CHKPUNCH           NO, CHECK OUT THIS ENTRY.
         B     PUNCHRTN           YES, NOT IN TIOT SO RETURN.
OPNPUNCH MVI   WORK,X'80'         INDICATE ONLY ONE FILE IN LIST.
         OPEN (SYSPUNCH,(OUTPUT)),MF=(E,WORK)
         SPACE
         LA    R2,BPAMBUFR        INITIALIZE SYMBOL POINTER.
         LA    R3,190             LOAD NUMBER OF SYMBOLS TO CHECK.
         LA    R5,X'41'           LOAD FIRST SYMBOL CODE POINT VALUE.
         SLR   R9,R9              INITIALIZE OUTPUT CARD COUNTER.
         SLR   R0,R0
         ST    R0,WORK+4          INITIALIZE NON-NULL SYMBOL COUNTER.
SYMLOOP  OC    0(18,R2),0(R2)     ANY NON-ZERO BITS IN SYMBOL?
         BZ    NEXTSYM            NO, TRY NEXT SYMBOL.
         CLI   INBUFF+11,C'X'     YES, HEXADECIMAL SOURCE REQUESTED?
         BNE   SYMBIN             NO, PUNCH OUT BINARY SOURCE.
         LA    R7,CARDX           YES, POINT TO CARD-IMAGE TEMPLATE.
         UNPK  17(13,R7),0(7,R2)  SUPPLY HEXADECIMAL SYMBOL SOURCE.
         UNPK  29(13,R7),6(7,R2)
         UNPK  41(13,R7),12(7,R2)
         TR    17(36,R7),PHEX-C'0'
         MVI   53(R7),X'7D'       CLEAN UP DECLARE CONSTANT STATEMENT.
         B     SYMCARD1           PUNCH FIRST CARD FOR THIS SYMBOL.
SYMBIN   LA    R7,CARD1           POINT TO CARD-IMAGE TEMPLATE.
         LR    R8,R2              COPY POINTER TO SYMBOL BITS.
         ICM   R1,X'C',0(R8)      LOAD LEFT-MOST COLUMN OF SYMBOL.
         LA    R4,17(,R7)         POINT TO OUTPUT AREA.
         BAL   R14,SYMBYTE        SHOW BINARY SOURCE FOR LEFT-MOST
         BAL   R14,SYMBYTE             COLUMN OF SYMBOL.
         LA    R8,2(,R8)          POINT PAST LEFT-MOST COLUMN BITS.
SYMCARD1 STC   R5,WORK            GET THE SYMBOL CODE POINT VALUE.
         UNPK  59(3,R7),WORK(2)   SHOW SYMBOL CODE POINT VALUE.
         TR    59(2,R7),PHEX-C'0'
         MVI   61(R7),X'7D'
         LA    R9,100(,R9)        INCREMENT OUTPUT CARD IMAGE COUNT.
         CVD   R9,WORK+8
         OI    WORK+15,X'0F'      MAKE NUMERIC CHARACTER.
         UNPK  72(8,R7),WORK+11(5)     SUPPLY CARD SEQUENCE NUMBER.
         PUT   SYSPUNCH,(R7)      PRODUCE FIRST SOURCE CARD FOR SYMBOL.
         LA    R0,1
         A     R0,WORK+4          INCREMENT NON-NULL SYMBOL COUNTER.
         ST    R0,WORK+4
         CLI   INBUFF+11,C'X'     HEXADECIMAL SOURCE REQUESTED?
         BE    NEXTSYM            YES, SYMBOL NOW PROCESSED.
         LA    R7,4               FOUR MORE CARDS FOR THIS SYMBOL.
SYMCRDLP LA    R6,4               FOUR BYTES SHOWN ON EACH CARD IMAGE.
         ICM   R1,X'F',0(R8)      LOAD NEXT FOR SYMBOL ROWS.
         LA    R4,CARD2+17        POINT TO OUTPUT AREA.
SYMROWLP BAL   R14,SYMBYTE
         LA    R4,4(,R4)          POINT PAST QUOTES, COMMA, ETC.
         BCT   R6,SYMROWLP        PROCESS NEXT SYMBOL ROW.
         LA    R8,4(,R8)          POINT PAST 4 ROWS' BITS.
         LA    R9,100(,R9)        INCREMENT OUTPUT CARD IMAGE COUNT.
         CVD   R9,WORK+8
         OI    WORK+15,X'0F'      MAKE NUMERIC CHARACTER.
         UNPK  CARD2+72(8),WORK+11(5)  SUPPLY CARD SEQUENCE NUMBER.
         PUT   SYSPUNCH,CARD2     PRODUCE ANOTHER SYMBOL SOURCE CARD.
         BCT   R7,SYMCRDLP        PROCESS NEXT SYMBOL SOURCE CARD.
NEXTSYM  LA    R2,18(,R2)         POINT TO NEXT SYMBOL'S DATA.
         LA    R5,1(,R5)          INCREMENT CODE POINT VALUE.
         BCT   R3,SYMLOOP         PROCESS NEXT SYMBOL.
         SPACE
CLOSEPCH L     R1,WORK+4          LOAD NON-NULL SYMBOL COUNTER.
         CVD   R1,WORK+8
         OI    WORK+15,X'0F'      MAKE NUMERIC CHARACTER.
         UNPK  CARDLAST+13(3),WORK+14(2)
         LA    R9,100(,R9)        INCREMENT OUTPUT CARD IMAGE COUNT.
         CVD   R9,WORK+8
         OI    WORK+15,X'0F'      MAKE NUMERIC CHARACTER.
         UNPK  CARDLAST+72(8),WORK+11(5) SUPPLY CARD SEQUENCE NUMBER.
         PUT   SYSPUNCH,CARDLAST  REPORT TOTAL SYMBOL COUNT.
         MVI   WORK,X'80'         INDICATE ONLY ONE FILE IN LIST.
         CLOSE SYSPUNCH,MF=(E,WORK)
         SLR   R15,R15            SET GOOD RETURN CODE.
PUNCHRTN L     R13,4(,R13)        POINT TO CALLER-SUPPLIED SAVE AREA.
         L     R14,12(,R13)       RESTORE RETURN ADDRESS.
         LM    R0,R12,20(R13)     RESTORE OTHER REGISTERS.
         BR    R14                RETURN TO CALLER.
         SPACE
SYMBYTE  LA    R0,8               GET NUMBER OF BITS PER BYTE.
SYMBITLP MVI   0(R4),C'0'         PLACE A ZERO TO START WITH.
         LTR   R1,R1              REALLY A ONE?
         BNM   SYMBITOK           NO, A ZERO WAS CORRECT.
         MVI   0(R4),C'1'         YES, SUPPLY IT.
SYMBITOK SLL   R1,1               PROMOTE NEXT BIT TO SIGN.
         LA    R4,1(,R4)          POINT TO NEXT CARD IMAGE COLUMN.
         BCT   R0,SYMBITLP        LOOP THROUGH NEXT BIT.
         BR    R14                BYTE DONE SO RETURN TO CALLER.
         TITLE ' SYMBOL SOURCE SUBROUTINE VARIABLES AND CONSTANTS '
SYSPUNCH DCB   DSORG=PS,MACRF=PM,DDNAME=SYSPUNCH,RECFM=FB,LRECL=80
CARD1    DC    CL80'         DC    B''0000000000000000''               +
                       X''##''                  '
CARD2    DC    CL80'         DC    B''00000000'',B''00000000'',B''00000+
               000'',B''00000000''                  '
CARDX    DC    CL80'         DC    X''000000000000000000000000000000000+
               000''   X''##''                  '
CARDLAST DC    CL80'* SOURCE FOR 000 NON-NULL SYMBOLS PUNCHED BY TSO TE+
               RMTEST &REL                  '
         SPACE
         LTORG
         SPACE
         DS    0D
PHEX     DC    C'0123456789ABCDEF'
         DS    0D                 END OF CSECT.
         SPACE
         DROP  R11,R13            SYMPUNCH, SAVAREA2.
         TITLE ' WORK AREAS AND BUFFERS '
TERMBUFR COM                      WORK AREAS AND BUFFERS.
SAVEAREA DS    18F
SAVAREA2 DS    18F
WORK     DS    2D
GMREGS   EQU   *,8                GETMAIN/FREEMAIN REGISTER SAVE AREA.
GMREG0   DC    F'0'
GMREG1   DC    F'0'
LINES    DS    F                  NUMBER OF SCREEN LINES.
COLUMNS  DS    F                  CURRENT TERMINAL WIDTH.
PRIMSIZE DS    H                  PRIMARY TERMINAL SIZE.
ALTSIZE  DS    H                  ALTERNATE TERMINAL SIZE.
TERMATTR DS    F                  TERMINAL ATTRIBUTES.
TRMNETID DS    CL16               TERMINAL IDENTIFIER.
         DS    0D
GTTERML  GTTERM MF=L              GTTERM PARAMETER LIST.
         DS    0D
NOEDDATA DS    XL256
INBUFF   DS    XL3584
WSFPSA   DS    D
BPAMBUFR DS    XL32720
TEMPSCRN EQU   BPAMBUFR+6880,3584
         TITLE ' DSECTS AND EQUATES '
         PRINT NOGEN
         DCBD  DSORG=PO,DEVD=DA
         PRINT GEN
         SPACE 2
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
         END   TERMTEST
/*
//LKED    EXEC PGM=IEWL,PARM='MAP,LIST'
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//SYSLMOD  DD  DSN=SYS2.CMDLIB(TERMTEST),DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//
