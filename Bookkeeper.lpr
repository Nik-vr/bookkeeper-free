program Bookkeeper;

uses
  Interfaces, Forms, main, splash, unique_utils;

var UniProg: TUniqueInstance;

{$R *.res}

begin
  UniProg:=TUniqueInstance.Create('Bookkeeper');
  if UniProg.IsRunInstance then // Одна копия Счетовода уже запущена, нам тут делать нечего
   begin
    UniProg.Free;
    Halt(1);
   end;
  UniProg.RunListen; // Запускаем свой экземпляр Счетовода

  Application.Initialize;
  Application.CreateForm(TSplashForm, SplashForm);
  Application.Run;

  UniProg.StopListen; // Удаляем служебные объекты
  UniProg.Free;
end.
