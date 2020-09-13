//DISKMAP  JOB (001),'DISKMAP',                                         00010000
//             CLASS=A,MSGCLASS=A                                       00020000
//DISKMAP EXEC PGM=DISKMAP,REGION=1024K                                 00030000
//SYSPRINT DD  SYSOUT=*                                                 00040000
//SYSUT1   DD  DSN=SYS1.PROCLIB,DISP=SHR                                00050000
//DD1      DD  DISP=OLD,UNIT=3350,VOL=SER=PUB001                        00060000
//                                                                      00070000
