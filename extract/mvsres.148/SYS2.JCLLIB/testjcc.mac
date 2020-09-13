//TESTJCC JOB (SETUP),
//            'Test JCC',
//            CLASS=A,
//            MSGCLASS=A,
//            REGION=8M,
//            MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(TESTJCC)
//*
//* Desc: JCC compile and go
//*
//********************************************************************
//*
//BEER    EXEC JCCCG
//COMPILE.SYSIN DD *
#include <stdio.h>
#include <stdlib.h>

static void song( int bottles )
{
 while( (printf(" %d bottles of beer on the wall, %d bottles of beer.\n"
      " Take one down and pass it around, %d bottle%s of beer on the wal
         bottles, bottles, bottles-1, bottles>2? "s":""), bottles > 2) )
  while( (--bottles,0) ) {}
 while( (puts(" 1 bottle of beer on the wall, 1 bottle of beer.\n"
   " Take one down and pass it around, no more bottles of beer on the wa
      " No more bottles of beer on the wall, no more bottles of beer.\n"
  " Go to the store and buy some more, 99 bottles of beer on the wall.")
}

int main()
{
 while( (song(99), exit(0), 0) ) {}
}
/*
//
