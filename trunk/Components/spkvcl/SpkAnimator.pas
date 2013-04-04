unit SpkAnimator;

interface

uses classes, controls, sysutils, math;

// Co ma byæ zmieniane w czasie
type TAnimationType = (atLeft, atTop, atWidth, atHeight);
// Kszta³t paraboli funkcji rozmiaru od czasu
     TSquareMode = (smPlus, smMinus);

type TAnimationOptions = class(TObject)
     private
     // Czas animacji w milisekundach
       FAnimationTime : integer;
     // Typ animacji
       FAnimationType : TAnimationType;
     // Czy animacja ma byæ kwadratowa czy liniowa
       FSquare : boolean;
     // Tryb animacji kwadratowej
       FSquareMode : TSquareMode;
     // Obiekt, którego rozmiar lub po³o¿enie bêdzie zmieniane
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
     // Rozmiar pocz¹tkowy i koñcowy
       FStart, FEnd : integer;
     // Wspó³czynniki potrzebne przy obliczaniu animacji kwadratowej
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
     // Metoda wywo³uj¹ca w¹tek
       procedure execute; override;
     published
     end;

type TSpkAnimator = class(TObject)
     private
     // Opcje animacji
       FOptions : TAnimationOptions;
     // Obiekt w¹tka animacyjnego
       FAnimateThread : TAnimateThread;
     // Zdarzenie po zakoñczeniu animacji
       FOnFinishAnimation : TNotifyEvent;
     protected
     // Zdarzenie zakoñczenia w¹tka
       procedure ThreadOnTerminate(sender : TObject);
     public
     // Konstruktor
       constructor create;
     // Destruktor
       destructor destroy; override;
     // Funkcja rozpoczyna animacje (gdy to mo¿liwe)
       function animate(BeginSize, EndSize : integer) : boolean;
     // Funkcja sprawdza, czy mo¿na rozpocz¹æ animacjê
       function CanAnimate : boolean;
     published
     // Opcje animacji
       property Options : TAnimationOptions read FOptions write FOptions;
     // Zdarzenie zakoñczenia animacji
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
// W przeciwnym wypadku animacja wykona siê tylko raz.
if @FOnFinishAnimation<>nil then
   FOnFinishAnimation(self);
end;

{ TAnimateThread }

constructor TAnimateThread.create(Data: TAnimationOptions; BeginSize,
  EndSize: integer; AOnTerminate : TNotifyEvent);
begin
  // Utwórz zawieszony
  inherited create(true);

  // Zainicjuj pola
  FOptions:=TAnimationOptions.create;
  self.FOptions.assign(Data);
  FStart:=BeginSize;
  FEnd:=EndSize;
  FreeOnTerminate:=true;
  self.OnTerminate:=AOnTerminate;

  // Wznów dzia³anie w¹tku
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
// Ustaw czasy rozpoczêcia i zakoñczenia animacji
BeginTime:=now;
EndTime:=now+(FOptions.AnimationTime/(24*60*60*1000));

// Jeœli u¿ytkownik za¿yczy³ sobie animacji kwadratowej, oblicz odpowiednie
// wspó³czynniki

if FOptions.Square then
   begin
   Fdelta:=(FEnd-FStart);
   Fa:=FDelta/(sqr(100));
   end;

while (now<EndTime) and not(Terminated) do
      begin
      // Obliczanie procent up³yniêtego czasu
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

// Poni¿sze linijki wynikaj¹ z faktu, ¿e w¹tek nie skoñczy siê
// najprawdopodobniej po _osi¹gniêciu_ czasu zakoñczenia animacji,
// lecz po _przekroczeniu_ go.
FSetSize:=FEnd;
Synchronize(DoSetSize);
end;

end.
