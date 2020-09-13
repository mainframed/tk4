This package is to enable MVS/370 applications to use
instructions from z/Architecture by employing the MVS
SPIE facility to trap invalid instructions and use 370
instructions to simulate various newer instructions.

You can code your application to set SIMZ9 as its SPIE
routine, or you can use RUNZ9 to set SIMZ9 as the SPIE
routine and then invoke your application program.

See the SIMZ9 source for a list of supported instructions.

ZIP file contents:

z9asm.rvl - source and macros for SIMZ9, RUNZ9 and TESTZ9.
z9load.rvl - load modules of SIMZ9, RUNZ9 and TESTZ9.
z9maclib.rvl - macros so that IFOX00 can generate executable
code when the newer instruction mnemonics are used in source.

All three files are in EBCDIC and should not be translated.
They are the binary image of MVS files with fixed-length
80-byte records.

z9load.rvl is in REVLMOD format.
The other two files are in PDSLOAD format.
(All three files can be loaded by the PDSLOAD subcommand
of REVIEW when processing the target PDS.)

This ZIP file was created in January 2008 for download from
http://www.prycroft6.com.au/vs2sw

