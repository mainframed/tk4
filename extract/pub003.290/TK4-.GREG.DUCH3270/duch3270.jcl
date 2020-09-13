//GREGD6G  JOB ,'DUCHESS GRAPHICS',CLASS=A,MSGCLASS=X,REGION=2048K,
//             COND=(4,LT),NOTIFY=GREG
//*
//*  JCL TO INSTALL MVS TSO 3270 GRAPHICS SUPPORT INTO DUCHESS.
//*
//*  THE DUCHESS DISTRIBUTION TAPE PROVIDES THE FOLLOWING DATA SETS:
//*            HLQ.DUCHESS.BK
//*            HLQ.DUCHESS.BOOK
//*            HLQ.DUCHESS.CLIST
//*            HLQ.DUCHESS.HELP
//*            HLQ.DUCHESS.LOAD
//*            HLQ.DUCHESS.MACLIB
//*            HLQ.DUCHESS.SOURCE
//*
//*  THIS JOBS ADDS ADDITIONAL MEMBERS TO THE SOURCE AND LOAD FILES
//*  WHILE LEAVING ALL ORIGINAL DATA UNCHANGED.
//*
//*  TO USE THE 3270 GRAPHICS VERSION OF DUCHESS AFTER THIS JOB
//*  HAS RUN, CHANGE YOUR DUCHESS PROCEDURE TO CALL MEMBER
//*  'DUCHESSG' (INSTEAD OF 'DUCHESS6').
//*
//*  NOW LET'S BEGIN...
//*
//*  CHANGE THE JOB CARD TO SUIT - AND THE PROC HLQ PARAMETER.
//*
//*  IF YOUR ASSEMBLER IS NOT 'IFOX00' THEN YOU WILL ALSO NEED
//*  TO CUSTOMISE THE TWO ASSEMBLE STEPS BELOW.
//*
//*
//*  1. INSTALL UPDATED SOURCE OF 'BOARD' CALLED 'BOARDG'
//*
//D6GRAF  PROC HLQ=GREG
//GENER1  EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//SYSUT2   DD  DSN=&HLQ..DUCHESS.SOURCE(BOARDG),DISP=SHR
//*
//*  2. INSTALL THE NEW 'DFRNTEND'/'DUCH3270' SOURCE
//*
//GENER2  EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//SYSUT2   DD  DSN=&HLQ..DUCHESS.SOURCE(DFRNTEND),DISP=SHR
//*
//*  3. ASSEMBLE 'BOARDG'
//*
//ASM3    EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,TERM'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=&HLQ..DUCHESS.MACLIB,DISP=SHR,DCB=BLKSIZE=32720
//         DD  DSN=SYS1.MACLIB,DISP=SHR
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=&HLQ..DUCHESS.SOURCE(BOARDG),DISP=SHR
//*
//*  4. LINK EDIT 'BOARDG'
//*
//LKED4   EXEC PGM=IEWL,PARM='LET,LIST,MAP,NCAL'
//SYSPRINT DD  SYSOUT=*
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSLIB   DD  DSN=&HLQ..DUCHESS.LOAD,DISP=SHR
//SYSLMOD  DD  DSN=&HLQ..DUCHESS.LOAD(BOARDG),DISP=SHR
//*
//*  5. ASSEMBLE 'DFRNTEND'/'DUCH3270'
//*
//ASM5    EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,TERM'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=&HLQ..DUCHESS.MACLIB,DISP=SHR,DCB=BLKSIZE=32720
//         DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=&HLQ..DUCHESS.SOURCE(DFRNTEND),DISP=SHR
//*
//*  6. LINK EDIT 'DFRNTEND'/'DUCH3270'
//*
//LKED6   EXEC PGM=IEWL,PARM='LET,LIST,MAP,NCAL'
//SYSPRINT DD  SYSOUT=*
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSLIB   DD  DSN=&HLQ..DUCHESS.LOAD,DISP=SHR
//SYSLMOD  DD  DSN=&HLQ..DUCHESS.LOAD(DFRNTEND),DISP=SHR
//*
//*  7. MAKE A NEW COPY OF 'DUCHESS6' CALLED 'DUCHESSG'
//*
//RELINK7 EXEC PGM=IEWL,PARM='LET,LIST,MAP'
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSLIB   DD  DSN=&HLQ..DUCHESS.LOAD,DISP=SHR
//SYSLMOD  DD  DSN=&HLQ..DUCHESS.LOAD,DISP=SHR
//        PEND
//THESTEP EXEC D6GRAF
//GENER1.SYSUT1   DD  *
         TITLE 'BOARD -- BOARD PRINT AND MODIFICATION'                  00000010
BOARD    CSECT                                                          00000020
         ENTRY CHMAP                                                    00000030
         ENTRY PUTBD                                                    00000040
         ENTRY PTHREATS                                                 00000050
         ENTRY PRINTDB                                                  00000060
         ENTRY UPDATE                                                   00000070
         ENTRY ALGSQR                                                   00000080
*                                                                       00000090
         EXTRN DBCHK                                                    00000100
         EXTRN HINIT                                                    00000110
         EXTRN POSDBEQ                                                  00000120
         EXTRN PUTCHAR                                                  00000130
         EXTRN SWITCH                                                   00000140
         ENTER DSA=YES                                                  00000150
*                                                                       00000160
*  PRINT CHESS BOARD                                                    00000170
*  R1 -> POSDB                                                          00000180
*                                                                       00000190
         LR    R11,R1                                                   00000200
         USING POSDB,R11                                                00000210
         MVC   BUF,INITBUF                                              00000220
         LA    R4,=C' K Q R B N P-K-Q-R-B-N-P'                          00000230
         LA    R3,BUF                                                   00000240
         LA    R2,WK                                                    00000250
         DO    R5,2                                                     00000260
         DO    R6,6                                                     00000270
         STM   R2,R4,PLIST                                              00000280
         LA    R1,PLIST                                                 00000290
         SCALL CHMAP                                                    00000300
         LA    R4,2(R4)           NEXT CHARACTER CODE                   00000310
         LA    R2,8(R2)           NEXT BIT MAP                          00000320
         ENDDO                                                          00000330
         LA    R2,BK              NEXT COLOR                            00000340
         ENDDO                                                          00000350
         LA    R0,DFLTOPTS                                              00000360
         LA    R1,BUF                                                   00000370
         SCALL PUTBD                                                    00000380
         B     RET0                                                     00000390
         EJECT                                                          00000400
PTHREATS ENTER DSA=YES                                                  00000410
         LR    R11,R1             PICK UP POSITION DATABASE.            00000420
         USING POSDB,R11          NOTE REGISTER USAGE.                  00000430
         GTKN                     PICK UP REST OF COMMAND LINE.         00000440
         TST   R15                DID IT EXIST?                         00000450
         WHILE Z                                                        00000460
         LR    R10,R1             POINT TO THE PARAMETER.               00000470
         LA    R1,2                                                     00000480
         CH    R1,0(R10)          IS THE LENGTH EXACTLY 2?              00000490
         IF    NZ                                                       00000500
         CLC   0(5,R10),ALL       IS IT 'ALL' ?                         00000510
         BNE   THRERR             NO -- ERROR.                          00000520
         LA    R8,BUF             POINT TO THE BUFFERS.                 00000530
         LA    R9,WKT             POINT TO THE WHITE KING.              00000540
         DO    R7,2               DO FOR WHITE AND BLACK.               00000550
         DO    R6,7               DO OVER ALL PIECES.                   00000560
         MVC   0(128,R8),INITBUF  INIT THE AREA.                        00000570
         ST    R9,PLIST           SAVE POINTER TO BITMAP.               00000580
         ST    R8,PLIST+4         SAVE ADDRESS OF BUFFER.               00000590
         LA    R1,=C'++'          SAVE CODE.                            00000600
         ST    R1,PLIST+8         POINT TO IT.                          00000610
         LA    R1,PLIST           POINT TO PARM LIST.                   00000620
         SCALL CHMAP              PRINT THE MAP.                        00000630
         LA    R8,128(R8)         BUMP BUFFER POINTER.                  00000640
         LA    R9,8(R9)           BUMP MAP POINTER.                     00000650
         ENDDO                                                          00000660
         LA    R8,BUF             RECOVER BUFFER POINTER.               00000670
         DO    R6,8               LOOP FOR ALL RANKS.                   00000680
         LA    R3,OUTBUF+2        POINT TO OUTPUT BUFFER.               00000690
         LR    R5,R8              GET BUFFER POINTER.                   00000700
         DO    R4,7               MOVE ALL 7 BOARDS.                    00000710
         MVC   0(16,R3),0(R5)     GET THE RANK FROM THIS BOARD.         00000720
         LA    R5,128(R5)         POINT TO NEXT BOARD.                  00000730
         MVI   16(R3),C' '        MOVE IN A BUFFER.                     00000740
         MVI   17(R3),C' '                                              00000750
         LA    R3,18(R3)          INCREMENT BUFFER POINTER.             00000760
         ENDDO                                                          00000770
         LA    R3,OUTBUF                                                00000780
         LA    R1,124             GET LENGTH OF OUTPUT BUFFER.          00000790
         STH   R1,OUTBUF          SAVE IT.                              00000800
         PRNTF '%S%L',((R3)),FO=4,PLIST=PLIST                           00000810
         LA    R8,16(R8)          POINT TO THE NEXT LINE.               00000820
         ENDDO                                                          00000830
         LA    R9,BKT             GET BLACK THREATS THIS TIME.          00000840
         LA    R8,BUF             POINT TO A BUFFER.                    00000850
         PRNTF '%L%L',FO=4        SKIP A LINE.                          00000860
         ENDDO                                                          00000870
         ELSE                                                           00000880
         LA    R8,WKT             GET WHITE KING THREATS.               00000890
         CLI   2(R10),C'W'        ENSURE THAT IT'S CORRECT.             00000900
         IF    NZ                                                       00000910
         CLI   2(R10),C'B'        MUST BE BLACK THEN.                   00000920
         BNZ   THRERR             NO                                    00000930
         LA    R8,BKT             YES -- POINT TO THEM.                 00000940
         ENDIF                                                          00000950
         IC    R7,3(R10)          PICK UP THE PIECE TYPE.               00000960
         INDEX 'KQRBNPT',R7       GET THE INDEX ...                     00000970
         TST   R15                DID IT EXIST?                         00000980
         BNZ   THRERR             NO -- ERROR                           00000990
         SLL   R1,3               ADJUST FOR DOUBLEWORDS.               00001000
         AR    R8,R1              ADD IN THE OFFSET.                    00001010
         MVC   BUF,INITBUF        INITIALISE THE BUFFER.                00001020
         LA    R10,=C'++'         THREATS WILL BE ++                    00001030
         LA    R9,BUF             POINT TO OUTPUT BUFFER.               00001040
         STM   R8,R10,PLIST       SAVE PARAMETERS.                      00001050
         LA    R1,PLIST           POINT TO PARAMETER LIST.              00001060
         SCALL CHMAP              MAP THE THREATS.                      00001070
         LA    R0,DFLTOPTS        GET THE DEFAULT OPTIONS.              00001080
         LA    R1,BUF                                                   00001090
         SCALL PUTBD              PRINT THIS BOARD OUT.                 00001100
         ENDIF                                                          00001110
         GTKN                                                           00001120
         TST   R15                ANYTHING PICKED UP?                   00001130
         ENDWHILE                 LOOP WHILE THERE IS.                  00001140
         B     RET0                                                     00001150
THRERR   PRNTF '%S invalid piece%L',((R10)),PLIST=PLIST                 00001160
         EXIT  RC=8                                                     00001170
         EJECT                                                          00001180
PRINTDB  ENTER DSA=YES                                                  00001190
         LR    R11,R1             R11 -> POSITION DATABASE.             00001200
         USING POSDB,R11                                                00001210
         LA    R9,WHITE           POINT TO THE COLOR.                   00001220
         LA    R10,WK             AND THE DATABASE SEGMENT.             00001230
         BAL   R14,PRINTSD                                              00001240
         LA    R9,BLACK           SWAP SIDES                            00001250
         LA    R10,BK             AND DATABASES.                        00001260
         BAL   R14,PRINTSD        PRINT IT.                             00001270
         B     RET0                                                     00001280
PRINTSD  ENTER                                                          00001290
         LA    R8,KING            PRINT KING PIECES AND THREATS.        00001300
         LA    R7,WK-WK(R10)                                            00001310
         BAL   R14,PRINTPC                                              00001320
         LA    R8,QUEEN           PRINT QUEEN PIECES.                   00001330
         LA    R7,WQ-WK(R10)                                            00001340
         BAL   R14,PRINTPC                                              00001350
         LA    R8,ROOK            PRINT ROOKS.                          00001360
         LA    R7,WR-WK(R10)                                            00001370
         BAL   R14,PRINTPC                                              00001380
         LA    R8,BISHOP                                                00001390
         LA    R7,WB-WK(R10)                                            00001400
         BAL   R14,PRINTPC                                              00001410
         LA    R8,KNIGHT          PRINT KNIGHTS.                        00001420
         LA    R7,WN-WK(R10)                                            00001430
         BAL   R14,PRINTPC                                              00001440
         LA    R8,PAWN                                                  00001450
         LA    R7,WP-WK(R10)                                            00001460
         BAL   R14,PRINTPC                                              00001470
         LA    R8,NULL                                                  00001480
         LA    R7,W-WK(R10)                                             00001490
         BAL   R14,PRINTPC                                              00001500
         LA    R7,WKO-WK(R10)                                           00001510
         PRNTF '%S offsets %H %H %H %H %H %H %H%L',((R9),(R7),2(R7),   *00001520
               4(R7),6(R7),8(R7),10(R7),12(R7)),PLIST=PLIST             00001530
         LA    R7,WSQUARES-WK(R10)                                      00001540
         PRNTF '%S squares %X%X%X%X%L',((R9),(R7),4(R7),8(R7),12(R7)), *00001550
               PLIST=PLIST                                              00001560
         LA    R7,WTYPES-WK(R10)                                        00001570
         PRNTF '%S types   %X%X%X%X%L',((R9),(R7),4(R7),8(R7),12(R7)), *00001580
               PLIST=PLIST                                              00001590
         GETC  1                                                        00001600
         LH    R2,WCASTLE-WK(R10)                                       00001610
         ST    R2,0(R1)                                                 00001620
         LR    R2,R1                                                    00001630
         PRNTF '%S flags %X%L',((R9),(R2)),PLIST=PLIST                  00001640
         B     RET0                                                     00001650
PRINTPC  ENTER                                                          00001660
         PRNTF '%S %S %X%X  %X%X%L',((R9),(R8),(R7),4(R7),WKT-WK(R7),  *00001670
               WKT-WK+4(R7)),PLIST=PLIST                                00001680
         B     RET0                                                     00001690
WHITE    STRNG 'white'                                                  00001700
BLACK    STRNG 'black'                                                  00001710
KING     STRNG 'king  '                                                 00001720
QUEEN    STRNG 'queen '                                                 00001730
ROOK     STRNG 'rook  '                                                 00001740
BISHOP   STRNG 'bishop'                                                 00001750
KNIGHT   STRNG 'knight'                                                 00001760
PAWN     STRNG 'pawn  '                                                 00001770
NULL     STRNG '      '                                                 00001780
         EJECT                                                          00001790
*                                                                       00001800
*  MAP BIT STRING TO BUFFER                                             00001810
*                                                                       00001820
*  0(R1) -> BIT MAP                                                     00001830
*  4(R1) -> BUFFER                                                      00001840
*  8(R1) -> 2 BYTE CODE                                                 00001850
*                                                                       00001860
CHMAP    ENTER                                                          00001870
         LM    R2,R4,0(R1)                                              00001880
         LB    R6,0(R2)                                                 00001890
         BSETB R8,0                                                     00001900
         DO    R5,64                                                    00001910
         LBR   R10,R6                                                   00001920
         NBR   R10,R8                                                   00001930
         TSTB  R10                                                      00001940
         IF    NZ                                                       00001950
         MVC   0(2,R3),0(R4)                                            00001960
         ENDIF                                                          00001970
         LA    R3,2(R3)           INCREMENT BUFFER POINTER.             00001980
         SRDL  R8,1               NEXT SQUARE ON BOARD                  00001990
         ENDDO                                                          00002000
         B     RET0                                                     00002010
         EJECT                                                          00002020
*                                                                       00002030
*  PRINT CHARACTER BOARD                                                00002040
*  R0 -- FILE OPTION WORD                                               00002050
*  R1 -> BUFFER                                                         00002060
*                                                                       00002070
PUTBD    ENTER                                                          00002080
         LR    R2,R0                                                    00002090
         LR    R3,R1                                                    00002100
********************************* TOP OF INSERTION BLOCK 2007FEB 3270G*
         L     R15,=V(DUCH3270)   POINT TO GRAPICS MODULE        3270G*
         BALR  R14,R15            CALL DUCH3270                  3270G*
         LTR   R15,R15            SUCCESS?                       3270G*
         BZ    PUTBDX             YES                            3270G*
********************************* END OF INSERTION BLOCK 2007FEB 3270G*
         PRNTF '%L'                                                     00002110
         DO    R4,8                                                     00002120
         DO    R5,16                                                    00002130
         LR    R0,R2                                                    00002140
         ZERO  R1                                                       00002150
         IC    R1,0(R3)                                                 00002160
         SCALL PUTCHAR                                                  00002170
         LA    R3,1(R3)                                                 00002180
         ENDDO                                                          00002190
         PRNTF '%L'                                                     00002200
         ENDDO                                                          00002210
PUTBDX   EQU   *                                                 3270G*
         PRNTF '%L'                                                     00002220
         B     RET0                                                     00002230
         EJECT                                                          00002240
*                                                                       00002250
*  UPDATE CHESS BOARD                                                   00002260
*  R1 -> POSDB.  USES GTKN ROUTINE                                      00002270
*                                                                       00002280
UPDATE   ENTER DSA=YES                                                  00002290
         ST    R1,TMP             SAVE POSDB                            00002300
         LA    R11,BUF                                                  00002310
         USING POSDB,R11                                                00002320
         MVDB  POSDB,0(R1)                                              00002330
         XBR   R8,R8              BOARD OF CHANGED SQUARES              00002340
         GTKN                                                           00002350
         TST   R15                                                      00002360
         WHILE Z                                                        00002370
         LH    R0,0(R1)           LENGTH OF STRING                      00002380
         LA    R1,2(R1)           ADDRESS OF STRING                     00002390
         C     R0,=F'2'                                                 00002400
         BNE   PIECERR                                                  00002410
         ZERO  R2                                                       00002420
         CLC   0(2,R1),=C'ZZ'                                           00002430
         IF    NE                 IF PIECE CODE                         00002440
         LR    R2,R11             -> WK                                 00002450
         CLI   0(R1),C'W'                                               00002460
         IF    NE                                                       00002470
         CLI   0(R1),C'B'                                               00002480
         BNE   PIECERR                                                  00002490
         LA    R2,BK                                                    00002500
         ENDIF                                                          00002510
         LC    R3,1(R1)           PIECE CODE                            00002520
         INDEX 'KQRBNP',R3                                              00002530
         TST   R15                                                      00002540
         BNZ   PIECERR                                                  00002550
         SLA   R1,3                                                     00002560
         AR    R2,R1                                                    00002570
         ENDIF                                                          00002580
*                                                                       00002590
*  R2 = 0 IF 'ZZ', ELSE POINTS TO APPROPRIATE PIECE BOARD               00002600
*                                                                       00002610
         GTKN                                                           00002620
         TST   R15                                                      00002630
         WHILE Z                                                        00002640
         LR    R4,R1                                                    00002650
         LR    R5,R15                                                   00002660
         SCALL ALGSQR             SQUARE NUMBER RETURNED IN R1          00002670
         TST   R15                                                      00002680
         IF    NZ                                                       00002690
         LR    R1,R4                                                    00002700
         LR    R15,R5                                                   00002710
         BREAK ,2                                                       00002720
         ENDIF                                                          00002730
*                                                                       00002740
*  CLEAR ANY PIECE FROM DESTINATION SQUARE                              00002750
*                                                                       00002760
         BSETB R4,0(R1)                                                 00002770
         OBR   R8,R4              RECORD CHANGED SQUARE                 00002780
         LA    R6,WK                                                    00002790
         DO    R7,2                                                     00002800
         DO    R15,6                                                    00002810
         LB    R0,0(R6)                                                 00002820
         NBR   R0,R4                                                    00002830
         XB    R0,0(R6)                                                 00002840
         STB   R0,0(R6)                                                 00002850
         LA    R6,8(R6)           NEXT BOARD                            00002860
         ENDDO                                                          00002870
         LA    R6,BK              NEXT COLOR                            00002880
         ENDDO                                                          00002890
*                                                                       00002900
*  INSTALL NEW PIECE, IF ANY                                            00002910
*                                                                       00002920
         TST   R2                                                       00002930
         IF    NZ                                                       00002940
         LB    R0,0(R2)                                                 00002950
         XBR   R0,R4                                                    00002960
         STB   R0,0(R2)                                                 00002970
         ENDIF                                                          00002980
         GTKN                                                           00002990
         TST   R15                                                      00003000
         ENDWHILE                                                       00003010
         TST   R15                                                      00003020
         ENDWHILE                                                       00003030
*                                                                       00003040
* FIX UP CASTLING STATUS                                                00003050
*                                                                       00003060
         ZERO  R4                 TABLE INDEX                           00003070
         LA    R6,WK              START WITH WHITE                      00003080
         DO    R7,2               FOR EACH COLOR ...                    00003090
         DO    R5,2               FOR EACH SIDE ...                     00003100
         LB    R0,ROOKTAB(R4)                                           00003110
         OB    R0,KINGTAB(R4)                                           00003120
         NBR   R0,R8                                                    00003130
         TSTB  R0                                                       00003140
         IF    NZ                 IF STATUS MAY BE AFFECTED             00003150
         LB    R0,ROOKTAB(R4)                                           00003160
         NB    R0,WR-WK(R6)                                             00003170
         ANYB  R0,R0                                                    00003180
         LB    R2,KINGTAB(R4)                                           00003190
         NB    R2,WK-WK(R6)                                             00003200
         ANYB  R2,R2                                                    00003210
         L     R14,BITTAB(R4)                                           00003220
         LC    R15,WCASTLE-WK(R6)                                       00003230
         NR    R0,R2                                                    00003240
         IF    Z                  IF CASTLING DISABLED                  00003250
         OR    R15,R14                                                  00003260
         XR    R15,R14                                                  00003270
         ELSE                     CASTLING OK                           00003280
         LR    R2,R14                                                   00003290
         NR    R2,R15                                                   00003300
         IF    Z                                                        00003310
         LBR   R2,R14             PROTECT R14,R15                       00003320
         L     R14,BITTAB+4(R4)   GET STRING                            00003330
         PRNTF '*%S-side castling enabled*%L',((R14)),PLIST=PLIST       00003340
         LBR   R14,R2                                                   00003350
         ENDIF                                                          00003360
         OR    R15,R14                                                  00003370
         ENDIF                                                          00003380
         STC   R15,WCASTLE-WK(R6)                                       00003390
         ENDIF                                                          00003400
         LA    R4,8(R4)           NEXT TABLE ENTRY                      00003410
         ENDDO                                                          00003420
         LA    R6,BK              NEXT COLOR                            00003430
         ENDDO                                                          00003440
*                                                                       00003450
         ZERO  R10                                                      00003460
         B     VALIDATE                                                 00003470
PIECERR  PRNTF 'Invalid piece code%L'                                   00003480
         LA    R10,4                                                    00003490
         B     VALIDATE                                                 00003500
SQRERR   PRNTF 'Invalid square code%L'                                  00003510
         LA    R10,8                                                    00003520
VALIDATE LR    R1,R11                                                   00003530
         SCALL DBCHK                                                    00003540
         TST   R15                                                      00003550
         IF    NZ                                                       00003560
         LA    R10,12                                                   00003570
         LR    R2,R1                                                    00003580
         PRNTF '%S%L',((R2)),PLIST=PLIST                                00003590
         ENDIF                                                          00003600
         LR    R0,R11                                                   00003610
         L     R1,TMP                                                   00003620
         SCALL POSDBEQ                                                  00003630
         TST   R15                                                      00003640
         IF    NE                                                       00003650
         MVC   0(160,R1),0(R11)                                         00003660
         MVC   160(160,R1),160(R11)                                     00003670
         SCALL HINIT                                                    00003680
         ENDIF                                                          00003690
         EXIT  RC=(R10)                                                 00003700
ROOKTAB  DC    X'0000000000000080'                                      00003710
         DC    X'0000000000000001'                                      00003720
         DC    X'8000000000000000'                                      00003730
         DC    X'0100000000000000'                                      00003740
KINGTAB  DC    X'0000000000000008'                                      00003750
         DC    X'0000000000000008'                                      00003760
         DC    X'0800000000000000'                                      00003770
         DC    X'0800000000000000'                                      00003780
BITTAB   DC    F'2',A(WQS)                                              00003790
         DC    F'1',A(WKS)                                              00003800
         DC    F'2',A(BQS)                                              00003810
         DC    F'1',A(BKS)                                              00003820
WQS      STRNG 'White queen'                                            00003830
WKS      STRNG 'White king'                                             00003840
BQS      STRNG 'Black queen'                                            00003850
BKS      STRNG 'Black king'                                             00003860
         EJECT                                                          00003870
*                                                                       00003880
*  ALGSQR -- RETURNS SQUARE #                                           00003890
*  R1 -> STRING IN ALGEBRAIC (SUPPOSEDLY)                               00003900
*                                                                       00003910
*  RETURNS R1 = SQUARE #, R15 = 0 IF NORMAL                             00003920
*                                                                       00003930
ALGSQR   ENTER                                                          00003940
         LA    R15,4              ASSUME THERE WILL BE AN ERROR         00003950
         LH    R2,0(R1)           LENGTH                                00003960
         LA    R3,2(R1)           -> STRING                             00003970
         C     R2,=F'2'                                                 00003980
         BNE   QUIT                                                     00003990
         IC    R5,0(R3)                                                 00004000
         INDEX 'ABCDEFGH',R5                                            00004010
         TST   R15                                                      00004020
         BNZ   QUIT                                                     00004030
         LR    R4,R1              SAVE RANK INFO                        00004040
         IC    R5,1(R3)                                                 00004050
         INDEX '87654321',R5                                            00004060
         TST   R15                                                      00004070
         BNZ   QUIT                                                     00004080
         SLA   R1,3                                                     00004090
         AR    R1,R4                                                    00004100
QUIT     EXIT  RC=(R15),RTN=(R1)                                        00004110
         EJECT                                                          00004120
RET0     EXIT                                                           00004130
DFLTOPTS EQU   6                                                        00004140
POSDB    DSECT                                                          00004150
         POSDB                                                          00004160
         DSA                                                            00004170
PLIST    DS    8F                                                       00004180
TMP      DS    D                                                        00004190
BUF      DS    CL128                                                    00004200
         DS    CL128                                                    00004210
         DS    CL128                                                    00004220
         DS    CL128                                                    00004230
         DS    CL128                                                    00004240
         DS    CL128                                                    00004250
         DS    CL128                                                    00004260
OUTBUF   DS    H                  LENGTH OF OUTPUT BUFFER.              00004270
         DS    CL124              AND THE BUFFER ITSELF.                00004280
         ENDDSA                                                         00004290
BOARD    CSECT                                                          00004300
INITBUF  DC    C' : * : * : * : *'                                      00004310
         DC    C' * : * : * : * :'                                      00004320
         DC    C' : * : * : * : *'                                      00004330
         DC    C' * : * : * : * :'                                      00004340
         DC    C' : * : * : * : *'                                      00004350
         DC    C' * : * : * : * :'                                      00004360
         DC    C' : * : * : * : *'                                      00004370
         DC    C' * : * : * : * :'                                      00004380
ALL      STRNG 'ALL'                                                    00004390
         REGS                                                           00004400
         END                                                            00004410
/*
//GENER2.SYSUT1   DD  *
DFRNTEND TITLE ' DUCHESS FRONT END TO ENABLE 3270 GRAPHICS '
***********************************************************************
*                                                                     *
*   THIS MODULE IS DESIGNED TO BE THE FIRST CSECT TO GET CONTROL      *
*   WHEN DUCHESS  - THE CHESS COMPUTER PROGRAM FROM DUKE UNIVERSITY   *
*   - IS EXECUTED.                                                    *
*                                                                     *
*   THIS ROUTINE WILL DETECT IF THE ENVIRONMENT IS SUCH THAT 3270     *
*   GRAPHICS CAN BE EMPLOYED TO RENDER THE CHESSBOARD.  THE 3270      *
*   STATUS IS SAVED IN THE 'STAT3270' AREA WHICH IS EXAMINED BY       *
*   'DUCH3270' WHICH WILL OUTPUT 3270 GRAPHICS IF APPROPRIATE.        *
*                                                                     *
*   AN MVS-LIKE ENVIRONMENT IS REQUIRED TO ENABLE THE USE OF 3270     *
*   GRAPHICS, SO DUCHESS PROCESSING UNDER OS/360 OR SVS WILL NOT      *
*   BE AFFECTED.                                                      *
*                                                                     *
*   3270 GRAPHICS WILL ONLY BE EMPLOYED WHEN 'DUCHESS' IS INVOKED IN  *
*   A TSO USER ADDRESS SPACE USING A 3270 TERMINAL CONNECTED VIA      *
*   VTAM WHICH IS OPERATING IN AN 80-COLUMN DISPLAY MODE AND WHICH    *
*   SUPPORTS FORMAT-1 PROGRAMMED SYMBOL GRAPHICS, OR NATIVE 3270      *
*   VECTOR GRAPHICS IF PROGRAMMED SYMBOLS CANNOT BE USED.             *
*                                                                     *
*   NO ATTEMPT IS MADE TO CHECK WHETHER EXTENDED HIGHLIGHTING OR      *
*   COLOUR IS SUPPORTED BECAUSE, ALTHOUGH IT IS UNLIKELY THAT A       *
*   3270 GRAPHICS TERMINAL IS MONOCHROME, THESE ORDERS ARE NOT USED.  *
*   IT IS EXPECTED THAT PROTECTED HIGH-INTENSITY IS SUFFICIENT TO     *
*   PRODUCE A WHITE-ON-BLACK DISPLAY FOR PROGRAMMED SYMBOLS, WHILE    *
*   THE COLOR '7' WILL BE USED FOR VECTOR GRAPHICS BITMAP DISPLAY.    *
*                                                                     *
*   IF APPROPRIATE, THE CHESSBOARD SYMBOL SET WILL BE LOADED HERE,    *
*   AND IN ANY EVENT CONTROL WILL BE PASSED TO CSECT 'DMAIN' AS IF    *
*   WERE THE MAIN ENTRY POINT OF 'DUCHESS' (WHICH IT WAS BEFORE       *
*   THIS FRONT END WAS ADDED).                                        *
*                                                                     *
*   THE CODE BELOW SHOULD BE ABLE TO BE ASSEMBLED BY IFOX00.          *
*                                                                     *
*   THE ONLY ADDRESS MODE ASSUMED TO EXIST IS 24-BIT ADDRESSING.      *
*                                                                     *
*   THIS ROUTINE USES MACROS FROM SYS1.MACLIB AND, DEPENDING ON       *
*   THE VERSION OF MVS, SYS1.AMODGEN.                                 *
*                                                                     *
*   THIS ROUTINE WAS WRITTEN BY GREG PRICE IN FEBRUARY 2007.          *
*                                                                     *
*   THE CHESS PIECE SYMBOLS WERE CREATED BY GREG PRICE USING THE      *
*   'TERMTEST' TSO PROGRAM AND THE 'VISTA' 1.25 TN3270 CLIENT         *
*   FROM TOM BRENNAN SOFTWARE.                                        *
*                                                                     *
***********************************************************************
         EJECT
*
*   SOME GENERAL NOTES ABOUT 3270 LOADABLE SYMBOLS:
*
*   FORMAT-1 SYMBOLS ARE 9 PELS WIDE AND 16 PELS HIGH.  TO LOAD
*   A FORMAT-1 SYMBOL 18 BYTES ARE NEEDED: THE FIRST TWO BYTES
*   SUPPLY THE BITS OF THE LEFT-MOST VERTICAL SLICE, WITH THE
*   NEXT 16 BYTES SUPPLYING THE BITS FOR 16 HORIZONTAL SLICES
*   (TOP TO BOTTOM) WHICH ARE EACH 8 BITS WIDE.
*
*   FORMAT-2 ALLOWS FOR THE COMPRESSION OF THE LPS DATA STREAM
*   FOR FORMAT-1 SYMBOLS.
*
*   FORMAT-3 SYMBOLS ARE 8 PELS WIDE AND 10 PELS HIGH.  TO LOAD
*   A FORMAT-3 SYMBOL 10 BYTES ARE NEEDED: EACH BYTE SUPPLIES
*   THE BITS FOR A HORIZONTAL SLICE WITH SLICES BEING PROCESSED
*   FROM TOP TO BOTTOM.  EARLY ATTACHMATE EMULATIONS USED FORMAT-3.
*
*   FORMAT-3 CAN BE GENERALISED TO OTHER HORIZONTAL SLICE COUNTS.
*
*   FORMAT-4 ALLOWS FOR THE COMPRESSION OF THE LPS DATA STREAM
*   FOR FORMAT-3 SYMBOLS.
*
*   FORMAT-5 SYMBOLS ARE 10 PELS WIDE AND 8 PELS HIGH.  TO LOAD
*   A FORMAT-5 SYMBOL 10 BYTES ARE NEEDED: EACH BYTE SUPPLIES
*   THE BITS FOR A VERTICAL SLICE WITH SLICES BEING PROCESSED
*   FROM LEFT TO RIGHT.  FORMAT-5 IS USED BY 3270 PRINTERS.
*
*   FORMAT-5 CAN BE GENERALISED TO OTHER VERTICAL SLICE COUNTS.
*
*   FORMAT-6 ALLOWS FOR THE COMPRESSION OF THE LPS DATA STREAM
*   FOR FORMAT-5 SYMBOLS.
*
*   DECOMPRESSION OF COMPRESSED LOAD PROGRAMMED SYMBOL (LPS)
*   DATA STREAMS IS A CONTROLLER (3274 OR 3174) FUNCTION.
*
         EJECT
         LCLC  &RLSE
         LCLC  &RLSEDAT
&RLSE    SETC  '02.00'
*RLSEDAT SETC  '2007-02-18'       01.00 - INITIAL WRITE
&RLSEDAT SETC  '2007-03-03'       02.00 - VECTOR GRAPHICS SUPPORT
         SPACE
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
         SPACE
REPLYLEN EQU   1024               QUERY TGET BUFFER LENGTH
ESC      EQU   X'27'              ESCAPE
EW       EQU   X'F5'              ERASE/WRITE
EWA      EQU   X'7E'              ERASE/WRITE ALTERNATE
WSF      EQU   X'F3'              WRITE STRUCTURED FIELD
SBA      EQU   X'11'              SET BUFFER ADDRESS
IC       EQU   X'13'              INSERT CURSOR
SF       EQU   X'1D'              START FIELD
         PRINT NOGEN
         CVT   DSECT=YES
         IHAPSA
         IHAASCB
         PRINT GEN
         EJECT
         USING PSA,0
         USING DFRNTEND,R15
DFRNTEND CSECT
         ENTRY DUCH3270
         B     @PROLOG1
         DROP  R15                DFRNTEND
         DC    AL1(#HD1LN)
@HDR1    DC    C'DFRNTEND &RLSE &RLSEDAT'
#HD1LN   EQU   *-@HDR1
@PROLOG1 STM   R14,R12,12(R13)    USUAL PREAMBLE...
         LR    R11,R15
         LA    R15,1
         LA    R12,4095(R15,R11)
         USING DFRNTEND,R11,R12
         LA    R2,SAVEAREA
         ST    R13,4(,R2)
         ST    R2,8(,R13)
         LR    R13,R2             POINT TO NEW SAVE AREA
*
*         CLEAR 3270 GRAPHICS STATUS - BUT ALREADY DEFINED AS THIS
*
*        MVI   STAT3270,0         ENSURE 3270 GRAPHICS IS RESET
*        MVI   ERSCMD,EW          USE PRIMARY SIZE BY DEFAULT
*
*         CHECK ENVIRONMENT FOR SUITABILITY
*
         L     R2,CVTPTR          POINT TO THE CVT
         USING CVT,R2
         TM    CVTDCB,X'13'       SOME FLAVOUR OF MVS?
         BNO   NOACTION           NO, PERFORM NO ACTION HERE
         DROP  R2                 CVT
         L     R2,PSAAOLD         POINT TO THE CURRENT ASCB
         USING ASCB,R2
         ICM   R0,15,ASCBTSB      TSO USER ADDRESS SPACE?
         BZ    NOACTION           NO, PERFORM NO ACTION HERE
         DROP  R2                 ASCB
         GTSIZE
         STM   R0,R1,SCRNLNES     SAVE LINES AND COLUMNS
         LTR   R15,R15            DID 'GTSIZE' WORK?
         BNZ   NOACTION           NO, SERIOUS PROBLEM
         CH    R0,=H'24'          FEWER THAN 24 LINES?
         BL    NOACTION           YES, THAT'S STRANGE UNLESS TTY
         ICM   R0,14,SCRNLNES     VALID 3270? (LESS THAN 256?)
         BNZ   NOACTION           NO, HOW WAS THAT DONE?
         CH    R1,=H'80'          EXACTLY 80 COLUMNS?
         BNE   NOACTION           NO, 3270 GRAPHICS NOT DEFINED
         GTTERM PRMSZE=GOTTERM,ALTSZE=GOTTERM+2,ATTRIB=GOTTERM+4,      +
               MF=(E,GETTERML)    GET TERMINAL CHARACTERISTICS
         LTR   R15,R15            DID 'GTTERM' WORK?
         BNZ   NOACTION           NO, EITHER TCAM TSO USER OR
*                                     VTAM DOES NOT HAVE THE
*                                     NECESSARY WHEREWITHAL'
         CLC   SCRNLNES+3(1),GOTTERM
         BNE   TRYALT             NOT PRIMARY SIZE
         CLC   SCRNCOLS+3(1),GOTTERM+1
         BE    SZMATCH            USE PRIMARY SIZE
TRYALT   CLC   SCRNLNES+3(1),GOTTERM+2
         BNE   NOACTION           NOT ALTERNATE SIZE EITHER
         CLC   SCRNCOLS+3(1),GOTTERM+3
         BNE   NOACTION           NOT ALTERNATE SIZE EITHER
         MVI   ERSCMD,EWA         USE ALTERNATE SIZE
         MVI   BDCLRSIZ,X'80'     USE ALTERNATE SIZE
SZMATCH  TM    GOTTERM+7,X'01'    IS QUERY SUPPORTED?
         BNO   NOACTION           NO, SO CAN'T ASK TERMINAL
*
*         PERFORM THE QUERY TO ASCERTAIN TERMINAL CAPABILITIES
*
         LA    R0,REPLYLEN        TGET BUFFER SIZE
         GETMAIN R,LV=(0)         ACQUIRE BUFFER
         LR    R3,R1              SAVE ITS ADDRESS
         XC    0(256,R1),0(R1)    CLEAR THE START OF IT
         STFSMODE ON,INITIAL=YES,NOEDIT=YES
         LA    R1,RESETAID        RESET THE TERMINAL AID
         LA    R0,L'RESETAID            BEFORE ISSUING THE
         ICM   R1,8,=X'03'              READ PARTITION
         TPUT  (1),(0),R          TPUT FULLSCR,WAIT,NOHOLD
         TCLEARQ INPUT            CLEAR ANY TYPE-AHEAD INPUT
         TPG   MF=(E,TPGLIST)     ISSUE QUERY TO TSO TERMINAL
         LTR   R15,R15            WAS TPG ISSUED SUCCESSFULLY?
         BNZ   TIDYUP             NO, DO NOT EXPECT A RESPONSE
QUERYGET LR    R1,R3              POINT TO TGET BUFFER FOR RESPONSE
         LA    R0,REPLYLEN                 FROM READ PARTITION
         ICM   R1,8,=X'81'        FLAGS FOR TGET ASIS,WAIT
         TGET  (1),(0),R          TGET ASIS,WAIT
         CLI   0(R3),X'6B'        VTAM RESHOW REQUEST (PA/CLEAR KEY)?
         BL    TIDYUP             NO, ASSUME QUERY NOT FUNCTIONAL
         CLI   0(R3),X'6F'
         BL    QUERYGET           YES, IGNORE AND GET QUERY RESPONSE
         CLI   0(R3),X'88'        QUERY RESPONSE AID?
         BNE   TIDYUP             NO, STICK TO 3270 BASICS
         LA    R15,1(,R3)         POINT PAST THE AID
         BCT   R1,QUERYPRS        DECREMENT LENGTH AND GO PARSE
         B     TIDYUP             JUST IN CASE THAT WAS THE ONLY BYTE
QUERYPRS CLI   2(R15),X'81'       QUERY REPLY ID?
         BNE   TIDYUP             NO, DATA ERROR
         CLI   3(R15),X'85'       QUERY REPLY SYMBOL SETS ID?
         BE    QUERYSYM           YES
         CLI   3(R15),X'80'       QUERY SUBFIELD SUMMARY?
         BE    QUERYSUM           YES
         CLI   3(R15),X'B4'       GRAPHIC COLOR?
         BE    QUERYVEC           YES, BUT NOT REALLY EXPECTED
NXTSBFLD SR    R0,R0              NO
         ICM   R0,3,0(R15)        LOAD SUBFIELD LENGTH
         AR    R15,R0             POINT TO NEXT SUBFIELD
         SR    R1,R0              SUBTRACT FROM TGET LENGTH
         BP    QUERYPRS           EXAMINE NEXT SUBFIELD
*
*   THE END OF THE QUERY RESPONSE INPUT DATA STREAM HAS BEEN REACHED.
*
*   THIS MEANS THAT PROGRAMMED SYMBOLS WILL NOT BE USED, BECAUSE
*   QUERY SUBFIELD PARSING STOPS AS SOON AS PROGRAMMED SYMBOL USAGE
*   HAS BEEN VALIDATED.  THE NEXT DECISION TO MAKE IS IF VECTOR
*   GRAPHICS BITMAP SUPPORT CAN BE EMPLOYED TO RENDER THE CHESSBOARD.
*
         CLI   STGID#,X'80'       IS VECTOR GRAPHICS DEEMED PRESENT?
         BNE   TIDYUP             NO, 3270 GRAPHICS NOT USABLE
         CLI   CHARWDTH,0         IS CHARACTER MATRIX WIDTH KNOWN?
         BE    NOGRAFIX           NO, CANNOT USE 3270 GRAPHICS
         CLI   CHARHITE,0         IS CHARACTER MATRIX HEIGHT KNOWN?
         BNE   CALCPELS           YES, TRY TO USE VECTOR GRAPHICS
NOGRAFIX MVI   STAT3270,0         NO, FLAG NO GRAPHICS USAGE
         B     TIDYUP             NOW GO EXIT THIS FRONT END
*
*   PERFORM CALCULATIONS BASED UPON THE SCREEN PIXEL DIMENSIONS
*
CALCPELS SR    R0,R0              80 COLUMNS REQUIRED FOR GRAPHICS
         IC    R0,CHARWDTH        GET PIXELS PER COLUMN
         MH    R0,=H'39'          WANT TO SHOW BOARD FROM COLUMN 2
         LNR   R0,R0              LEFT OF CENTRE MAKES X NEGATIVE
         STCM  R0,3,SEGXPOS       SET BOARD START X COORDINATE
         SR    R1,R1
         IC    R1,CHARHITE        GET PIXELS PER ROW HEIGHT
         LR    R15,R1             SAVE IT FOR LATER
         M     R0,SCRNLNES        GET PIXEL HEIGHT OF SCREEN
         SRA   R1,1               HALVE IT - ABOVE CENTRE SO Y POSITIVE
         STCM  R1,3,SEGYPOS       SET BOARD START Y COORDINATE
         LA    R1,16*8-1          GET PIXELS FOR BOARD HEIGHT MINUS ONE
         AR    R1,R15             ROUND BOARD HEIGHT UP TO NEXT ROW
         SR    R0,R0              CLEAR FOR DIVIDE
         DR    R0,R15             GET ROWS NEEDED TO SHOW BOARD
         LA    R1,1(,R1)          GET ROW NUMBER AFTER THAT
         ST    R1,SETLINE#        SAVE LINE NUMBER TO STLINENO TO
         XC    SYMBOL40,SYMBOL40  RESET ALL PIXELS OF A BLANK
         MVI   STAT3270,X'80'     ENABLE 3270 GRAPHICS USAGE
         B     TIDYUP             NOW GO EXIT THIS FRONT END
*
*   FROM THE CHARACTER SETS SUBFIELD THE INFORMATION TO BE EXTRACTED
*   IS (1) THE DETAILS OF A SUITABLE TERMINAL STORAGE WHICH CAN BE
*   USED TO HOLD THE CHESSBOARD SYMBOLS, AND (2) THE PIXEL SIZE OF
*   A DISPLAY LOCATION SO THAT THE COORDINATES OF A VECTOR GRAPHICS
*   BITMAP CAN BE CALCULATED.
*
QUERYSYM MVC   CHARSIZE,6(R15)    SAVE CHARACTER MATRIX SIZE
         TM    4(R15),X'20'       LOAD PSSF SUPPORTED?
         BZ    NXTSBFLD           NO, CANNOT DO RASTER GRAPHICS
         TM    8(R15),X'40'       FORMAT TYPE 1 SUPPORTED BY TERMINAL?
         BZ    NXTSBFLD           NO, SO FORGET LOADABLE SYMBOLS
         SR    R14,R14
         LA    R2,13(,R15)        POINT TO FIRST DESCRIPTOR
         ICM   R14,3,0(R15)       GET LENGTH OF WHOLE SUBFIELD
         LA    R0,13
         SR    R14,R0             GET LENGTH OF ALL DESCRIPTORS
         IC    R0,12(,R15)        GET SYMBOL SET DESCRIPTOR LENGTH
QRYSTGLP TM    1(R2),X'80'        LOADABLE TERMINAL STORAGE?
         BO    LOADSYMS           YES, FOUND ONE
QRYNXSTG SR    R14,R0             NO, UPDATE REMAINING LENGTH
         BNP   NXTSBFLD           END OF SUBFIELD REACHED
         AR    R2,R0              POINT TO NEXT DESCRIPTOR
         B     QRYSTGLP           LOOK AT IT
*
*   OF ALL OF THE QUERY INBOUND SUBFIELDS WHICH MUST EXIST TO
*   SUPPORT VECTOR GRAPHICS, GRAPHIC COLOR (X'B4') HAS ARBITRARILY
*   BEEN CHOSEN AS THE ONE TO INDICATE WHETHER VECTOR GRAPHICS
*   IS SUPPORTED BY THE TERMINAL OR NOT.
*
*   VECTOR GRAPHICS SUBFIELDS SUCH AS GRAPHIC COLOR ARE NOT REQUIRED
*   TO BE SENT INBOUND FOR A STANDARD QUERY (THEY MUST BE RETURNED
*   FOR AN APPROPRIATE QUERY LIST) BUT ALL SUBFIELDS THAT THE
*   TERMINAL CAN PROVIDE WILL BE LISTED IN THE SUMMARY SUBFIELD.
*
*   THE CASE WHERE THE TERMINAL DOES NOT SUPPORT QUERY LIST (AND
*   THEREFORE MAY NOT RETURN A SUMMARY SUBFIELD, AND RETURNS ALL
*   SUPPORTED SUBFIELDS AFTER A STANDARD QUERY) IS ALSO HANDLED
*   BY THE EXPLICIT CHECKING FOR A GRAPHIC COLOR SUBFIELD.
*
QUERYSUM LA    R2,4               SCAN QCODE LIST LOOKING FOR 'B4'
         SR    R0,R0
         ICM   R0,3,0(R15)        LOAD SUBFIELD LENGTH
         SR    R0,R2              GET QCODE COUNT
         BNP   NXTSBFLD           END OF SUBFIELD REACHED
         LA    R2,4(,R15)         POINT TO QCODE LIST
QUERYQLP CLI   0(R2),X'B4'        WILL A QUERY LIST X'B4' WORK?
         BE    QUERYVEC           YES, NON-NULL DATA EXISTS FOR IT
         LA    R2,1(,R2)          POINT TO NEXT QCODE
         BCT   R0,QUERYQLP        GO CHECK NEXT CODE
         B     NXTSBFLD           END OF SUBFIELD REACHED
*
*         FLAG THAT GRAPHIC COLOR SUBFIELD WAS OR COULD BE SENT
*
QUERYVEC MVI   STGID#,X'80'       SET A NON-ZERO INVALID STORAGE ID
         B     NXTSBFLD           SUBFIELD NOW PROCESSED
*
*         LOAD THE CHESS BOARD SYMBOL SET
*
LOADSYMS MVC   STGID#,0(R2)       SAVE LOADABLE STORAGE ID
         TPUT  PSAWSF,PSALEN,NOEDIT,WAIT,MF=(E,TPUTLIST)
         LTR   R15,R15            SUCCESS?
         BNZ   TIDYUP             NO
         MVC   STAT3270,STGID#    SET STORAGE ID INTO STATUS AREA
*
*         TRANSFER CONTROL TO 'DMAIN'
*
TIDYUP   STLINENO LINE=1,MODE=OFF TURN FULLSCREEN MODE OFF
         LA    R0,REPLYLEN        GET TGET BUFFER LENGTH
         LR    R1,R3              GET TGET BUFFER ADDRESS
         FREEMAIN R,LV=(0),A=(1)  FREE THE TGET BUFFER
NOACTION L     R13,4(,R13)        POINT TO CALLER'S SAVE AREA
         L     R15,=V(DMAIN)      POINT TO DUCHESS MAIN E.P.
         L     R14,12(,R13)       RESTORE RETURN ADDRESS
         LM    R0,R12,20(R13)     RESTORE OTHER REGISTERS
         XC    8(4,R13),8(R13)    RESET SAVE AREA CHAIN
         BR    R15                TRANSFER CONTROL TO DMAIN
*
         DROP  R11,R12            DFRNTEND
*
         DC    0D'0'
         DC    CL24' END OF FRONT END LOGIC '
         TITLE ' DUCHESS 3270 GRAPHICS DISPLAY ROUTINE '
***********************************************************************
*                                                                     *
*   THIS ROUTINE RECEIVES CONTROL FROM 'PUTBD' IN THE 'BOARD' CSECT.  *
*                                                                     *
***********************************************************************
         SPACE 2
         USING DUCH3270,R15
DUCH3270 B     @PROLOG2
         DC    AL1(#HD2LN)
@HDR2    DC    C'DUCH3270 &RLSE &RLSEDAT'
#HD2LN   EQU   *-@HDR2
*
@PROLOG2 CLI   STAT3270,0         USING 3270 GRAPHICS?
         BER   R14                NO, FAST PATH EXIT WITH NON-ZERO R15
         DROP  R15                DUCH3270
         STM   R14,R12,12(R13)    USUAL PREAMBLE...
         LR    R11,R15
         LA    R15,1
         LA    R12,4095(R15,R11)
         USING DUCH3270,R11,R12
         LA    R2,SAVEAREA
         ST    R13,4(,R2)
         ST    R2,8(,R13)
         LR    R13,R2             POINT TO NEW SAVE AREA
         MVC   BUF,0(R1)          COPY CHESSBOARD BUFFER
         MVC   ERASECMD,ERSCMD    SET CORRECT ERASE COMMAND CODE
*
*         DECODE KEYBOARD CHARACTER CHESSBOARD CONTENTS
*
PUTBOARD LA    R0,64              GET NUMBER OF SQUARES
         LA    R3,BUF             POINT TO CHESSBOARD BUFFER
SQUARELP LR    R14,R0             GET LOOP CONTROL COUNT
         BCTR  R14,0              CONVERT TO OFFSET
         ST    R14,SAVEAREA       DETERMINE SQUARE COLOUR
         SRL   R14,3                   FROM COORDINATES
         X     R14,SAVEAREA
         STC   R14,SAVEAREA
         NI    SAVEAREA,X'01'     RESET UNWANTED BITS
         XI    SAVEAREA,X'41'     GET VACANT SQUARE CODE POINT
         LA    R15,BSWHITE        PREPARE FOR BLACK SQUARE
         TM    SAVEAREA,X'01'     WHITE SQUARE?
         BNO   *+8                NO, BLACK IS CORRECT
         LA    R15,WSWHITE        YES, IT IS A WHITE SQUARE
         CLI   0(R3),C'-'         IS A BLACK PIECE HERE?
         BNE   *+8                NO
         LA    R15,512-64(,R15)   YES
         TRT   1(1,R3),0(R15)     RESOLVE THE SQUARE CONTENTS
         MVC   0(1,R3),SAVEAREA   PREPARE FOR VACANT SQUARE
         MVC   1(1,R3),SAVEAREA
         BZ    SQUARENX           IT IS A VACANT SQUARE
         STC   R2,0(,R3)          SET LEFT PART OF PIECE
         LA    R2,1(,R2)
         STC   R2,1(,R3)          SET RIGHT PART OF PIECE
SQUARENX LA    R3,2(,R3)          POINT TO NEXT SQUARE
         BCT   R0,SQUARELP        PROCESS NEXT SQUARE
         CLI   STAT3270,X'80'     USING VECTOR GRAPHICS?
         BNE   RASTER             NO, USING RASTER GRAPHICS
*
*         DISPLAY CHESSBOARD AS A SINGLE BITMAP
*
*
*   THE PIXEL BIT SETTINGS FOR THE VECTOR GRAPHICS BITMAP ARE TAKEN
*   FROM THE SYMBOL DATA THAT WOULD HAVE BEEN LOADED IF PROGRAMMED
*   SYMBOLS WERE TO BE USED.  ACCORDINGLY, THE SYMBOL CODE POINTS
*   OF THE INTERPRETED CHESSBOARD ARE USED TO ACCESS THE REQUIRED
*   BIT PATTERNS.  THE 'SYMBOL40' AREA HAS ALREADY BEEN CLEARED
*   BY THE FRONT END, SO NO EXTRA LOGIC IS NEEDED TO HANDLE THE
*   BLANK CHARACTER WHICH HAS A CODE POINT OF X'40'.
*
*   ONLY EIGHT NINTHS OF THE SYMBOL SET PIXELS ARE DISPLAYED IN
*   THE BITMAP CONSTRUCTED HERE - THE LEFT-MOST AND RIGHT-MOST
*   VERTICAL SLICES OF EACH CHESSBOARD SQUARE ARE DISCARDED.
*
*   BY HAVING BOTH THE FRONT END (WHICH LOADS THE SYMBOL SET) AND
*   THE BOARD RENDERER (WHICH CONTRUCTS THIS BITMAP) IN THE ONE
*   MODULE, ONLY ONE COPY OF THE CHESSBOARD PIXEL DATA IS NEEDED.
*
         LA    R1,BUF             POINT TO BOARD CODE POINTS
         LA    R2,BDLINES+2       POINT TO PIXEL LINE DATA
         LA    R3,8               CHESSBOARD RANK COUNT
VECTRLPR LA    R4,8               CHESSBOARD FILE COUNT
VECTRLPF LR    R6,R2              SAVE LINE "ORIGIN"
         LA    R15,C' '           GET THE LOWEST CODE POINT
*
*         EXTRACT 8 RIGHT-MOST SLICES FOR LEFT HALF OF SQUARE
*
         SR    R14,R14
         IC    R14,0(,R1)         GET THE SYMBOL CODE POINT
         SR    R14,R15            GET CODE POINT "OFFSET"
         MH    R14,=H'18'         GET PIXEL DATA OFFSET
         LA    R14,SYMBOL40(R14)  POINT TO PIXEL DATA
         LA    R0,16              GET HORIZONTAL SLICE COUNT
LDSLICE1 MVC   0(1,R2),2(R14)     COPY HORIZONTAL SLICE
         LA    R2,18(,R2)         POINT TO NEXT PIXEL LINE
         LA    R14,1(,R14)        INCREMENT SLICE POINTER
         BCT   R0,LDSLICE1
*
*         EXTRACT 8 LEFT-MOST SLICES FOR RIGHT HALF OF SQUARE
*
         LR    R2,R6              RESTORE LINE "ORIGIN"
         SR    R14,R14
         IC    R14,1(,R1)         GET THE SYMBOL CODE POINT
         SR    R14,R15            GET CODE POINT "OFFSET"
         MH    R14,=H'18'         GET PIXEL DATA OFFSET
         LA    R14,SYMBOL40(R14)  POINT TO PIXEL DATA
         LA    R5,2(,R14)         POINT TO HORIZONTAL SLICES
         LA    R8,2               GET BYTES PER VERTICAL SLICE
LDSLICE3 LA    R7,X'80'           PREPARE FOR EXECUTE
         LA    R0,8               GET BITS PER BYTE
LDSLICE2 IC    R15,0(,R5)         LOAD HORIZONTAL SLICE
         SRL   R15,1              SHIFT OUT RIGHT-MOST PEL
         STC   R15,1(,R2)         STORE INTO BITMAP
         EX    R7,TMLEFT1         IS VERTICAL SLICE BIT ON?
         BNO   *+8                NO
         OI    1(R2),X'80'        YES, SET IT ON IN BITMAP
         LA    R2,18(,R2)         POINT TO NEXT PIXEL LINE
         LA    R5,1(,R5)          INCREMENT SLICE POINTER
         SRL   R7,1               DEMOTE LEFT SLICE TEST BIT
         BCT   R0,LDSLICE2
         LA    R14,1(,R14)        POINT TO NEXT VERTICAL SLICE BYTE
         BCT   R8,LDSLICE3
         LA    R2,2(,R6)          POINT TO TOP OF NEXT SQUARE
         LA    R1,2(,R1)          POINT TO NEXT SQUARE'S CODE POINTS
         BCT   R4,VECTRLPF        PROCESS SQUARE IN NEXT FILE
         LA    R2,18*16-16(,R2)   MOVE TO FIRST SQUARE OF NEXT RANK
         BCT   R3,VECTRLPR        PROCESS SQUARE IN NEXT RANK
*
         TPUT  BDVECTOR,BDVECLEN,NOEDIT,WAIT,HOLD
         B     EXIT3270
*
TMLEFT1  TM    0(R14),X'00'       <<< EXECUTED >>>
*
*         DISPLAY CHESSBOARD USING PREVIOUSLY LOADED SYMBOLS
*
RASTER   MVC   ROW1,BUF           LOAD CHESSBOARD ROWS
         MVC   ROW2,BUF+16
         MVC   ROW3,BUF+32
         MVC   ROW4,BUF+48
         MVC   ROW5,BUF+64
         MVC   ROW6,BUF+80
         MVC   ROW7,BUF+96
         MVC   ROW8,BUF+112
*        STFSMODE ON
         LA    R1,CHESSBD
         LA    R0,CHESSBDL
         ICM   R1,8,=X'0B'        WAIT,HOLD,FULLSCR
         TPUT  (1),(0),R          DISPLAY CHESSBOARD
EXIT3270 LR    R2,R15             SAVE TPUT RETURN CODE
         STLINENO LINELOC=SETLINE#,MODE=OFF
         LR    R15,R2             SET RETURN CODE FROM TPUT
         L     R13,4(,R13)        POINT TO CALLER'S SAVE AREA
         L     R14,12(,R13)
         LM    R0,R12,20(R13)
         XC    8(4,R13),8(R13)    CLEAR SAVE AREA CHAIN
         BR    R14                RETURN AFTER SUCCESS
*
         DROP  R11,R12            DUCH3270
         TITLE ' DUCHESS 3270 GRAPHICS SUPPORT WORKING STORAGE '
         LTORG
         DC    0D'0'
SAVEAREA DC    18F'0'
SCRNLNES DC    F'0'               NUMBER OF SCREEN LINES
SCRNCOLS DC    F'0'               NUMBER OF SCREEN COLUMNS
GOTTERM  DC    2F'0'              RESULTS FROM GTTERM MACRO
GETTERML GTTERM MF=L              PARAMETER LIST FOR GTTERM
TPGLIST  TPG   QUERY,L'QUERY,NOEDIT,WAIT,MF=L
TPUTLIST TPUT  PSAWSF,PSALEN,NOEDIT,WAIT,MF=L
SETLINE# DC    F'9'               LINE NUMBER AFTER BITMAP BOARD
*
STAT3270 DC    AL1(0)             TERMINAL STORAGE ID FOR SYMBOLS
*                                 X'00' IF NO GRAPHICS
*                                 X'80' IF VECTOR GRAPHICS BITMAP
ERSCMD   DC    AL1(EW)            COMMAND TO ERASE AND RESET SCREEN
*
CHARSIZE EQU   *,2                PIXEL SIZE OF A DISPLAY LOCATION
CHARWDTH DC    AL1(0)             PIXEL WIDTH OF A DISPLAY LOCATION
CHARHITE DC    AL1(0)             PIXEL HEIGHT OF A DISPLAY LOCATION
*
RESETAID DC    X'27F1C3'          ESCAPE + WRITE + WCC
QUERY    DC    X'F3000501FF02'    WRITE STRUCTURED FIELD + QUERY
*
*   DATA STREAM TO WRITE THE CHESSBOARD VECTOR GRAPHICS BITMAP
*
BDVECTOR DC    AL1(WSF)           WRITE STRUCTURED FIELD
         DC    AL2(4)             LENGTH OF FIRST STRUCTURED FIELD
         DC    X'03'              ERASE/RESET
BDCLRSIZ DC    X'00'              IMPLICIT PARTITION SIZE - DEFAULT
BDVECSF  DC    AL2(BDVECSFL)      LENGTH OF STRUCTURED FIELD
         DC    X'0F10'            GRAPHIC PICTURE
         DC    X'00'              PARTITION IDENTIFIER (PID)
         DC    B'11000000'        FLAGS - SPAN : FIRST AND LAST
*                                       - MODE : INTERMEDIATE MODE
         DC    X'00'              RESERVED
*
         DC    X'70'              BEGIN SEGMENT
         DC    AL1(12)            LENGTH OF FOLLOWING PARAMETERS
         DC    CL4'DUCH'          NAME OF PROCEDURE TO BE CREATED
         DC    B'01110100'        VISIBLE   NOHILITE
         DC    B'01101000'        NOPROL NEW SEG DATA
         DC    AL2(SEGLEN)        LENGTH OF PROCEDURE TO BE CREATED
         DC    X'00000000'        P/S NAME
SEGDATA  EQU   *
         DC    X'0C',AL1(4)       SET MIX (XOR)
         DC    X'21',AL1(4)       SET CURRENT POSITION
SEGXPOS  DC    AL2(0)             X
SEGYPOS  DC    AL2(0)             Y
         DC    X'0A',AL1(7)       SET COLOR
*                                 BEGIN IMAGE
         DC    X'91',AL1(6),AL2(0,128,128)
         SPACE
BDLINES  EQU   *                  128 BITMAP LINES
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
         DC    X'92',AL1(16),16X'00'
*                                 2048 BYTES OF PIXEL DATA IN BITMAP
*                                 IMAGE END
         DC    X'93',AL1(2),AL2(0)
SEGLEN   EQU   *-SEGDATA
BDVECSFL EQU   *-BDVECSF          LENGTH OF OUTBOUND STRUCTURED FIELD
BDVECLEN EQU   *-BDVECTOR         LENGTH OF TPUT DATA STREAM
*
*   DATA STREAM TO WRITE THE CHESSBOARD SYMBOLS
*
CHESSBD  DC    AL1(ESC)           ESCAPE
ERASECMD DC    AL1(EW)            ERASE AND RESET THE SCREEN
         DC    X'C1'              STANDARD WRITE CONTROL CHARACTER
         DC    X'2843D6'          USE LOADED CHARACTER SET
         DC    AL1(SBA),X'4040'   SBA LINE 1, COLUMN 1
         DC    AL1(SF),X'F8'      PROTECTED, HIGH INTENSITY, AUTOSKIP
ROW1     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C1D1'   SBA LINE 2, COLUMN 2
ROW2     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C261'   SBA LINE 3, COLUMN 2
ROW3     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C3F1'   SBA LINE 4, COLUMN 2
ROW4     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C5C1'   SBA LINE 5, COLUMN 2
ROW5     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C6D1'   SBA LINE 6, COLUMN 2
ROW6     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C761'   SBA LINE 7, COLUMN 2
ROW7     DC    CL16' '            CHESSBOARD ROW
         DC    AL1(SBA),X'C8F1'   SBA LINE 8, COLUMN 2
ROW8     DC    CL16' '            CHESSBOARD ROW
         DC    X'284300'          USE DEFAULT CHARACTER SET
         DC    AL1(SF),X'40'      UNPROTECTED, LOW INTENSITY
         DC    AL1(SBA),X'4A40'   SBA LINE 9, COLUMN 1
         DC    AL1(IC)            INSERT CURSOR
CHESSBDL EQU   *-CHESSBD          DATA STREAM LENGTH
         DC    0D'0'              TRANSLATE-AND-TEST TABLES
BUF      DC    CL128' '           LOCAL COPY OF CHESSBOARD BUFFER
WSWHITE  DC    XL256'00'          WHITE SQUARE WHITE PIECES
         ORG   WSWHITE+C'K'
         DC    AL1(WSWK)          KING
         ORG   WSWHITE+C'Q'
         DC    AL1(WSWQ)          QUEEN
         ORG   WSWHITE+C'R'
         DC    AL1(WSWR)          ROOK
         ORG   WSWHITE+C'N'
         DC    AL1(WSWN)          KNIGHT
         ORG   WSWHITE+C'B'
         DC    AL1(WSWB)          BISHOP
         ORG   WSWHITE+C'P'
         DC    AL1(WSWP)          PAWN
         ORG   WSWHITE+256-32     REUSE SOME STORAGE
BSWHITE  DC    XL256'00'          BLACK SQUARE WHITE PIECES
         ORG   BSWHITE+C'K'
         DC    AL1(BSWK)          KING
         ORG   BSWHITE+C'Q'
         DC    AL1(BSWQ)          QUEEN
         ORG   BSWHITE+C'R'
         DC    AL1(BSWR)          ROOK
         ORG   BSWHITE+C'N'
         DC    AL1(BSWN)          KNIGHT
         ORG   BSWHITE+C'B'
         DC    AL1(BSWB)          BISHOP
         ORG   BSWHITE+C'P'
         DC    AL1(BSWP)          PAWN
         ORG   BSWHITE+256-32     REUSE SOME STORAGE
WSBLACK  DC    XL256'00'          WHITE SQUARE BLACK PIECES
         ORG   WSBLACK+C'K'
         DC    AL1(WSBK)          KING
         ORG   WSBLACK+C'Q'
         DC    AL1(WSBQ)          QUEEN
         ORG   WSBLACK+C'R'
         DC    AL1(WSBR)          ROOK
         ORG   WSBLACK+C'N'
         DC    AL1(WSBN)          KNIGHT
         ORG   WSBLACK+C'B'
         DC    AL1(WSBB)          BISHOP
         ORG   WSBLACK+C'P'
         DC    AL1(WSBP)          PAWN
         ORG   WSBLACK+256-32     REUSE SOME STORAGE
BSBLACK  DC    XL256'00'          BLACK SQUARE BLACK PIECES
         ORG   BSBLACK+C'K'
         DC    AL1(BSBK)          KING
         ORG   BSBLACK+C'Q'
         DC    AL1(BSBQ)          QUEEN
         ORG   BSBLACK+C'R'
         DC    AL1(BSBR)          ROOK
         ORG   BSBLACK+C'N'
         DC    AL1(BSBN)          KNIGHT
         ORG   BSBLACK+C'B'
         DC    AL1(BSBB)          BISHOP
         ORG   BSBLACK+C'P'
         DC    AL1(BSBP)          PAWN
         ORG
*
*
*   SYMBOL STORAGES 0 (PRIMARY CHARACTER SET) AND 1 (ALTERNATE OR
*   GRAPHIC/"APL" CHARACTER SET) ARE READ-ONLY, IE. NOT LOADABLE.
*
*   FOR A 3279, PROGRAMMBLE STORAGE "A" REFERS TO SYMBOL STORAGE 2,
*               PROGRAMMBLE STORAGE "B" REFERS TO SYMBOL STORAGE 3,
*               PROGRAMMBLE STORAGE "C" REFERS TO SYMBOL STORAGE 4,
*               PROGRAMMBLE STORAGE "D" REFERS TO SYMBOL STORAGE 5,
*               PROGRAMMBLE STORAGE "E" REFERS TO SYMBOL STORAGE 6,
*               PROGRAMMBLE STORAGE "F" REFERS TO SYMBOL STORAGE 7.
*
         DC    CL16'SYMBOLS'      PADDING TO MAKE 'SYMBOL40' SAFE
*
PSAWSF   DC    X'F3'              WSF TO LOAD SYMBOLS INTO PSA.
SYMFIELD DC    AL2(ADDSYMLN)      STRUCTURED FIELD LENGTH.
*
*   LOADABLE SYMBOL SETS MUST HAVE AN ID IN THE X'40' TO X'EF' RANGE.
*   I CHOSE X'D6' FOR "DUCHESS 6".
*
         DC    X'0641D641'        LPS-ID,BASIC+CLR+TYP1,LCID,FIRST-SYM.
STGID#   DC    X'02'              READ/WRITE STORAGE ID.
*
*   FOR A SINGLE BYTE CHARACTER SET (SBCS) CODE POINTS X'40' TO X'FE'
*   ARE DISPLAYABLE.  CODE POINT X'40' IS NEVER LOADABLE AND IS
*   ALWAYS BLANK, AND WILL BE USED HERE FOR VACANT BLACK SQUARES.
*
SYMBOLS  EQU   *                  START OF SYMBOL PIXEL DATA
SYMBOL40 EQU   SYMBOLS-18,18      TO BE CLEARED TO SIMULATE A BLANK
*
* X'41'        VACANT            WHITE SQUARE            BOTH
         DC    B'1111111111111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
         DC    B'11111111',B'11111111',B'11111111',B'11111111'
*
BSWR     EQU   X'42'
* X'42'        WHITE ROOK        BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000000',B'00001101',B'00001101'
         DC    B'00001111',B'00000000',B'00000111',B'00000111'
         DC    B'00000111',B'00000111',B'00000000',B'00001111'
         DC    B'00001111',B'00000000',B'00000000',B'00000000'
* X'43'        WHITE ROOK        BLACK SQUARE           RIGHT
         DC    B'0011101111011000'
         DC    B'00000000',B'00000000',B'01100000',B'01100000'
         DC    B'11100000',B'00000000',B'11000000',B'11000000'
         DC    B'11000000',B'11000000',B'00000000',B'11100000'
         DC    B'11100000',B'00000000',B'00000000',B'00000000'
*
WSWR     EQU   X'44'
* X'44'        WHITE ROOK        WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11100000',B'11101101',B'11101101'
         DC    B'11101111',B'11100000',B'11110111',B'11110111'
         DC    B'11110111',B'11110111',B'11100000',B'11101111'
         DC    B'11101111',B'11100000',B'11111111',B'11111111'
* X'45'        WHITE ROOK        WHITE SQUARE           RIGHT
         DC    B'1011101111011011'
         DC    B'11111111',B'00001111',B'01101111',B'01101111'
         DC    B'11101111',B'00001111',B'11011111',B'11011111'
         DC    B'11011111',B'11011111',B'00001111',B'11101111'
         DC    B'11101111',B'00001111',B'11111111',B'11111111'
*
BSWB     EQU   X'46'
* X'46'        WHITE BISHOP      BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000000',B'00000001',B'00000011'
         DC    B'00000111',B'00001110',B'00001110',B'00011000'
         DC    B'00011000',B'00001110',B'00001110',B'00001110'
         DC    B'00001111',B'00000000',B'00000000',B'00000000'
* X'47'        WHITE BISHOP      BLACK SQUARE           RIGHT
         DC    B'0011100000001000'
         DC    B'00000000',B'00000000',B'00000000',B'10000000'
         DC    B'11000000',B'11100000',B'11100000',B'00110000'
         DC    B'00110000',B'11100000',B'11100000',B'11100000'
         DC    B'11100000',B'00000000',B'00000000',B'00000000'
*
WSWB     EQU   X'48'
* X'48'        WHITE BISHOP      WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111110',B'11111101',B'11111011'
         DC    B'11110111',B'11101110',B'11101110',B'11011000'
         DC    B'11011000',B'11101110',B'11101110',B'11101110'
         DC    B'11101111',B'11100000',B'11111111',B'11111111'
* X'49'        WHITE BISHOP      WHITE SQUARE           RIGHT
         DC    B'1011100000001011'
         DC    B'11111111',B'11111111',B'01111111',B'10111111'
         DC    B'11011111',B'11101111',B'11101111',B'00110111'
         DC    B'00110111',B'11101111',B'11101111',B'11101111'
         DC    B'11101111',B'00001111',B'11111111',B'11111111'
*
BSWN     EQU   X'4A'
* X'4A'        WHITE KNIGHT      BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000000',B'00000001',B'00000011'
         DC    B'00000111',B'00001110',B'00011000',B'00000001'
         DC    B'00000011',B'00000111',B'00000000',B'00011111'
         DC    B'00011111',B'00000000',B'00000000',B'00000000'
* X'4B'        WHITE KNIGHT      BLACK SQUARE           RIGHT
         DC    B'0011111111011000'
         DC    B'00000000',B'00000000',B'00000000',B'10000000'
         DC    B'11000000',B'11000000',B'11000000',B'11000000'
         DC    B'11000000',B'11100000',B'00000000',B'11110000'
         DC    B'11110000',B'00000000',B'00000000',B'00000000'
*
WSWN     EQU   X'4C'
* X'4C'        WHITE KNIGHT      WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111110',B'11111101',B'11111011'
         DC    B'11110111',B'11101110',B'11011000',B'11000001'
         DC    B'11111011',B'11110111',B'11000000',B'11011111'
         DC    B'11011111',B'11000000',B'11111111',B'11111111'
* X'4D'        WHITE KNIGHT      WHITE SQUARE           RIGHT
         DC    B'1011111111011011'
         DC    B'11111111',B'11111111',B'01111111',B'10111111'
         DC    B'11011111',B'11011111',B'11011111',B'11011111'
         DC    B'11011111',B'11101111',B'00000111',B'11110111'
         DC    B'11110111',B'00000111',B'11111111',B'11111111'
*
BSWP     EQU   X'4E'
* X'4E'        WHITE PAWN        BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000000',B'00000011',B'00000111'
         DC    B'00000111',B'00000011',B'00000001',B'00000011'
         DC    B'00000111',B'00001111',B'00000000',B'00011111'
         DC    B'00011111',B'00000000',B'00000000',B'00000000'
* X'4F'        WHITE PAWN        BLACK SQUARE           RIGHT
         DC    B'0011111111011000'
         DC    B'00000000',B'00000000',B'10000000',B'11000000'
         DC    B'11000000',B'10000000',B'00000000',B'10000000'
         DC    B'11000000',B'11100000',B'00000000',B'11110000'
         DC    B'11110000',B'00000000',B'00000000',B'00000000'
*
WSWP     EQU   X'50'
* X'50'        WHITE PAWN        WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111110',B'11111011',B'11110111'
         DC    B'11110111',B'11111011',B'11111101',B'11111011'
         DC    B'11110111',B'11101111',B'11000000',B'11011111'
         DC    B'11011111',B'11000000',B'11111111',B'11111111'
* X'51'        WHITE PAWN        WHITE SQUARE           RIGHT
         DC    B'1011111111011011'
         DC    B'11111111',B'11111111',B'10111111',B'11011111'
         DC    B'11011111',B'10111111',B'01111111',B'10111111'
         DC    B'11011111',B'11101111',B'00000111',B'11110111'
         DC    B'11110111',B'00000111',B'11111111',B'11111111'
*
WSBR     EQU   X'52'
* X'52'        BLACK ROOK        WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111111',B'11110010',B'11110010'
         DC    B'11110000',B'11111111',B'11111000',B'11111000'
         DC    B'11111000',B'11111000',B'11111111',B'11110000'
         DC    B'11110000',B'11111111',B'11111111',B'11111111'
* X'53'        BLACK ROOK        WHITE SQUARE           RIGHT
         DC    B'1100010000100111'
         DC    B'11111111',B'11111111',B'10011111',B'10011111'
         DC    B'00011111',B'11111111',B'00111111',B'00111111'
         DC    B'00111111',B'00111111',B'11111111',B'00011111'
         DC    B'00011111',B'11111111',B'11111111',B'11111111'
*
BSBR     EQU   X'54'
* X'54'        BLACK ROOK        BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00011111',B'00010010',B'00010010'
         DC    B'00010000',B'00011111',B'00001000',B'00001000'
         DC    B'00001000',B'00001000',B'00011111',B'00010000'
         DC    B'00010000',B'00011111',B'00000000',B'00000000'
* X'55'        BLACK ROOK        BLACK SQUARE           RIGHT
         DC    B'0100010000100100'
         DC    B'00000000',B'11110000',B'10010000',B'10010000'
         DC    B'00010000',B'11110000',B'00100000',B'00100000'
         DC    B'00100000',B'00100000',B'11110000',B'00010000'
         DC    B'00010000',B'11110000',B'00000000',B'00000000'
*
WSBB     EQU   X'56'
* X'56'        BLACK BISHOP      WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111110',B'11111100',B'11111000'
         DC    B'11110000',B'11100001',B'11100001',B'11100111'
         DC    B'11100111',B'11100001',B'11100001',B'11100001'
         DC    B'11110000',B'11110000',B'11111111',B'11111111'
* X'57'        BLACK BISHOP      WHITE SQUARE           RIGHT
         DC    B'1000011111110011'
         DC    B'11111111',B'11111111',B'01111111',B'00111111'
         DC    B'00011111',B'00001111',B'00001111',B'11001111'
         DC    B'11001111',B'00001111',B'00001111',B'00001111'
         DC    B'00011111',B'00011111',B'11111111',B'11111111'
*
BSBB     EQU   X'58'
* X'58'        BLACK BISHOP      BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000001',B'00000010',B'00000100'
         DC    B'00001000',B'00010001',B'00010001',B'00100111'
         DC    B'00100111',B'00010001',B'00010001',B'00010001'
         DC    B'00010000',B'00011111',B'00000000',B'00000000'
* X'59'        BLACK BISHOP      BLACK SQUARE           RIGHT
         DC    B'0100011111110100'
         DC    B'00000000',B'00000000',B'10000000',B'01000000'
         DC    B'00100000',B'00010000',B'00010000',B'11001000'
         DC    B'11001000',B'00010000',B'00010000',B'00010000'
         DC    B'00010000',B'11110000',B'00000000',B'00000000'
*
WSBN     EQU   X'5A'
* X'5A'        BLACK KNIGHT      WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111111',B'11111110',B'11111100'
         DC    B'11111000',B'11110001',B'11100011',B'11111110'
         DC    B'11111100',B'11111000',B'11111111',B'11100000'
         DC    B'11100000',B'11111111',B'11111111',B'11111111'
* X'5B'        BLACK KNIGHT      WHITE SQUARE           RIGHT
         DC    B'1100000000100111'
         DC    B'11111111',B'11111111',B'11111111',B'01111111'
         DC    B'00111111',B'00111111',B'00111111',B'00111111'
         DC    B'00111111',B'00011111',B'11111111',B'00001111'
         DC    B'00001111',B'11111111',B'11111111',B'11111111'
*
BSBN     EQU   X'5C'
* X'5C'        BLACK KNIGHT      BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000001',B'00000110',B'00001100'
         DC    B'00011000',B'00110001',B'01100011',B'00011110'
         DC    B'00000100',B'00001000',B'00111111',B'00100000'
         DC    B'00100000',B'00111111',B'00000000',B'00000000'
* X'5D'        BLACK KNIGHT      BLACK SQUARE           RIGHT
         DC    B'0100000000100100'
         DC    B'00000000',B'00000000',B'10000000',B'01000000'
         DC    B'00100000',B'00100000',B'00100000',B'00100000'
         DC    B'00110000',B'00010000',B'11111000',B'00001000'
         DC    B'00001000',B'11111000',B'00000000',B'00000000'
*
WSBP     EQU   X'5E'
* X'5E'        BLACK PAWN        WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111111',B'11111100',B'11111000'
         DC    B'11111000',B'11111100',B'11111110',B'11111100'
         DC    B'11111000',B'11110000',B'11111111',B'11100000'
         DC    B'11100000',B'11111111',B'11111111',B'11111111'
* X'5F'        BLACK PAWN        WHITE SQUARE           RIGHT
         DC    B'1100000000100111'
         DC    B'11111111',B'11111111',B'01111111',B'00111111'
         DC    B'00111111',B'01111111',B'11111111',B'01111111'
         DC    B'00111111',B'00011111',B'11111111',B'00001111'
         DC    B'00001111',B'11111111',B'11111111',B'11111111'
*
BSBP     EQU   X'60'
* X'60'        BLACK PAWN        BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000001',B'00000100',B'00001000'
         DC    B'00001000',B'00000100',B'00000010',B'00000100'
         DC    B'00001000',B'00010000',B'00111111',B'00100000'
         DC    B'00100000',B'00111111',B'00000000',B'00000000'
* X'61'        BLACK PAWN        BLACK SQUARE           RIGHT
         DC    B'0100000000100100'
         DC    B'00000000',B'00000000',B'01000000',B'00100000'
         DC    B'00100000',B'01000000',B'10000000',B'01000000'
         DC    B'00100000',B'00010000',B'11111000',B'00001000'
         DC    B'00001000',B'11111000',B'00000000',B'00000000'
*
BSWK     EQU   X'62'
* X'62'        WHITE KING        BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000001',B'00000111',B'00111001'
         DC    B'01101101',B'01100111',B'01100011',B'00110011'
         DC    B'00011111',B'00001111',B'00000000',B'00011111'
         DC    B'00011111',B'00000000',B'00000000',B'00000000'
* X'63'        WHITE KING        BLACK SQUARE           RIGHT
         DC    B'0111111111011000'
         DC    B'00000000',B'00000000',B'11000000',B'00111000'
         DC    B'01101100',B'11001100',B'10001100',B'10011000'
         DC    B'11110000',B'11100000',B'00000000',B'11110000'
         DC    B'11110000',B'00000000',B'00000000',B'00000000'
*
WSWK     EQU   X'64'
* X'64'        WHITE KING        WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111100',B'11111001',B'11000111',B'10111001'
         DC    B'01101101',B'01100111',B'01100011',B'10110011'
         DC    B'11011111',B'11101111',B'11000000',B'11011111'
         DC    B'11011111',B'11000000',B'11111111',B'11111111'
* X'65'        WHITE KING        WHITE SQUARE           RIGHT
         DC    B'0111111111011011'
         DC    B'01111111',B'00011111',B'11000111',B'00111011'
         DC    B'01101101',B'11001101',B'10001101',B'10011011'
         DC    B'11110111',B'11101111',B'00000111',B'11110111'
         DC    B'11110111',B'00000111',B'11111111',B'11111111'
*
BSWQ     EQU   X'66'
* X'66'        WHITE QUEEN       BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00000000',B'00000110',B'01100110'
         DC    B'00110110',B'00110110',B'00011011',B'00011011'
         DC    B'00001111',B'00001111',B'00000000',B'00011111'
         DC    B'00011111',B'00000000',B'00000000',B'00000000'
* X'67'        WHITE QUEEN       BLACK SQUARE           RIGHT
         DC    B'0000001111011000'
         DC    B'00000000',B'00000000',B'11000000',B'11001100'
         DC    B'11011000',B'11011000',B'10110000',B'10110000'
         DC    B'11100000',B'11100000',B'00000000',B'11110000'
         DC    B'11110000',B'00000000',B'00000000',B'00000000'
*
WSWQ     EQU   X'68'
* X'68'        WHITE QUEEN       WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11110000',B'10010110',B'01100110'
         DC    B'10110110',B'10110110',B'11011011',B'11011011'
         DC    B'11101111',B'11101111',B'11000000',B'11011111'
         DC    B'11011111',B'11000000',B'11111111',B'11111111'
* X'69'        WHITE QUEEN       WHITE SQUARE           RIGHT
         DC    B'1000001111011011'
         DC    B'11111111',B'00011111',B'11010011',B'11001101'
         DC    B'11011011',B'11011011',B'10110111',B'10110111'
         DC    B'11101111',B'11101111',B'00000111',B'11110111'
         DC    B'11110111',B'00000111',B'11111111',B'11111111'
*
WSBK     EQU   X'6A'
* X'6A'        BLACK KING        WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111110',B'11111000',B'11000110'
         DC    B'10010010',B'10011000',B'10011100',B'11001100'
         DC    B'11100000',B'11110000',B'11111111',B'11100000'
         DC    B'11100000',B'11111111',B'11111111',B'11111111'
* X'6B'        BLACK KING        WHITE SQUARE           RIGHT
         DC    B'1000000000100111'
         DC    B'11111111',B'11111111',B'00111111',B'11000111'
         DC    B'10010011',B'00110011',B'01110011',B'01100111'
         DC    B'00001111',B'00011111',B'11111111',B'00001111'
         DC    B'00001111',B'11111111',B'11111111',B'11111111'
*
BSBK     EQU   X'6C'
* X'6C'        BLACK KING        BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000011',B'00000110',B'00111000',B'01000110'
         DC    B'10010010',B'10011000',B'10011100',B'01001100'
         DC    B'00100000',B'00010000',B'00111111',B'00100000'
         DC    B'00100000',B'00111111',B'00000000',B'00000000'
* X'6D'        BLACK KING        BLACK SQUARE           RIGHT
         DC    B'1000000000100100'
         DC    B'10000000',B'11100000',B'00111000',B'11000100'
         DC    B'10010010',B'00110010',B'01110010',B'01100100'
         DC    B'00001000',B'00010000',B'11111000',B'00001000'
         DC    B'00001000',B'11111000',B'00000000',B'00000000'
*
WSBQ     EQU   X'6E'
* X'6E'        BLACK QUEEN       WHITE SQUARE            LEFT
         DC    B'1111111111111111'
         DC    B'11111111',B'11111111',B'11111001',B'10011001'
         DC    B'11001001',B'11001001',B'11100100',B'11100100'
         DC    B'11110000',B'11110000',B'11111111',B'11100000'
         DC    B'11100000',B'11111111',B'11111111',B'11111111'
* X'6F'        BLACK QUEEN       WHITE SQUARE           RIGHT
         DC    B'1111110000100111'
         DC    B'11111111',B'11111111',B'00111111',B'00110011'
         DC    B'00100111',B'00100111',B'01001111',B'01001111'
         DC    B'00011111',B'00011111',B'11111111',B'00001111'
         DC    B'00001111',B'11111111',B'11111111',B'11111111'
*
BSBQ     EQU   X'70'
* X'70'        BLACK QUEEN       BLACK SQUARE            LEFT
         DC    B'0000000000000000'
         DC    B'00000000',B'00001111',B'01101001',B'10011001'
         DC    B'01001001',B'01001001',B'00100100',B'00100100'
         DC    B'00010000',B'00010000',B'00111111',B'00100000'
         DC    B'00100000',B'00111111',B'00000000',B'00000000'
* X'71'        BLACK QUEEN       BLACK SQUARE           RIGHT
         DC    B'0111110000100100'
         DC    B'00000000',B'11100000',B'00101100',B'00110010'
         DC    B'00100100',B'00100100',B'01001000',B'01001000'
         DC    B'00010000',B'00010000',B'11111000',B'00001000'
         DC    B'00001000',B'11111000',B'00000000',B'00000000'
*
ADDSYMLN EQU   *-SYMFIELD
PSALEN   EQU   *-PSAWSF
         DC    0D'0'
         DC    CL8' END OF '
         DC    CL8'DUCH3270'
         DC    0D'0'              END OF CSECT
         END   DFRNTEND
/*
//RELINK7.SYSLIN   DD    *
         INCLUDE SYSLIB(DFRNTEND)
         INCLUDE SYSLIB(DMAIN)
         INCLUDE SYSLIB(CMNDUTIL)
         INCLUDE SYSLIB(VSTAMP)
         INCLUDE SYSLIB(PARSUTIL)
         INCLUDE SYSLIB(DRIVERS)
         INCLUDE SYSLIB(DATABASE)
         INCLUDE SYSLIB(THREATS)
         INCLUDE SYSLIB(PIECGEN)
         INCLUDE SYSLIB(SEARCH)
         INCLUDE SYSLIB(SRCHUTIL)
         INCLUDE SYSLIB(ECHOUTIL)
         INCLUDE SYSLIB(TTABLE)
         INCLUDE SYSLIB(SUBS)
         INCLUDE SYSLIB(SYSTEM)
         INCLUDE SYSLIB(BOARDG)
         ORDER   DFRNTEND,DMAIN,CMNDUTIL,VSTAMP,PARSUTIL,DRIVERS
         ORDER   DATABASE,THREATS,PIECGEN,SEARCH0,SRCHUTIL
         ORDER   ECHOUTIL,TTABLE,SUBS,SYSTEM,FILETBL,GETSTRNG
         ORDER   MAKEMOVE,MVEX,NEWLINE,PRINTF,PUTCHAR,BDEV
         ORDER   BDEVSTRS,BOARD,CAPGEN,$CHARMOV,GETNUMBR
         ORDER   GETOKEN,HELP,MOVECHAR,MOVESORT,MVGEN
         ORDER   BDEVUTIL,BOOKMOVE,CMPTPOST,EVBOUND,FINDMOVE
         ORDER   GETCHAR,THRTTBLS,BDKEY,$PARSE,UNGETCHR
         ENTRY   DFRNTEND
         NAME    DUCHESSG(R)
/*
//
