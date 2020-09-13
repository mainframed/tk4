                   THE # COMMAND SUBSYSTEM

You need to have file 266 from the CBT tape 249 available to be able
to run the installation jobs.  The jobs assume this file to be in
a PDS of the name CBT249.FILE266

Before using the # system you should read the documentation included
in CBT249.FILE266

CMDSB1   -  This Job will install the PTF UZ61025.  Without this PTF
            the needed assembly jobs will not assemble CMDSBSYS
            correctly.  The PTF has already been included during
            the RECEIVE for the Turnkey system (Version 2).

            This job is required unless you plan to install the
            pre-assembled and linked modules

            On the Turnkey system (Version 3) the PTF is already
            APPLYed and ACCEPTed, and you can omit this job

CMDSB2    - This job will install a USERMOD ZUM0004.  This usermod
            will add CMD1 to the subsystem name table.  This job
            is required, unless you are using the MVS Turnkey
            system Version 3, where the USERMOD is already APPLYed

CMDSB3    - Allocate the files for building CMDSBSYS.  Required if
            you want to reassemble CMDSBSYS, otherwise proceed to
            CMDSB6

CMDSB4    - Assemble and link of CMDSBSYS files. (Part1)  Required if
            you want to reassemble CMDSBSYS, otherwise proceed to
            CMDSB6

CMDSB5    - Assemble and link of CNDSBSYS files. (Part2)  Required if
            you want to reassemble CMDSBSYS, otherwise proceed to
            CMDSB6

CMDSB6    - Print the CMDSBSYS documentation.  Create CMDSBSYS
            procedures.  This job is required

CMDSB7    - Copy the (pre)linked modules to the correct target libs
            This job is required

CMDSB8    - You need to update the TSO authorized commands table.
            In the Turnkey system this is usermod ZUM001.  The
            source is in SYS1.UMODSRC(IKJEFTE2),
            and the JCL to install it is in this member

Remember to start CMD1 automatically by either placing

COM='S CMD1'

into SYS1.PARMLIB(COMMND00)
or by adding

$VS,'S CMD1'

to the OS command section of SYS1.PARMLIB(JES2PARM)
You need to IPL the system with the CLPA option, then you can use
the # command subsystem

