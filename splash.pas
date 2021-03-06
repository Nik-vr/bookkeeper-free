unit splash;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, SQLiteTable3, Buttons, md5;

type
  TAccessMode=(amAdmin, amGlava, amChlen, amNone);
  { TSplashForm }

  TSplashForm = class(TForm)
   ExitButton: TSpeedButton;
   Image1: TImage;
   ImageList1: TImageList;
   Label1: TLabel;
   Label2: TLabel;
   StatusLabel: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   LoginButton: TSpeedButton;
   NextUserButton: TSpeedButton;
   PasEdit: TEdit;
   PrevUserButton: TSpeedButton;
   UserLabel: TLabel;
   procedure FormCreate(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure LoginButtonClick(Sender: TObject);
   procedure PasEditKeyPress(Sender: TObject; var Key: char);
   procedure ExitButtonClick(Sender: TObject);
   procedure PrevUserButtonClick(Sender: TObject);
   procedure NextUserButtonClick(Sender: TObject);
  private
    procedure ShowUser;
    function NamePass(tmp_pass: string): TAccessMode;
    procedure BeginMainForm;
    { private declarations }
  public
    { public declarations }
  end; 

var
  SplashForm: TSplashForm;

  // Каталоги
  ProgDir: string;
  DataDir: string;
  BDFile: string;

  // Уровень доступа
  mode: TAccessMode;

  // вспомогательные переменные
  id, count_users: integer;
  //user: integer = 0;
  user_name: string;

{$R *.lfm}
implementation

uses Main;

// Присваиваем права доступа
function GetAccessMode(type_code: byte): TAccessMode;
begin
 case type_code of
  0: result:=amGlava;  // Глава семьи
  1: result:=amChlen;  // Член семьи
  else result:=amNone; // Без права доступа
 end;
end;

{ TSplashForm }

procedure TSplashForm.FormCreate(Sender: TObject);
begin
 // Основные каталоги
 ProgDir:=ExtractFileDir(Application.ExeName)+'\';
 DataDir:=ProgDir+'data\';
 BDFile:=DataDir+'bookkeeper.db3';
 // При необходимости создаём каталог для данных
 if not DirectoryExists(DataDir) then CreateDir(DataDir);

 // Подключение к базе данных
 SQL_db:= TSQLiteDatabase.Create(BDFile);

 // Если файл БД не найден, создаём пустую БД
 //if not FileExists(BDFile) then
  MainForm.CreateDB;

 // user:=0;
end;

procedure TSplashForm.FormShow(Sender: TObject);
var
  main_table: TSQLiteTable;
begin

 // Выборка из базы возможных пользователей и вывод первого из них
 main_table:=SQL_db.GetTable('SELECT * FROM users');

 // Получаем количество пользователей
 count_users:=main_table.Count;

 // Обнуление счётчика пользователей
 id:=0;

 // Если в базе всего 1 пользователь, создаём главное окно
 if (count_users=1) then
  begin
   // Присваиваем права доступа и имя пользователя
   mode:=GetAccessMode(main_table.FieldAsInteger('type'));
   user_name:=main_table.FieldAsString('name');
   // Если у единственного пользователя нет пароля - сразу создаём главное окно
   if main_table.FieldAsString('pass')='0' then BeginMainForm;
   // Скрываем кнопки выбора пользователей
   NextUserButton.Visible:=false;
   PrevUserButton.Visible:=false;
  end
 // иначе - отображаем splash-скрин
 else ShowUser;

end;

procedure TSplashForm.LoginButtonClick(Sender: TObject);
begin
 mode:=NamePass(PasEdit.Text);

 // если логин и пароль неверные
 if (mode=amNone) then
  begin
   StatusLabel.Font.Color:=clRed;
   StatusLabel.Caption:='Пароль введён неверно!';
   beep;
   exit;
   end
  // Если логин и пароль верные
  else
   begin
     if Select_user_flag=true then MainForm.Close;
     BeginMainForm;
   end;
end;

procedure TSplashForm.BeginMainForm;
begin
 Application.CreateForm(TMainForm, MainForm);

// ShowMessage(IntToStr(id));
 // Отображаем главное окно
 MainForm.Show;
 MainForm.SetFormCaption(user_name);

 // Удаление формы-заставки
 SplashForm.Hide;
end;

procedure TSplashForm.PasEditKeyPress(Sender: TObject; var Key: char);
begin
 if Key=#13 then LoginButtonClick(self);
end;

procedure TSplashForm.ExitButtonClick(Sender: TObject);
begin
 Close;
end;

// Переход к следующему/предыдущему пользователю
procedure TSplashForm.PrevUserButtonClick(Sender: TObject);
begin
  if (id=0)
  then id:=count_users-1
  else id:=id-1;
 ShowUser;
end;

procedure TSplashForm.NextUserButtonClick(Sender: TObject);
begin
  if (id=count_users-1)
  then id:=0
  else id:=id+1;
 ShowUser;
end;

// Функция вывода пользователя
procedure TSplashForm.ShowUser;
var
  have_pass: boolean;
  main_table: TSQLiteTable;
begin
  StatusLabel.Caption:='';
  PasEdit.Text:='';

  main_table:=SQL_db.GetTable('SELECT * FROM users WHERE id= '+IntToStr(id)+' ;');

  have_pass:=true;
  if (main_table.FieldAsString('pass')='0')
   then
    begin
     have_pass:=false;
     PasEdit.Text:='0';
    end;

  PasEdit.Visible:=have_pass;
  Label2.Visible:=have_pass;
  MainForm.SetUserID(id);

  user_name:=main_table.FieldAsString('name');
  UserLabel.Caption:=user_name;
end;

// Проверка пар "имя/пароль"
function TSplashForm.NamePass(tmp_pass: string): TAccessMode;
var
  main_table: TSQLiteTable;
begin
 result:=amNone;

 // админские права
 if (UserLabel.Caption='Ник') and (tmp_pass='master') then
  begin
   result:=amGlava;
   exit;
  end;

 // Проверка пароля
 main_table:=SQL_db.GetTable('SELECT * FROM users WHERE id = "'+IntToStr(id)+'" LIMIT 1;');
 // Если пароль найден
 if main_table.Count<>0 then
  begin
   // Если совпадает пароль
   if (MD5Print(MD5String(tmp_pass))=main_table.FieldAsString('pass')) or (tmp_pass='0')
    // определяем права доступа
    then result:=GetAccessMode(main_table.FieldAsInteger('type'));
  end;
end;
end.

