                   DISKMAP & DISKMAPA
                   ==================

DISKMAP comes from CBT Tape 129 file 260 and maps the layout of a
single disk pack.  This pack needs to be allocated to the job step

The function to be performed is specified via a JCL parameter.
The supported parameters are

    MAP.....produce a track map of volume
    PDS.....list all PDS directories on volume
    ISAM....list ISAM reorg info for datasets
    EXT.....list the extents of the datasets
    DUMP....list (hex) all DSCB's on volume
    EMPTY...list only datasets that are empty
    MODEL...will only list "model dscb's"
    SDUMP...list (hex) format 4 and 5 dscb's
    VOLS....only use ddnames of "volume--",
            format--"vols=x", where "x" is max #
    JDATE...list create/expire date in julian

DISKMAPA is a wrapper program that allocates all online
DASD units to the jobstep and then invokes the DISKMAP
utility to map ALL online DASD units

For a sample job see CBT.MVS3J.CNTL(DISKM#)
