CDPG037  CSECT
         DC    A(EBCNAME)  Address of EBCDIC code page name
         DC    A(ASCNAME)  Address of ASCII code page name
         DC    A(EBC2ASC)  Address of Ebcdic to Ascii table
         DC    A(ASC2EBC)  Address of Ascii to Ebcdic table
*
EBCNAME  DC    C'IBM Codepage 037',X'00'  NULL Terminated for C
ASCNAME  DC    C'ISO Latin-1',X'00'       NULL Terminated for C
*
* IBM Code Page 037 to ISO Latin-1
*
EBC2ASC  DS    0D
         DC    X'00',X'01',X'02',X'03',X'9C',X'09',X'86',X'7F' 00 - 07
         DC    X'97',X'8D',X'8E',X'0B',X'0C',X'0D',X'0E',X'0F' 08 - 0F
         DC    X'10',X'11',X'12',X'13',X'9D',X'85',X'08',X'87' 10 - 17
         DC    X'18',X'19',X'92',X'8F',X'1C',X'1D',X'1E',X'1F' 18 - 1F
         DC    X'80',X'81',X'82',X'83',X'84',X'0A',X'17',X'1B' 20 - 27
         DC    X'88',X'89',X'8A',X'8B',X'8C',X'05',X'06',X'07' 28 - 2F
         DC    X'90',X'91',X'16',X'93',X'94',X'95',X'96',X'04' 30 - 37
         DC    X'98',X'99',X'9A',X'9B',X'14',X'15',X'9E',X'1A' 38 - 3F
         DC    X'20',X'A0',X'A1',X'A2',X'A3',X'A4',X'A5',X'A6' 40 - 47
         DC    X'A7',X'A8',X'A9',X'2E',X'3C',X'28',X'2B',X'7C' 48 - 4F
         DC    X'26',X'AA',X'AB',X'AC',X'AD',X'AE',X'AF',X'B0' 50 - 57
         DC    X'B1',X'B2',X'21',X'24',X'2A',X'29',X'3B',X'D9' 58 - 5F
         DC    X'2D',X'2F',X'B3',X'B4',X'B5',X'B6',X'B7',X'B8' 60 - 67
         DC    X'B9',X'BA',X'BB',X'2C',X'25',X'5F',X'3E',X'3F' 68 - 6F
         DC    X'BC',X'BD',X'BE',X'BF',X'C0',X'C1',X'C2',X'C3' 70 - 77
         DC    X'C4',X'60',X'3A',X'23',X'40',X'27',X'3D',X'22' 78 - 7F
         DC    X'C5',X'61',X'62',X'63',X'64',X'65',X'66',X'67' 80 - 87
         DC    X'68',X'69',X'C6',X'C7',X'C8',X'C9',X'CA',X'CB' 88 - 8F
         DC    X'CC',X'6A',X'6B',X'6C',X'6D',X'6E',X'6F',X'70' 90 - 97
         DC    X'71',X'72',X'CD',X'CE',X'CF',X'D0',X'D1',X'D2' 98 - 9F
         DC    X'D3',X'7E',X'73',X'74',X'75',X'76',X'77',X'78' A0 - A7
         DC    X'79',X'7A',X'D4',X'D5',X'D6',X'E3',X'D7',X'D8' A8 - AF
         DC    X'5E',X'DA',X'DB',X'DC',X'DD',X'DE',X'DF',X'E0' B0 - B7
         DC    X'E1',X'E2',X'5B',X'5D',X'E5',X'E4',X'E6',X'E7' B8 - BF
         DC    X'7B',X'41',X'42',X'43',X'44',X'45',X'46',X'47' C0 - C7
         DC    X'48',X'49',X'E8',X'E9',X'EA',X'EB',X'EC',X'ED' C8 - CF
         DC    X'7D',X'4A',X'4B',X'4C',X'4D',X'4E',X'4F',X'50' D0 - D7
         DC    X'51',X'52',X'EE',X'EF',X'F0',X'F1',X'F2',X'F3' D8 - DF
         DC    X'5C',X'F4',X'53',X'54',X'55',X'56',X'57',X'58' E0 - E7
         DC    X'59',X'5A',X'F5',X'F6',X'F7',X'F8',X'F9',X'FA' E8 - EF
         DC    X'30',X'31',X'32',X'33',X'34',X'35',X'36',X'37' F0 - F7
         DC    X'38',X'39',X'FB',X'FC',X'FD',X'FE',X'FF',X'9F' F8 - FF
*
* ISO Latin-1 to IBM Code Page 037
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
         DC    X'E7',X'E8',X'E9',X'BA',X'E0',X'BB',X'B0',X'6D' 58 - 5F
         DC    X'79',X'81',X'82',X'83',X'84',X'85',X'86',X'87' 60 - 67
         DC    X'88',X'89',X'91',X'92',X'93',X'94',X'95',X'96' 68 - 6F
         DC    X'97',X'98',X'99',X'A2',X'A3',X'A4',X'A5',X'A6' 70 - 77
         DC    X'A7',X'A8',X'A9',X'C0',X'4F',X'D0',X'A1',X'07' 78 - 7F
         DC    X'20',X'21',X'22',X'23',X'24',X'15',X'06',X'17' 80 - 87
         DC    X'28',X'29',X'2A',X'2B',X'2C',X'09',X'0A',X'1B' 88 - 8F
         DC    X'30',X'31',X'1A',X'33',X'34',X'35',X'36',X'08' 90 - 97
         DC    X'38',X'39',X'3A',X'3B',X'04',X'14',X'3E',X'FF' 98 - 9F
         DC    X'41',X'42',X'43',X'44',X'45',X'46',X'47',X'48' A0 - A7
         DC    X'49',X'4A',X'51',X'52',X'53',X'54',X'55',X'56' A8 - AF
         DC    X'57',X'58',X'59',X'62',X'63',X'64',X'65',X'66' B0 - B7
         DC    X'67',X'68',X'69',X'6A',X'70',X'71',X'72',X'73' B8 - BF
         DC    X'74',X'75',X'76',X'77',X'78',X'80',X'8A',X'8B' C0 - C7
         DC    X'8C',X'8D',X'8E',X'8F',X'90',X'9A',X'9B',X'9C' C8 - CF
         DC    X'9D',X'9E',X'9F',X'A0',X'AA',X'AB',X'AC',X'AE' D0 - D7
         DC    X'AF',X'5F',X'B1',X'B2',X'B3',X'B4',X'B5',X'B6' D8 - DF
         DC    X'B7',X'B8',X'B9',X'AD',X'BD',X'BC',X'BE',X'BF' E0 - E7
         DC    X'CA',X'CB',X'CC',X'CD',X'CE',X'CF',X'DA',X'DB' E8 - EF
         DC    X'DC',X'DD',X'DE',X'DF',X'E1',X'EA',X'EB',X'EC' F0 - F7
         DC    X'ED',X'EE',X'EF',X'FA',X'FB',X'FC',X'FD',X'FE' F8 - FF
         END
