//PRIMGCC  JOB (GCC),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=8M,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMGCC)
//*
//* Desc: Sieve of Eratosthenes programmed in C, optimized for use
//*       with GNU C version 3.2.3 MVS V8.5, as ported by Paul Edwards.
//*
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//*       GCC's printf integer to string conversion (%d) performs
//*       poorly on MVS 3.8j, while a combined usage of sprintf and
//*       fwrite shows significantly better performance (though still
//*       not satisfactorily) with a strong correlation between the
//*       number of calls to sprintf and the performance. For that
//*       reason the code was optimized to minimize the number of
//*       sprintf calls to one per line as opposed to one per prime
//*       which one would normally code.
//*
//********************************************************************
//PRIMES  EXEC GCCCG,COPTS='-v -O3'
//COMP.SYSIN DD DATA,DLM=@@
/**
*** headers
**/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
/**
*** declarations
**/
int main(int argc, char **argv) {
  int     count     = 1;
  FILE*   output    = NULL;
  char    *out      = malloc(162);
  char    *rest     = " %7d";
  char    *line     = "1%7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d
 %7d %7d %7d %7d %7d %7d\n";
  char    *array;
  int     top_value, i, j, k, prime, multiple, sqrt_top_value, o[20];
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
  output = fopen("DD:OUTPUT","w");
  j = 1;
  k = 0;
  o[0] = 2;
/**
*** print 20 primes per output line
**/
  for (i=3; i <= top_value; i += 2)
  {
    if (array[i]) {
      o[j] = i;
      count++;
      if (j++ == 19) {
       sprintf(out,line,o[0],o[1],o[2],o[3],o[4],o[5],o[6],o[7],o[8],o[9
                    o[11],o[12],o[13],o[14],o[15],o[16],o[17],o[18],o[19
        fwrite(out,1,161,output); /* use fwrite to circumvent slow fprin
        j = 0;
        line[0] = 0x40;
        if (k++ == 61) {
          line[0] = 0xf1;
          k = 0;
        }
      }
    }
  }
/**
*** print incomplete last line
**/
  if (j != 0) {
    rest[0] = line[0];
    for (i=0; i < j; i++) {
      fprintf(output,rest,o[i]);
      rest[0] = 0x40;
    }
    fprintf(output,"\n");
  }
/**
*** print summary and close output file
**/
  fprintf(output,"\n %7d primes up to %7d found.\n", count, top_value);
  fclose(output);
/**
*** done
**/
  exit(0);
}
@@
//GO.SYSIN    DD *
2000
/*
//GO.OUTPUT   DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=32200)
//
