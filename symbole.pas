PROGRAM Symbole;    { Autor Paweł Łopata }

USES Crt, Graph;

CONST
    ESC         = #27;
    MAXPIERW    = 28;
    ILOSC       = 20;
    SZYBKOSC    = 5;
    pierwiastek     : array [1..MAXPIERW] of
                        record
                            symbol : string [2];
                            nazwa  : string [10];
                        end =
        ((symbol : 'Na'; nazwa : 'SÓD'    ),
         (symbol : 'K '; nazwa : 'POTAS'  ),
         (symbol : 'Ca'; nazwa : 'WAPŃ'   ),
         (symbol : 'Mg'; nazwa : 'MAGNEZ' ),
         (symbol : 'Al'; nazwa : 'GLIN'   ),
         (symbol : 'Fe'; nazwa : 'ŻELAZO' ),
         (symbol : 'Cu'; nazwa : 'MIEDŹ'  ),
         (symbol : 'Zn'; nazwa : 'CYNK'   ),
         (symbol : 'Pb'; nazwa : 'OŁÓW'   ),
         (symbol : 'Cl'; nazwa : 'CHLOR'  ),
         (symbol : 'S '; nazwa : 'SIARKA' ),
         (symbol : 'O '; nazwa : 'TLEN'   ),
         (symbol : 'N '; nazwa : 'AZOT'   ),
         (symbol : 'C' ; nazwa : 'WĘGIEL' ),
         (symbol : 'H' ; nazwa : 'WODÓR'  ),
         (symbol : 'P' ; nazwa : 'FOSFOR' ),
         (symbol : 'Si'; nazwa : 'KRZEM'  ),
         (symbol : 'Ag'; nazwa : 'SREBRO' ),
         (symbol : 'Au'; nazwa : 'ZŁOTO'  ),      { 2 - Level }
         (symbol : 'Pt'; nazwa : 'PLATYNA'),
         (symbol : 'Ra'; nazwa : 'RAD'    ),
         (symbol : 'Hg'; nazwa : 'RTĘĆ'   ),
         (symbol : 'Sn'; nazwa : 'CYNA'   ),
         (symbol : 'Po'; nazwa : 'POLON'  ),
         (symbol : 'Br'; nazwa : 'BROM'   ),
         (symbol : 'J '; nazwa : 'JOD'    ),
         (symbol : 'He'; nazwa : 'HEL'    ),
         (symbol : 'Ar'; nazwa : 'ARGON'  ));

VAR
    Maxx, Maxy      : word;
    xcent, ycent    : word;
    Skala           : integer;
    Maxcolor        : word;
    Height, Width   : word;
    
    animindex       : integer;
    
    wodax, gorax    : integer;
    
    obrazki         : array [1..14] of pointer;
    i, j, pozycja   : integer;
    
    ch              : char;
    symb            : string[2];
    outstr          : string[5];
    punkty          : integer;
    czasreakcji     : word;
    los             : integer;
    level, licznik  : integer;
    
    firstletter     : boolean;
    ok, zderzenie   : boolean;

