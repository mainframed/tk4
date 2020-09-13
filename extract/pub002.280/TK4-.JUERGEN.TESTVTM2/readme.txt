TESTVTM2 -- A Sample Complex Exit Driven VTAM Application
=========================================================

This is a special version of TESTVTM2 adapted to the non ACF
VTAM Level 2 that's available with MVS 3.8j. It supports most
terminal types that can occur on MVS 3.8j when running under
Hercules:

 - local non SNA 3270
 - local SNA 3270 attached through 3791L
 - remote SNA 3270 attached through 3705 NCP
 - local SNA TTY emulated as 3767 attached through 3791L
 - remote SNA TTY emulated as 3767 attached through 3705 NCP

This version is a rework of the original TESTVTM2 port to MVS 3.8J
done by Greg Price in 2003. Device support relies on the specific
behavior of VTAM level 2 and may be incompatible with later ACF/VTAM
versions. It should be noted that 3270 terminals get queried
unconditionally. So please use tn3270 emulations supporting
WSF QUERY only (don't know if others do exist at all) and also
use real 3270 tubes supporting WSF QUERY only.

Juergen Winkelmann (JW), ETH Zuerich, June 2012
winkelmann@id.ethz.ch

Credits: Binyamin Dissen - original version
         Greg Price      - first non ACF (MVS 3.8j) port (GP@P6)
         Greg Price      - I've stolen all of the 3270 query
                           structured field analysis and
                           3270 buffer address conversion
                           logic from the brilliant 3270
                           datastream article and sample
                           program on his website

Installation
============

1. Upload and receive TESTVTM2.XMI to a PDS of your choice (LRECL 80).

2. Follow the instructions in member $$README.
