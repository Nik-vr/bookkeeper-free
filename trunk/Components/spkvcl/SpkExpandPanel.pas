unit SpkExpandPanel;

interface

uses
    {$IFDEF MSWINDOWS}
    windows,
    {$ELSE}
    LCLIntf,Messages,LCLType,
    {$ENDIF}
     classes, forms, LMessages, stdctrls, extctrls, sysutils,
     SpkGraphTools, graphics, controls, TypInfo, dialogs, math,
     SpkAnimator;

type TRollPlace = (rpLeft, rpTop, rpRight, rpBottom, rpNone);
     TPanelBorder = (pbUp, pbDown, pbFrame);
     TExpandState = (esExpanded, esCollapsed);
     TResizeState = (rsNormal, rsPressed, rsResize);

type TSpkExpandPanel = class(TPanel)
     private
       FRollPlace : TRollPlace;
       FPanelBorder : TPanelBorder;
       FExpandState : TExpandState;
       FHighlight : boolean;
       FExpandSize : integer;
       FResizeState : TResizeState;
       FHideChildren : boolean;
       FAllowResize : boolean;
       FConstraints : TSizeConstraints;
       FAnimate : boolean;
       FAnimator : TSpkAnimator;

       FOnCollapsed : TNotifyEvent;
       FOnExpanded : TNotifyEvent;

       FMouseDelta : integer;

     protected
       procedure paint; override;
       procedure draw_arrow(highlight : boolean);

       procedure SetPanelBorder(value : TPanelBorder);
       procedure SetExpandState(const Value: TExpandState);
       procedure SetAlign(value : TAlign);
       function GetAlign : TAlign;

       procedure MyOnMouseMove(var msg : TMessage); {$IFDEF MSWINDOWS} message WM_MOUSEMOVE {$ELSE} message LM_MOUSEMOVE {$ENDIF};
       procedure MyOnLMouseButtonUp(var msg : TMessage); {$IFDEF MSWINDOWS} message WM_LBUTTONUP {$ELSE} message LM_LBUTTONUP {$ENDIF};
       procedure MyOnLMouseButtonDown(var msg : TMessage); {$IFDEF MSWINDOWS} message WM_LBUTTONDOWN {$ELSE} message LM_LBUTTONDOWN {$ENDIF};
       procedure MyOnMouseLeave(var msg : TMessage); message CM_MouseLeave;

       procedure OnFinishAnimation(sender : TObject);

       procedure HideComponents;
       procedure ShowComponents;

     public
       constructor create(AOwner : TComponent); override;
       destructor destroy; override;
       procedure AlignControls( AControl : TControl; var Rect : TRect); override;
     published
       property PanelBorder : TPanelBorder read FPanelBorder write SetPanelBorder;
       property Align : TAlign read GetAlign write SetAlign;
       property HideChildren : boolean read FHideChildren write FHideChildren;
       property AllowResize : boolean read FAllowResize write FAllowResize;
       property Constraints : TSizeConstraints read FConstraints write FConstraints;
       property Animate : boolean read FAnimate write FAnimate;
       property ExpandState : TExpandState read FEXpandState write SetExpandState;
       property OnExpanded : TNotifyEvent read FOnExpanded write FOnExpanded;
       property OnCollapsed : TNotifyEvent read FOnCollapsed write FOnCollapsed;
     end;

procedure Register;

implementation

procedure Register;

begin
RegisterComponents('SpookSoft',[TSpkExpandPanel]);
end;

{ TSpkExpandPanel }

procedure TSpkExpandPanel.paint;

begin
// Ramka
with self.canvas do
     begin
     brush.color:=self.color;
     FillRect(0,0,width,height);

     case FPanelBorder of
          pbUp : begin
                 pen.color:=clBtnShadow;
                 moveto(0,height-1);
                 lineto(width,height-1);
                 moveto(width-1,0);
                 lineto(width-1,height);

                 pen.color:=clBtnHighlight;
                 moveto(0,0);
                 lineto(width,0);
                 moveto(0,0);
                 lineto(0,height);
                 end;
          pbDown : begin
                   pen.color:=clBtnShadow;
                   moveto(0,0);
                   lineto(width,0);
                   moveto(0,0);
                   lineto(0,height);

                   pen.color:=clBtnHighlight;
                   moveto(0,height-1);
                   lineto(width,height-1);
                   moveto(width-1,0);
                   lineto(width-1,height);
                   end;
          pbFrame : begin
                   pen.color:=clBtnShadow;
                   moveto(0,0);
                   lineto(width,0);
                   moveto(0,0);
                   lineto(0,height);

                   pen.color:=clBtnHighlight;
                   moveto(0,height-1);
                   lineto(width,height-1);
                   moveto(width-1,0);
                   lineto(width-1,height);

                   pen.color:=clBtnHighlight;
                   moveto(1,1);
                   lineto(width-1,1);
                   moveto(1,1);
                   lineto(1,height-1);

                   pen.color:=clBtnShadow;
                   moveto(1,height-2);
                   lineto(width-1,height-2);
                   moveto(width-2,1);
                   lineto(width-2,height-1);
                   end;
     end;

     draw_arrow(FHighlight);
     end;
end;

procedure TSpkExpandPanel.draw_arrow(highlight : boolean);

begin
with self.canvas do
     begin
     if highlight then
        begin
        brush.color:=clHighlight;
        pen.color:=self.color;
        end else
            begin
            brush.color:=self.color;
            pen.color:=clHighlight;
            end;

     // Przycisk do zwijania
     case FRollPlace of
          rpLeft : begin
                   FillRect(2,2,7,height-2);

                   if FExpandState = esExpanded then
                      begin
                      moveto(3,(height div 2)-2);
                      lineto(3,(height div 2)+3);

                      moveto(4,(height div 2)-1);
                      lineto(4,(height div 2)+2);

                      moveto(5,(height div 2));
                      lineto(5,(height div 2)-1);
                      end else
                          begin
                          moveto(5,(height div 2)-2);
                          lineto(5,(height div 2)+3);

                          moveto(4,(height div 2)-1);
                          lineto(4,(height div 2)+2);

                          moveto(3,(height div 2));
                          lineto(3,(height div 2)-1);
                          end;
                   end;
          rpRight : begin
                    FillRect(width-7,2,width-2,height-2);

                    if FExpandState = esExpanded then
                       begin
                       moveto(width-4,(height div 2)-2);
                       lineto(width-4,(height div 2)+3);

                       moveto(width-5,(height div 2)-1);
                       lineto(width-5,(height div 2)+2);

                       moveto(width-6,(height div 2));
                       lineto(width-6,(height div 2)-1);
                       end else
                           begin
                           moveto(width-6,(height div 2)-2);
                           lineto(width-6,(height div 2)+3);

                           moveto(width-5,(height div 2)-1);
                           lineto(width-5,(height div 2)+2);

                           moveto(width-4,(height div 2));
                           lineto(width-4,(height div 2)-1);
                           end;
                    end;
          rpTop : begin
                  Fillrect(2,2,width-2,7);

                  if FExpandState = esExpanded then
                     begin
                     moveto((width div 2)-2,3);
                     lineto((width div 2)+3,3);

                     moveto((width div 2)-1,4);
                     lineto((width div 2)+2,4);

                     moveto((width div 2),5);
                     lineto((width div 2)+1,5);
                     end else
                         begin
                         moveto((width div 2)-2,5);
                         lineto((width div 2)+3,5);

                         moveto((width div 2)-1,4);
                         lineto((width div 2)+2,4);

                         moveto((width div 2),3);
                         lineto((width div 2)+1,3);
                         end;
                  end;
          rpBottom : begin
                     Fillrect(2,height-7,width-2,height-2);

                     if FExpandState = esExpanded then
                        begin
                        moveto((width div 2)-2,height-4);
                        lineto((width div 2)+3,height-4);

                        moveto((width div 2)-1,height-5);
                        lineto((width div 2)+2,height-5);

                        moveto((width div 2),height-6);
                        lineto((width div 2)+1,height-6);
                        end else
                            begin
                            moveto((width div 2)-2,height-6);
                            lineto((width div 2)+3,height-6);

                            moveto((width div 2)-1,height-5);
                            lineto((width div 2)+2,height-5);

                            moveto((width div 2),height-4);
                            lineto((width div 2)+1,height-4);
                            end;

                     end;
     end;
     end;
end;

procedure TSpkExpandPanel.SetPanelBorder(value : TPanelBorder);

begin
FPanelBorder:=value;
refresh;
end;

procedure TSpkExpandPanel.SetAlign(value : TAlign);

var i : integer;
    rect : TRect;

begin
inherited Align:=value;
case value of
     alLeft : begin
              FRollPlace:=rpRight;
              FAnimator.Options.AnimationType:=atWidth;
              end;
     alRight : begin
               FRollPlace:=rpLeft;
               FAnimator.Options.AnimationType:=atWidth;
               end;
     alTop : begin
             FRollPlace:=rpBottom;
             FAnimator.Options.AnimationType:=atHeight;
             end;
     alBottom : begin
                FRollPlace:=rpTop;
                FAnimator.Options.AnimationType:=atHeight;
                end;
else
     FRollPlace:=rpNone;
end;

if self.controlcount>0 then
   for i:=0 to self.controlcount-1 do
       begin
       rect:=self.ClientRect;
       self.AlignControls(self.controls[i],rect);
       end;
end;

function TSpkExpandPanel.GetAlign : TAlign;

begin
result:=inherited Align;
end;

procedure TSpkExpandPanel.MyOnMouseMove(var msg : TMessage);

var MouseOver : boolean;
    x,y : integer;
    lmb : boolean;
    w,h : integer;

begin
inherited;

x:=LoWord(msg.LParam);
y:=HiWord(msg.LParam);
lmb:=(msg.WParam and MK_LBUTTON<>0);

// Hottrack - jeœli mysz jest nad strza³k¹, podœwietl j¹
if FResizeState in [rsNormal, rsPressed, rsResize] then
   begin
   MouseOver:=false;
   case FRollPlace of
        rpLeft : begin
                 if (x>=2) and (x<=6) and
                    (y>=2) and (y<=height-3) then MouseOver:=true;
                 end;
        rpTop : begin
                if (x>=2) and (x<=width-3) and
                   (y>=2) and (y<=6) then MouseOver:=true;
                end;
        rpRight : begin
                  if (x>=width-7) and (x<=width-3) and
                     (y>=2) and (y<=height-3) then MouseOver:=true;
                  end;
        rpBottom : begin
                   if (x>=2) and (x<=width-3) and
                      (y>=height-7) and (y<=height-3) then MouseOver:=true;
                   end;
   end;
   if MouseOver<>FHighlight then
      begin
      FHighlight:=MouseOver;
      draw_arrow(FHighlight);
      end;
   end;

if (FResizeState=rsPressed) and (FExpandState=esExpanded) and (FAllowResize) and (FAnimator.CanAnimate) then
   begin
   // W³aœnie rozpoczyna siê resize.
   case self.Align of
        alLeft : begin
                 FMouseDelta:=mouse.cursorpos.X-self.width;
                 end;
        alRight : begin
                  FMouseDelta:=mouse.cursorpos.X+self.width;
                  end;
        alTop : begin
                FMouseDelta:=mouse.cursorpos.Y-self.height;
                end;
        alBottom : begin
                   FMouseDelta:=mouse.cursorpos.Y+self.height;
                   end;
   end;
   FResizeState:=rsResize;
   end;

if FResizeState=rsResize then
   begin
   // Trwa resize.
   w:=self.width;
   h:=self.height;

   case self.Align of
        alLeft : begin
                 w:=mouse.cursorpos.x-FMouseDelta;
                 end;
        alRight : begin
                  w:=FMouseDelta-mouse.cursorpos.X;
                  end;
        alTop : begin
                h:=mouse.cursorpos.y-FMouseDelta;
                end;
        alBottom : begin
                   h:=FMouseDelta-mouse.cursorpos.y;
                   end;
   end;

   if FConstraints.MinWidth<>0 then
      w:=max(FConstraints.MinWidth, w);
   if FConstraints.MinHeight<>0 then
      h:=max(FConstraints.MinHeight, h);
   if FConstraints.MaxWidth<>0 then
      w:=min(FConstraints.MaxWidth, w);
   if FConstraints.MaxHeight<>0 then
      h:=min(FConstraints.MaxHeight, h);

   self.width:=w;
   self.height:=h;
   self.refresh;
   Application.ProcessMessages;
   end;
end;

procedure TSpkExpandPanel.MyOnLMouseButtonUp(var msg : TMessage);

var x,y,i : integer;

begin
inherited;

x:=LoWord(msg.LParam);
y:=HiWord(msg.LParam);

if (FResizeState=rsPressed) and (FAnimator.CanAnimate) then
   begin
   case FRollPlace of
        rpLeft : begin
                 if (x>=2) and (x<=6) and
                    (y>=2) and (y<=height-3) then
                    begin
                    if FExpandState=esExpanded then
                       begin
                       FExpandSize:=self.Width;
                       FExpandState:=esCollapsed;
                       if FHideChildren then HideComponents;
                       if FAnimate then
                          FAnimator.animate(self.width,9) else
                          begin
                          self.width:=9;
                          if @FOnCollapsed<>nil then FOnCollapsed(self);
                          end;
                       end else
                           begin
                           if FAnimate then FAnimator.animate(self.width,FExpandSize) else
                              begin
                              self.width:=FExpandSize;
                              if FHideChildren then ShowComponents;
                              if @FOnExpanded<>nil then FOnExpanded(self);
                              end;
                           FExpandState:=esExpanded;
                           end;
                    end;
                 end;
        rpTop : begin
                if (x>=2) and (x<=width-3) and
                   (y>=2) and (y<=6) then
                   begin
                   if FExpandState=esExpanded then
                      begin
                      FExpandSize:=self.Height;
                      FExpandState:=esCollapsed;
                      if FHideChildren then HideComponents;
                      if FAnimate then FAnimator.animate(self.height,9) else
                         begin
                         self.height:=9;
                         if @FOnCollapsed<>nil then FOnCollapsed(self);
                         end;
                      end else
                          begin
                          if FAnimate then FAnimator.animate(self.height,FExpandSize) else
                             begin
                             self.height:=FExpandSize;
                             if FHideChildren then ShowComponents;
                             if @FOnExpanded<>nil then FOnExpanded(self);
                             end;
                          FExpandState:=esExpanded;
                          end;
                   end;
                end;
        rpRight : begin
                  if (x>=width-7) and (x<=width-3) and
                     (y>=2) and (y<=height-3) then
                     begin
                     if FExpandState=esExpanded then
                        begin
                        FExpandSize:=self.Width;
                        FExpandState:=esCollapsed;
                        if FHideChildren then HideComponents;
                        if FAnimate then FAnimator.animate(self.width,9) else
                           begin
                           self.width:=9;
                           if @FOnCollapsed<>nil then FOnCollapsed(self);
                           end;
                        end else
                            begin
                            if FAnimate then FAnimator.animate(self.width,FExpandSize) else
                               begin
                               self.width:=FExpandSize;
                               if FHideChildren then ShowComponents;
                               if @FOnExpanded<>nil then FOnExpanded(self);
                               end;
                            FExpandState:=esExpanded;
                            end;
                     end;
                  end;
        rpBottom : begin
                   if (x>=2) and (x<=width-3) and
                      (y>=height-7) and (y<=height-3) then
                      begin
                      if FExpandState=esExpanded then
                         begin
                         FExpandSize:=self.Height;
                         FExpandState:=esCollapsed;
                         if FHideChildren then HideComponents;
                         if FAnimate then FAnimator.animate(self.height,9) else
                            begin
                            self.height:=9;
                            if @FOnCollapsed<>nil then FOnCollapsed(self);
                            end;
                         end else
                             begin
                             if FAnimate then FAnimator.animate(self.height,FExpandSize) else
                                begin
                                self.height:=FExpandSize;
                                if FHideChildren then ShowComponents;
                                if @FOnExpanded<>nil then FOnExpanded(self);
                                end;
                             FExpandState:=esExpanded;
                             end;
                      end;
                   end;
   end;
   end;

FResizeState:=rsNormal;
if self.Cursor<>crDefault then self.cursor:=crDefault;
end;

procedure TSpkExpandPanel.MyOnLMouseButtonDown(var msg : TMessage);

var x,y : integer;

begin
inherited;
x:=LoWord(msg.LParam);
y:=HiWord(msg.LParam);

if (FResizeState=rsNormal) and (FAnimator.CanAnimate) then
   begin
   case FRollPlace of
        rpLeft : begin
                 if (x>=2) and (x<=6) and
                    (y>=2) and (y<=height-3) then
                    FResizeState:=rsPressed;
                 end;
        rpTop : begin
                if (x>=2) and (x<=width-3) and
                   (y>=2) and (y<=6) then
                   FResizeState:=rsPressed;
                end;
        rpRight : begin
                  if (x>=width-7) and (x<=width-3) and
                     (y>=2) and (y<=height-3) then
                     FResizeState:=rsPressed;
                  end;
        rpBottom : begin
                   if (x>=2) and (x<=width-3) and
                      (y>=height-7) and (y<=height-3) then
                      FResizeState:=rsPressed;
                   end;
   end;
   end;
end;

procedure TSpkExpandPanel.MyOnMouseLeave(var msg : TMessage);

begin
inherited;

if FResizeState=rsNormal then
   begin
   FHighlight:=false;
   draw_arrow(FHighlight);
   end;
end;

procedure TSpkExpandPanel.HideComponents;

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

procedure TSpkExpandPanel.ShowComponents;

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

constructor TSpkExpandPanel.create(AOwner : TComponent);

begin
  inherited create(AOwner);

  FRollPlace:=rpLeft;
  FPanelBorder:=pbFrame;
  FExpandState:=esExpanded;
  DoubleBuffered:=true;
  FHighlight:=false;
  FHideChildren:=true;
  FAllowResize:=true;
  FConstraints:=TSizeConstraints.Create(self);
  FAnimator:=TSpkAnimator.create;
  FOnExpanded:=nil;
  FOnCollapsed:=nil;

  with FAnimator.Options do
       begin
       AnimationTime:=250;
       AnimationType:=atWidth;
       Square:=true;
       SquareMode:=smMinus;
       Target:=self;
       end;
  FAnimator.OnFinishAnimation:=self.OnFinishAnimation;

  case inherited Align of
       alLeft : FRollPlace:=rpRight;
       alRight : FRollPlace:=rpLeft;
       alTop : FRollPlace:=rpBottom;
       alBottom : FRollPlace:=rpTop;
  else
       FRollPlace:=rpNone;
  end;

end;

destructor TSpkExpandPanel.destroy;

begin
  FConstraints.Free;
  FAnimator.Free;
  inherited destroy;
end;

procedure TSpkExpandPanel.AlignControls( AControl : TControl; var Rect : TRect);
begin

case FRollPlace of
     rpLeft : with Rect do begin
                           Top := Top + 2;
                           Bottom := Bottom - 2;
                           Left := Left + 8;
                           Right := Right - 2;
                           end;
     rpRight : with Rect do begin
                            Top := Top + 2;
                            Bottom := Bottom - 2;
                            Left := Left + 2;
                            Right := Right - 8;
                            end;
     rpTop : with Rect do begin
                          Top := Top + 8;
                          Bottom := Bottom - 2;
                          Left := Left + 2;
                          Right := Right - 2;
                          end;
     rpBottom : with Rect do begin
                             Top := Top + 2;
                             Bottom := Bottom - 8;
                             Left := Left + 2;
                             Right := Right - 2;
                             end;
end;

  inherited AlignControls( AControl, Rect );
end;

procedure TSpkExpandPanel.OnFinishAnimation(sender: TObject);
begin
if (FExpandState=esExpanded) and (FHideChildren) then ShowComponents;
if (FExpandState=esExpanded) and (@FOnExpanded<>nil) then FOnExpanded(self);
if (FExpandState=esCollapsed) and (@FOnCollapsed<>nil) then FOnCollapsed(self);
end;

procedure TSpkExpandPanel.SetExpandState(const Value: TExpandState);
begin
if Value<>FExpandState then
   begin
   if align in [alTop, alBottom] then
      if Value=esCollapsed then
         begin
         FExpandSize:=self.Height;
         FExpandState:=Value;
         if FHideChildren then HideComponents;
         if FAnimate then FAnimator.animate(self.height,9) else
            begin
            self.height:=9;
            if @FOnCollapsed<>nil then FOnCollapsed(self);
            end;
         end else
             begin
             if FAnimate then FAnimator.animate(self.height,FExpandSize) else
                begin
                self.height:=FExpandSize;
                if FHideChildren then ShowComponents;
                if @FOnExpanded<>nil then FOnExpanded(self);
                end;
             FExpandState:=Value;
             end;
   if align in [alLeft, alRight] then
      if Value=esCollapsed then
         begin
         FExpandSize:=self.Width;
         FExpandState:=Value;
         if FHideChildren then HideComponents;
         if FAnimate then FAnimator.animate(self.width,9) else
            begin
            self.width:=9;
            if @FOnCollapsed<>nil then FOnCollapsed(self);
            end;
         end else
             begin
             if FAnimate then FAnimator.animate(self.width,FExpandSize) else
                begin
                self.width:=FExpandSize;
                if FHideChildren then ShowComponents;
                if @FOnExpanded<>nil then FOnExpanded(self);
                end;
             FExpandState:=Value;
             end;
   end;
end;

end.
