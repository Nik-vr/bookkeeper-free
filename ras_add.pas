unit ras_add;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel, Buttons, ActnList, Grids, ZVDateTimePicker, CurrencyEdit,
  SQLiteTable3, Windows, types, MyTools;

type

  { TAddRasForm }

  TAddRasForm = class(TForm)
    ActionElse: TAction;
    ActionList1: TActionList;
    BillBox: TComboBox;
    ButtonPanel1: TButtonPanel;
    CatBox: TComboBox;
    CountEdit: TCurrencyEdit;
    BasketBox: TGroupBox;
    Label3: TLabel;
    PriceEdit: TCurrencyEdit;
    ElseButton: TSpeedButton;
    GroupBox1: TGroupBox;
    IzmBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MemoEdit: TEdit;
    RasDateTimePicker: TZVDateTimePicker;
    BasketGrid: TStringGrid;
    BasketButton: TSpeedButton;
    procedure ActionElseExecute(Sender: TObject);
    procedure BasketGridClick(Sender: TObject);
    procedure BasketGridDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure BillBoxDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure BillBoxSelect(Sender: TObject);
    procedure CatBoxDrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure CatBoxSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IzmBoxChange(Sender: TObject);
    procedure MemoEditKeyPress(Sender: TObject; var Key: char);
    procedure OKButtonClick(Sender: TObject);
  private
    procedure AddRash;
    procedure Clean(first_step: boolean);
    procedure CreateNewRashod;
    procedure LoadBasket(basket_id: integer);
    procedure LoadIzmList;
    procedure LoadRashod(id: integer);
    procedure SelectCombo(rashod_id: integer);
    procedure SetBasketMode(basket_mode: boolean);
  public
    //    procedure BillBoxDraw(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
  end;

var
  AddRasForm: TAddRasForm;
  bas_count, count_else, temp_cur, old_bill: integer;
  basket_ID: string;

  old_num, old_price: real;

implementation

uses Main, doh_add;

{$R *.lfm}

procedure TAddRasForm.LoadIzmList;
var
 main_table: TSQLiteTable;
 i: integer;
begin
 // Очистка списка
 IzmBox.Clear;

 // Проверка, необходимо ли загружать весь список
 if MainForm.MeasureCheckBox.Checked=true then
  begin
   // Выборка данных об единицах измерения из БД
   main_table:=SQL_db.GetTable('SELECT * FROM izm');

   // Проход по списку единиц изменения
   for i:=0 to main_table.Count-1 do
    begin
     IzmBox.AddItem(main_table.FieldAsString('abbr'),TObject(main_table.FieldAsInteger('id')));
     main_table.Next;
    end;
  end
  // если единицы измерения отключены
  else
   begin
    // Выборка данных об единицах измерения из БД (берём только дефолтную единицу)
    main_table := SQL_db.GetTable('SELECT * FROM izm LIMIT 1');
    IzmBox.AddItem(main_table.FieldAsString('abbr'),TObject(main_table.FieldAsInteger('id')));
   end;

  // Значение по умолчанию
  IzmBox.ItemIndex:=0;
end;

// Режим окна (корзина/единичные расходы)
procedure TAddRasForm.SetBasketMode(basket_mode: boolean);
begin
 // вид окна
 BasketBox.Enabled:=basket_mode;
 if basket_mode
  then Width:=850  // показываем сетку корзины
  else Width:=470; // скрываем сетку корзины
end;

// Отображение окна
procedure TAddRasForm.FormShow(Sender: TObject);
var
  xID: integer;
  xType: TMyItemType;
begin
  // Счётчик добавленных расходов (для корректной работы кнопки "Ещё")
  count_else := 0;

  // Ширина колонок
  with BasketGrid do
   begin
    ColWidths[0] := 136; // Наименование
    ColWidths[1] := 50;  // цена
    ColWidths[2] := 40;  // кол-во
    ColWidths[3] := 126;  // примечание
   end; // with ...

  // Загружаем списки единиц измерения, категорий и счетов
  LoadIzmList;
  AddDohForm.LoadCategoryList('cat_ras', AddRasForm);
  AddDohForm.LoadBillsList(AddRasForm);

  // Очистка окна
  Clean(True);

  // Редактирование
  if Add_flag = False then
   begin
    // Загружаем данные о расходе
    xType:=(MainForm.MainGrid.Objects[0, MainForm.ActRow] as TItemData).xType;
    xID:=(MainForm.MainGrid.Objects[0, MainForm.ActRow] as TItemData).ID;

    // Загружаем данные
    LoadBasket(xID);
   end // if Add_flag = ...
  // Готовим форму к добавлению нового расхода/корзины
  else CreateNewRashod;

  ButtonPanel1.OKButton.Enabled:=false;
  ElseButton.Enabled:=false;
  BasketButton.Enabled:=false;
end;

// Загрузка расхода
procedure TAddRasForm.LoadRashod(id: integer);
var
 main_table: TSQLiteTable;
begin
 // Загрузка данных из БД
 main_table := SQL_db.GetTable('SELECT * FROM rashod WHERE id=' + IntToStr(id));

 // Если данные не загружены, закрываем окно (вероятно передан неверный ID)
 if main_table.Count = 0 then AddRasForm.Close;

 // Подготовка окна
 ElseButton.Visible := False;
 Caption := 'Изменение записи';
 ButtonPanel1.OKButton.Caption:= 'Изменить';

 // Выбор элементов в списках
 SelectCombo(id);

 // Загрузка прочих данных
 old_bill := integer(BillBox.Items.Objects[BillBox.ItemIndex]);

 MemoEdit.Text:=main_table.FieldAsString('memo');
 CountEdit.Text:=main_table.FieldAsString('num');
 PriceEdit.Text:=main_table.FieldAsString('price');

 old_num:=StrToCurr(main_table.FieldAsString('num'));
 old_price:=StrToCurr(main_table.FieldAsString('price'));
end;

// Загрузка корзины
procedure TAddRasForm.LoadBasket(basket_id: integer);
var
 temp_table, temp_table2: TSQLiteTable;
 i: integer;
 xID: integer;
begin
  // Выборка данных из БД
  temp_table := SQL_db.GetTable('SELECT * FROM rashod WHERE basket=' + IntToStr(basket_ID));

  // Подготовка окна
  BillBox.Enabled := False;
  RasDateTimePicker.Enabled := False;
  // Очистка сетки
  BasketGrid.RowCount := 1;
  BasketGrid.ColCount := 4;

  // загрузка списка товаров в корзине
  for i := 0 to temp_table.Count - 1 do
   with BasketGrid do
    begin
     // Если нужно - добавляем строку
     if (i <> temp_table.Count - 1 - 1) then RowCount := RowCount + 1;
     // Подкатегория
     temp_table2 := SQL_db.GetTable('SELECT * FROM cat_ras WHERE id=' + temp_table.FieldAsString('cat') + ' LIMIT 1;');
     Cells[0, i] := temp_table2.FieldAsString('name');
     // служебные данные (ID, тип)
     Objects[0, i] := TItemData.Create(temp_table.FieldAsInteger('id'), itRashod);
     // Сумма
     Cells[1, i] := CurrToStr(MainForm.RoundEx(
        MainForm.DrawValut(temp_table.FieldAsInteger('bill'), 0,
        StrToCurr(temp_table.FieldAsString('price'))), 2)); // Сумма
     // Количество
     Cells[2, i] := temp_table.FieldAsString('num');
     // Примечание
     Cells[3, i] := temp_table.FieldAsString('memo');

     temp_table.Next;
    end; // for i:=

  // Загружаем в окно редактирования первую запись корзины
  xID:=(BasketGrid.Objects[0, 0] as TItemData).ID;
  LoadRashod(xID);
end;

// Подготовка формы к добавлению нового расхода/корзины
procedure TAddRasForm.CreateNewRashod;
begin
  ButtonPanel1.OKButton.Caption:= 'Добавить';
  // Выбираем режим
  if (add_basket <> -1) then
   // добавление новой записи к существующей корзине
   begin
    Caption:='Добавление новой записи в корзину';
    BillBox.Enabled:=False;
    RasDateTimePicker.Enabled:=False;
  end
  // новая корзина или новая одиночная запись
  else
   begin
    Caption:='Добавление новой записи';
    RasDateTimePicker.Date:=Date;
    BillBox.Enabled:=true;
    RasDateTimePicker.Enabled:=true;
  end;
  // Прочие поля
  MemoEdit.Text:='';
  CountEdit.Value:=1;
  PriceEdit.Value:=0;
  IzmBoxChange(PriceEdit);
end;

// Выбор пунктов в списках, соответсвующих загружаемых данным
// (для "Счёта", "Категории" и "Единицы измерения")
procedure TAddRasForm.SelectCombo(rashod_id: integer);
var
  i: integer;
  main_table: TSQLiteTable;
begin
 // Загрузка данных
 main_table:=SQL_db.GetTable('SELECT * FROM rashod WHERE id='+IntToStr(rashod_id));

 // Заполнение ComboBox "Категория"
 for i:=0 to CatBox.Items.Count-1 do
  if (integer(CatBox.Items.Objects[i]) = main_table.FieldAsInteger('cat')) then
   begin
    CatBox.ItemIndex:=i;
    break;
   end;

  // Заполнение ComboBox "Категория"
  for i:=0 to BillBox.Items.Count-1 do
   if (integer(BillBox.Items.Objects[i]) = main_table.FieldAsInteger('bill')) then
    begin
     BillBox.ItemIndex:=i;
     break;
    end;

  // Заполнение ComboBox "Единица измерения"
  for i:=0 to IzmBox.Items.Count-1 do
   if (integer(IzmBox.Items.Objects[i]) = main_table.FieldAsInteger('izm')) then
    begin
     IzmBox.ItemIndex:=i;
     break;
    end;

  // Заполнение поля "Дата"
  RasDateTimePicker.Date:=main_table.FieldAsDateTime('date');
end;

procedure TAddRasForm.IzmBoxChange(Sender: TObject);
begin
  // Проверяем поля ввода и комбобоксы
  if (CountEdit.Value <= 0) or (PriceEdit.Value <= 0) or (CatBox.ItemIndex = -1) or
    (BillBox.ItemIndex = -1) then
  begin
    ButtonPanel1.OKButton.Enabled:=False;
    ElseButton.Enabled:=False;
    BasketButton.Enabled:=False;
  end
  else
  begin
    ButtonPanel1.OKButton.Enabled:=True;
    ElseButton.Enabled:=True;
    BasketButton.Enabled:=True;
  end;

  // Проверка на 1 запуск корзины
  if ((Add_flag) and (count_else = 0)) then
    ButtonPanel1.OKButton.Enabled := False;
end;

procedure TAddRasForm.MemoEditKeyPress(Sender: TObject; var Key: char);
const
 lq: char = #171;
 rq: char = #187;
var
 NumOfQuotes: integer;
begin
 if Key = '"' then
  begin
   // Определяем тип поля редактирования и подсчитываем количество кавычек в нём
   if (Sender is TEdit)
    then NumOfQuotes:=CntChRepet((Sender as TEdit).Text, lq)
         + CntChRepet((Sender as TEdit).Text, rq);
   // нечётные кавычки - открывающие, чётные - закрывающие
   if odd(NumOfQuotes)
    then Key := rq
    else Key := lq;
  end;
end;

// Отрисовка категорий и подкатегорий в ComboBox
procedure TAddRasForm.CatBoxDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
begin
  AddDohForm.CatBoxDrawItem(Control, Index, ARect, State);
end;

// Выбор категории из списка
procedure TAddRasForm.CatBoxSelect(Sender: TObject);
begin
  // после выбора категории автоматически уводим фокус в поле редактирования цены
  PriceEdit.SetFocus;
end;

// Отрисовка списка счетов (с валютами)
procedure TAddRasForm.BillBoxDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
begin
  AddDohForm.BillBoxDraw(Control, Index, ARect, State);
end;

// Выбор счёта из списка
procedure TAddRasForm.BillBoxSelect(Sender: TObject);
begin
  // после выбора счёта автоматически уводим фокус в поле выбора категории
  CatBox.SetFocus;
end;

// Добавление нового расхода (кнопка Ещё)
procedure TAddRasForm.ActionElseExecute(Sender: TObject);
begin
  if not ElseButton.Enabled then exit;
  AddRash;
  //if basket_flag = True then
  // begin
    Clean(False);
    count_else := count_else + 1;
    BillBox.Enabled := False;
    RasDateTimePicker.Enabled := False;
  // end
  //else Clean(True);
  PriceEdit.SetFocus;
end;

// Выбор товара из таблицы корзины
procedure TAddRasForm.BasketGridClick(Sender: TObject);
begin
  // Если в сетке есть данные, при щелчке они загружаются
  if (BasketGrid.Cells[0, 0]<>'')
   then LoadRashod((BasketGrid.Objects[0, BasketGrid.Row] as TItemData).ID);
end;

// Отрисовка сетки таблицы
procedure TAddRasForm.BasketGridDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin
  MainForm.MeasureGridDrawCell(BasketGrid, Acol, Arow, aRect, aState);
end;

// Добавление/изменение
procedure TAddRasForm.OKButtonClick(Sender: TObject);
begin
  AddRash;
end;

// Сохранение записи
procedure TAddRasForm.AddRash;
var
  balans, balans_old, num, price: real;
  ras_ID, bill_ID: string;
  temp_table: TSQLiteTable;
  main_table: TSQLiteTable;
begin
  ButtonPanel1.OKButton.Enabled := False;
  ElseButton.Enabled := False;
  // Обновление записи в БД
  SQL_db.BeginTransaction;
  // В режиме редактирования ID берём из таблицы
  if not Add_flag then
    ras_ID := IntToStr((MainForm.MainGrid.Objects[0, MainForm.ActRow] as TItemData).ID)
  // В режиме добавления нового пользователя - не присваиваем (его определит MySQL)
  else
  begin
    // Ищем максимальный индекс
    ras_ID := IntToStr(SQL_db.GetMaxValue('rashod', 'id') + 1);
    // Вставляем новую строку (с заданными ID и корзиной)
    SQL_db.ExecSQL(
      'INSERT INTO rashod (id, cat, bill, price, num, izm, basket, date, item, agent, memo) VALUES ("'
      +
      ras_ID + '", "", "", "", "", "", "-1", "", "", "", "")');

    if add_basket <> -1
     then SQL_db.ExecSQL('UPDATE rashod SET basket = ' + IntToStr(add_basket) + ' WHERE id =' + ras_ID);
 //   ShowMessage(IntToStr(add_basket));
    // Добавление корзины
    //if basket_flag = True then
     if count_else = 0 then
      begin
       // Ищем максимальный индекс
       temp_table := SQL_db.GetTable('SELECT basket FROM rashod ORDER by basket DESC LIMIT 1;');
       if temp_table.Count <= 0 then basket_ID := '0'
       else
        begin
         temp_table.First;
         basket_ID := IntToStr(temp_table.FieldAsInteger('basket') + 1);
       end;
      end;
      SQL_db.ExecSQL('UPDATE rashod SET basket = ' + basket_ID + ' WHERE id =' + ras_ID);
  end; // if add_flag / else

  bill_ID := IntToStr(integer(BillBox.Items.Objects[BillBox.ItemIndex]));
  temp_table := SQL_db.GetTable('SELECT balans FROM bill WHERE id=' + bill_ID);
  balans := StrToCurr(temp_table.FieldAsString('balans'));
  price := PriceEdit.Value;
  num := CountEdit.Value;

  if Add_flag = True then
   begin
    balans := balans - price * num;
    SQL_db.ExecSQL('UPDATE bill SET balans = "' + CurrToStr(balans) + '" WHERE id =' + bill_ID);
   end
  else
   begin
    if StrToInt(bill_ID) <> old_bill then
     begin
      balans := balans - price * num;
      SQL_db.ExecSQL('UPDATE bill SET balans = "' + CurrToStr(balans) + '" WHERE id =' + bill_ID);

      main_table := SQL_db.GetTable('SELECT balans FROM bill WHERE id =' + IntToStr(old_bill));
      balans_old := StrToCurr(main_table.FieldAsString('balans'));
      balans_old := balans_old + old_price * old_num;
      SQL_db.ExecSQL('UPDATE bill SET balans = "' + CurrToStr(balans_old) + '" WHERE id =' + IntToStr(old_bill));
     end
    else
     begin
      balans := balans + old_price * old_num - price * num;
      SQL_db.ExecSQL('UPDATE bill SET balans = "' + CurrToStr(balans) + '" WHERE id =' + bill_ID);
     end;
   end;

  SQL_db.ExecSQL('UPDATE rashod SET cat = "' + IntToStr(integer(CatBox.Items.Objects[CatBox.ItemIndex])) + '" WHERE id =' + ras_ID);
  SQL_db.ExecSQL('UPDATE rashod SET bill = "' + IntToStr(integer(BillBox.Items.Objects[BillBox.ItemIndex])) + '" WHERE id =' + ras_ID);
  SQL_db.ExecSQL('UPDATE rashod SET price = "' + PriceEdit.Text + '" WHERE id =' + ras_ID);
  SQL_db.ExecSQL('UPDATE rashod SET num = "' + CountEdit.Text + '" WHERE id =' + ras_ID);
  SQL_db.ExecSQL('UPDATE rashod SET izm = "' + IntToStr(integer(IzmBox.Items.Objects[IzmBox.ItemIndex])) + '" WHERE id =' + ras_ID);
  RasDateTimePicker.Time := Time;
  SQL_db.ExecSQL('UPDATE rashod SET date = "' + IntToStr(DateTimeToUnixTime(RasDateTimePicker.DateTime)) + '" WHERE id =' + ras_ID);
  SQL_db.ExecSQL('UPDATE rashod SET memo = "' + MemoEdit.Text + '" WHERE id =' + ras_ID);
  SQL_db.Commit;

  // Обновление сетки в главном окне
  MainForm.GetMainTable;
  MainForm.UserComboBoxSelect(self);
end;

// Очистка при запуске формы и нажатии кнопки Ещё
procedure TAddRasForm.Clean(first_step: boolean);
begin
  MemoEdit.Clear;
  CountEdit.Value := 1;
  PriceEdit.Value := 0;
  if first_step then RasDateTimePicker.Date := Date;
end;

end.
