This collection assumes that you have installed the MVS Turnkey
system.  It has been installed and tested in that environment.
If you haven't installed the MVS Turnkey System, these files will
most probably work as well, but, you will have to do some adjustments
to JCL procedures etc

For instalation instructions see member $$INSTALL in this file

When you use the supplied JCL to load the Addon Utility tape to disk,
the following files will be created

   CBT.MVS38J.CNTL        - JCL
   CBT.MVS38J.ASM         - Assembler Source
   CBT.MVS38J.MACLIB      - Assembler Macros
   CBT.MVS38J.LOAD        - Preassembled load modules


The following functions etc are included
    APFCK    -  Check IEAAPFxx members for plausibility
    APFLS    -  List all APF priviledged datasets
    BRODSCAN -  Analyze SYS1.BRODSCAN *)
    CMDSBSYS -  the "#" command subsystem.  adds a lot of additional
                operator and/or TSO commands to MVS
                The source code of this package is provided on CBT tape
                249 file 266.  This file is required if you want to
                compile the package yourself.
    DISKM    -  Disk Mapping Program
    FCOOK    -  The fortune cookie jar
    MOVELOAD -  Preload IEHMOVE modules for better performance *)
    OSCMD    -  Execute OS commands from batch
    REQUEUE  -  Reques running job for later execution *)
    TAPEHDR  -  Display info about tape label *)
    SETPF    -  Set console PFKs from SETPFKxx parmlib members
    PA2SI    -  Pass JCL parameter to SYSIN
    PILOT    -  An MVS auto-pilot.  The package is
                a) work in progress
                b) hopefully growing in the future
                c) nevertheless functional
                It provides the facility to automatically reply to
                console WTORs, and to start MVS procedures as
                response to console WTOs
                It also allows to run scripts of MVS operator commands
                It is made up from the following modules
                * BSPPILOT - The Auto pilot communications task
                * BSPRUNSC - The RUN SCRIPTS module
                * IEECVXIT - An exit for automatically reply to WTORs
                             and to react to certain WTOs
                The fortune cookie jar and the SETPF function are also
                integrated into the BSP autopilot
    SMPSL    -  SMP Selection/filtering program.  see SMPSL@ for docs
    VTMWT    -  Wait for VTAM ACB to become active.  See VTMWT@ docs
