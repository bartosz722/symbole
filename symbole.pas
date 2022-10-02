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


procedure Init;
var
    driver, mode : integer;
    errorcode    : integer;
begin
    driver := Detect;
    InitGraph(driver, mode, '');
    errorcode := GraphResult;
    if errorcode <> grOk then
        begin
            case errorcode of
            -2 : Writeln('Nie wykryto karty graficznej!');
            -3 : Writeln('Brak zbioru zawierającego sterownik graficzny! (.BGI)');
            -4 : Writeln('Niedobry sterownik graficzny! (.BGI)');
            -5 : Writeln('Brak pamięci do załadowania sterownika graficznego!');
            end;
            Halt(1);
        end;
    randomize;
    cleardevice;
    Maxx := Getmaxx;
    Maxy := Getmaxy;
    xcent := maxx div 2;
    ycent := maxy div 2;
    Skala := Maxx div 319;
    Maxcolor := Getmaxcolor;
    Height := Textheight('M');
    Width := Textwidth('M');
end; { Init }

procedure welcome;
begin
    Cleardevice;
    Outtextxy(20, 20, 'SYMBOLE CHEMICZNE - Gra edukacyjna');
    Outtextxy(30, 40, 'Instrukcja:');
    Outtextxy(50, 60, 'Statki o nazwach pierwiastków chemicznych musisz');
    Outtextxy(40, 70, 'doprowadzić bezpiecznie do portu. Po drodze napotykają');
    Outtextxy(40, 80, 'one góry lodowe. Aby statek nie rozbił się, należy');
    Outtextxy(40, 90, 'poprawnie wpisać symbol pierwiastka chemicznego, którego');
    Outtextxy(40, 100, 'nazwę nosi statek.');
    Outtextxy(30, 120, 'Aby zacząć grę - wpisz 1 lub 2, gdy chcesz skończyć wciścnij ESC.');
    Outtextxy(50, 140, '1 - gra na podstawowym poziomie (18 pierwiastków)');
    Outtextxy(50, 150, '2 - poziom bardziej zaawansowany');
end; { welcome }
