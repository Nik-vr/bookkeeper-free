unit doh_add; 

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  Buttons, StdCtrls, ZVDateTimePicker, CurrencyEdit, SQLiteTable3, Windows,
  cur_trans, splash, types, MyTools;

type

  { TAddDohForm }

  TAddDohForm = class(TForm)
   ButtonPanel1: TButtonPanel;
   SumEdit: TCurrencyEdit;
   MemoEdit: TEdit;
   Label1: TLabel;
   Label5: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   CatBox: TComboBox;
   BillBox: TComboBox;
   GroupBox1: TGroupBox;
   DohDateTimePicker: TZVDateTimePicker;
   procedure BillBoxDrawItem(Control: TWinControl; Index: Integer;
     ARect: TRect; State: TOwnerDrawState);
   procedure CatBoxDrawItem(Control: TWinControl; Index: Integer; ARect: TRect;
     State: TOwnerDrawState);
   procedure FormShow(Sender: TObject);
   procedure MemoEditKeyPress(Sender: TObject; var Key: char);
   procedure OKButtonClick(Sender: TObject);
   procedure SumEditChange(Sender: TObject);
  private
    procedure CreateNewDohod;
    procedure LoadDohod(id: integer);
    procedure SaveDohod;
    { private declarations }
  public
   procedure BillBoxDraw(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
   procedure LoadBillsList(xForm: TForm);
   procedure LoadCategoryList(xTable: string; xForm: TForm);
  end;

var
  AddDohForm: TAddDohForm;
  old_sum: real;

implementation

uses Main;

{$R *.lfm}

{ TAddDohForm }

// Заполнение списка категорий
procedure TAddDohForm.LoadCategoryList(xTable: string; xForm: TForm);
var
 main_table: TSQLiteTable;
 temp_table: TSQLiteTable;
 i,j: integer;
begin
 // Очиска списка
 (xForm.FindComponent('CatBox') as TComboBox).Clear;

 // Выборка из таблицы категорий
 main_table:=SQL_db.GetTable('SELECT * FROM '+xTable+' WHERE (id!=0) and (parent=-1)');

 // Проход по списку пользователей
 for i:=0 to main_table.Count-1 do
  begin
   // Добавляем название категории в список (+ привязываем ID категории для служебного пользования)
   (xForm.FindComponent('CatBox') as TComboBox).AddItem(main_table.FieldAsString('name'), TObject(main_table.FieldAsInteger('id')));

   // Ищем подкатегории для текущей родильской категории
   temp_table:=SQL_db.GetTable('SELECT * FROM '+xTable+' WHERE parent='+main_table.FieldAsString('id'));
   // Проход по списку подкатегорий
   for j:=0 to temp_table.Count-1 do
    begin
     // Добавляем название подкатегории в список (+ привязываем ID подкатегории для служебного пользования)
     (xForm.FindComponent('CatBox') as TComboBox).AddItem(temp_table.FieldAsString('name'), TObject(temp_table.FieldAsInteger('id')));
     temp_table.Next;
    end;
   // переходим к следующей категории
   main_table.Next;
  end;

 // Значение по умолчанию (категория не выбрана)
 (xForm.FindComponent('CatBox') as TComboBox).ItemIndex:=-1;
end;


// Заполнение списка счетов
procedure TAddDohForm.LoadBillsList(xForm: TForm);
var
 main_table: TSQLiteTable;
 i: integer;
 capt: string;
begin
 // Очистка списка
 (xForm.FindComponent('BillBox') as TComboBox).Clear;

 // Выборка из таблицы счетов
 if mode=amChlen
  then main_table:=SQL_db.GetTable('SELECT * FROM bill WHERE user='+IntToStr(user_id))
  else main_table:=SQL_db.GetTable('SELECT * FROM bill');

 // Проход по списку пользователей
 for i:=0 to main_table.Count-1 do
  begin
   // Добавляем в список название счёта и валюту (+ ID счёта для служебнгго пользования)
   capt:=main_table.FieldAsString('name')+'|'+TransCurForm.SelectValut(main_table.FieldAsInteger('id'));
   (xForm.FindComponent('BillBox') as TComboBox).AddItem(capt, TObject(main_table.FieldAsInteger('id')));
   // Переходим к следующему счёту
   main_table.Next;
  end;

 // Значение по умолчанию (счёт не выбран)
 (xForm.FindComponent('BillBox') as TComboBox).ItemIndex:=-1;
end;


// Отображение окна
procedure TAddDohForm.FormShow(Sender: TObject);
begin
 DohDateTimePicker.MaxDate:=Date;

 // Загружаем списки категорий и счетов
 LoadCategoryList('cat_doh', AddDohForm);
 LoadBillsList(AddDohForm);

 // Выбор режима (редактирование/добавление дохода)
 if Add_flag=false
  // загружаем данные о доходе
  then LoadDohod((MainForm.MainGrid.Objects[0, MainForm.ActRow] as TItemData).ID)
  // Готовим окно к добавлению нового дохода
  else CreateNewDohod;

 // Включаем/выключаем служебные кнопки
 SumEditChange(self);
end;


// Подготовка окна к добавлению нового дохода
procedure TAddDohForm.CreateNewDohod;
begin
 // Заголовоко окна
 Caption:='Добавление новой записи';
 // Очистка полей
 MemoEdit.Text:='';
 DohDateTimePicker.Date:=Date;
 SumEdit.Value:=0;
end;


// Загрузка данных о существующем доходе
procedure TAddDohForm.LoadDohod(id: integer);
var
 main_table: TSQLiteTable;
 i: integer;
begin
 // Выборка данных из БД
 main_table:=SQL_db.GetTable('SELECT * FROM dohod WHERE id='+IntToStr(id));

 // Если данных для указанного ID нет - закрывам окно (вероятно, передан неверный ID)
 if main_table.Count=0 then
  begin
   AddDohForm.Close;
   exit;
  end;

 // Заголовок окна
 Caption:='Изменение записи';

 // Выбираем требуемый пункт в списке категорий
 for i:=0 to CatBox.Items.Count-1 do
  if (Integer(CatBox.Items.Objects[i])=main_table.FieldAsInteger('cat')) then
   begin
    CatBox.ItemIndex:=i;
    break;
   end;

 // Выбираем требуемый пункт в списке счетов
 for i:=0 to BillBox.Items.Count-1 do
  if (Integer(BillBox.Items.Objects[i])=main_table.FieldAsInteger('bill')) then
   begin
    BillBox.ItemIndex:=i;
    break;
   end;

 // Загружаем прочие данные
 MemoEdit.Text:=main_table.FieldAsString('memo');
 DohDateTimePicker.Date:=main_table.FieldAsDateTime('date');
 old_sum:=StrToCurr(main_table.FieldAsString('sum'));
 SumEdit.Text:=main_table.FieldAsString('sum');
 ButtonPanel1.OKButton.Enabled:=false;
end;


// Фильтр ввода для поля "Примечание"
procedure TAddDohForm.MemoEditKeyPress(Sender: TObject; var Key: char);
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


// Отрисовка категорий и подкатегорий в ComboBox
procedure TAddDohForm.CatBoxDrawItem(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
 txt: string;
 main_table: TSQLiteTable;
 xTable: string;
begin
 if Control=AddDohForm.CatBox
  then xTable:='cat_doh'
  else xTable:='cat_ras';

 with (Control as TCombobox) do
  begin
   main_table:=SQL_db.GetTable('SELECT parent FROM '+xTable+' WHERE id='+IntToStr(Integer((Control as TCombobox).Items.Objects[Index])));

   // Цвета для выделенного пункта
   if odFocused in State then
    begin
     Canvas.Brush.color:=clHotLight;
     Canvas.Font.Color:=clWhite;
    end;

   // Выделение жирным родительских категорий
   if main_table.FieldAsInteger('parent')=-1 then
    begin
     Canvas.Font.Style:=Canvas.Font.Style+[fsBold];
     txt:=' ';
    end
   else
    begin
     Canvas.Font.Style:=Canvas.Font.Style-[fsBold];
     txt:='  -';
    end;

    // Отрисовка текста с заданным параметрами
    Canvas.FillRect(ARect);
    Canvas.TextOut(ARect.Left, ARect.Top, txt+Items[Index]);
   end;
end;


// Отрисовка ComboBox со списком валют
procedure TAddDohForm.BillBoxDrawItem(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
begin
  BillBoxDraw(Control, Index, ARect, State);
end;


// Отрисовка ComboBox со списком валют
procedure TAddDohForm.BillBoxDraw(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
  sep_pos: Integer; // Флаг символа-разделителя
  TabW: integer;
  txt, txt2: string;
begin

 with (Control as TComboBox) do
  begin
   txt:=Items[Index];
   Canvas.FillRect(ARect);

   // Поиск сепаратора
   sep_pos:= Pos('|', txt);

   // Если сепаратора нет, рисуем текст целиком
   if sep_pos=0 then Canvas.TextOut(ARect.Left, ARect.Top, txt)
   else
    begin
     // отрезаем "хвост"
     txt2:=Copy(txt, sep_pos+1, Length(txt));
     txt:=Copy(txt, 1, sep_pos-1);
     // Вычисляем отступ
     TabW:=ClientWidth-Canvas.TextWidth(txt2)-30;
     // рисуем в два захода
     Canvas.TextOut(ARect.Left, ARect.Top, txt);
     Canvas.TextOut(ARect.Left+TabW, ARect.Top, txt2);
    end;
  end;

end;


//
procedure TAddDohForm.OKButtonClick(Sender: TObject);
begin
 if SumEdit.Value<=0 then exit;

 ButtonPanel1.OKButton.Enabled:=false;

 // Обновление записи в БД
 SaveDohod;

 // Обновление сетки в главном окне
 MainForm.GetMainTable;
 MainForm.UserComboBoxSelect(self);
end;


// Сохранение данных о доходе
procedure TAddDohForm.SaveDohod;
var
 doh_ID, bill_ID: string;
 balans: currency;
 temp_table: TSQLiteTable;
begin
 // Старт записи в БД
 SQL_db.BeginTransaction;

 // Выбор режима сохранения
 if not Add_flag
  // в режиме редактирования ID берём из таблицы
  then doh_ID:=IntToStr((MainForm.MainGrid.Objects[0, MainForm.ActRow] as TItemData).ID)
  // в режиме добавления нового дохода - берём максимальный ID из БД
  else
   begin
    // Получаем следующий свободный ID
    doh_ID:=IntToStr(SQL_db.GetMaxValue('dohod', 'id')+1);
    // Вставляем новую строку (с заданными ID и категорий)
    SQL_db.ExecSQL('INSERT INTO dohod (id, cat, bill, sum, date, sourse, memo) VALUES ("'+doh_ID+'", "", "", "", "", "", "")');
   end;

 // Получаем текущий баланс счёта
 bill_ID:=IntToStr(Integer(BillBox.Items.Objects[BillBox.ItemIndex]));
 temp_table:=SQL_db.GetTable('SELECT balans FROM bill WHERE id='+bill_ID);
 balans:=StrToCurr(temp_table.FieldAsString('balans'));
 // Вычисляем новый баланс с учётом режима (редактирование/добавление дохода)
 if Add_flag=true
  then balans:=balans+SumEdit.Value
  else balans:=balans-old_sum+SumEdit.Value;

 // Обновляем данные в БД
 SQL_db.ExecSQL('UPDATE bill SET balans = "'+CurrToStr(balans)+'" WHERE id ='+bill_ID);
 SQL_db.ExecSQL('UPDATE dohod SET cat = "'+IntToStr(Integer(CatBox.Items.Objects[CatBox.ItemIndex]))+'" WHERE id ='+doh_ID);
 SQL_db.ExecSQL('UPDATE dohod SET bill = "'+IntToStr(Integer(BillBox.Items.Objects[BillBox.ItemIndex]))+'" WHERE id ='+doh_ID);
 SQL_db.ExecSQL('UPDATE dohod SET sum = "'+SumEdit.Text+'" WHERE id ='+doh_ID);
 DohDateTimePicker.Time:=Time;
 SQL_db.ExecSQL('UPDATE dohod SET date = "'+IntToStr(DateTimeToUnixTime(DohDateTimePicker.DateTime))+'" WHERE id ='+doh_ID);
 SQL_db.ExecSQL('UPDATE dohod SET memo = "'+MemoEdit.Text+'" WHERE id ='+doh_ID);

 // Завершаем редактирование БД
 SQL_db.Commit;
end;

//
procedure TAddDohForm.SumEditChange(Sender: TObject);
begin
 if (SumEdit.Value<=0) or (BillBox.ItemIndex<0) or (CatBox.ItemIndex<0)
  then ButtonPanel1.OKButton.Enabled:=false
  else ButtonPanel1.OKButton.Enabled:=true;
end;

end.
