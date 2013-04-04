unit mandocking; 

{$mode objfpc}{$H+}

interface

uses
  Types,
  Forms,
  SysUtils,
  Controls,
  ExtCtrls,
  ProjectIntf,
  LazIDEIntf,
  MenuIntf,
  IDEMsgIntf,
  SrcEditorIntf,
  XMLConf;

procedure Register;  

resourcestring
  mnuDockMsgWindow = 'Dock "Messages" window';  

implementation

type
  TDockState = record
    Docked    : Boolean;
    FloatRect : TRect;
    FloatBrd  : TFormBorderStyle;
    DockSize  : TSize;
  end;

  { TManualDocker }

  TManualDocker = class(TObject)
  private
    FCurrentSrcWin  : TWinControl;
  protected
    function DoChangeDocking(DockingEnabled: Boolean): Boolean;
    procedure LoadState(cfg: TXMLConfig; var Astate: TDockState; const StateName: string);
    procedure SaveState(cfg: TXMLConfig; const Astate: TDockState; const StateName: string);
    procedure LoadStates;
    procedure SaveStates;

    procedure AllocControls(AParent: TWinControl);
    procedure DeallocControls;
    procedure RealignControls;
    procedure UpdateDockState(var astate: TDockState; wnd: TWinControl);

    procedure SourceWindowCreated(Sender: TObject);
    procedure SourceWindowDestroyed(Sender: TObject);
  public
    ConfigPath  : AnsiString;
    split       : TSplitter;
    panel       : TPanel;
    MsgWnd      : TDockState;
    constructor Create;
    destructor Destroy; override;
    procedure OnCmdClick(Sender: TObject);
    function OnProjectOpen(Sender: TObject; AProject: TLazProject): TModalResult;
  end;

var
  cmd     : TIDEMenuCommand = nil;
  docker  : TManualDocker = nil;

const
  DockCfgRoot = 'ManualDockConfig';
  DockCfgXML  = 'manualdockconfig.xml';
  MsgDockedName = 'Messages';

{ TManualDocker }

function SafeRect(const c: TREct; MinWidth, MinHeight: Integer): TRect;
begin
  Result := c;
  if Result.Top < 0 then Result.Top := 0;
  if Result.Left < 0 then Result.Left := 0;
  if c.Right - c.Left < MinWidth then Result.Right := Result.Left + MinWidth;
  if c.Bottom - c.Top < MinHeight then Result.Bottom := Result.Top + MinHeight;
end;

function Max(a, b: Integer): Integer;
begin
  if a > b then Result := a
  else Result := b;
end;

function TManualDocker.DoChangeDocking(DockingEnabled:Boolean):Boolean;
var
  i : Integer;
begin
  if DockingEnabled then begin
    Result:=False;
    if not (Assigned(SourceEditorManagerIntf) and Assigned(SourceEditorManagerIntf.ActiveSourceWindow))
       or not Assigned(IDEMessagesWindow)
    then Exit;

    if not Assigned(panel) then
      AllocControls(SourceEditorManagerIntf.ActiveSourceWindow);

    if panel.Parent <> SourceEditorManagerIntf.ActiveSourceWindow then begin
      split.Parent:=SourceEditorManagerIntf.ActiveSourceWindow;
      panel.Parent:=SourceEditorManagerIntf.ActiveSourceWindow;
    end;

    split.visible:=true;
    panel.visible:=true;
    with IDEMessagesWindow do
      if IDEMessagesWindow.Parent = nil then begin
        MsgWnd.FloatRect := Bounds(Left, Top, Width, Height);
        MsgWnd.FloatBrd := IDEMessagesWindow.BorderStyle;
      end;
    IDEMessagesWindow.Parent := panel;
    IDEMessagesWindow.Align := alClient;
    IDEMessagesWindow.BorderStyle := bsNone;
    IDEMessagesWindow.TabStop := False;
    for i := 0 to IDEMessagesWindow.ControlCount - 1 do
      if IDEMessagesWindow.Controls[i] is TWinControl then
        TWinControl(IDEMessagesWindow.Controls[i]).TabStop := False;
    panel.Height := MsgWnd.DockSize.cy;
    Result:=True;
  end else begin
    if Assigned(panel) then begin
      panel.visible := False;
      UpdateDockState(MsgWnd, panel);
    end;
    if Assigned(split) then split.visible := False;
    IDEMessagesWindow.Parent := nil;
    with MsgWnd do begin
      IDEMessagesWindow.BoundsRect := SafeRect(FloatRect,
        Max(30, IDEMessagesWindow.ClientWidth), Max(30, IDEMessagesWindow.ClientHeight));
      IDEMessagesWindow.BorderStyle := FloatBrd;
    end;
    IDEMessagesWindow.TabStop := true;
    IDEMessagesWindow.Show;

    {undocking is always succesfull}
    Result:=True;
  end;
end;

constructor TManualDocker.Create;
var
  pths  : array [0..1] of String;
  i     : Integer;
begin
  if SourceEditorManagerIntf <> nil then begin
    SourceEditorManagerIntf.RegisterChangeEvent(semWindowCreate, @SourceWindowCreated);
    SourceEditorManagerIntf.RegisterChangeEvent(semWindowDestroy, @SourceWindowDestroyed);
  end;

  pths[0]:= LazarusIDE.GetPrimaryConfigPath;
  pths[1]:= LazarusIDE.GetSecondaryConfigPath;
  for i := 0 to length(pths)-1 do begin
    try
      ConfigPath := IncludeTrailingPathDelimiter(pths[i])+DockCfgXML;
      LoadStates;
      Break;
    except
    end;
  end;
  MsgWnd.FloatBrd := bsToolWindow;
end;

destructor TManualDocker.Destroy;
begin
  if Assigned(panel) then UpdateDockState(MsgWnd, panel);
  SaveStates;
  DeallocControls;
  inherited Destroy;
end;

procedure TManualDocker.OnCmdClick(Sender: TObject);
var
  NeedDocking: Boolean;
begin
  NeedDocking:=not Cmd.Checked;
  DoChangeDocking(NeedDocking);
  MsgWnd.docked:=NeedDocking;
  cmd.Checked:=NeedDocking;
end;

function TManualDocker.OnProjectOpen(Sender: TObject; AProject: TLazProject): TModalResult;
begin
  DoChangeDocking(MsgWnd.Docked);
  Result := mrOK;
end;

function CreateXMLConfig(const xmlfile: string) : TXMLConfig;
begin
  Result := TXMLConfig.Create(nil);
  Result.RootName := DockCfgRoot;
  Result.Filename := xmlfile;
end;

procedure TManualDocker.AllocControls(AParent: TWinControl);
begin
  FCurrentSrcWin := AParent;
  panel := TPanel.Create(AParent);
  panel.Parent := AParent;
  panel.BorderStyle := bsNone;

  split := TSplitter.Create(AParent);
  split.Parent := AParent;

  RealignControls;
end;

procedure TManualDocker.DeallocControls;
begin
  split:=nil;
  panel:=nil;
end;

procedure TManualDocker.RealignControls;
begin
  panel.Align := alClient;
  split.Align := alClient;
  panel.Align := alBottom;
  split.Align := alBottom;
end;

procedure TManualDocker.UpdateDockState(var astate: TDockState; wnd: TWinControl);
begin
  astate.DockSize.cx := wnd.ClientWidth;
  astate.DockSize.cy := wnd.ClientHeight;
end;

procedure TManualDocker.SourceWindowCreated(Sender: TObject);
begin
  if Assigned(FCurrentSrcWin) or (SourceEditorManagerIntf.SourceWindowCount > 1) then
    Exit;
  if MsgWnd.Docked then DoChangeDocking(true);
end;

procedure TManualDocker.SourceWindowDestroyed(Sender: TObject);
var
  i : Integer;
begin
  if FCurrentSrcWin <> Sender then Exit;
  DoChangeDocking(False);
  DeallocControls;
  FCurrentSrcWin := nil;

  // avoid re-docking to the window being destroyed
  if MsgWnd.Docked and (SourceEditorManagerIntf.ActiveSourceWindow<>Sender) then
    DoChangeDocking(True);
end;

procedure TManualDocker.LoadState(cfg: TXMLConfig; var Astate: TDockState;
  const StateName: string);
begin
  AState.Docked := cfg.GetValue(StateName+'/docked', False);
  AState.FloatRect.Left := cfg.GetValue(StateName+'/float/left', -1);
  AState.FloatRect.Top := cfg.GetValue(StateName+'/float/top', -1);
  AState.FloatRect.Right := cfg.GetValue(StateName+'/float/right', -1);
  AState.FloatRect.Bottom := cfg.GetValue(StateName+'/float/bottom', -1);
  AState.DockSize.cx := cfg.GetValue(StateName+'/docked/cx', 30);
  AState.DockSize.cy := cfg.GetValue(StateName+'/docked/cy', 50);
end;

procedure TManualDocker.SaveState(cfg: TXMLConfig; const Astate: TDockState; const StateName: string);
begin
  cfg.SetValue(StateName+'/docked', AState.Docked);
  cfg.SetValue(StateName+'/float/left', AState.FloatRect.Left);
  cfg.SetValue(StateName+'/float/top', AState.FloatRect.Top);
  cfg.SetValue(StateName+'/float/right', AState.FloatRect.Right);
  cfg.SetValue(StateName+'/float/bottom', AState.FloatRect.Bottom);
  cfg.SetValue(StateName+'/docked/cx', AState.DockSize.cx);
  cfg.SetValue(StateName+'/docked/cy', AState.DockSize.cy)
end;

procedure TManualDocker.LoadStates;
var
  cfg   : TXMLConfig;
begin
  cfg := CreateXMLConfig(ConfigPath);
  try
    LoadState(cfg, MsgWnd, MsgDockedName)
  finally
    cfg.Free;
  end;
end;

procedure TManualDocker.SaveStates;
var
  cfg   : TXMLConfig;
begin
  cfg := CreateXMLConfig(ConfigPath);
  try
    try
      SaveState(cfg, MsgWnd, MsgDockedName)
    finally
      cfg.Free;
    end;
  except
  end;
end;

procedure Register;
begin
  docker := TManualDocker.Create;
  cmd := RegisterIDEMenuCommand(itmViewMainWindows, 'makeMessagesDocked', mnuDockMsgWindow, @docker.OnCmdClick, nil, nil, '');
  LazarusIDE.AddHandlerOnProjectOpened(@docker.OnProjectOpen, False);
end;

initialization
 
finalization
  docker.Free;

end.

