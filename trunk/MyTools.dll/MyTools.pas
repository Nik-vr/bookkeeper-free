unit MyTools;

//  Из исходников Inno Setup
// (c) 1998-2003 Jordan Russell
//
//  Common non-VCL functions

{$B-,R-}

interface

uses Windows, SysUtils, Graphics, Classes, Controls, WinInet;

{ Delphi 2.01's RegStr unit should never be used because it contains many
  wrong declarations. Delphi 3's RegStr unit doesn't have this problem, but
  for backward compatibility, it defines a few of the correct registry key
  constants here. }
const
  { Do NOT localize any of these }
  NEWREGSTR_PATH_SETUP = 'Software\Microsoft\Windows\CurrentVersion';

type TBuffer = array of Char;

type
  TWinVersion = (wvUnknown, wv95, wv98, wvME, wvNT3, wvNT4, wvW2K, wvXP);

procedure ErrorMessage(Msg: string);
function NewFileExists(const Name: String): Boolean;
function DirExists(const Name: String): Boolean;
function AddBackslash(const S: String): String;
function RemoveBackslash(const S: String): String;
function RemoveBackslashUnlessRoot(const S: String): String;
function AddQuotes(const S: String): String;
function RemoveQuotes(const S: String): String;
function GetShortName(const LongName: String): String;
function GetWinDir: String;
function GetSystemDir: String;
function AdjustLength(var S: String; const Res: Cardinal): Boolean;
function RegQueryStringValue(H: HKEY; Name: PChar; var ResultStr: String): Boolean;
function RegValueExists(H: HKEY; Name: PChar): Boolean;
function GetSpecialFolderPath(folder : integer) : string;
function GetProgramFilesPath: String;
function GetCommonFilesPath: String;
function IsMultiByteString(S: String): Boolean;
function RemoveAccelChar(const S: String): String;
function GetTextWidth(const DC: HDC; S: String; const Prefix: Boolean): Integer;
function AddPeriod(const S: String): String;
function GetUserNameString: String;
function IntColorToHex(Color: integer): string;
function HexToInt(Color: string): integer;
function CheckHexForHash(const col: string):string ;
function FontToStr(font: TFont): string;
procedure StrToFont(const str: string; font: TFont);
function tok(const sep: string; var s: string): string;
procedure RemoveDir(const Dir: string);
function MakeRect(Pt1: TPoint; Pt2: TPoint): TRect;
function GetLocaleInformation(Flag: Integer): string;
function DetectWinVersion: TWinVersion;
function BeautyStr(const s: string; iLength: integer): string;
function AltDown : Boolean;
function ShiftDown : Boolean;
function CtrlDown : Boolean;
function SplitString(str: string; separator: Char): TStringList;
function GetRegStringValue(const Key, ValueName: string; RootKey: DWord = HKEY_CLASSES_ROOT): string;
function LenToTime(len: integer): string;
function SmallFonts: Boolean;
function FindMinString(list: TStringList): integer;
function FindMinInt(list: TStringList): integer;
function FindMaxString(list: TStringList): integer;
function FindMaxInt(list: TStringList): integer;
function Replace(Str, X, Y: string): string;
function GetCurFromWeb(Cur: string): Currency;
function QuoteParam(s: string): string;

implementation

uses ActiveX, ShlObj;

// Окно сообщения
procedure ErrorMessage(Msg: string);
begin
  MessageBoxW(0, PWideChar(Msg), 'Ошибка!', $2010);
end;


function fAnsiPos(const Substr, S: string; FromPos: integer): Integer;
var
  P: PChar;
begin
  Result := 0;
  P := AnsiStrPos(PChar(S) + fromPos - 1, PChar(SubStr));
  if P <> nil then
    Result := Integer(P) - Integer(PChar(S)) + 1;
end;


function InternalGetFileAttr(const Name: String): Integer;
var
  OldErrorMode: UINT;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);  { Prevent "Network Error" boxes }
  try
    Result := GetFileAttributes(PChar(RemoveBackslashUnlessRoot(Name)));
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

function NewFileExists(const Name: String): Boolean;
{ Returns True if the specified file exists.
  This function is better than Delphi's FileExists function because it works
  on files in directories that don't have "list" permission. There is, however,
  one other difference: FileExists allows wildcards, but this function does
  not. }
var
  Attr: Integer;
begin
  Attr := InternalGetFileAttr(Name);
  Result := (Attr <> -1) and (Attr and faDirectory = 0);
end;

function DirExists(const Name: String): Boolean;
{ Returns True if the specified directory name exists. The specified name
  may include a trailing backslash.
  NOTE: Delphi's FileCtrl unit has a similar function called DirectoryExists.
  However, the implementation is different between Delphi 1 and 2. (Delphi 1
  does not count hidden or system directories as existing.) }
var
  Attr: Integer;
begin
  Attr := InternalGetFileAttr(Name);
  Result := (Attr <> -1) and (Attr and faDirectory <> 0);
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



function GetShortName(const LongName: String): String;
{ Gets the short version of the specified long filename. If the file does not
  exist, or some other error occurs, it returns LongName. }
var
  Res: DWORD;
begin
  SetLength(Result, MAX_PATH);
  repeat
    Res := GetShortPathName(PChar(LongName), PChar(Result), Length(Result));
    if Res = 0 then begin
      Result := LongName;
      Break;
    end;
  until AdjustLength(Result, Res);
end;

function GetWinDir: String;
{ Returns fully qualified path of the Windows directory. Only includes a
  trailing backslash if the Windows directory is the root directory. }
var
  Buf: array[0..MAX_PATH-1] of Char;
begin
  GetWindowsDirectory(Buf, SizeOf(Buf));
  Result := StrPas(Buf);
end;

function GetSystemDir: String;
{ Returns fully qualified path of the Windows System directory. Only includes a
  trailing backslash if the Windows System directory is the root directory. }
var
  Buf: array[0..MAX_PATH-1] of Char;
begin
  GetSystemDirectory(Buf, SizeOf(Buf));
  Result := StrPas(Buf);
end;


function AdjustLength(var S: String; const Res: Cardinal): Boolean;
{ Returns True if successful. Returns False if buffer wasn't large enough,
  and called AdjustLength to resize it. }
begin
  Result := Integer(Res) < Length(S);
  SetLength(S, Res);
end;

function InternalRegQueryStringValue(H: HKEY; Name: PChar; var ResultStr: String;
  Type1, Type2: DWORD): Boolean;
var
  Typ, Size: DWORD;
  S: String;
begin
  Result := False;
  if (RegQueryValueEx(H, Name, nil, @Typ, nil, @Size) = ERROR_SUCCESS) and
     ((Typ = Type1) or (Typ = Type2)) then begin
    if Size < 2 then begin  {for the following code to work properly, Size can't be 0 or 1}
      ResultStr := '';
      Result := True;
    end
    else begin
      SetLength(S, Size-1); {long strings implicity include a null terminator}
      if RegQueryValueEx(H, Name, nil, nil, @S[1], @Size) = ERROR_SUCCESS then begin
        ResultStr := S;
        Result := True;
      end;
    end;
  end;
end;

function RegQueryStringValue(H: HKEY; Name: PChar; var ResultStr: String): Boolean;
{ Queries the specified REG_SZ or REG_EXPAND_SZ registry key/value, and returns
  the value in ResultStr. Returns True if successful. When False is returned,
  ResultStr is unmodified. }
begin
  Result := InternalRegQueryStringValue(H, Name, ResultStr, REG_SZ,
    REG_EXPAND_SZ);
end;

function RegValueExists(H: HKEY; Name: PChar): Boolean;
{ Returns True if the specified value exists. Requires KEY_QUERY_VALUE access
  to the key. }
var
  I: Integer;
  EnumName: array[0..1] of Char;
  Count: DWORD;
  ErrorCode: Longint;
begin
  Result := RegQueryValueEx(H, Name, nil, nil, nil, nil) = ERROR_SUCCESS;
  if Result and ((Name = nil) or (Name^ = #0)) and
     (Win32Platform <> VER_PLATFORM_WIN32_NT) then begin
    { On Win9x/Me a default value always exists according to RegQueryValueEx,
      so it must use RegEnumValue instead to check if a default value
      really exists }
    Result := False;
    I := 0;
    while True do begin
      Count := SizeOf(EnumName);
      ErrorCode := RegEnumValue(H, I, EnumName, Count, nil, nil, nil, nil);
      if (ErrorCode <> ERROR_SUCCESS) and (ErrorCode <> ERROR_MORE_DATA) then
        Break;
      { is it the default value? }
      if (ErrorCode = ERROR_SUCCESS) and (EnumName[0] = #0) then begin
        Result := True;
        Break;
      end;
      Inc(I);
    end;
  end;
end;


// Пути к системным папкам:
// [Current User]\My Documents      - Folder := CSIDL_PERSONAL;
// All Users\Application Data       - Folder := CSIDL_COMMON_APPDATA;
// [User Specific]\Application Data - Folder := CSIDL_LOCAL_APPDATA;
// Program Files                    - Folder := CSIDL_PROGRAM_FILES;
// All UsersDocuments               - Folder := CSIDL_COMMON_DOCUMENTS;
function GetSpecialFolderPath(folder : integer) : string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
    Result := path
  else
    Result := '';
end;

function GetPathFromRegistry(const Name: PChar): String;
var
  H: HKEY;
begin
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, NEWREGSTR_PATH_SETUP, 0,
     KEY_QUERY_VALUE, H) = ERROR_SUCCESS then begin
    if not RegQueryStringValue(H, Name, Result) then
      Result := '';
    RegCloseKey(H);
  end
  else
    Result := '';
end;

function GetProgramFilesPath: String;
{ Gets path of Program Files.
  Returns blank string if not found in registry. }
begin
  Result := GetPathFromRegistry('ProgramFilesDir');
end;

function GetCommonFilesPath: String;
{ Gets path of Common Files.
  Returns blank string if not found in registry. }
begin
  Result := GetPathFromRegistry('CommonFilesDir');
end;


function IsMultiByteString(S: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
    if IsDBCSLeadByte(Ord(S[I])) then begin
      Result := True;
      Break;
    end;
end;

function FontExistsCallback(const lplf: TLogFont; const lptm: TTextMetric;
  dwType: DWORD; lpData: LPARAM): Integer; stdcall;
begin
  Boolean(Pointer(lpData)^) := True;
  Result := 1;
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

function GetTextWidth(const DC: HDC; S: String; const Prefix: Boolean): Integer;
{ Returns the width of the specified string using the font currently selected
  into DC. If Prefix is True, it first removes "&" characters as necessary. }
var
  Size: TSize;
begin
  { This procedure is 10x faster than using DrawText with the DT_CALCRECT flag }
  if Prefix then
    S := RemoveAccelChar(S);
  GetTextExtentPoint32(DC, PChar(S), Length(S), Size);
  Result := Size.cx;
end;

function AddPeriod(const S: String): String;
begin
  Result := S;
  if (Result <> '') and (AnsiLastChar(Result)^ > '.') then
    Result := Result + '.';
end;

function GetUserNameString: String;
var
  Buf: array[0..255] of Char;
  BufSize: DWORD;
begin
  BufSize := SizeOf(Buf);
  if GetUserName(Buf, BufSize) then
    Result := Buf
  else
    Result := '';
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


// Преобразование параметров шрифта в строку
function FontToStr(font: TFont): string;
  procedure yes(var str: string);
  begin

    str := str + 'y';
  end;
  procedure no(var str: string);
  begin

    str := str + 'n';
  end;
begin

  {кодируем все атрибуты TFont в строку}
  Result := '';
  Result := Result + IntColorToHex(font.Color) + '|';
//  Result := Result + IntToStr(font.Height) + '|';
  Result := Result + font.Name + '|';
//  Result := Result + IntToStr(Ord(font.Pitch)) + '|';
//  Result := Result + IntToStr(font.PixelsPerInch) + '|';
  Result := Result + IntToStr(font.size) + '|';
  if fsBold in font.style then
    yes(Result)
  else
    no(Result);
  if fsItalic in font.style then
    yes(Result)
  else
    no(Result);
  if fsUnderline in font.style then
    yes(Result)
  else
    no(Result);
  if fsStrikeout in font.style then
    yes(Result)
  else
    no(Result);
end;


// Преобразование строки в пааметры шрифта
procedure StrToFont(const str: string; font: TFont);
var
 tStr: string;
begin
  if str = '' then Exit;
  tStr:=str;
  
  font.Color := HexToInt(tok('|', tStr));
//  font.Height := StrToInt(tok('|', str));
  font.Name := tok('|', tStr);
//  font.Pitch := TFontPitch(StrToInt(tok('|', str)));
//  font.PixelsPerInch := StrToInt(tok('|', str));
  font.Size := StrToInt(tok('|', tStr));
  font.Style := [];
  if Copy(tStr, 2, 1) = 'y' then
    font.Style := font.Style + [fsBold];
  if Copy(tStr, 3, 1) = 'y' then
    font.Style := font.Style + [fsItalic];
  if Copy(tStr, 4, 1) = 'y' then
    font.Style := font.Style + [fsUnderline];
  if Copy(tStr, 5, 1) = 'y' then
    font.Style := font.Style + [fsStrikeout];
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


procedure RemoveDir(const Dir: string);
var
  sr: TSearchRec;
begin
  if FindFirst(Dir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if sr.Attr and faDirectory = 0 then
      begin
        DeleteFile(Dir + '\' + sr.name);
      end
      else
      begin
        if pos('.', sr.name) <= 0 then
          RemoveDir(Dir + '\' + sr.name);
      end;
    until
      FindNext(sr) <> 0;
  end;
  FindClose(sr);
  RemoveDirectory(PChar(Dir));
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


// Получение информации о локализации системы
function GetLocaleInformation(Flag: Integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
    pcLCA[0] := #0;
  Result := pcLCA;
end;

function DetectWinVersion: TWinVersion;
var
  OSVersionInfo: TOSVersionInfo;
begin
  Result := wvUnknown;
  OSVersionInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
  begin
    case OSVersionInfo.DwMajorVersion of
      3: Result := wvNT3;
      4: case OSVersionInfo.DwMinorVersion of
          0: if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
              Result := wvNT4
            else
              Result := wv95;
          10: Result := wv98;
          90: Result := wvME;
        end;
      5: case OSVersionInfo.DwMinorVersion of
          0: Result := wvW2K;
          1: Result := wvXP;
        end;
    end;
  end;
end;

// Обрезание строки по длине
function BeautyStr(const s: string; iLength: integer): string;
var
  bm: TBitmap;
  sResult: string;
  iStrLen: integer;
  bAdd: boolean;
begin
  Result := s;
  if Trim(s) = '' then
    exit;

  bAdd := false;
    sResult := s;
  bm := TBitmap.Create;
  bm.Width := 100;
  bm.Height := 100;
  iStrLen := bm.Canvas.TextWidth(sResult);
  while iStrLen > iLength do
  begin
    if Length(sResult) < 4 then
      break;

    Delete(sResult, Length(sResult) - 2, 3);
    bAdd := true;
    iStrLen := bm.Canvas.TextWidth(sResult);
  end;

  if (iStrLen <= iLength) and bAdd then
    sResult := sResult + '...';

  bm.Free;
  Result := sResult;
end;

function CtrlDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Control] and 128) <> 0);
end;

function ShiftDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128) <> 0);
end;

function AltDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Menu] and 128) <> 0);
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



function GetRegStringValue(const Key, ValueName: string; RootKey: DWord = HKEY_CLASSES_ROOT): string;
var
  Size: DWord;
  RegKey: HKEY;
begin
  Result := '';
  if RegOpenKey(RootKey, PChar(Key), RegKey) = ERROR_SUCCESS then
  try
    Size := 256;
    SetLength(Result, Size);
    if RegQueryValueEx(RegKey, PChar(ValueName), nil, nil, PByte(PChar(Result)), @Size) = ERROR_SUCCESS then
      SetLength(Result, Size - 1) else
      Result := '';
  finally
    RegCloseKey(RegKey);
  end;
end;

function LenToTime(len: integer): string;
const
 kd=1000 * 24 * 60 * 60;
 l=3600000; 
begin
 result:='00:00';

  if len<=l
   then result:=FormatDateTime ('nn:ss', len / kd)
   else result:=FormatDateTime ('hh"/"nn', len / kd)

// result:= FormatDateTime ('nn:ss', len / kd);
 //
end;


function SmallFonts: Boolean;
{Значение функции TRUE если мелкий шрифт}
var
  DC: HDC;
begin
  DC := GetDC(0);
  Result := (GetDeviceCaps(DC, LOGPIXELSX) = 96);
  { В случае крупного шрифта будет 120}
  ReleaseDC(0, DC);
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


function GetCurFromWeb(Cur: string): Currency;
var
 hInet, hConnection, hRequest: hInternet;
 s: String;
 Len: Cardinal;
 f: Text;
 Req: string;
 CurDate: string;
 CurDateTmp: TDate;
 TempList: TStringList;
 temp: string;
 i: integer;
begin
 result:=0;
 TempList:=TStringList.Create;
 // Устанавливаем соединение
 try
  hInet:= InternetOpen('?', INTERNET_OPEN_TYPE_DIRECT, nil, nil, 0);
  hConnection := InternetConnect(hInet, 'www.cbr.ru', 80, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
  // Формируем строку запроса
  CurDateTmp:=GetCurrentTime;
  CurDate:=DateToStr(CurDateTmp);
  CurDate[3]:='/'; CurDate[6]:='/';
  req:='/scripts/XML_daily.asp?date_req='+CurDate; //'07/02/2009';
  // Отправляем запрос
  hRequest := HttpOpenRequest(hConnection, 'GET', PChar(req), nil, nil, nil, 0, 0);
  HttpSendRequest(hRequest, nil, 0, nil, 0);
  SetLength(s, $10000);
  InternetReadFile(hRequest, PPointer(@s)^, Length(s), Len);
  SetLength(s, Len);
  InternetCloseHandle(hRequest);
  InternetCloseHandle(hConnection);
  InternetCloseHandle(hInet);
  // Сохраняем файл
  Assign(f, GetTempDir+'Currency.xml');
  Rewrite(f);
  Write(f, s);
  Close(f);
  // Загружаем файл
  TempList.LoadFromFile(GetTempDir+'Currency.xml');

  //
  if Cur='usd' then
  for i:=0 to TempList.Count-1 do
   begin
    if fAnsiPos('R01235', PChar(TempList[i]), 1)<>0
     then temp:=TempList[i+5];
   end;
  //
  if Cur='eur' then
  for i:=0 to TempList.Count-1 do
   begin
    if fAnsiPos('R01239', PChar(TempList[i]), 1)<>0
     then temp:=TempList[i+5];
   end;

  temp:=Copy(temp, 9, Length(temp)-16);

  if Length(temp)>0
   then result:=StrToCurr(temp);
 except
   result:=0;
 end;  

end;

// Экранирование символов в SQL-запросов
function QuoteParam(s: string): string;
var
 i: integer;
 Dest: string;
begin
 Dest:= '';
 for i:=1 to length(s) do
  // берём текущий символ и при необходимости заменяем его
  case s[i] of
  '"': Dest:=Dest+'''';
  else Dest:=Dest+s[i];
 end; // for

 result:=Dest;
end;




end.


