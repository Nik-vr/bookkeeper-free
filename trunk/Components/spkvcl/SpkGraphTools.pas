unit SpkGraphTools;

interface

uses
    {$IFDEF MSWINDOWS}
    windows,
    {$ELSE}
    LCLIntf,
    {$ENDIF}
    graphics, classes, math, sysutils, Dialogs;

// FillRect z win32 //

procedure line(canvas : TCanvas; x1, y1, x2, y2 : integer); overload;
procedure line(canvas : TCanvas; p1, p2 : TPoint); overload;
procedure line(canvas : TCanvas; rect : TRect); overload;

procedure rectangle(canvas : TCanvas; rect : TRect); overload;
procedure rectangle(canvas : TCanvas; p1,p2 : TPoint); overload;
procedure rectangle(canvas : TCanvas; x1,y1,x2,y2 : integer); overload;

function Darken(kolor : TColor; percentage : byte) : TColor;
function Brighten(kolor : TColor; percentage : byte) : TColor;
function Shade(kol1,kol2 : TColor; percentage : byte) : TColor;

function percent(min, pos, max : integer) : byte;

// GRADIENTFILL z WIN32!!! //

procedure HGradient(canvas : TCanvas; cStart,cEnd : TColor; rect : TRect); overload;
procedure HGradient(canvas : TCanvas; cStart,cEnd : TColor; p1, p2 : TPoint); overload;
procedure HGradient(canvas : TCanvas; cStart,cEnd : TColor; x1,y1,x2,y2 : integer); overload;

procedure VGradient(canvas : TCanvas; cStart,cEnd : TColor; rect : TRect); overload;
procedure VGradient(canvas : TCanvas; cStart,cEnd : TColor; p1, p2 : TPoint); overload;
procedure VGradient(canvas : TCanvas; cStart,cEnd : TColor; x1,y1,x2,y2 : integer); overload;

procedure WheelHGradient(canvas : TCanvas; cStart, cEnd : TColor; rect : TRect); overload;
procedure WheelHGradient(canvas : TCanvas; cStart, cEnd : TColor; p1, p2 : TPoint); overload;
procedure WheelHGradient(canvas : TCanvas; cStart, cEnd : TColor; x1,y1,x2,y2 : integer); overload;

procedure Circle(canvas : TCanvas; rect : TRect); overload;
procedure Circle(canvas : TCanvas; p1, p2 : TPoint); overload;
procedure Circle(canvas : TCanvas; x1,y1,x2,y2 : integer); overload;

implementation

procedure line(canvas : TCanvas; x1, y1, x2, y2 : integer); overload;

begin
canvas.MoveTo(x1,y1);
canvas.lineto(x2,y2);
canvas.Pixels[x2,y2]:=canvas.Pen.color;
end;

procedure line(canvas : TCanvas; p1, p2 : TPoint); overload;

begin
canvas.moveto(p1.x,p1.y);
canvas.lineto(p2.x,p2.y);
canvas.Pixels[p2.x,p2.y]:=canvas.Pen.color;
end;

procedure line(canvas : TCanvas; rect : TRect); overload;

begin
canvas.moveto(rect.Left,rect.top);
canvas.lineto(rect.right,rect.bottom);
canvas.pixels[rect.right,rect.bottom]:=canvas.pen.Color;
end;

procedure rectangle(canvas : TCanvas; rect : TRect); overload;

begin
line(canvas,rect.left,rect.top,rect.right,rect.top);
line(canvas,rect.right,rect.top,rect.right,rect.bottom);
line(canvas,rect.right,rect.bottom,rect.left,rect.bottom);
line(canvas,rect.left,rect.bottom,rect.left,rect.top);
end;

procedure rectangle(canvas : TCanvas; p1,p2 : TPoint); overload;

begin
rectangle(canvas,rect(p1.x,p1.y,p2.x,p2.y));
end;

procedure rectangle(canvas : TCanvas; x1,y1,x2,y2 : integer); overload;

begin
rectangle(canvas, rect(x1,y1,x2,y2));
end;

function Darken(kolor : TColor; percentage : byte) : TColor;

var r,g,b : byte;

begin
r:=round(GetRValue(ColorToRGB(kolor))*percentage/100);
g:=round(GetGValue(ColorToRGB(kolor))*percentage/100);
b:=round(GetBValue(ColorToRGB(kolor))*percentage/100);
result:=rgb(r,g,b);
end;

function Brighten(kolor : TColor; percentage : byte) : TColor;

var r,g,b : byte;

begin
r:=round(GetRValue(ColorToRGB(kolor))+( (255-GetRValue(ColorToRGB(kolor)))*(percentage/100) ));
g:=round(GetGValue(ColorToRGB(kolor))+( (255-GetGValue(ColorToRGB(kolor)))*(percentage/100) ));
b:=round(GetBValue(ColorToRGB(kolor))+( (255-GetBValue(ColorToRGB(kolor)))*(percentage/100) ));
result:=rgb(r,g,b);
end;

function Shade(kol1,kol2 : TColor; percentage : byte) : TColor;

var r,g,b : byte;

begin
r:=round(GetRValue(ColorToRGB(kol1))+( (GetRValue(ColorToRGB(kol2))-GetRValue(ColorToRGB(kol1)))*(percentage/100) ));
g:=round(GetGValue(ColorToRGB(kol1))+( (GetGValue(ColorToRGB(kol2))-GetGValue(ColorToRGB(kol1)))*(percentage/100) ));
b:=round(GetBValue(ColorToRGB(kol1))+( (GetBValue(ColorToRGB(kol2))-GetBValue(ColorToRGB(kol1)))*(percentage/100) ));
result:=rgb(r,g,b);
end;

function percent(min, pos, max : integer) : byte;

begin
if max=min then result:=max else
   result:=round((pos-min)*100/(max-min));
end;

procedure HGradient(canvas : TCanvas; cStart,cEnd : TColor; rect : TRect); overload;

var i : integer;

begin
if rect.top<=rect.bottom then
   for i:=rect.top to rect.bottom do
       begin
       canvas.pen.color:=Shade(cStart, cEnd, percent(rect.top,i,rect.bottom));
       line(canvas,rect.left,i,rect.right,i);
       end;
end;

procedure HGradient(canvas : TCanvas; cStart,cEnd : TColor; p1, p2 : TPoint); overload;

begin
HGradient(canvas,cstart,cend,rect(p1.x,p1.y,p2.x,p2.y));
end;

procedure HGradient(canvas : TCanvas; cStart,cEnd : TColor; x1,y1,x2,y2 : integer); overload;

begin
HGradient(canvas,cstart,cend,rect(x1,y1,x2,y2));
end;


procedure VGradient(canvas : TCanvas; cStart,cEnd : TColor; rect : TRect); overload;

var i : integer;

begin
if rect.left<=rect.right then
   for i:=rect.left to rect.right do
       begin
       canvas.pen.color:=Shade(cStart, cEnd, percent(rect.left,i,rect.right));
       line(canvas,i,rect.top,i,rect.bottom);
       end;
end;

procedure VGradient(canvas : TCanvas; cStart,cEnd : TColor; p1, p2 : TPoint); overload;

begin
VGradient(canvas,cstart,cend,rect(p1.x,p1.y,p2.x,p2.y));
end;

procedure VGradient(canvas : TCanvas; cStart,cEnd : TColor; x1,y1,x2,y2 : integer); overload;

begin
VGradient(canvas,cstart,cend,rect(x1,y1,x2,y2));
end;

procedure WheelHGradient(canvas : TCanvas; cStart, cEnd : TColor; rect : TRect); overload;

begin
WheelHGradient(canvas,cStart,cEnd,rect.left,rect.top,rect.right,rect.bottom);
end;

procedure WheelHGradient(canvas : TCanvas; cStart, cEnd : TColor; p1, p2 : TPoint); overload;

begin
WheelHGradient(canvas,cStart,cEnd,p1.x,p1.y,p2.x,p2.y);
end;

procedure WheelHGradient(canvas : TCanvas; cStart, cEnd : TColor; x1,y1,x2,y2 : integer); overload;

var r : real;
    y : integer;
    x : integer;

begin
r:=(y2-y1) / 2; // div czy / ?
for y:=y1 to y2 do
    begin
    canvas.pen.color:=shade(cStart,cEnd,percent(y1,y,y2));
    x:=trunc(sqrt(sqr(r+0.2)-sqr(y1-y+r)));
    x:=trunc(((x2-x1)/(y2-y1))*x); // elipsa
    line(canvas,-x+x1+trunc(r),y,x+x1+trunc(r),y);
    end;
end;

procedure Circle(canvas : TCanvas; rect : TRect); overload;

begin
circle(canvas,rect.left,rect.top,rect.right,rect.bottom);
end;

procedure Circle(canvas : TCanvas; p1, p2 : TPoint); overload;

begin
circle(canvas,p1.x,p1.y,p2.x,p2.y);
end;

procedure Circle(canvas : TCanvas; x1,y1,x2,y2 : integer); overload;

var r : real;
    y : integer;
    x : integer;

begin
r:=(y2-y1) / 2; // div czy / ?
for y:=y1 to y2 do
    begin
    x:=trunc(sqrt(sqr(r+0.2)-sqr(y1-y+r)));
    x:=trunc(((x2-x1)/(y2-y1))*x); // elipsa
    if y in [y1,y2] then line(canvas,-x+x1+trunc(r),y,x+x1+trunc(r),y) else
       begin
       canvas.Pixels[-x+x1+trunc(r),y]:=canvas.pen.color;
       canvas.Pixels[x+x1+trunc(r),y]:=canvas.pen.color;
       end;
    end;
end;

end.
