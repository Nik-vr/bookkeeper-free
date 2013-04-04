unit MyTools;

// Вспомогательные функции
// (c) 2004-2010 Петроченко Н.Ю.

interface

uses SysUtils, Classes, Dialogs;

type TBuffer = array of Char;

procedure ErrorMessage(Msg: string);
function AddBackslash(const S: String): String;
function RemoveBackslash(const S: String): String;
function RemoveBackslashUnlessRoot(const S: String): String;
function AddQuotes(const S: String): String;
function RemoveQuotes(const S: String): String;
function AdjustLength(var S: String; const Res: Cardinal): Boolean;
function RemoveAccelChar(const S: String): String;
function AddPeriod(const S: String): String;
function IntColorToHex(Color: integer): string;
function HexToInt(Color: string): integer;
function CheckHexForHash(const col: string):string ;
function tok(const sep: string; var s: string): string;
function MakeRect(Pt1: TPoint; Pt2: TPoint): TRect;
function SplitString(str: string; separator: Char): TStringList;
function FindMinString(list: TStringList): integer;
function FindMinInt(list: TStringList): integer;
function FindMaxString(list: TStringList): integer;
function FindMaxInt(list: TStringList): integer;
function Replace(Str, X, Y: string): string;
function ConvertQuotes(const source_text:string):string;
function CntChRepet(InputStr: string; InputSubStr: char): integer;

implementation


// Окно сообщения
procedure ErrorMessage(Msg: string);
begin
  MessageDlg('Ошибка!', Msg, mtError, [mbClose], '');
end;


function GetParamStr(P: PChar; var Param: String): PChar;
var
  Len: Integer;
  Buffer: array[0..4095] of Char;
begin
  while True do begin
    while (P[0] <> #0) and (P[0] <= ' ') do Inc(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  while (P[0] > ' ') and (Len < SizeOf(Buffer)) do
    if P[0] = '"' then begin
      Inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do begin
        Buffer[Len] := P[0];
        Inc(Len);
        Inc(P);
      end;
      if P[0] <> #0 then Inc(P);
    end
    else begin
      Buffer[Len] := P[0];
      Inc(Len);
      Inc(P);
    end;
  SetString(Param, Buffer, Len);
  Result := P;
end;

function AddBackslash(const S: String): String;
{ Adds a trailing backslash to the string, if one wasn't there already.
  But if S is an empty string, the function returns an empty string. }
begin
  Result := S;
  if (Result <> '') and (AnsiLastChar(Result)^ <> '\') then
    Result := Result + '\';
end;

function RemoveBackslash(const S: String): String;
{ Removes the trailing backslash from the string, if one exists }
begin
  Result := S;
  if (Result <> '') and (AnsiLastChar(Result)^ = '\') then
    SetLength(Result, Length(Result)-1);
end;

function RemoveBackslashUnlessRoot(const S: String): String;
{ Removes the trailing backslash from the string, if one exists and does
  not specify a root directory of a drive (i.e. "C:\"}
var
  L: Integer;
begin
  Result := S;
  L := Length(Result);
  if L < 2 then
    Exit;
  if (AnsiLastChar(Result)^ = '\') and
     ((Result[L-1] <> ':') or (ByteType(Result, L-1) <> mbSingleByte)) then
    SetLength(Result, L-1);
end;

function AddQuotes(const S: String): String;
{ Adds a quote (") character to the left and right sides of the string if
  the string contains a space and it didn't have quotes already. This is
  primarily used when spawning another process with a long filename as one of
  the parameters. }
begin
  Result := Trim(S);
  if (AnsiPos(' ', Result) <> 0) and
     ((Result[1] <> '"') or (AnsiLastChar(Result)^ <> '"')) then
    Result := '"' + Result + '"';
end;

function RemoveQuotes(const S: String): String;
{ Opposite of AddQuotes; removes any quotes around the string. }
begin
  Result := S;
  while (Result <> '') and (Result[1] = '"') do
    Delete(Result, 1, 1);
  while (Result <> '') and (AnsiLastChar(Result)^ = '"') do
    SetLength(Result, Length(Result)-1);
end;


function AdjustLength(var S: String; const Res: Cardinal): Boolean;
{ Returns True if successful. Returns False if buffer wasn't large enough,
  and called AdjustLength to resize it. }
begin
  Result := Integer(Res) < Length(S);
  SetLength(S, Res);
end;


function RemoveAccelChar(const S: String): String;
var
  I: Integer;
begin
  Result := S;

  I := 1;
  while I <= Length(Result) do begin
    if not(Result[I] in LeadBytes) then begin
      if Result[I] = '&' then
        System.Delete(Result, I, 1);
      Inc(I);
    end
    else
      Inc(I, 2);
  end;
end;

function AddPeriod(const S: String): String;
begin
  Result := S;
  if (Result <> '') and (AnsiLastChar(Result)^ > '.') then
    Result := Result + '.';
end;


// Преобразует Hex-цвет (HTML) в обычный TColor
function HexToInt(Color: string): integer;
var
  rColor: integer;
begin
  rColor:=0;
  Color := CheckHexForHash(Color);

  if (length(color) >= 6) then
  begin
    {незабудьте, что TColor это bgr, а не rgb: поэтому необходимо изменить порядок}
    color := '$00' + copy(color,5,2) + copy(color,3,2) + copy(color,1,2);
    rColor := StrToInt(color);
  end;

  result := rColor;
end;

// Просто проверяет первый сивол строки на наличие '#' и удаляет его, если он найден
function CheckHexForHash(const col: string): string;
var
 rCol: string;
begin
  rCol:=col;
  if rCol[1] = '#' then
    rCol := StringReplace(rCol,'#','',[rfReplaceAll]);
  result := rCol;
end;

function tok(const sep: string; var s: string): string;

  function isoneof(c, s: string): Boolean;
  var
    iTmp: integer;
  begin
    Result := False;
    for iTmp := 1 to Length(s) do
    begin
      if c = Copy(s, iTmp, 1) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
var

  c, t: string;
begin

  if s = '' then
  begin
    Result := s;
    Exit;
  end;
  c := Copy(s, 1, 1);
  while isoneof(c, sep) do
  begin
    s := Copy(s, 2, Length(s) - 1);
    c := Copy(s, 1, 1);
  end;
  t := '';
  while (not isoneof(c, sep)) and (s <> '') do
  begin
    t := t + c;
    s := Copy(s, 2, length(s) - 1);
    c := Copy(s, 1, 1);
  end;
  Result := t;
end;

// Преобразует TColor в Hex-цвет (Delphi - BGR)
function IntColorToHex(Color: integer): string;
var
  temp: string;
begin
  temp:=IntToHex(Color, 6);
  result := copy(temp,5,2) + copy(temp,3,2) + copy(temp,1,2);
end;


// Получение Rect по координатам угловых точек
function MakeRect(Pt1: TPoint; Pt2: TPoint): TRect;
begin
  if pt1.x < pt2.x then
  begin
    Result.Left := pt1.x;
    Result.Right := pt2.x;
  end
  else
  begin
    Result.Left := pt2.x;
    Result.Right := pt1.x;
  end;
  if pt1.y < pt2.y then
  begin
    Result.Top := pt1.y;
    Result.Bottom := pt2.y;
  end
  else
  begin
    Result.Top := pt2.y;
    Result.Bottom := pt1.y;
  end;
end;


function SplitString(str: string; separator: Char): TStringList;
var
 i: integer;
 num: integer;
begin
 // Создание объекта
 Result:=TStringList.Create;
 num:=0;

 // Подчет количества
 for i:=1 to Length(str) do
  begin
   if str[i]=separator then num:=num+1;
  end;

 // Нарезка
 for i:=0 to num do
  begin
   result.Add( tok(separator, str) );
  end;
end;


// Поиск в списке первой по алфавиту строки
function FindMinString(list: TStringList): integer;
var
  min: integer; // номер минимального элемента массива
  i: integer; // номер элемента, сравниваемого с минимальным
begin
  min := 0; // пусть первый элемент минимальный
  for i := 1 to list.Count-1 do
   begin
    if List[i] < List[min] then  min := i;
   end;
  result:=min;
end;

// Поиск в списке минимального целого числа
function FindMinInt(list: TStringList): integer;
var
  min: integer; // номер минимального элемента массива
  i: integer; // номер элемента, сравниваемого с минимальным
begin
  min := 0; // пусть первый элемент минимальный
  for i := 1 to list.Count-1 do
   begin
    if StrToInt(List[i]) < StrToInt(List[min]) then  min := i;
   end;
  result:=min;
end;

// Поиск в списке последней по алфавиту строки
function FindMaxString(list: TStringList): integer;
var
  max: integer; // номер минимального элемента массива
  i: integer; // номер элемента, сравниваемого с минимальным
begin
  max := 0; // пусть первый элемент минимальный
  for i := 1 to list.Count-1 do
   begin
    if List[i] > List[max] then  max := i;
   end;
  result:=max;
end;

// Поиск в списке максимального целого числа
function FindMaxInt(list: TStringList): integer;
var
  max: integer; // номер максимального элемента массива
  i: integer; // номер элемента, сравниваемого с максимальным
begin
  max:= 0; // пусть первый элемент максимальный
  for i:= 1 to list.Count-1 do
   begin
    if StrToInt(List[i]) > StrToInt(List[max]) then max:=i;
   end;
  result:=StrToInt(list[max]);
end;

function Replace(Str, X, Y: string): string;
{Str - строка, в которой будет производиться замена.
 X - подстрока, которая должна быть заменена.
 Y - подстрока, на которую будет произведена заменена}
var
  buf1, buf2, buffer: string;
begin
  buf1 := '';
  buf2 := Str;
  Buffer := Str;

  while Pos(X, buf2) > 0 do
  begin
    buf2 := Copy(buf2, Pos(X, buf2), (Length(buf2) - Pos(X, buf2)) + 1);
    buf1 := Copy(Buffer, 1, Length(Buffer) - Length(buf2)) + Y;
    Delete(buf2, Pos(X, buf2), Length(X));
    Buffer := buf1 + buf2;
  end;

  Replace := Buffer;
end;

// Замена прямых кавычек на "лапки"
function ConvertQuotes(const source_text:string):string;
const
 REPLACE_CHARS: array[boolean] of char = (#187,#171);
var
  i: cardinal;
 rpl: cardinal;
begin
  result:= source_text;
  rpl:= 0;

  for i:=1 to length(result) do
   if result[i] = '"' then
    begin
     inc(rpl);
     result[i] := REPLACE_CHARS[ odd(rpl) ];
    end;
end;



function CntChRepet(InputStr: string; InputSubStr: char): integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to length(InputStr) do
    if InputStr[i] = InputSubStr then
      inc(result);
end;

end.
