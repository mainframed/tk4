BYPASSNQ
========

This is a modification of the OS/VS2 (MVS 3.8j) version of Gilbert Saint-Flour's
BYPASSNQ utility. The following changes have been incorporated above the
original version as published on the CBT tape file 749:

- Backport to OS/VS2 completed (the original version had several compile and
  runtime bugs as a result of an obviously incomplete backport)

- RAC support added: If a ressource access control system is installed and
  active BYPASSNQ will execute only if the user has read access to profile
  NONQAUTH in the facility class. If RAC isn't installed or active, this
  change is transparent, i.e. access is allowed to everyone.


Installation Instructions
=========================

- Use RECV370 to receive the installation PDS.
- Optional: Copy members BYPASSNQ, BYPASCRN, and BYPASUPD to a source dataset.
- Edit job BYPASNQ$:
  o Change all occurances of SYS2.ASM to the name of your source dataset,
    or to the installation PDS if you didn't copy the source members.
  o Change all occurences of SYS2.LINKLIB to the name of the loadlib into
    which the BYPASSNQ module it to be linked.
- Submit BYPASNQ$. A zero return code is expected from all steps.


Optional Materials
==================

- The source members BYPASSNQ and BYPASCRN are the original source as published
  in CBT file 749. These are updated by install job BYPASNQ$ on the fly, then
  assembled and linked. The updated source is deleted after the assemblies and
  thus doesn't become visible except in the assembly listings. Member ASM38J of
  the installation PDS is an XMITted PDS containing the updated source. Receive
  it using RECV370 to view the source or add further updates.

- Member BIN38J of the installation PDS is an XMITted loadlib containing the
  ready to use BYPASSNQ module. If you just want to use BYPASSNQ and are not
  interested in building the module yourself, receive BIN38J into a loadlib of
  your choice (for example SYS2.LINKLIB) using RECV370.


Usage
=====

See the comment header of source member BYPASSNQ for usage examples.

May 2012, Juergen Winkelmann
winkelmann@id.ethz.ch
