unit correct_balans;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel, CurrencyEdit, splash, cur_trans, Windows, SQLiteTable3;

type

  { TCorrectForm }

  TCorrectForm = class(TForm)
   ButtonPanel1: TButtonPanel;
   BillBox: TComboBox;
   SumEdit: TCurrencyEdit;
   MemoEdit: TEdit;
   GroupBox1: TGroupBox;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   procedure BillBoxClick(Sender: TObject);
   procedure BillBoxDrawItem(Control: TWinControl; Index: Integer;
    ARect: TRect; State: TOwnerDrawState);
   procedure FormShow(Sender: TObject);
   procedure OKButtonClick(Sender: TObject);
  private
   procedure SaveToCorrect(table: string; ost: real);
  public
    { public declarations }
  end; 

var
  CorrectForm: TCorrectForm;

implementation

uses Main, doh_add;

{$R *.lfm}

{ TCorrectForm }

procedure TCorrectForm.FormShow(Sender: TObject);
var
  i: integer;
  temp_table: TSQLiteTable;
begin
 BillBox.Clear;
 MemoEdit.Clear;

 // Выборка из таблицы счетов
 if mode=amChlen
 then temp_table:=SQL_db.GetTable('SELECT * FROM bill WHERE user='+IntToStr(user_id))
 else temp_table:=SQL_db.GetTable('SELECT * FROM bill');

 // Проход по списку пользователей
 for i:=0 to temp_table.Count-1 do
   begin
    BillBox.Items.Add(temp_table.FieldAsString('name')+'|'+TransCurForm.SelectValut(temp_table.FieldAsInteger('id')));
    BillBox.Items.Objects[i]:=TObject(temp_table.FieldAsInteger('id'));
    temp_table.Next;
   end;
 BillBox.ItemIndex:=-1;

 for i:=0 to BillBox.Items.Count-1 do
 if Integer(BillBox.Items.Objects[i])=StrtoInt(MainForm.BillGrid.Cells[0, MainForm.BillGrid.Row]) then
  begin
   BillBox.ItemIndex:=i;
   break;
  end;

// Caption:='Корректировка баланса';
// ButtonPanel1.OKButton.Caption:='Изменить баланс';
 ButtonPanel1.OKButton.Enabled:=false;
 SumEdit.SetFocus;
end;

procedure TCorrectForm.BillBoxDrawItem(Control: TWinControl; Index: Integer;
 ARect: TRect; State: TOwnerDrawState);
begin
 AddDohForm.BillBoxDraw(Control, Index, ARect, State);
end;

procedure TCorrectForm.BillBoxClick(Sender: TObject);
begin
 if (BillBox.ItemIndex<>-1) and (SumEdit.Value>0)
  then ButtonPanel1.OKButton.Enabled:=true
  else ButtonPanel1.OKButton.Enabled:=false;
end;

procedure TCorrectForm.OKButtonClick(Sender: TObject);
var
 temp_balans, bd_balans: real;
 main_table: TSQLiteTable;
begin
 ButtonPanel1.OKButton.Enabled:=false;
 //
  temp_balans:=0;
  temp_balans:=SumEdit.Value;

  main_table:=SQL_db.GetTable('SELECT balans FROM bill WHERE id='+IntToStr(Integer(BillBox.Items.Objects[BillBox.ItemIndex])));
  bd_balans:=StrToCurr(main_table.FieldAsString('balans'));

  if temp_balans>bd_balans
   then SaveToCorrect('dohod',temp_balans-bd_balans)
   else
    if temp_balans<bd_balans
     then SaveToCorrect('rashod',bd_balans-temp_balans);

  // Обновление записи в БД
  SQL_db.BeginTransaction;
  SQL_db.ExecSQL('UPDATE bill SET balans = "'+CurrToStr(temp_balans)+'" WHERE id ='+IntToStr(Integer(BillBox.Items.Objects[BillBox.ItemIndex])));
  SQL_db.Commit;

  //Обновление сетки в главном окне
  MainForm.GetBillList;
  MainForm.GetMainTable;
//  MainForm.GetRasTable;
  MainForm.OutputBalans;
end;

procedure TCorrectForm.SaveToCorrect(table: string; ost: real);
var
 ID, temp_bill: string;
 tab: integer;
 temp_table: TSQLiteTable;
begin
 // Ищем максимальный индекс
 temp_table:=SQL_db.GetTable('SELECT id FROM '+table+' ORDER by id DESC LIMIT 1;');
 if temp_table.Count<=0
  then ID:='0'
  else ID:=IntToStr(temp_table.FieldAsInteger('id')+1);

 SQL_db.BeginTransaction;
 if table='dohod' then
  begin
   SQL_db.ExecSQL('INSERT INTO dohod (id, cat, bill, sum, date, sourse, memo) VALUES ("'+ID+'", 0, "", "", "", "", "")');
   SQL_db.ExecSQL('UPDATE dohod SET sum = "'+CurrToStr(ost)+'" WHERE id ='+ID);
  end;

 if table='rashod' then
  begin
   SQL_db.ExecSQL('INSERT INTO rashod (id, cat, bill, price, num, izm, basket, date, item, agent, memo) VALUES ("'+ID+'", 0, "", "", "", "", -1, "", "", "", "")');
   SQL_db.ExecSQL('UPDATE rashod SET price = "'+CurrToStr(ost)+'" WHERE id ='+ID);
   SQL_db.ExecSQL('UPDATE rashod SET num = 1 WHERE id ='+ID);
   SQL_db.ExecSQL('UPDATE rashod SET izm = -1 WHERE id ='+ID);
  end;

 SQL_db.ExecSQL('UPDATE '+table+' SET bill = "'+IntToStr(Integer(BillBox.Items.Objects[BillBox.ItemIndex]))+'" WHERE id ='+ID);
 SQL_db.ExecSQL('UPDATE '+table+' SET date = "'+IntToStr(DateTimeToUnixTime(Date))+'" WHERE id ='+ID);

 temp_bill:=BillBox.Items.Strings[BillBox.ItemIndex];
 tab:=Pos('|', temp_bill);
 SetLength(temp_bill,tab-1);

 if Length(MemoEdit.Text)>0
  then SQL_db.ExecSQL('UPDATE '+table+' SET memo = "Корректировка счёта '+temp_bill+' ('+MemoEdit.Text+')" WHERE id ='+ID)
  else SQL_db.ExecSQL('UPDATE '+table+' SET memo = "Корректировка счёта '+temp_bill+'" WHERE id ='+ID);

 SQL_db.Commit;
end;

end.
