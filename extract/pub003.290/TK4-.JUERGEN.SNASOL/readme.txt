SNASOL -- An Experimental Network Solicitor for SNA Terminals
=============================================================

SNASOL is an adaption of the TESTVTM2 sample VTAM application
which can be used as a network solicitor enabling SNA terminals
to bind to an application without needing stick man to self-initiate
(note that the network solicitor that comes with the VTAM Level 2
available on MVS 3.8j doesn't support SNA terminals and thus
doesn't cover this use case).

Juergen Winkelmann (JW), ETH Zuerich, July 2013
winkelmann@id.ethz.ch

Credits: Binyamin Dissen - original TESTVTM2 implementation
         Greg Price      - first non ACF (MVS 3.8j) port (GP@P6)
         Greg Price      - I've stolen all of the 3270 query
                           structured field analysis and
                           3270 buffer address conversion
                           logic from the brilliant 3270
                           datastream article and sample
                           program on his website

Installation
============

1. Upload and receive snasol.xmi to a PDS of your choice (LRECL 80).

2. Follow the instructions in member $$README.
