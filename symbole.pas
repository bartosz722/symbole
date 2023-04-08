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
    Maxx,Maxy       : word;
    xcent,ycent     : word;
    Skala           : integer;
    Maxcolor        : word;
    Height,Width    : word;
    
    animindex       : integer;
    
    wodax,gorax     : integer;
    
    obrazki         : array [1..14] of pointer;
    i,j,pozycja     : integer;
    
    ch              : char;
    symb            : string[2];
    outstr          : string[5];
    punkty          : integer;
    czasreakcji     : word;
    los             : integer;
    level,licznik   : integer;
    
    firstletter     : boolean;
    ok,zderzenie    : boolean;


procedure Init;
var
    driver,mode  : integer;
    errorcode    : integer;
begin
    driver := Detect;
    InitGraph(driver,mode,'');
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
    Outtextxy(20,20,'SYMBOLE CHEMICZNE - Gra edukacyjna');
    Outtextxy(30,40,'Instrukcja:');
    Outtextxy(50,60,'Statki o nazwach pierwiastków chemicznych musisz');
    Outtextxy(40,70,'doprowadzić bezpiecznie do portu. Po drodze napotykają');
    Outtextxy(40,80,'one góry lodowe. Aby statek nie rozbił się, należy');
    Outtextxy(40,90,'poprawnie wpisać symbol pierwiastka chemicznego, którego');
    Outtextxy(40,100,'nazwę nosi statek.');
    Outtextxy(30,120,'Aby zacząć grę - wpisz 1 lub 2, gdy chcesz skończyć wciścnij ESC.');
    Outtextxy(50,140,'1 - gra na podstawowym poziomie (18 pierwiastków)');
    Outtextxy(50,150,'2 - poziom bardziej zaawansowany');
end; { welcome }


procedure brr(j:integer);
begin
    sound(j);
    delay(15);
    nosound;
end; { brr }


procedure learn;
var
    size : word;
    i    : integer;

procedure rysstatek(x,y:word);
begin
    setcolor(Maxcolor);
    moveto(x,y);
    linerel(160,0);
    linerel(-12,0);
    linerel(2,-2);
    linerel(10,-18);
    linerel(-30,0);
    linerel(-5,5);
    linerel(-90,0);
    linerel(-1,-15);    { nadbud }
    linerel(3,0);
    linerel(-40,0);
    linerel(3,0);
    linerel(0,15);
    linerel(34,0);
    linerel(-45,0);     { ruf }
    linerel(1,9);
    linerel(1,3);
    linerel(2,2);
    linerel(3,1);
    linerel(4,0);
    
    line(x+70,y-16,x+70,y-40);  { dźwigi }
    line(x+70,y-25,x+60,y-37);
    line(x+110,y-16,x+110,y-40);
    line(x+110,y-25,x+100,y-37);
    
    line(x+40,y-16,x+67,y-16);  { ładownie }
    line(x+40,y-17,x+67,y-17);
    line(x+75,y-16,x+107,y-16);
    line(x+75,y-17,x+107,y-17);
    
    circle(x+145,y-15,1);
    circle(x+16,y-25,2);
    circle(x+24,y-25,2);
end; { rysstatek }

begin

    {------------------------------------------------------------------------------}
    {                   Zapamiętanie obrazków do animacji.                         }
    {------------------------------------------------------------------------------}

    { ******** Statek ******** }

    size = imagesize(4,140,190,180);
    for i:=1 to 4 do getmem(obrazki[i],size);

    rysstatek(30,180);

    putpixel(13,179,Maxcolor);  { pierwszy image }
    putpixel(16,179,Maxcolor);
    putpixel(18,179,Maxcolor);
    putpixel(19,179,Maxcolor);

    for i:=0 to 14 do
        begin
            putpixel(34+i*10,180,0);
            putpixel(34+i*10,179,Maxcolor);
        end;
        
    getimage(4,140,190,180,obrazki[1]^);

    setcolor(0);                { drugi image }
    line(10,179,20,179);
    line(28,179,174,179);
    setcolor(Maxcolor);
    line(28,180,178,180);

    putpixel(12,179,Maxcolor);
    putpixel(15,179,Maxcolor);
    putpixel(17,179,Maxcolor);
    putpixel(18,179,Maxcolor);
    putpixel(19,179,Maxcolor);

    for i:=0 to 14 do
        begin
            putpixel(31+i*10,180,0);
            putpixel(32+i*10,180,0);
            putpixel(33+i*10,180,0);
            putpixel(31+i*10,179,Maxcolor);
            putpixel(33+i*10,179,Maxcolor);
            putpixel(32+i*10,178,Maxcolor);
            putpixel(33+i*10,178,Maxcolor);
        end;

    getimage(4,140,190,180,obrazki[2]^);

    setcolor(0);                { trzeci image }
    line(10,179,20,179);
    line(28,179,174,179);
    line(28,178,174,178);
    setcolor(Maxcolor);
    line(28,180,178,180);
    putpixel(11,179,Maxcolor);
    putpixel(14,179,Maxcolor);
    putpixel(16,179,Maxcolor);
    putpixel(17,179,Maxcolor);
    putpixel(18,179,Maxcolor);

    for i:=0 to 14 do
        begin
            putpixel(29+i*10,180,0);
            putpixel(30+i*10,180,0);
            putpixel(31+i*10,180,0);
            putpixel(29+i*10,179,Maxcolor);
            putpixel(31+i*10,179,Maxcolor);
            putpixel(29+i*10,178,Maxcolor);
            putpixel(30+i*10,178,Maxcolor);
        end;

    getimage(4,140,190,180,obrazki[3]^);

    setcolor(0);                { czwarty image }
    line(10,179,20,179);
    line(28,179,174,179);
    line(28,179,174,178);
    setcolor(Maxcolor);
    line(28,180,178,180);
    putpixel(13,179,Maxcolor);
    putpixel(15,179,Maxcolor);
    putpixel(16,179,Maxcolor);
    putpixel(19,179,Maxcolor);

    for i:=1 to 14 do
        begin
            putpixel(28+i*10,180,0);
            putpixel(28+i*10,179,Maxcolor);
        end;

    getimage(4,140,190,180,obrazki[4]^);

    { ******** Góra lodowa ******** }

    size := imagesize(300,180,355,140);
    for i:=5 to 6 do getmem(obrazki[i],size);

    moveto(300,180);
    linerel(15,-40);
    linerel(30,10);
    linerel(10,30);
    getimage(300,180,355,140,obrazki[5]^);
    setcolor(0);
    moveto(300,180);
    linerel(15,-40);
    linerel(30,10);
    linerel(10,30);

    setcolor(Maxcolor);
    moveto(302,180);
    linerel(13,-40);
    linerel(30,9);
    linerel(11,31);
    getimage(300,180,355,140,obrazki[6]^);

    { ******** Zatopienie ******** }

    size := imagesize(410,120,590,160);
    for i:=10 to 14 do getmem(obrazki[i],size);
    setfillstyle(Solidfill,0);

    for i=:1 to 5 do
        begin
            bar(410,120,590,200);
            rysstatek(430,160+i*8);
            bar(410,160,590,200);
            getimage(410,120,590,160,obrazki[i+9]^);
        end;

    { ******** Woda ******** }
    
    size := imagesize(10,190,Maxx-2,192);
    for i:=7 to 9 do getmem(obrazki[i],size);
    
    setfillstyle(Solidfill,Maxcolor);
    line(10,192,Maxx-5,192);
    getimage(10,190,Maxx-2,192,obrazki[7]^);
    
    for i:=0 to (Maxx div 10)-2 do
        begin
            putpixel(i*10+12,192,0);
            putpixel(i*10+12,191,Maxcolor);
        end;
    getimage(10,190,Maxx-2,192,obrazki[8]^);
    
    for i:=0 to (Maxx div 10)-2 do
        begin
            putpixel(i*10+11,192,0);
            putpixel(i*10+12,192,0);
            putpixel(i*10+13,192,0);
            putpixel(i*10+11,191,Maxcolor);
            putpixel(i*10+12,191,0);
            putpixel(i*10+13,191,Maxcolor);
            putpixel(i*10+12,190,Maxcolor);
        end;
    getimage(10,190,Maxx-2,192,obrazki[9]^);
    
end; { learn }


procedure animstatprosto(x : integer);
begin
    putimage(x,ycent,obrazki[1+(animindex div 3) mod 4]^,normalput);
end;


procedure animstattonie;
begin
    putimage(pozycja,ycent,obrazki[10+(animindex div 6) mod 5]^,normalput);
end;


procedure animgora;
begin
    putimage(gorax,ycent,obrazki[5+(animindex div 5) mod 2]^,normalput);
end;


procedure animwoda;
begin
    putimage(wodax,ycent+38,obrazki[7+(animindex div 5) mod 3]^,normalput);
end;


procedure topsie;
begin
    setfillstyle(Solidfill,0);
    bar(xcent-50,ycent div 2,xcent+50,ycent div 2 + Height);
    setfillstyle(Solidfill,Maxcolor);
    outtextxy(xcent-50,ycent div 2,'ŹLE! ! Ma być '+symb);
    animindex:=1;
    repeat
        animstattonie;
        animgora;
        animwoda;
        brr(20);brr(20);brr(20);
        animindex:=(animindex+1) mod 60;
    until animindex>24;
    delay(1000);
    setfillstyle(Solidfill,0);
    bar(0,0,Maxx,Maxy);
    setfillstyle(Solidfill,Maxcolor);
end; { topsie }

