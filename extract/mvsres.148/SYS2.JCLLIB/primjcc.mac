//PRIMJCC  JOB (JCC),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMJCC)
//*
//* Desc: Sieve of Eratosthenes programmed in C.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//* Desc: Sieve of Eratosthenes programmed in C, optimized for use
//*       with Jason Winter's JCC version 1.50.00.
//*
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//*       JCC's printf integer to string conversion (%d) performs
//*       poorly on MVS 3.8j, while a combined usage of itoa and
//*       fwrite shows significantly better performance. For that
//*       reason the output lines are constructed in storage using
//*       itoa, giving a slightly more complex coding than simply
//*       issuing printf once a prime is detected.
//*
//********************************************************************
//PRIMES  EXEC JCCCG,INFILE='JUERGEN.JCC.SRC(PRIM)'
//COMPILE.SYSIN DD DATA,DLM=@@
/**
*** headers
**/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
/**
*** declarations
**/
void main(int argc, char **argv) {
  int     count     = 1;
  int     s         = 8;
  int     e         = 10;
  FILE*   output    = NULL;
  char    *out      = malloc(162);
  char    *array;
  int     top_value, i, j, k, prime, multiple, sqrt_top_value;
/**
*** initialization
**/
  scanf("%d", &top_value);
  sqrt_top_value = sqrt(top_value);
  array = malloc(top_value + 1);
  for (i=3; i <= top_value; i += 2) array[i] = 0x01;
/**
*** sieve
**/
  for (prime = 3; prime <= sqrt_top_value; prime += 2)
  {
    if (array[prime] == 0x01) {
      j = 2 * prime;
      for (multiple = prime*prime; multiple <= top_value;
           multiple += j) array[multiple] = 0x00;
    }
  }
/**
*** print initialization
**/
  output = fopen("OUTPUT","w");
  j = 1;
  k = 0;
  strcpy(out,"\
1       2                               \
                                        \
                                        \
                                        \
");
/**
*** print 20 primes per output line
**/
  for (i=3; i <= top_value; i += 2)
  {
    if (array[i]) {
      if (i > e) {s--; e *= 10;}
      multiple = 8*j;
      itoa(i,out+s+multiple,10);
      out[9+multiple] = 0x40;
      count++;
      if (j++ == 19) {
        fwrite(out,1,161,output);
        j = 0;
        out[0] = 0x40;
        if (k++ == 61) {
          out[0] = 0xf1;
          k = 0;
        }
      }
    }
  }
  if (j != 0) fwrite(out,1,1+j*8,output);
/**
*** print summary and close output file
**/
  fprintf(output,"\n\n %7d primes up to %7d found.\n", count, top_value)
  fclose(output);
/**
*** done
**/
  exit(0);
}
@@
//GO.SYSIN DD *
2000
/*
//OUTPUT   DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=32200)
//
