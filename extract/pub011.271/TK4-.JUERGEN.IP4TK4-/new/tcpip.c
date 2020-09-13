/***********************************************************
 * C Socket Interface.
 * -------------------
 * To modify the Hercules emulator
 *
 * (see: EZASOKET.ASM)
 *
 * Copyright (c)2003,2009 Jason Paul Winter, All Rights Reserved.
 *
 ***********************************************************/

/* *** These are no longer needed due to the hstdinc.h #include below:
#include <winsock2.h>
#include <stdlib.h>
#include <stdio.h>
*/

#include "hstdinc.h"

#ifndef _MSVC_

/* Convert my Windows declarations back to normal *nix types if needed: */

#define SOCKET int
#define SOCKADDR struct sockaddr
#define SOCKADDR_IN struct sockaddr_in
#define LPSOCKADDR struct sockaddr *

#define closesocket close
#define ioctlsocket ioctl

#define INVALID_SOCKET -1
#define SOCKET_ERROR -1

#endif

typedef struct talk_tag * talk_ptr;
typedef struct talk_tag {
    long   len_in;
    char * buffer_in;
    long   len_out;
    char * buffer_out;
    long   ret_cd;
} talk;

typedef struct selects_tag * selects_ptr;
typedef struct selects_tag {
    long   len;
    long   invalid;
    long * ri;
    long * wi;
    long * ei;
    long * ro;
    long * wo;
    long * eo;
} selects;

//void EZASOKET (long func, long aux1, long aux2, talk_ptr t);

/**********************************************************************************/
/**********************************************************************************/
/**********************************************************************************/

static unsigned char DCCascii_to_ebcdic[] = {
    "\x00\x01\x02\x03\x37\x2D\x2E\x2F\x16\x05\x15\x0B\x0C\x0D\x0E\x0F"
    "\x10\x11\x12\x13\x3C\x3D\x32\x26\x18\x19\x3F\x27\x1C\x1D\x1E\x1F"
    "\x40\x5A\x7F\x7B\x5B\x6C\x50\x7D\x4D\x5D\x5C\x4E\x6B\x60\x4B\x61"
    "\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\x7A\x5E\x4C\x7E\x6E\x6F"
    "\x7C\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xD1\xD2\xD3\xD4\xD5\xD6"
    "\xD7\xD8\xD9\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xAD\xE0\xBD\x5F\x6D"
    "\x79\x81\x82\x83\x84\x85\x86\x87\x88\x89\x91\x92\x93\x94\x95\x96"
    "\x97\x98\x99\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xC0\x4F\xD0\xA1\x07"
    "\x20\x21\x22\x23\x24\x25\x06\x17\x28\x29\x2A\x2B\x2C\x09\x0A\x1B"
    "\x30\x31\x1A\x33\x34\x35\x36\x08\x38\x39\x3A\x3B\x04\x14\x3E\xFF"
    "\x41\xAA\x4A\xB1\x9F\xB2\x6A\xB5\xBB\xB4\x9A\x8A\xB0\xCA\xAF\xBC"
    "\x90\x8F\xEA\xFA\xBE\xA0\xB6\xB3\x9D\xDA\x9B\x8B\xB7\xB8\xB9\xAB"
    "\x64\x65\x62\x66\x63\x67\x9E\x68\x74\x71\x72\x73\x78\x75\x76\x77"
    "\xAC\x69\xED\xEE\xEB\xEF\xEC\xBF\x80\xFD\xFE\xFB\xFC\xBA\xAE\x59"
    "\x44\x45\x42\x46\x43\x47\x9C\x48\x54\x51\x52\x53\x58\x55\x56\x57"
    "\x8C\x49\xCD\xCE\xCB\xCF\xCC\xE1\x70\xDD\xDE\xDB\xDC\x8D\x8E\xDF"
};

static unsigned char DCCebcdic_to_ascii[] = {
    "\x00\x01\x02\x03\x9C\x09\x86\x7F\x97\x8D\x8E\x0B\x0C\x0D\x0E\x0F"
    "\x10\x11\x12\x13\x9D\x0A\x08\x87\x18\x19\x92\x8F\x1C\x1D\x1E\x1F"
    "\x80\x81\x82\x83\x84\x85\x17\x1B\x88\x89\x8A\x8B\x8C\x05\x06\x07"
    "\x90\x91\x16\x93\x94\x95\x96\x04\x98\x99\x9A\x9B\x14\x15\x9E\x1A"
    "\x20\xA0\xE2\xE4\xE0\xE1\xE3\xE5\xE7\xF1\xA2\x2E\x3C\x28\x2B\x7C"
    "\x26\xE9\xEA\xEB\xE8\xED\xEE\xEF\xEC\xDF\x21\x24\x2A\x29\x3B\x5E"
    "\x2D\x2F\xC2\xC4\xC0\xC1\xC3\xC5\xC7\xD1\xA6\x2C\x25\x5F\x3E\x3F"
    "\xF8\xC9\xCA\xCB\xC8\xCD\xCE\xCF\xCC\x60\x3A\x23\x40\x27\x3D\x22"
    "\xD8\x61\x62\x63\x64\x65\x66\x67\x68\x69\xAB\xBB\xF0\xFD\xFE\xB1"
    "\xB0\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\xAA\xBA\xE6\xB8\xC6\xA4"
    "\xB5\x7E\x73\x74\x75\x76\x77\x78\x79\x7A\xA1\xBF\xD0\x5B\xDE\xAE"
    "\xAC\xA3\xA5\xB7\xA9\xA7\xB6\xBC\xBD\xBE\xDD\xA8\xAF\x5D\xB4\xD7"
    "\x7B\x41\x42\x43\x44\x45\x46\x47\x48\x49\xAD\xF4\xF6\xF2\xF3\xF5"
    "\x7D\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\xB9\xFB\xFC\xF9\xFA\xFF"
    "\x5C\xF7\x53\x54\x55\x56\x57\x58\x59\x5A\xB2\xD4\xD6\xD2\xD3\xD5"
    "\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\xB3\xDB\xDC\xD9\xDA\x9F"
};

/**********************************************************************************/
/**********************************************************************************/
/**********************************************************************************/

#define hercNBBY 8
#define hercFD_SETSIZE	256
typedef long hercfd_mask;
#define hercNFDBITS (sizeof(hercfd_mask) * hercNBBY)
#define	herchowmany(x, y) (((x) + ((y) - 1)) / (y))

typedef	struct hercfd_set {
    hercfd_mask hercfds_bits [herchowmany(hercFD_SETSIZE, hercNFDBITS)];
} hercfd_set;

#define hercFD_SET(n, p)    ((p)->hercfds_bits[(n)/hercNFDBITS] |= (1 << ((n) % hercNFDBITS)))
#define hercFD_CLR(n, p)    ((p)->hercfds_bits[(n)/hercNFDBITS] &= ~(1 << ((n) % hercNFDBITS)))
#define hercFD_ISSET(n, p)  ((p)->hercfds_bits[(n)/hercNFDBITS] & (1 << ((n) % hercNFDBITS)))

/**********************************************************************************/
/**********************************************************************************/
/**********************************************************************************/

#define Ccom 1024        /* 1023, as the first is never used (=0) */

static char    Ccom_opn [Ccom];
static char    Ccom_blk [Ccom]; /* Is a blocking socket? */
static SOCKET  Ccom_han [Ccom];

static long    CerrGen;         /* Last error, thread-dodgy but it's only used for "non socket" errors */
static long    Cerr     [Ccom]; /* Last error for specific socket, this one is thread safe. */

static selects_ptr Cselect [Ccom];      /* Array for the 3 arrays of select input/output data */

/**********************************************************************************/

#ifdef _MSVC_

/* When using MSVC, just use the normal critical section functions: */

#undef initialize_lock
#undef LOCK
#undef obtain_lock
#undef release_lock

#define initialize_lock InitializeCriticalSection
#define LOCK CRITICAL_SECTION
#define obtain_lock EnterCriticalSection
#define release_lock LeaveCriticalSection

#else

/* If unix, include whatever hercules defines */

#include "hercules.h"

#endif

static LOCK tcpip_lock;

static long tcpip_init_req = 1;

static void tcpip_init () {
    long i;


    initialize_lock(&tcpip_lock);

    CerrGen = 0;

    i = 0;
    while (i < Ccom) {
        Cselect [i] = NULL;

        Cerr [i] = 0;
        Ccom_blk [i] = 1;
        Ccom_han [i] = -1;
        Ccom_opn [i++] = 0;
    }
}

/**********************************************************************************/

#define hEMFILE          24		/* Too many open files */
/* non-blocking and interrupt i/o */
#define	hEAGAIN          35		/* Resource temporarily unavailable */
#define	hEWOULDBLOCK     hEAGAIN /* Operation would block */
#define	hEINPROGRESS     36		/* Operation now in progress */
#define	hEALREADY        37		/* Operation already in progress */

/* ipc/network software -- argument errors */
#define	hENOTSOCK        38		/* Socket operation on non-socket */
#define	hEDESTADDRREQ    39		/* Destination address required */
#define	hEMSGSIZE        40		/* Message too long */
#define	hEPROTOTYPE      41		/* Protocol wrong type for socket */
#define	hENOPROTOOPT     42		/* Protocol not available */
#define	hEPROTONOSUPPORT 43		/* Protocol not supported */
#define	hESOCKTNOSUPPORT 44		/* Socket type not supported */
#define	hEOPNOTSUPP      45		/* Operation not supported */
#define	hEPFNOSUPPORT    46		/* Protocol family not supported */
#define	hEAFNOSUPPORT    47		/* Address family not supported by protocol family */
#define	hEADDRINUSE      48		/* Address already in use */
#define	hEADDRNOTAVAIL   49		/* Can't assign requested address */

/* ipc/network software -- operational errors */
#define hENETDOWN        50		/* Network is down */
#define hENETUNREACH     51		/* Network is unreachable */
#define hENETRESET       52		/* Network dropped connection on reset */
#define hECONNABORTED    53		/* Software caused connection abort */
#define hECONNRESET      54		/* Connection reset by peer */
#define hENOBUFS         55		/* No buffer space available */
#define hEISCONN         56		/* Socket is already connected */
#define hENOTCONN        57		/* Socket is not connected */
#define hESHUTDOWN       58		/* Can't send after socket shutdown */
#define hETOOMANYREFS    59		/* Too many references: can't splice */
#define hETIMEDOUT       60		/* Operation timed out */
#define hECONNREFUSED    61		/* Connection refused */

/* Other */
#define hEINVAL          22		/* Invalid argument */
#define hELOOP           62		/* Too many levels of symbolic links */
#define hENAMETOOLONG    63		/* File name too long */
#define hEHOSTDOWN       64		/* Host is down */
#define hEHOSTUNREACH    65		/* No route to host */
#define hENOTEMPTY       66		/* Directory not empty */
#define hEPROCLIM        67		/* Too many processes */
#define hEUSERS          68		/* Too many users */
#define hEDQUOT          69		/* Disc quota exceeded */
#define hESTALE          70		/* Stale NFS file handle */
#define hEREMOTE         71		/* Too many levels of remote in path */

#ifndef _MSVC_

/* Reverse my MSVC changes for Non MSVC compilers: */

#define fEMFILE          EMFILE
#define fEINVAL          EINVAL
#define fENAMETOOLONG    ENAMETOOLONG
#define fENOTEMPTY       ENOTEMPTY

#else

/* New MSVC compilers have EMFILE, EINVAL, ENAMETOOLONG and ENOTEMPTY */
/* defined in multiple places - so some new code here adds a 'f'ix!  */
/* This is what we need to do with error #s: Windows->Unix->Hercules */

#define fEMFILE          WSAEMFILE
#define  EWOULDBLOCK     WSAEWOULDBLOCK /* Is also EAGAIN */
#define  EINPROGRESS     WSAEINPROGRESS
#define  EALREADY        WSAEALREADY

#define  ENOTSOCK        WSAENOTSOCK
#define  EDESTADDRREQ    WSAEDESTADDRREQ
#define  EMSGSIZE        WSAEMSGSIZE
#define  EPROTOTYPE      WSAEPROTOTYPE
#define  ENOPROTOOPT     WSAENOPROTOOPT
#define  EPROTONOSUPPORT WSAEPROTONOSUPPORT
#define  ESOCKTNOSUPPORT WSAESOCKTNOSUPPORT
#define  EOPNOTSUPP      WSAEOPNOTSUPP
#define  EPFNOSUPPORT    WSAEPFNOSUPPORT
#define  EAFNOSUPPORT    WSAEAFNOSUPPORT
#define  EADDRINUSE      WSAEADDRINUSE
#define  EADDRNOTAVAIL   WSAEADDRNOTAVAIL

#define  ENETDOWN        WSAENETDOWN
#define  ENETUNREACH     WSAENETUNREACH
#define  ENETRESET       WSAENETRESET
#define  ECONNABORTED    WSAECONNABORTED
#define  ECONNRESET      WSAECONNRESET
#define  ENOBUFS         WSAENOBUFS
#define  EISCONN         WSAEISCONN
#define  ENOTCONN        WSAENOTCONN
#define  ESHUTDOWN       WSAESHUTDOWN
#define  ETOOMANYREFS    WSAETOOMANYREFS
#define  ETIMEDOUT       WSAETIMEDOUT
#define  ECONNREFUSED    WSAECONNREFUSED

#define fEINVAL          WSAEINVAL
#define  ELOOP           WSAELOOP
#define fENAMETOOLONG    WSAENAMETOOLONG
#define  EHOSTDOWN       WSAEHOSTDOWN
#define  EHOSTUNREACH    WSAEHOSTUNREACH
#define fENOTEMPTY       WSAENOTEMPTY
#define  EPROCLIM        WSAEPROCLIM
#define  EUSERS          WSAEUSERS
#define  EDQUOT          WSAEDQUOT
#define  ESTALE          WSAESTALE
#define  EREMOTE         WSAEREMOTE

#endif

/* This is the error translation routine for whatever host to Hercules: */
static int Get_errno () {
    long i;
    
#ifndef _MSVC_
    i = errno;
#else
    i = WSAGetLastError ();
#endif

    switch (i) {
    case fEMFILE:
        return (hEMFILE);
/*    case EAGAIN:
        return (hEAGAIN);  SAME AS EWOULDBLOCK*/
    case EWOULDBLOCK:
        return (hEWOULDBLOCK);
    case EINPROGRESS:
        return (hEINPROGRESS);
    case EALREADY:
        return (hEALREADY);
    case ENOTSOCK:
        return (hENOTSOCK);
    case EDESTADDRREQ:
        return (hEDESTADDRREQ);
    case EMSGSIZE:
        return (hEMSGSIZE);
    case EPROTOTYPE:
        return (hEPROTOTYPE);
    case ENOPROTOOPT:
        return (hENOPROTOOPT);
    case EPROTONOSUPPORT:
        return (hEPROTONOSUPPORT);
    case ESOCKTNOSUPPORT:
        return (hESOCKTNOSUPPORT);
    case EOPNOTSUPP:
        return (hEOPNOTSUPP);
    case EPFNOSUPPORT:
        return (hEPFNOSUPPORT);
    case EAFNOSUPPORT:
        return (hEAFNOSUPPORT);
    case EADDRINUSE:
        return (hEADDRINUSE);
    case EADDRNOTAVAIL:
        return (hEADDRNOTAVAIL);
    case ENETDOWN:
        return (hENETDOWN);
    case ENETUNREACH:
        return (hENETUNREACH);
    case ENETRESET:
        return (hENETRESET);
    case ECONNABORTED:
        return (hECONNABORTED);
    case ECONNRESET:
        return (hECONNRESET);
    case ENOBUFS:
        return (hENOBUFS);
    case EISCONN:
        return (hEISCONN);
    case ENOTCONN:
        return (hENOTCONN);
    case ESHUTDOWN:
        return (hESHUTDOWN);
    case ETOOMANYREFS:
        return (hETOOMANYREFS);
    case ETIMEDOUT:
        return (hETIMEDOUT);
    case ECONNREFUSED:
        return (hECONNREFUSED);
    case fEINVAL :
        return (hEINVAL);
    case ELOOP :
        return (hELOOP);
    case fENAMETOOLONG :
        return (hENAMETOOLONG);
    case EHOSTDOWN :
        return (hEHOSTDOWN);
    case EHOSTUNREACH :
        return (hEHOSTUNREACH);
    case fENOTEMPTY :
        return (hENOTEMPTY);
#ifdef EPROCLIM // Some *nixs don't have this error
    case EPROCLIM :
        return (hEPROCLIM);
#endif
    case EUSERS :
        return (hEUSERS);
    case EDQUOT :
        return (hEDQUOT);
    case ESTALE :
        return (hESTALE);
    case EREMOTE :
        return (hEREMOTE);
    }

    return (i);
}

/**********************************************************************************/

#if defined(WORDS_BIGENDIAN)

/*
  regs comming in: (Non Intel Format - msb first.)
           /--R0--\          /--R1--\
  00000000 xxxxxxxx 00000000 yyyyyyyy ...
  (Zeros are the 64bit register parts, never used in S370.)
*/

static void set_reg (long * regs, long r, long v) {
    regs [(r * 2) + 1] = v;
}

static long get_reg (long * regs, long r) {
    return (regs [(r * 2) + 1]);
}

#else

/*
  regs comming in: (Intel Format - lsb first.)
  /--R0--\          /--R1--\
  xxxxxxxx 00000000 yyyyyyyy 00000000 ...
  (Zeros are the 64bit register parts, never used in S370.)
*/

static void set_reg (long * regs, long r, long v) {
    regs [r * 2] = v;
}

static long get_reg (long * regs, long r) {
    return (regs [r * 2]);
}

#endif

/**********************************************************************************/

static long check_not_sock (long s, talk_ptr t) {

    if ((s < 1) || (s >= Ccom)) {
        t->ret_cd = -1;
        return (1);
    }

    if (Ccom_han [s] == -1) {
        t->ret_cd = -1;
        return (1);
    }

    return (0);
}

static void EZASOKET (long func, long aux1, long aux2, talk_ptr t) {
	long   i;
    socklen_t  isock;
    long   k;
    long   l;
    long   m;
	long   size;
    struct hostent * hp;
    struct timeval timeout;
    fd_set sockets;
    SOCKADDR_IN Clocal_adx;
    SOCKADDR    Slocal_adx;

    switch (func & 0xFF) {
    case 1:  /* INITAPI */

        t->ret_cd = 0;
		return;

    case 2:  /* GETERRORS */
 
        if (check_not_sock (aux1, t)) {
            t->ret_cd = hENOTSOCK;
            return;
        }

        t->ret_cd = Cerr [aux1];
		return;

    case 3:  /* GETERROR */
    
        t->ret_cd = CerrGen;
		return;

    case 4:  /* GETHOSTBYNAME */
    
        if ((hp = gethostbyname (t->buffer_in)) == NULL) {
            
            CerrGen = Get_errno ();

            t->ret_cd = 0;
            return;
        } else {
            if (hp->h_addr_list [0] == NULL) {
                t->ret_cd = 0;
                return;
            } else {
                t->ret_cd = (ntohl(((long *)(hp->h_addr_list [0])) [0]));
                return;
            }
        }

    case 5:  /* SOCKET */
    
        obtain_lock (&tcpip_lock);

        m = 1;
        while (m < Ccom) {
            if (Ccom_opn [m] == 0) break;
            m++;
        }
        if (m == Ccom) {

            CerrGen = hEMFILE;
            
            release_lock (&tcpip_lock);

            t->ret_cd = -1;
            return;  /* None available. */
        }

        i = aux1 >> 16; /* Family: eg. PF_INET */

		if ((Ccom_han [m] = socket (i, (aux1 & 0xFFFF), aux2)) == INVALID_SOCKET) {

            CerrGen = Get_errno ();

            release_lock (&tcpip_lock);

            t->ret_cd = -1;
			return;  /* ERROR */
		}

        Ccom_opn [m] = 1;

        release_lock (&tcpip_lock);

        t->ret_cd = m;
        return;

    case 6:  /* BIND */

        /* FUNC:SOCK&FUNC, AUX1:ADDRESS, AUX2:FAMILY&PORT */

		m = func >> 16; /* SOCKET # */
        i = aux2 >> 16; /* Family */

        if (check_not_sock (m, t)) return;

        /* set up socket */
		Clocal_adx.sin_family = (short)(i & 0xFF);
		
        Clocal_adx.sin_addr.s_addr = htonl (aux1);

		Clocal_adx.sin_port = htons ((unsigned short)(aux2 & 0xFFFF));

        if (bind (Ccom_han [m], (LPSOCKADDR)&Clocal_adx, sizeof (Clocal_adx))) {

            Cerr [m] = Get_errno ();

            t->ret_cd = -1;
			return;  /* ERROR */
		}

        t->ret_cd = 0;
		return;

    case 7:  /* CONNECT */

		m = func >> 16; /* SOCKET # */
        i = aux2 >> 16; /* Family */

        if (check_not_sock (m, t)) return;

		/* set up socket */
		Clocal_adx.sin_family = (short)(i & 0xFF);
		
        Clocal_adx.sin_addr.s_addr = htonl (aux1);
		
        Clocal_adx.sin_port = htons ((unsigned short)(aux2 & 0xFFFF));

        k = 1;
        ioctlsocket (Ccom_han [m], FIONBIO, &k);

        i = connect (Ccom_han [m], (LPSOCKADDR)&Clocal_adx, sizeof (Clocal_adx));
        Cerr [m] = Get_errno ();
        
        k = 0;
        ioctlsocket (Ccom_han [m], FIONBIO, &k);

		if (i == -1) {
            
            switch (Cerr [m]) {
            case hEISCONN :
                t->ret_cd = 0;  /* Worked! */
                return;

            case hEINVAL :      /* WSAEALREADY in Windows old sockets */
            case hEALREADY :
            case hEWOULDBLOCK :
            case hEINPROGRESS :

                if (Ccom_blk [m] == 0) {
                    t->ret_cd = -1;
	    		    return;  /* ERROR, But Client Knows... */
                }

                t->ret_cd = -2; /* Must wait. */
                return;
            }

            t->ret_cd = -1;
			return;  /* ERROR */
		}

        t->ret_cd = 0;
		return;

    case 8:  /* LISTEN */

        if (check_not_sock (aux1, t)) return;

        i = aux2;
        if (i == 0) i = SOMAXCONN;

		if (listen (Ccom_han [aux1], i)) {

            Cerr [aux1] = Get_errno ();

            t->ret_cd = -1;
		    return;  /* ERROR */
		}

        t->ret_cd = 0;
		return;

    case 9:  /* ACCEPT */

        if (check_not_sock (aux1, t)) return;

        obtain_lock (&tcpip_lock);

        m = 1;
        while (m < Ccom) {
            if (Ccom_opn [m] == 0) break;
            m++;
        }

        if (m == Ccom) {

            Cerr [aux1] = hEMFILE;

            release_lock (&tcpip_lock);

            t->ret_cd = -1;
            return; /* None available. */
        }

        isock = sizeof (Slocal_adx);
        
        timeout.tv_sec = 0;
        timeout.tv_usec = 0;

        FD_ZERO (&sockets);
        FD_SET (Ccom_han [aux1], &sockets);

        if (select (Ccom_han [aux1] + 1, &sockets, NULL, NULL, &timeout) == 0) {

            release_lock (&tcpip_lock);

            if (Ccom_blk [aux1]) {
                t->ret_cd = -2;
            } else {
                Cerr [aux1] = hEWOULDBLOCK;
                t->ret_cd = -1;
            }
            return;
        }

        l = Ccom_han [m] = accept (Ccom_han [aux1], &Slocal_adx, &isock);

        if (l == INVALID_SOCKET) {

            Cerr [aux1] = Get_errno ();

            release_lock (&tcpip_lock);

            t->ret_cd = -1;
            return;  /* ERROR */
		}

        Ccom_opn [m] = 1;

        release_lock (&tcpip_lock);

        t->len_out = sizeof (Clocal_adx);
        t->buffer_out = (char *)malloc (t->len_out);
        memcpy (t->buffer_out, &Slocal_adx, t->len_out);
        ((SOCKADDR_IN *)(t->buffer_out))->sin_family = htons (((SOCKADDR_IN *)(t->buffer_out))->sin_family);

        t->ret_cd = m;
        return;

    case 10: /* SEND */

        if (check_not_sock (aux1, t)) return;

        if ((l = send (Ccom_han [aux1], t->buffer_in, t->len_in, 0)) == SOCKET_ERROR) {

            Cerr [aux1] = Get_errno ();

            t->ret_cd = -1;
			return;
		}

        t->ret_cd = l;
        return;

    case 11: /* RECV */

        if (check_not_sock (aux1, t)) return;

        timeout.tv_sec = 0;
        timeout.tv_usec = 0;

        FD_ZERO (&sockets);
        FD_SET (Ccom_han [aux1], &sockets);

        if (select (Ccom_han [aux1] + 1, &sockets, NULL, NULL, &timeout) == 0) {

            if (Ccom_blk [aux1]) {
                t->ret_cd = -2;
            } else {
                Cerr [aux1] = hEWOULDBLOCK;
                t->ret_cd = -1;
            }
            return;
        }

        t->buffer_out = (char *)malloc (aux2);

        if ((size = recv (Ccom_han [aux1], t->buffer_out, aux2, 0)) == SOCKET_ERROR) {	/* receive command */

            Cerr [aux1] = Get_errno ();

            t->len_out = 0;
            free (t->buffer_out);
            t->buffer_out = NULL;

            t->ret_cd = -1;
            return;
		}

        t->len_out = size;
        t->ret_cd = size;
        return;

    case 12: /* CLOSE */
    
        if ((aux1 > 0) && (aux1 < Ccom)) {
            /* close connection */
            if (Ccom_opn [aux1])
			    closesocket (Ccom_han [aux1]);

            Ccom_opn [aux1] = 0;
            Ccom_han [aux1] = -1;
            Ccom_blk [aux1] = 1;
        }

        t->ret_cd = 0;
		return;

    case 13: /* EBCDIC2ASCII */

        t->len_out = t->len_in;
        t->buffer_out = (char *)malloc (t->len_out);

        m = t->len_out;
        i = 0;
        k = 0;
        while (m) {
            t->buffer_out [k++] = DCCebcdic_to_ascii [(unsigned char)(t->buffer_in [i++])];
            m--;
        }

        t->ret_cd = t->len_out;
        return;

    case 14: /* ASCII2EBCDIC */

        t->len_out = t->len_in;
        t->buffer_out = (char *)malloc (t->len_out);

        m = t->len_out;
        i = 0;
        k = 0;
        while (m) {
            t->buffer_out [k++] = DCCascii_to_ebcdic [(unsigned char)(t->buffer_in [i++])];
            m--;
        }

        t->ret_cd = t->len_out;
        return;

    case 15: /* IOCTL */

        m = func >> 16;

        if (check_not_sock (m, t)) return;

        if (aux1 == 1) {
            
            if (aux2) {
                Ccom_blk [m] = 0; /* No longer blocking */
            } else {
                Ccom_blk [m] = 1;
            }

            t->ret_cd = 0;

        } else {
        
            i = ioctlsocket (Ccom_han [m], FIONREAD, &(t->ret_cd));
            if (i == -1) {
                t->ret_cd = -1;
                Cerr [m] = Get_errno ();
            }
        }

        return;

    case 16: /* GETSOCKNAME */

        if (check_not_sock (aux1, t)) return;

        t->len_out = sizeof (Clocal_adx);
        t->buffer_out = (char *)malloc (t->len_out);

        isock = t->len_out;
        t->ret_cd = getsockname (Ccom_han [aux1], (struct sockaddr *)(t->buffer_out), &isock);

        if (t->ret_cd == -1) {
            Cerr [aux1] = Get_errno ();
        } else {
            ((SOCKADDR_IN *)(t->buffer_out))->sin_family = htons (((SOCKADDR_IN *)(t->buffer_out))->sin_family);
        }

        return;

    case 17: /* SELECT */

        /* func>>16 = socket
           aux1 = func subcode
           aux2 = maxsock+1 */

        m = func >> 16;

        if (check_not_sock (m, t)) return;

        switch (aux1 & 0xFF) {
        case 0:  /* Start */
            if (Cselect [m] == NULL) { /* Start-part */
                
                Cselect [m] = malloc (sizeof (selects));
                
                Cselect [m]->ri = malloc (sizeof (fd_set));
                Cselect [m]->wi = malloc (sizeof (fd_set));
                Cselect [m]->ei = malloc (sizeof (fd_set));

                Cselect [m]->ro = malloc (sizeof (fd_set));
                Cselect [m]->wo = malloc (sizeof (fd_set));
                Cselect [m]->eo = malloc (sizeof (fd_set));
            }

            FD_ZERO ((fd_set *)(Cselect [m]->ri));
            FD_ZERO ((fd_set *)(Cselect [m]->wi));
            FD_ZERO ((fd_set *)(Cselect [m]->ei));

            Cselect [m]->len = 0;
            Cselect [m]->invalid = 0;

            t->ret_cd = 0;
            return;

        case 1:  /* Read Inputs */

            Cselect [m]->len = t->len_in; /* Copy every time... */

            /* Need to bswap every long in the incoming array... */
            i = t->len_in / 4;
            while (i) {
                i--;
                ((long *)t->buffer_in) [i] = htonl (((long *)t->buffer_in) [i]);
            }

            i = 0;
            while (i < aux2) {
                if (hercFD_ISSET (i, (hercfd_set *)(t->buffer_in))) {
                    if (Ccom_han [i] == -1) {
                        Cselect [m]->invalid = 1;
                    } else {
                        FD_SET (Ccom_han [i], (fd_set *)(Cselect [m]->ri));
                    }
                }
                i++;
            }

            t->ret_cd = 0;
            return;

        case 2:  /* Write Inputs */

            Cselect [m]->len = t->len_in; /* Copy every time... */

            /* Need to bswap every long in the incoming array... */
            i = t->len_in / 4;
            while (i) {
                i--;
                ((long *)t->buffer_in) [i] = htonl (((long *)t->buffer_in) [i]);
            }

            i = 0;
            while (i < aux2) {
                if (hercFD_ISSET (i, (hercfd_set *)(t->buffer_in))) {
                    if (Ccom_han [i] == -1) {
                        Cselect [m]->invalid = 1;
                    } else {
                        FD_SET (Ccom_han [i], (fd_set *)(Cselect [m]->wi));
                    }
                }
                i++;
            }

            t->ret_cd = 0;
            return;

        case 3:  /* Exception Inputs */

            Cselect [m]->len = t->len_in; /* Copy every time... */

            /* Need to bswap every long in the incoming array... */
            i = t->len_in / 4;
            while (i) {
                i--;
                ((long *)t->buffer_in) [i] = htonl (((long *)t->buffer_in) [i]);
            }

            i = 0;
            while (i < aux2) {
                if (hercFD_ISSET (i, (hercfd_set *)(t->buffer_in))) {
                    if (Ccom_han [i] == -1) {
                        Cselect [m]->invalid = 1;
                    } else {
                        FD_SET (Ccom_han [i], (fd_set *)(Cselect [m]->ei));
                    }
                }
                i++;
            }

            t->ret_cd = 0;
            return;

        case 4:  /* Run 'select' (never blocking here, so may loop back.) */

            memcpy (Cselect [m]->ro, Cselect [m]->ri, sizeof (fd_set));
            memcpy (Cselect [m]->wo, Cselect [m]->wi, sizeof (fd_set));
            memcpy (Cselect [m]->eo, Cselect [m]->ei, sizeof (fd_set));

            if (Cselect [m]->invalid) {
                Cerr [m] = hENOTSOCK;
                t->ret_cd = -1;
                return;
            }

            timeout.tv_sec = 0;
            timeout.tv_usec = 0;

            i = select (Ccom_han [aux2 - 1] + 1,
                        (fd_set *)(Cselect [m]->ro),
                        (fd_set *)(Cselect [m]->wo),
                        (fd_set *)(Cselect [m]->eo),
                        &timeout);

            if (i == 0) {
                t->ret_cd = -2; /* Let the caller decide what to do. */
            } else {
                t->ret_cd = i;
            }
            return;

        case 5:  /* Read Outputs */

            t->len_out = Cselect [m]->len;
            t->buffer_out = (char *)malloc (t->len_out);
            memset (t->buffer_out, 0, t->len_out);

            i = 0;
            while (i < aux2) {
                if (Ccom_han [i] != -1)
                    if (FD_ISSET (Ccom_han [i], (fd_set *)(Cselect [m]->ro)))
                        hercFD_SET (i, (hercfd_set *)(t->buffer_out));
                i++;
            }

            /* Need to bswap every long in the outgoing array... */
            i = t->len_out / 4;
            while (i) {
                i--;
                ((long *)t->buffer_out) [i] = htonl (((long *)t->buffer_out) [i]);
            }

            t->ret_cd = 0;
            return;

        case 6:  /* Write Outputs */

            t->len_out = Cselect [m]->len;
            t->buffer_out = (char *)malloc (t->len_out);
            memset (t->buffer_out, 0, t->len_out);

            i = 0;
            while (i < aux2) {
                if (Ccom_han [i] != -1)
                    if (FD_ISSET (Ccom_han [i], (fd_set *)(Cselect [m]->wo)))
                        hercFD_SET (i, (hercfd_set *)(t->buffer_out));
                i++;
            }

            /* Need to bswap every long in the outgoing array... */
            i = t->len_out / 4;
            while (i) {
                i--;
                ((long *)t->buffer_out) [i] = htonl (((long *)t->buffer_out) [i]);
            }

            t->ret_cd = 0;
            return;

        case 7:  /* Exception Outputs */

            t->len_out = Cselect [m]->len;
            t->buffer_out = (char *)malloc (t->len_out);
            memset (t->buffer_out, 0, t->len_out);

            i = 0;
            while (i < aux2) {
                if (Ccom_han [i] != -1)
                    if (FD_ISSET (Ccom_han [i], (fd_set *)(Cselect [m]->eo)))
                        hercFD_SET (i, (hercfd_set *)(t->buffer_out));
                i++;
            }

            /* Need to bswap every long in the outgoing array... */
            i = t->len_out / 4;
            while (i) {
                i--;
                ((long *)t->buffer_out) [i] = htonl (((long *)t->buffer_out) [i]);
            }

            t->ret_cd = 0;
            return;

        case 8:  /* Finish */

            if (Cselect [m] != NULL) { /* Clean-up */
                
                free (Cselect [m]->ri);
                free (Cselect [m]->wi);
                free (Cselect [m]->ei);

                free (Cselect [m]->ro);
                free (Cselect [m]->wo);
                free (Cselect [m]->eo);

                free (Cselect [m]);
                Cselect [m] = NULL;
            }

            t->ret_cd = 0;
            return;
        }

        return;
    }

    t->ret_cd = 0;
    return;
}

/**********************************************************************************/
/*
  R0  = 0 (Initially, but turns to > 0 after the native call.
  R1  = Byte Counter
  R2  = Source/Destination of PC buffer.  32bits.
  R3  = Direction (0 = to Host PC, 1 = from Host PC)
  R4  = Returned Bytes

  R7  = Function
  R8  = Aux. value 1
  R9  = Aux. value 2

  R14 = Identifier (returned & passed back for conversations.)
  R15 = Work Variable / Return Code
*/

long lar_tcpip (long * regs) {
    talk_ptr t;

    if (tcpip_init_req) {
        tcpip_init_req = 0;
        tcpip_init ();
    }

    if (get_reg (regs, 0) == 0) { /* Initial call. */

        if (get_reg (regs, 3) == 0) { /* Alloc memory for this communication. */

            t = (talk_ptr)malloc (sizeof (talk));
            
            t->len_in = get_reg (regs, 1);
            t->buffer_in = (char *)malloc (t->len_in + 1);
            t->buffer_in [t->len_in] = 0; /* NULL Terminator */

            t->len_out = 0;
            t->buffer_out = NULL; /* I've got nothing, at the moment */
            t->ret_cd = 0;

            set_reg (regs, 14, (long)t);
            
            set_reg (regs, 2, (long)(&(t->buffer_in [0])));

        } else {                      /* They want some return info... */

            t = (talk_ptr)get_reg (regs, 14);

            set_reg (regs, 1, t->len_out);
            set_reg (regs, 2, (long)(&(t->buffer_out [0])));

            set_reg (regs, 4, t->ret_cd);
        }

    } else {                      /* Must need additional processing. */

        t = (talk_ptr)get_reg (regs, 14);

        if (get_reg (regs, 3) == 0) { /* Run. */

            EZASOKET (get_reg (regs, 7), get_reg (regs, 8), get_reg (regs, 9), t);

        } else {                      /* Dealloc memory for this communication. */

            free (t->buffer_in);
            if (t->buffer_out) free (t->buffer_out);
            free (t);

            set_reg (regs, 14, 0);
        }
    }

    return (1); /* We never return 0, that's for the DLL Loader. */
}

/**********************************************************************************/
