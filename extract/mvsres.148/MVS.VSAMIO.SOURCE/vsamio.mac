000100* ************************************************************** *
000200*                                                                *
000300*        VV   VV  SSSSS     A    M     M  IIII    OOOOO          *
000400*        VV   VV SS   SS   AAA   MM   MM   II    OO   OO         *
000500*        VV   VV SS       AA AA  MMM MMM   II    OO   OO         *
000600*        VV   VV  SSSSS  AA   AA MMMMMMM   II    OO   OO         *
000700*        VV   VV      SS AA   AA MM M MM   II    OO   OO         *
000800*         VV VV  SS   SS AAAAAAA MM   MM   II    OO   OO         *
000900*          VVV   SS   SS AA   AA MM   MM   II    OO   OO         *
001000*           V     SSSSS  AA   AA MM   MM  IIII    OOOOO          *
001100*                                                                *
001200* ************************************************************** *
001300*                                                                *
001400* THESE PARAMETERS ARE USED TO INTERFACE WITH THE VSAM DATASET   *
001500* ACCESS ROUTINE.                                                *
001600*                                                                *
001700* THE VSIO-PARAMETER-VALUES SUPPLY THE VALUES USED TO MOVE INTO  *
001800* PARAMETER ENTRIES TO TAILOR THE ROUTINE TO A SPECIFIC DATASET  *
001900* AND TO PROVIDE COMMANDS TO DRIVE THE ROUTINE.                  *
002000* ************************************************************** *
002100 01  VSIO-PARAMETER-VALUES.
002200     02  VSIO-OPEN               PIC  X(08)  VALUE 'OPEN    '.
002300     02  VSIO-CLOSE              PIC  X(08)  VALUE 'CLOSE   '.
002400     02  VSIO-READ               PIC  X(08)  VALUE 'READ    '.
002500     02  VSIO-WRITE              PIC  X(08)  VALUE 'WRITE   '.
002600     02  VSIO-REWRITE            PIC  X(08)  VALUE 'REWRITE '.
002700     02  VSIO-DELETE             PIC  X(08)  VALUE 'DELETE  '.
002800     02  VSIO-START-KEY-EQUAL    PIC  X(08)  VALUE 'STARTEQ '.
002900     02  VSIO-START-KEY-NOTLESS  PIC  X(08)  VALUE 'STARTGE '.
003000     02  VSIO-KSDS               PIC  X(04)  VALUE 'KSDS'.
003100     02  VSIO-ESDS               PIC  X(04)  VALUE 'ESDS'.
003200     02  VSIO-RRDS               PIC  X(04)  VALUE 'RRDS'.
003300     02  VSIO-SEQUENTIAL         PIC  X(10)  VALUE 'SEQUENTIAL'.
003400     02  VSIO-DIRECT             PIC  X(10)  VALUE 'DIRECT    '.
003500     02  VSIO-DYNAMIC            PIC  X(10)  VALUE 'DYNAMIC   '.
003600     02  VSIO-INPUT              PIC  X(06)  VALUE 'INPUT '.
003700     02  VSIO-OUTPUT             PIC  X(06)  VALUE 'OUTPUT'.
003800     02  VSIO-INPUT-OUTPUT       PIC  X(06)  VALUE 'UPDATE'.
003900
004000* ************************************************************** *
004100* THE VSIO-PARAMETER-BLOCK IS THE COMMUNICATION INTERFACE TO     *
004200* THE ROUTINE.                                                   *
004300* ************************************************************** *
004400 01  VSIO-PARAMETER-BLOCK.
004500     02  VSIO-COMMAND            PIC  X(08).
004600     02  VSIO-RETURN-CODE        PIC S9(04)  COMP.
004700         88  VSIO-SUCCESS                    VALUE +0.
004800         88  VSIO-LOGIC-ERROR                VALUE +8.
004900         88  VSIO-END-OF-FILE                VALUE +9999.
005000         88  VSIO-PARAMETER-ERROR            VALUE +20 THRU +28.
005100         88  VSIO-COMMAND-UNKNOWN            VALUE +20.
005200         88  VSIO-DATASET-ALREADY-OPEN       VALUE +21.
005300         88  VSIO-DATASET-NOT-OPEN           VALUE +22.
005400         88  VSIO-ORGANIZATION-KEYWORD       VALUE +23.
005500         88  VSIO-ACCESS-KEYWORD             VALUE +24.
005600         88  VSIO-ACCESS-UNSUPPORTED         VALUE +25.
005700         88  VSIO-MODE-KEYWORD               VALUE +26.
005800         88  VSIO-MODE-UNSUPPORTED           VALUE +27.
005900         88  VSIO-DDNAME-BLANK               VALUE +28.
006000     02  VSIO-VSAM-RETURN-CODE   PIC S9(04)  COMP.
006100     02  VSIO-VSAM-FUNCTION-CODE PIC S9(04)  COMP.
006200     02  VSIO-VSAM-FEEDBACK-CODE PIC S9(04)  COMP.
006300         88  VSIO-DUPLICATE-RECORD           VALUE +8.
006400         88  VSIO-SEQUENCE-ERROR             VALUE +12.
006500         88  VSIO-RECORD-NOT-FOUND           VALUE +16.
006600         88  VSIO-NO-MORE-SPACE              VALUE +28.
006700         88  VSIO-READ-WITHOUT-START         VALUE +88.
006800* ************************************************************** *
006900*                    END OF VSAMIO COPY BOOK                     *
007000* ************************************************************** *
