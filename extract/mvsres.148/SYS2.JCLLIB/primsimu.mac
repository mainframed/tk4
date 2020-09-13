//PRIMSIMU JOB (SIMULA),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=9000K,TIME=1440,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMSIMU)
//*
//* Desc: Sieve of Eratosthenes programmed in SIMULA.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//********************************************************************
//PRIMES  EXEC SIMCG
//SIM.SYSIN DD *
comment
***
*** Eratosthenes' Sieve, direct iteration
***;
begin
comment
***
*** declarations
***;
    ref(outfile) primout;
    boolean array isprime(1:8400000);
    integer i,j,k,l,limit;
comment
***
*** initialization
***;
    limit := inint;
    for i := 3 step 2 until limit do
        isprime(i) := true;
    i := 3;
    k := 9;
comment
***
*** sieve
***;
    for i := i while k < limit do
    begin
        for i := i while k < limit and not isprime(i) do
        begin
            i := i+2;
            k := i*i;
        end;
        if k < limit then
        begin
            for k := k while k < limit do
            begin
                isprime(k) := false;
                k := k+i+i;
            end;
            i := i+2;
            k := i*i;
        end;
    end;
comment
***
*** print initialization
***;
    j := 1;
    k := 1;
    l := 0;
    primout :- new outfile("PRIMOUT");
    primout.open(blanks(161));
    primout.outtext("1");
    primout.outint(2, 8);
comment
***
*** print 20 primes per output line
***;
    for i := 3 step 2 until limit-1 do
    begin
        if isprime(i) then
        begin
            j := j + 1;
            k := k + 1;
            primout.outint(i, 8);
            if j = 20 then
            begin
                primout.outimage;
                j := 0;
                l := l + 1;
                if l = 62 then
                begin
                    primout.outtext("1");
                    l := 0;
                end
                else primout.outtext(" ");
            end;
        end;
    end;
comment
***
*** print incomplete last line
***;
    if j ^= 0 then primout.outimage;
    primout.outimage;
comment
***
*** print summary and close output file
***;
    primout.outint(k, 8); primout.outtext(" primes up to ");
    primout.outint(limit, 8); primout.outtext(" found");
    primout.outimage;
    primout.close; primout :- none;
comment
***
*** done
***;
end;
/*
//GO.SYSIN   DD *
2000
/*
//GO.SYSOUT  DD SYSOUT=*
//GO.PRIMOUT DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)
//
