In MVS 3.8J there are at least four distinct ways to logon to TSO in "TTY" (line) mode. I have gotten the first three working, with 2741 mode still a bit quirky.  The fourth method is stalled due to a TCAM S0C4. Methods 1&2 are non-SNA, methods 3&4 are SNA.

For these purposes, we may define "line mode" as a mode where none of your favorite applications work:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rpf
RPF: NO 3270 TERMINAL, RPF INOPERATIVE
READY 

queue
QUEUE COMMAND REQUIRES DISPLAY TERMINAL
READY 

review
"REVIEW" TERMINATED BECAUSE TERMINAL IS NOT A 3270 DISPLAY

terminal linesize(80)
READY 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Note that the KERMIT stuff has only been tested out using method #3.  It may
work with method 1, but probably a little tweaking is needed (translation tables?)

Also, method 1 has been tested to work (#2 should also) when MVS is running under VM/370; VM=YES must then be included in the TCAM stage II; the VM/370 DIAL command is used to connect to the MVS guest; and the VM/370 VIRTUAL statement is used to configure the virtual TTYs; finally, a VM source modification seems to be needed in order to correct a VM/370 crash.

1. - via TSO/TCAM
   - connecting through a 2701/2703 using line control type="TELE2"
   - device defined as TERM=3335 (*) on the LINEGRP macro in TCAM's stage I
   - each TTY device appears to MVS as a separate CUA
   - TCAM performs EBCDIC/ASCII translation
   - bytes flowing across S/370 channel to the 270x are in ASCII
   - AFAIK, the TTY is the only non-IBM device support found anywhere in 3.8J
  *3335 refers to the model ASR/33 and ASR/35 (and compatible) Teletype series.
2. - via TSO/TCAM
   - connecting through a 2701/2703 using line control type="IBM1"
   - device defined as TERM=2741 on the LINEGRP macro in TCAM's stage I
   - each 2741 device appears to MVS as a separate CUA
   - TCAM performs code translation
   - bytes flowing across the S/370 channel to the 270x are in 2741 code
   - two code tables were used by IBM, EBCD and Correspondence Code
   - EBCD may have been also known as PTTC/8 (Paper Tape Code)
3. - via TSO/VTAM
   - connecting through a 3704/3705 in NCP (not EP) mode
   - VTAM LOGMODE session parameters must be arranged for LU1 (line) mode
   - TSO/VTAM does *not* view these devices as ASCII TTY's
   - supported as IBM 3767/3770 terminals
   - neither TSO nor VTAM perform any code translation for them
   - bytes flowing across the S/370 channel are in EBCDIC
   - only a single CUA regardless of the number of remote attached terminals.
4. - same as #3, except using TCAM instead of VTAM (if this is possible)
   - TCAM LINEGRP macro is defined with TERM=PUNT
   - Testing this is stalled due to TCAM S0C4.

In all of the above cases, there is no physical 270x or 370x, nor usually is there an actual dumb terminal.  Instead we have an ordinary remote incoming ASCII TELNET connection which we accept via a listening TCP/IP socket in our Herc drivers (connect(), accept(), listen(), and socket() are all low-level Unix system calls).

The function of the Herc driver in each case is to fake MVS into believing that it's communicating with an ASR33 or a 2741 or a 3767, via a 270x or a 370x as appropriate, while mapping the quirks of each of these devices into a standard ASCII TTY stream for the benefit of the client who's TELNETing in.

Numbered as above, these include:
1. For the ASR/33/35, host bytes are already in ASCII although the bit order must be reversed.
2. For the 2741, the user selects the desired code table (EBCD, Correspondence Code, or None) in the Hercules config file.  The first two options enable conventional ASCII TELNET users to emulate the 2741 line codes; genuine 2741 hardware users would of course select None (no translation).  TSO/TCAM apparently auto-detects the proper code table.  If the autodetection fails, TSO repeats the LOGON prompt twice, once in each code, which looks something like this:
IKJ53020A ENTER  LOGON
OW+43929P USVUN  YQAQS
3. For the 3767, ASCII/EBCDIC conversion happens in the Hercules driver using the Herc's built-in translation tables and host_to_guest()/guest_to_host().
4. (same as #3).

In all these cases, we must also map the canonical TELNET interrupt (CTRL-C) to BREAK, ATTN, or SNA SIGNAL, respectively (totally differently in each case, of course).

Another quirk found in the 270x world is the method of writing "idle" characters.  The CCW chains used by the Access Methods frequently contain write commands that cause actual idle bytes to be sent to the 270x, which real 270x's discarded without being sent over the comm line to the terminal.  There is always a CCW chain running, which is why active 270x lines run by TSO/TCAM always appear as "A-BSY" when using the OS "D U" commands to display them.  However, these idle writes cause troubles that must be worked around in the Herc driver.  First, we need to suppress these characters from being sent to the remote TELNET terminal where they would otherwise appear as garbage; second, we need to add some time delay before ending these write CCWs, to avoid very high CPU consumption.  These CCWs were used for things like machine carriage control delays as well as for obscure purposes internal to the Access Methods...
