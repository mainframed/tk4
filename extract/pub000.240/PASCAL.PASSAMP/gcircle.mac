PROGRAM  GREATC(INPUT, OUTPUT); (*$M-*)

  CONST  DEGSRADIANS = 57.29578;

  VAR  SIDEA,  SIDEB,  SIDEC,
       ANGLEA, ANGLEB, ANGLEC,
       AMINUSB, APLUSB,
       DELTA, PLUSMINUS,
       STRTLATMNTS, STRTLONMNTS,
       DESTLATMNTS,  DESTLONMNTS,
       STRTLAT, STRTLON,
       DESTLAT,  DESTLON:             REAL;

       DISTANCE, I, STEP,
       STRTLATDEGS, STRTLONDEGS,
       DESTLATDEGS,  DESTLONDEGS,
       LATDEGS, LATMNTS,
       LONDEGS, LONMNTS:       INTEGER;



FUNCTION  TAN(X: REAL):  REAL;

BEGIN  (* TAN *)
  TAN := SIN(X) / COS(X)
END;  (* TAN *)



FUNCTION  COT(X: REAL):  REAL;

BEGIN  (* COT *)
  COT := (1.0 / X) - (X / 3.0)
                   - (X * X * X / 45.0)
                   - (2.0 * X * X * X * X * X / 945.0)
                   - (X * X * X * X * X * X * X / 4725.0);
END;  (* COT *)



FUNCTION  ASIN(X: REAL):  REAL;

BEGIN  (* ASIN *)
  ASIN := X + (X * X * X / 6.0)
            + (3.0 * X * X * X * X * X / 40.0)
            + (15.0 * X * X * X * X * X * X * X / 336.0);
END;  (* ASIN *)




BEGIN  (* GREATCIRCLE *)
      READ(STRTLATDEGS, STRTLATMNTS, STRTLONDEGS, STRTLONMNTS);
      READ(DESTLATDEGS,  DESTLATMNTS,  DESTLONDEGS,  DESTLONMNTS) ;

      STRTLAT := STRTLATDEGS + (STRTLATMNTS / 60.0);
      STRTLON:= STRTLONDEGS + (STRTLONMNTS / 60.0);
      DESTLAT  := DESTLATDEGS  + (DESTLATMNTS  / 60.0);
      DESTLON := DESTLONDEGS  + (DESTLONMNTS  / 60.0);

      WRITELN('1STRTING LAT:      ', STRTLATDEGS:3,
                                           STRTLATMNTS:5);
      WRITELN(' STRTING LON:     ', STRTLONDEGS:3,
                                           STRTLONMNTS:5);
      WRITELN('0DESTINATION LAT:   ', DESTLATDEGS:3,
                                           DESTLATMNTS:5);
      WRITELN(' DESTINATION LON:  ', DESTLONDEGS:3,
                                           DESTLONMNTS:5);

      PLUSMINUS := 1.0;
      IF  STRTLON > DESTLON   THEN PLUSMINUS := -1.0;
      READ(STEP);

      SIDEA := (90.0 - DESTLAT) / DEGSRADIANS;
      SIDEB := (90.0 - STRTLAT)/ DEGSRADIANS;
      ANGLEC := ABS(STRTLON - DESTLON) / DEGSRADIANS;
      AMINUSB := 2.0 * (ARCTAN(SIN(0.5*(SIDEA-SIDEB))/
                          SIN(0.5*(SIDEA+SIDEB))*
                          COT(0.5*ANGLEC)));
      APLUSB  := 2.0 * (ARCTAN(COS(0.5*(SIDEA-SIDEB))/
                           COS(0.5*(SIDEA+SIDEB))*
                           COT(0.5*ANGLEC)));
      ANGLEA := (AMINUSB + APLUSB) / 2.0;
      SIDEC  := ASIN(SIN(ANGLEC) * SIN(SIDEA)/ SIN(ANGLEA));
      DISTANCE := TRUNC(0.5+SIDEC * 3963.2);
      WRITELN('0GREATCIRCLE DISTANCE = ', DISTANCE:6, ' STATUTE MILES');
      WRITELN('0');


      SIDEC  := SIDEB;
      ANGLEB := 0.0;
      DELTA  := ANGLEC / STEP;

      FOR I := 1 TO STEP+1  DO
        BEGIN
          AMINUSB := 2.0*(ARCTAN(SIN(0.5*(ANGLEA-ANGLEB))/
                                 SIN(0.5*(ANGLEA+ANGLEB))*
                                 TAN(0.5*SIDEC)));
          APLUSB  := 2.0*(ARCTAN(COS(0.5*(ANGLEA-ANGLEB))/
                                 COS(0.5*(ANGLEA+ANGLEB))*
                                 TAN(0.5*SIDEC)));
          SIDEA := (AMINUSB + APLUSB) / 2.0;
          LATDEGS  := TRUNC(90.0 - (SIDEA * DEGSRADIANS));
          LATMNTS  := TRUNC(0.5+((90.0 - (SIDEA * DEGSRADIANS))
                                           - LATDEGS) * 60.0);
          LONDEGS := TRUNC(STRTLONDEGS + ((ANGLEB * DEGSRADIANS)
                                                    * PLUSMINUS));
          LONMNTS := TRUNC(0.5+((STRTLON + ((ANGLEB *DEGSRADIANS)
                                     * PLUSMINUS)) - LONDEGS) * 60.0);
          IF  LONMNTS >= 60
              THEN
                BEGIN
                  LONDEGS := LONDEGS + 1;
                  LONMNTS := LONMNTS - 60;
                END;
         WRITELN(LATDEGS:3, LATMNTS:3,
                 LONDEGS:8, LONMNTS:3);
         ANGLEB := ANGLEB + DELTA;
        END  (* FOR LOOP *)
END  (* GREATCIRCLE *)  .
 27 46   45 26  39 12   16 22     (TYPICAL DATA FOR GREATCIRCLE)
