unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, SpkRollPanel, SpkExpandPanel, ExpandPanels;

type

  { TForm1 }

  TForm1 = class(TForm)
   Button1: TButton;
   MyRollOut1: TMyRollOut;
   Panel1: TPanel;
   SpkRollPanel1: TSpkRollPanel;
   SpkRollPanel2: TSpkRollPanel;
   SpkRollPanel3: TSpkRollPanel;
   SpkRollPanel4: TSpkRollPanel;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

end.

