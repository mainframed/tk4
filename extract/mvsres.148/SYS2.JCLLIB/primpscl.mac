//PRIMPSCL JOB (PASCAL),
//             'Eratosthenes Sieve',
//             CLASS=A,
//             MSGCLASS=A,
//             TIME=1440,REGION=9000K,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(PRIMPSCL)
//*
//* Desc: Sieve of Eratosthenes programmed in Pascal.
//*       All prime numbers up to the value entered via
//*       //GO.SYSIN DD are computed.
//*
//********************************************************************
//PRIMES   EXEC PASCG,PARM.GO='//STACK=8400K'
//COMPILE.SYSIN DD *
program Eratosthenes(input,output);
var a:ARRAY[1..8000000] of boolean;
    N,i,j,m:integer;
begin
 read(N);
 i:=3;
 while i <= N do begin a[i]:=TRUE; i:=i+2; end;
 m:=trunc(sqrt(N));
 i:=3;
 while i <= m do begin
     if a[i] then begin
       j:=i;
       while j <= N DIV i do begin a[i*j]:=FALSE; j:=j+2; end;
     end;
     i:=i+2;
   end;
 i:=3;
 j:=1;
 write(2:8);
 while i <= N do begin if a[i] then begin j:=j+1; write(i:8); end;
   i:=i+2;
 end;
 m := 20-(j mod 20);
 if m <> 20 then for i:=1 to m do write('        ');
 writeln('0', j:7, ' primes up to ', N:7, ' found');
end.
/*
//GO.OUTPUT DD SYSOUT=*,DCB=(LRECL=160,BLKSIZE=16000,RECFM=FBA)
//GO.SYSIN  DD *
2000
/*
//
