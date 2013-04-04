unit options;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{$M+}
TOptions = class(TObject)
  protected
    FIniFile: TIniFile;
    function Section: string;
    procedure SaveProps;
    procedure ReadProps;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
end;
{$M-}

constructor TOptions.Create(const FileName: string);
begin
  FIniFile:=TIniFile.Create(FileName);
  ReadProps;
end;

destructor TOptions.Destroy;
begin
  SaveProps;
  FIniFile.Free;
  inherited Destroy;
end;

procedure TOptions.SaveProps;
var
  I, N: Integer;
  TypeData: PTypeData;
  List: PPropList;
begin
  TypeData:= GetTypeData(ClassInfo);
  N:= TypeData.PropCount;
  if N <= 0 then
    Exit;
  GetMem(List, SizeOf(PPropInfo)*N);
  try
    GetPropInfos(ClassInfo,List);
    for I:= 0 to N - 1 do
      case List[I].PropType^.Kind of
        tkEnumeration, tkInteger:
          FIniFile.WriteInteger(Section, List[I]^.name,GetOrdProp(Self,List[I]));
        tkFloat:
          FIniFile.WriteFloat(Section, List[I]^.name, GetFloatProp(Self, List[I]));
        tkString, tkLString, tkWString:
          FIniFile.WriteString(Section, List[I]^.name, GetStrProp(Self, List[I]));
      end;
  finally
    FreeMem(List,SizeOf(PPropInfo)*N);
  end;
end;


procedure TOptions.ReadProps;
var
  I, N: Integer;
  TypeData: PTypeData;
  List: PPropList;
  AInt: Integer;
  AFloat: Double;
  AStr: string;
begin
  TypeData:= GetTypeData(ClassInfo);
  N:= TypeData.PropCount;
  if N <= 0 then
    Exit;
  GetMem(List, SizeOf(PPropInfo)*N);
  try
    GetPropInfos(ClassInfo, List);
    for I:= 0 to N - 1 do
      case List[I].PropType^.Kind of
        tkEnumeration, tkInteger:
        begin
          AInt:= GetOrdProp(Self, List[I]);
          AInt:= FIniFile.ReadInteger(Section, List[I]^.name, AInt);
          SetOrdProp(Self, List[i], AInt);
        end;
        tkFloat:
        begin
          AFloat:=GetFloatProp(Self,List[i]);
          AFloat:=FIniFile.ReadFloat(Section, List[I]^.name,AFloat);
          SetFloatProp(Self,List[i],AFloat);
        end;
        tkString, tkLString, tkWString:
        begin
          AStr:= GetStrProp(Self,List[i]);
          AStr:= FIniFile.ReadString(Section, List[I]^.name, AStr);
          SetStrProp(Self,List[i], AStr);
        end;
      end;
  finally
    FreeMem(List,SizeOf(PPropInfo)*N);
  end;
end;

function TOptions.Section: string;
begin
  Result := ClassName;
end;

end.