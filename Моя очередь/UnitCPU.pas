unit UnitCPU;

interface
const
  QueueCount=2;
type
  ListPT=^TTimeList;
  QueueElPT=^TQueueList;

  TTimeList=record
    Next:ListPT;
    Value:Integer;
  end;

  TQueueList=record
    Input:Integer;
    Time:ListPT;
    Next:QueueElPT;
  end;

  TQueue = record
    Head:QueueElPT;
    Tail:QueueElPT;
    Count:Integer;
  end;

  TQueueMas=array[1..QueueCount] of TQueue;
var
  TimeNeed:integer;
procedure Initialize(TaktT,InputT:integer);
function AllTakts(var standing:integer):integer;

implementation
const
  OperationCount=10;
  Values:array[1..QueueCount,1..4,1..OperationCount] of integer = (
    (
      ( 2,2,3,4,2,1,1,3,3,2 ),
      ( 4,1,1,1,1,2,2,3,1,1 ),
      ( 4,5,3,2,1,3,4,5,2,3 ),
      ( 0,0,0,0,0,0,0,0,0,0 )
    ),
    (

      ( 4,5,3,2,1,1,3,3,3,4 ),
      ( 6,8,7,5,4,2,3,1,8,5 ),
      ( 0,0,0,0,0,0,0,0,0,0 ),
      ( 0,0,0,0,0,0,0,0,0,0 )

    )
  );
  ObjCount:array[1..QueueCount] of integer = (3,2);

var
  TaktTime,InputTime:integer;
  Objects:TQueueMas;

//Взять элемент с головы очереди
function GetFromQueue(var q:TQueue):QueueElPT;
begin
  if q.Head<> nil then
  begin
    result:=q.Head;
    q.Head:=q.Head^.Next;
    q.Count:=q.Count-1;
  end
  else
    result:=nil;
end;

//Добавить элемент в хвост очереди
procedure AddToQueue(var q:TQueue;var x:QueueElPT);
begin
  x^.Next:=nil;
  if q.Head<> nil then
    q.Tail^.Next:=x
  else
    q.Head:=x;
  q.Tail:=x;
  q.Count:=q.Count+1;
end;


procedure DoCPU(var Queue:TQueue ;var obj: QueueElPT; var standing:integer);
var
  temp:ListPT;
  x:QueueElPT;
begin

  if obj^.Time^.Next^.Value <= TaktTime then
  begin

    standing:=standing + TaktTime - obj^.Time^.Next^.Value;

    temp:=obj^.Time^.Next;
    obj^.Time^.Next:=obj^.Time^.Next^.Next;
    Dispose(temp);

    obj^.Input:=InputTime;
  end

  else
    Dec(obj^.Time^.Next^.Value, TaktTime);


  x:=GetFromQueue(Queue);

  if obj^.Time^.Next <> nil then
    AddToQueue(Queue,x)
  else
    Dispose(obj)
end;


procedure DoNotCPU(var obj: QueueElPT);
begin
  if (obj^.Input <> 0) and (obj^.Input >= TaktTime) then
    obj^.Input:=obj^.Input-TaktTime
  else if (obj^.Input <> 0) then
    obj^.Input:=0;
end;


procedure DoSmth(var obj:QueueElPT);
var
  i,j:integer;
  x:QueueElPT;
begin

  for i:=1 to QueueCount do
  begin
    x:=Objects[i].Head;

    for j:=1 to  Objects[i].Count do
    begin
      //Если элемнт не obj
      if x <> obj then
        DoNotCPU(x);
      x:=x^.Next;
    end;
  end; //for i
end;


procedure Takt(var standing:integer);
var
  i,j:integer;
  x:QueueElPT;
  q:^TQueue;
begin

  i:=1;
  x:=nil;
  while i <= QueueCount do
  begin

    for j:=1 to Objects[i].Count do
    begin
      x:=Objects[i].Head;

      if x^.Input = 0 then
      begin
        q:=@Objects[i];
        break
      end
      else
      begin

        x:=GetFromQueue(Objects[i]);
        AddToQueue(Objects[i],x);
        x:=nil;
      end;
    end;//for j


    if x<>nil then
      break;

    i:=i+1;
  end;//while i
  if x <> nil then
    DoCPU(q^,x,standing)
  else
    standing:=standing+TaktTime;
  DoSmth(x);
end;


function NeedMore:boolean;
var
  i:integer;
begin
  result:=false;
  for i :=1 to QueueCount do
    if Objects[i].Count<> 0 then
      result:=true;
end;


function AllTakts(var standing:integer):integer;
begin
  result:=0;
  standing:=0;

  while NeedMore do      //Пока не выполним всё, что надо
  begin
    Takt(standing);
    result:=result+1;
  end;
end;

procedure Initialize(TaktT,InputT:integer);
var
  i,j,k:integer;
  x:QueueElPT;
  t,t1:ListPT;
begin
  TimeNeed:=0;

  TaktTime:=TaktT;
  InputTime:=InputT;

  for i:=  1 to QueueCount do
  begin

    Objects[i].Head:=nil;
    Objects[i].Tail:=nil;
    Objects[i].Count:=0;


    for j:= 1 to ObjCount[i]  do
    begin

      New(x);
      x^.Next:=nil;
      x^.Input:=0;
      New(x^.Time);
      New(x^.Time^.Next);
      t:=x^.Time^.Next;

       for k:= 1 to OperationCount   do
      begin
        if Values[i,j,k] <> 0 then
        begin
          TimeNeed:=TimeNeed+Values[i,j,k];
          t^.Value:=Values[i,j,k];
          t1:=t;
          New(t);
          t1^.Next:=t
        end;
      end;
      t1^.Next:=nil;

      AddToQueue(Objects[i],x);
    end;
  end;
end;

end.
