//TESTSIMU JOB (SIMULA),
//             'Test SIMULA 67',
//             CLASS=A,
//             MSGCLASS=A,
//             REGION=1M,
//             MSGLEVEL=(1,1)
//********************************************************************
//*
//* Name: SYS2.JCLLIB(TESTSIMU)
//*
//* Desc: SIMULA Installation Verification.
//*       Four programs are executed using the SIMCNT utility.
//*
//********************************************************************
//SIMULA  EXEC SIM,P=4,CP='XREF'
//SYSIN   DD *
Simulation begin
   comment Erathostenes' Sieve,
           adapted from Ole-Johan Dahls 1966-paper;

   process class sieve(prime); integer prime;
        begin
           outint(prime, 5);
           L: if nextev.evtime - time > 2 then
                activate new sieve(time + 2) delay 2;
              hold(2 * prime);
              go to L;
        end sieve;

   Outtext( "Primes smaller than 10000:" );
   Outimage; Outimage;

   outint(2, 5);
   activate new sieve(3) at 3;
   hold(10000)
end Simulation
/*
//DATA    DD DUMMY
//SYSIN1  DD *
begin
 procedure X;  Outchar(char(if char(64)=' ' then 127 else 34));
 procedure B4; Outtext(blanks(4));
 procedure Y(s);  text s; begin Outtext(s); Outimage; end;
 procedure YY(s); text s; Outtext(s);
 procedure Z(s);  text s;
 begin B4; X; Outtext(s); X; Outchar(','); Outimage; end;
 procedure ZZ(s); text s;
 begin X; Outtext(s); X; Outchar(','); Outimage; end;
 procedure ZZZ(s); text s;
 begin B4; X; Outtext(s); X; Outimage; end;
 procedure WW(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w);
        value a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w;
         text a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w;
 begin
   Y(a);Y(b);Y(c);Y(d);Y(e);Y(f);Y(g);Y(h);Y(i);Y(j);Y(k);Y(l);
   Y(m);Y(n);Y(o);Y(p);Y(q);Y(r);Y(s);Y(t);YY(u);ZZ(a);Z(b);
   Z(c);Z(d);Z(e);Z(f);Z(g);Z(h);Z(i);Z(j);Z(k);Z(l);Z(m);Z(n);
   Z(o);Z(p);Z(q);Z(r);Z(s);Z(t);Z(u);Z(v);ZZZ(w);Y(v);YY(w)
 end;
WW( "begin",
    " procedure X;  Outchar(char(if char(64)=' ' then 127 else 34));",
    " procedure B4; Outtext(blanks(4));",
    " procedure Y(s);  text s; begin Outtext(s); Outimage; end;",
    " procedure YY(s); text s; Outtext(s);",
    " procedure Z(s);  text s;",
    " begin B4; X; Outtext(s); X; Outchar(','); Outimage; end;",
    " procedure ZZ(s); text s;",
    " begin X; Outtext(s); X; Outchar(','); Outimage; end;",
    " procedure ZZZ(s); text s;",
    " begin B4; X; Outtext(s); X; Outimage; end;",
    " procedure WW(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w);",
    "        value a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w;",
    "         text a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w;",
    " begin",
    "   Y(a);Y(b);Y(c);Y(d);Y(e);Y(f);Y(g);Y(h);Y(i);Y(j);Y(k);Y(l);",
    "   Y(m);Y(n);Y(o);Y(p);Y(q);Y(r);Y(s);Y(t);YY(u);ZZ(a);Z(b);",
    "   Z(c);Z(d);Z(e);Z(f);Z(g);Z(h);Z(i);Z(j);Z(k);Z(l);Z(m);Z(n);",
    "   Z(o);Z(p);Z(q);Z(r);Z(s);Z(t);Z(u);Z(v);ZZZ(w);Y(v);YY(w)",
    " end;",
    "WW( ",
    "  );",
    "end of self-reproducible SIMULA program"
  );
end of self-reproducible SIMULA program
/*
//DATA11  DD DUMMY
//SYSIN2  DD *
BEGIN
  COMMENT
     Simula Version of 99 Beers
     Maciej Macowicz (mm@cpe.ipl.fr)
     Status: Untested :)
     Amended 2007-03-10 by Jack Leunissen (jack.leunissen@wur.nl)
     Amended 2013-12-21 by Juergen Winkelmann (winkelmann@id.ethz.ch)
     Status: Working (at least it prints and counts correctly)
  ;
  INTEGER bottles;
  INTEGER num;
  num := 2;
  OutImage;
  FOR bottles:= 99 STEP -1 UNTIL 2 DO
  BEGIN
    IF (bottles < 10) THEN num := 1;
    OutInt(bottles,num);
    OutText(" bottle(s) of beer on the wall, ");
    OutInt(bottles,num);
    OutText(" bottle(s) of beer.");
    OutImage;
    Outtext("Take one down, pass it around, ");
    OutInt(bottles - 1,num);
    OutText(" bottle(s) of beer on the wall. ");
    OutImage;
    OutImage;
  END;
  OutText("1 bottle of beer on the wall, one bottle of beer.");
  OutImage;
  OutText("Take one down, pass it around, ");
  OutText("no more bottles of beer on the wall.");
  OutImage;
  OutImage;
  OutText("No more bottles of beer on the wall, ");
  OutText("no more bottles of beer.");
  OutImage;
  OutText("Go to the store and buy some more, ");
  OutText("99 bottles of beer on the wall.");
  OutImage;
  OutImage;
END
/*
//DATA21  DD DUMMY
//SYSIN3  DD *
begin
class word(t); value t; text t;
begin
while true do begin
detach;
outtext(t);
end
end *** word ***;
ref(word) h,w;
h :- new word("Hello");
w :- new word("world");
resume(h);
outchar(' ');
resume(w);
outimage;
outimage;
end of program
/*
//DATA31  DD DUMMY
//
