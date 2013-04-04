unit unique_utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, simpleipc;

type

  TOnUniqueInstanceMessage = procedure (Sender: TObject; Params: array of String; ParamCount: Integer) of object;

  { TUniqueInstance }

  TUniqueInstance = class
  private
    fcli: TSimpleIPCClient;
    fOnMessage: TOnUniqueInstanceMessage;
    fsrv: TSimpleIPCServer;
    fName: String;

    procedure OnNative(Sender: TObject);

    procedure CreateSrv;
    procedure CreateCli;
  public
    property OnMessage: TOnUniqueInstanceMessage read fOnMessage write fOnMessage;

    function IsRunInstance: Boolean;
    procedure SendParams;
    procedure SendString(aStr: String);

    procedure RunListen;
    procedure StopListen;

    constructor Create(aName: String);
    destructor Destroy; override;
  end;

implementation

uses strutils;

{ TUniqueInstance }

procedure TUniqueInstance.OnNative(Sender: TObject);
var
 Str: array of String;
 Cnt,i: Integer;

  procedure GetParams(const AStr: String);
  var
    pos1,pos2:Integer;
  begin
    SetLength(Str, Cnt);
    i := 0;
    pos1:=1;
    pos2:=pos(#1, AStr);
    while pos1 < pos2 do
    begin
      str[i] := Copy(AStr, pos1, pos2 - pos1);
      pos1 := pos2+1;
      pos2 := posex(#1, AStr, pos1);
      inc(i);
    end;
  end;

begin
  if Assigned(fOnMessage) then
   begin
    Cnt:=fsrv.MsgType;
    GetParams(fsrv.StringMessage);
    fOnMessage(Self,Str,Cnt);
    SetLength(Str,0);
   end;
end;

procedure TUniqueInstance.CreateSrv;
begin
  if fsrv=nil then
   begin
    fsrv:=TSimpleIPCServer.Create(nil);
    fsrv.OnMessage:=@OnNative;
   end;
  if fcli<>nil then
   FreeAndNil(fcli);
end;

procedure TUniqueInstance.CreateCli;
begin
  if fcli=nil then
   fcli:=TSimpleIPCClient.Create(nil);
end;

function TUniqueInstance.IsRunInstance: Boolean;
begin
  CreateCli;
  fcli.ServerID:=fName;
  Result:=fcli.ServerRunning;
end;

procedure TUniqueInstance.SendParams;
var
 t: String;
 j: Integer;
begin
  CreateCli;
  fcli.ServerID:=fName;
  if not fcli.ServerRunning then
   Exit;
  t:='';
  for j:=1 to ParamCount do
   t:=t+#1+AnsiToUtf8(ParamStr(j));
  try
   fcli.Connect;
   fcli.SendStringMessage(ParamCount,t);
  finally
   fcli.Disconnect;
  end;
end;

procedure TUniqueInstance.SendString(aStr: String);
begin
  CreateCli;
  fcli.ServerID:=fName;
  if not fcli.ServerRunning then
   Exit;
  try
   fcli.Connect;
   fcli.SendStringMessage(1,aStr+#1);
  finally
   fcli.Disconnect;
  end;
end;

procedure TUniqueInstance.RunListen;
begin
  CreateSrv;
  fsrv.ServerID:=fName;
  fsrv.Global:=True;
  fsrv.StartServer;
end;

procedure TUniqueInstance.StopListen;
begin
  if fsrv=nil then
   Exit;
  fsrv.StopServer;
end;

constructor TUniqueInstance.Create(aName: String);
begin
  fName:=aName;
end;

destructor TUniqueInstance.Destroy;
begin
  if fcli<>nil then
   fcli.Free;
  if fsrv<>nil then
   fsrv.Free;
  inherited Destroy;
end;

end.

