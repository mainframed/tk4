//PRIMSIMU JOB (SIMULA),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=9000K,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMSIMD)
//*
//* Desc: Sieve of Eratosthenes programmed in SIMULA.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed. Due to the recursive nature
//*       of the simulation it is not recommended enter a higher
//*       limit than 100000.
//*
//********************************************************************
//PRIMES  EXEC SIMCG
//SIM.SYSIN DD *
comment Eratosthenes' Sieve, adapted from Ole-Johan Dahls 1966-paper;

Simulation begin

   integer acc;
   integer limit;
   external assembly procedure BreakOutImage;

   process class sieve(prime); integer prime;
        begin
           acc := acc + 1;
           outint(prime, 7);
           L: if nextev.evtime - time > 2 then
                activate new sieve(time + 2) delay 2;
              hold(2 * prime);
              go to L;
        end sieve;

   limit := inint;
   Outtext( "All primes smaller than " );
   outint(limit, 7);
   Outtext( ":" );
   Outimage; Outimage;

   outint(2, 7); comment N.B. fails for input < 3;
   activate new sieve(3) at 3;
   hold(limit);

   Outimage; Outimage;
   Outint( acc + 1, 7 ); Outtext( " primes found" );

  end Simulation
/*
//GO.SYSIN DD *
2000
/*
//GO.SYSOUT DD SYSOUT=*
//
