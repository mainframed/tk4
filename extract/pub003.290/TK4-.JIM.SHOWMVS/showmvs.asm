***********************************************************************
*                                                                     *
*     THIS PROGRAM RUNS IN BATCH   AND DISPLAYS A LOT OF         <38J>*
*     INFORMATION THAT YOU GENERALLY HAVE TO GET FROM DIFFERENT       *
*     SOURCES.                                                        *
*                                                                     *
*       ON-LINE CPU'S                                                 *
*       AMOUNT OF ON-LINE STORAGE (REAL AND EXTENDED)                 *
*       IPL DATE, TIME, VOLSER, NUC-ID, CLPA                          *
*       VIRTUAL STORAGE MAP (CSA, SQA, LPA, ETC)                      *
*       DSN OF THE MASTER CATALOG                                     *
*       DSN OF THE PAGE DATA SETS                                     *
*       SMFSID, JWT, GRS' SNAME                                       *
*       MVS LEVEL, DFP LEVEL, OSLVL FLAGS                             *
*       PRODUCT LEVELS FOR: TSO/E, ISPF, DFDSS, HSM, RACF, VTAM       *
*       UCB TABLE WITH UNIT NAMES AND DASD VOLUME STATUS              *
*       SUB-SYSTEM VECTOR TABLE WITH FUNCTIONS PROCESSED              *
*       ACTIVE LPA QUEUE                                              *
*       SVC TABLE WITH NAME OF CORRESPONDING LPA MODULE               *
*       LINK-LIST DATA SETS, WITH CREATION DATE                       *
*       LPA-LIST DATA SETS, WITH CREATION DATE                        *
*       LIST OF AUTHORIZED LIBRARIES                                  *
*       YOUR TIOT, WITH EXCP COUNTS FOR EACH DD                       *
*       ENHANCED VIEW OF YOUR JPAQ                                    *
*       ENHANCED VIEW OF THE LOAD-LISTS OF YOUR ADDRESS SPACE         *
***********************************************************************
*
*  REGISTER USAGE
*
*  R0    SCRATCH
*  R1    SCRATCH
*  R2
*  R3    CVT
*  R4    TCB
*  R5
*  R6
*  R7
*  R8
*  R9
*  R10   CURRENT LINE PTR FOR STRING
*  R11   BASE
*  R12   BASE (SHORT-TERM VIA P$BEGIN)
*  R13   DYN
*  R14   SCRATCH, INTERNAL LINKAGE
*  R15   SCRATCH, RETURN CODE
***********************************************************************
         PRINT GEN,DATA                   <38J>
         EJECT ,
SHOWMVS  CSECT
         USING PSA,0                                              <38J>
*8OWMVS  RMODE ANY
BASEADDR DS    0H                                                 <38J>
&VERMOD  SETC  'V38J.0001'             VERSION 2004-12-n9gtm
         SAVE  (14,12),,'SHOWMVS &SYSDATE '
         LR    R11,R15                                            <38J>
         USING BASEADDR,R11                                       <38J>
         GETMAIN RU,LV=DYNL,BNDRY=PAGE                            <38J>
         LR    R9,R1                   SAVE GOTTEN AREA PTR       <38J>
         LR    R0,R1                   MVCL DEST ADDR             <38J>
         L     R1,=A(DYNL)             MVCL DEST LENGTH           <38J>
         SLR   R15,R15                 MVCL SOURCE LENGTH         <38J>
         MVCL  R0,R14                  CLEAR GOTTEN STORAGE       <38J>
         ST    R13,4(,R9)              OUR BACKPTR @ CALLER'S SA  <38J>
         ST    R9,8(,R13)              CALLER'S FWDPTR @ OUR SA   <38J>
         LM    R13,R1,8(R13)           SET R13, RELOAD R1
         USING DYN,R13
         MVC   PARMADDR,0(R1)          SAVE PARM/CBUF ADDRESS
*----------------------------------------------------------------------
         BAL   R14,INITIAL             INITIALIZE THE ENVIRONMENT
         LTR   R15,R15                 VALID ISPF ENVIRONMENT?
         BNZ   GOBACK                  NO, QUIT
         BAL   R14,SPACE1              BLANK LINE AT THE TOP
         BAL   R14,HARDWARE            HARDWARE DATA
         BAL   R14,IPLDATA             IPL DATE
         BAL   R14,MEMORY              VIRTUAL MEMORY MAP
         BAL   R14,MASTRCAT            MASTER CATALOG
         BAL   R14,PAGEDS              PAGE DATA SETS
         BAL   R14,SMFDATA             SMF DATA
         BAL   R14,SPLEVEL             MVS/SP & DFP LEVELS
         BAL   R14,PRODUCTS            TSO, SPF, DFDSS, HSM, RACF, VTAM
         BAL   R14,SORT                SORT ALIAS
         BAL   R14,DEVICES             ON-LINE UNITS
         BAL   R14,SUBSYSTM            SUB-SYSTEMS
         BAL   R14,LPACTIV             ACTIVE LPA
         BAL   R14,SVCTABLE            SVC TABLE
         BAL   R14,LINKLIST            LNKLSTXX
         BAL   R14,LPALIST             LPALSTXX
         BAL   R14,APFLIST             APF LIST
         BAL   R14,SCANTIOT            TIOT
         BAL   R14,TCB_TREE            TCB TREE
         BAL   R14,JPAQ                JPAQ
         BAL   R14,LOADLIST            LOAD LISTS
         BAL   R14,CLOSE               CLOSE SYSPRINT             <38J>
         ESTAE 0                       DELETE RECOVERY ENVIRONMENT
*8       BAL   R14,BRIF                START BROWSE MODE
GOBACK   LR    R1,R13
         L     R13,4(,R13)
         FREEMAIN RU,LV=DYNL,A=(1)
         RETURN (14,12),RC=00
*----------------------------------------------------------------------
         EJECT ,
*----------------------------------------------------------------------
*        INITIALIZE THE ENVIRONMENT
*----------------------------------------------------------------------
INITIAL  P$BEGIN ,
         AGO   .XINI1                                             <38J>
*8       LOAD  EP=ISPLINK              LOAD ISPLINK
*8       ST    R0,ISPLINK              KEEP THE ADDRESS
*8       LA    R0,L'ZENVIR             .
*8       ST    R0,DWD                  .
*8       LA    R14,=C'VCOPY '          ISPF FUNCTION
*8       LA    R15,=C'(ZENVIR)'        VARIABLE LIST
*8       LA    R0,DWD                  LENGTH
*8       LA    R1,ZENVIR               AREA ADDRESS
*8       LA    R2,=C'MOVE '            MOVE MODE
*8       STM   R14,R2,TENWORDS
*8       OI    TENWORDS+16,X'80'       END-OF-LIST FLAG
*8       LA    R1,TENWORDS             PARM LIST ADDRESS
*8       L     R15,ISPLINK             LOAD INTERFACE ADDRESS
*8       BALR  R14,R15                 CALL ISPF
*8       LTR   R15,R15
*8       BNZ   INIT99
.XINI1   ANOP  ,                                                  <38J>
*
         ST    R11,BASEREG             FOR RECOVERY ROUTINE
         L     R2,=A(RECOVERY)         RECOVERY ROUTINE
         MNOTE *,'ESTAE ROUTINE TEMPORARILY DISABLED'
         AGO   .NOSTAE
         ESTAE (R2),                   RECOVERY ROUTINE               XX
               CT,                     CREATE                         XX
               PARAM=DYN,              PARAM FOR RECOVERY ROUTINE     XX
               MF=(E,ESTAEL)
.NOSTAE  ANOP
*
         MVI   BLANKS,C' '
         MVC   BLANKS+1(L'BLANKS-1),BLANKS
*
         LA    R10,LINES               START OF TABLES
         USING LINE,R10
*
         L     R3,CVTPTR               CVT ADDRESS
         USING CVTMAP,R3               PERMANENT ASSIGNMENT
*
         L     R4,PSATOLD-PSA          MY TCB
         USING TCB,R4
*
         ST    R4,MYTCB                KEEP ITS ADDRESS FOR DETACH
         MVC   JSTCB,TCBJSTCB          THE JOB STEP TCB
*
         AGO   .XINI2                                             <38J>
*8       L     R1,CVTLINK              DCB FOR SYS1.LINKLIB
*8       LOAD  EP=IEFEB4UV,DCB=(1)     GET ADDRESS OF IEFEB4UV ROUTINE
*8       ST    R0,IEFEB4UV             KEEP ADDRESS
.XINI2   ANOP  ,                                                  <38J>
         SLR   R15,R15                 INITIALIZATION GOOD        <38J>
INIT99   P$END
         EJECT ,
*----------------------------------------------------------------------
*        ON-LINE CPU'S AND REAL STORAGE
*----------------------------------------------------------------------
HARDWARE P$BEGIN
         STRING 'ONLINE CPU(S)',INTO=LINE                         <38J>
         LA    R10,NEXTLINE                                       <38J>
         L     R7,CVTPCCAT             PCCA VECTOR TABLE
         LA    R8,0016                 16 IS THE MAX NUMBER OF CPU'S
*LOOP
HARDW1   ICM   R9,B'1111',0(R7)        PCCA
         BZ    HARDW4                  THIS CPU ACTIVE, JUMP
         USING PCCA,R9
         STRING '  CPU ',(PCCACPUA,H,L),'  SERIAL: ',(PCCACPID+0,8), XXX
               '  MODEL: ',(PCCACPID+8,4),INTO=LINE
         LA    R10,NEXTLINE
HARDW4   LA    R7,4(,R7)               BUMP PCCAT PTR
         BCT   R8,HARDW1
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
*
*        REAL STORAGE
*
         STRING 'REAL STORAGE',INTO=LINE                          <38J>
         LA    R10,NEXTLINE                                       <38J>
         LA    R1,0001
         AL    R1,CVTEORM              HI-ADDR
         SRL   R1,0010                 GET IT IN "K"
         STRING '  ON-LINE: ',(CVTRLSTG,F,L),'K',                      X
               '   HIGHEST ADDRESS: ',((R1),,L),'K',                   X
               INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
*8       L     R8,CVTRCEP              RSM CTL & ENUM AREA
*8       L     R9,RCEESPL-RCE(,R8)     # OF EXTENDED STORAGE FRAMES
*8       SLL   R9,002                  CHANGE TO "K"
*8       STRING '      EXTENDED STORAGE: ',((R9),,L),'K',INTO=LINE
*8       BAL   R14,SPACE2              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        IPL DATA
*----------------------------------------------------------------------
IPLDATA  P$BEGIN ,
         AGO   .XIPLD1                                            <38J>
         L     R6,CVTSMCA              SMF SMCA
         USING SMCABASE,R6
         L     R1,SMCAIDTE             IPL DATE 00YYDDDF
         L     R1,=X'0000000F'         IPL DATE 00YYDDDF          <38J>
         L     R15,=A(@JDATE)          DATE CONVERT RTNE
         BALR  R14,R15                 CONVERT JULIAN TO YYMMDD
         MVC   DWD+0(2),0(R1)          YY
         MVI   DWD+2,C'/'              YY/
         MVC   DWD+3(2),2(R1)          YY/MM
         MVI   DWD+5,C'/'              YY/MM/
         MVC   DWD+6(2),4(R1)          YY/MM/DD
         SLR   R0,R0
         L     R1,SMCAITME             IPL TIME (BINARY)
         L     R1,=A(0)                IPL TIME (BINARY) <38J>
         D     R0,=X'00057E40'         GET HOURS
         LR    R2,R1                   HH
         LR    R1,R0                   REMAINDER
         SLR   R0,R0
         D     R0,=F'6000'             GET MINUTES IN R1
*
         ZAP   K2,CVTDATE              TODAY'S DATE
         STRING '(TODAY)',INTO=NEXTLINE
         SP    K2,SMCAIDTE             DIFFERENCE IN DAYS
         SP    K2,CVTDATE              DIFFERENCE IN DAYS
         BZ    IPLDATA6                TODAY, JUMP
         STRING '(YESTERDAY)',INTO=NEXTLINE
         CP    K2,=P'1'                WAS IT YESTERDAY?
         BE    IPLDATA6                YES, JUMP
         STRING '(',(K2,P,L0),' DAYS AGO)',INTO=NEXTLINE
IPLDATA6 DS    0H
         STRING 'IPL DATE: ',DWD,2X,(NEXTLINE,,T),                   XXX
               '   TIME: ',((R2),,R2Z),':',((R1),,R2Z),INTO=LINE
         LA    R10,NEXTLINE
.XIPLD1  ANOP                                                     <38J>
*
         L     R5,CVTSYSAD             IPL UCB
         USING UCBOB,R5
         L     R8,CVTEXT2              CVT EXTENSION
         USING CVTXTNT2,R8
         L     R15,CVTASMVT            POINT TO ASM VECTOR TABLE
         LA    R9,=C'NO '              CLPA=NO
         TM    ASMFLAG2-ASMVT(R15),ASMQUICK   QUICK START?
         BO    *+8                     YES, JUMP
         LA    R9,=C'YES'              NO, CLPA=YES
         STRING 'IPL FROM: ',UCBVOLI,'/',UCBNAME,                 <38J>X
               '   NUC ID: ',CVTNUCLS,                                 X
               '   CLPA: ',((R9),3),INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        DISPLAY VIRTUAL MEMORY MAP
*----------------------------------------------------------------------
MEMORY   P$BEGIN ,
         STRING 'VIRTUAL STORAGE MAP',INTO=LINE
         BAL   R14,SPACE2
         STRING '  ----AREA----',                                     XX
               '  ------START------     ------END-------     SIZE',   XX
               INTO=LINE
         BAL   R14,SPACE2
*
         L     R7,CVTGDA               GLOBAL DATA AREA
         USING GDA,R7
*
* COMMON AREA
*
         L     R8,CSAPQEP              GDA -> CSA PQE             <38J>
         USING PQESECT,R8                                         <38J>
        $MEMORY '----------',PQEREGN,CVTMZ00                      <38J>
         S     R10,=A(L$LINE)
         MVC   LINE(8),=C'  COMMON'
         BAL   R14,SPACE2
*
**       ST    R7,DY8WORD1
**       LA    R14,L$GDA
**       ST    R14,DY8WORD3
**      $MEMORY '       GDA',DY8WORD1,,DY8WORD3
*
         L     R9,SQASPQEP             GDA -> SQA (SP245) SPQE
         USING SPQESECT,R9
         L     R9,SPDQEPTR             SPQE -> DQE
         USING DQESECT,R9
        $MEMORY '       SQA',DQEBLKAD,,DQELNTH
*
         L     R14,DQEBLKAD            SQA BEGIN ADDR
         BCTR  R14,0
         ST    R14,DY8WORD2            PLPA/SQA CONTIGUOUS
         SLR   R9,R9
         ICM   R9,7,CVTLPDIR           CVT -> LPA DIRECTORY
         ST    R9,DY8WORD1
        $MEMORY '      PLPA',DY8WORD1,DY8WORD2
*
*       $MEMORY '      MLPA',CVTMLPAS,CVTMLPAE
*       $MEMORY '    P-BLDL',????????,????????  PAGEABLE BLDL
*
         L     R8,CSAPQEP              GDA -> CSA PQE             <38J>
         USING PQESECT,R8                                         <38J>
        $MEMORY '       CSA',PQEREGN,,PQESIZE                     <38J>
         BAL   R14,SPACE1
*
* PRIVATE USER AREA
*
        $MEMORY '----------',PASTRT,,PASIZE                       <38J>
         S     R10,=A(L$LINE)
         MVC   LINE(9),=C'  PRIVATE'
         BAL   R14,SPACE2
*
*       $MEMORY '      LSQA',???????,,???????                     <38J>
*       $MEMORY '       SWA',???????,,???????                     <38J>
*
         L     R9,PSAAOLD              PSA -> CURRENT ASCB
         USING ASCB,R9
         L     R9,ASCBLDA              ASCB -> LDA
         USING LDA,R9
         L     R8,ASDPQE               LDA -> ADDR SPACE RGN PQE  <38J>
         USING PQESECT,R8                                         <38J>
        $MEMORY 'V=V REGION',PQEREGN,,PQESIZE                     <38J>
*
         L     R8,VRPQEP               GDA -> ALLOWABLE V=R       <38J>
         USING PQESECT,R8                                         <38J>
        $MEMORY 'V=R REGION',PQEREGN,,PQESIZE                     <38J>
*
         L     R8,LDASRPQE             LDA -> SYSTEM REGION PQE   <38J>
         USING PQESECT,R8                                         <38J>
        $MEMORY 'SYS REGION',PQEREGN,,PQESIZE                     <38J>
         BAL   R14,SPACE1
*
* NUCLEUS/SYSTEM AREA
*
         SLR   R14,R14                 ADDRESS 0
         ST    R14,DY8WORD1
         L     R14,CVTNUCB             LOWEST ADDR NOT IN NUC
         BCTR  R14,0                   LAST ADDR IN NUC
         ST    R14,DY8WORD2
        $MEMORY '----------',DY8WORD1,DY8WORD2                    <38J>
         S     R10,=A(L$LINE)
         MVC   LINE(9),=C'  NUCLEUS'
*        BAL   R14,SPACE1
*       $MEMORY '   NUC-EXT',????????,????????                    <38J>
*       $MEMORY '      FLPA',????????,????????                    <38J>
*       $MEMORY '    F-BLDL',????????,????????                    <38J>
*       $MEMORY '   NUCLEUS',????????,????????                    <38J>
**
**
**       STRING 'LDA->',((R9),,X),INTO=LINE
         BAL   R14,SPACE2
         DROP  R7                      GDA                        <38J>
         DROP  R8                      PQE                        <38J>
         DROP  R9
         P$END
*
*8      $MEMORY '   MLPA   ',CVTEMLPS,CVTEMLPE
*8      $MEMORY '   FLPA   ',CVTFLPAS,CVTFLPAE
ADDR0    DC    A(0)                    VIRTUAL ADDR ZERO          <38J>
         EJECT ,
*----------------------------------------------------------------------
*        DSNAME OF THE MASTER CATALOG
*----------------------------------------------------------------------
* NOTE: OLD CODE SIMPLY REMOVED (NOT COMMENTED OUT) IN THIS CODE  <38J>
CBSCAXCN EQU   X'14'                   AMCBS OFFSET TO CAXWA CHAIN<38J>
CAXUCB   EQU   X'1C'                   CAXWA OFFSET TO UCB        <38J>
CAXCNAM  EQU   X'34'                   CAXWA OFFSET TO CAT NAME   <38J>
*
MASTRCAT P$BEGIN ,
         L     R5,CVTCBSP              @ AMCBS
         L     R6,CBSCAXCN(,R5)        @ CAXWA CHAIN              <38J>
*
CATLOOP  DS    0H
         L     R7,CAXUCB(,R6)          UCB ADDR                   <38J>
         USING UCBOB,R7
*                                      MCAT AT END OF CAXWA CHAIN <38J>
         MVC   UNITNAME+8(4),UCBTYP    DEVICE TYPE
*8<TMP>  BAL   R14,GETUNIT             GET UNITNAME
*                                      KEEP OVERLAYING, MCAT LAST CAXWA
         MVC   LINE,BLANKS                                        <38J>
         STRING 'MASTER CATALOG:',                                     +
               '  DSN=',(X'034'(R6),44,T),                             +
               ' CUU=',UCBNAME,                                        +
               ' VOLSER=',UCBVOLI,INTO=LINE
         ICM   R6,15,4(R6)             @ NEXT CAXWA, IF ANY       <38J>
         BNZ   CATLOOP                                            <38J>
         BAL   R14,SPACE2                                         <38J>
         P$END
         DROP  R7                      UCBOB
         EJECT ,
*----------------------------------------------------------------------
*        DISPLAY PAGE DATA SETS
*----------------------------------------------------------------------
PAGEDS   P$BEGIN ,
         STRING 'PAGE DATA SETS:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R9,CVTASMVT             POINT TO ASM VECTOR TABLE
         L     R9,ASMPART-ASMVT(,R9)   POINT TO PAGE ACT REF TABLE
         L     R1,PARTSIZE-PART(,R9)   NUMBER OF PART ENTRIES
         L     R2,PARTDSNL-PART(,R9)   POINT TO 1ST PAGE DSN
*LOOP
PAGEDS1  CLI   0(R2),C' '              VALID DSN?
         BNH   PAGEDS2                 NO, SKIP IT
         MVC   LINE,BLANKS             BLANK LINE
         MVC   DSNAME,0(R2)            MOVE DSNAME
*        MVI   VOLSER,C'?'             LOCATE WILL BE DONE LATER  <38J>
         LA    R10,NEXTLINE
PAGEDS2  LA    R2,44(,R2)              NEXT DSN
         BCT   R1,PAGEDS1
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        DISPLAY SMF DATA
*----------------------------------------------------------------------
SMFDATA  P$BEGIN ,
         L     R6,CVTSMCA              SMF SMCA
         USING SMCABASE,R6
*8       STRING '  SID: ',SMCASID,'  JWT: ',SMCASJWT,INTO=LINE,    X
*8             '   CVTSNAME: ',CVTSNAME  GRS
         STRING 'SMF SID: ',SMCASID,INTO=LINE                     <38J>
         BAL   R14,SPACE2              BLANK LINE
         P$END
         DROP  R6                      SMCA
         EJECT ,
         EJECT ,
*----------------------------------------------------------------------
*        PRINT CVT FIELDS
*----------------------------------------------------------------------
SPLEVEL  P$BEGIN ,
         AGO   .XSPLVL           <38J>
         LR    R6,R3                   A(CVTMAP)
         SH    R6,=Y(CVTMAP-CVTFIX)    SUBTRACT PREFIX LENGTH
         USING CVTFIX,R6
         L     R7,CVTDFA               DATA FACILITIES AREA
         USING DFA,R7
         MVC   DWD,=X'40204B204B20'    ' X.X.X'
         ED    DWD,DFAREL              X'3200'
         TM    CVTDCB,CVTOSEXT         DO WE HAVE OSLVL?
         BO    SPLVL21                 YES, JUMP
         STRING '  CVTPRODI: ',CVTPRODI,'  CVTPRODN: ',CVTPRODN,       X
               '  DFP LEVEL:',(DWD,6),                                 X
               '   CVTDCB: ',(CVTDCB,1,X),                             X
               INTO=LINE
         B     SPLVL99
SPLVL21  DS    0H
         STRING '  CVTPRODI: ',CVTPRODI,'  CVTPRODN: ',CVTPRODN,       X
               '  DFP LEVEL:',(DWD,6),INTO=LINE
         LA    R10,NEXTLINE
         STRING '    CVTDCB: ',(CVTDCB,1,X),                           X
               '   OSLVL: ',(CVTOSLVL+0,1,X),1X,(CVTOSLVL+1,1,X),1X,   X
               (CVTOSLVL+2,1,X),1X,(CVTOSLVL+3,1,X),1X,                X
               (CVTOSLVL+4,1,X),1X,(CVTOSLVL+5,1,X),1X,                X
               (CVTOSLVL+6,1,X),1X,(CVTOSLVL+7,1,X),1X,                X
               INTO=LINE
SPLVL99  BAL   R14,SPACE2              BLANK LINE
.XSPLVL  ANOP               <38J>
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        TSO/E, DFDSS, HSM, RACF, VTAM
*----------------------------------------------------------------------
PRODUCTS P$BEGIN ,
         STRING 'PRODUCTS:',INTO=LINE
         LA    R10,NEXTLINE
         AGO   .XPROD    <38J>  SKIP CVTTVT
*
         L     R7,CVTTVT               TSO VECTOR TABLE
         USING TSVT,R7
         STRING '  TSO/E LEVEL:  ',TSVTLVER,'.',TSVTLREL,'.',TSVTLMOD, X
               4X,(ZENVIR,8),INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
*
         MVC   WK256(2+2),=Y(1,80)             BLDL HDR
         MVC   WK256+4(8),=C'ADRRELVL'         EPNAME
         BLDL  0,WK256                 ISSUE BLDL
         LTR   R15,R15
         BNZ   DFDSS8                  NOT FOUND, JUMP
         LOAD  DE=WK256+4              LOAD ADRRELVL, IF PRESENT
         LR    R1,R0                   PASS EP ADDR
         STRING '  DF/DSS LEVEL: ',((R1),H,L),'.',(2(R1),FL1,L),'.', XXX
               (3(R1),FL1,L),INTO=LINE
         DELETE DE=WK256+4             I'M DONE WITH IT
         BAL   R14,SPACE2              BLANK LINE
.XPROD   ANOP              <38J>
*
DFDSS8   DS    0H
         ICM   R7,B'1111',CVTHSM       HSM VECTOR TABLE
         BZ    RACF00
         USING MQCT,R7
         CLI   MQCTID,C'Q'             CHECK CB ID
         BNE   RACF00
         STRING '  DF/HSM LEVEL: ',MQCTVER,'.',MQCTREL,'.',MQCTMOD,   XX
               INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
*
RACF00   ICM   R7,B'1111',CVTRAC       RACF VECTOR TABLE
         BZ    RACF99
         USING RCVT,R7
         IC    R0,RCVTVERS             X'04' MEANS 1.4
         LA    R1,X'00F0'              X'04' MEANS 1.4
         NR    R1,R0                   R1=VERSION#-1
         SRL   R1,004                  X'04' MEANS 1.4
         LA    R1,1(,R1)               X'04' MEANS 1.4
         LA    R2,X'000F'              X'04' MEANS 1.4
         NR    R2,R0                   R2=RELEASE#
         STRING '  RACF LEVEL:   ',((R1),,L),'.',((R2),,L),INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
RACF99   EQU   *
*
VTAM00   L     R8,PSAATCVT             ADDR OF VTAM CVT
         LTR   R8,R8
         BZ    VTAM99
*8       STRING '  VTAM LEVEL:   ',((R8),4),8X,((R8),,X),INTO=LINE
         STRING '  VTAM ACTIVE',INTO=LINE                         <38J>
         BAL   R14,SPACE2              BLANK LINE
VTAM99   DS    0H
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        IDENTIFY SORT BY ITS REAL NAME
*----------------------------------------------------------------------
SORT     P$BEGIN ,
         LOAD  EPLOC=SORTNAME,ERRET=NOSORT  LOAD SORT UTILITY     <38J>
         L     R9,TCBLLS               POINT TO LAST LLE IN CHAIN
         USING LLE,R9
*LOOP
SORT21   L     R6,LLECDPT              CDE PTR
         USING CDENTRY,R6
         CLC   SORTNAME,CDNAME         IS IT SORT'S LLE?
         BE    SORT33                  YES, JUMP
         ICM   R9,B'1111',LLECHN       CHECK FOR END OF CHAIN
         BNZ   SORT21                  LOOP THROUGH LOAD LIST
*ENDLOOP
         B     SORT99                  SOMETHING'S WRONG HERE
SORTNAME DC    CL8'SORT'               NAME OF SORT PGM (ANY SORT)
ICEMAN   DC    CL8'ICEMAN'             NAME OF SORT PGM (DFSORT)
SORT33   TM    CDATTR,CDMIN            IS THIS A MINOR CDE?
         BNO   SORT36                  NO, JUMP
         L     R6,CDXLMJP              YES, POINT TO MAJOR CDE/LPDE
SORT36   DS    0H
         STRING '  SORT''S TRUE NAME IS ',CDNAME,INTO=LINE
         CLC   SORTNAME,CDNAME         IS SORT'S NAME "SORT"?
         BNE   SORT98                  NO, QUIT
* IF SORT'S TRUE NAME IS "SORT", DISPLAY THE FIRST 256 BYTES
* OF THE LOAD-MODULE TO HELP WITH ITS IDENTIFICATION.
*8       L     R7,LPDEXTAD-LPDE(,R6)   LOAD POINT ADDRESS (IF LPDE)
*8       TM    CDATTRB,CDELPDE         IS THIS A LPDE?
*8       BO    SORT42                  YES, JUMP
         L     R7,CDXLMJP              POINT TO XTLST
*        L     R7,XTLMSBAD-XTLST(R7)   LOAD POINT     2004-12-n9gtm
         L     R7,XTLMSBAA-XTLST(R7)   LOAD POINT     2004-12-n9gtm
SORT42   DS    0H
         STRING (LINE,,T),'   (FIRST 256 BYTES FOLLOW)',INTO=LINE
         LA    R9,NEXTLINE+1000        POINT TO WORKING STORAGE
         MVC   0(256,R9),0(R7)         MOVE TO WORKING STORAGE
         BAL   R14,NONPRINT            BUILD TRANSLATE TABLE
         TR    0(256,R9),WK256         GET RID OF NON-PRINTABLE CHARS
         BAL   R14,SPACE2              BLANK LINE
         STRING 8X,(000(R9),64),INTO=LINE
         LA    R10,NEXTLINE
         STRING 8X,(064(R9),64),INTO=LINE
         LA    R10,NEXTLINE
         STRING 8X,(128(R9),64),INTO=LINE
         LA    R10,NEXTLINE
         STRING 8X,(192(R9),64),INTO=LINE
         B     SORT98
*
NOSORT   DS    0H
         STRING '  SORT NOT FOUND IN LINKLIST',INTO=LINE
*
SORT98   BAL   R14,SPACE2              BLANK LINE
SORT99   DELETE EPLOC=SORTNAME         NOW GET RID OF IT
         P$END
         DROP  R6,R9                   CDENTRY,LLE
         EJECT
*----------------------------------------------------------------------
*        UCB TABLE
*----------------------------------------------------------------------
DEVICES  P$BEGIN ,
         STRING 'ON-LINE DEVICES:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         STRING '  CUU  UCBTYP    UNITNAME  VOLSER  STATUS',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         XC    WK256(100),WK256        CLEAR WORK AREA
         MVC   WK256(4),CVTILK2        @ 1ST UCB HWORD PTR   <38J>
*LOOP
DEV_GET  DS    0H                                            <38J>
*                                                            <38J>
*8V_GET  LA    R14,WK256               WORK AREA FOR UCB SCAN RTN.
*8       LA    R15,CVTPTR              POINT TO X'00' IF CLASS=ALL
*8       LA    R0,TENWORDS+12          RETURNED UCB ADDRESS
*8       STM   R14,R0,TENWORDS         BUILD PARM LIST
*8       OI    TENWORDS+8,X'80'        MARK END OF LIST
*8       LA    R1,TENWORDS             PARAMETER LIST
*8       L     R15,CVTUCBSC            UCB SCAN ROUTINE
*8       BALR  R14,R15                 CALL THE UCBSCAN ROUTINE
*8       LTR   R15,R15
*8       BNZ   DEV_EOD
*8       L     R5,TENWORDS+12          LOAD R1 WITH ADDRESS OF UCB
*                                                             <38J>
         L     R14,WK256               @ UCB OR END-OF-TABLE  <38J>
         CLC   =X'FFFF',0(R14)         END OF UCB LOOKUP TBL? <38J>
         BE    DEV_EOD                 YES, BR                <38J>
         SLR   R5,R5                                          <38J>
         ICM   R5,3,0(R14)             @ UCB                  <38J>
         LA    R14,2(,R14)             @ NEXT UCB PTR         <38J>
         ST    R14,WK256               FOR NEXT TIME          <38J>
*                                                             <38J>
         TM    UCBSTAT,UCBONLI         ONLINE UNITS ONLY
         BNO   DEV_GET
*
         MVC   VOLMOUNT,BLANKS
         MVC   UNITNAME+8(4),UCBTYP    DEVICE TYPE
         BAL   R14,GETUNIT             GET UNITNAME
DEV_VOL  LA    R1,BLANKS               NO VOLSER UNLESS TAPE/DASD
         CLI   UCBTBYT3,UCB3TAPE       TAPE?
         BE    DEV_VOL2                YES, JUMP
         CLI   UCBTBYT3,UCB3DACC       DASD?
         BNE   DEV_PUN                 NO, JUMP
DEV_VOL2 CLI   UCBVOLI,C' '            VALID VOLSER?
         BNH   DEV_PUN                 NO, JUMP
         LA    R1,UCBVOLI              VOLSER FOR TAPE/DASD
         CLI   UCBTBYT3,UCB3DACC       DASD?
         BNE   DEV_PUN                 NO, JUMP
*8       MVC   VOLMOUNT(3),=C'SMS'     YES, SHOW IT
*8       TM    UCBFL5,UCBSMS           SMS VOL?
*8       BO    DEV_PUN                 YES, JUMP
         MVC   VOLMOUNT,=C'PRIVATE'    USE=PRIVATE
         TM    UCBSTAB,UCBBPRV         CHECK USE
         BO    DEV_PUN
         MVC   VOLMOUNT,=C'PUBLIC '    USE=PUBLIC
         TM    UCBSTAB,UCBBPUB         CHECK USE
         BO    DEV_PUN
         MVC   VOLMOUNT,=C'STORAGE'    USE=STORAGE
DEV_PUN  DS    0H
         STRING 2X,UCBNAME,2X,(UCBTYP,4,X),2X,UNITNAME,2X,((R1),6),  XXX
               2X,VOLMOUNT,INTO=LINE
         LA    R10,NEXTLINE
         B     DEV_GET
*ENDLOOP
DEV_EOD  BAL   R14,SPACE1              BLANK LINE
         P$END                         UCB
         DROP  R5                      UCB
         EJECT ,
*----------------------------------------------------------------------
*        SUB-SYSTEMS AND FUNCTIONS PROCESSED
*----------------------------------------------------------------------
SUBSYSTM P$BEGIN ,
         STRING 'SUB-SYSTEM VECTOR TABLE:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R1,CVTJESCT             JES COMM TABLE
         L     R5,JESSSCT-JESCT(,R1)   FIRST JSCVT
         USING SSCT,R5
*LOOP
SUBSYS22 MVC   NEXTLINE,BLANKS
         ICM   R6,15,SSCTSSVT          SUB-SYSTEM VECTOR TABLE
         BZ    SUBSYS70                INACTIVE SUB-SYSTEM
         USING SSVT,R6
         SLR   R1,R1                   FIRST FUNCTION CODE
         LA    R2,256                  MAX NUMBER OF FUNCTIONS
*--LOOP
SUBSYS30 LA    R14,SSVTFCOD(R1)        FUNCTION BYTE
         LA    R1,1(,R1)               NEXT FUNCTION CODE
         CLI   0(R14),0
         BE    SUBSYS35
         STRING (NEXTLINE,,T),1X,((R1),,L0),INTO=NEXTLINE
SUBSYS35 BCT   R2,SUBSYS30
*--ENDLOOP
SUBSYS70 DS    0H
         STRING 2X,SSCTSNAM,1X,(SSCTSSVT,,X),NEXTLINE,INTO=LINE
         LA    R10,NEXTLINE
         ICM   R5,15,4(R5)             NEXT SSCVT
         BNZ   SUBSYS22
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        ACTIVE LPA Q
*----------------------------------------------------------------------
LPACTIV  P$BEGIN ,
         L     R5,CVTQLPAQ             ACTIVE LPA QUEUE
         ICM   R5,B'1111',0(R5)        FIRST LPDE ON QUEUE
         BZ    LPACT99                 EMPTY QUEUE, SKIP SEARCH
*
         USING LPDE,R5
         STRING 'ACTIVE LPA QUEUE:',INTO=LINE
         BAL   R14,SPACE2
         STRING 9X,'@LPDE   ',                                         +
               1X,'LPDECHN ',                                          +
               1X,'LPDERBP ',                                          +
               1X,'LPDENAME',                                          +
               1X,'LPDENTP ',                                          +
               1X,'LPDEXLP ',                                          +
               1X,'USE ',                                              +
               1X,'AT',                                                +
               1X,'A2',                                                +
               1X,'LPDEXTLN',                                          +
               1X,'LPDEXTAD',                                          +
               1X,'MAJORNAM',                                          +
               INTO=LINE
         BAL   R14,SPACE2
*
*
LPACT11  TM    LPDEATTR,LPDEMIN        MINOR LPDE?
         BO    LPACT12                 YES, JUMP
*
         STRING ' MAJLPDE',                                            +
               1X,((R5),,X),                                           +
               1X,(LPDECHN,,X),                                        +
               1X,(LPDERBP,,X),                                        +
               1X,LPDENAME,                                            +
               1X,(LPDENTP,,X),                                        +
               1X,(LPDEXLP,,X),                                        +
               1X,(LPDEUSE,,X),                                        +
               1X,(LPDEATTR,,X),                                       +
               1X,(LPDEATT2,,X),                                       +
               1X,(LPDEXTLN,,X),                                       +
               1X,(LPDEXTAD,,X),                                       +
               1X,(LPDENAME-LPDE(R5),8),                               +
               INTO=LINE
         B     LPACT14
*
LPACT12  DS    0H                      MINOR LPDE
         ICM   R2,15,LPDEXLP           @ ASSOCIATED MAJOR LPDE
         BZ    LPACT14
         STRING ' MINLPDE',                                            +
               1X,((R5),,X),                                           +
               1X,(LPDECHN,,X),                                        +
               1X,(LPDERBP,,X),                                        +
               1X,LPDENAME,                                            +
               1X,(LPDENTP,,X),                                        +
               1X,(LPDEXLP,,X),                                        +
               1X,(LPDEUSE,,X),                                        +
               1X,(LPDEATTR,,X),                                       +
               1X,(LPDEATT2,,X),                                       +
               1X,(LPDEXTLN,,X),                                       +
               1X,(LPDEXTAD,,X),                                       +
               1X,(LPDENAME-LPDE(R2),8),                               +
               INTO=LINE
*
LPACT14  DS    0H
         LA    R10,NEXTLINE
         ICM   R5,B'1111',LPDECHN      NEXT LPDE ADDR
         BNZ   LPACT11                 NO FINISHED YET, LOOP
*
LPACT99  DS    0H
         BAL   R14,SPACE2
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        SVC TABLE
*----------------------------------------------------------------------
SVCTABLE P$BEGIN ,
         STRING 'SVC TABLE:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R5,CVTABEND             SECONDARY CVT
         USING SCVTSECT,R5
         LA    R1,088*8                MULT BY 8 (LEN OF SVC ENTRY)
         A     R1,SCVTSVCT             CHANGE OFFSET TO ADDRESS
         MVC   SVC88,0(R1)             SAVE FOR LATER
         L     R5,SCVTSVCT             SVC TABLE
         LA    R8,00256/2
         OI    K1+L'K1-1,15            INIT PACKED CTR
*LOOP
SVCTAB3  ZAP   K2,K1
         AP    K2,=P'1'
         L     R1,0(,R5)               SVC EP ADDR
         BAL   R14,CSVQUERY            GET EP NAME
         MVC   EP1,EP2                 PASS EP NAME
         L     R1,8(,R5)               SVC EP ADDR
         BAL   R14,CSVQUERY            GET EP NAME
         STRING (K1,P),2X,(0(R5),4,X),2X,(4(R5),4,X),1X,EP1,       XXXXX
               (K2,P),2X,(8(R5),4,X),2X,(12(R5),4,X),1X,EP2,INTO=LINE
         LA    R10,NEXTLINE
         AP    K1,=P'2'
         LA    R5,8+8(,R5)
         BCT   R8,SVCTAB3
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        LIST LNKLSTXX LIBRARIES
*----------------------------------------------------------------------
LINKLIST P$BEGIN ,
         L     R6,CVTLINK              SYS1.LINKLIB DCB
         ICM   R6,B'0111',DCBDEBA-IHADCB(R6) DEB ADDRESS
         LA    R1,=C'LNKAUTH=LNKLST'
         TM    DEBFLGS1-DEBBASIC(R6),DEBAPFIN    AUTH=YES?
         BO    *+8                     YES, JUMP
         LA    R1,=C'LNKAUTH=APFTAB'
         AGO   .XLNKL                                 <38J>
         L     R7,CVTLLTA              LINK LIST TABLE
         USING LLT,R7
         STRING 'LINK-LIST: ',(CVTLLTA,,X),                            X
               (LLTNO,F,R9B),' ENTRIES',6X,((R1),14),INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R8,LLTNO                # OF ENTRIES
         LA    R9,LLTENTRY             LINK LIST TABLE ENTRY
         USING LLTENTRY,R9
*LOOP
LNKLST41 MVC   LINE,BLANKS
         MVC   DSNAME,LLTDSNAM         MOVE DSNAME TO UNPROTECTED STRGE
         MVI   VOLSER,C'?'             $LOCATE REQUIRED
         MVI   YYMMDD,C'?'             $OBTAIN REQUIRED
         MVI   CATUNCAT,C'-'           APF-LIST SCAN REQUIRED
         LA    R10,NEXTLINE
         LA    R9,LLTNEXT              NEXT ENTRY
         BCT   R8,LNKLST41
         DROP  R7,R9                       <38J>
.XLNKL   ANOP                              <38J>
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        LIST LPALSTXX LIBRARIES
*----------------------------------------------------------------------
LPALIST  P$BEGIN ,
         AGO   .XLPAL                            <38J>
         TM    CVTDCB,CVTMVSE          XA/ESA?
         BZ    LPALST99                NO, JUMP
         L     R1,CVTSMEXT             STORAGE MAP EXTENSION
         L     R7,CVTEPLPS-CVTVSTGX(,R1)  LPA TABLE
         USING LLT,R7                                <38J>
         STRING 'LPA-LIST: ',((R7),,X),                                X
               (LLTNO,F,R9B),' ENTRIES.',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R8,LLTNO                # OF ENTRIES
         LA    R9,LLTENTRY-LLT(,R7)    FIRST LPA LIST TABLE ENTRY
         USING LLTENTRY,R9                          <38J>
*LOOP
LPALST42 MVC   LINE,BLANKS
         MVC   DSNAME,LLTDSNAM         MOVE DSNAME TO UNPROTECTED STRGE
         MVI   VOLSER,C'?'             $LOCATE REQUIRED
         MVI   YYMMDD,C'?'             $OBTAIN REQUIRED
         LA    R10,NEXTLINE
         LA    R9,LLTNEXT              NEXT ENTRY
         BCT   R8,LPALST42
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         DROP  R7,R9                   LLT,LLTENTRY <38J>
.XLPAL   ANOP                                       <38J>
LPALST99 P$END
         EJECT ,
*----------------------------------------------------------------------
*        LIST AUTHORIZED LIBRARIES
*----------------------------------------------------------------------
APFLIST  P$BEGIN ,
         L     R7,CVTAUTHL             APF TABLE
         LH    R8,0(,R7)               # OF ENTRIES
         STRING 'APF-LIST: ',(CVTAUTHL,,X),                            X
               ((R8),,R9B),' ENTRIES.',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         ST    R10,APFTABLE            SAVE ADDR OF 1ST LINE
*LOOP
APFLIST3 MVC   LINE,BLANKS
         SLR   R1,R1
         IC    R1,2(,R7)
         SH    R1,=H'6'                VOLSER LENGTH
         STRING (9(R7),(R1)),INTO=DSNAME MOVE DSNAME
         MVC   VOLSER,3(R7)            MOVE VOLSER
         MVI   YYMMDD,C'?'             $OBTAIN REQUIRED
         MVI   CATUNCAT,C'?'           $LOCATE REQUIRED
         LA    R10,NEXTLINE
         LA    R7,7(R1,R7)             NEXT ENTRY
         BCT   R8,APFLIST3
*ENDLOOP
         EJECT ,
*----------------------------------------------------------------------
*------- TRI DE LA TABLE APF-LIST -------------------------------------
*----------------------------------------------------------------------
         LA    R0,L'LINE               LONGUEUR D'UN POSTE
         LR    R1,R10                  A(NEXTLINE)
         SLR   R1,R0                   DERNIER POSTE DE LA TABLE
         STM   R0,R1,APFTABLE+4        LONGUEUR, DERNIER POSTE
*LOOP
TRIZO    MVI   0(R13),0                ETAT INITIAL DE L'INDICATEUR
         L     R15,APFTABLE            DEBUT DE LA TABLE  N=1
         USING LINE,R15
         SLR   R1,R0                   LE DERNIER POSTE EST TRIE
*--LOOP
TRIZOC   CLC   DSNAME,DSNAME+L'LINE    (POSTE N) GT (POSTE N+1) ?
         BNH   TRIZOH                  SI NON, BRANCH
         XC    LINE,NEXTLINE           SI (POSTE N+1) LT (POSTE N)
         XC    NEXTLINE,LINE            RENVERSER LES
         XC    LINE,NEXTLINE             DEUX POSTES.
         MVI   0(R13),8                NOTER LE DECLASSEMENT
TRIZOH   BXLE  R15,R0,TRIZOC           FAIRE N=N+1
*--ENDLOOP
TRIZON   CLI   0(R13),0                Y-A-T-IL EU UN DECLASSEMENT ?
         BNE   TRIZO                   SI OUI, REFAIRE UN PASSAGE
*ENDLOOP
         DROP  R15                     LINE
         BAL   R14,SPACE1              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        SCAN TIOT
*----------------------------------------------------------------------
SCANTIOT P$BEGIN ,
         AGO   .XSCTIOT                                <38J>
         STRING 'TIOT:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R5,TCBTIO               TIOT
         USING TIOT1,R5
         L     R6,PSAAOLD-PSA          MY ASCB
         L     R6,ASCBOUCB-ASCB(,R6)   MY OUCB
         USING OUCB,R6
         STRING '  JOBNAME: ',TIOCNJOB,'  STEP: ',(TIOCSTEP+0,8),     XX
               '  PROCSTEP: ',(TIOCSTEP+8,8),                         XX
               '  PERFORM=',(OUCBNPG,H,L),                            XX
               INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         GETMAIN R,LV=DYN24L           GET WORK AREA
         LR    R8,R1                   PASS ADDRESS
         USING IHADCB,R8
         XC    IHADCB(DYN24L),IHADCB
         MVI   DCBOFLGS,X'02'          DCB AVAILABLE
         MVI   DCBMACR1,X'D0'          MACRF=E
         MVI   DCBMACR2,X'08'          MACRF=E
         MVC   ARLLEN,=Y(ARLEND-ARLLEN)  LENGTH OF ARL
         MVC   ARLIDENT,=C'AR'         BLOCK ID
         ST    R8,OPENLIST             OPENL
         MVI   OPENLIST,X'80'          OPENL
         LA    R0,ARL                  WORK AREA
         LA    R1,OPENLIST+4           WORK AREA
         ST    R0,0(,R1)               BUILD DCB EXIT LIST
         MVI   0(R1),X'93'             ARL REQUEST
         ST    R1,DCBEXLST             STORE INTO DCB
*LOOP
TIOT_GET CLI   TIOEDDNM,C' '           GOOD DDNAME?
         BNH   TIOT_NXT                NO, NEXT ENTRY
         MVC   DCBDDNAM,TIOEDDNM       MOVE DDNAME
         RDJFCB MF=(E,OPENLIST)        BUILD AN ARL
         LTR   R15,R15                 RDJFCB WENT OK?
         BNZ   TIOT_NXT                NO, NEXT ENTRY
         LH    R2,ARLRTRVD             DATA SET COUNT
         L     R6,ARLAREA              GET ADDR OF AREA
         USING JFCBDSNM-4,R6
         SLR   R1,R1                   FIRST ENTRY
*--LOOP
TIOT_PUN ALR   R5,R1                   BUMP TIOT ENTRY ADDR
         MVC   VOLMOUNT,BLANKS
         SLR   R1,R1                   EXCP=0
         SLR   R9,R9                   PREPARE ICM
         ICM   R9,B'0111',TIOEFSRT     UCB ADDRESS
         BZ    TIOT_P4                 NO UCB, SKIP TCT SCAN
         USING UCBOB,R9
         MVC   UNITNAME+8(4),UCBTYP    DEVICE TYPE
         BAL   R14,GETUNIT             GET UNITNAME
TIOT_TCT LA    R1,TIOENTRY             POINT TO CURRENT TIOT ENTRY
         SL    R1,TCBTIO               CHANGE ADDRESS TO OFFSET
*
         L     R14,TCBTCT              TCBTCT
         USING SMFTCT,R14              TCBTCT
         L     R15,TCTIOTBL            START OF I/O MEASUREMENT TABLE
         LA    R15,TCTIODSP-TCTTIOT(,R15)  FIRST DD ENTRY
         USING TCTDCBTD,R15
*----LOOP
@TCT11   CL    R1,TCTDCBTD             SAME TIOT OFFSET?
         BE    @TCT21                  YES, EXIT LOOP
         LA    R15,TCTDCBLE            NEXT LOOKUP TABLE ENTRY
         ICM   R0,B'1111',TCTDCBLE     END OF TABLE ?
         BNZ   @TCT11                  NOT YET, TRY NEXT DD ENTRY
*----ENDLOOP
         SLR   R1,R1                   NOT FOUND, EXCP COUNT IS ZERO
         B     @TCT29
@TCT21   L     R1,TCTIOTSD             OFFSET IN I/O MEASURE. TABLE
         A     R1,TCTIOTBL             =A(TCTTIOT)
         L     R1,TCTDCTR-TCTDDENT(,R1) EXCP COUNT
         DROP  R14,R15                 TCT
*
@TCT29   TM    UCBFL5,UCBSMS           SMS VOL?     X'20'
         BZ    TIOT_P4                 NO, JUMP
         MVC   VOLMOUNT(3),=C'SMS'     YES, SHOW IT
TIOT_P4  LTR   R9,R9                   VALID UCB?
         BNZ   TIOT_P6                 YES, JUMP
         LA    R9,BLANKS               NO, USE DUMMY
TIOT_P6  DS    0H
         STRING 2X,TIOEDDNM,1X,JFCBDSNM,1X,(JFCBVOLS,6),1X,UNITNAME,   X
               1X,((R1)),1X,UCBNAME,1X,VOLMOUNT,INTO=LINE
         LA    R10,NEXTLINE
         AH    R6,0(,R6)               BUMP UP TO NEXT ENTRY
         SLR   R1,R1                   PREPARE IC
         IC    R1,TIOELNGH             LOAD LENGTH OF CURRENT ENTRY
         BCT   R2,TIOT_PUN             LOOP UNTIL LAST DSN PRINTED
*--ENDLOOP
         SLR   R0,R0
         ICM   R0,B'0111',ARLRLEN      LENGTH OF RETRIEVAL AREA
         L     R1,ARLAREA              ADDRESS OF AREA
         FREEMAIN R,LV=(0),A=(1)       FREE ALLOC RETR AREA
TIOT_NXT SLR   R1,R1                   PREPARE IC
         ICM   R1,B'0001',TIOELNGH     LOAD/TEST LNGTH OF CURRENT ENTRY
         LA    R5,0(R1,R5)             BUMP UP TO NEXT ENTRY
         BNZ   TIOT_GET                LOOP THROUGH TIOT
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         FREEMAIN R,LV=DYN24L,A=(R8)
*8       DROP  R6,R9,R8                JFCB, UCB, IHADCB
         DROP  R6                                 <38J>
         DROP  R9                                 <38J>
         DROP  R8                                 <38J>
.XSCTIOT ANOP                                     <38J>
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        DISPLAY TCB TREE AND RB CHAINS
*----------------------------------------------------------------------
TCB_TREE P$BEGIN
         L     R4,JSTCB                THE JOB STEP TCB
         STRING 'TCB TREE AND RB CHAINS:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         STRING 4X,'TCB ADDRESS',19X,INTO=LINE,                        X
               'PROGRAM     IC    STAB  CDFLGS    DDNAME'
         BAL   R14,SPACE2              BLANK LINE
         SLR   R3,R3                   INDENTATION INDEX
*LOOP
TREE100  STCM  R4,B'0111',DWD          STORE TCB ADDR
         STRING (BLANKS,4(R3)),(DWD,3,X),INTO=LINE
         L     R5,TCBRBP               POINT TO TOP RB
         LA    R9,WK256                START OF RB TABLE
*
*        BUILD RB TABLE
*--LOOP
TREE110  ICM   R5,B'1000',CVTPTR       CLEAN UP HI-ORDER BYTE
         SH    R5,=Y(RBBASIC-RBPREFIX) POINT TO RBPREFIX
         USING RBPREFIX,R5
         ST    R5,0(,R9)               STORE RB ADDRESS
         TM    RBSTAB2,RBTCBNXT        CHECK FOR END OF CHAIN
         L     R5,RBLINK               POINT TO PREVIOUS RB (OR TCB)
         LA    R9,4(,R9)               BUMP UP TO NEXT TABLE ENTRY
         BZ    TREE110                 JUMP IF RB FOR 1ST ATTACHED PGM
*--ENDLOOP
*
*        PROCESS RB TABLE BACKWARDS
*--LOOP
TREE200  SH    R9,=H'4'                PREVIOUS ENTRY IN RB TABLE
         L     R5,0(,R9)               LOAD RB ADDRESS
         CLI   RBSTAB1,RBFTPRB         IS THIS A PRB?
         BNE   TREE280                 NO, IGNORE IT
         TM    RBCDFLGS,RBCDSYNC       CHECK FLAGS
         BO    TREE260                 JUMP IF IT IS A SYNCH PRB
         L     R1,RBCDE                POINT TO CDE/LPDE
         STRING INTO=(LINE+30,L'LINE),4X,                             XX
               (CDNAME-CDENTRY(R1),8),4X,      PGM NAME               XX
               (RBINTCOD,2,X),4X,      INTERRUPT CODE <38J>           XX
               (RBSTAB,2,X),4X,        STATUS BYTE                    XX
               (RBCDFLGS,,X)           FLAGS
*8             (RBWLIC+3,1,X),         IC
         B     TREE270
TREE260  MVC   DWD,RBGRS15             PICK UP ENTRY POINT ADDRESS
         NI    DWD+3,X'FE'             SET BIT 31 TO ZERO
         STRING INTO=(LINE+30,L'LINE),4X,                             XX
               (DWD,4,X),4X,           EP ADDRESS                     XX
               (RBINTCOD,2,X),4X,      INTERRUPT CODE <38J>           XX
               (RBSTAB,2,X),4X,                                       XX
               (RBCDFLGS,,X)
*8             (RBWLIC+3,1,X),
*
TREE270  LA    R10,NEXTLINE            NEXT LINE
TREE280  LA    R0,WK256                CHECK FOR END OF CHAIN
         CR    R9,R0                   CHECK FOR END OF CHAIN
         BH    TREE200                 LOOP THROUGH RB TABLE
*--ENDLOOP
         BAL   R14,SCANTCB             GET NEXT TCB
         BNZ   TREE100                 PROCESS NEXT TCB
*ENDLOOP
         BAL   R14,SPACE1              BLANK LINE
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        DISPLAY JPAQ (CDE CHAIN)
*----------------------------------------------------------------------
JPAQ     P$BEGIN ,
         L     R4,JSTCB                THE JOB STEP TCB
         STRING 'JPAQ:',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
         L     R5,TCBJPQ               POINT TO FIRST CDE IN CHAIN
         USING CDENTRY,R5
         STRING '   NAME     ENTPT     USE ',                          X
               ' ATTRB SP ATTR ATTR2',                                 X
               '  MAJ-CDE    LENGTH   LOAD-PNT',INTO=LINE
         BAL   R14,SPACE2              BLANK LINE
*LOOP
JPAQ21   L     R6,CDXLMJP              POINT TO XL (OR MAJOR CDE)
         TM    CDATTR,CDMIN            CHECK ATTRIBUTES
         BO    JPAQ25                  JUMP IF THIS IS A MINOR CDE
         USING XTLST,R6
         STRING 3X,CDNAME,1X,(CDENTPT,,X),2X,(CDUSE,,X),3X,            X
               (CDATTRB,,X),2X,(CDATTR,,X),4X,           <38J>         X
               (CDATTR2,,X),14X,(XTLMSBLN,,X),3X,(XTLMSBAD,,X),        X
               INTO=LINE
*8             (CDSP,,X)
         B     JPAQ29
JPAQ25   DS    0H
         STRING 3X,CDNAME,1X,(CDENTPT,,X),9X,(CDATTRB,,X),6X,          X
               (CDATTR,,X),4X,(CDATTR2,,X),3X,(CDNAME-CDENTRY(R6),8),  X
               INTO=LINE
JPAQ29   LA    R10,NEXTLINE            NEXT LINE
         ICM   R5,B'1111',CDCHAIN      CHECK FOR END OF CHAIN
         BNZ   JPAQ21                  LOOP THROUGH RB TABLE
*ENDLOOP
         DROP  R5,R6                   CDE, XTLST
         BAL   R14,SPACE1              BLANK LINE
         P$END
         DROP  R3                      CVT
         EJECT ,
*----------------------------------------------------------------------
*        DISPLAY LOAD-LISTS
*----------------------------------------------------------------------
LOADLIST P$BEGIN
         L     R4,JSTCB                THE JOB STEP TCB
         STRING 'LOAD-LIST:',INTO=LINE
         LA    R10,NEXTLINE
         SLR   R3,R3                   INDENTATION INDEX
*LOOP
LOADL11  ICM   R9,B'1111',TCBLLS       POINT TO LAST LLE IN CHAIN
         BZ    LOADL80                 SKIP THIS TCB IF NO LLE CHAIN
         USING LLE,R9
*
         BAL   R14,SPACE1              BLANK LINE
         STCM  R4,B'0111',DWD          STORE TCB ADDR
         L     R5,TCBRBP               TOP RB
         USING RBBASIC,R5
         TM    RBCDFLGS,RBCDSYNC       CHECK FLAGS
         BNO   *+8                     JUMP IF IT IS NOT A SYNCH PRB
         ICM   R5,B'0111',RBLINK+1     POINT TO PREVIOUS RB IF SYNCH RB
         L     R5,RBCDE                POINT TO CDE/LPDE
         USING CDENTRY,R5
         STRING '  TCB ',(DWD,3,X),'  PGM ',CDNAME,INTO=LINE
         LA    R10,NEXTLINE
*--LOOP
LOADL70  STCM  R9,B'0111',DWD          STORE LLE ADDR
         L     R5,LLECDPT              CDE PTR
         STRING '    LLE ',(DWD,3,X),2X,CDNAME,2X,(CDENTPT,,X),2X,    XX
               (LLECOUNT,,X),1X,(LLESYSCT,,X),INTO=LINE
         LA    R10,NEXTLINE
         ICM   R9,B'1111',LLECHN       CHECK FOR END OF CHAIN
         BNZ   LOADL70                 LOOP THROUGH LOAD LIST
*--ENDLOOP
LOADL80  BAL   R14,SCANTCB             NEXT TCB IN TREE
         BNZ   LOADL11
*ENDLOOP
         BAL   R14,SPACE1                                         <38J>
         P$END
         EJECT ,
*----------------------------------------------------------------------
*        CLOSE SYSPRINT                                           <38J>
*----------------------------------------------------------------------
CLOSE    P$BEGIN
         STRING 'DONE',INTO=LINE
         BAL   R14,SPACE2
         TM    DY8DCB+(DCBOFLGS-IHADCB),DCBOFOPN OPENED?
         BNO   CLOSE99
         MVC   DY8CLOSE(L$CLOSE),MODLCLOS        COPY CLOSE
         CLOSE DY8DCB,MF=(E,DY8CLOSE)            CLOSE SYSPRINT
CLOSE99  P$END
         EJECT ,
*----------------------------------------------------------------------
*        INVOKE ISPF/PDF "BRIF" SERVICE
*----------------------------------------------------------------------
BRIF     P$BEGIN
*8       DELETE EP=IEFEB4UV            NO LONGER NEEDED
*
*        ATTACH THE LOCATE/OBTAIN SUB-TASK
*
         L     R1,=A(SUBTASK)
         IDENTIFY EP=SUB_TASK,ENTRY=(1)
         LA    R1,DYN                  PARM FOR THE SUBTASK
         ATTACH  EP=SUB_TASK,ECB=ECB1,SF=(E,ATTACHL)
         ST    R1,ECB1+4               KEEP TCB ADDRESS
*
BRIF200  LA    R0,LINES                FIRST LINE
         LR    R1,R10                  LAST LINE
         SR    R1,R0                   SIZE
         SR    R0,R0
         D     R0,=A(L'LINES)          NUMBER OF LINES
         ST    R1,NUMLINES             FOR BRIF
*
         ST    R13,DYN                 DIALOG DATA PTR: A(DYN)
         LA    R14,=C'BRIF '           FUNCTION NAME
         LA    R15,TITLE               DSNAME (TITLE)
         LA    R0,=C'F '               RECFM
         LA    R1,=A(L'LINES)          LENGTH
         LA    R2,=A(RDRTNE)           READ ROUTINE
         SLR   R3,R3                   COMMAND ROUTINE
         LA    R4,DYN                  PARM FOR READ ROUTINE
         STM   R14,R4,ATTACHL
         OI    ATTACHL+24,X'80'        END-OF-LIST FLAG
*
         LA    R1,ATTACHL              PARM LIST ADDRESS
         L     R15,ISPLINK             LOAD INTERFACE ADDRESS
         BALR  R14,R15             <== INVOKE "BRIF" SERVICE
*
         CLI   ECB1+4,X'FF'            DETACHED ALREADY?
         BE    BRIF99                  YES, JUMP
         DETACH ECB1+4                 DETACH SUBTASK
BRIF99   P$END
         EJECT ,
*----------------------------------------------------------------------
*----------------------------------------------------------------------
$LTORG   LOCTR ,                       SUBRTNS CALLED BY P$BEGIN RTNS
*----------------------------------------------------------------------
*----------------------------------------------------------------------
TITLE    DC    C'SHOWMVS',X'00',C'PROGRAM',X'00',C'&VERMOD '
         SPACE 2
*----------------------------------------------------------------------
*        SCAN LPA QUEUES TO LOCATE EPNAME FOR ADDR IN (R1)
*----------------------------------------------------------------------
CSVQUERY MVC   EP2,BLANKS              CLEAR OUTPUT AREA
         AGO   .XCSVQ             <38J>
         CL    R1,SVC88                THIS SVC USED?
         BE    CSVQRY88                NO, GOBACK
         LA    R1,0(,R1)               CLEAN-UP AMODE BIT
         USING CVTMAP,R3
*
*        SCAN ACTIVE LPA QUEUE (MLPA/FLPA)
*
         L     R2,CVTQLPAQ             ACTIVE LPA QUEUE
         ICM   R2,B'1111',0(R2)        FIRST LPDE ON QUEUE
         BZ    CSVQRY20                EMPTY QUEUE, SKIP SEARCH
         USING LPDE,R2
         MVI   EP2,C'A'                ACTIVE LPA Q
*LOOP
CSVQRY11 L     R15,LPDENTP             ENTRY POINT
         LA    R15,0(,R15)             CLEAN UP AMODE BIT
         CR    R1,R15                  IS THIS MY ENTRY POINT?
         BE    CSVQRY82                MODULE FOUND, JUMP
         ICM   R2,B'1111',LPDECHN      NEXT LPDE ADDR
         BNZ   CSVQRY11                NO FINISHED YET, LOOP FURTHER
*ENDLOOP
*        SCAN PAGEABLE LPA QUEUE (PLPA)
*
CSVQRY20 L     R2,CVTLPDIA             FIRST LPDE
         USING LPDE,R2
         MVI   EP2,C'P'                PAGEABLE LPA Q
*LOOP
CSVQRY21 L     R15,LPDENTP             ENTRY POINT
         LA    R15,0(,R15)             CLEAN UP AMODE BIT
         CR    R1,R15                  IS THIS MY ENTRY POINT?
         BE    CSVQRY82                MODULE FOUND, JUMP
         TM    LPDEATTR,LPDEMIN        MINOR LPDE?
         BO    CSVQRY22                YES, IGNORE
         LM    R15,R0,LPDEXTLN         LENGTH/LOAD ADDR
         CR    R0,R1
         BH    CSVQRY22                OUTSIDE BOUNDARIES, JUMP
         AR    R0,R15
         CR    R0,R1
         BH    CSVQRY82                MODULE FOUND, JUMP
CSVQRY22 LA    R2,LPDEXTAD+4           BUMP LPDE ADDR
         CLI   LPDENAME,X'FF'          END OF LPA DIRECTORY?
         BNE   CSVQRY21                NO, LOOP FURTHER
*ENDLOOP
         MVC   EP2+2(4),=C'*NUC'       EP FOUND IN THE NUCLEUS
         MVI   EP2,C'N'                NUCLEUS
         L     R2,CVTSMEXT             STORAGE MAP EXTENSION
         USING CVTVSTGX,R2
         CL    R1,CVTRWNS              NUC?
         BL    CSVQRY61                NO, JUMP
         CL    R1,CVTERWNE             NUC?
         BLR   R14                     YES, GOBACK
*
CSVQRY61 MVC   EP2+2(5),=C'*FLPA'      EP FOUND IN FIXED LPA
         MVI   EP2,C'F'                FIXED LPAQ
         CL    R1,CVTFLPAS             FLPA (BELOW)
         BL    CSVQRY62                NO, JUMP
         CL    R1,CVTFLPAE             END OF FLPA (BELOW)
         BLR   R14                     YES, GOBACK
CSVQRY62 CL    R1,CVTEFLPS             FLPA (ABOVE)
         BL    CSVQRY63                NO, JUMP
         CL    R1,CVTEFLPE             END OF FLPA (ABOVE)
         BLR   R14                     YES, GOBACK
*
CSVQRY63 MVC   EP2+2(5),=C'*MLPA'      EP FOUND IN FIXED LPA
         MVI   EP2,C'F'                MODIFIED LPAQ
         CL    R1,CVTMLPAS             MLPA (BELOW)
         BL    CSVQRY64                NO, JUMP
         CL    R1,CVTMLPAE             END OF MLPA (BELOW)
         BLR   R14                     YES, GOBACK
CSVQRY64 CL    R1,CVTEMLPS             MLPA (ABOVE)
         BL    CSVQRY71                NO, JUMP
         CL    R1,CVTEMLPE             END OF MLPA (ABOVE)
         BLR   R14                     YES, GOBACK
*
CSVQRY71 L     R2,CVTGDA               POINT TO GDA
         USING GDA,R2
         MVC   EP2+2(5),=C'*CSA '      EP FOUND IN CSA
         MVI   EP2,C'C'                CSA
         L     R0,GDACSA               CSA (BELOW)
         CLR   R1,R0                   WITHIN CSA?
         BL    CSVQRY72                NO, JUMP
         AL    R0,GDACSASZ             END OF CSA (BELOW)
         CLR   R1,R0                   WITHIN CSA?
         BLR   R14                     YES, GOBACK
CSVQRY72 L     R0,GDAECSA              CSA (ABOVE)
         CLR   R1,R0                   WITHIN CSA?
         BL    CSVQRY73                NO, JUMP
         AL    R0,GDAECSAS             END OF CSA (ABOVE)
         CLR   R1,R0                   WITHIN CSA?
         BLR   R14                     YES, GOBACK
CSVQRY73 MVC   EP2,BLANKS              RETURN BLANK NAME
         BR    R14
*
         USING LPDE,R2
CSVQRY82 MVC   EP2+2(8),LPDENAME       PASS EP NAME
         BR    R14
         DROP  R2,R3                   LPDE, CVT
CSVQRY88 MVI   EP2,C'-'                SVC IS NOT IN SERVICE
.XCSVQ   ANOP                  <38J>
         BR    R14
         EJECT ,
*----------------------------------------------------------------------
*        CONVERT UCBTYP TO UNITNAME
*----------------------------------------------------------------------
GETUNIT  CLC   UNITNAME+12(4),UNITNAME+8   SAME DEVICE TYPE?
         BER   R14                     YES, UNITNAME IS OK ALREADY
         MVC   UNITNAME+12(4),UNITNAME+8   SAVE DEVICE TYPE
         ST    R14,DYN                 SAVE R14
         AGO   .XGUNT                  <38J>
         MVI   TENWORDS+20,X'01'       RETURN A LOOK-UP VALUE (BIT7)
         MVI   TENWORDS+21,X'00'       CLEAR UNUSED BYTE
         LA    R14,UNITNAME            UNITNAME+DEVTYPE
         LA    R15,TENWORDS+20         FLAGS
         STM   R14,R15,TENWORDS
         OI    TENWORDS+4,X'80'        END-OF-LIST FLAG
         LA    R1,TENWORDS             PARM LIST ADDRESS
         L     R15,IEFEB4UV            LOAD ROUTINE ADDRESS
         BALR  R14,R15                 GET UNIT NAME
         LTR   R15,R15
         BNZ   GETUNIT6                BAD RETURN CODE, QUIT
         MVI   TENWORDS+20,X'20'       RETURN A UNIT NAME (BIT2)
         LA    R1,TENWORDS             PARM LIST ADDRESS
         L     R15,IEFEB4UV            LOAD ROUTINE ADDRESS
         BALR  R14,R15                 GET UNIT NAME
         LTR   R15,R15
         BZ    GETUNIT9                GOOD RETURN CODE, GOBACK
.XGUNT   ANOP                          <38J>
GETUNIT6 MVC   UNITNAME,BLANKS         CONVERSION DID NOT WORK
GETUNIT9 L     R14,DYN                 RESTORE R14
         BR    R14
         EJECT ,
*----------------------------------------------------------------------
*        PRINT A BLANK LINE
*----------------------------------------------------------------------
SPACE2   LA    R10,NEXTLINE
SPACE1   MVC   LINE,BLANKS
         LA    R10,NEXTLINE
*----------------------------------------------------------------------
*  SHOWOUT - OUTPUT LINES THAT "STRING" HAS PRODUCED SO FAR       <38J>
*            USE QSAM "PUT" RATHER THAN ISPF "BRIF"
*----------------------------------------------------------------------
SHOWOUT  DS    0H
         PUSH  USING
         STM   R0,R15,DY8OUT           FREE UP SOME REGS
         BALR  R12,0
         USING *,R12
         LR    R8,R13                  SAVE DYN PTR
         USING DYN,R8
         LA    R9,DY8DCB               @ DCB
         USING IHADCB,R9
         DROP  R13                     DON'T CONFUSE ASSEMBLER
         LA    R13,DY8SA               GIVE PUT A TEMP SAVEAREA
*
         TM    DCBOFLGS,DCBOFOPN       DCB ALREADY OPENED?
         BO    OUTOPEN
*
         MVC   DY8DCB(L$DCB),DCBPRINT            COPY DCB
         MVC   DY8OPEN(L$OPEN),MODLOPEN          COPY OPEN
         OPEN  ((R9),(OUTPUT)),MF=(E,DY8OPEN)    OPEN SYSPRINT OUTPUT
         TM    DCBOFLGS,DCBOFOPN                 DID IT OPEN OK?
         BO    OPENOK
U100     ABEND 100,DUMP                          SYSPRINT OPEN FAILED
*
OPENOK   DS    0H
         LA    R0,LINES
         ST    R0,DY8PTRS              @ 1ST REC
         LA    R0,L$LINE
         ST    R0,DY8PTRS+4            L' REC
*
OUTOPEN  DS    0H
         LM    R5,R6,DY8PTRS           R5-R7: @REC, L'REC, @CURRENT
         LA    R7,LINE                 MOST RECENT LINE
         ST    R7,DY8PTRS              FOR NEXT TIME
         BCTR  R7,0                    DON'T WRITE CURRENT LINE
*
OUTPUT   DS    0H
         PUT   (R9),(R5)               WRITE SYSPRINT LINE
         BXLE  R5,R6,OUTPUT            UNTIL CAUGHT UP WITH STRING
*
         LM    R0,R15,DY8OUT           PUT REGS BACK AS NORMAL
         POP   USING
         BR    R14
*
DCBPRINT DCB   DDNAME=SYSPRINT,MACRF=PM,DSORG=PS,                      +
               RECFM=FB,LRECL=L$LINE,BLKSIZE=3200
L$DCB    EQU   *-DCBPRINT
*
MODLOPEN OPEN  (0,(OUTPUT)),MF=L
L$OPEN   EQU   *-MODLOPEN
*
MODLCLOS CLOSE (,),MF=L
L$CLOSE  EQU   *-MODLCLOS
         EJECT ,
*----------------------------------------------------------------------
*        BUILD A TRANSLATE TABLE FOR NON-PRINTABLE CHARACTERS
*----------------------------------------------------------------------
NONPRINT MVI   WK256,C' '              PRINTABLE CHARACTERS
         MVC   WK256+1(255),WK256
         MVC   WK256+X'4A'(7),=X'4A4B4C4D4E4F50'
         MVC   WK256+X'5A'(8),=X'5A5B5C5D5E5F6061'
         MVC   WK256+X'6A'(6),=X'6A6B6C6D6E6F'
         MVC   WK256+X'7A'(6),=X'7A7B7C7D7E7F'
         MVC   WK256+C'A'(10),=C'ABCDEFGHI'
         MVC   WK256+C'J'(10),=C'JKLMNOPQR'
         MVC   WK256+C'S'(9),=C'STUVWXYZ'
         MVC   WK256+C'0'(10),=C'0123456789'
         BR    R14
         SPACE 3
*----------------------------------------------------------------------
*        TCB TREE SCAN SOUTINE
*----------------------------------------------------------------------
SCANTCB  LR    R1,R4                   SAVE TCB ADDRESS
         L     R4,TCBLTC-TCB(,R4)      DAUGHTER
         LA    R3,1(,R3)               INDENTATION INDEX
*LOOP
SCANTCB2 LTR   R4,R4                   CHECK FOR END OF CHAIN
         BNZR  R14                     PASS VALID TCB ADDRESS
         L     R4,TCBNTC-TCB(,R1)      SISTER
         L     R1,TCBOTC-TCB(,R1)      MOTHER
         BCT   R3,SCANTCB2             INDENTATION INDEX
*ENDLOOP
         SR    R4,R4                   SET CC=0
         BR    R14                     GOBACK
         DROP
         EJECT ,
*----------------------------------------------------------------------
*----------------------------------------------------------------------
$FARRTNE LOCTR                         FAR ROUTINES
*----------------------------------------------------------------------
*----------------------------------------------------------------------
*        BRIF READ ROUTINE
*----------------------------------------------------------------------
RDRTNE   SAVE  (14,12),,*
         BALR  R12,0
         USING *,R12
         L     R2,00(,R1)              RECORD DATA READ
*@@      L     R3,04(,R1)              LENGTH
         L     R4,08(,R1)              RELATIVE RECORD NUMBER
         L     R5,12(,R1)              PTR TO DIALOG DATA AREA
         L     R5,0(,R5)               POINT TO DYN
         USING DYN,R5
         L     R11,BASEREG             BASE REGISTER
         USING BASEADDR,R11
         TM    ECB1,X'40'              SUBTASK ENDED ALREADY?
         BZ    RDRTNE3                 NOT YET, JUMP
         CLI   ECB1+4,X'FF'            DETACHED ALREADY?
         BE    RDRTNE3                 YES, JUMP
         CLC   MYTCB,PSATOLD-PSA       AM I UNDER THE RIGHT TCB?
         BNE   RDRTNE3                 NO, JUMP
         DETACH ECB1+4                 DETACH SUBTASK
         MVI   ECB1+4,X'FF'            MARK IT DETACHED
*
RDRTNE3  L     R1,0(,R4)               LINE NUMBER REQUESTED BY BRIF
         C     R1,NUMLINES             CHECK FOR END OF DATA
         BH    RDRTNE8                 JUMP IF TOO BIG
         BCTR  R1,0                    DOWN BY 1
         M     R0,=A(L'LINE)           OFFSET TO LAST LINE
         LA    R10,LINES(R1)           CHANGE OFFSET TO ADDRESS
         ST    R10,0(,R2)              PASS DATA ADDRESS
         RETURN (14,12),RC=0           GOBACK TO EDIT
*
*        END OF DATA - RETURN MAX LINE#
*
RDRTNE8  L     R1,NUMLINES             NUMBER OF LINES
         ST    R1,0(,R4)               PASS IT TO BRIF
         BCTR  R1,0                    DOWN BY 1
         M     R0,=A(L'LINE)           OFFSET TO LAST LINE
         LA    R10,LINES(R1)           CHANGE OFFSET TO ADDRESS
         ST    R10,0(,R2)              PASS DATA ADDRESS
         RETURN (14,12),RC=8
         DROP
         EJECT ,
*----------------------------------------------------------------------
*
*        SUB-TASK USED FOR ASYNCHRONOUS LOCATE/OBTAIN
*
*        THIS SUB-TASK ALLOWS IMPATIENT USERS (LIKE ME) TO SEE THE
*        FIRST SCREEN WITHOUT ANY DELAY WHILE VOLUME AND VTOC
*        INFORMATION (WHICH REQUIRE I/O) IS OBTAINED FOR THE LINK-LIST,
*        LPA-LIST AND APF-LIST DISPLAYS.
*
*        WHEN THE USER SCROLLS TO THESE SCREENS (WHICH TAKES A FEW
*        SECONDS), VOLUME AND VTOC INFORMATION WILL HAVE BEEN OBTAINED
*        IN THE BACKGROUND, WITHOUT THE USER HAVING TO WAIT.
*
*        IF A SPEEDY USER CHAINS A "FIND" COMMAND TO THE INVOCATION
*        OF THIS PROGRAM (BY ISSUING "TSO SHOWMVS;F LPA-LIST" FOR
*        EXAMPLE), THEN HE/SHE WILL PROBABLY GET A BUNCH OF QUESTION
*        MARKS INSTEAD OF VOLUME AND VTOC INFORMATION (SURPRISE,
*        SURPRISE !!).  AFTER A FEW SECONDS OF HESITATION, THIS USER
*        IS LIKELY TO HIT "ENTER" OR SCROLL (UP OR DOWN) TO SEE IF
*        OTHER BIZARRE THINGS HAPPEN, WHICH LEAVES ENOUGH TIME TO THE
*        SUBTASK TO FINISH OBTAINING THE INFORMATION AND REPLACE THE
*        QUESTION MARKS WITH PERTINENT DATA.
*
*----------------------------------------------------------------------
SUBTASK  BALR  R12,0
         USING *,R12
         LR    R9,R1                   A(DYN)
         USING DYN,R9
         L     R11,BASEREG             BASE REGISTER
         USING BASEADDR,R11
         LA    R10,LINES               FIRST LINE
         USING LINE,R10
*
*              VOLSER
*LOOP
SUBT11   CLI   VOLSER,C'?'             VOLSER FOUND ALREADY?
         BNE   SUBT21                  YES, JUMP
         MVC   VOLSER,=C'??????'       NOT FOUND
         L     R14,=X'44,00,00,00'     CAMLST FLAGS
         LA    R15,DSNAME              ENTRY NAME
         SLR   R0,R0                   NO CVOL PTR
         LA    R1,WK256                WORK AREA
         STM   R14,R1,TENWORDS         BUILD CAMLIST
         LOCATE TENWORDS
         LTR   R15,R15
         BNZ   SUBT21                  NOT FOUND (OR OTHER ERROR)
         MVC   VOLSER,WK256+6          MOVE VOLSER
*YYMMDD
SUBT21   CLI   YYMMDD,C'?'             DATE FOUND ALREADY?
         BNE   SUBT31                  YES, JUMP
         MVC   YYMMDD,BLANKS           BLANK OUT DATE FIELD
         L     R14,=X'C1,00,00,00'     CAMLST FLAGS
         LA    R15,DSNAME              DATA SET NAME OF CCHHR
         LA    R0,VOLSER               VOLUME SERIAL
         LA    R1,DS1FMTID             WORK AREA
         STM   R14,R1,TENWORDS         BUILD CAMLIST
         OBTAIN TENWORDS               READ F1-DSCB
         LTR   R15,R15
         BNZ   SUBT31                  NOT FOUND (OR OTHER ERROR)
         SLR   R0,R0
         ICM   R0,B'0001',DS1CREDT+0   CREATION YEAR
         CVD   R0,DWD
         ICM   R1,B'0011',DWD+6        ....0YYC
         SLL   R1,012                  .0YYC000
         ICM   R0,B'0011',DS1CREDT+1   CREATION DAY
         CVD   R0,DWD
         ICM   R1,B'0011',DWD+6        .0YYDDDC
         L     R15,=A(@JDATE)          DATE CONVERT ROUTINE
         BALR  R14,R15                 CONVERT JULIAN TO YYMMDD
         MVC   YYMMDD(6),0(R1)         YYMMDD
*UNCAT=UNCAT
SUBT31   CLI   CATUNCAT,C'?'           CATALOG STATUS KNOWN ALREADY?
         BNE   SUBT41                  YES, JUMP
         MVC   CATUNCAT,=C'UNCAT'      MOVE STATUS
         L     R14,=X'44,00,00,00'     CAMLST FLAGS
         LA    R15,DSNAME              ENTRY NAME
         SLR   R0,R0                   NO CVOL PTR
         LA    R1,WK256                WORK AREA
         STM   R14,R1,TENWORDS         BUILD CAMLIST
         LOCATE TENWORDS
         LTR   R15,R15
         BNZ   SUBT41                  NOT FOUND (OR OTHER ERROR)
         CLC   VOLSER,WK256+6          SAME VOLSER?
         BNE   SUBT41                  NO, JUMP
         MVC   CATUNCAT,BLANKS         CATALOGED=YES
*UNCAT=APF
SUBT41   CLI   CATUNCAT,C'-'           APF-LIST STATUS KNOWN ALREADY?
         BNE   SUBT51                  YES, JUMP
         MVC   CATUNCAT,=C'APF  '      MOVE STATUS
         LM    R15,R1,APFTABLE         APF TABLE
         LTR   R15,R15                 TEST
         BZ    SUBT51                  TEST
*--LOOP
SUBT44   CLC   DSNAME,DSNAME-LINE(R15) MY DSNAME?
         BNE   SUBT45                  NO, JUMP
         CLC   VOLSER,VOLSER-LINE(R15) MY VOLSER?
         BE    SUBT51                  YES, QUIT
SUBT45   BXLE  R15,R0,SUBT44           NEXT ENTRY
*--ENDLOOP
         MVC   CATUNCAT,BLANKS         APF=NO
SUBT51   LA    R10,NEXTLINE            NEXT LINE
         CLI   LINE,00                 LAST LINE?
         BNE   SUBT11                  NO, LOOP MORE
*ENDLOOP
         SVC   3                       GOOD BYE
         DROP
         EJECT ,
*----------------------------------------------------------------------
*        RECOVERY ROUTINE
*----------------------------------------------------------------------
RECOVERY LA    R15,0012                R15=12
         CR    R0,R15                  SDWA ALLOCATED?
         BALR  R15,0                   LOCAL BASE
         BNE   RCVY$200-*(,R15)        YES, JUMP
         SR    R15,R15                 SET RC=0 (IF R0=12)
         BR    R14                     RETURN TO EXIT PROLOG
RCVY$200 BALR  R15,0
         SAVE  (14,12),,'RECOVERY ROUTINE'
         BALR  R12,0
         USING *,R12
         LR    R8,R1
         USING SDWA,R8
         LR    R14,R13
         L     R13,SDWAPARM            =A(DYN)
         LA    R13,DYN_RCVY-DYN(,R13)  =A(DYN_RCVY)
         ST    R14,4(,R13)
         ST    R13,8(,R14)
         USING DYN_RCVY,R13
         ICM   R4,B'1111',RETRY        LOAD/TEST RETRY ADDRESS
         BNP   RCVY$999                NO RETRY, CONTINUE WITH ABEND
         MVI   RETRY,X'FF'             INVALIDATE RETRY ADDRESS
         MVC   SDWASRSV,SDWAGRSV       MOVE REGISTERS
         MVC   SDWASR03,CVTPTR         R3=CVTADDR
         MVC   SDWASR04,PSATOLD-PSA    R4=TCBADDR
         MVC   SDWASR11,BASEREG        R11 (BASE REG)
         MVC   SDWASR13,SDWAPARM       R13
         L     R13,4(,R13)             R/TM SAVE AREA
         SETRP WKAREA=(R8),RETADDR=(R4),RC=4,  <== RETRY               X
               FRESDWA=YES,RETREGS=YES,REGS=(14,12)
RCVY$999 L     R13,4(,R13)
         SETRP WKAREA=(R8),REGS=(14,12),RC=00
         DROP  ,                                                  <38J>
         EJECT ,
*----------------------------------------------------------------------
*----------------------------------------------------------------------
$LTORG   LOCTR ,                                                  <38J>
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         LTORG ,                                                  <38J>
         EJECT ,
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         STRING GENERATE               GENERATE LITERALS  <38J>
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         EJECT ,
*----------------------------------------------------------------------
*----------------------------------------------------------------------
*        DYNAMIC STORAGE AREA
*----------------------------------------------------------------------
*----------------------------------------------------------------------
DYN      DSECT                         DYNAMIC STORAGE AREA
         DS    18F                     SAVE AREA FOR MAINLINE
PARMADDR DS    A                       ADDR OF CALLER'S PARM OR CBUF
DYN_RCVY DS    18F                     SAVE AREA FOR RECOVERY ROUTINE
DWD      DS    D                       WORK AREA
TENWORDS DS    10F                     WORK AREA
JSTCB    DS    A(TCB)                  ADDRESS OF THE JOB-STEP TCB
MYTCB    DS    A(TCB)                  ADDRESS OF MY TCB
BASEREG  DS    A(R11)                  BASE REGISTERS FOR RECOVERY
ESTAEL   ESTAE MF=L
P$END    DS    2A                      RETURN/RETRY ADDRESS
RETRY    EQU   P$END+4,4,C'A'          RETRY ADDRESS
NUMLINES DS    F                       NUMBER OF LINES
APFTABLE DS    A(LINE,L'LINE,NEXTLINE) APF-LIST
BLANKS   DS    CL100                   A BUNCH OF BLANKS
VOLMOUNT DS    C'STORAGE'              VOLUME MOUNT ATTRIBUTE
IEFEB4UV DS    V(IEFEB4UV)             UNITNAME CONVERSION RTNE
ISPLINK  DS    V(ISPLINK)              ISPF DIALOG INTERFACE
UNITNAME DS    CL8,XL4,XL4             IEFEB4UV
ZENVIR   DS    CL32                    ISPF ENVIRONMENT
K1       DS    PL4                     COUNTER
K2       DS    PL4                     COUNTER
EP1      DS    CL10                    SVC TABLE
EP2      DS    CL10                    SVC TABLE
SVC88    DS    A                       UNUSED SVC NUMBER
ATTACHL  ATTACH SF=L
ECB1     DS    F,A(TCB)                COMMUNICATION ECB
         IECSDSL1 1                    F1-DSCB
         DS    XL5                     PADDING FOR OBTAIN
         WK$OUT ,                      SHOWOUT WORKAREAS <38J>
         DS    0F                                        <38J>
WK256    DS    XL256,2D                265-BYTE WORK AREA
LINES    DS    5000CL100               LINES FOR BRIF
DYNL     EQU   *-DYN                   LENGTH OF DYNAMIC STORAGE AREA
         SPACE 2
         PRINT NOGEN                   SAVE PAPER
PRINT    OPSYN ANOP                    SHUT'EM UP
         SPACE 2
*----------------------------------------------------------------------
*        WORK AREA FOR RDJFCB
*----------------------------------------------------------------------
IHADCB   DCBD  DSORG=XE,DEVD=DA        IHADCB
*8       IHAARL DSECT=NO               ALLOC RETRIEVAL LIST
*8ENLIST DS    A(IHADCB,ARL)           OPEN LIST, DCB EXIT LIST
OPENLIST DS    A(IHADCB,0)             OPEN LIST, DCB EXIT LIST
DYN24L   EQU   *-IHADCB
         SPACE 2
*----------------------------------------------------------------------
         DSECT
LINE     DS    CL100                   CURRENT LINE
L$LINE   EQU   *-LINE                                             <38J>
DSNAME   EQU   LINE+2,44
VOLSER   EQU   LINE+2+44+3,6
YYMMDD   EQU   LINE+2+44+3+6+3,6
CATUNCAT EQU   LINE+2+44+3+6+3+6+3,5   UNCAT
NEXTLINE DS    CL100                   NEXT LINE
         EJECT ,
*----------------------------------------------------------------------
*----------------------------------------------------------------------
*        MVS CONTROL-BLOCKS
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* LOW STORAGE, PHYSICAL CONFIGURATION
*----------------------------------------------------------------------
         IHAPSA DSECT=YES              PREFIXED STORAGE AREA
*        IHAPCCAT DSECT=YES            PCCA VECTOR TABLE
         IHAPCCA DSECT=YES             PHYSICAL CONFIG. COMM. AREA
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* COMMUNICATION VECTORS
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         CVT   PREFIX=YES,DSECT=YES,LIST=NO
         IHASCVT DSECT=YES,LIST=NO     SECONDARY CVT
         IEFJESCT                      JES VECTOR TABLE
         IEFJSCVT                      SUB-SYSTEM COMM. VECTOR TABLE
         IEFJSSVT                      SUB-SYSTEM VECTOR TABLE
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REAL & VIRTUAL STORAGE MANAGEMENT
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IHAGDA                        GLOBAL DATA AREA
L$GDA    EQU    *-GDA
         IHALDA                        LOCAL  DATA AREA
         IHAPQE ,                      VSM PARTITION QUEUE ELEMENT<38J>
         IHASPQE ,                     VSM SUBPOOL QUEUE ELEMENT  <38J>
         IHADQE ,                      VSM DESCRIPTOR Q ELEMENT   <38J>
*----------------------------------------------------------------------
*        ILRASMVT DSECT=YES            AUXILIARY STRGE MGR VECTOR TABLE
ASMVT    DSECT                         ILRASMVT
ASMFLAG1 DS    X                       FLAGS 1
ASMFLAG2 DS    X,2X                    FLAGS 2
ASMQUICK EQU   X'08'                   QUICK START IPL
ASMSART  DS    V(SART)                 SWAP ACTIVITY REFERENCE TABLE
ASMPART  DS    V(PART)                 PAGE ACTIVITY REFERENCE TABLE
*----------------------------------------------------------------------
PART     DSECT                         ILRPART
PARTSIZE EQU   PART+04,4,C'X'          NUMBER OF ENTRIES IN THE PART
PARTDSNL EQU   PART+24,4,C'X'          ADDR OF DSN LIST
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* TASK MANAGEMENT
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IHAASCB                       ADDRESS SPACE CONTROL BLOCK
         IKJTCB DSECT=YES,LIST=NO      TASK CONTROL BLOCK
         IKJRB  DSECT=YES              REQUEST BLOCK              <38J>
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* CONTENTS MANAGEMENT
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IHALPDE ,                     LPA DIRECTORY ENTRY
         IHACDE ,                      CONTENTS DIRECTORY ENTRY
         IHALLE ,                      LOAD-LIST ELEMENT
         IHAXTLST ,                    EXTENT LIST
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* IOS & DATA MANAGEMENT
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IEZDEB  LIST=NO               DATA EXTENT BLOCK
TIOT     DSECT
         IEFTIOT1                      TASK INPUT-OUTPUT TABLE
         IEFUCBOB LIST=NO,PREFIX=NO    UNIT CONTROL BLOCK
JFCB     DSECT
         IEFJFCBN LIST=NO              JOB FILE CONTROL BLOCK
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* SMF, SRM
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IEESMCA                       SMF ANCHOR
         IEFTCT ,                      SMF TIMING CONTROL TABLE
         IRAOUCB                       SRM PARMS
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* PROGRAM PRODUCTS
*----------------------------------------------------------------------
*----------------------------------------------------------------------
*@@@     ICHPRCVT                      RACF
RCVT     DSECT                         ICHPRCVT  <==CVTRAC
         ORG   *+X'00AC'
RCVTVERS DS    XL1                     VERSION INDICATOR
RCVTVRN  EQU   X'F0'                   VERSION NUMBER IN HIGH NIBBLE
RCVTRELS EQU   X'0F'                   RELEASE NUMBER IN LOW NIBBLE
*----------------------------------------------------------------------
*@@@     ARCQCT                        HSM
*----------------------------------------------------------------------
MQCT     DSECT                         ARCACT    <==CVTHSM
         ORG   *+X'002C'
MQCTID   DS    C'QCT*'                 BLOCK ID
MQCTVER  DS    CL2                     VERSION
MQCTREL  DS    CL1                     RELEASE
MQCTMOD  DS    CL1                     MODIFICATION
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* RECOVERY/TERMINATION
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IHASDWA DSECT=YES             SDWA DSECT                 <38J>
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* MISCELLANEOUS
*----------------------------------------------------------------------
*----------------------------------------------------------------------
         IEZBITS                       BIT0-BIT7
         YREGS                         REGISTER EQUATES
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* ORPHANS (WE DON'T HAVE THESE IN MVS38J)
*----------------------------------------------------------------------
*----------------------------------------------------------------------
*8       IHARD  ,                      <NOT IN MVS38J>            <38J>
*8       IARRCE                        RSM CTL & ENUM AREA
*8       IHADFA  DSECT=YES             DFP AREA
*8       IKJTSVT                       TSO VECTOR TABLE
*----------------------------------------------------------------------
LLT      DSECT                         LINKLIST TABLE
LLTLLT   DS    C'LLT '                 BLOCK ACRONYM
LLTNO    DS    F                       NUMBER OF ENTRIES
LLTENTRY DS    0CL45                   DSNAME ENTRY
LLTDSNL  DS    FL1                     DSNAME LENGTH AFTER TRUNCATION
LLTDSNAM DS    CL44                    DATA SET NAME
LLTNEXT  EQU   *                       NEXT ENTRY
         DROP  ,
         EJECT ,
***********************************************************************
*
*        JULIAN-TO-YYMMDD CONVERSION ROUTINE
*
*          RECEIVES 00YYDDDF IN R1
*
*          RETURNS ADDRESS OF "YYMMDD" IN R1
*
***********************************************************************
@JDATE   CSECT
*8DATE   RMODE ANY
         SAVE  (14,2),,@JDATE
         BALR  R2,0
         USING *,R2
         USING @JDATES,R13
         MVC   @JDATET1,@JDATET0       MONTH TABLE
         TM    @JDATED+1,X'01'         ODD YEARS
         BO    @JDATEN                   AREN'T LEAP YEARS
         TM    @JDATED+1,X'12'         ZEROES IN 1980, ALL ONES IN 1992
         BM    @JDATEN                 MIXED IN 1982/1990
@JDATEL  MVI   @JDATET1+3,X'9F'        29TH OF FEBRUARY (LEAP YEAR)
@JDATEN  ZAP   @JDATEM,@JDATET1+7(1)   0 OF 30
         LA    R15,@JDATET1-2          TABLE OF MONTHS (NUMBER OF DAYS)
@JDATEP  AP    @JDATEM,@JDATET1+1(1)   ADD 1 OF 31
         LA    R15,2(,R15)             NEXT NUMBER OF DAYS
         SP    @JDATED+2(2),0(2,R15)   DDD
         BP    @JDATEP
         AP    @JDATED+2(2),0(2,R15)   DDD
         LA    R1,@JDATEY
         UNPK  0(3,R1),@JDATED+1(2)    YY
         UNPK  2(2,R1),@JDATEM         YYMM
         OI    3(R1),X'F0'             SUPPRESS SIGN
         UNPK  4(2,R1),@JDATED+2(2)    YYMMDD
         OI    5(R1),X'F0'             SUPPRESS SIGN
         ST    R1,@JDATED              PASS ADDRESS OF YYMMDD HH:MM
         RETURN (14,2)
@JDATET0 DC    P'31,28,31,30,31,30,31,31,30,31,30,31'
         SPACE 3
@JDATES  DSECT
         DS    A(0,0,0,14,15,0,1,2)
@JDATEM  EQU   @JDATES+16,4,C'P'       R15 SLOT
@JDATED  EQU   @JDATES+24,4,C'P'       R1 SLOT: 00YYDDDF
@JDATET1 DS    CL24               +32  TABLE OF MONTHS
@JDATEY  DS    C'YYMMDD',C' '     +56  YYMMDD.
         END
