unit SpkRollPanel;
{$mode objfpc}{$H+}
interface

uses
    {$IFDEF MSWINDOWS}
    windows,
    {$ELSE}
    LCLIntf,LCLType,LMessages,
    {$ENDIF}
     classes, Graphics, Controls, forms, extctrls, Dialogs,SpkGraphTools,
     StdCtrls,Buttons,sysutils, messages, Math, SpkAnimator, TypInfo;

type TGradientMode = (gmNone, gmUser, gmAuto);
     TGradientType = (gtVertical, gtHorizontal);
     TRollMode = (rmUnroll, rmRoll);
     TResizeMode = (rmNormal, rmResize);

type

{ TSpkRollPanel }

TSpkRollPanel = class(TPanel)
     private
       // Pomocnicze
       FRollMode : TRollMode;
       FResizeMode : TResizeMode;
       FUnrollHeight : integer;
       FMouseDelta : integer;

       // W³aœciwoœci
       FMargin : integer;
       FMarginColor : TColor;
       FCaptionHeight : integer;
       FBorderColor : TColor;
       FAllowResize : boolean;
       FAnimate : boolean;
       FAnimator : TSpkAnimator;
       FHideChildren : boolean;
       FCanMove: Boolean;
       down: Boolean;
       mx,my: integer;
       
       FCaptionGradientMode : TGradientMode;
       FCaptionColorFrom,
       FCaptionColorTo : TColor;
       FCaptionGradientType : TGradientType;

       FPanelGradientMode : TGradientMode;
       FPanelColorFrom,
       FPanelColorTo : TColor;
       FPanelGradientType : TGradientType;
     protected
       procedure paint; override;

       procedure SetCaptionGradientMode(value : TGradientMode);
       procedure SetCaptionColorFrom(value : TColor);
       procedure SetCaptionColorTo(value : TColor);
       procedure SetCaptionGradientType(value : TGradientType);

       procedure SetPanelGradientMode(value : TGradientMode);
       procedure SetPanelColorFrom(value : TColor);
       procedure SetPanelColorTo(value : TColor);
       procedure SetPanelGradientType(value : TGradientType);

       procedure SetMargin(value : integer);
       procedure SetMarginColor(value : TColor);
       procedure SetCaptionHeight(value : integer);
       procedure SetBorderColor(value : TColor);
       procedure SetAllowResize(value : boolean);
       procedure SetCanMove(value : boolean);

       procedure MyOnLMouseButtonUp(var msg : TMessage) {$IFDEF MSWINDOWS} message WM_LBUTTONUP {$ELSE} message LM_LBUTTONUP {$ENDIF};
       procedure MyOnLMouseButtonDown(var msg : TMessage); {$IFDEF MSWINDOWS} message WM_LBUTTONDOWN {$ELSE} message LM_LBUTTONDOWN {$ENDIF};
       procedure MyOnMouseMove(var msg : TMessage); {$IFDEF MSWINDOWS} message WM_MOUSEMOVE {$ELSE} message LM_MOUSEMOVE {$ENDIF};
       
       procedure SetRollMode(ARollMode : TRollMode);

       procedure OnFinishAnimation(sender : TObject);

       procedure HideComponents;
       procedure ShowComponents;
     public
       constructor create(AOwner : TComponent); override;
       destructor destroy; override;

       procedure AlignControls( AControl : TControl; var Rect : TRect); override;
     published
       property Margin : integer read FMargin write SetMargin;
       property MarginColor : TColor read FMarginColor write SetMarginColor;
       property CaptionHeight : integer read FCaptionHeight write SetCaptionHeight;
       property BorderColor : TColor read FBorderColor write SetBorderColor;
       property AllowResize : boolean read FAllowResize write SetAllowResize;
       property Animate : boolean read FAnimate write FAnimate;
       property HideChildren : boolean read FHideChildren write FHideChildren;

       property RollMode : TRollMode read FRollMode write SetRollMode;

       property CaptionGradientMode : TGradientMode read FCaptionGradientMode write SetCaptionGradientMode;
       property CaptionColorFrom : TColor read FCaptionColorFrom write SetCaptionColorFrom;
       property CaptionColorTo : TColor read FCaptionColorTo write SetCaptionColorTo;
       property CaptionGradientType : TGradientType read FCaptionGradientType write SetCaptionGradientType;

       property PanelGradientMode : TGradientMode read FPanelGradientMode write SetPanelGradientMode;
       property PanelColorFrom : TColor read FPanelColorFrom write SetPanelColorFrom;
       property PanelColorTo : TColor read FPanelColorTo write SetPanelColorTo;
       property PanelGradientType : TGradientType read FPanelGradientType write SetPanelGradientType;
       property CanMove : Boolean read FCanMove write SetCanMove;

     end;

procedure Register;

implementation

{ TSpkRollPanel }

procedure Register;

begin
RegisterComponents('SpookSoft',[TSpkRollPanel]);
end;

procedure TSpkRollPanel.SetCaptionGradientMode(value : TGradientMode);

begin
FCaptionGradientMode:=value;
refresh;
end;

procedure TSpkRollPanel.SetCaptionColorFrom(value : TColor);

begin
FCaptionColorFrom:=value;
refresh;
end;

procedure TSpkRollPanel.SetCaptionColorTo(value : TColor);

begin
FCaptionColorTo:=value;
refresh;
end;

procedure TSpkRollPanel.SetCaptionGradientType(value : TGradientType);

begin
FCaptionGradientType:=value;
refresh;
end;

procedure TSpkRollPanel.SetPanelGradientMode(value : TGradientMode);

begin
FPanelGradientMode:=value;
refresh;
end;

procedure TSpkRollPanel.SetPanelColorFrom(value : TColor);

begin
FPanelColorFrom:=value;
refresh;
end;

procedure TSpkRollPanel.SetPanelColorTo(value : TColor);

begin
FPanelColorTo:=value;
refresh;
end;

procedure TSpkRollPanel.SetPanelGradientType(value : TGradientType);

begin
FPanelGradientType:=value;
refresh;
end;

procedure TSpkRollPanel.SetMargin(value : integer);

begin
FMargin:=value;
refresh;
end;

procedure TSpkRollPanel.SetMarginColor(value : TColor);

begin
FMarginColor:=value;
refresh;
end;

procedure TSpkRollPanel.SetCaptionHeight(value : integer);

begin
FCaptionHeight:=value;
refresh;
end;

procedure TSpkRollPanel.SetBorderColor(value : TColor);

begin
FBorderColor:=value;
refresh;
end;

procedure TSpkRollPanel.SetAllowResize(value : boolean);

begin
FAllowResize:=value;
refresh;
end;

procedure TSpkRollPanel.SetCanMove(value: boolean);
begin
FCanMove:=value;
refresh;
end;

procedure TSpkRollPanel.MyOnLMouseButtonUp(var msg : TMessage);
var x,y : integer;
begin
inherited;
x:=loword(msg.LParam);
y:=hiword(msg.LParam);
down:=false;
if (x>Fmargin) and (x<self.width-Fmargin-1) and
   (y>Fmargin) and (y<Fmargin+CaptionHeight) then
   begin
   if (align in [alTop, alBottom, alNone]) then
      begin
      if FRollMode=rmUnroll then
         SetRollMode(rmRoll) else
         SetRollMode(rmUnroll);
      end;
   end;
end;

procedure TSpkRollPanel.SetRollMode(ARollMode : TRollMode);

begin
if ARollMode=FRollMode then exit;
if not(FAnimator.CanAnimate) then exit;
if ARollMode=rmRoll then
   begin
   FUnrollHeight:=self.height;
   if FHideChildren then HideComponents;
   FRollMode:=ARollMode;
   if FAnimate then
      begin
      FAnimator.Options.SquareMode:=smMinus;
      FAnimator.animate(self.height,2*FMargin+FCaptionHeight+2);
      end else self.height:=2*FMargin+FCaptionHeight+2;
   end else
       begin
       FRollMode:=ARollMode;
       if FAnimate then
          begin
          FAnimator.Options.SquareMode:=smMinus;
          FAnimator.animate(self.height, FUnrollHeight)
          end else
              begin
              self.height:=FUnrollHeight;
              if FHideChildren then ShowComponents;
              end;
       end;

end;

procedure TSpkRollPanel.MyOnLMouseButtonDown(var msg : TMessage);
begin
  inherited;
  mx:=msg.LParamLo;
  my:=msg.LParamHi;
  down:=true;
end;

procedure TSpkRollPanel.MyOnMouseMove(var msg : TMessage);
var x,y : integer;
    lmb : boolean;
    tp: TPoint;
begin
  inherited;
  x:=msg.LParamLo;
  y:=msg.LParamHi;
  lmb:=(msg.WParam and MK_LBUTTON<>0);
  if CanMove and down then begin
//      self.Cursor:=crHourGlass;
      if x>mx then self.Left:=self.left+(x-mx)
      else if x<mx then self.Left:=self.left-(mx-x);
      if y>my then self.top:=self.top+(y-my)
      else if y<my then self.top:=self.top-(my-y);
      mx:=x;
      my:=y;
      Self.Refresh;
//      exit;
  end;
if (FRollMode=rmUnroll) and FAllowResize then
   begin
   if (x>FMargin) and (x<self.width-FMargin-1) and
      (y>=self.Height-FMargin-4) and (y<self.height-FMargin)
      then self.Cursor:=crSizeNS else self.cursor:=crDefault;

   // Jeœli u¿ytkownik w³aœnie skoñczy³ resize'owaæ
   if  not(lmb) and (FResizeMode=rmResize) then
            begin
            // Zakoñcz resize
            FResizeMode:=rmNormal;
            end;
   // Jeœli u¿ytkownik rozpoczyna resize
   if (y>=self.Height-FMargin-4) and (y<self.height-FMargin) and lmb and (FResizeMode=rmNormal)then
      begin
      // W³¹cz tryb resize
      FResizeMode:=rmResize;
      // Oblicz zale¿noœæ pomiêdzy pozycj¹ gryzonia i wysokoœci¹ pane'a
      FMouseDelta:=mouse.cursorpos.Y-self.height;
      end;
   // Jeœli trwa resize
   if FResizeMode=rmResize then
      begin
      // Ustaw odpowiedni¹ wysokoœæ w zale¿noœci od pozycji gryzonia
      // self.Height:=max(FMinHeight,mouse.cursorpos.Y-FMouseDelta) else
      self.Height:=max(mouse.cursorpos.Y-FMouseDelta,FCaptionHeight+2*FMargin+2+10);
      self.refresh;
      end;
   end;
   Inherited;
end;

constructor TSpkRollPanel.create(AOwner : TComponent);

begin
  inherited;// create(AOwner);
  FRollMode:=rmUnroll;
  FResizeMode:=rmNormal;

  FMargin:=2;
  FMarginColor:=clWhite;
  FCaptionHeight:=16;
  FBorderColor:=clBtnFace;
  FAnimate:=false;
  FHideChildren:=false;
  FAnimator:=TSpkAnimator.create;
  with FAnimator.Options do
       begin
       AnimationTime:=200;
       AnimationType:=atHeight;
       Square:=true;
       SquareMode:=smPlus;
       Target:=self;
       end;
  FAnimator.OnFinishAnimation:=@self.OnFinishAnimation;

  DoubleBuffered:=true;

  font.Style:=[fsBold];

  FCaptionGradientMode:=gmNone;
  FCaptionColorFrom:=clBtnFace;
  FCaptionColorTo:=clBtnFace;
  FCaptionGradientType:=gtVertical;

  FPanelGradientMode:=gmNone;
  FPanelColorFrom:=clWhite;
  FPanelColorTo:=clBtnFace;
  FPanelGradientType:=gtVertical;

  FAllowResize:=true;
end;

destructor TSpkRollPanel.destroy;

begin
  inherited;
end;

procedure TSpkRollPanel.AlignControls( AControl : TControl; var Rect : TRect);
begin
with Rect do begin
             Top := Top + 4 + FMargin + FCaptionHeight;
             Bottom := Bottom - 4;
             Left := Left + 4;
             Right := Right - 4;
             end;
inherited AlignControls( AControl, Rect );
end;

procedure TSpkRollPanel.paint;

var drawrect : TRect;
    textheight : integer;

begin
// Margines

Drawrect.top:=FMargin;
Drawrect.left:=FMargin;
Drawrect.Right:=self.width-1-FMargin;
Drawrect.Bottom:=self.height-1-FMargin;

self.canvas.brush.color:=FMarginColor;
self.canvas.brush.style:=bsSolid;
self.canvas.FillRect(rect(0,0,width,height));

// Caption panela
// Ramka

self.canvas.pen.color:=FBorderColor;
rectangle(self.canvas,drawrect.left,drawrect.top,drawrect.right,drawrect.top+FCaptionHeight+1);

// T³o

case FCaptionGradientMode of
     gmNone : begin
              self.canvas.brush.color:=FCaptionColorFrom;
              self.canvas.brush.style:=bsSolid;
              self.canvas.FillRect(rect(drawrect.left+1,drawrect.top+1,drawrect.right-1 +1,drawrect.top+FCaptionheight +1))
              end;
     gmUser : begin
              case FCaptionGradientType of
                   gtVertical : VGradient(self.canvas,FCaptionColorFrom,FCaptionColorTo,drawrect.left+1,drawrect.top+1,drawrect.right-1,drawrect.top+FCaptionheight);
                   gtHorizontal : HGradient(self.canvas,FCaptionColorFrom,FCaptionColorTo,drawrect.left+1,drawrect.top+1,drawrect.right-1,drawrect.top+FCaptionheight);
              end;
              end;
     gmAuto : begin
              case FCaptionGradientType of
                   gtVertical : VGradient(self.canvas,FCaptionColorFrom,brighten(FCaptionColorFrom,40),drawrect.left+1,drawrect.top+1,drawrect.right-1,drawrect.top+FCaptionheight);
                   gtHorizontal : HGradient(self.canvas,FCaptionColorFrom,brighten(FCaptionColorFrom,40),drawrect.left+1,drawrect.top+1,drawrect.right-1,drawrect.top+FCaptionheight);
              end;
              end;
end;

// Tekst captiona

self.canvas.brush.style:=bsClear;
self.canvas.Font.assign(self.Font);
textheight:=self.canvas.textheight('Wy');
self.canvas.TextOut(drawrect.Left+5,drawrect.top+1+((FCaptionHeight-textheight) div 2),self.caption);

// Pole zawartoœci panela

// if FRollMode=rmUnroll then
if height>2*FMargin+FCaptionHeight+2 then
   begin
   self.canvas.pen.color:=FBorderColor;
   rectangle(self.canvas,drawrect.left,drawrect.top+FCaptionHeight+1,drawrect.right,drawrect.bottom);

   // T³o
   case FPanelGradientMode of
        gmNone : begin
                 self.canvas.brush.color:=FPanelColorFrom;
                 self.canvas.brush.style:=bsSolid;
                 self.canvas.FillRect(rect(drawrect.left+1,drawrect.top+FCaptionHeight+2,drawrect.right-1 +1,drawrect.bottom-1 +1))
                 end;
        gmUser : begin
                 case FPanelGradientType of
                      gtVertical : VGradient(self.canvas,FPanelColorFrom,FPanelColorTo,drawrect.left+1,drawrect.top+FCaptionHeight+2,drawrect.right-1,drawrect.bottom-1);
                      gtHorizontal : HGradient(self.canvas,FPanelColorFrom,FPanelColorTo,drawrect.left+1,drawrect.top+FCaptionHeight+2,drawrect.right-1,drawrect.bottom-1);
                 end;
                 end;
        gmAuto : begin
                 case FPanelGradientType of
                      gtVertical : VGradient(self.canvas,FPanelColorFrom,brighten(FPanelColorFrom,40),drawrect.left+1,drawrect.top+FCaptionHeight+2,drawrect.right-1,drawrect.bottom-1);
                      gtHorizontal : HGradient(self.canvas,FPanelColorFrom,brighten(FPanelColorFrom,40),drawrect.left+1,drawrect.top+FCaptionHeight+2,drawrect.right-1,drawrect.bottom-1);
                 end;
                 end;
   end;
   end;
end;

procedure TSpkRollPanel.OnFinishAnimation(sender: TObject);
begin
if FHideChildren and (FRollMode=rmUnroll) then ShowComponents;
end;

procedure TSpkRollPanel.HideComponents;

var i : integer;
    PropInfo : PPropInfo;

begin
if self.controlCount>0 then
   for i:=0 to self.controlcount-1 do
       begin
       PropInfo:=GetPropInfo(self.controls[i],'visible');
       if PropInfo<>nil then
          SetOrdProp(self.controls[i],'Visible',0);
       end;
end;

procedure TSpkRollPanel.ShowComponents;

var i : integer;
    PropInfo : PPropInfo;

begin
if self.controlCount>0 then
   for i:=0 to self.controlcount-1 do
       begin
       PropInfo:=GetPropInfo(self.controls[i],'visible');
       if PropInfo<>nil then
          SetOrdProp(self.controls[i],'Visible',1);
       end;
end;

end.
