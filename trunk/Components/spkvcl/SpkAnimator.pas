unit SpkAnimator;

interface

uses classes, controls, sysutils, math;

// Co ma by� zmieniane w czasie
type TAnimationType = (atLeft, atTop, atWidth, atHeight);
// Kszta�t paraboli funkcji rozmiaru od czasu
     TSquareMode = (smPlus, smMinus);

type TAnimationOptions = class(TObject)
     private
     // Czas animacji w milisekundach
       FAnimationTime : integer;
     // Typ animacji
       FAnimationType : TAnimationType;
     // Czy animacja ma by� kwadratowa czy liniowa
       FSquare : boolean;
     // Tryb animacji kwadratowej
       FSquareMode : TSquareMode;
     // Obiekt, kt�rego rozmiar lub po�o�enie b�dzie zmieniane
       FTarget : TControl;
     protected
     public
       constructor create;
       destructor destroy; override;
       procedure assign(source : TAnimationOptions);
     published
       property AnimationTime : integer read FAnimationTime write FAnimationTime;
       property AnimationType : TAnimationType read FAnimationType write FAnimationType;
       property Square : boolean read FSquare write FSquare;
       property SquareMode : TSquareMode read FSquareMode write FSquareMode;
       property Target : TControl read FTarget write FTarget;
     end;

type TAnimateThread = class(TThread)
     private
     // Opcje animacji
       FOptions : TAnimationOptions;
     // Rozmiar pocz�tkowy i ko�cowy
       FStart, FEnd : integer;
     // Wsp�czynniki potrzebne przy obliczaniu animacji kwadratowej
       Fa, FDelta : extended;

     // "Parametr" procedury DoSetSize
       FSetSize : integer;
     protected
     // Synchronizowana procedura nadaje obiektowi odpowiedni wymiar
       procedure DoSetSize;
     public
     // Konstruktor
       constructor create(Data : TAnimationOptions; BeginSize, EndSize : integer; AOnTerminate : TNotifyEvent);
     // Destruktor
       destructor destroy; override;
     // Metoda wywo�uj�ca w�tek
       procedure execute; override;
     published
     end;

type TSpkAnimator = class(TObject)
     private
     // Opcje animacji
       FOptions : TAnimationOptions;
     // Obiekt w�tka animacyjnego
       FAnimateThread : TAnimateThread;
     // Zdarzenie po zako�czeniu animacji
       FOnFinishAnimation : TNotifyEvent;
     protected
     // Zdarzenie zako�czenia w�tka
       procedure ThreadOnTerminate(sender : TObject);
     public
     // Konstruktor
       constructor create;
     // Destruktor
       destructor destroy; override;
     // Funkcja rozpoczyna animacje (gdy to mo�liwe)
       function animate(BeginSize, EndSize : integer) : boolean;
     // Funkcja sprawdza, czy mo�na rozpocz�� animacj�
       function CanAnimate : boolean;
     published
     // Opcje animacji
       property Options : TAnimationOptions read FOptions write FOptions;
     // Zdarzenie zako�czenia animacji
       property OnFinishAnimation : TNotifyEvent read FOnFinishAnimation write FOnFinishAnimation;
     end;

implementation

{ TAnimateOptions }

// Metoda przepisuje jeden obiekt TAnimationOptions do drugiego.
procedure TAnimationOptions.assign(source: TAnimationOptions);
begin
FAnimationTime:=source.AnimationTime;
FAnimationType:=source.AnimationType;
FSquare:=source.Square;
FSquareMode:=source.SquareMode;
FTarget:=source.Target;
end;

constructor TAnimationOptions.create;
begin
  inherited;
  FAnimationTime:=500;
  FSquare:=true;
  FSquareMode:=smPlus;
  FAnimationType:=atWidth;
end;

destructor TAnimationOptions.destroy;
begin
  inherited;
end;

{ TSpkAnimator }

function TSpkAnimator.animate(BeginSize, EndSize: integer) : boolean;
begin
if FAnimateThread<>nil then
   begin
   result:=false;
   exit
   end;
result:=true;
FAnimateThread:=TAnimateThread.create(FOptions,BeginSize,EndSize,ThreadOnTerminate);
end;

function TSpkAnimator.CanAnimate: boolean;
begin
result:=FAnimateThread=nil;
end;

constructor TSpkAnimator.create;
begin
  FOptions:=TAnimationOptions.create;
  FOnFinishAnimation:=nil;
end;

destructor TSpkAnimator.destroy;
begin
  FOptions.Free;
  if FAnimateThread<>nil then
     begin
     FAnimateThread.terminate;
     FAnimateThread.free;
     end;
  inherited;
end;

procedure TSpkAnimator.ThreadOnTerminate(sender: TObject);
begin
FAnimateThread:=nil;
// W przeciwnym wypadku animacja wykona si� tylko raz.
if @FOnFinishAnimation<>nil then
   FOnFinishAnimation(self);
end;

{ TAnimateThread }

constructor TAnimateThread.create(Data: TAnimationOptions; BeginSize,
  EndSize: integer; AOnTerminate : TNotifyEvent);
begin
  // Utw�rz zawieszony
  inherited create(true);

  // Zainicjuj pola
  FOptions:=TAnimationOptions.create;
  self.FOptions.assign(Data);
  FStart:=BeginSize;
  FEnd:=EndSize;
  FreeOnTerminate:=true;
  self.OnTerminate:=AOnTerminate;

  // Wzn�w dzia�anie w�tku
  self.Resume;
end;

destructor TAnimateThread.destroy;
begin
FOptions.free;
end;

procedure TAnimateThread.DoSetSize;
begin
case FOptions.FAnimationType of
     atLeft : self.FOptions.FTarget.Left:=FSetSize;
     atTop : self.FOptions.FTarget.Top:=FSetSize;
     atWidth : self.FOptions.FTarget.width:=FSetSize;
     atHeight : self.FOptions.FTarget.Height:=FSetSize;
end;
end;

procedure TAnimateThread.execute;

var BeginTime, EndTime : TDateTime;
    procent : integer;

begin
// Ustaw czasy rozpocz�cia i zako�czenia animacji
BeginTime:=now;
EndTime:=now+(FOptions.AnimationTime/(24*60*60*1000));

// Je�li u�ytkownik za�yczy� sobie animacji kwadratowej, oblicz odpowiednie
// wsp�czynniki

if FOptions.Square then
   begin
   Fdelta:=(FEnd-FStart);
   Fa:=FDelta/(sqr(100));
   end;

while (now<EndTime) and not(Terminated) do
      begin
      // Obliczanie procent up�yni�tego czasu
      procent:=trunc((100*(now-BeginTime))/(EndTime-BeginTime));
      if not(FOptions.Square) then
         begin
         // Animacja liniowa
         FSetSize:=FStart+trunc((procent*(FEnd-FStart))/100);
         end else
             begin
             // Animacja kwadratowa
             if FOptions.FSquareMode=smPlus then
                begin
                // Animacja y=x^2
                FSetSize:=FStart+trunc(Fa*sqr(procent));
                end else
                    begin
                    // Animacja y=-x^2
                    FSetSize:=FStart+trunc((-Fa)*sqr(procent-100)+FDelta);
                    end;
             end;
      Synchronize(DoSetSize);
      end;

// Poni�sze linijki wynikaj� z faktu, �e w�tek nie sko�czy si�
// najprawdopodobniej po _osi�gni�ciu_ czasu zako�czenia animacji,
// lecz po _przekroczeniu_ go.
FSetSize:=FEnd;
Synchronize(DoSetSize);
end;

end.
