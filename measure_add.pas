unit measure_add;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ButtonPanel, MyTools, SQLiteTable3;

type

  { TMeasureAddForm }

  TMeasureAddForm = class(TForm)
   ButtonPanel1: TButtonPanel;
   MeasureLabel: TLabel;
   MeasureEdit: TEdit;
   GroupBox1: TGroupBox;
   procedure FormShow(Sender: TObject);
   procedure MeasureEditChange(Sender: TObject);
   procedure MeasureEditKeyPress(Sender: TObject; var Key: char);
   procedure OKButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  MeasureAddForm: TMeasureAddForm;

implementation

uses Main;
{$R *.lfm}

procedure TMeasureAddForm.FormShow(Sender: TObject);
var
 main_table: TSQLiteTable;
begin
 if Add_flag=false then
  begin
   // Загрузка данных
   main_table:=SQL_db.GetTable('SELECT abbr FROM izm WHERE id='+MainForm.MeasureGrid.Cells[0, MainForm.MeasureGrid.Row]+' LIMIT 1;');
   // Имя
   MeasureEdit.Text:=main_table.FieldAsString('abbr');
   Caption:='Изменение записи';
   ButtonPanel1.OKButton.Caption:='Изменить';
  end
 else
  begin
   Caption:='Добавление новой записи';
   ButtonPanel1.OKButton.Caption:='Добавить';
   MeasureEdit.Text:='';
  end;
 ButtonPanel1.OKButton.Enabled:=false;
end;

procedure TMeasureAddForm.MeasureEditChange(Sender: TObject);
begin
  if Length(MeasureEdit.Text)<1
  then ButtonPanel1.OKButton.Enabled:=false
  else ButtonPanel1.OKButton.Enabled:=true;
end;

procedure TMeasureAddForm.MeasureEditKeyPress(Sender: TObject; var Key: char);
const
 lq: char = #171;
 rq: char = #187;
var
 NumOfQuotes: integer;
begin
 //
 if Key='"' then
  begin
   // Определяем тип поля редактирования и подсчитываем количество кавычек в нём
   if (Sender is TEdit)
    then NumOfQuotes:=CntChRepet((Sender as TEdit).Text, lq)+CntChRepet((Sender as TEdit).Text, rq);

   if odd(NumOfQuotes)
    then Key:=rq
    else Key:=lq;
  end;

end;

procedure TMeasureAddForm.OKButtonClick(Sender: TObject);
var
 measure_ID: string;
begin
 ButtonPanel1.OKButton.Enabled:=false;
 // Обновление записи в БД
 SQL_db.BeginTransaction;
 // В режиме редактирования ID берём из таблицы
 if not Add_flag
  then measure_ID:=MainForm.MeasureGrid.Cells[0, MainForm.MeasureGrid.Row]
  // В режиме добавления нового пользователя - не присваиваем (его определит MySQL)
  else
   begin
    // Ищем максимальный индекс
    measure_ID:=IntToStr(SQL_db.GetMaxValue('izm', 'id')+1);
    // Вставляем новую строку (с заданными ID и категорий)
    SQL_db.ExecSQL('INSERT INTO izm (id, abbr) VALUES ("'+measure_ID+'", "")');
   end;
 // Логин
 SQL_db.ExecSQL('UPDATE izm SET abbr = "'+MeasureEdit.Text+'" WHERE id ='+measure_ID);
 SQL_db.Commit;

 // Обновление сетки в главном окне
 MainForm.GetMeasureList;
end;
end.
