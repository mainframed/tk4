//CDPG1047 JOB (,),'CDPG1047',REGION=2048K
//ASM     EXEC PGM=IFOX00,                                  
//             PARM='DECK,NOLOAD,TERM,NOTEST'
//SYSLIB   DD  DISP=SHR,DSN=SYS1.MACLIB                     
//         DD  DISP=SHR,DSN=SYS1.AMODGEN                    
//SYSUT1   DD  SPACE=(CYL,(25,5)),UNIT=VIO                  
//SYSUT2   DD  SPACE=(CYL,(25,5)),UNIT=VIO                  
//SYSUT3   DD  SPACE=(CYL,(25,5)),UNIT=VIO                  
//SYSTERM  DD  SYSOUT=*                                     
//SYSPRINT DD  SYSOUT=*                                     
//SYSPUNCH DD  DISP=SHR,DSN=SYS2.OBJMOD(CDPG1047)               
//SYSIN    DD  *               
CDPG1047 CSECT
         DC    A(EBCNAME)  Address of EBCDIC code page name
         DC    A(ASCNAME)  Address of ASCII code page name
         DC    A(EBC2ASC)  Address of Ebcdic to Ascii table
         DC    A(ASC2EBC)  Address of Ascii to Ebcdic table
*
EBCNAME  DC    C'IBM Codepage 1047',X'00' NULL Terminated for C
ASCNAME  DC    C'ISO Latin-1',X'00'       NULL Terminated for C
*
* IBM Code Page 1047 to ISO Latin-1
*
EBC2ASC  DS    0D
         DC    X'00',X'01',X'02',X'03',X'9C',X'09',X'86',X'7F' 00 - 07 
         DC    X'97',X'8D',X'8E',X'0B',X'0C',X'0D',X'0E',X'0F' 08 - 0F 
         DC    X'10',X'11',X'12',X'13',X'9D',X'0A',X'08',X'87' 10 - 17 
         DC    X'18',X'19',X'92',X'8F',X'1C',X'1D',X'1E',X'1F' 18 - 1F 
         DC    X'80',X'81',X'82',X'83',X'84',X'85',X'17',X'1B' 20 - 27 
         DC    X'88',X'89',X'8A',X'8B',X'8C',X'05',X'06',X'07' 28 - 2F 
         DC    X'90',X'91',X'16',X'93',X'94',X'95',X'96',X'04' 30 - 37 
         DC    X'98',X'99',X'9A',X'9B',X'14',X'15',X'9E',X'1A' 38 - 3F 
         DC    X'20',X'A0',X'E2',X'E4',X'E0',X'E1',X'E3',X'E5' 40 - 47 
         DC    X'E7',X'F1',X'A2',X'2E',X'3C',X'28',X'2B',X'7C' 48 - 4F 
         DC    X'26',X'E9',X'EA',X'EB',X'E8',X'ED',X'EE',X'EF' 50 - 57 
         DC    X'EC',X'DF',X'21',X'24',X'2A',X'29',X'3B',X'5E' 58 - 5F 
         DC    X'2D',X'2F',X'C2',X'C4',X'C0',X'C1',X'C3',X'C5' 60 - 67 
         DC    X'C7',X'D1',X'A6',X'2C',X'25',X'5F',X'3E',X'3F' 68 - 6F 
         DC    X'F8',X'C9',X'CA',X'CB',X'C8',X'CD',X'CE',X'CF' 70 - 77 
         DC    X'CC',X'60',X'3A',X'23',X'40',X'27',X'3D',X'22' 78 - 7F 
         DC    X'D8',X'61',X'62',X'63',X'64',X'65',X'66',X'67' 80 - 87 
         DC    X'68',X'69',X'AB',X'BB',X'F0',X'FD',X'FE',X'B1' 88 - 8F 
         DC    X'B0',X'6A',X'6B',X'6C',X'6D',X'6E',X'6F',X'70' 90 - 97 
         DC    X'71',X'72',X'AA',X'BA',X'E6',X'B8',X'C6',X'A4' 98 - 9F 
         DC    X'B5',X'7E',X'73',X'74',X'75',X'76',X'77',X'78' A0 - A7 
         DC    X'79',X'7A',X'A1',X'BF',X'D0',X'5B',X'DE',X'AE' A8 - AF 
         DC    X'AC',X'A3',X'A5',X'B7',X'A9',X'A7',X'B6',X'BC' B0 - B7 
         DC    X'BD',X'BE',X'DD',X'A8',X'AF',X'5D',X'B4',X'D7' B8 - BF 
         DC    X'7B',X'41',X'42',X'43',X'44',X'45',X'46',X'47' C0 - C7 
         DC    X'48',X'49',X'AD',X'F4',X'F6',X'F2',X'F3',X'F5' C8 - CF 
         DC    X'7D',X'4A',X'4B',X'4C',X'4D',X'4E',X'4F',X'50' D0 - D7 
         DC    X'51',X'52',X'B9',X'FB',X'FC',X'F9',X'FA',X'FF' D8 - DF 
         DC    X'5C',X'F7',X'53',X'54',X'55',X'56',X'57',X'58' E0 - E7 
         DC    X'59',X'5A',X'B2',X'D4',X'D6',X'D2',X'D3',X'D5' E8 - EF 
         DC    X'30',X'31',X'32',X'33',X'34',X'35',X'36',X'37' F0 - F7 
         DC    X'38',X'39',X'B3',X'DB',X'DC',X'D9',X'DA',X'9F' F8 - FF
*
* ISO Latin-1 to IBM Code Page 1047
*
ASC2EBC  DS    0D
         DC    X'00',X'01',X'02',X'03',X'37',X'2D',X'2E',X'2F' 00 - 07 
         DC    X'16',X'05',X'15',X'0B',X'0C',X'0D',X'0E',X'0F' 08 - 0F 
         DC    X'10',X'11',X'12',X'13',X'3C',X'3D',X'32',X'26' 10 - 17 
         DC    X'18',X'19',X'3F',X'27',X'1C',X'1D',X'1E',X'1F' 18 - 1F 
         DC    X'40',X'5A',X'7F',X'7B',X'5B',X'6C',X'50',X'7D' 20 - 27 
         DC    X'4D',X'5D',X'5C',X'4E',X'6B',X'60',X'4B',X'61' 28 - 2F 
         DC    X'F0',X'F1',X'F2',X'F3',X'F4',X'F5',X'F6',X'F7' 30 - 37 
         DC    X'F8',X'F9',X'7A',X'5E',X'4C',X'7E',X'6E',X'6F' 38 - 3F 
         DC    X'7C',X'C1',X'C2',X'C3',X'C4',X'C5',X'C6',X'C7' 40 - 47 
         DC    X'C8',X'C9',X'D1',X'D2',X'D3',X'D4',X'D5',X'D6' 48 - 4F 
         DC    X'D7',X'D8',X'D9',X'E2',X'E3',X'E4',X'E5',X'E6' 50 - 57 
         DC    X'E7',X'E8',X'E9',X'AD',X'E0',X'BD',X'5F',X'6D' 58 - 5F 
         DC    X'79',X'81',X'82',X'83',X'84',X'85',X'86',X'87' 60 - 67 
         DC    X'88',X'89',X'91',X'92',X'93',X'94',X'95',X'96' 68 - 6F 
         DC    X'97',X'98',X'99',X'A2',X'A3',X'A4',X'A5',X'A6' 70 - 77 
         DC    X'A7',X'A8',X'A9',X'C0',X'4F',X'D0',X'A1',X'07' 78 - 7F 
         DC    X'20',X'21',X'22',X'23',X'24',X'25',X'06',X'17' 80 - 87 
         DC    X'28',X'29',X'2A',X'2B',X'2C',X'09',X'0A',X'1B' 88 - 8F 
         DC    X'30',X'31',X'1A',X'33',X'34',X'35',X'36',X'08' 90 - 97 
         DC    X'38',X'39',X'3A',X'3B',X'04',X'14',X'3E',X'FF' 98 - 9F 
         DC    X'41',X'AA',X'4A',X'B1',X'9F',X'B2',X'6A',X'B5' A0 - A7 
         DC    X'BB',X'B4',X'9A',X'8A',X'B0',X'CA',X'AF',X'BC' A8 - AF 
         DC    X'90',X'8F',X'EA',X'FA',X'BE',X'A0',X'B6',X'B3' B0 - B7 
         DC    X'9D',X'DA',X'9B',X'8B',X'B7',X'B8',X'B9',X'AB' B8 - BF 
         DC    X'64',X'65',X'62',X'66',X'63',X'67',X'9E',X'68' C0 - C7 
         DC    X'74',X'71',X'72',X'73',X'78',X'75',X'76',X'77' C8 - CF 
         DC    X'AC',X'69',X'ED',X'EE',X'EB',X'EF',X'EC',X'BF' D0 - D7 
         DC    X'80',X'FD',X'FE',X'FB',X'FC',X'BA',X'AE',X'59' D8 - DF 
         DC    X'44',X'45',X'42',X'46',X'43',X'47',X'9C',X'48' E0 - E7 
         DC    X'54',X'51',X'52',X'53',X'58',X'55',X'56',X'57' E8 - EF 
         DC    X'8C',X'49',X'CD',X'CE',X'CB',X'CF',X'CC',X'E1' F0 - F7 
         DC    X'70',X'DD',X'DE',X'DB',X'DC',X'8D',X'8E',X'DF' F8 - FF
         END
/*
//*
//LINK EXEC PGM=IEWL,PARM='XREF'
//SYSPRINT DD SYSOUT=*
//SYSUT1 DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//OBJECT DD DISP=SHR,DSN=SYS2.OBJMOD(CDPG1047)
//SYSLMOD DD DISP=SHR,DSN=SYS2.CMDLIB
//SYSLIN  DD *
  INCLUDE OBJECT(CDPG1047)
  NAME CDPG1047(R)
/*
//DBSTOP  EXEC DBSTOP
//DBSTART EXEC DBSTART
// 
