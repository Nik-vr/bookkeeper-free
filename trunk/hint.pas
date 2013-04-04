unit hint; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SQLiteTable3, types, doh_add;

type

  { THintForm }

  THintForm = class(TForm)
   HintBox: TListBox;
   procedure FormShow(Sender: TObject);
   procedure HintBoxDrawItem(Control: TWinControl; Index: Integer;
     ARect: TRect; State: TOwnerDrawState);
   procedure HintBoxMouseEnter(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  HintForm: THintForm; 

implementation

uses main;

{$R *.lfm}

{ THintForm }

procedure THintForm.HintBoxMouseEnter(Sender: TObject);
begin
  HintForm.Visible:=false;
  MainForm.Timer1.Enabled:=false;
end;

procedure THintForm.FormShow(Sender: TObject);
var
  MaxWidth: integer;
  i: integer;
  xID: integer;
  item_table, basket_table, temp_table: TSQLiteTable;
  sum: Currency = 0;
  num: Currency = 0;
  price: Currency = 0;
  xName: string;
begin
 HintBox.Items.Clear;
 MaxWidth:=0;

 with MainForm do
 case CurCol of
 // Подсказки для кнопок
 4: HintBox.Items.Add('Редактировать');
 5, 7: HintBox.Items.Clear;
 6: HintBox.Items.Add('Удалить');
 else
  // Формируем текст подсказки для строки операции
  begin
   // Идентификатор записи/корзины
   xID:=(MainForm.MainGrid.Objects[0, MainForm.MainGrid.Row] as TItemData).ID;

   case (MainForm.MainGrid.Objects[0, MainForm.MainGrid.Row] as TItemData).xType of
   itRashod: // подсказка для корзины
    begin
     // вывод данных о составе корзины
     basket_table:=SQL_db.GetTable('SELECT * FROM rashod WHERE basket='+IntToStr(xID));
     sum:=0; // сумма для корзины
     if basket_table.Count>0 then
      for i:=0 to basket_table.Count-1 do
       begin
        // текстовая метка
        xName:=basket_table.FieldAsString('memo');
        if Length(xName)<=0 then
         begin
          temp_table:=SQL_db.GetTable('SELECT * FROM cat_doh WHERE id='+basket_table.FieldAsString('cat')+' LIMIT 1;');
          xName:=temp_table.FieldAsString('name');
         end;

        num:=StrToCurr(basket_table.FieldAsString('num'));
        price:=StrToCurr(basket_table.FieldAsString('price'));
        HintBox.Items.Add(xName+'|'+CurrToStr(num*price));
        sum:=sum+num*price;
        basket_table.Next;
       end;

     // вывод итога
     HintBox.Items.Add('Итого '+IntToStr(basket_table.Count)+' наименований');
     HintBox.Items.Add('на сумму '+CurrToStr(sum)+' руб.');
    end;  // of .. itRashod

   itDohod: // доход
    begin
     item_table:=SQL_db.GetTable('SELECT * FROM dohod WHERE id='+IntToStr(xID));
     HintBox.Items.Add('Доход от '+DateToStr(item_table.FieldAsDateTime('date')));
     //
     AddDohForm.LoadBillsList(AddDohForm);
     for i:=0 to AddDohForm.BillBox.Items.Count-1 do
      if (Integer(AddDohForm.BillBox.Items.Objects[i])=item_table.FieldAsInteger('bill')) then
      begin
       HintBox.Items.Add('Счёт: '+AddDohForm.BillBox.Items[i]);
       break;
      end;
     //
     sum:=StrToCurr(item_table.FieldAsString('sum'));
     HintBox.Items.Add('Cумма '+CurrToStr(sum)+' руб.');
    end; // of .. itDohod
   end; // case

//   HintBox.Items.Add('Колбаса..........55.11');
//   HintBox.Items.Add('Хлеб..............8.90');
  end;
 end;

 for i:=0 to HintBox.Count-1 do
  begin
   if MaxWidth<HintBox.Canvas.GetTextWidth(HintBox.Items[i])
    then MaxWidth:=HintBox.Canvas.GetTextWidth(HintBox.Items[i]);
  end;

 Height:=HintBox.Count*HintBox.ItemHeight+5;
 Width:=MaxWidth+8;

 if HintBox.Items.Count<=0
  then Visible:=false
  else Visible:=true;
end;

procedure THintForm.HintBoxDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  sep_pos: Integer; // Флаг символа-разделителя
  TabW, TxtW: integer;
  txt, txt2: string;
begin

 with HintBox do
  begin
   txt:=Items[Index];

   // Цвет фона ("подсказка")
   Canvas.Brush.Color:=clInfoBk;
  // if Length(txt)>=1 then
//    if (idx = index) and (txt[1]<>'!')
//     then Canvas.Font.Color:=clHighlight
//     else Canvas.Font.Color:=clWindowText;

    // Выделяем жирным заголовки
    if Length(txt)>=1 then
    if txt[1]='!' then
     begin
      Canvas.Font.Style:=Canvas.Font.Style+[fsBold];
      txt:=Copy(txt, 2, Length(txt));
     end
     else Canvas.Font.Style:=Canvas.Font.Style-[fsBold];

    Canvas.FillRect(ARect);

   // Поиск сепаратора
   sep_pos:= Pos('|', txt);

   // Если сепаратора нет, рисуем текст целиком
   if sep_pos=0 then Canvas.TextOut(ARect.Left+5, ARect.Top, txt)
   else
    begin
     // отрезаем "хвост"
     txt2:=Copy(txt, sep_pos+1, Length(txt+' '));
     txt:=Copy(txt, 1, sep_pos-1);
     // Вычисляем отступ
     TabW:=ClientWidth-Canvas.TextWidth(' '+txt2)-1;
     TxtW:=Canvas.TextWidth(txt+' ');
     // Рисуем "подчёркивание"
     Canvas.TextOut(ARect.Left+TxtW, ARect.Top, '....................................');
     // рисуем текст в два захода
     Canvas.TextOut(ARect.Left+5, ARect.Top, txt+' ');
     Canvas.TextOut(ARect.Left+TabW, ARect.Top, ' '+txt2);
     //
    end;
  end;
end;

end.

