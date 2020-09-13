/* DYN75 (c) Copyright Jason Paul Winter, 2003,2009 */
/* Minor changes for dynamic loader use - Jan Jaeger */

/*
*** For *nix type systems: (be warned: this information is quite old!)
*** compile by: (Update "i686" to "i586" if required.) ***

gcc -DHAVE_CONFIG_H -I. -fomit-frame-pointer -O3 -march=i686 -W -Wall -shared -export-dynamic -o dyn75.dll dyn75.c tcpip.c .libs/libherc.dll.a .libs/libhercs.dll.a

  *** Or ***
  
gcc -DHAVE_CONFIG_H -I. -fomit-frame-pointer -O3 -march=i686 -W -Wall -shared -export-dynamic -o dyn75.dll dyn75.c tcpip.c hercules.a

libherc*.dll.a - is windows only, it's not required on unix.
It provides back-link support under cygwin.

If hercules is built without libtool, then hercules.a should
be used to include backlink support.

You can then issue ldmod dyninst dyn75 from the hercules panel,
or add the same statement to the hercules.cnf file.
*/

#include "hstdinc.h"

/* Original code from 2003/4 starts here... */

#include "hercules.h"

#if defined(WIN32) && !defined(HDL_USE_LIBTOOL)
/* We need to do some special tricks for cygwin here, since cygwin   */
/* does not support backlink and we need to resolve symbols during   */
/* dll initialisation (REGISTER/RESOLVER). Opcode tables are renamed */
/* such that no naming conflicts occur.                              */
 #define opcode_table opcode_table_r
 #define opcode_01xx  opcode_01xx_r
 #define opcode_a5xx  opcode_a5xx_r
 #define opcode_a4xx  opcode_a4xx_r
 #define opcode_a7xx  opcode_a1xx_r
 #define opcode_b2xx  opcode_b2xx_r
 #define opcode_b3xx  opcode_b3xx_r
 #define opcode_b9xx  opcode_b9xx_r
 #define opcode_c0xx  opcode_c0xx_r
 #define opcode_e3xx  opcode_e3xx_r
 #define opcode_e5xx  opcode_e5xx_r
 #define opcode_e6xx  opcode_e6xx_r
 #define opcode_ebxx  opcode_ebxx_r
 #define opcode_ecxx  opcode_ecxx_r
 #define opcode_edxx  opcode_edxx_r
 #define s370_opcode_table s370_opcode_table_r
 #define s390_opcode_table s390_opcode_table_r
 #define z900_opcode_table z900_opcode_table_r
#endif

#include "opcode.h"

#if defined(WIN32) && !defined(HDL_USE_LIBTOOL)
 #undef opcode_table
 #undef opcode_01xx
 #undef opcode_a5xx
 #undef opcode_a4xx
 #undef opcode_a7xx
 #undef opcode_b2xx
 #undef opcode_b3xx
 #undef opcode_b9xx
 #undef opcode_c0xx
 #undef opcode_e3xx
 #undef opcode_e5xx
 #undef opcode_e6xx
 #undef opcode_ebxx
 #undef opcode_ecxx
 #undef opcode_edxx
 #undef s370_opcode_table
 #undef s390_opcode_table
 #undef z900_opcode_table
#endif

#include "inline.h"

/*-------------------------------------------------------------------*/
/* 75xx TCP  - TCPIP Ra,yyy(Rb,Rc)  Ra=anything, Rc>4<14, Rb=0/ditto */
/*-------------------------------------------------------------------*/

extern int lar_tcpip (DW * regs); /* function in my tcpip.c file */
extern long map32[100];

/*
  R0  = 0 (Initially, but turns to > 0 after the native call.
  R1  = Byte Counter
  R2  = Source/Destination of PC buffer.  32bits.
  R3  = Direction (0 = to Host PC, 1 = from Host PC)
  R4  = Returned Bytes

  R7 \
  R8 |= Used by the lar_tcpip function (but not here.)
  R9 /

  R14 = Identifier (returned & passed back for conversations.)
  R15 = Work Variable / Return Code
*/

DEF_INST(dyninst_opcode_75) {
    int     r1;              /* Value of R field       */
    int     b2;              /* Base of effective addr */
    VADR    effective_addr2; /* Effective address      */
    int     i;
    unsigned char * s;

    /*  vv---vv---------------- input variables to TCPIP */
    RX(inst, regs, r1, b2, effective_addr2);
    /*                     ^^-- becomes yyy+gr[b]+gr[c] */
    /*                 ^^------ becomes access register c */
    /*             ^^---------- becomes to-store register a */

    if (regs->GR_L(0) == 0) { /* Only run when R0 = 0, (restart) */

        if (lar_tcpip (&(regs->gr [0])) == 0) { /* Get PC buffer */
            regs->GR_L(15) = -1; /* Error */
            return;
        }

        regs->GR_L(0) = 1;    /* Do not call native routine again */
    }

    if (regs->GR_L(1) != 0) s = (unsigned char *)(map32[regs->GR_L(2)]);

    while (regs->GR_L(1) != 0) { /* Finished > */

        i = regs->GR_L(1) - 1;
        if (i > 255) i = 255;

        if (regs->GR_L(3) == 0) { /* Going to host */
            /* Load bytes from operand address */
            ARCH_DEP(vfetchc) ( s, (unsigned char)i, effective_addr2, b2, regs );
        } else {                  /* Going from host */
            /* Store bytes at operand address */
            ARCH_DEP(vstorec) ( s, (unsigned char)i, effective_addr2, b2, regs );
        }

        i++;
        effective_addr2 += i;  /* No exception, quick copy without calc's */
        (regs->GR_L(b2)) += i; /* Exception, can recalculate if/when restart */
        s += i;                /* Next PC byte segment location */
        (regs->GR_L(1)) -= i;  /* One less segment to copy next time */
    }

    if (lar_tcpip (&(regs->gr [0])) == 0) { /* Run! */
        regs->GR_L(15) = -1; /* Error */
        return;
    }

    regs->GR_L(15) = 0; /* No error */
}

#if !defined(_GEN_ARCH)

#if defined(_ARCHMODE2)
#define _GEN_ARCH _ARCHMODE2
#include "dyn75.c"
#endif 

#if defined(_ARCHMODE3)
#undef _GEN_ARCH
#define _GEN_ARCH _ARCHMODE3
#include "dyn75.c"
#endif 

/* Libtool static name colision resolution */
/* note : lt_dlopen will look for symbol & modulename_LTX_symbol */
#if !defined(HDL_BUILD_SHARED) && defined(HDL_USE_LIBTOOL)
#define hdl_ddev dyn75_LTX_hdl_ddev
#define hdl_depc dyn75_LTX_hdl_depc
#define hdl_reso dyn75_LTX_hdl_reso
#define hdl_init dyn75_LTX_hdl_init
#define hdl_fini dyn75_LTX_hdl_fini
#endif

#endif /*!defined(_GEN_ARCH)*/
