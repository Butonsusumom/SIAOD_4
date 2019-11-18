program Lab_rab_5;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows,
  UnitCPU in 'UnitCPU.pas';
  procedure Head;
  begin
    Writeln('--------------------------------------------------------------------------------------');
    Writeln('|       |   0  |   1  |   2  |   3  |   4  |   5  |   6  |   7  |   8  |   9  |  10  |');
    Writeln('--------------------------------------------------------------------------------------');
  end;
var
TaktsOfWork,standing,TaktT,InputT:integer;
KPD:real;
i,j:integer;
begin

  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  //Writeln('Время такта:');
  //readln(TaktT);
 // Writeln('Время ввода:');
 // readln(InputT);
  Writeln;
       writeln;
       writeln('                                       KPD');
 Head;
   for i:=1 to 10 do
   begin

   write('|',i:4,'   |');
    for j:=0 to 10 do
    begin
      TaktT:=i;
      InputT:=j;
        Initialize(TaktT,InputT);
        standing:=0;
        TaktsOfWork:=AllTakts(standing);
        KPD:=(TimeNeed/(TimeNeed+standing))*100;
 {  if (TaktT=1) and (InputT=1) then
        begin
        standing:=3;
        KPD:=98.1;
        end;       }

        write(KPD:5:2,'%|');
        end;
        writeln;
               Writeln('--------------------------------------------------------------------------------------');
        end;
       // writeln('Время простоя: ',standing,#13,#10,'КПД процессора: ',KPD:0:2,'%');
       // writeln;
       // writeln;
       Writeln;
       writeln;
       writeln('                                    STANDING');

       Head;
   for i:=1 to 10 do
   begin

   write('|',i:4,'   |');
    for j:=0 to 10 do
    begin
      TaktT:=i;
      InputT:=j;
        Initialize(TaktT,InputT);
        standing:=0;
        TaktsOfWork:=AllTakts(standing);
        KPD:=(TimeNeed/(TimeNeed+standing))*100;
 {  if (TaktT=1) and (InputT=1) then
        begin
        standing:=3;
        KPD:=98.1;
        end;       }

        write(standing:6,'|');
        end;
        writeln;
               Writeln('--------------------------------------------------------------------------------------');
        end;

  readln
end.
