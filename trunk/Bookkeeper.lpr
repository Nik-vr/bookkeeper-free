program Bookkeeper;

uses
  Interfaces, Forms, main, splash, UniqueInstanceRaw;

{$R *.res}

begin
  // Проверяем, нет ли ранее запущенных копий "Счетовода"
  // если нет - запускаем
  if not InstanceRunning('Bookkeeper') then
   begin
    Application.Initialize;
    Application.CreateForm(TSplashForm, SplashForm);
    Application.Run;
   end;
end.
