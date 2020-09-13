Waterloo Script Documentation in PDF
====================================

This zip file contains the documentation for Waterloo Script version 3.2 dated
13th January 1978 in PDF format. It has been created by

1. Running the SCRIPTMN procedure as documented in the Memorandum to Users to
   format the documentation distribution as found in SCRIPT.MEMO and placing
   the output in a PDS named SCRIPT.MEMOTXT instead of directly sending it to
   SYSOUT. This step has been done on an MVS 3.8j system.

2. Transferring SCRIPT.MEMOTXT to a system capable to run Leland Lucius' txt2pdf
   utility.

3. Running txt2pdf to convert the documentation to PDF.

Index
=====

@@README.txt - this file
@memotxt.xmi - printer output library in XMIT format
@txt2pdf.jcl - sample jcl to convert the printer output to PDF
7 PDF files  - the Waterloo Script documentation
