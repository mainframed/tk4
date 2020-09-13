//HERC01UP JOB (ACCNT),'CreSamp ',CLASS=A,MSGCLASS=X                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(CRESAMP)                                                 
//*                                                                             
//*  Desc: Create JCL examples                                                  
//*  Note: 4 jobsteps are used here:                                            
//*        3 jobsteps to create the target data set:                            
//*          at the moment is a NEW HERC01.TEST.SAMPJCL                         
//*        1 jobstep to ADD members from SYS2.JCLLIB                            
//*        This is done so the original SYS2.JCLLIB can be renamed              
//*                                                                             
//********************************************************************          
//*                                                                             
//CRE#PDS  EXEC PGM=IEBGENER Use IEBGENER to add PDSLOAD example                
//*                          So we have no trouble with ./ and ><               
//SYSPRINT DD  SYSOUT=*                                                         
//*-------- temporary -----------------------------------------                 
//SYSUT2   DD  DISP=(,CATLG),DSN=HERC01.TEST.SAMPJCL(PDSLOAD),                  
//*SYSUT2  DD  DISP=(,CATLG),DSN=SYS2.JCLLIB(PDSLOAD),                          
//*-------- temporary -----------------------------------------                 
//         UNIT=SYSALLDA,SPACE=(TRK,(20,20,120),RLSE),                          
//         DCB=(LRECL=80,RECFM=FB,BLKSIZE=6080,DSORG=PO)                        
//*SYSUT2   DD  DISP=SHR,DSN=SYS2.JCLLIB                                        
//SYSIN    DD  DUMMY                                                            
//SYSUT1   DD  DATA,DLM=##  <<--== DLM !!                                       
//HERC01UP JOB (PDSLOAD),'test PDSLOAD',CLASS=A,MSGCLASS=X                      
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(PDSLOAD)                                                 
//*                                                                             
//*  Desc: PDSLOAD step to add IEBUPDTE sample JCL                              
//*                                                                             
//*  Note: UPDTE(><)   - REPLACE >< WITH CTL CHARACTERS ./                      
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//LOADUPDT EXEC PGM=PDSLOAD,PARM='UPDTE(><)'                                    
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT2   DD  DISP=SHR,DSN=HERC01.TEST.SAMPJCL                                 
//*                                                                             
//* START of DD DATA,DLM=#$ !!!!!!!!!                                           
//*===================================================                          
//SYSUT1   DD  DATA,DLM=#$  <<--== DLM !!                                       
./ ADD NAME=IEBUPDT2                                                            
//HERC01UP JOB (ACCNT),'IEBUPDTE',CLASS=A,MSGCLASS=X                            
//*                                                                             
//* add members to new data set                                                 
//* or existing one (Update the DISP and other parms)                           
//*                                                                             
//CRENEW   EXEC PGM=IEBUPDTE,PARM='NEW'                                         
//SYSUT2   DD  DISP=(,CATLG),DSN=HERC01.TEST.TRASHCAN,                          
//         UNIT=SYSALLDA,SPACE=(TRK,(20,20,41),RLSE),                           
//         DCB=(LRECL=80,RECFM=FB,BLKSIZE=6080)                                 
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
><        ADD   LIST=ALL,NAME=TRASH1                                            
                Just an example: can be deleted                                 
><        ADD   LIST=ALL,NAME=TRASH2                                            
><     NUMBER   NEW1=10,INCR=10                                                 
                Just an example: can be deleted                                 
><        ENDUP                                                                 
#$                                                                              
//*===================================================                          
//* END of DD DATA,DLM=#$ !!!!!!!!!                                             
//*                                                                             
//*                                                                             
##                                                                              
//*                                                                             
//*RESAMP  EXEC PGM=IEBUPDTE,PARM='NEW'                                         
//CRESAMP  EXEC PGM=PDSLOAD                                                     
//*-------- temporary -----------------------------------------                 
//*SYSUT2   DD  DISP=SHR,DSN=SYS2.JCLLIB                                        
//SYSUT2   DD  DISP=SHR,DSN=*.CRE#PDS.SYSUT2                                    
//*-------- temporary -----------------------------------------                 
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DATA,DLM=#$ <<---==== DLM                                        
./ ADD NAME=$HISTORY                                                            
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB($HISTORY)                                                
//*                                                                             
//*  Desc: Short History and TODO about this sample JCL                         
//*                                                                             
//********************************************************************          
//*                                                                             
Date       Description                                                          
2013-11-13 Typo in $HISTORY                                                     
2013-11-04 Small updates from ScottC on                                         
           BAT#EDIT                                                             
           PDSLOAD                                                              
           READOMAT                                                              
2013-11-02 Added samples READOMAT and BAT#EDIT from ScottC                      
2013-10-31 Added samples MINIZIPP and MINIZIPS from ScottC                      
         - Updated explanation on related members                               
               to add MINIZIPP and MINIZIPS                                     
         - reorganized this $HISTORY member                                     
2013-10-16 switched AMDPRDMP from TSO as this MVS does not need that.           
2013-10-12 added new sample PUNPDSXM                                            
                            RD#PDSXM                                            
                                                                                
2013-10-12 updated comments in XMIT370P to:                                     
               XMI='missing', XMI - OUTput xmit data set                        
               PDS='missing', PDS - INput pds data set                          
           IN and OUT were the other way around.                                
                                                                                
2013-10-10 changed all MSGCLASS into X                                          
                                                                                
2013-10-07 added:                                                               
BSPOSCMD   Issue MVS commands from a batch job                                  
DELAY      Run the DELAY program                                                
TSOBATCH   Just an example of TSO in the batch                                  
                                                                                
2013-10-07 updated from SYS2.JCLLIB:                                            
CLIPDASD   Inserted instream procedure                                          
EREP0000   Changed name of the procedure called here                            
EREP0010   Changed name of the procedure called here                            
                                                                                
2013-10-06 updated by ScottC                                                    
MemberName Short_description                                                    
BSPHRCMD   Issue an Hercules command from within MVS                            
TSUPDATE   Batch update of all members of a PDS                                 
           and a sset of 3 related samples:                                     
MINIUNZP   Unzip a zip archive using MINIUNZ                                    
RECV370P   Receive xmitted PDS data set                                         
XMIT370P   Create an XMIT file from the PDS created in RECV370P                 
                                                                                
2013-10-03 new members                                                          
MemberName Short_description                                                    
BYPASSNQ   Do data set  manipulations without ENQ                               
TAPEMAP    Print the contents of a tape (a tapemap)                             
                                                                                
2013-09-29 new members                                                          
MemberName Short_description                                                    
RECV370P   Receive xmitted PDS data set                                         
RECV370S   Receive xmitted sequential data set                                  
OFFLOAD    Copy a pds to an offloaded sequential data set                       
SAVEOLD    Make a safety copy of a PDS with iebcopy                             
RENMEMBR   Copy+rename a member before replacing it                             
COMPRESS   Compress a PDS                                                       
IEBUPDTE   add members to new data set                                          
COMPPROC   Compress one or more PDSes (with a safety copy)                      
                                                                                
                                                                                
./ ADD NAME=$$$INDEX                                                            
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB($$$INDEX)                                                
//*                                                                             
//*  Desc: Short index of members in this PDS with sample JCL                   
//*                                                                             
//********************************************************************          
//*                                                                             
           Short description                               |Remarks   |         
           ------------------------------------------------------------         
           Job uses unavailable PROC                       |1 NO PROC |         
           Job is no longer of use in a RAKF system        |2 NO RAKF |         
=======================================================================         
Membername Short description                               |Remarks   |         
---------- ------------------------------------------------------------         
$$$INDEX   THIS member, you are reading it                 |          |         
$HISTORY   Done and To Be Done                             |          |         
ADDALIAS   Add a member alias to a PDS member              |          |         
ADDUSER    Add new TSO users                               |          |         
ADDUSERP   Add new TSO users, assigning standard password  |2 NO RAKF |         
ALLALIAS   Define all ALIASes                              |          |         
AMASPZAP   Update (ZAP) a loadmodule                       |          |         
AMDPRDMP   Print (format) a system dump                    |          |         
BAT#EDIT   Batch edit a data set                           |          |         
BSPHRCMD   Issue an Hercules command from within MVS       |          |         
BSPOSCMD   Issue MVS commands from a batch job             |          |         
BSPVTMWT   wait till vtam myapplid is active               |          |         
BYPASSNQ   Do data set  manipulations without ENQ          |          |         
CHGPWD     Change a user`s password                        |2 NO RAKF |         
CLIPDASD   Rename offline volume(s)                        |          |         
COMPPROC   Compress one or more PDSes (with a safety copy) |          |         
COMPRESS   Compress a PDS                                  |          |         
CONFIGSE   prints the current I/O config in text format    |          |         
COPY001    Copy PDS to PDS, replacing existing members     |          |         
DEFALIAS   Create an alias (HLQ pointer in mastercatalog)  |          |         
DEFPAGE    Define a system PAGE data set                   |          |         
DEFSWAP    Define a system SWAP data set                   |          |         
DELAY      Run the DELAY program                           |          |         
DUMPT      amaspzap dumpt: print loadmodule contents       |          |         
DUMPTNUC   amaspzap dumpt: print module from NUCLEUS       |          |         
EREP       print erep error log from SYS1.LOGREC           |          |         
EREP0000   Dump SYS1.LOGREC to new generation data set     |          |         
EREP0010   Create various reports from EREP History Data   |          |         
IEBCOPY    example IEBCOPY to copy a member                |          |         
IEBDG      generate test data                              |          |         
IEBGENER   copy/"print" a data set with IEBGENER           |          |         
IEBPTPCH   print formatted data                            |          |         
IEBUPDTE   add members to new data set                     |          |         
           or existing one Update the DISP of SYSUT2       |          |         
IEFBR14    A do "nothing" job                              |          |         
IEHINITT   init a tape (write volume label)                |          |         
IEHLIST    list a pds or a dasd VTOC                       |          |         
IEHMOVE    Move files from pack A to pack B                |          |         
INTRDR     Send data to the internal reader,               |          |         
           Stated otherwise: submit a job                  |          |         
LINK       Linkedit a set of objects into a load module    |          |         
LISTIDR    ==-->> See member LISTLOAD                      |          |         
LISTLOAD   print about a loadmodule                        |          |         
LISTPDS    ==-->> See member IEHLIST                       |          |         
LISTVTOC   IEHLIST List the VTOC of a DASD volume          |          |         
MINIUNZP   Unzip a zip archive using MINIUNZ               |          |         
MINIZIPP   Zip a PDS using MINIZIP                         |          |         
MINIZIPS   Zip a sequential file using MINIZIP             |          |         
OFFLOAD    Copy a pds to an offloaded sequential data set  |          |         
PDSLOAD    Sample PDSLOAD job                              |          |         
PDSUPDTE   Tailor "all" members in a PDS                   |          |         
PJCLADD    Create a file with password protection          |          |         
PROGADD    Add a password to datasets using IEHPROGM       |2 NO RAKF |         
PROGCHG    Change a password to a dataset using IEHPROGM   |2 NO RAKF |         
PROGDEL    List a password entry using IEHPROGM            |2 NO RAKF |         
           !! Member name suggests DELete but does a LIST! |          |         
PROGLST    List a password entry using IEHPROGM            |          |         
PROTADD    Add a password to a dataset using TSO PROTECT   |2 NO RAKF |         
PROTCHG    Change a dataset password via TSO PROTECT       |2 NO RAKF |         
PROTDEL    Delete a dataset password via PROTECT           |2 NO RAKF |         
PROTLST    List PASSWORD info for a dataset via TSO PROTECT|2 NO RAKF |         
PTPCH001   IEBPTPCH Punch (one or more) PDS members        |          |         
PTPCH002   IEBPTPCH Punch a complete PDS                   |          |         
PUNPDSXM   XMIT and punch a PDS data set to a PC file      |          |         
PWDPRINT   List PASSWORD dataset                           |2 NO RAKF |         
RD#PDSXM   Read xmitted PDS from a PC file into a new PDS  |          |         
READOMAT   Read a CBT file directly from the original ZIP  |          |         
RECV370P   Receive the XMIT file (member),                 |          |         
           created as a result of MINIUNZP and create a PDS|          |         
RECV370S   Receive xmitted sequential data set             |          |         
RENMEMBR   Copy+rename a member before replacing it        |          |         
REVLMOD    sample Restore a loadmodule from reader 00C     |          |         
SAVEOLD    Make a safety copy of a PDS with iebcopy        |          |         
SHUTDOWN   Initiate automated shutdown of the TK4- system  |          |         
SMPLIST    SMP list info out of System Modification Program|          |         
SMPTFSEL   SMP Select SYSMODs via Filter Criteria          |          |         
SPZAP001   Dump a load module                              |          |         
SPZAP002   Dump a load module and print translated         |          |         
SPZAP003   Zap a load module                               |          |         
TAPEMAP    Print the contents of a tape (a tapemap)        |          |         
TESTALG    Test ALGOL Installation                         |          |         
TESTCOB    Test COBOL Installation                         |          |         
TESTFORT   Test FORTRAN Installation (Fortran G & H)       |          |         
TESTPL1    Test PLI installation                           |          |         
TESTRPG    Test RPG installation                           |          |         
TESTSORT   Test SORT installation                          |          |         
TSOBATCH   Just an example of TSO in the batch             |          |         
TSUPDATE   Batch update of all members of a PDS            |          |         
UCATMVS    Create a user catalog                           |          |         
XMIT370P   Create XMIT file from PDS created in RECV370P   |          |         
ZAPDSCB    Update data set settings:                       |          |         
           Set/Remove expiration date                      |          |         
           Alter secondary space allocation                |          |         
           Alter password protection                       |          |         
                                                           |          |         
                                                           |          |         
                                                           |          |         
./ ADD NAME=ADDALIAS                                                            
//HERC01AA JOB (ACCNT),'ADDALIAS',CLASS=A,MSGCLASS=X                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(ADDALIAS)                                                
//*                                                                             
//*  Desc: add an alias to a PDS member                                         
//*                                                                             
//********************************************************************          
//*                                                                             
//RUNCMD   EXEC PGM=IKJEFT01,DYNAMNBR=25                                        
//SYSTSPRT DD  SYSOUT=*                                                         
//SYSTSIN  DD  *                                                                
 RENAME 'HERC01.DELETE.THIS(ORIGINAL)' +                                        
        'HERC01.DELETE.THIS(AN#ALIAS)' ALIAS                                    
./ ADD NAME=AMASPZAP                                                            
//HERC01Z1 JOB (ACCNT),'AMASPZAP',TIME=(2),MSGCLASS=X,CLASS=A                   
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(AMASPZAP)                                                
//*                                                                             
//*  Desc: example zap: zap a copy of IEFBR14                                   
//*                     to IEFBR15                                              
//*                     - a continuous loop (sometimes nice to have)            
//*                                                                             
//********************************************************************          
//*                                                                             
//ZAP14#15 EXEC PGM=AMASPZAP                                                    
//SYSPRINT DD  SYSOUT=*                                                         
//SYSLIB   DD  DISP=SHR,DSN=HERC01.TEST.LOADLIB                                 
//SYSIN    DD  *                                                                
 NAME  IEFBR15 IEFBR14                                                          
 VER 00 1BFF,07FE                                                               
 REP 00 0700,07FF                                                               
//*                                                                             
./ ADD NAME=AMDPRDMP                                                            
//HERC01PD JOB (ACCNT),'AMDPRDUMP',CLASS=A,MSGCLASS=X                           
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(AMDPRDMP)                                                
//*                                                                             
//*  Desc: Print (format) a system dump                                         
//*                                                                             
//*  Note: Related manual might be:                                             
//*  GC28-0674 OS/VS2 MVS System Programming Library: Service Aids              
//*  Also found GC28-0633-1_OS_VS_Service_Aids_Sep72                            
//*  e.g. http://archive.org/details/                                           
//*      bitsavers_ibm370OSVS331OSVSServiceAidsSep72_12225347                   
//*                                                                             
//********************************************************************          
//* newer MVS releases require TSO services                                     
//*INTSO    EXEC PGM=IKJEFT01,PARM='AMDPRDMP LINECNT=91'                        
//*SYSTSIN  DD  DUMMY,DCB=(RECFM=F,LRECL=80,BLKSIZE=80)                         
//*SYSTSPRT DD  SYSOUT=*                                                        
//********************************************************************          
//PRDMP    EXEC PGM=AMDPRDMP,PARM='LINECNT=91'                                  
//SYSTSPRT DD  SYSOUT=*                                                         
//SYSPRINT DD  SYSOUT=* ,CHARS=GFC,FCB=1208                                     
//* Input dump data set:                                                        
//TAPE     DD  DISP=SHR,DSN=SYS1.DUMP01                                         
//INDEX    DD  SYSOUT=* ,CHARS=GFC,FCB=1208                                     
//PRINTER  DD  SYSOUT=* ,CHARS=GFC,FCB=1208                                     
//SYSUT1   DD  UNIT=VIO,SPACE=(4104,(1027,191))                                 
//SYSIN    DD  *                                                                
 PRINT CURRENT                                                                  
 END                                                                            
//SYSIN    DD   *                                                               
 O SUMDUMP                                                                      
 GO                                                                             
 END                                                                            
./ ADD NAME=BAT#EDIT                                                            
//HERC01U JOB ('edit bat'),'Batch edit example',                                
//          CLASS=A,                                                            
//          MSGCLASS=X,                                                         
//          MSGLEVEL=(1,1),                                                     
//          NOTIFY=HERC01                                                       
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//*********************************************************************         
//*                                                                             
//*  Name: SYS2.JCLLIB(BAT#EDIT)                                                
//*                                                                             
//* Desc : Batch edit a data set                                                
//*                                                                             
//*********************************************************************         
//*                                                                             
//ADDCLIST EXEC PGM=IEBGENER                                                    
//SYSPRINT DD SYSOUT=*                                                          
//SYSIN    DD DUMMY                                                             
//SYSUT1   DD DATA,DLM='><'                                              
PROC 0                                                                          
CONTROL MSG LIST CONLIST SYMLIST NOFLUSH                                        
EDIT 'HERC01.CBT.FILE478.PDS(RAWSTAPE)' DATA                                   
TOP                                                                             
C /IBMUSER/HERC01/         ALL                                                  
TOP                                                                             
F /ASMA90                                                                       
C /ASMA90/IFOX00/          ALL                                                  
F /MODGEN                                                                       
C /MODGEN/AMODGEN/         ALL                                                  
FIND /SYSUT1                                                                    
INSERT //SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,10)                                 
INSERT //SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,10)                                 
FIND /IBMUSER                                                                   
C /IBMUSER.LOAD(TEMPNAME)/SYS2.LINKLIB(RAWSTAPE)/ ALL                           
FIND ~//*                                                                       
C    ~//*~//~ ALL                                                               
SAVE                                                                            
TOP                                                                             
C /MSGCLASS=X/MSGCLASS=X,/                                                      
INSERT // USER=HERC01,PASSWORD=MY$PWN0W                                         
SUBMIT                                                                          
END                                                                             
END                                                                             
EXIT                                                                            
><                                                                              
//SYSUT2   DD DSN=&&TEMPPDS(MODJCL),DISP=(NEW,PASS),                            
//            DCB=(LRECL=80,BLKSIZE=3120,RECFM=FB,DSORG=PO),                    
//            SPACE=(TRK,(1,1,1),RLSE),UNIT=SYSALLDA                            
//*                                                                             
//BATCHTSO EXEC PGM=IKJEFT01,PARM='MODJCL'                                      
//SYSTSPRT DD  SYSOUT=*                                                         
//SYSPROC  DD  DSN=&&TEMPPDS,DISP=(OLD,PASS)                                    
//SYSTSIN  DD  DUMMY                                                            
//                                                                              
./ ADD NAME=BSPHRCMD 0106-13275-13279-1136-00008-00008-00000-HERC01  03         
//HERC01HR JOB (BSPHRCMD),'BSPHRCMD',CLASS=A,MSGCLASS=X,NOTIFY=HERC01           
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  NAME: SYS2.JCLLIB(BSPHRCMD)                                                
//*                                                                             
//*  DESC: Issue an Hercules command from within MVS                            
//*                                                                             
//*  Note: Command can be given both via PARM and/or SYSIN                      
//*                                                                             
//*   Required DD statements:                                                   
//*       none                                                                  
//*                                                                             
//*   Optional DD statements                                                    
//*    SYSPRINT  for messages                                                   
//*    HRCPRINT  for replies from Hercules                                      
//*                                                                             
//********************************************************************          
//*                                                                             
//STEP010  EXEC PGM=BSPHRCMD,PARM='UPTIME'                                      
//SYSPRINT DD  SYSOUT=*                                                         
//HRCPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
DEVLIST                                                                         
//                                                                              
./ ADD NAME=BSPOSCMD                                                            
//HERC01OS JOB (CBT),'Run BSPOSCMD',CLASS=A,MSGCLASS=X                          
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(BSPOSCMD)                                                
//*                                                                             
//*  Desc: Issue MVS commands from a batch job                                  
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Notes:                                                                     
//*         The commands can be passed via PARM statement,                      
//*         or via SYSIN DD statement, or both                                  
//*                                                                             
//*         Required DD statements:                                             
//*            none                                                             
//*                                                                             
//*         Optional DD statements                                              
//*            SYSPRINT  for messages                                           
//*                                                                             
//GO1     EXEC PGM=BSPOSCMD,PARM='D A,L'                                        
//*                                                                             
//GO2     EXEC PGM=BSPOSCMD,PARM='S DBREPORT'                                   
//SYSIN DD *                                                                    
I SMF                                                                           
D A,L                                                                           
./ ADD NAME=BYPASSNQ                                                            
//HERC01NQ JOB (BYPASSNQ),'UPDATE DATA SET',CLASS=A,MSGCLASS=X                  
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(BYPASSNQ)                                                
//*                                                                             
//*  Desc: Do data set  manipulations without ENQ                               
//*        program 'BYPASSNQ' from GILBERT SAINT-FLOUR                          
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//GO       EXEC PGM=BYPASSNQ,PARM=IEHPROGM                                      
//DD1      DD  UNIT=3390,VOL=SER=PUB003,DISP=OLD                                
//SYSPRINT DD  SYSOUT=*                                                         
  RENAME DSNAME=IBMUSER.TEST29,VOL=3390=PUB003,NEWNAME=GILBERT.TEST29B          
 SCRATCH DSNAME=IBMUSER.TEST29B,VOL=3390=PUB003                                 
./ ADD NAME=CLIPDASD                                                            
//HERC01RL JOB (RELABEL),'Clip DASD',CLASS=A,MSGCLASS=X                         
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//*********************************************************************         
//*                                                                             
//* Name: SYS2.JCLLIB(CLIPDASD)                                                 
//*                                                                             
//* Desc: Rename an offline DASD volume                                         
//*                                                                             
//* Note: Reverify ALL things you type here!                                    
//*       An error can cause loss of data!                                      
//*                                                                             
//*       In case a NEW dasd volume has to be labelled:                         
//*       change the controlcard for ICKDSF to NOVERIFY                         
//*                                                                             
//*********************************************************************         
//*                                                                             
//* instream procedure start ================================                   
//*                                                                             
//CLIPOFFL PROC CUA=000,     <=== address of OFFLINE unit to relabel            
//           VERID=VVVVVVVV, <=== OLD name of dasd device                       
//           VOLID=VVVVVVVV  <=== NEW name of dasd device                       
//*                                                                             
//* Make sure the dasd volume does come offline                                 
//*                                                                             
//CMD0     EXEC PGM=BSPOSCMD,PARM=' D U,,,&CUA.,1'                              
//CMD1     EXEC PGM=BSPOSCMD,COND=(5,LT),PARM=' V &CUA.,OFFLINE'                
//WAIT#2   EXEC PGM=DELAY,PARM='2'                                              
//CMD2     EXEC PGM=BSPOSCMD,COND=(5,LT),PARM=' S DEALLOC'                      
//WAIT#2   EXEC PGM=DELAY,PARM='2'                                              
//*        Prepare controlcard for ICKDSF                                       
//CMD3     EXEC PGM=BSPPA2SI,                                                   
//*   PARM=' REFORMAT UNIT(&CUA.) VOLID(&VOLID.) NOVERIFY'                      
//    PARM=' REFORMAT UNIT(&CUA.) VOLID(&VOLID.) VERIFY(&VERID)'                
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(TRK,(1,1))                          
//*        Do the actual label change                                           
//ICKDSF   EXEC PGM=ICKDSF,COND=(5,LT)                                          
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.CMD3.SYSUT1                              
//*        vary online again                                                    
//CMD4     EXEC PGM=BSPOSCMD,COND=(5,LT),PARM='V &CUA.,ONLINE'                  
//*        Mount as private                                                     
//CMD5     EXEC PGM=BSPOSCMD,COND=(5,LT),                                       
//           PARM='M &CUA.,VOL=(SL,&VOLID),USE=PRIVATE'                         
//WAIT#2   EXEC PGM=DELAY,PARM='2'                                              
//CMD9     EXEC PGM=BSPOSCMD,PARM=' D U,,,&CUA.,1'                              
//CLIPOFFL PEND                                                                 
//*                                                                             
//* instream procedure =end= ================================                   
//*                                                                             
//SRC000   EXEC CLIPOFFL,CUA=601,VOLID=SRC000,VERID=WAS348                      
./ ADD NAME=COMPPROC                                                            
//HERC01ZP JOB COMPPROC,'save+Compress lib',CLASS=A,MSGCLASS=X                  
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(COMPPROC)                                                
//*                                                                             
//*  Desc: Compress one or more PDSes (with a safety copy)                      
//*                                                                             
//*  Note: Be sure the xxxxxxxxx.SAVE data set does not yet exist               
//*        Job seems to be OK if xxxxxxxx.SAVE already exists but               
//*        a new NOT CATALOGUED data set remains                                
//*                                                                             
//*  Note:                                                                      
//*        Be sure to handle the PDS appropriately (may need IPL!)              
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//* -------------------------------------------------------------------         
//* Write the SYSIN data to temp disk (to be used later)                        
//* -------------------------------------------------------------------         
//COPYCNTL EXEC PGM=IEBGENER                                                    
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  *                                                                
 COPY I=SYSUT1,O=SYSUT2,LIST=NO                                                 
//SYSUT2   DD  DISP=(,PASS),DSN=&&SAVECOPY,                                     
// UNIT=SYSDA,SPACE=(TRK,1),DCB=*.SYSUT1                                        
//SYSIN    DD  DUMMY,DCB=(LRECL=80)                                             
//*                                                                             
//CMPRCNTL EXEC PGM=IEBGENER                                                    
//SYSPRINT DD  DUMMY                                                            
//SYSUT1   DD  *,DCB=(LRECL=80,BLKSIZE=80)                                      
 COPY I=SYSUT1,O=SYSUT1,LIST=NO                                                 
//SYSUT2   DD  DISP=(,PASS),DSN=&&COMPRESS,                                     
// UNIT=SYSDA,SPACE=(TRK,1),DCB=*.SYSUT1                                        
//SYSIN    DD  DUMMY,DCB=(LRECL=80)                                             
//*                                                                             
//* -------------------------------------------------------------------         
//* Instream procedure                                                          
//* -------------------------------------------------------------------         
//*                                                                             
//SAVECMPR PROC LIB=FORGOTTEN,SPC='1,1,1'                                       
//C#1#SAVE EXEC PGM=IEBCOPY,COND=(9,LT)                                         
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=&LIB                                                
//SYSUT2   DD  DISP=(,CATLG),DSN=&LIB..SAVE,                                    
// UNIT=SYSDA,DCB=(&DSCB),SPACE=(TRK,(&SPC),RLSE)                               
//SYSIN    DD  DISP=(SHR,PASS),DSN=&&SAVECOPY                                   
//*                                                                             
//C#1#COMP EXEC PGM=IEBCOPY,COND=((0,NE,C#1#SAVE),(9,LT))                       
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=&LIB                                                
//SYSIN    DD  DISP=(SHR,PASS),DSN=&&COMPRESS                                   
//SAVECMPR PEND                                                                 
//*                                                                             
//* -------------------------------------------------------------------         
//* Use the instream procedure                                                  
//*                                                                             
//* -------------------------------------------------------------------         
//*                                                                             
//* //CMD  EXEC SAVECMPR,LIB='SYS2.CMDLIB',                                     
//* //         DSCB='RECFM=U,BLKSIZE=19069,DSORG=PO',                           
//* //          SPC='600,45,100'                                                
//*                                                                             
//PROC EXEC SAVECMPR,LIB='SYS2.PROCLIB',                                        
//         DSCB='RECFM=FB,LRECL=80,BLKSIZE=19040,DSORG=PO',                     
//          SPC='300,45,40'                                                     
//*                                                                             
./ ADD NAME=COMPRESS                                                            
//HERC01ZZ JOB (COMPRESS),'Compress a pds',CLASS=A,MSGCLASS=X                   
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(COMPRESS)                                                
//*                                                                             
//*  Desc: Compress a PDS                                                       
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//COMPRESS EXEC PGM=IEBCOPY,PARM='LIST=NO'                                      
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=HERC01.TEST.LOADLIB                                 
//SYSIN    DD  *                                                                
 C I=SYSUT1,O=SYSUT1                                                            
//*                                                                             
./ ADD NAME=DELAY                                                               
//HERC01WT JOB (DELAY),'do a DELAY',CLASS=A,MSGCLASS=X                          
//********************************************************************          
//*                                                                             
//* Name: SYS2.JCLLIB(DELAY)                                                    
//*                                                                             
//* Desc: Run the DELAY program                                                 
//*                                                                             
//********************************************************************          
//DELAY11 EXEC PGM=BSPDELAY,PARM=11   Delay 11 seconds                          
./ ADD NAME=DUMPT                                                               
//HERC01DT JOB (ACCNT),'DUMPT',TIME=(2),MSGCLASS=X,CLASS=A                      
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(DUMPT)                                                   
//*                                                                             
//*  Desc: amaspzap dumpt: print loadmodule contents                            
//*                                                                             
//********************************************************************          
//*                                                                             
//DUMPT    EXEC PGM=AMASPZAP                                                    
//SYSPRINT DD  SYSOUT=*                                                         
//SYSLIB   DD  DISP=SHR,DSN=SYS2.CMDLIB                                         
//SYSIN    DD  *                                                                
 DUMPT IND$FILE ALL                                                             
//*                                                                             
./ ADD NAME=DUMPTNUC                                                            
//HERC01DT JOB (ACCNT),'DUMPT',TIME=(2),MSGCLASS=X,CLASS=A                      
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(DUMPT)                                                   
//*                                                                             
//*  Desc: amaspzap dumpt: print module from NUCLEUS                            
//*                                                                             
//********************************************************************          
//*                                                                             
//DUMPT    EXEC PGM=AMASPZAP                                                    
//SYSPRINT DD  SYSOUT=*                                                         
//SYSLIB   DD  DISP=SHR,DSN=SYS1.NUCLEUS                                        
//SYSIN    DD  *                                                                
 DUMPT IEANUC01 IEEUCMC                                                         
//*                                                                             
./ ADD NAME=EREP                                                                
//HERC01ER JOB (EREP),'LOGREC',CLASS=A,MSGCLASS=X                               
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(DUMPT)                                                   
//*                                                                             
//*  Desc: print erep error log                                                 
//********************************************************************          
//*                                                                             
//PRINTEX  EXEC  PGM=IFCEREP1,REGION=6000K,                                     
// PARM=('ACC=N,HIST=N,LINECT=60,TABSIZE=256K')                                 
//*PARM=('ACC=N,HIST=N,SYSEXN,LINECT=60,TABSIZE=256K')                          
//*            'DATE=(84310,84338)') ,TIME=(11.00,12.00)'                       
//SERLOG   DD  DISP=SHR,DSN=SYS1.LOGREC                                         
//TOURIST  DD  SYSOUT=*                                                         
//EREPPT   DD  SYSOUT=*                                                         
//DIRECTWK DD  UNIT=VIO,SPACE=(CYL,(2))                                         
./ ADD NAME=EREP0000                                                            
//HERC01DL JOB (EREP),'Dump LOGREC',CLASS=A,MSGCLASS=X                          
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//*********************************************************************         
//*                                                                             
//* Name: SYS2.JCLLIB(EREP0000)                                                 
//*                                                                             
//* Desc: Dump SYS1.LOGREC to new generation data set                           
//*                                                                             
//*********************************************************************         
//DUMPIT EXEC DUMPEREP                                                          
./ ADD NAME=EREP0010                                                            
//HERC01RR JOB (EREP),'Various Reports',CLASS=A,MSGCLASS=X                      
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//*********************************************************************         
//*                                                                             
//* Name: SYS2.JCLLIB(EREP0010)                                                 
//*                                                                             
//* Desc: Create various reports from EREP History Data                         
//*       Current LOGREC is dumped first                                        
//*                                                                             
//*********************************************************************         
//DUMPIT   EXEC DUMPEREP                                                        
//*                                                                             
//IPL      EXEC EREPORT,REPORT=EREP0110   IPL report                            
//SYSUM    EXEC EREPORT,REPORT=EREP0010   Summary report                        
//SOFTWARE EXEC EREPORT,REPORT=EREP0100   Software events                       
//DDR      EXEC EREPORT,REPORT=EREP0080   Dynamic Device Reconfig               
//MDR      EXEC EREPORT,REPORT=EREP0070   Miscellaneous Data Records            
//EVENTS   EXEC EREPORT,REPORT=EREP0020   Event detail report                   
//THRESHLD EXEC EREPORT,REPORT=EREP0030   Temporary Error reports               
//MCH      EXEC EREPORT,REPORT=EREP0040   Machine Check reports                 
//CHCH     EXEC EREPORT,REPORT=EREP0050   Channel Check reports                 
//OBR      EXEC EREPORT,REPORT=EREP0060   Outbord data Unit Check               
//MIH      EXEC EREPORT,REPORT=EREP0090   Missing Interrupt Handler             
//TRENDS   EXEC EREPORT,REPORT=EREP0120   Trends                                
//*                                                                             
//ACCIN    DD  DISP=SHR,DSN=EREP.HISTORY.DATA                                   
./ ADD NAME=IEBCOPY                                                             
//HERC01BC JOB (ACCNT),'IEBCOPY',CLASS=A,MSGCLASS=X                             
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(IEBCOPY)                                                 
//*                                                                             
//*  Desc: example IEBCOPY to copy a member                                     
//*                                                                             
//*  Notes:                                                                     
//*  1) Indicate members FROM SYSUT1 are allowed to                             
//*     overwrite existing members in SYSUT2                                    
//*     by the "R" in ((SYSUT1,R))                                              
//*  2) rename IEFBR14 to IEFBR15 in the copy                                   
//*     by            ((IEFBR14,IEFBR15))                                       
//*                                                                             
//********************************************************************          
//*                                                                             
//COPYBR14 EXEC PGM=IEBCOPY                                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=SYS1.LINKLIB                                        
//SYSUT2   DD  DISP=SHR,DSN=HERC01.TEST.LOADLIB                                 
//SYSIN    DD  *                                                                
 C I=((SYSUT1,R)),O=SYSUT2                                                      
 S M=((IEFBR14,IEFBR15))                                                        
//*                                                                             
./ ADD NAME=IEBDG                                                               
//HERC01DG JOB (ACCNT),'IEBDG',CLASS=A,MSGCLASS=X                               
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(IEBDG)                                                   
//*                                                                             
//*  Desc: create test data                                                     
//*                                                                             
//********************************************************************          
//*                                                                             
//GEN      EXEC  PGM=IEBDG                                                      
//SYSPRINT DD  SYSOUT=*                                                         
//INPUT1   DD  *                                                                
WU                  HILDA                   L92                                 
WARREN              WILLIAM                 J82                                 
MEAD                JANICE                  J69                                 
YAEGER              FRANK                   J69                                 
JAQUET              STEFAN                  L92                                 
MADRID              MIGUEL                  J69                                 
GELLAI              ANDY                    J82                                 
LEE                 PAUL                    J69                                 
TOWNSEND            LEE                     J82                                 
BURT                JOHN                    J69                                 
MEHTA               NEELA                   L92                                 
KIRCHHOFER          RICHARD                 L92                                 
YAMAMOTO-SMITH      HOLLY                   J69                                 
BANH                PAUL                    L92                                 
JONES               MARGARET                J62                                 
//GENOUT1  DD  DSN=&&DS1,DISP=(NEW,PASS),                                       
//         DCB=(LRECL=80,BLKSIZE=6000,RECFM=FB),                                
//         UNIT=SYSDA,SPACE=(TRK,(5,2))                                         
//GENOUT2  DD  DSN=&&DS2,DISP=(NEW,PASS),                                       
//         DCB=(LRECL=80,BLKSIZE=8004,RECFM=VB),                                
//         UNIT=SYSDA,SPACE=(TRK,(5,2))                                         
//SYSIN    DD  *                                                                
 DSD  OUTPUT=(GENOUT1),INPUT=(INPUT1)                                           
 CREATE INPUT=INPUT1                                                            
 END                                                                            
 DSD  OUTPUT=(GENOUT2)                                                          
 FD NAME=SORT,LENGTH=10,STARTLOC=1,PICTURE=10,'XYZ123ABCD',ACTION=RP            
 FD NAME=SUM1,LENGTH=6,STARTLOC=18,PICTURE=6,P'001125',INDEX=92,       C        
               SIGN=-                                                           
 FD NAME=SUM2,LENGTH=3,STARTLOC=26,FORMAT=ZD,INDEX=12                           
 FD NAME=LAST,LENGTH=12,STARTLOC=46,FORMAT=AN,ACTION=SL                         
 REPEAT QUANTITY=3,CREATE=2                                                     
 CREATE QUANTITY=3,NAME=(SORT,SUM1,SUM2,LAST)                                   
 CREATE QUANTITY=6,NAME=(SORT,SUM1,SUM2)                                        
 END                                                                            
//* print the generated data sets                                               
//PRT#1    EXEC PGM=IEBGENER                                                    
//SYSPRINT DD  DUMMY                                                            
//SYSUT1   DD  DISP=OLD,DSN=&&DS1                                               
//SYSUT2   DD  SYSOUT=*,DCB=*.SYSUT1                                            
//SYSIN    DD  *                                                                
//* print the generated data sets                                               
//PRT#2    EXEC PGM=IEBGENER                                                    
//SYSPRINT DD  DUMMY                                                            
//SYSUT1   DD  DISP=OLD,DSN=&&DS2                                               
//SYSUT2   DD  SYSOUT=*,DCB=*.SYSUT1                                            
//SYSIN    DD  *                                                                
./ ADD NAME=IEBGENER                                                            
//HERC01GN JOB (ACCNT),'IEBGENER',CLASS=A,MSGCLASS=X                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//* copy "print" a data set with IEBGENER                                       
//*                                                                             
//PRT#1    EXEC PGM=IEBGENER                                                    
//SYSPRINT DD  DUMMY                                                            
//SYSUT1   DD  DISP=SHR,DSN=HERC01.TEST.CNTL(IEBGENER)                          
//SYSUT2   DD  SYSOUT=*,DCB=*.SYSUT1                                            
//SYSIN    DD  *                                                                
./ ADD NAME=IEBPTPCH                                                            
//HERC01PC JOB (ACCOUNT),'IebPtPch',CLASS=A,MSGCLASS=X                          
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//* print formatted data                                                        
//*                                                                             
//STEP1    EXEC  PGM=IEBPTPCH                                                   
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT2   DD  SYSOUT=*,DCB=(LRECL=133,RECFM=FB)                                
//SYSUT1   DD  DISP=SHR,DSN=HERC01.TEST.CNTL                                    
//SYSIN    DD  *                                                                
     PRINT TYPORG=PO,MAXNAME=1,MAXFLDS=1                                        
           RECORD FIELD=(80)                                                    
/*                                                                              
//SYSINXX  DD  * other possibilities (see utilities manual)                     
 PRINT TYPORG=PS,TOTCONV=XE                                                     
 TITLE ITEM=('PRINT PARTITIONED DIRECTORY OF PDS',10)                           
 TITLE ITEM=('FIRST TWO BYTES SHOW NUM OF USED BYTES',10)                       
 LABELS DATA=NO                                                                 
/*                                                                              
//NOTNOW   DD  *                                                                
           PRINT TYPORG=PO,PREFORM=A                                            
/*                                                                              
./ ADD NAME=IEFBR14                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=X                             
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
./ ADD NAME=IEHINITT                                                            
//HERC01IN JOB (ACCNT),'iehinitt',MSGCLASS=X,CLASS=A                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//* init a tape                                                                 
//* on msg IEC701D M 480,VOLUME TO BE LABELED HERC01                            
//*        mount a (new?) tape using hercules console and:                      
//*        devinit 480 newtape.aws                                              
//*                                                                             
//* after that reply to the wtor with M                                         
//*                                                                             
//*                                                                             
//IEHINITT EXEC PGM=IEHINITT,REGION=8000K                                       
//SYSPRINT DD  SYSOUT=*                                                         
//CARTRIDG DD  UNIT=(TAPE,1,DEFER)                                              
//SYSIN    DD  *                                                                
CARTRIDG   INITT SER=HERC01,OWNER='TK4-SYSPRO'                                  
//*                                                                             
./ ADD NAME=IEHLIST                                                             
//HERC01LI JOB (ACCNT),'IEHLIST',CLASS=A,MSGCLASS=X                             
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//* listpds                                                                     
//*                                                                             
//* The dasd volume to be printed (from) needs                                  
//* to be allocated to the job step.                                            
//*                                                                             
//* The DDNAME is irrelevant. Used V as DDNAME here.                            
//*                                                                             
//*                                                                             
//LISTPDS  EXEC PGM=IEHLIST,COND=((0,EQ),(0,NE))                                
//SYSPRINT DD  SYSOUT=*                                                         
//V        DD  DISP=SHR,UNIT=SYSALLDA,VOL=SER=PUB000                            
//SYSIN    DD  *                                                                
 LISTPDS DSNAME=SYS2.PROCLIB,VOL=3350=PUB000                                    
//*                                                                             
//* listvtoc                                                                    
//* Note:  there is a continuation "X" in pos 72 within the SYSIN               
//LISTVTOC EXEC PGM=IEHLIST COND=((0,EQ),(0,NE))                                
//SYSPRINT DD  SYSOUT=*                                                         
//V        DD  DISP=SHR,UNIT=SYSALLDA,VOL=SER=PUB000                            
//SYSIN    DD  *                                                                
 LISTVTOC FORMAT,VOL=SYSDA=PUB000,                                     X        
               DSNAME=(SYS2.PROCLIB)                                            
./ ADD NAME=INTRDR                                                              
//HERC01IR JOB (ACCNT),'INTRDR',CLASS=A,MSGCLASS=X                              
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//* Send data to the internal reader                                            
//* Stated otherwise: submit a job                                              
//*                                                                             
//ST1      EXEC  PGM=IEBGENER                                                   
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DUMMY                                                            
//SYSUT2   DD  SYSOUT=(,INTRDR)                                                 
//SYSUT1   DD  DATA,DLM=##                                                      
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
//HERC01BR JOB (ACCNT),'iefbr14',CLASS=A,MSGCLASS=A                             
//* just return, do nothing else                                                
//IEFBR14  EXEC PGM=IEFBR14                                                     
//*                                                                             
##                                                                              
./ ADD NAME=LISTIDR                                                             
==-->> See member LISTLOAD                                                      
./ ADD NAME=LISTLOAD                                                            
//HERC01LL JOB (ACCNT),'LISTLOAD',CLASS=A,MSGCLASS=X                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//* print loadmodule info                                                       
//* The PDS that contains the loadmodule needs te be                            
//* allocated the the DDNAME: SYSLIB                                            
//*                                                                             
//LISTLOAD EXEC PGM=AMBLIST,REGION=6M                                           
//SYSLIB   DD  DISP=SHR,DSN=SYS2.CMDLIB                                         
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
 LISTLOAD MEMBER=IND$FILE,OUTPUT=XREF                                           
//*                                                                             
//* other sysin samples:                                                        
//*                                                                             
//*  LISTIDR  MEMBER=IEFBR14                                                    
//*  LISTLOAD MEMBER=IDA0192A,OUTPUT=XREF,RELOC=2AFE000                         
//*                                                                             
./ ADD NAME=LISTPDS                                                             
==-->> See member IEHLIST                                                       
./ ADD NAME=MINIUNZP 0106-13279-13279-1219-00067-00069-00000-HERC01  40         
//HERC01UZ JOB (MINIUNZP),'MINIUNZP',CLASS=A,MSGCLASS=X                         
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  NAME: SYS2.JCLLIB(MINIUNZP)                                                
//*                                                                             
//*  DESC: Unzip a zip archive using MINIUNZ                                    
//*                                                                             
//*  Note: Each output file from the zip input is stored as a pds mbr           
//*                                                                             
//*  Note: This is a set of related samples:                                    
//*        Running these 5 members in this order is meant to                    
//*        illustrate their relationship to one another.                        
//*    MINIUNZP - Unzip a zip archive and store each file as PDS member         
//*    RECV370P - Receive the XMIT file (member),                               
//*               created as a result of MINIUNZP and create a PDS.             
//*    XMIT370P - Create an XMIT file from the PDS created in RECV370P.         
//*    MINIZIPP - Create a zip archive from the PDS created in RECV370P         
//*    MINIZIPS - Create a zip archive from the sequential XMIT file            
//*               created in XMIT370P.                                          
//*                                                                             
//********************************************************************          
//*                                                                             
//MINIUNZ PROC DUMMY='',          <=== Code 'DUMMY,' for stats only             
//           INDSN='missing',                                                   
//*         INFILE='missing',     <=== Single file name example                 
//*            EXT='.xmi',        <=== Single file name example                 
//          OUTPDS='missing',                                                   
//           ASCII=''             <=== Code '-l' for stats only                 
//*                                                                             
//* usage: miniunz -aclv zipfile dest_file [file_to_extract]                    
//* where: -a opens files in text-translated mode and converts                  
//*           ASCII to EBCDIC.                                                  
//*        -c chooses the alternate code-page 037 instead of the                
//*           default 1047.                                                     
//*        -l only lists statistics and files in the zip archive.               
//*        -v only lists statistics and files in the zip archive.               
//*                                                                             
//*        If no file_to_extract is specified, all files are                    
//*        extracted and the destination file will have (member)                
//*        automatically appended.                                              
//*                                                                             
//MINIUNZ EXEC PGM=MINIUNZ,                                                     
//* PARM='&ASCII dd:input dd:output &INFILE.&EXT' makeutil format               
//* PARM='&ASCII input output &INFILE.&EXT' to extract only one file            
//  PARM='&ASCII input output'                                                  
//*STEPLIB  DD DSN=&HLQ..MAKEUTIL.LINKLIB,DISP=SHR                              
//INPUT    DD  DSN=&INDSN,DISP=SHR                                              
//**          DCB=(LRECL=0,BLKSIZE=32760,RECFM=U)                               
//*OUTPUT   DD  DSN=&OUTPDS(&INFILE), Single file name                          
//OUTPUT   DD  &DUMMY.DSN=&OUTPDS,                                              
//             DISP=(NEW,CATLG),                                                
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),                            
//             SPACE=(TRK,(6000,2000,15),RLSE),                                 
//             VOL=SER=WORK03,UNIT=3390                                         
//SYSIN    DD  DUMMY                                                            
//STDOUT   DD  SYSOUT=*                                                         
//SYSPRINT DD  SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)                     
//SYSTERM  DD  SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)                     
//*                                                                             
// PEND                                                                         
//*                                                                             
//*   FOR STATS ONLY                                                            
//*                                                                             
//STEP010 EXEC PROC=MINIUNZ,                                                    
//**           COND=(0,LE),   <=== UNCOMMENT TO BYPASS THIS STEP                
//            ASCII='-l',                                                       
//            INDSN='TK4-.JIM.CBT571.XMIT370.ZIP',                              
//            DUMMY='DUMMY,',OUTPDS='DUMMY'                                     
//*                                                                             
//*   FOR ACTUAL UNZIP                                                          
//*                                                                             
//STEP020 EXEC PROC=MINIUNZ,                                                    
//            INDSN='*.STEP010.MINIUNZ.INPUT',                                  
//*          INFILE='FILE571',    <=== Single file name example                 
//*            EXT='.xmi',        <=== Single file name example                 
//          OUTPDS='TK4-.JIM.CBT571.XMIT370.UNZIP'                              
//                                                                              
./ ADD NAME=MINIZIPP 0105-13293-13303-1406-00060-00058-00000-HERC01  41         
//HERC01ZP JOB (MINIZIPP),'MINIZIPP',CLASS=A,MSGCLASS=X,NOTIFY=HERC01,          
//  REGION=4096K                                                                
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  NAME: SYS2.JCLLIB(MINIZIPP)                                                
//*                                                                             
//*  DESC: Zip a PDS using MINIZIP                                              
//*                                                                             
//*  Note: Each member in the PDS is stored as a file in the                    
//*        zip archive.                                                         
//*                                                                             
//*  Note: This is a set of related samples:                                    
//*        Running these 5 members in this order is meant to                    
//*        illustrate their relationship to one another.                        
//*    MINIUNZP - Unzip a zip archive and store each file as PDS member         
//*    RECV370P - Receive the XMIT file (member),                               
//*               created as a result of MINIUNZP and create a PDS.             
//*    XMIT370P - Create an XMIT file from the PDS created in RECV370P.         
//*    MINIZIPP - Create a zip archive from the PDS created in RECV370P         
//*    MINIZIPS - Create a zip archive from the sequential XMIT file            
//*               created in XMIT370P.                                          
//*                                                                             
//* Here is an example of MINIZIP                                               
//*                                                                             
//* usage: minizip -abcolx zipfile files_to_add                                 
//* where: -a opens files_to_add in text-translated mode and                    
//*           converts EBCDIC to ASCII.                                         
//*        -b zips files without length indicators (use with V,VB               
//*           or U datasets only).                                              
//*        -c chooses the alternate code-page 037 instead of the                
//*           default 1047.                                                     
//*        -o specifies that all files_to_add are Partition                     
//*           Organised datasets (PDS) and that all members/alias's             
//*           in each dataset should be zipped.                                 
//*                                                                             
//*        SYSUT1 and zipfile need to be allocated as F/FB with any             
//*        LRECL and BLKSIZE.                                                   
//*                                                                             
//ZIPMINI  PROC VOL='PUB003'                                                    
//*                                                                             
//MINIZIP  EXEC PGM=MINIZIP,PARM='-a -o output input'                           
//INPUT    DD DSN=TK4-.JIM.CBT571.XMIT370.PDS,DISP=SHR                          
//OUTPUT   DD DSN=TK4-.JIM.CBT571.XMIT370.PDS.ZIP,DISP=(NEW,CATLG),             
//         DCB=(RECFM=VB,LRECL=255,BLKSIZE=15050),                              
//         SPACE=(TRK,(11,1)),VOL=SER=&VOL,UNIT=SYSALLDA                        
//SYSIN    DD DUMMY                                                             
//STDOUT   DD SYSOUT=*                                                          
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)                      
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)                      
//*                                                                             
//* SYSUT1   = Temporary work space                                             
//SYSUT1   DD DSN=&&TEMP2,DISP=(,DELETE),                                       
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),                                
//         SPACE=(CYL,(20,20)),UNIT=SYSALLDA                                    
// PEND                                                                         
//*                                                                             
//S1 EXEC PROC=ZIPMINI                                                          
//                                                                              
./ ADD NAME=MINIZIPS 0104-13294-13303-1407-00060-00058-00000-HERC01  37         
//HERC01ZS JOB (MINIZIPS),'MINIZIPS',CLASS=A,MSGCLASS=X,NOTIFY=HERC01,          
//  REGION=4096K                                                                
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  NAME: SYS2.JCLLIB(MINIZIPS)                                                
//*                                                                             
//*  DESC: Zip a sequential file using MINIZIP                                  
//*                                                                             
//*  Note: A zip archive is created from the input sequential file.             
//*                                                                             
//*  Note: This is a set of related samples:                                    
//*        Running these 5 members in this order is meant to                    
//*        illustrate their relationship to one another.                        
//*    MINIUNZP - Unzip a zip archive and store each file as PDS member         
//*    RECV370P - Receive the XMIT file (member),                               
//*               created as a result of MINIUNZP and create a PDS.             
//*    XMIT370P - Create an XMIT file from the PDS created in RECV370P.         
//*    MINIZIPP - Create a zip archive from the PDS created in RECV370P         
//*    MINIZIPS - Create a zip archive from the sequential XMIT file            
//*               created in XMIT370P.                                          
//*                                                                             
//* Here is an example of MINIZIP                                               
//*                                                                             
//* usage: minizip -abcolx zipfile files_to_add                                 
//* where: -a opens files_to_add in text-translated mode and                    
//*           converts EBCDIC to ASCII.                                         
//*        -b zips files without length indicators (use with V,VB               
//*           or U datasets only).                                              
//*        -c chooses the alternate code-page 037 instead of the                
//*           default 1047.                                                     
//*        -o specifies that all files_to_add are Partition                     
//*           Organised datasets (PDS) and that all members/alias's             
//*           in each dataset should be zipped.                                 
//*                                                                             
//*        SYSUT1 and zipfile need to be allocated as F/FB with any             
//*        LRECL and BLKSIZE.                                                   
//*                                                                             
//ZIPMINI  PROC VOL='PUB003'                                                    
//*                                                                             
//MINIZIP  EXEC PGM=MINIZIP,PARM='output FILE571'                               
//FILE571  DD DSN=TK4-.JIM.CBT571.XMIT370.PDS.XMIT,DISP=SHR                     
//OUTPUT   DD DSN=TK4-.JIM.CBT571.XMIT370.PDS.XMIT.ZIP,                         
//            DISP=(NEW,CATLG),                                                 
//            DCB=(RECFM=VB,LRECL=255,BLKSIZE=15050),                           
//            SPACE=(TRK,(11,1)),VOL=SER=&VOL,UNIT=SYSALLDA                     
//SYSIN    DD DUMMY                                                             
//STDOUT   DD SYSOUT=*                                                          
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)                      
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,LRECL=132,BLKSIZE=132)                      
//*                                                                             
//* SYSUT1   = Temporary work space                                             
//SYSUT1   DD DSN=&&TEMP2,DISP=(,DELETE),                                       
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),                                
//         SPACE=(CYL,(20,20)),UNIT=SYSALLDA                                    
// PEND                                                                         
//*                                                                             
//S1 EXEC PROC=ZIPMINI                                                          
//                                                                              
./ ADD NAME=OFFLOAD                                                             
//HERC01OL JOB (OFFLOAD),'offload pds members',CLASS=A,MSGCLASS=X               
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(OFFLOAD)                                                 
//*                                                                             
//*  Desc: OFFLOAD members from PDS to a sequential data set                    
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//OFFLOAD  EXEC PGM=OFFLOAD,REGION=256K                                         
//SYSPRINT DD  SYSOUT=*                                                         
//PDS      DD  DISP=SHR,DSN=HERC01.TEST.CNTL                                    
//SEQ      DD  DSN=HERC01.TEST.CNTL.UNLOAD,DISP=(,CATLG),UNIT=SYSDA,            
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=5600),                            
//             SPACE=(TRK,(5,5),RLSE)                                           
//SYSIN    DD  * select PDSLOAD only                                            
  O I=PDS,O=SEQ,T=IEBUPDTE                                                      
  S M=PDSLOAD                                                                   
//* //SYSIN    DD * EXclude @@@INDEX                                            
//*   O I=PDS,O=SEQ,T=IEBUPDTE                                                  
//*   E M=@@@INDEX                                                              
//*                                                                             
./ ADD NAME=PDSUPDTE                                                            
//HERC01UP JOB (PDSUPDTE),'SAMPLE JOB',CLASS=A,MSGCLASS=X                       
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(PDSUPDTE)                                                
//*                                                                             
//*  Desc: Tailor "all" members in a PDS                                        
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Documentation can be found in TK4-.PHIL.PDSUPDTE.ZIP.                      
//*     This doc is a zipped pdf.                                               
//*     On MVS in a 3270 session extract pdf from TK4-.PHIL.PDSUPDTE.ZIP        
//*                                                                             
//*  rfe -> "D" use mask: TK4-.PHIL.PDSUPDTE.ZIP                                
//*  "B" - browse the data set                                                  
//*  enter CUT on the command line                                              
//*  to copy the extracted PDF to a data set:                                   
//*  Enter an intermediate dsname, e.g.:                                        
//*  SPECIFY OUTPUT SEQUENTIAL DATA SET NAME                                    
//*         ==> PDSUPDTE.PDF                                                    
//*  This results in data set <yourPrefix>.PDSUPDTE.PDF                         
//*  This data set is allocated if did not exist before.                        
//*                                                                             
//*  Donwload this data set to your PC in BINARY                                
//*  E.g. pdsupdte.pdf                                                          
//*                                                                             
//********************************************************************          
//*                                                                             
//EXAMPLE  EXEC PGM=PDSUPDTE,PARM=CHECK  to verify first                        
//*                          PARM=UPDATE after check is OK                      
//SYSPRINT DD  SYSOUT=*                                                         
//@TEST    DD  DISP=SHR,DSN=HERC01.TEST.CNTL                                    
//* short explanation:                                                          
//*                                                                             
//* replace all occurrences of MSGCLASS=A and MSGCLASS=X -> MSGCLASS=C          
//* MSGCLASS=A<MSGCLASS=C<                                                      
//* MSGCLASS=X<MSGCLASS=C<                                                      
//*                                                                             
//* replace all occurrences of SYSOUT=A -> SYSOUT=C                             
//* SYSOUT=A<SYSOUT=*<                                                          
//*                                                                             
//* replace all occurrences of SYS2 -> HERC01 if the line has JCLLIB            
//* SYS2<HERC01<JCLLIB<                                                         
//*                                                                             
//* FIND    all occurrences of the word CLASS                                   
//* CLASS<CLASS<                                                                
//SYSIN    DD  *                                                                
MSGCLASS=A<MSGCLASS=C<                                                          
MSGCLASS=X<MSGCLASS=C<                                                          
SYSOUT=A<SYSOUT=*<                                                              
SYS2<HERC01<JCLLIB<                                                             
CLASS<CLASS<                                                                    
/*                                                                              
./ ADD NAME=XMIT370P 0113-13274-13279-1201-00054-00017-00000-HERC01  51         
//HERC01XP JOB (XMIT370),'XMIT PDS',CLASS=A,MSGCLASS=X,NOTIFY=HERC01            
//* USER=HERC01,PASSWORD=XXXXXXXX                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(XMIT370P)                                                
//*                                                                             
//*  Desc: Create an xmit data set from an input PDS data set                   
//*                                                                             
//*  Note: Uses instream procedure                                              
//*                                                                             
//*  Note: This is a set of related samples:                                    
//*        Running these 5 members in this order is meant to                    
//*        illustrate their relationship to one another.                        
//*    MINIUNZP - Unzip a zip archive and store each file as PDS member         
//*    RECV370P - Receive the XMIT file (member),                               
//*               created as a result of MINIUNZP and create a PDS.             
//*    XMIT370P - Create an XMIT file from the PDS created in RECV370P.         
//*    MINIZIPP - Create a zip archive from the PDS created in RECV370P         
//*    MINIZIPS - Create a zip archive from the sequential XMIT file            
//*               created in XMIT370P.                                          
//*                                                                             
//*                                                                             
//********************************************************************          
//*                                                                             
//XMIT370 PROC XMI='missing', XMI - OUTput xmit data set                        
//             PDS='missing', PDS - INput pds data set                          
//             SPA='600,150', Primary and secondary SPACE (in trk)              
//             VOL=WORK03     Target dasd volume                                
//XMIT370  EXEC PGM=XMIT370                                                     
//*STEPLIB  DD DSN=SYS2.LOCAL.LINKLIB,DISP=SHR                                  
//SYSPRINT DD  SYSOUT=*                                                         
//XMITPRT  DD  SYSOUT=*                                                         
//XMITLOG  DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//*                                                                             
//* SYSUT1   = PDS input data set                                               
//SYSUT1   DD  DSN=&PDS,DISP=SHR                                                
//*                                                                             
//* SYSUT2   = Temporary work space                                             
//SYSUT2   DD  DISP=(,DELETE,DELETE),DSN=&&SYSUT2,                              
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//             SPACE=(TRK,(&SPA))                                               
//*                                                                             
//* XMITOUT  = XMIT output data set                                             
//XMITOUT  DD  DISP=(,CATLG),DSN=&XMI,                                          
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//* DCB info is ignored                                                         
//*            DCB=(LRECL=80,BLKSIZE=3200,DSORG=PS,RECFM=FB),                   
//             SPACE=(TRK,(&SPA))                                               
//SYSIN    DD  DUMMY                                                            
//         PEND                                                                 
//*                                                                             
//********************************************************************          
//* call the procedure                                                          
//********************************************************************          
//*                                                                             
//XMIT1DS  EXEC XMIT370,                                                        
//**           PDS='HERC01.PDSLOAD.RECEIVED.PDS',                               
//**           XMI='HERC01.PDSLOAD.XM',                                         
//             PDS='TK4-.JIM.CBT571.XMIT370.PDS',       input                   
//             XMI='TK4-.JIM.CBT571.XMIT370.PDS.XMIT',   output                 
//             SPA='065,005', Primary and secondary SPACE (in trk)              
//**           VOL=WORK03     Target dasd volume                                
//             VOL=PUB003     Target dasd volume                                
//*                                                                             
//*                                                                             
./ ADD NAME=PUNPDSXM                                                            
//HERC01XP JOB (PUNPDSXM),'XMIT PDS',CLASS=A,MSGCLASS=C                         
//* USER=HERC01,PASSWORD=XXXXXXXX                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(PUNPDSXM)                                                
//*                                                                             
//*  Desc: Punch an input PDS data set XMITted to a punch data set              
//*        xmitted data set is sent to the punch device on unit 00D,            
//*        on the PC where Hercules is running                                  
//*                                                                             
//*  Note: Uses instream procedure                                              
//*                                                                             
//*  Note: verify various things:                                               
//*        punch1 assumed on unit 00D                                           
//*        punch1 assumed to be free                                            
//*        Hercules device 00D is overwriting target file                       
//*                 at pch\'name of input PDS'.xm                               
//*                                                                             
//*                                                                             
//********************************************************************          
//*                                                                             
//XM#PUNCH PROC XMO='missing', XMO - OUTput xmit data set                       
//             PDS='missing',  PDS - INput pds data set                         
//             SPA='600,150',  Primary and secondary SPACE (in trk)             
//             VOL=WORK03,     Target dasd volume                               
//             PUNDIR='pch',   Target destination                               
//             PUNDEV='10D',   Target punch unit                                
//             PUNDFN0='pch/pch10d.txt ascii' ORIG devinit parms                
//XMIT370  EXEC PGM=XMIT370                                                     
//*STEPLIB  DD DSN=SYS2.LOCAL.LINKLIB,DISP=SHR                                  
//SYSPRINT DD  SYSOUT=*                                                         
//XMITPRT  DD  SYSOUT=*                                                         
//XMITLOG  DD  SYSOUT=*                                                         
//SYSUDUMP DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=&PDS           PDS input data set                   
//XMITOUT  DD  DISP=(,CATLG),DSN=&XMO,     XMIT output data set                 
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//* DCB info is ignored                                                         
//*            DCB=(LRECL=80,BLKSIZE=3200,DSORG=PS,RECFM=FB),                   
//             SPACE=(TRK,(&SPA),RLSE)                                          
//*                                                                             
//*            Temporary work space                                             
//SYSUT2   DD  DISP=(,DELETE,DELETE),DSN=&&SYSUT2,                              
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//             SPACE=(TRK,(&SPA))                                               
//SYSIN    DD  DUMMY                                                            
//* first display CURRENT status MVS and Hercules                               
//CMD0M    EXEC PGM=BSPOSCMD,COND=(5,LT),PARM=' D U,,,&PUNDEV,1'                
//CMD0H    EXEC PGM=BSPHRCMD,COND=(5,LT),PARM=' devlist &PUNDEV'                
//WAIT#1   EXEC PGM=DELAY,COND=(5,LT),PARM='1'                                  
//*                                                                             
//*        Prepare controlcard for BSPHRCMD                                     
//*        to set the output file                                               
//*                                                                             
//* Note:  Verify on the hercules console that this                             
//*        command completes correctly!                                         
//*                                                                             
//CMD2PREP EXEC PGM=BSPPA2SI,COND=(5,LT),                                       
//    PARM=' devinit &PUNDEV &PUNDIR\&XMO ' ! binary not ASCII                  
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(TRK,(1,1))                          
//*                                                                             
//CMD2     EXEC PGM=BSPHRCMD,COND=(5,LT)                                        
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.CMD2PREP.SYSUT1                          
//*                                                                             
//* ========================================================                    
//* Copy the data set to the punch device                                       
//* ========================================================                    
//COPY#PUN EXEC PGM=IEBGENER,COND=(5,LT)                                        
//SYSPRINT DD  DUMMY                                                            
//SYSUT1   DD  DISP=SHR,DSN=&XMO                                                
//SYSUT2   DD  UNIT=&PUNDEV,DCB=(LRECL=80,RECFM=F,BLKSIZE=80)                   
//SYSIN    DD  DUMMY                                                            
//*                                                                             
//* close the punch file and reset the hercules device                          
//*                                                                             
//CMD3PREP EXEC PGM=BSPPA2SI,COND=(5,LT),                                       
//    PARM=' devinit &PUNDEV &PUNDFN0'                                          
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(TRK,(1,1))                          
//CMD3     EXEC PGM=BSPHRCMD,COND=(5,LT)                                        
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.CMD3PREP.SYSUT1                          
//*                                                                             
//WAIT#2   EXEC PGM=DELAY,COND=(5,LT),PARM='1'                                  
//XM#PUNCH PEND                                                                 
//*                                                                             
//********************************************************************          
//* call the procedure                                                          
//********************************************************************          
//*                                                                             
//XMIT1DS  EXEC XM#PUNCH,                                                       
//             PDS='HERC01.RMFPRT.CNTL',       input                            
//             XMO='HERC01.RMFPRT.CNTL.XM',    output                           
//             SPA='065,005', Primary and secondary SPACE (in trk)              
//             VOL=WORK03     Target dasd volume                                
//*                                                                             
./ ADD NAME=RD#PDSXM                                                            
//HERC01RX JOB (RD#PDSXM),'Recv PDS from PC',CLASS=A,MSGCLASS=C                 
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(RD#PDSXM)                                                
//*                                                                             
//*  Desc: Read an xmitted PDS data set from a PC file                          
//*        xmitted PDS is received into a new PDS                               
//*                                                                             
//*  Note: Uses instream procedure                                              
//*                                                                             
//*  Note: verify various things:                                               
//*        reader  assumed on unit 10C                                          
//*        reader  assumed to be NOT in use                                     
//*        Hercules device 10C will read PC data set                            
//*        by default at pch\'name of input XMI'                                
//*        Hercules device 10C will be set back to:                             
//*        010C 3505 jcl/dummy eof ascii trunc                                  
//*  Note WARNING 1:                                                            
//*        The combined filepath filename can not be too long.                  
//*        Put the file to be read in the pch directory and                     
//*        keep the filename short.                                             
//*  Note WARNING 2:                                                            
//*        If the PC file does not exist a loop occurs in RECV370               
//*        You have to cancel the job to get out of that.                       
//*        Symptom on the hercules log console:                                 
//*          HHC01200E 0:010C Card:                                             
//*                    error in function access(): No such file or directory    
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//XM#READ  PROC XMI='missing', XMI - INput xmit data set from PC                
//             PDS='missing',  PDS - OUTput pds data set                        
//             SPA='600,150',  Primary and secondary SPACE (in trk)             
//             VOL=WORK03,     Target dasd volume                               
//             BLK='3120',     Blocksize                                        
//             DIR=40,         Number of directory blocks for PDS               
//             RDRDIR='pch',   Source reader directory                          
//             RDRDEV='10C',   Source reader unit                               
//             RDRDFN0='jcl/dummy eof ascii trunc' orig devinit parms           
//*                                                                             
//* Display reader device                                                       
//*                                                                             
//CMD0     EXEC PGM=BSPOSCMD,COND=(5,LT),PARM=' D U,,,&RDRDEV,1'                
//CMD1     EXEC PGM=BSPHRCMD,COND=(5,LT),PARM=' devlist &RDRDEV '               
//CMD2     EXEC PGM=BSPOSCMD,COND=(5,LT),PARM=' V &RDRDEV,ONLINE'               
//WAIT02   EXEC PGM=DELAY,COND=(5,LT),PARM='1'                                  
//*                                                                             
//*        Prepare controlcard for BSPHRCMD (define INput file)                 
//*                                                                             
//CMD3PREP EXEC PGM=BSPPA2SI,COND=(5,LT),                                       
//    PARM=' devinit &RDRDEV &RDRDIR/&XMI ebcdic eof    '                       
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(TRK,(1,1))                          
//CMD3     EXEC PGM=BSPHRCMD,COND=(5,LT)                                        
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.CMD3PREP.SYSUT1                          
//*                                                                             
//*        Prepare controlcard for BSPHRCMD to list                             
//*                                                                             
//CMDLPREP EXEC PGM=BSPPA2SI,COND=(5,LT),                                       
//    PARM=' devlist &RDRDEV                 '                                  
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(TRK,(1,1))                          
//CMDLIST  EXEC PGM=BSPHRCMD,COND=(5,LT)                                        
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.CMDLPREP.SYSUT1                          
//*                                                                             
//* Copy the data set FROM the punch device                                     
//*                                                                             
//COPY#PUN EXEC PGM=IEBGENER,COND=(5,LT)                                        
//SYSPRINT DD  DUMMY                                                            
//SYSUT2   DD  DISP=(,PASS),               read INput data set                  
//             UNIT=SYSALLDA,              VOL=SER=&VOL,                        
//             DCB=(LRECL=80,BLKSIZE=3200,DSORG=PS,RECFM=FB),                   
//             SPACE=(TRK,(&SPA),RLSE)                                          
//SYSUT1   DD  UNIT=&RDRDEV,                                                    
//             DCB=(LRECL=80,BLKSIZE=80,DSORG=PS,RECFM=F)                       
//SYSIN    DD  DUMMY                                                            
//*                                                                             
//* close the punch file and reset the reader                                   
//*                                                                             
//CMD4PREP EXEC PGM=BSPPA2SI,COND=EVEN, even after abend!                       
//    PARM=' devinit &RDRDEV &RDRDFN0 '                                         
//SYSUT1   DD  DISP=(,PASS),UNIT=VIO,SPACE=(TRK,(1,1))                          
//CMD4     EXEC PGM=BSPHRCMD,COND=EVEN  even after abend!                       
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DISP=(OLD,DELETE),DSN=*.CMD4PREP.SYSUT1                          
//*                                                                             
//* receive the data set into a PDS                                             
//*                                                                             
//RECV370  EXEC PGM=RECV370,COND=(5,LT)                                         
//RECVLOG  DD  SYSOUT=*                                                         
//SYSTSPRT DD  SYSOUT=*                                                         
//SYSPRINT DD  SYSOUT=*,DCB=(RECFM=FB,LRECL=121,BLKSIZE=12100)                  
//SYSTERM  DD  SYSOUT=*                                                         
//SYSABEND DD  DUMMY                                                            
//*                                                                             
//XMITIN   DD  DISP=OLD,DSN=*.COPY#PUN.SYSUT2                                   
//SYSUT2   DD  DISP=(,CATLG),DSN=&PDS, PDS output data set                      
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//             DCB=(LRECL=80,BLKSIZE=&BLK,DSORG=PO,RECFM=FB),                   
//             SPACE=(TRK,(&SPA,&DIR),RLSE)                                     
//*                                                                             
//*            PDS Sequential unloaded temporary                                
//SYSUT1   DD  DISP=(,DELETE,DELETE),DSN=&&SYSUT1,                              
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//             SPACE=(TRK,(&SPA))                                               
//SYSIN    DD  DUMMY                                                            
//XM#READ  PEND =============================================                   
//* ******************************************************************          
//* call the procedure                                                          
//********************************************************************          
//*                                                                             
//RD#ASM   EXEC XM#READ,                                                        
//             XMI='HERC01.TEST.ASM.XM',       INput from PC                    
//             PDS='HERC01.TEST.ASM2',        OUTput                            
//             SPA='065,005', Primary and secondary SPACE (in trk)              
//             VOL=WORK03     Target dasd volume                                
//*                                                                             
./ ADD NAME=RECV370P 0107-13274-13279-1216-00056-00053-00000-HERC01  23         
//HERC01RP JOB (RECV370P),'RECV PDS',CLASS=A,MSGCLASS=X,NOTIFY=HERC01           
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(RECV370P)                                                
//*                                                                             
//*  Desc: Receive the XMIT file (member),                                      
//*        created as a result of MINIUNZP and create a PDS.                    
//*                                                                             
//*  Note: Uses instream procedure                                              
//*                                                                             
//*  Note: This is a set of related samples:                                    
//*        Running these 5 members in this order is meant to                    
//*        illustrate their relationship to one another.                        
//*    MINIUNZP - Unzip a zip archive and store each file as PDS member         
//*    RECV370P - Receive the XMIT file (member),                               
//*               created as a result of MINIUNZP and create a PDS.             
//*    XMIT370P - Create an XMIT file from the PDS created in RECV370P.         
//*    MINIZIPP - Create a zip archive from the PDS created in RECV370P         
//*    MINIZIPS - Create a zip archive from the sequential XMIT file            
//*               created in XMIT370P.                                          
//*                                                                             
//********************************************************************          
//*                                                                             
//RECV370 PROC XMI=FORGOTTEN, XMI - INput xmit data set                         
//             PDS=FORGOTTEN, PDS - OUTput pds data set                         
//             SPA='600,150', Primary and secondary SPACE (in trk)              
//             BLK='3120',    Blocksize                                         
//             DIR=40,        Number of directory blocks for PDS                
//             VOL=WORK03     Target dasd volume                                
//RECV370  EXEC PGM=RECV370                                                     
//RECVLOG  DD  SYSOUT=*                                                         
//SYSTSPRT DD  SYSOUT=*                                                         
//SYSPRINT DD  SYSOUT=*,DCB=(RECFM=FB,LRECL=121,BLKSIZE=12100)                  
//SYSTERM  DD  SYSOUT=*                                                         
//SYSABEND DD  DUMMY                                                            
//*                                                                             
//* XMITIN   = Input data set. Must be FB 80                                    
//XMITIN   DD  DISP=SHR,DSN=&XMI                                                
//*                                                                             
//* SYSUT1   = PDS unloaded (Sequential unloaded) temporary                     
//SYSUT1   DD  DISP=(,DELETE,DELETE),DSN=&&SYSUT1,                              
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//             SPACE=(TRK,(&SPA))                                               
//*                                                                             
//* SYSUT2   = PDS output data set                                              
//SYSUT2   DD  DISP=(,CATLG),DSN=&PDS,                                          
//             UNIT=SYSALLDA,VOL=SER=&VOL,                                      
//             DCB=(LRECL=80,BLKSIZE=&BLK,DSORG=PO,RECFM=FB),                   
//             SPACE=(TRK,(&SPA,&DIR))                                          
//SYSIN    DD  DUMMY                                                            
//         PEND                                                                 
//*                                                                             
//********************************************************************          
//* call the procedure                                                          
//********************************************************************          
//*                                                                             
//RECEIVE  EXEC RECV370,                                                        
//**           XMI='HERC01.PDSLOAD.XM',                                         
//**           PDS='HERC01.PDSLOAD.RECEIVED.PDS',                               
//             XMI='TK4-.JIM.CBT571.XMIT370.UNZIP(FILE571)',                    
//             PDS='TK4-.JIM.CBT571.XMIT370.PDS',                               
//             SPA='065,005', Primary and secondary SPACE (in trk)              
//             BLK='6160',    Blocksize                                         
//             DIR=40,        Number of directory blocks for PDS                
//**           VOL=WORK03     Target dasd volume                                
//             VOL=PUB003     Target dasd volume                                
//*                                                                             
./ ADD NAME=RECV370S                                                            
//HERC01RS JOB (RECV370S),'RECV SEQ',CLASS=A,MSGCLASS=X                         
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(RECV370S)                                                
//*                                                                             
//*  Desc: Receive xmitted data set back into SEQUENTIAL data set               
//*                                                                             
//********************************************************************          
//*                                                                             
//RECV370  EXEC PGM=RECV370                                                     
//RECVLOG  DD  SYSOUT=*                                                         
//SYSPRINT DD  SYSOUT=*                                                         
//*                                                                             
//* XMITIN - INput: the XMITTED data set                                        
//XMITIN   DD  DISP=SHR,DSN=HERC01.FB80.DATA                                    
//*                                                                             
//* SYSUT1 - OUTput the data set to receive the sequential data                 
//SYSUT1   DD  DSN=HERC01.RECV370.DEMO.SEQ,                                     
//             UNIT=SYSDA,VOL=SER=WORK03,                                       
//             SPACE=(TRK,(60,60),RLSE),                                        
//             DISP=(,CATLG,DELETE)                                             
//SYSIN    DD  DUMMY                                                            
//SYSUDUMP DD  SYSOUT=*                                                         
./ ADD NAME=RENMEMBR                                                            
//HERC01RM JOB (RENMEMBR),'save current',CLASS=A,MSGCLASS=X                     
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(RENMEMBR)                                                
//*                                                                             
//*  Desc: Copy+rename member(s) before replacing it                            
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//REN#OLD  EXEC PGM=IEBCOPY,PARM='SIZE=999K',REGION=4000K                       
//PROD     DD  DISP=SHR,DSN=SYS2.LINKLIB                                        
//*                                                                             
//* DCB should be compatible with that of the dd PROD                           
//TEMP     DD  DISP=(,PASS),                                                    
//         DCB=(RECFM=U,BLKSIZE=19069),                                         
//         SPACE=(TRK,(30,30,43),RLSE),UNIT=SYSALLDA                            
//SYSPRINT DD  SYSOUT=*                                                         
//*                                                                             
//* Sequence here is:                                                           
//* - copy members to TEMP                                                      
//* - copy members back to PROD DD while renaming.                              
//SYSIN    DD  *                                                                
 C I=PROD,O=TEMP                                                                
 S M=MVSDDT                                                                     
 S M=DDTSYM                                                                     
 C O=PROD,I=TEMP                                                                
 S M=((MVSDDT,@MVSDDT,R))                                                       
 S M=((DDTSYM,@DDTSYM,R))                                                       
//*                                                                             
./ ADD NAME=READOMAT                                                            
//HERC01U JOB ('readOMAt'),'Read CBT zip to PDS',                               
//          CLASS=A,                                                            
//          MSGCLASS=X,                                                         
//          MSGLEVEL=(1,1),                                                     
//          NOTIFY=HERC01                                                       
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//*********************************************************************         
//*                                                                             
//*  Name : SYS2.JCLLIB(READOMAT)                                               
//*                                                                             
//*  Desc : Read a CBT partitioned dataset directly from the original           
//*         ZIP archive, which is to be presented as an OMA tape using          
//*         the following file definition,                                      
//*                                                                             
//*  Note : This example JCL is based upon:                                     
//*         - TDF file to be located in the *tapes* subdirectory                
//*               located below the directory                                   
//*               where Hercules has been started from.                         
//*         - CBT ZIP should reside in the *tapes/data* subdirectory.           
//*                                                                             
//*  Example CBT478.tdf:                                                        
//*    | <-Pos 1                                                                
//*    |@TDF ; TDF in CAPS! This is file # 478 RAWSTAPE from Jan Jaeger         
//*    |data/CBT478.zip FIXED RECSIZE 6144                                      
//*    |* DOC: Make sure the TM and EOT records below are in CAPITALS           
//*    |*      and have NO trailing spaces                                      
//*    |TM                                                                      
//*    |TM                                                                      
//*    |EOT                                                                     
//*                                                                             
//*  Note: If you get this message on the console:                              
//*        IGF509D  REPLY DEVICE, OR 'NO'                                       
//*        then reply NO and check:                                             
//*        - the Hercules log (did the devinit work OK?)                        
//*        - your job, maybe an error in the TDF name or location               
//*********************************************************************         
//*                                                                             
//OMA2PDS  PROC TAPUNIT='480',                                                  
//           VOLSER='PCTOMF',                                                   
//          TDFNAME='CBT478',                                                   
//          TOPRFIX='HERC01.CBT', output PDS prefix                             
//           TONAME='FILE478',    output PDS middle                             
//          TOSUFIX='.PDS',       output PDS suffix                             
//          XMSUFIX='.XMI',       XMIT ds in ZIP suffix                         
//          WRKUNIT='SYSDA',      Work dasd                                     
//           TOUNIT='SYSDA',      Target for output PDS                         
//            ASCII=''                                                          
//* vary online just to be sure                                                 
//VARY#ON  EXEC PGM=BSPOSCMD,PARM='VARY &TAPUNIT,ONLINE'                        
//*                                                                             
//UNMOUNT1 EXEC PGM=BSPOSCMD,PARM='u &TAPUNIT'                                  
//DELAY1   EXEC PGM=DELAY,PARM='1'                                              
//MOUNTTAP EXEC PGM=BSPOSCMD,PARM='m &TAPUNIT,vol=(NL,&VOLSER)'                 
//DELAY2   EXEC PGM=DELAY,PARM='1'                                              
//DEVINIT1 EXEC PGM=BSPHRCMD,                                                   
// PARM='devinit &TAPUNIT tapes/&TDFNAME..tdf'                                  
//*                                                                             
//* read CBT file from tape                                                     
//*                                                                             
//READOMA  EXEC PGM=IEBGENER                                                    
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  DUMMY                                                            
//SYSUT1   DD  DISP=(OLD,KEEP,KEEP),                                            
//             DCB=(RECFM=U,LRECL=0,BLKSIZE=32760),                             
//             VOL=SER=&VOLSER,                                                 
//             UNIT=(&TAPUNIT,,DEFER),LABEL=(1,NL)                              
//SYSUT2   DD  DSN=&&ZIP,DISP=(NEW,PASS),                                       
//             DCB=*.SYSUT1,                                                    
//             SPACE=(TRK,(10,10),RLSE),UNIT=&WRKUNIT                           
//*                                                                             
//*                                                                             
//UNMOUNT1 EXEC PGM=BSPOSCMD,PARM='u &TAPUNIT'                                  
//*                                                                             
//* list the zip just in case...                                                
//*                                                                             
//LISTZIP  EXEC PGM=MINIUNZ,PARM='-vl ZIPIN '                                   
//STDOUT   DD  SYSOUT=*                                                         
//ZIPIN    DD  DSN=&&ZIP,DISP=(OLD,PASS)                                        
//*                                                                             
//* unzip CBT file                                                              
//*                                                                             
//UNZIP   EXEC PGM=MINIUNZ,                                                     
//        PARM='&ASCII ZIPIN FILEOUT &TONAME.&XMSUFIX',                         
//        COND=(0,NE,READOMA)                                                   
//STDOUT   DD SYSOUT=*                                                          
//ZIPIN    DD DSN=&&ZIP,DISP=(OLD,DELETE)                                       
//FILEOUT  DD DSN=&&XMI,DISP=(NEW,PASS),                                        
//            UNIT=&WRKUNIT,SPACE=(TRK,(50,10)),                                
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=3200,DSORG=PS)                     
//*                                                                             
//* delete the output target                                                    
//*                                                                             
//DELIT    EXEC PGM=IEFBR14,                                                    
//         COND=((0,NE,READOMA),(0,NE,UNZIP))                                   
//SYSUT2   DD  DSN=&TOPRFIX..&TONAME.&TOSUFIX,                                  
//         DISP=(MOD,DELETE),SPACE=(TRK,1),                                     
//         UNIT=SYSALLDA                                                        
//*                                                                             
//* receive CBT file                                                            
//*                                                                             
//RECV370 EXEC PGM=RECV370,                                                     
//         COND=((0,NE,READOMA),(0,NE,UNZIP))                                   
//RECVLOG  DD SYSOUT=*                                                          
//XMITIN   DD DSN=&&XMI,DISP=(OLD,DELETE)                                       
//SYSPRINT DD SYSOUT=*                                                          
//SYSUT1   DD DSN=&&SYSUT1,DISP=(NEW,DELETE,DELETE),                            
//            SPACE=(CYL,(100,50)),UNIT=&WRKUNIT                                
//SYSUT2   DD DSN=&TOPRFIX..&TONAME.&TOSUFIX,                                   
//            DISP=(NEW,CATLG),SPACE=(TRK,(180,180,40)),                        
//            UNIT=&TOUNIT                                                      
//SYSIN    DD DUMMY                                                             
//OMA2PDS  PEND                                                                 
//*                                                                             
//S1 EXEC PROC=OMA2PDS,                                                         
//          TDFNAME='CBT478',                                                   
//          TOPRFIX='HERC01.CBT',                                               
//           TONAME='FILE478'                                                   
//*                                                                             
//                                                                              
./ ADD NAME=TSOBATCH                                                            
//HERC011T JOB (ACCNT),'TSO in batch',CLASS=A,MSGCLASS=X                        
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//* Name: TSOBATCH                                                              
//*                                                                             
//* Desc: Simple example of TSO in batch                                        
//*                                                                             
//********************************************************************          
//*                                                                             
//TSOBATCH EXEC PGM=IKJEFT01,REGION=4000K,DYNAMNBR=50                           
//*SYSPROC  DD  DISP=SHR,DSN=SYS2.CMDPROC                                       
//SYSTSPRT DD  SYSOUT=*                                                         
//SYSPRINT DD  SYSOUT=*                                                         
//SYSTSIN  DD  *                                                                
 LISTA  STA HIS                                                                 
./ ADD NAME=TSUPDATE 8024-74171-13279-1232-00084-00037-00000-HERC01  10         
//HERC01TS JOB (EDIT),'Update a PDS',CLASS=A,MSGCLASS=X                         
//********************************************************************          
//*                                                                             
//* Name: TSUPDATE                                                              
//*                                                                             
//* Desc: Various examples of running TSUPDTE:                                  
//*       1: Print documentaton only                                            
//*       2: Print documentaton and perform global change, no update            
//*       3: Print proc summary reference                                       
//*       4: Print dataset summary reference by proc                            
//*       5: Print program summary reference by proc                            
//*                                                                             
//* Note: Sometimes you get RC=0, but no output other than stats.               
//*       Run it again or maybe a second time after that,                       
//*       and viola, you get output!                                            
//*                                                                             
//********************************************************************          
//*                                                                             
//********************************************************************          
//*  PRINT DOCUMENTATON ONLY                                                    
//********************************************************************          
//EXAMPLE1 EXEC PGM=TSUPDATE,PARM='PDS,,CKPTFULL,,NOLOOKBACK'                   
//CHKPT    DD  DISP=(MOD,DELETE,CATLG),                                         
//             DSN=MVS.TSUPDATE.CHCKPT,                                         
//             UNIT=SORT,SPACE=(CYL,(10,10))                                    
//SYSPRINT DD  SYSOUT=*                                                         
//UPDTDUMP DD  SYSOUT=*                                                         
//PROCLIB  DD  DISP=SHR,DSN=SYS1.SYSGEN.CNTL                                    
//ERRPRT   DD  SYSOUT=*                                                         
//WORKFILE DD  UNIT=SORT,SPACE=(CYL,(5,5))                                      
//CHANGE   DD  *                                                                
INIT OPTION=DOCUMENT                                                            
//                                                                              
//********************************************************************          
//*  PRINT DOCUMENTATON AND PERFORM GLOBAL CHANGE, NO UPDATE                    
//********************************************************************          
//EXAMPLE2 EXEC PGM=TSUPDATE,PARM='PDS,,CKPTFULL,,NOLOOKBACK'                   
//CHKPT    DD  DISP=(MOD,DELETE,CATLG),                                         
//             DSN=MVS.TSUPDATE.CHCKPT,                                         
//             UNIT=SORT,SPACE=(CYL,(10,10))                                    
//SYSPRINT DD  SYSOUT=*                                                         
//UPDTDUMP DD  SYSOUT=*                                                         
//PROCLIB  DD  DISP=SHR,DSN=SYS1.SYSGEN.CNTL                                    
//ERRPRT   DD  SYSOUT=*                                                         
//WORKFILE DD  UNIT=SORT,SPACE=(CYL,(5,5))                                      
//CHANGE   DD  *                                                                
INIT OPTION=DOCUMENT                                                            
INIT OPTION=SET,KEYWORD=DETAIL,VALUE=ON                                         
#.@#./#                                                                         
//* The above control card means substitute ".@" with "./", no update.          
//                                                                              
#.@#./#                                                                W        
//* A "W" (i.e. "write") is needed in col 72 to make changes permanent.         
//*                                                                             
//********************************************************************          
//*  PRINT PROC SUMMARY REFERENCE                                               
//********************************************************************          
//EXAMPLE3 EXEC PGM=TSUPDATE,PARM=XREFFULL    <=== PROC XREF                    
//*STEPLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR                                       
//SYSPRINT DD  SYSOUT=*                                                         
//SORTLIB  DD  DSNAME=SYS1.SORTLIB,DISP=SHR                                     
//UPDTDUMP DD  SYSOUT=*                                                         
//PROCLIB  DD  DISP=SHR,DSN=SYS2.PROCLIB                                        
//ERRPRT   DD  SYSOUT=*                                                         
//WORKFILE DD  UNIT=VIO,SPACE=(CYL,(5,5))                                       
//*                                                                             
//********************************************************************          
//*  PRINT DATASET SUMMARY REFERENCE BY PROC                                    
//********************************************************************          
//EXAMPLE4 EXEC PGM=TSUPDATE,PARM=XREFDSN                                       
//SYSPRINT DD  SYSOUT=*                                                         
//SORTLIB  DD  DSNAME=SYS1.SORTLIB,DISP=SHR                                     
//UPDTDUMP DD  SYSOUT=*                                                         
//PROCLIB  DD  DISP=SHR,DSN=SYS2.PROCLIB                                        
//ERRPRT   DD  SYSOUT=*                                                         
//WORKFILE DD  UNIT=VIO,SPACE=(CYL,(1,1))                                       
//*                                                                             
//********************************************************************          
//*  PRINT PROGRAM SUMMARY REFERENCE BY PROC                                    
//********************************************************************          
//EXAMPLE5 EXEC PGM=TSUPDATE,PARM=XREFPGM                                       
//SYSPRINT DD  SYSOUT=*                                                         
//SORTLIB  DD  DSNAME=SYS1.SORTLIB,DISP=SHR                                     
//UPDTDUMP DD  SYSOUT=*                                                         
//PROCLIB  DD  DISP=SHR,DSN=SYS2.PROCLIB                                        
//ERRPRT   DD  SYSOUT=*                                                         
//WORKFILE DD  UNIT=VIO,SPACE=(CYL,(1,1))                                       
//                                                                              
./ ADD NAME=SAVEOLD                                                             
//HERC01S  JOB (SAVEOLD),'Create a copy',CLASS=A,MSGCLASS=X                     
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(SAVEOLD)                                                 
//*                                                                             
//*  Desc: Make a safety copy of a PDS with iebcopy                             
//*                                                                             
//********************************************************************          
//*                                                                             
//SAVEOLD  EXEC PGM=IEBCOPY,                                                    
// PARM='SIZE=999K,LIST=NO,RC4NOREP'                                            
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=SYS2.CMDLIB                                         
//SYSUT2   DD  DISP=(,CATLG),                                                   
//             DSN=SYS2.CMDLIB.SAVE,                                            
//             VOL=SER=PUB000,SPACE=(TRK,(500,100,100)),                        
//             DCB=(RECFM=U,BLKSIZE=19069,DSORG=PO),                            
//             UNIT=SYSALLDA                                                    
//SYSIN    DD  *                                                                
 C I=SYSUT1,O=SYSUT2                                                            
//*                                                                             
./ ADD NAME=SMPLIST                                                             
//HERC01SL JOB (SMPLIST),'SMPLIST ',CLASS=A,MSGCLASS=X                          
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//*-+----1----+----2----+----3----+----4----+----5----+----6----+----7-         
//*                                                                             
//SMPLIST  EXEC SMPAPP,COND=(5,LT)                                              
//SMPCNTL  DD  *                                                                
  LIST CDS    MOD(IEECVUCM IEEDUCM)                                             
             LMOD(IEECVUCM IEEDUCM)                                             
                                      .                                         
//*                                                                             
//* other examples:                                                             
//*                                                                             
//SMPCNTL  DD  *                                                                
  LIST CDS    LMOD(HASJES20)                                                    
            MOD(HASPNUC                                                         
                                HASPRDR                                         
                                HASPRDRO                                        
                                HASPRSCN                                        
                                HASPXEQ                                         
                                HASPPRPU                                        
                                HASPACCT                                        
                                HASPMISC                                        
                                HASPCON                                         
                                HASPRTAM                                        
                                HASPCOMM                                        
                                HASPCOMA                                        
                                HASPINIT)                                       
                 SYSMOD(EJE1103,ZP60015,WM00017,TJES801,ZUM0018)                
                                .                                               
//SMPCNTL  DD  *                                                                
  LIST CDS    MOD(IEFJESNM,HASJES20).                                           
//SMPCNTL  DD  *                                                                
LIST CDS SYSMOD .                                                               
//*                                                                             
./ ADD NAME=TAPEMAP                                                             
//HERC01TM JOB ACCT,'MAP a TAPE',CLASS=S,MSGCLASS=X                             
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*                                                                             
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(TAPEMAP)                                                 
//*                                                                             
//*  Desc: Print the contents of a tape (a tapemap)                             
//*                                                                             
//*  Note: Make sure you use a jobclass that allows BLP processing              
//*        This is regulated by the JES2 converterparms.                        
//*        Jobclass H (hot batch) and S (sysprog) are allowed BLP               
//*                                                                             
//*  Note: Make sure the requested tapeunit is online                           
//*        e.g. v 480,online                                                    
//*        and activate the tape file on hercules after the mountmsg:           
//*        devinit 480 tapes\mytape.aws                                         
//*                                                                             
//********************************************************************          
//*                                                                             
//*--------------------------------------------------------------------         
//*  Desc: Make a tapemap                                                       
//*--------------------------------------------------------------------         
//TAPEMAP  PROC TAPER='??????',UNITR=480                                        
//TAPEMAP  EXEC PGM=TAPEMAP,TIME=2                                              
//SYSPRINT DD  SYSOUT=*                                                         
//SYSPRIN2 DD  SYSOUT=*                                                         
//SYSUT1   DD  UNIT=(&UNITR,,DEFER),VOL=SER=&TAPER,                             
//         DSN=HERC01.EFFE.NOABEND.S913,  <<-- no temp dsname                   
//         LABEL=(1,BLP,,IN) (,BLP,EXPDT=98000)                                 
//*--------------------------------------------------------------------         
//TAPEMAP  PEND                                                                 
//*                                                                             
//HTAPE1    EXEC TAPEMAP,TAPER=HTAPE1                                           
//                                                                              
./        ENDUP                                                                 
#$                                                                              
//*                                                                             
//*                                                                             
//*    PDSLOAD step to add IEBUPDTE sample JCL                                  
//*                                                                             
//*    UPDTE(><)   - REPLACE >< WITH CTL CHARACTERS ./                          
//*                                                                             
//*                                                                             
//STEP1   EXEC PGM=PDSLOAD,PARM='UPDTE(><),CTL(./)'                             
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT2   DD  DISP=SHR,DSN=*.CRESAMP.SYSUT2                                    
//SYSUT1   DD  DATA,DLM=#$  <<--=== DLM outer                                   
./ ADD NAME=IEBUPDTE                                                            
//HERC01UP JOB (ACCNT),'IEBUPDTE',CLASS=A,MSGCLASS=X                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//*    PDSLOAD step to add IEBUPDTE sample JCL                                  
//*                                                                             
//*    UPDTE(><)   - REPLACE >< WITH CTL CHARACTERS ./                          
//*                                                                             
//*                                                                             
//STEP1    EXEC PGM=PDSLOAD,PARM='UPDTE(><),CTL(./)'                            
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT2   DD  DISP=SHR,DSN=*.CRE#PDS.SYSUT2                                    
//SYSUT1   DD  DATA,DLM=#$  <<--=== DLM outer                                   
./ ADD NAME=IEBUPDTE                                                            
//HERC01UP JOB (ACCNT),'IEBUPDTE',CLASS=A,MSGCLASS=X                            
//* USER=HERC01,PASSWORD=xxxxxxxx                                               
//********************************************************************          
//*                                                                             
//*  Name: SYS2.JCLLIB(IEBUPDTE)                                                
//*                                                                             
//*  Desc:  add members to new data set                                         
//*         if adding members to an existing data set                           
//*         then Update the DISP of SYSUT2                                      
//*                                                                             
//*                                                                             
//********************************************************************          
//*                                                                             
//*                                                                             
//AMP#UPD  EXEC PGM=IEBUPDTE,PARM='NEW'                                         
//SYSUT2   DD  DISP=(,CATLG),DSN=HERC01.TEST.TRASHCAN,                          
//         UNIT=SYSALLDA,SPACE=(TRK,(20,20,41),RLSE),                           
//         DCB=(LRECL=80,RECFM=FB,BLKSIZE=6080)                                 
//SYSPRINT DD  SYSOUT=*                                                         
//SYSIN    DD  *                                                                
><        ADD   LIST=ALL,NAME=TRASH1                                            
                Just an example: can be deleted                                 
><        ADD   LIST=ALL,NAME=TRASH2                                            
><     NUMBER   NEW1=10,INCR=10                                                 
                Just an example: can be deleted                                 
><        ENDUP                                                                 
./        ENDUP                                                                 
//*                                                                             
##                                                                              
#$                                                                              
//*                                                                             
//********************************************************************          
//*                                                                             
//* ADD members but do not UPDATE existing members:                             
//*                                                                             
//********************************************************************          
//*                                                                             
//COPYSYS2 EXEC PGM=IEBCOPY                                                     
//SYSPRINT DD  SYSOUT=*                                                         
//SYSUT1   DD  DISP=SHR,DSN=SYS2.JCLLIB                                         
//SYSUT2   DD  DISP=SHR,DSN=HERC01.TEST.SAMPJCL                                 
//SYSIN    DD  *                                                                
 C I=SYSUT1,O=SYSUT2                                                            
//*                                                                             
