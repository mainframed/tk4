//DSSDUMP$ JOB  (JUERGEN),
//          'RACify DSSDUMP',
//          CLASS=A,
//          MSGCLASS=X,
//          MSGLEVEL=(1,1),
//          NOTIFY=HERC01
//*********************************************************************
//*
//* Name: SYS2.DSSSRC(DSSDUMP$)
//*
//* Desc: ZAP DSSDUMP to verify caller's read access to facility
//*       DSSAUTH if resource access control is active
//*
//* Usage: 1. Change all occurances of SYS2.DSSLIB in this job to the
//*           DSN of a load library containing the original DSSDUMP
//*           module as distributed in the hercules-os380 Yahoo group's
//*           file section (dssdmp.zip or DSSDTR.zip). The ZAP fits
//*           the DSSDUMP version dated 12th, 2010 15:35:00 and the
//*           load module as linked on November 18th, 2011 at 19:18:21.
//*
//*        2. Submit this job.
//*
//*        3. The load module will get expanded to provide space for
//*           the ZAP and thus this is not an inplace update. So, if
//*           the DSSDUMP module is in the linklist and you're using
//*           DYNABLDL, remember to restart it to activate the change.
//*
//*        4. Create profile DSSAUTH in the FACILITY class with
//*           universal access NONE. Permit users and/or groups
//*           READ access to allow usage of DSSDUMP.
//*
//* Example profile definitions for the RAKF security system:
//* ----+----1----+----2----+----3----+----4----+----5----+----6----
//* FACILITYDSSAUTH                                             NONE
//* FACILITYDSSAUTH                                     ADMIN   READ
//* FACILITYDSSAUTH                                     STCGROUPREAD
//*
//* The same, if you happen to have RACF:
//* -------------------------------------
//* rdefine facility dssauth uacc(none)
//* permit dssauth cl(facility) id(admin,stcgroup) access(read)
//*
//* Both examples authorize members of groups ADMIN or STCGROUP
//* (or users of that name) to use DSSDUMP.
//*
//*********************************************************************
//*
//* Create patch area
//*
//LKED    EXEC PGM=IEWL,PARM='XREF,LET,LIST,NCAL,AC=1'
//SYSLMOD  DD DSN=SYS2.DSSLIB,DISP=SHR
//SYSUT1   DD DSN=&&SYSUT1,UNIT=SYSDA,
//         SPACE=(1024,(50,20))
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD *
 PAGE    DSSDUMP
 ORDER   DSSDUMP
 ORDER   DSSDUMP2
 ORDER   DSSDUMPD
 ORDER   SUBCAT
 ORDER   SUBCOMP
 ORDER   SUBLPALK
 ORDER   SUBTREE
 ORDER   SUBCPOOL
 ORDER   SUBVERB
 ORDER   SUBVTVAL
 ORDER   SUBXTSUM
 ENTRY   DSSDUMP
 INCLUDE SYSLMOD(DSSDUMP)
 EXPAND  DSSDUMP(196)
 NAME DSSDUMP(R)
/*
//*
//* Apply the ZAP
//*
//ZAPZARAP EXEC PGM=AMASPZAP
//SYSPRINT DD  SYSOUT=*
//SYSLIB   DD  DSN=SYS2.DSSLIB,DISP=SHR
//SYSIN    DD  *
 NAME DSSDUMP DSSDUMP
 IDRDATA  JW12114
 VER 029C 87FFB2F2          BXLE  R15,R15,HAVEAUTH YES; WHOOPPEE
 REP 029C 87FFCFE4          BXLE  R15,R15,CHECKRAC YES; check user auth
*
* Patch area
*
 VER 1FE4 00000000
 REP 1FE4 41C0CFE4 CHECKRAC LA    R12,INCRBASE(,R12) increment 2nd base
*                  INCRBASE EQU   CHECKRAC-BASE2 offset to 2nd base
*                           USING CHECKRAC,R12 establish addressability
 REP 1FE8 58F00010          L     R15,CVTPTR   get CVT address
 REP 1FEC BFFFF0F8          ICM   R15,B'1111',CVTSAF(R15) SAFV defined?
 REP 1FF0 4780C08A          BZ    GOAHEAD      no RAC, go execute
*                           USING SAFV,R15     addressability of SAFV
 REP 1FF4 D503F000C0BF      CLC   SAFVIDEN(4),SAFVID SAFV initialized?
 REP 1FFA 4770C08A          BNE   GOAHEAD      no RAC, go execute
*                           DROP  R15          SAFV no longer needed
*
* Relocate address constants in RACHECK parameter list
* to avoid needing to modify the relocation dictionary
* (this makes the code non reentrant)
*
 REP 1FFE 41F0C098          LA    R15,DSSAUTH get facility name address
 REP 2002 BFF8C03C          ICM   R15,B'1000',*+X'1E' insert high order
 REP 2006 50F0C03C          ST    R15,*+X'1A' store it in RACHECK plist
 REP 200A 41F0C071          LA    R15,ICH10005 get class name lng addr
 REP 200E BFF8C040          ICM   R15,B'1000',*+X'16' insert high order
 REP 2012 50F0C040          ST    R15,*+X'12' store it in RACHECK plist
*
* Authorization check       RACHECK ENTITY=DSSAUTH,CLASS='FACILITY',
*                                   ATTR=READ
 REP 2016 0700              CNOP  0,4          align
 REP 2018 4510C07A          BAL   1,*+70       branch around plist
 REP 201C 38                DC    AL1(56)      \
 REP 2021 00207C            DC    AL3(DSSAUTH)  \
 REP 2024 02                DC    B'00000010'    \
 REP 2025 002055            DC    AL3(ICH10005)   RACHECK plist
 REP 2055 08       ICH10005 DC    AL1(8)         /
 REP 2056 C6C1C3C9D3C9E3E8  DC    CL8'FACILITY' /
 REP 205E 0A82              SVC   130          invoke RACHECK SVC
*
* End of authorization check
*
 REP 2060 12FF              LTR   R15,R15      authorization granted?
 REP 2062 4780C08A          BZ    GOAHEAD      yes, go execute
 REP 2066 5BC0C094          S     R12,BASE2INC no, restore 2nd base ..
 REP 206A 47F0B2A0          B     ABEND          .. and abend
 REP 206E 5BC0C094 GOAHEAD  S     R12,BASE2INC restore 2nd base
 REP 2072 47F0B2F2          B     HAVEAUTH     WHOOPPEE
*
* Constants
*
 REP 2078 00000FE4 BASE2INC DC    A(INCRBASE)  offset to 2nd base
*                  DSSAUTH  DC    CL39'DSSAUTH' facility name
*                  SAFVID   DC    CL4'SAFV'    SAFV eye catcher
 REP 207C C4E2E2C1E4E3C84040404040404040404040404040404040
 REP 2094 404040404040404040404040404040E2C1C6E5
/*
//
