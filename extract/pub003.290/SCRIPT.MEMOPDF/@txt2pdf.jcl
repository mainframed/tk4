//JUERGENP JOB ...,
//         CLASS=A,MSGCLASS=J,
//         REGION=8M,
//         MSGLEVEL=(1,1),
//         NOTIFY=JUERGEN
//***
//*** Convert Waterloo Script Documentation to PDF
//***
//SCRDOC   EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(scrdoc) out scrdoc.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 paper A4 font 12/CN/100 page n/sp +
 color black/white lm 0.2 lpi 6 rm 0
/*
//SCRINTRO EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(scrintro) out scrintro.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 paper A4 font 12/CN/100 page n/sp +
 color black/white lm 0.2 lpi 6 rm 0
/*
//SCRIPT   EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(script) out script.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 paper A4 font 12/CN/100 page n/sp +
 color black/white lm 0.2 lpi 6 rm 0
/*
//SCRIPTCD EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(scriptcd) out scriptcd.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 font 10/CN/100 page n/tcr +
 color black/white paper 7.5x18.0
/*
//SCRIPTNI EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(scriptni) out scriptni.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 paper A4 font 12/CN/100 page n/sp +
 color black/white lm 0.2 lpi 6 rm 0
/*
//SCRIPTUP EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(scriptup) out scriptup.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 paper A4 font 12/CN/100 page n/sp +
 color black/white lm 0.8 lpi 6 rm 0
/*
//SYSPUBMN EXEC PGM=IKJEFT01
//SYSEXEC  DD  DSN=USER.CLIST,DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
 txt2pdf in script.memotxt(syspubmn) out syspubmn.pdf +
 encoding define/TN/'txt2pdf.ucmlib(TN)' +
 xfont truetype/CN/TN/NS/'txt2pdf.courier.new.ttf' +
 paper A4 font 12/CN/100 page n/sp +
 color black/white lm 0.2 lpi 6 rm 0
/*
//
