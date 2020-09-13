Waterloo University WATFIV FORTRAN IV System
============================================

This is an update of Jay Moseley's WATFIV distribution with the following
changes:

- The distribution tape is written using IEBCOPY (partitioned datasets) and
  IEBGENER (sequential datasets). Jay's original distribution was in IEHMOVE
  format which isn't compatible with RAKF, a RACF replacement used on the
  popular TK4- Tur(n)key distribution of MVS 3.8j. The new tape format resolves
  the RAKF problems that occure when trying to read the original IEHMOVE tape
  on TK4- or other RAKF enabled systems.

- The printable version of the WATFIV User's Guide (dataset WATFIV.USER.GUIDE)
  on the original tape was damaged. It has now been fully recovered.

- The PDF version of the WATFIV User's Guide (file watfivug.pdf) of the original
  distribution has been deleted. Instead, a new PDF created from the recovered 
  printable dataset WATFIV.USER.GUIDE is now part of the distribution tape. It
  gets loaded as WATFIV.USER.GUIDE.PDF during installation and can be accessed
  by performing a binary download using the 3270 terminal emulation's download
  functionality.


Installation and Use
====================

1. Adapt job reload.jcl (found in folder jcl of the distribution) to your
   system's requirements and submit it.

   As distributed the job can be run without modifications on TK4-. Note,
   however, that, starting with Update 06, WATFIV is preinstalled and ready to
   use on TK4-.

   If this is a reinstall on a system having WATFIV already installed make sure
   to delete all datasets under the chosen high level qualifier (default WATFIV)
   before running this job.

2. Run job wattest.jcl (found in folder jcl of the distribution) to verify the
   installation. A return code of 4 is expected.

3. Perform a binary download of dataset WATFIV.USER.GUIDE.PDF using your 3270
   terminal emulation's download functionality. This dataset is a PDF of the
   WATFIV User's Guide and fully describes how to use WATFIV. Note, however,
   that chapter "4.3 USING THE INTERACTIVE DEBUGGING FACILITIES" applies to CMS
   only. Interactive debugging isn't supported on TSO with the given WATFIV
   version.

________________________________________________________________________________
Juergen Winkelmann, ETH Zuerich, October 2014
winkelmann@id.ethz.ch

Credits: Jay Moseley for making the original distribution available on
         http://www.jaymoseley.com/hercules/compilers/watfiv.htm
________________________________________________________________________________
