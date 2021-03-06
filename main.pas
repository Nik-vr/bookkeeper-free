unit main;

{$mode delphi}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, Grids, Buttons, SQLiteTable3, LCLProc, types, LCLType,
  ActnList, TAChartAxis, TAGraph, TASeries, TATools, MyTools, integerlist, xIni,
  splash, user_add, measure_add, cur_add, bill_add, doh_cat_add, doh_add,
  ras_add, cur_trans, correct_balans, hint;

type
  { TMainForm }

  TMainForm = class(TForm)
    AddBasket: TAction;
    AddRashod: TAction;
    AddDohod: TAction;
    ActionList1: TActionList;
   AddCatDohButton: TToolButton;
   AddPodcatDohButton: TToolButton;
   BalansLabel: TLabel;
   CatBox: TComboBox;
   MeasureCheckBox: TCheckBox;
   GridTypeSelect: TComboBox;
   DohRadioButton: TRadioButton;
   GroupBox1: TGroupBox;
   CurGridHeader: THeaderControl;
   GridButtonsImageList: TImageList;
   ButtonsIconsImageList: TImageList;
   Label5: TLabel;
   HintTimer: TTimer;
   Panel5: TPanel;
   TimeLabel: TLabel;
   UsersGridHeader: THeaderControl;
   BillGridHeader: THeaderControl;
   HeaderControl4: THeaderControl;
   DohGridHeader: THeaderControl;
   Label4: TLabel;
   GridPeriodSelect: TComboBox;
   CorrectBtn: TBitBtn;
   CatDohBox: TGroupBox;
   Chart2LineSeries1: TLineSeries;
   DelCatDohButton: TToolButton;
   DohTreeView: TTreeView;
   EditCatDohButton: TToolButton;
   RasRadioButton: TRadioButton;
   ReportBox: TListBox;
   MeasureGrid: TStringGrid;
   CurGrid: TStringGrid;
   BillGrid: TStringGrid;
   DutyGrid: TStringGrid;
   MainGrid: TStringGrid;
   UserGrid: TStringGrid;
   PayDutyBtn: TBitBtn;
   CheckBox1: TCheckBox;
   DutyBox: TGroupBox;
   ToolBar6: TToolBar;
   ToolBar9: TToolBar;
   AddDutyButton: TToolButton;
   CulcButton: TToolButton;
   ToolButton16: TToolButton;
   ToolButton19: TToolButton;
   ToolButton20: TToolButton;
   DelDutyButton: TToolButton;
   ToolButton27: TToolButton;
   ToolButton5: TToolButton;
   EditDutyButton: TToolButton;
   TransCurBtn: TBitBtn;
   Chart1: TChart;
   Chart1PieSeries1: TPieSeries;
   Chart2: TChart;
   Chart2BarSeries1: TBarSeries;
   TransCurButton: TToolButton;
   ToolButton3: TToolButton;
   TypeCharGroup: TRadioGroup;
   GridUsersSelect: TComboBox;
   Label2: TLabel;
   Label3: TLabel;
   Panel4: TPanel;
   PeriodBox: TComboBox;
   Label1: TLabel;
   Panel2: TPanel;
   Panel3: TPanel;
   MeasureBox: TGroupBox;
   DiagramBox: TGroupBox;
   CurBox: TGroupBox;
   Timer1: TTimer;
   InfoButton: TToolButton;
   SelectUserButton: TToolButton;
   UserBox: TGroupBox;
   BillBox: TGroupBox;
   CatRasBox: TGroupBox;
   DohBox: TGroupBox;
   ChartBox: TGroupBox;
   ToolbarImageList: TImageList;
   TabsImageList: TImageList;
   ButtonsImageList: TImageList;
   GridIconsImageList: TImageList;
   TabSheet3: TTabSheet;
   TabSheet4: TTabSheet;
   TabSheet5: TTabSheet;
   TabSheet6: TTabSheet;
   TabSheet7: TTabSheet;
   ToolBar5: TToolBar;
   ToolBar7: TToolBar;
   RasButton: TToolButton;
   ToolButton13: TToolButton;
   EditBillButton: TToolButton;
   ToolButton17: TToolButton;
   DelBillButton: TToolButton;
   AddBillButton: TToolButton;
   AddCatRasButton: TToolButton;
   ToolButton22: TToolButton;
   EditCatRasButton: TToolButton;
   ToolButton24: TToolButton;
   DelCatRasButton: TToolButton;
   AddPodcatRasButton: TToolButton;
   ToolButton29: TToolButton;
   RasTreeView: TTreeView;
   UserComboBox: TComboBox;
   PageControl1: TPageControl;
   TabSheet1: TTabSheet;
   TabSheet2: TTabSheet;
   ToolBar1: TToolBar;
   ToolBar2: TToolBar;
   ToolBar3: TToolBar;
   ToolBar4: TToolBar;
   DohButton: TToolButton;
   ToolButton10: TToolButton;
   ToolButton11: TToolButton;
   AddIzmButton: TToolButton;
   ToolButton12: TToolButton;
   DelCurButton: TToolButton;
   EditUserButton: TToolButton;
   ToolButton14: TToolButton;
   ToolButton15: TToolButton;
   DelUserButton: TToolButton;
   AddUserButton: TToolButton;
   ToolButton9: TToolButton;
   ValutButton: TToolButton;
   AddCurButton: TToolButton;
   EditIzmButton: TToolButton;
   DelIzmButton: TToolButton;
   ToolButton8: TToolButton;
   EditCurButton: TToolButton;
   procedure AddCatDohButtonClick(Sender: TObject);
   procedure AddCatRasButtonClick(Sender: TObject);
   procedure AddCurButtonClick(Sender: TObject);
   procedure AddDohodExecute(Sender: TObject);
   procedure AddIzmButtonClick(Sender: TObject);
   procedure AddPodcatDohButtonClick(Sender: TObject);
   procedure AddPodcatRasButtonClick(Sender: TObject);
   procedure AddRashodExecute(Sender: TObject);
   procedure BillGridDblClick(Sender: TObject);
   procedure BillGridDrawCell(Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
   procedure CatBoxSelect(Sender: TObject);
   procedure CorrectBtnClick(Sender: TObject);
   procedure Chart2AxisList0MarkToText(var AText: String; AMark: Double);
   procedure CulcButtonClick(Sender: TObject);
   procedure CurGridDblClick(Sender: TObject);
   procedure CurGridDrawCell(Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
   procedure CurGridSelectCell(Sender: TObject; ACol, ARow: Integer;
    var CanSelect: Boolean);
   procedure DelBillButtonClick(Sender: TObject);
   procedure DelCatDohButtonClick(Sender: TObject);
   procedure DelCatRasButtonClick(Sender: TObject);
   procedure DelCurButtonClick(Sender: TObject);
   procedure DelIzmButtonClick(Sender: TObject);
   procedure DelUserButtonClick(Sender: TObject);
   procedure HintTimerTimer(Sender: TObject);
   procedure MeasureCheckBoxChange(Sender: TObject);
   procedure MainGridClick(Sender: TObject);
   procedure MainGridDrawCell(Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
   procedure MainGridMouseDown(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
   procedure MainGridMouseLeave(Sender: TObject);
   procedure MainGridMouseMove(Sender: TObject; Shift: TShiftState; X,
     Y: Integer);
   procedure MainGridMouseUp(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
   procedure MainGridMouseWheelDown(Sender: TObject; Shift: TShiftState;
     MousePos: TPoint; var Handled: Boolean);
   procedure DohRadioButtonClick(Sender: TObject);
   procedure DohTreeViewChange(Sender: TObject; Node: TTreeNode);
   procedure DohTreeViewDblClick(Sender: TObject);
   procedure EditBillButtonClick(Sender: TObject);
   procedure EditCatDohButtonClick(Sender: TObject);
   procedure EditCatRasButtonClick(Sender: TObject);
   procedure EditCurButtonClick(Sender: TObject);
   procedure EditIzmButtonClick(Sender: TObject);
   procedure EditUserButtonClick(Sender: TObject);
   procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
   procedure FormCreate(Sender: TObject);
   procedure FormResize(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure AddUserButtonClick(Sender: TObject);
   procedure AddBillButtonClick(Sender: TObject);
   procedure GridTypeSelectSelect(Sender: TObject);
   procedure InfoButtonClick(Sender: TObject);
   procedure MeasureGridDblClick(Sender: TObject);
   procedure MeasureGridDrawCell(Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
   procedure MeasureGridSelectCell(Sender: TObject; ACol, ARow: Integer;
    var CanSelect: Boolean);
   procedure PageControl1Change(Sender: TObject);
   procedure GridPeriodSelectSelect(Sender: TObject);
   procedure PeriodBoxSelect(Sender: TObject);
   procedure RasTreeViewChange(Sender: TObject; Node: TTreeNode);
   procedure ReportBoxDrawItem(Control: TWinControl; Index: Integer;
    ARect: TRect; State: TOwnerDrawState);
   procedure ReportBoxMouseLeave(Sender: TObject);
   procedure ReportBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
   procedure SelectUserButtonClick(Sender: TObject);
   procedure Timer1Timer(Sender: TObject);
   procedure TransCurBtnClick(Sender: TObject);
   procedure TypeCharGroupClick(Sender: TObject);
   procedure GridUsersSelectSelect(Sender: TObject);
   procedure UserComboBoxSelect(Sender: TObject);
   procedure UserGridDblClick(Sender: TObject);
   procedure UserGridDrawCell(Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
   procedure UserGridSelectCell(Sender: TObject; ACol, ARow: Integer;
    var CanSelect: Boolean);
   procedure ValutButtonClick(Sender: TObject);
  private
   AutoSelect: boolean;
   HintX, HintY: integer;
   CursorDown: boolean;
   FontSize: integer;
    //
    procedure DeleteBasket(basketID: integer);
    procedure DeleteDohod(xID: integer);
    procedure DeleteRashod(xID: integer);
    function GetDataForMainTable(table_name: string): TSQLiteTable;
    function GetSumForDate(UnixDate: integer): currency;
    procedure LoadFormSize(Sender: TObject);
    procedure SaveFormSize(Sender: TObject);
   procedure SetHeaderWidths(aGrid: TStringGrid);
   procedure DrawChart;
   procedure SelectDataInChart(table_cat, table: string);
   procedure DrawDiagram;
   procedure DrawReport;
   procedure DrawCatBox(table_cat: string);
   procedure SetOptions;
  public
    ActRow: integer; // текущая строка таблицы
    CurCol, CurRow: Integer; // позиция курсора над основной сеткой
    procedure SetUserID(id: integer);
    procedure CreateDB;
    procedure SetFormCaption(user_name: string);
    procedure GetMeasureList;
    procedure GetCurList;
    procedure GetUserList;
    procedure GetBillList;
    procedure GetDohList(TreeCat: TTreeView; Table: string);
    procedure GetMainTable;
    procedure OutputBalans;
    procedure MinusBalans(ras_ID: string);
    function DrawValut(bill_ID, con_valut: integer; sum: real): real;
    function ReturnBillId(user: integer): string;
    function ReturnCatId(xParent, table: string): string;
    function RoundEx(sum: currency; prec: integer): currency;
end;

  function GetCurFromWeb(Cur: string): Currency; external 'MyTools';

type
  TMyItemType=(itRashod, itDohod, itOperation);

type
 { TItemData }
 TItemData = class(TObject)
  private

  public
   ID: integer;
   xType: TMyItemType; // itRashod - расход, itDohod - доход, itOperation - фин.операция
   constructor Create(newID: integer; newType: TMyItemType);
 end;

var
  MainForm: TMainForm;

  // Объекты для работы с БД
  SQL_db: TSQLiteDatabase;
  SQL_query: string;
  user_id: integer;

  // Флаги добавления/изменения и категории/подкатегории
  Add_flag, Cat_flag, Select_user_flag: boolean;
  add_basket: integer;
  //
  idx, idx_old, dr_date, tb_date: integer;
  //
  DeleteFlag: boolean;

// линкуем секцию ResourceString (текстовые ресурсы, подлежащие переводу)
//{$I localization\local_main.inc}

implementation

{$R *.lfm}
{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
 // Настройки
 DefaultFormatSettings.DecimalSeparator:='.';

 MainForm.Icon:=Application.Icon;
 MainForm.Constraints.MaxHeight:=Screen.Height;
 MainForm.Constraints.MaxWidth:=Screen.Width;

 Application.OnMinimize:=SaveFormSize;
 Application.OnRestore:=LoadFormSize;
end;

procedure TMainForm.SaveFormSize(Sender: TObject);
begin
 SetIniInt('form','top',MainForm.Top,DataDir+'options.ini');
 SetIniInt('form','left',MainForm.Left,DataDir+'options.ini');
 SetIniInt('form','width',MainForm.Width,DataDir+'options.ini');
 SetIniInt('form','height',MainForm.Height,DataDir+'options.ini');
end;

procedure TMainForm.LoadFormSize(Sender: TObject);
begin
 MainForm.Width:=GetIniInt('form','width',800,800,Screen.Width,DataDir+'options.ini');
 MainForm.Height:=GetIniInt('form','height',600,600,Screen.Height,DataDir+'options.ini');
 MainForm.Top:=GetIniInt('form','top',0,0,Screen.Height-MainForm.Height,DataDir+'options.ini');
 MainForm.Left:=GetIniInt('form','left',0,0,Screen.Width-MainForm.Width,DataDir+'options.ini');
end;

procedure TMainForm.SetOptions;
begin
 // восстановление сохраненных размеров формы
 LoadFormSize(self);
 // восстановление настройки отображения единиц измерения
 MeasureCheckBox.Checked:=GetIniBool('measure','on',true,DataDir+'options.ini');
end;

procedure TMainForm.SetUserID(id: integer);
begin
  user_id:=id;
end;

// Изменение размеров формы -> настройка размеров таблиц
procedure TMainForm.FormResize(Sender: TObject);
//var
//  NumOfLines: integer;
begin
 CatRasBox.Width:=(PageControl1.ClientWidth-25) div 2;
 CatDohBox.Left:=CatRasBox.Width+15;
 CatDohBox.Width:=CatRasBox.Width;

 BillBox.Width:=MainForm.Width-185;
 DutyBox.Width:=BillBox.Width;

 ChartBox.Width:=MainForm.Width-330;
 DiagramBox.Width:=ChartBox.Width;

 MeasureBox.Left:=CurBox.Width+15;
 MeasureBox.Height:=MainForm.Height-150;
 CurBox.Height:=MeasureBox.Height;
 UserBox.Height:=MeasureBox.Height;

 CatDohBox.Height:=MeasureBox.Height;
 CatRasBox.Height:=MeasureBox.Height;

 BillBox.Height:=(PageControl1.ClientHeight-60) div 2;
 DutyBox.Top:=BillBox.Height+10;
 DutyBox.Height:=BillBox.Height;

 ChartBox.Height:=(PageControl1.ClientHeight-60) div 2;
 DiagramBox.Top:=ChartBox.Height+10;
 DiagramBox.Height:=ChartBox.Height;

 // Устанавливаем размеры таблиц и хидеров
 SetHeaderWidths(CurGrid);
 SetHeaderWidths(MeasureGrid);
 SetHeaderWidths(UserGrid);
 SetHeaderWidths(BillGrid);
 SetHeaderWidths(MainGrid);
end;

// Установка ширины колонок цен
procedure TMainForm.SetHeaderWidths(aGrid: TStringGrid);
var
 i: integer;
begin
  // Таблица измерений
  if aGrid=MeasureGrid then with MeasureGrid do
   begin
    ColWidths[0]:=0;  // Скрытый столбец с ID
    ColWidths[1]:=150;
   end;

  // Таблица валют
  if aGrid=CurGrid then with CurGrid do
   begin
    ColWidths[0]:=0;  // Скрытый столбец с ID
    ColWidths[1]:=210;
    ColWidths[2]:=90; // Столбец сокращения
    ColWidths[3]:=90; // Столбец курса
    ColWidths[4]:=0;  // Столбец изменения валюты
    for i:=1 to ColCount-2 do
     with CurGridHeader do Sections[i-1].Width:=ColWidths[i]+(i div 3);
   end;

  // Таблица пользователей
  if aGrid=UserGrid then with UserGrid do
   begin
    ColWidths[0]:=0;   // Скрытый столбец с ID
    ColWidths[1]:=160; // Столбец имени
    ColWidths[2]:=0;   // Столбец пароля
    ColWidths[3]:=130; // Столбец статуса
    for i:=1 to ColCount-1 do
     with UsersGridHeader do Sections[i-1].Width:=ColWidths[i]+(i div 3);
   end;

  // Таблица счетов
  if aGrid=BillGrid then with BillGrid do
   begin
    ColWidths[0]:=0;   // Скрытый столбец с ID
    ColWidths[1]:=(ClientWidth-370) div 2;
    ColWidths[2]:=ColWidths[1];
    ColWidths[3]:=100; // Столбец пользователя
    ColWidths[4]:=60;  // Столбец валюты
    ColWidths[5]:=60;  // Столбец баланса
    ColWidths[6]:=150; // Столбец комментария
    for i:=1 to ColCount-1 do
     with BillGridHeader do Sections[i-1].Width:=ColWidths[i]+(i div 3);
   end;

  // Основная таблица
  if aGrid=MainGrid then with MainGrid do
   begin
    ColWidths[0]:=120; // тип операции + дата
    ColWidths[1]:=(ClientWidth-302) div 3;  // категория
    ColWidths[2]:=105; // Сумма
    ColWidths[3]:=ColWidths[1]*2; // примечание
    // ширина колонки с кнопкой №1 (равна ширине изображения-кнопки)
    ColWidths[4]:=29;
    ColWidths[5]:=10; // колонка "отступ"
    // ширина колонки с кнопкой №2 (равна ширине изображения-кнопки)
    ColWidths[6]:=29;
    ColWidths[7]:=10; // колонка "отступ"
    // хидер
    with DohGridHeader do
     begin
      for i:=0 to 3 do Sections[i].Width:=ColWidths[i]+(i div 3);
      Sections[4].Width:=39*2; // двойная ширина столбца с кнопками
     end;
   end;

end;

// Отображение главной формы программы
procedure TMainForm.FormShow(Sender: TObject);
var
 i: integer;
 Codes: TStringList;
 temp_table: TSQLiteTable;
begin
 add_basket:=-1;
 Select_user_flag:=false;

 PageControl1.ActivePageIndex:=0;

// Timer1Timer(self);
 DutyBox.Visible:=false;

 if count_users<2 then SelectUserButton.Enabled:=false;

 // Выбираем режим работы (глава семьи, член семьи)
 case mode of
  amChlen:
   begin
    // Скрываем функции, недоступные пользователям с правами "член семьи"
    PageControl1.Pages[4].TabVisible:=false;
    UserComboBox.Visible:=false;
    Label2.Visible:=false;
    Panel4.Visible:=false;
   end;
  amGlava:
   begin
    // Выборка данных о пользователях из БД
    temp_table:=SQL_db.GetTable('SELECT * FROM users');

    UserComboBox.Items.Add('Все пользователи');
    UserComboBox.Items.Objects[0]:=TObject(-1);
    // Проход по списку пользователей
    for i:=0 to temp_table.Count-1 do
     begin
       UserComboBox.Items.Add(temp_table.FieldAsString('name'));
       UserComboBox.Items.Objects[i+1]:=TObject(temp_table.FieldAsInteger('id'));

       GridUsersSelect.Items.Add(temp_table.FieldAsString('name'));
       GridUsersSelect.Items.Objects[i+1]:=TObject(temp_table.FieldAsInteger('id'));
      temp_table.Next;
     end;
     UserComboBox.ItemIndex:=0;
    end;
 end;

 Chart2.BottomAxis.OnMarkToText:=Chart2AxisList0MarkToText;

 // Создание вспомогательных форм
 Application.CreateForm(TMeasureAddForm,MeasureAddForm);
 Application.CreateForm(TCurAddForm, CurAddForm);
 Application.CreateForm(TUserAddForm, UserAddForm);
 Application.CreateForm(TBillAddForm, BillAddForm);
 Application.CreateForm(TAddCatForm, AddCatForm);
 Application.CreateForm(TAddDohForm, AddDohForm);
 Application.CreateForm(TAddRasForm, AddRasForm);
 Application.CreateForm(TTransCurForm, TransCurForm);
 Application.CreateForm(TCorrectForm, CorrectForm);
 Application.CreateForm(THintForm, HintForm);

 // Установка пользовательских настроек
 SetOptions;

 // Вызов функций заполнения и перерисовки таблиц
 GetMeasureList;
 GetCurList;
 GetUserList;
 GetBillList;
 GetDohList(RasTreeView,'cat_ras');
 GetDohList(DohTreeView,'cat_doh');

 DrawDiagram;
 DrawReport;

// Timer1.Enabled:=false;

 if CurRow=-1 then exit
  else
   begin
    CurRow:=-1;
    MainGrid.Repaint;
   end;

 DohRadioButtonClick(self);
 PeriodBoxSelect(self);
 GridPeriodSelectSelect(self);

 // Вывод списка доступных валют из файла
 with CurAddForm.CurConstGrid do
  begin
   // Очистка сетки
   RowCount:=1;
   ColCount:=2;

   // Чтение списка кодов валют из файла
   Codes:=TStringList.Create;
   Codes:=ReadIniSection('valutes', DataDir+'valutes.lst');
   for i:=0 to Codes.Count-1 do
    begin
     // Если нужно - добавляем строку
     if (i<>0) then RowCount:=RowCount+1;
     Cells[0, i]:=Codes[i];     // ID
     Cells[1, i]:=GetIniString('valutes', Codes[i], '', DataDir+'valutes.lst');   // Название
    end;
  ColWidths[0]:=0;   // Скрытый столбец с ID
  ColWidths[1]:=200; // Столбец названия
  end;
end;

procedure TMainForm.DrawReport;
var
 temp_table, temp_table_2: TSQLiteTable;
 balans: real;
 i, j: integer;
begin
 ReportBox.Clear;
 ReportBox.Items.Add('!Мои финансы');

 for i:=0 to 3 do
  begin
   balans:=0;

   if mode=amChlen
   then temp_table:=SQL_db.GetTable('SELECT * FROM bill WHERE type='+IntToStr(i)+' and user='+IntToStr(user_id))
   else
    if UserComboBox.ItemIndex=0
    then temp_table:=SQL_db.GetTable('SELECT * FROM bill WHERE type='+IntToStr(i))
    else temp_table:=SQL_db.GetTable('SELECT * FROM bill WHERE type='+IntToStr(i)+' and user='+IntToStr(Integer(UserComboBox.Items.Objects[UserComboBox.ItemIndex])));

   if temp_table.Count>0 then
   begin
    temp_table.First;

    for j:=0 to temp_table.Count-1 do
     begin
      balans:=balans+StrToCurr(temp_table.FieldAsString('balans'));
      temp_table.Next;
     end;

    temp_table_2:=SQL_db.GetTable('SELECT name FROM type_bill WHERE id='+IntToStr(i));
    ReportBox.Items.Add(temp_table_2.FieldAsString('name')+'|'+CurrToStr(balans));
   end;
  end;

 //ReportBox.Items.Add('');
 //ReportBox.Items.Add('!Последние расходы/доходы');

// if MainGrid.RowCount<5
//  then count:=MainGrid.RowCount-1
//  else count:=4;

// for i:=count downto 1 do
//   if Length(MainGrid.Cells[7,MainGrid.RowCount-i])<>0 then
//   ReportBox.Items.Add(MainGrid.Cells[1,MainGrid.RowCount-i]+'|'+'-'+MainGrid.Cells[6,MainGrid.RowCount-i]);

(* if MainGrid.RowCount<3
  then count:=MainGrid.RowCount-1
  else count:=2;

 for i:=count downto 1 do
  ReportBox.Items.Add(MainGrid.Cells[1,MainGrid.RowCount-i]+'|'+'+'+MainGrid.Cells[5,MainGrid.RowCount-i]);
*)
end;

procedure TMainForm.OutputBalans;
var
 balans: real;
 i: integer;
 temp_table: TSQLiteTable;
begin
 balans:=0;

 if mode=amChlen
 then temp_table:=SQL_db.GetTable('SELECT id, balans FROM bill WHERE user='+IntToStr(user_id))
 else
   if UserComboBox.ItemIndex=0
    then temp_table:=SQL_db.GetTable('SELECT id, balans FROM bill')
    else temp_table:=SQL_db.GetTable('SELECT id, balans FROM bill WHERE user='+IntToStr(Integer(UserComboBox.Items.Objects[UserComboBox.ItemIndex])));

  if temp_table.Count<>0 then
   begin
    temp_table.First;
    for i:=0 to temp_table.Count-1 do
     begin
      balans:=balans+DrawValut(temp_table.FieldAsInteger('id'), 0, StrToCurr(temp_table.FieldAsString('balans')));
      temp_table.Next;
     end;
    end;

  BalansLabel.Caption:='Общий баланс: '+CurrToStr(RoundEx(balans,2))+' руб.';
end;

// Добавление пользователя
procedure TMainForm.AddUserButtonClick(Sender: TObject);
begin
 Add_flag:=true;
 UserAddForm.ShowModal;
end;

// Добавление счета
procedure TMainForm.AddBillButtonClick(Sender: TObject);
begin
 Add_flag:=true;
 BillAddForm.ShowModal;
end;

procedure TMainForm.GridTypeSelectSelect(Sender: TObject);
begin
  GetMainTable;
end;

// О программе...
procedure TMainForm.InfoButtonClick(Sender: TObject);
begin
 MessageDlg('О программе','Программа "Счетовод"'+#10#13+'Версия: 0.8.1 beta'+#10#13+'Авторские права:'+#10#13+'Петроченко Е.С.'+#10#13+'Петроченко Н.Ю. (c) 2010',mtInformation,[mbOK],'');
end;

// Отображение формы изменения записи при двойном щелчке на записи
procedure TMainForm.MeasureGridDblClick(Sender: TObject);
begin
 EditIzmButtonClick(self);
end;

// Функция отрисовки таблиц
procedure TMainForm.MeasureGridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
 xStyle: TTextStyle;
 padding: integer;
begin

 with (Sender as TStringGrid) do
  begin
   padding:=0;

  // Разный цвет для чётных/нечётных строк
  if (ARow mod 2)=0
   then Canvas.Brush.Color:=HexToInt('eceeff')
   else Canvas.Brush.Color:=HexToInt('fbfbfb');

  // Выделенная строка
  if (gdSelected in aState) then
   begin
    Canvas.Brush.Color:=HexToInt('d6f3d5');
    Canvas.Font.Color:=HexToInt('000000');
   end;

   Canvas.FillRect(aRect);    // очистка канвы
   xStyle:=Canvas.TextStyle;  // исходный стиль отрисовки текста

   // Таблица валют
   if Sender=CurGrid then
    begin
     if (ACol=3) or (ACol=2)
      then xStyle.Alignment:=taCenter
      else xStyle.Alignment:=taLeftJustify;
      // padding:=CurGridHeader.Sections[0].Width+5;

     if Acol=3 then
      if Length(CurGrid.Cells[4,ARow])>0 then
       if StrToInt(CurGrid.Cells[4,ARow])=0
        then Canvas.Font.Color:=clBlack
        else
         if StrToInt(CurGrid.Cells[4,ARow])=-1
          then Canvas.Font.Color:=clRed
          else Canvas.Font.Color:=clGreen;
    end;

   // Таблица пользователей
   if Sender=UserGrid then
    begin
     if (ACol=3) or (ACol=2)
      then xStyle.Alignment:=taCenter
      else xStyle.Alignment:=taLeftJustify;

     if ACol=1 then
      begin
       if Cells[2, ARow]<>'0' then
        begin
         GridIconsImageList.Draw(Canvas, aRect.Left+1, aRect.Top+1, 1);
         padding:=20;
        end;
      end;
    end;

   // Таблица счетов
   if Sender=BillGrid then
    begin
     if (ACol=3) or (ACol=4) or (ACol=5)
      then xStyle.Alignment:=taCenter
      else xStyle.Alignment:=taLeftJustify;

     if (Acol=5) and (Length(Cells[0,ARow])<>0) then
      if StrToCurr(BillGrid.Cells[5,ARow])<0
        then Canvas.Font.Color:=clRed;
    end;

   // Таблица корзины (в диалоге редактирования расхода)
   if Sender=AddRasForm.BasketGrid then
    begin
     if (ACol=1) or (ACol=2)
      then xStyle.Alignment:=taCenter
      else xStyle.Alignment:=taLeftJustify;
     if ACol=3 then padding:=227;
    end;

   Canvas.TextRect(aRect, padding+2, 0, Cells[ACol, ARow], xStyle);
 end;

end;

procedure TMainForm.MeasureGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
 if MeasureGrid.Cells[0,ARow]='0'
 then DelIzmButton.Enabled:=false
 else DelIzmButton.Enabled:=true;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
 if PageControl1.ActivePage=TabSheet3 then GetBillList;
 if PageControl1.ActivePage=TabSheet5 then
  begin
   GetMainTable;
   SetHeaderWidths(MainGrid);
  end;
end;

procedure TMainForm.RasTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
 if (RasTreeView.Selected=nil) then exit;
 if (Integer(RasTreeView.Selected.Data)=0) or (Integer(RasTreeView.Selected.Data)=1)
  then
   begin
    DelCatRasButton.Enabled:=false;
    EditCatRasButton.Enabled:=false;
   end
  else
   begin
    DelCatRasButton.Enabled:=true;
    EditCatRasButton.Enabled:=true;
   end;
end;

procedure TMainForm.ReportBoxDrawItem(Control: TWinControl; Index: Integer;
 ARect: TRect; State: TOwnerDrawState);
var
  sep_pos: Integer; // Флаг символа-разделителя
  TabW, TxtW: integer;
  txt, txt2: string;
begin

 with ReportBox do
  begin
   txt:=Items[Index];

    Canvas.Brush.Color:=clWindow;
    if Length(txt)>=1 then
    if (idx = index) and (txt[1]<>'!')
     then Canvas.Font.Color:=clHighlight
     else Canvas.Font.Color:=clWindowText;

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
   if sep_pos=0 then Canvas.TextOut(ARect.Left, ARect.Top, txt)
   else
    begin
     // отрезаем "хвост"
     txt2:=Copy(txt, sep_pos+1, Length(txt+' '));
     txt:=Copy(txt, 1, sep_pos-1);
     // Вычисляем отступ
     TabW:=ClientWidth-Canvas.TextWidth(' '+txt2)-1;
     TxtW:=Canvas.TextWidth(txt+' ');
     // Рисуем "подчёркивание"
     Canvas.TextOut(ARect.Left+TxtW, ARect.Top, '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ');
     // рисуем текст в два захода
     Canvas.TextOut(ARect.Left, ARect.Top, txt+' ');
     Canvas.TextOut(ARect.Left+TabW, ARect.Top, ' '+txt2);
     //
    end;
  end;
end;

// Определение пункта списка статистики, над которым находится курсор
procedure TMainForm.ReportBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  idx:=ReportBox.ItemAtPos(Point(X,Y), True);
  if idx=idx_old then exit;
  idx_old:=idx;
  ReportBox.Repaint;
end;

procedure TMainForm.ReportBoxMouseLeave(Sender: TObject);
begin
  idx:=-1;
  ReportBox.Repaint;
end;

procedure TMainForm.SelectUserButtonClick(Sender: TObject);
begin
 Select_user_flag:=true;
 SplashForm.ShowModal;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
 i: TFormatSettings;
begin
 i.LongTimeFormat:='hh:nn:ss';
 i.TimeSeparator:=':';
 TimeLabel.Caption:='Сегодня: '+DateToStr(Date)+' '+TimeToStr(Time, i);
end;

procedure TMainForm.TransCurBtnClick(Sender: TObject);
begin
 if BillGrid.RowCount>1
  then TransCurForm.ShowModal
  else MessageDlg('Перевод средств','Для перевода средств со счёта на счёт'+#10#13+'необходимы как минимум два счёта.',mtInformation,[mbOK],'');
end;

procedure TMainForm.TypeCharGroupClick(Sender: TObject);
begin
 DrawChart;
end;

procedure TMainForm.GridUsersSelectSelect(Sender: TObject);
begin
 GetMainTable;
end;

procedure TMainForm.UserComboBoxSelect(Sender: TObject);
begin
 DrawChart;
 DrawDiagram;
 DrawReport;
 OutputBalans;
end;

procedure TMainForm.GridPeriodSelectSelect(Sender: TObject);
begin
 case GridPeriodSelect.ItemIndex of
  0: tb_date:=DateTimeToUnixTime(Date);
  1: tb_date:=DateTimeToUnixTime(Date)-86400*7;
  2: tb_date:=DateTimeToUnixTime(Date)-86400*30;
  3: tb_date:=DateTimeToUnixTime(Date)-86400*365;
 end;
 GetMainTable;
end;

procedure TMainForm.PeriodBoxSelect(Sender: TObject);
begin
 case PeriodBox.ItemIndex of
  0: dr_date:=DateTimeToUnixTime(Date);
  1: dr_date:=DateTimeToUnixTime(Date)-86400*7;
  2: dr_date:=DateTimeToUnixTime(Date)-86400*30;
  3: dr_date:=DateTimeToUnixTime(Date)-86400*365;
 end;

 DrawChart;
end;

procedure TMainForm.UserGridDblClick(Sender: TObject);
begin
 EditUserButtonClick(self);
end;

procedure TMainForm.UserGridDrawCell(Sender: TObject; aCol, aRow: Integer;
 aRect: TRect; aState: TGridDrawState);
begin
  MeasureGridDrawCell(UserGrid, Acol, Arow, aRect, aState);
end;

// Проверка: текущий пользователь не может удалить сам себя
procedure TMainForm.UserGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
 // Проверяем возможность преобразования
 if not TryStrToInt(UserGrid.Cells[0,ARow], user_id) then exit;

 if (StrToInt(UserGrid.Cells[0,ARow])=user_id)
  then DelUserButton.Enabled:=false
  else DelUserButton.Enabled:=true;
end;

// Обновление столбца курсов валют
procedure TMainForm.ValutButtonClick(Sender: TObject);
var
 i: integer;
 kurs: Currency;
 cur_user_ID: string;
begin
 SQL_db.BeginTransaction;

 for i:=1 to CurGrid.RowCount-1 do
  with CurGrid do
   begin
    cur_user_ID:=CurGrid.Cells[0, i];
    kurs:=GetCurFromWeb(Cells[2, i]);

    if (kurs<>-1) then
    begin
     if StrToCurr(Cells[3, i])<>kurs then
      begin
       if (StrToCurr(Cells[3, i])<kurs)
       then CurGrid.Cells[4, i]:='1'
       else CurGrid.Cells[4, i]:='-1';

       Cells[3, i]:=CurrToStr(kurs);
       SQL_db.ExecSQL('UPDATE valut SET kurs = "'+Cells[3, i]+'" WHERE id ='+cur_user_ID);
      end
     else CurGrid.Cells[4, i]:='0';
    end
    else CurGrid.Cells[4, i]:='0';
    Application.ProcessMessages;
   end;
 SQL_db.Commit;

 OutputBalans;
end;

// Добавление единицы измерения
procedure TMainForm.AddIzmButtonClick(Sender: TObject);
begin
 Add_flag:=true;
 MeasureAddForm.ShowModal;
end;

// Добавление подкатегории дохода
procedure TMainForm.AddPodcatDohButtonClick(Sender: TObject);
var
 temp_table: TSQLiteTable;
begin
 temp_table:=SQL_db.GetTable('SELECT id FROM cat_doh WHERE (id!=0) and (parent=-1)');
 if temp_table.Count<=0 then
  begin
   MessageDlg('Добавление подкатегории','Вы не можете добавить подкатегорию,'+#10#13+'так как не существует ни одной категории.',mtInformation,[mbOK],'');
   exit;
  end;

 Add_flag:=true;
 Cat_flag:=false;
 if (DohTreeView.Selected=nil) then DohTreeView.TopItem.Selected:=True;

 AddCatForm.AddCat(DohTreeView,'cat_doh');
end;

// Добавление подкатегории расхода
procedure TMainForm.AddPodcatRasButtonClick(Sender: TObject);
var
 temp_table: TSQLiteTable;
begin
 temp_table:=SQL_db.GetTable('SELECT id FROM cat_ras WHERE (id!=0) and (id!=1) and (parent=-1)');
 if temp_table.Count<=0 then
  begin
   MessageDlg('Добавление подкатегории','Вы не можете добавить подкатегорию,'+#10#13+'так как не существует ни одной категории.',mtInformation,[mbOK],'');
   exit;
  end;

 Add_flag:=true;
 Cat_flag:=false;
 if (RasTreeView.Selected=nil) then RasTreeView.TopItem.Selected:=True;

 AddCatForm.AddCat(RasTreeView,'cat_ras');
end;

// Добавление расхода
procedure TMainForm.AddRashodExecute(Sender: TObject);
var
 text: string;
 temp_table: TSQLiteTable;
begin
 text:='';

 temp_table:=SQL_db.GetTable('SELECT id FROM cat_ras WHERE (id!=0) and (id!=1)');
 if temp_table.Count<=0 then text:=' ни одной категории';

 temp_table:=SQL_db.GetTable('SELECT id FROM bill');
 if temp_table.Count<=0 then
  if Length(text)>0
   then text:=text+' и ни одного счёта'
   else text:=' ни одного счёта';

 if Length(text)>0
 then
  begin
   MessageDlg('Добавление расхода','Вы не можете добавить расход, так как не'+#10#13+'существует'+text+'.',mtInformation,[mbOK],'');
   exit;
  end;

 Add_flag:=true;
 AddRasForm.ShowModal;
end;

// Отображение формы изменения записи при двойном щелчке на записи
procedure TMainForm.BillGridDblClick(Sender: TObject);
begin
 if EditBillButton.Enabled then EditBillButtonClick(self);
end;

procedure TMainForm.BillGridDrawCell(Sender: TObject; aCol, aRow: Integer;
 aRect: TRect; aState: TGridDrawState);
begin
 MeasureGridDrawCell(BillGrid, Acol, Arow, aRect, aState);
end;

procedure TMainForm.CatBoxSelect(Sender: TObject);
begin
 DrawChart;
end;

procedure TMainForm.CorrectBtnClick(Sender: TObject);
begin
 CorrectForm.ShowModal;
end;

procedure TMainForm.Chart2AxisList0MarkToText(var AText: String; AMark: Double);
var
 fs: TFormatSettings;
 CurDate: LongInt;
 PrevDate: LongInt;
begin
 with fs do
   begin
    DateSeparator:='/';
    ShortDateFormat:='d.m';
    LongDateFormat:='d.m';
   end;
  CurDate:=DateTimeToUnixTime(Date);

  if AMark=0 then AText:=DateToStr(Date, fs)
  else
   begin
    PrevDate:=CurDate-(Round(AMark)*86400);
    AText:=DateToStr(UnixTimeToDateTime(PrevDate), fs);
   end;
end;

// Запуск калькулятора (Win)
procedure TMainForm.CulcButtonClick(Sender: TObject);
begin
 // Полный путь, т.к. команда calc вызывает установленный OpenOffice/LibreOffice Calc
 ShellExecute(0, nil, PChar('c:\Windows\System32\calc.exe'),'',nil,1)
end;

procedure TMainForm.CurGridDblClick(Sender: TObject);
begin
 if EditCurButton.Enabled then EditCurButtonClick(self);
end;

procedure TMainForm.CurGridDrawCell(Sender: TObject; aCol, aRow: Integer;
 aRect: TRect; aState: TGridDrawState);
begin
 MeasureGridDrawCell(CurGrid, Acol, Arow, aRect, aState);
end;

// Проверка: пользователь не может удалить валюту "Рубль"
procedure TMainForm.CurGridSelectCell(Sender: TObject; ACol, ARow: Integer;
 var CanSelect: Boolean);
begin
  if (CurGrid.Cells[0,ARow]='0')
  then
   begin
    DelCurButton.Enabled:=false;
    EditCurButton.Enabled:=false;
   end
  else
   begin
    DelCurButton.Enabled:=true;
    EditCurButton.Enabled:=true;
   end;
end;

// Удаление счёта
procedure TMainForm.DelBillButtonClick(Sender: TObject);
var
 Allow, Cur, count_doh, count_ras: integer;
 temp_table: TSQLiteTable;
begin
  Cur:=BillGrid.Row;
  if (Cur<0) then exit;

  temp_table:=SQL_db.GetTable('SELECT id FROM dohod WHERE bill='+BillGrid.Cells[0,BillGrid.Row]);
  count_doh:=temp_table.Count;

  temp_table:=SQL_db.GetTable('SELECT id FROM rashod WHERE bill='+BillGrid.Cells[0,BillGrid.Row]);
  count_ras:=temp_table.Count;

  if (count_doh>0) or (count_ras>0)
   then
    begin
    MessageDlg('Удаление счёта','Вы не можете удалить счёт "'+BillGrid.Cells[1,BillGrid.Row]+'", так как'+#10#13+'существуют доходы/расходы, относящиеся к нему.',mtInformation,[mbOK],'');
    exit;
    end;

  Allow:=MessageDlg('Удаление счёта','Вы уверены, что хотите удалить счёт "'+BillGrid.Cells[1, BillGrid.Row]+'"?',mtWarning,mbYesNo,0);
  if not (Allow=IDYES) then exit;

  SQL_db.BeginTransaction;
  SQL_db.ExecSQL('DELETE FROM bill WHERE id='+BillGrid.Cells[0, BillGrid.Row]);
  SQL_db.Commit;

  BillGrid.DeleteRow(BillGrid.Row);
  //GetBillList;
  BillGrid.Row:=Cur;
end;

// Удаление категории дохода
procedure TMainForm.DelCatDohButtonClick(Sender: TObject);
var
 Allow, count: integer;
 DelNode: string;
 temp_table: TSQLiteTable;
begin
   if (DohTreeView.Selected=nil) then exit;

   DelNode:=IntToStr(Integer(DohTreeView.Selected.Data));
   temp_table:=SQL_db.GetTable('SELECT id FROM dohod WHERE cat='+DelNode);
   count:=temp_table.Count;

   if count>0
   then
    begin
    MessageDlg('Удаление категории дохода','Вы не можете удалить категорию "'+DohTreeView.Selected.Text+'",'+#10#13+'так как существуют доходы, относящиеся к ней.',mtInformation,[mbOK],'');
    exit;
    end;

   Allow:=MessageDlg('Удаление категории дохода','Вы уверены, что хотите удалить категорию "'+DohTreeView.Selected.Text+'"?',mtWarning,mbYesNo,0);
   if not (Allow=IDYES) then exit;

   SQL_db.BeginTransaction;
   SQL_db.ExecSQL('DELETE FROM cat_doh WHERE id='+DelNode);
   SQL_db.ExecSQL('DELETE FROM cat_doh WHERE parent='+DelNode);
   SQL_db.Commit;

   DohTreeView.Selected.Delete;
end;

// Удаление категории расхода
procedure TMainForm.DelCatRasButtonClick(Sender: TObject);
var
 Allow, count: integer;
 DelNode: string;
 temp_table: TSQLiteTable;
begin
   if (RasTreeView.Selected=nil) then exit;

   DelNode:=IntToStr(Integer(RasTreeView.Selected.Data));

   temp_table:=SQL_db.GetTable('SELECT id FROM rashod WHERE cat='+DelNode);
   count:=temp_table.Count;

   if count>0
   then
    begin
    Allow:=MessageDlg('Удаление категории расхода','Вы не можете удалить категорию "'+RasTreeView.Selected.Text+'",'+#10#13+'так как существуют расходы, относящиеся к ней.',mtInformation,[mbOK],'');
    exit;
    end;

   Allow:=MessageDlg('Удаление категории расхода','Вы уверены, что хотите удалить категорию "'+RasTreeView.Selected.Text+'"?',mtWarning,mbYesNo,0);
   if not (Allow=IDYES) then exit;

   SQL_db.BeginTransaction;
   SQL_db.ExecSQL('DELETE FROM cat_ras WHERE id='+DelNode);
   SQL_db.ExecSQL('DELETE FROM cat_ras WHERE parent='+DelNode);
   SQL_db.Commit;

   RasTreeView.Selected.Delete;
end;

// Удаление валюты
procedure TMainForm.DelCurButtonClick(Sender: TObject);
var
 Allow, Cur, count: integer;
 temp_table: TSQLiteTable;
begin
 Cur:=CurGrid.Row;
 if (Cur<0) then exit;

 temp_table:=SQL_db.GetTable('SELECT id FROM bill WHERE valut='+CurGrid.Cells[0,CurGrid.Row]);
 count:=temp_table.Count;

 if count>0
  then
   begin
    MessageDlg('Удаление валюты','Вы не можете удалить валюту "'+CurGrid.Cells[1,CurGrid.Row]+'", так как'+#10#13+'существуют счета, относящиеся к ней.',mtInformation,[mbOK],'');
    exit;
   end;

 Allow:=MessageDlg('Удаление валюты','Вы уверены, что хотите удалить валюту "'+CurGrid.Cells[1, CurGrid.Row]+'"?',mtWarning,mbYesNo,0);
 if not (Allow=IDYES) then exit;

 SQL_db.BeginTransaction;
 SQL_db.ExecSQL('DELETE FROM valut WHERE id='+CurGrid.Cells[0, CurGrid.Row]);
 SQL_db.Commit;

 CurGrid.DeleteRow(CurGrid.Row);
 CurGrid.Row:=Cur;
end;


// Удаление дохода
procedure TMainForm.DeleteDohod(xID: integer);
var
 Allow: integer;
 balans, sum: real;
 bill_ID: string;
 temp_table: TSQLiteTable;
 msg: string;
begin
 DeleteFlag:=true;

 // формируеми текст предупреждения
 msg:=MainGrid.Cells[1, ActRow];
 if Length(MainGrid.Cells[3, ActRow])>0 then msg:=msg+': '+MainGrid.Cells[3, ActRow];
 Allow:=MessageDlg('Удаление дохода','Вы уверены, что хотите удалить доход "'+msg+'"?',mtWarning,mbYesNo,0);
 if not (Allow=IDYES) then
  begin
   DeleteFlag:=false;
   exit;
  end;

 SQL_db.BeginTransaction;
 // ID счёта
 temp_table:=SQL_db.GetTable('SELECT * FROM dohod WHERE id='+IntToStr(xID));
 bill_ID:=temp_table.FieldAsString('bill');
 // сумма (для изменения баланса)
 sum:=StrToCurr(temp_table.FieldAsString('sum'));
 // текущий баланс счёта
 temp_table:=SQL_db.GetTable('SELECT balans FROM bill WHERE id='+bill_ID);
 balans:=StrToCurr(temp_table.FieldAsString('balans'));
 // вычисляем новый баланс
 balans:=balans-sum;
 // внесение изменений в БД
 SQL_db.ExecSQL('UPDATE bill SET balans = "'+CurrToStr(balans)+'" WHERE id ='+bill_ID);
 SQL_db.ExecSQL('DELETE FROM dohod WHERE id='+IntToStr(xID));
 SQL_db.Commit;
 // Перерисовка основной сетки
 MainGrid.Rows[ActRow].Clear;
 MainGrid.DeleteRow(ActRow);
 //
 MainGrid.Row:=ActRow;
 DeleteFlag:=false;
end;

// Удаление расхода
procedure TMainForm.DeleteRashod(xID: integer);
var
 Allow: integer;
 msg: string;
begin
 DeleteFlag:=true;

 // формируеми текст предупреждения
 msg:=MainGrid.Cells[1, ActRow];
 if Length(MainGrid.Cells[3, ActRow])>0 then msg:=msg+': '+MainGrid.Cells[3, ActRow];
 Allow:=MessageDlg('Удаление расхода','Вы уверены, что хотите удалить расход "'+msg+'"?',mtWarning,mbYesNo,0);
 if not (Allow=IDYES) then
  begin
   DeleteFlag:=false;
   exit;
  end;

 // Корректируем баланс счёта
 MinusBalans(IntToStr(xID));
 SQL_db.BeginTransaction;
 SQL_db.ExecSQL('DELETE FROM rashod WHERE id='+IntToStr(xID));
 SQL_db.Commit;
 // Перерисовка основной сетки
 MainGrid.Rows[ActRow].Clear;
 MainGrid.DeleteRow(ActRow);
 //
 MainGrid.Row:=ActRow;
 DeleteFlag:=false;
end;

// Удаление корзины расходов
procedure TMainForm.DeleteBasket(basketID: integer);
var
 Allow, i: integer;
 SQL_table: TSQLiteTable;
 msg: string;
begin
 DeleteFlag:=true;

 // формируеми текст предупреждения
 msg:=MainGrid.Cells[1, ActRow];
 if Length(MainGrid.Cells[3, ActRow])>0 then msg:=msg+': '+MainGrid.Cells[3, ActRow];
 Allow:=MessageDlg('Удаление расхода','Вы уверены, что хотите удалить корзину "'+msg+'"?',mtWarning,mbYesNo,0);
 if not (Allow=IDYES) then
  begin
   DeleteFlag:=false;
   exit;
  end;

 // Корректировка баланса
 SQL_db.BeginTransaction;
 SQL_table:=SQL_db.GetTable('SELECT * FROM rashod WHERE basket='+IntToStr(basketID));
 for i:=0 to SQL_table.Count-1 do
  begin
   MinusBalans(SQL_table.FieldAsString('id'));
   SQL_table.Next;
  end;
 // Удаление записей о расходах, входящих в корзину
 SQL_db.ExecSQL('DELETE FROM rashod WHERE basket='+IntToStr(basketID));
 SQL_db.Commit;
 // Перерисовка основной сетки
 MainGrid.Rows[ActRow].Clear;
 MainGrid.DeleteRow(ActRow);
 //
 MainGrid.Row:=ActRow;
 DeleteFlag:=false;
end;

// Корректировка баланса (при удалении расхода)
procedure TMainForm.MinusBalans(ras_ID: string);
var
 balans, num, price: real;
 bill_ID: string;
 temp_table: TSQLiteTable;
begin
 // Получаем данные об удаляемом расходе
 temp_table:=SQL_db.GetTable('SELECT * FROM rashod WHERE id='+ras_ID);
 bill_ID:=temp_table.FieldAsString('bill');
 price:=StrToCurr(temp_table.FieldAsString('price'));
 num:=StrToCurr(temp_table.FieldAsString('num'));
 // Получаем данные о состоянии счёта
 temp_table:=SQL_db.GetTable('SELECT balans FROM bill WHERE id='+bill_ID);
 balans:=StrToCurr(temp_table.FieldAsString('balans'));
 // корректируем баланс счёта
 balans:=balans+price*num;
 SQL_db.ExecSQL('UPDATE bill SET balans = "'+CurrToStr(balans)+'" WHERE id ='+bill_ID);
end;

// Добавление валюты
procedure TMainForm.AddCurButtonClick(Sender: TObject);
begin
 Add_flag:=true;
 CurAddForm.ShowModal;
end;

// Добавление дохода
procedure TMainForm.AddDohodExecute(Sender: TObject);
var
 text: string;
 temp_table: TSQLiteTable;
begin
 text:='';

 temp_table:=SQL_db.GetTable('SELECT id FROM cat_doh WHERE id!=0');
 if temp_table.Count<=0 then text:=' ни одной категории';

 temp_table:=SQL_db.GetTable('SELECT id FROM bill');
 if temp_table.Count<=0 then
  if Length(text)>0
   then text:=text+' и ни одного счёта'
   else text:=' ни одного счёта';

 if Length(text)>0
 then
  begin
   MessageDlg('Добавление расхода','Вы не можете добавить расход, так как не'+#10#13+'существует'+text+'.',mtInformation,[mbOK],'');
   exit;
  end;

 Add_flag:=true;
 AddDohForm.ShowModal;
end;

// Добавление категории дохода
procedure TMainForm.AddCatDohButtonClick(Sender: TObject);
begin
 Add_flag:=true;
 Cat_flag:=true;
 AddCatForm.AddCat(DohTreeView,'cat_doh');
end;

procedure TMainForm.AddCatRasButtonClick(Sender: TObject);
begin
 Add_flag:=true;
 Cat_flag:=true;
 AddCatForm.AddCat(RasTreeView,'cat_ras');
end;

// Удаление единицы измерения
procedure TMainForm.DelIzmButtonClick(Sender: TObject);
 var
 Allow, Cur, count: integer;
 temp_table: TSQLiteTable;
begin
 Cur:=MeasureGrid.Row;
 if (Cur<0) then exit;

 temp_table:=SQL_db.GetTable('SELECT id FROM rashod WHERE izm='+MeasureGrid.Cells[0,MeasureGrid.Row]);
 count:=temp_table.Count;

 if count>0
  then
   begin
    MessageDlg('Удаление единицы измерения','Вы не можете удалить единицу "'+MeasureGrid.Cells[1,MeasureGrid.Row]+'", так как'+#10#13+'существуют расходы, относящиеся к ней.',mtInformation,[mbOK],'');
    exit;
   end;

 Allow:=MessageDlg('Удаление единицы измерения','Вы уверены, что хотите удалить единицу "'+MeasureGrid.Cells[1, MeasureGrid.Row]+'"?',mtWarning,mbYesNo,0);
 if not (Allow=IDYES) then exit;

 SQL_db.BeginTransaction;
 SQL_db.ExecSQL('DELETE FROM izm WHERE id='+MeasureGrid.Cells[0, MeasureGrid.Row]);
 SQL_db.Commit;

 MeasureGrid.DeleteRow(MeasureGrid.Row);
 MeasureGrid.Row:=Cur;
end;


// Удаление пользователя
procedure TMainForm.DelUserButtonClick(Sender: TObject);
var
 Allow, Cur: integer;
 count: integer;
 temp_table: TSQLiteTable;
begin
 Cur:=UserGrid.Row;
 if (Cur<0) then exit;

 temp_table:=SQL_db.GetTable('SELECT id FROM bill WHERE user='+UserGrid.Cells[0,UserGrid.Row]);
 count:=temp_table.Count;

 if count>0
  then
   begin
    MessageDlg('Удаление пользователя','Вы не можете удалить пользователя "'+UserGrid.Cells[1,UserGrid.Row]+'", так как'+#10#13+'существуют счета, относящиеся к нему.',mtInformation,[mbOK],'');
    exit;
   end;

 Allow:=MessageDlg('Удаление пользователя','Вы уверены, что хотите удалить пользователя "'+UserGrid.Cells[1, UserGrid.Row]+'"?',mtWarning,mbYesNo,0);
 if not (Allow=IDYES) then exit;

 SQL_db.BeginTransaction;
 SQL_db.ExecSQL('DELETE FROM users WHERE id='+UserGrid.Cells[0, UserGrid.Row]);
 SQL_db.Commit;

 UserGrid.DeleteRow(UserGrid.Row);
 //GetUserList;
 UserGrid.Row:=Cur;
end;

procedure TMainForm.HintTimerTimer(Sender: TObject);
begin
 if AutoSelect or DeleteFlag or (AddDohForm.Visible) or (AddRasForm.Visible) then exit;

 if not HintForm.Visible=true then
   begin
    HintForm.Visible:=true;
    MainGrid.SetFocus;
   end
  else
   begin
    HintForm.Left:=HintX;
    HintForm.Top:=HintY;
   end;
end;

procedure TMainForm.MeasureCheckBoxChange(Sender: TObject);
var
 OpMeasure: boolean;
begin
 AddRasForm.IzmBox.ItemIndex:=0;

 OpMeasure:=MeasureCheckBox.Checked;
 MeasureBox.Visible:=OpMeasure;
 AddRasForm.IzmBox.Enabled:=OpMeasure;

 SetIniBool('measure','on',OpMeasure,DataDir+'options.ini');
end;

procedure TMainForm.MainGridClick(Sender: TObject);
var
 xID: integer;
begin
 // исключаем случайное или повтороное срабатывание функции
 if AutoSelect or DeleteFlag then exit;
 if (CurRow=-1) or (MainGrid.Row=-1) then exit;

 // ID выбранной записи
 xID:=(MainGrid.Objects[0, ActRow] as TItemData).ID;

 // тип выбранной записи
 case CurCol of
  4: // кнопка "Редактировать"
  case (MainGrid.Objects[0, ActRow] as TItemData).xType of
    itDohod:
     begin
      Add_flag:=false;
      AddDohForm.ShowModal;
     end;
    itRashod:
     begin
      Add_flag:=false;
      AddRasForm.ShowModal;
     end;
  end;
  6: // кнопка "Удалить"
  case (MainGrid.Objects[0, ActRow] as TItemData).xType of
   itDohod: DeleteDohod(xID);
   itRashod: DeleteRashod(xID);
  end
  // при щелчке на прочих ячейках (не кнопках) - ничего не делаем
  else exit;
  end;
end;


// Отрисовка осовной сетки расходов и доходов
procedure TMainForm.MainGridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
 //xStyle: TTextStyle;
// padding: integer;
 txt: string;
 NeedText: boolean = true;
 IconIndex: byte;

 function TextToDateText(txt: string): string;
 begin
  result:=DateToStr(UnixTimeToDateTime(StrToInt64(txt)));
 end;

begin
  with MainGrid as TStringGrid do
   begin
    //xStyle:=Canvas.TextStyle;
    txt:=Cells[Acol, Arow];

    // Разные цвет для чётных/нечётных строк
    if (ARow mod 2)=1
     then Canvas.Brush.Color:=HexToInt('fbfbfb')
     else Canvas.Brush.Color:=HexToInt('eceeff');

    // Выделенная строка
    if (gdSelected in aState) and (CurRow<>-1) then
     begin
      Canvas.Brush.Color:=HexToInt('d6f3d5');
      Canvas.Font.Color:=HexToInt('000000');
     end;

    // Готовим канву к отрисовке
    Canvas.FillRect(aRect);

    // Рисуем "кнопку" редактирования
    if (ACol=4) and (CurRow=aRow) then
     begin
      // вид кнопки - нажата или нет
      if (CursorDown) and (CurCol=ACol) then
        begin
         // нажата
         GridButtonsImageList.Draw(Canvas, aRect.Left, aRect.Top+4, 1);
         ButtonsIconsImageList.Draw(Canvas, Arect.Left+5, Arect.Top+6, 0);
        end
       else
        begin
         // не нажата
         GridButtonsImageList.Draw(Canvas, aRect.Left, aRect.Top+4, 0);
         ButtonsIconsImageList.Draw(Canvas, Arect.Left+5, Arect.Top+5, 0);
        end;

      NeedText:=false; // отключаем отрисовку текста
     end;

    // Рисуем "кнопку" удаления
    if (ACol=6) and (CurRow=Arow) then
     begin
      // вид кнопки - нажата или нет
      if (CursorDown) and (CurCol=ACol) then
        begin
         // нажата
         GridButtonsImageList.Draw(Canvas, Arect.Left, Arect.Top+4, 1);
         ButtonsIconsImageList.Draw(Canvas, Arect.Left+6, Arect.Top+7, 1);
        end
       else
        begin
         // не нажата
         GridButtonsImageList.Draw(Canvas, Arect.Left, Arect.Top+4, 0);
         ButtonsIconsImageList.Draw(Canvas, Arect.Left+6, Arect.Top+6, 1);
        end;
      NeedText:=false; // отключаем отрисовку текста
     end;

    // Выделяем сумму зелёным/красным цветом
    if (Acol=2) and (Objects[0, Arow]<>nil) then
     begin
      case (Objects[0, Arow] as TItemData).xType of
       itRashod: Canvas.Font.Color:=clRed;  // красный - для расходов
       itDohod: Canvas.Font.Color:=clGreen; // зелёный - для доходов
       //itOperation: Canvas.Font.Color:=clGreen; // ??? - для операций
       else Canvas.Font.Color:=clBlack;      // в прочих ячейках цвет текста - чёрный
      end; // case
     end;

    Canvas.Font.Style:=Canvas.Font.Style-[fsBold];
    // Первая колонка
    if (Acol=0) and (Objects[0, Arow]<>nil) then
     begin
      // Преобразование даты/времени
      txt:=TextToDateText(txt);

      // Выбираем значок
      case (Objects[0, Arow] as TItemData).xType of
       itRashod: IconIndex:=3; // для расходов
       itDohod: IconIndex:=2;  // для доходов
       itOperation: IconIndex:=4; // ??? - для операций
       else Canvas.Font.Color:=clBlack;      // в прочих ячейках цвет текста - чёрный
      end; // case
      // если в корзине 1 расход
      if (Integer(Objects[2, Arow])<=1) and (IconIndex=0) then IconIndex:=3;
      // Визуально скрываем дублиующиеся даты
      if (Arow>0) then
       if TextToDateText(Cells[0, ARow]) = TextToDateText(Cells[0, ARow-1])
        then Canvas.Font.Color:=$00D7D7D7
        else Canvas.Font.Color:=clWindowText;
     end;

    // Отрисовка текста
    if NeedText then
     begin
      // В столбце даты добавляем индикатор типа операции (расход/доход)
      if (ACol=0) then
       begin
        GridIconsImageList.Draw(Canvas, Arect.Left+6, Arect.Top+6, IconIndex);
        Canvas.TextOut(aRect.Left+30, aRect.Top+2, txt);
       end
      else Canvas.TextOut(aRect.Left, aRect.Top+2, txt);
     end;

   end;
end;

procedure TMainForm.MainGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 CursorDown:=true;
 ActRow:=CurRow;
 MainGrid.Repaint;
end;

// Отключение выделения при выходе курсора
procedure TMainForm.MainGridMouseLeave(Sender: TObject);
begin
 if AutoSelect or DeleteFlag then exit;

 HintForm.Visible:=false;
 HintTimer.Enabled:=false;
 //
 if CurRow=-1 then exit
 else
  begin
   CurRow:=-1;
  // MainGrid.Row:=-1;
   MainGrid.Repaint;
  end;
end;

procedure TMainForm.MainGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
 r: integer = 0;
 c: integer = 0;
begin
 if (CursorDown) and ((CurCol=4) or (CurCol=5) or (CurCol=6) or (CurCol=7)) then exit;

 AutoSelect:=true;
 //
 HintX:=(Left+PageControl1.Left)+X+50;
 HintY:=(Top+PageControl1.Top+DohBox.Top+MainGrid.Top)+Y+80+GetSystemMetrics(SM_CYCAPTION);
 //
 MainGrid.MouseToCell(x, y, c, r);

 if (CurRow <> r) then
  begin
   HintForm.Visible:=false;
   HintTimer.Enabled:=false;
  end;

  if ((CurRow <> r) or(CurCol <> c)) then
     begin
       CurRow:= r;
       CurCol:= c;
       sleep(50);
       MainGrid.Row:=CurRow;
//       CursorDown:=false;
       MainGrid.Repaint;
     end;
  AutoSelect:=false;

  //
  if (CurCol=4) or (CurCol=5) or (CurCol=6) or (CurCol=6) then
   begin
    HintForm.Visible:=false;
    HintTimer.Enabled:=false;
   end;

  HintForm.Left:=HintX;
  HintForm.Top:=HintY;
  HintTimer.Enabled:=true;
end;

procedure TMainForm.MainGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 CursorDown:=false;
 MainGrid.Repaint;
end;

procedure TMainForm.MainGridMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 AutoSelect:=true;
 MainGridMouseLeave(self);
 AutoSelect:=false;
end;

// Построение списка категорий для фильтра
procedure TMainForm.DrawCatBox(table_cat: string);
var
 i: integer;
 main_table: TSQLiteTable;
 temp_table: TSQLiteTable;
begin
 CatBox.Clear;

 main_table:=SQL_db.GetTable('SELECT id, name FROM '+table_cat+' WHERE parent=-1');

 for i:=0 to main_table.Count-1 do
  begin
   // пропускаем служебные категории
   if main_table.FieldAsInteger('id')=0
    then CatBox.Items.Add('Все категории')
    else
     begin
      temp_table:=SQL_db.GetTable('SELECT id FROM '+table_cat+' WHERE parent='+main_table.FieldAsString('id'));
      if temp_table.Count<>0 then
      begin
       CatBox.Items.Add(main_table.FieldAsString('name'));
       CatBox.Items.Objects[CatBox.Items.Count-1]:=TObject(main_table.FieldAsInteger('id'));
      end;
     end;
   main_table.Next;
  end;
 CatBox.ItemIndex:=0;
end;

procedure TMainForm.DohRadioButtonClick(Sender: TObject);
begin
 if DohRadioButton.Checked=true
  then DrawCatBox('cat_doh')
  else DrawCatBox('cat_ras');

 DrawChart;
end;

procedure TMainForm.DohTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if (DohTreeView.Selected=nil) then exit;
  if (Integer(DohTreeView.Selected.Data)=0)
  then
   begin
    DelCatDohButton.Enabled:=false;
    EditCatDohButton.Enabled:=false
   end
  else
   begin
    DelCatDohButton.Enabled:=true;
    EditCatDohButton.Enabled:=true;
   end;
end;

procedure TMainForm.DohTreeViewDblClick(Sender: TObject);
begin
 EditCatDohButtonClick(self);
end;

// Изменение счёта
procedure TMainForm.EditBillButtonClick(Sender: TObject);
begin
 Add_flag:=false;
 BillAddForm.ShowModal;
end;

// Изменение категории дохода
procedure TMainForm.EditCatDohButtonClick(Sender: TObject);
begin
 Add_flag:=false;
 if (DohTreeView.Selected=nil) or (EditCatDohButton.Enabled=false) then exit;
 if (DohTreeView.Selected.Parent=nil)
  then Cat_flag:=true
  else Cat_flag:=false;
 AddCatForm.AddCat(DohTreeView,'cat_doh');
end;

// Изменение категории расхода
procedure TMainForm.EditCatRasButtonClick(Sender: TObject);
begin
 Add_flag:=false;
 if (RasTreeView.Selected=nil) or (EditCatRasButton.Enabled=false) then exit;
 if (RasTreeView.Selected.Parent=nil)
  then Cat_flag:=true
  else Cat_flag:=false;
 AddCatForm.AddCat(RasTreeView,'cat_ras');
end;

// Изменение валюты
procedure TMainForm.EditCurButtonClick(Sender: TObject);
begin
 Add_flag:=false;
 CurAddForm.ShowModal;
end;

// Изменение единицы измерения
procedure TMainForm.EditIzmButtonClick(Sender: TObject);
begin
 Add_flag:=false;
 MeasureAddForm.ShowModal;
end;

// Изменение пользователя
procedure TMainForm.EditUserButtonClick(Sender: TObject);
begin
 Add_flag:=false;
 UserAddForm.ShowModal;
end;

// Формируем заголовок для главного окна
procedure TMainForm.SetFormCaption(user_name: string);
var
 FormCaption: string;
begin
  FormCaption:='Счетовод - '+user_name;
  // Отображаем уровень прав
  case mode of
   amGlava: FormCaption:=FormCaption+' (глава семьи)';
   amChlen: FormCaption:=FormCaption+' (член семьи)';
  end; // case
 MainForm.Caption:=FormCaption;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 if Select_user_flag=false then
  begin
   SQL_db.Destroy;
   Application.Terminate;
  end;

 // сохранение размеров и положения формы
 SaveFormSize(Self);
end;

// Создание таблиц
procedure TMainForm.CreateDB;
begin
 // Таблица названий типов счетов
 if not (SQL_db.TableExists('type_bill')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [type_bill] ([id] INTEGER, [name] CHAR)';
   SQL_db.execsql(SQL_query);
   // Добавление всех вариантов
   SQL_db.ExecSQL('INSERT INTO type_bill (id, name) VALUES ("0", "Наличные деньги")');
   SQL_db.ExecSQL('INSERT INTO type_bill (id, name) VALUES ("1", "Имущество")');
   SQL_db.ExecSQL('INSERT INTO type_bill (id, name) VALUES ("2", "Дебетная карта (счёт, книжка)")');
   SQL_db.ExecSQL('INSERT INTO type_bill (id, name) VALUES ("3", "Электронные деньги")');
  end;

 // Таблица пользователей
 if not (SQL_db.TableExists('users')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [users] ([id] INTEGER, [name] CHAR, [pass] CHAR, [type] INTEGER)';
   SQL_db.execsql(SQL_query);
   // Добавление пользователя по умолчанию (для первого входа)
   SQL_db.ExecSQL('INSERT INTO users (id, name, pass, type) VALUES ("0", "Счетовод", "0", "0")');
  end;

 // Таблица валют
 if not (SQL_db.TableExists('valut')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [valut] ([id] INTEGER, [name] CHAR, [abbr] CHAR, [kurs] REAL)';
   SQL_db.execsql(SQL_query);
   // Добавление рубля (для первого входа)
   SQL_db.ExecSQL('INSERT INTO valut (id, name, abbr, kurs) VALUES ("0", "Российский рубль", "RUB", "1")');
  end;

 // Таблица единиц измерения
 if not (SQL_db.TableExists('izm')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [izm] ([id] INTEGER, [abbr] CHAR)';
   SQL_db.execsql(SQL_query);
   SQL_db.ExecSQL('INSERT INTO izm (id, abbr) VALUES ("0", "шт.")');
  end;

  // Таблица категорий доходов
 if not (SQL_db.TableExists('cat_doh')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [cat_doh] ([id] INTEGER, [name] CHAR, [parent] INTEGER, [cat_order] INTEGER)';
   SQL_db.execsql(SQL_query);
   // Добавление служебной категории
   SQL_db.ExecSQL('INSERT INTO cat_doh (id, name, parent, cat_order) VALUES ("0", "Финансовые операции", "-1", "0")');
  end;

 // Таблица категорий расходов
 if not (SQL_db.TableExists('cat_ras')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [cat_ras] ([id] INTEGER, [name] CHAR, [parent] INTEGER, [cat_order] INTEGER)';
   SQL_db.execsql(SQL_query);
   // Добавление служебной категории
   SQL_db.ExecSQL('INSERT INTO cat_ras (id, name, parent, cat_order) VALUES ("0", "Финансовые операции", "-1", "0")');
   SQL_db.ExecSQL('INSERT INTO cat_ras (id, name, parent, cat_order) VALUES ("1", "Комиссия", "-1", "1")');
  end;

 // Таблица счетов
 if not (SQL_db.TableExists('bill')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [bill] ([id] INTEGER, [name] CHAR, [type] INTEGER, [valut] INTEGER, [begin] REAL, ';
   SQL_query:=SQL_query+'[balans] REAL, [user] INTEGER, [date] CHAR, [memo] CHAR)';
   SQL_db.execsql(SQL_query);
   SQL_db.ExecSQL('INSERT INTO bill (id, name, type, valut, begin, balans, user, date, memo) VALUES ("0", "Кошелёк", "0", "0", "0", "0", "0", "'+IntToStr(Integer(DateTimeToUnixTime(Date)))+'", "")');
  end;

 // Таблица доходов
 if not (SQL_db.TableExists('dohod')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [dohod] ([id] INTEGER, [cat] INTEGER, [bill] INTEGER, [sum] FLOAT, [date] CHAR, [sourse] INTEGER, [memo] CHAR)';
   SQL_db.execsql(SQL_query);
  end;

 // Таблица расходов
 if not (SQL_db.TableExists('rashod')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [rashod] ([id] INTEGER, [cat] INTEGER, [bill] INTEGER, [price] REAL, [num] REAL, ';
   SQL_query:=SQL_query+'[izm] INTEGER, [basket] INTEGER, [date] CHAR, [item] INTEGER, [agent] INTEGER, [memo] CHAR)';
   SQL_db.execsql(SQL_query);
  end;

 // Таблица планирования доходов
 if not (SQL_db.TableExists('plan_doh')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [plan_doh] ([id] INTEGER, [name] CHAR, [cat] INTEGER, [bill] INTEGER, [sum] REAL, ';
   SQL_query:=SQL_query+'[period] INTEGER, [param] INTEGER, [date] CHAR, [memo] INTEGER)';
   SQL_db.execsql(SQL_query);
  end;

 // Таблица планирования расходов
 if not (SQL_db.TableExists('plan_ras')) then
  begin
   SQL_query:='CREATE TABLE IF NOT EXISTS [plan_ras] ([id] INTEGER, [name] CHAR, [cat] INTEGER, [bill] INTEGER, [sum] REAL, ';
   SQL_query:=SQL_query+'[period] INTEGER, [param] INTEGER, [date] CHAR, [memo] INTEGER, [dolg] INTEGER)';
   SQL_db.execsql(SQL_query);
  end;
end;

// Построение списка единиц измерения
procedure TMainForm.GetMeasureList;
var
 i: integer;
 xCount: integer;
 temp_table: TSQLiteTable;
begin
 // Очистка сетки
 MeasureGrid.RowCount:=1;
 MeasureGrid.ColCount:=2;

 // Выборка из таблицы
 temp_table:=SQL_db.GetTable('SELECT * FROM izm');
 xCount:=temp_table.Count;

 // Проход по списку
 if xCount>0 then
 for i:=0 to xCount-1 do
  with MeasureGrid do
   begin
    // Если нужно - добавляем строку
    if (i<xCount-1) then RowCount:=RowCount+1;
    Cells[0, i]:=temp_table.FieldAsString('id');     // ID
    Cells[1, i]:=temp_table.FieldAsString('abbr');   // Название
    temp_table.Next;
   end;

 // Таблица единиц
 SetHeaderWidths(MeasureGrid);

end;

// Построение списка валют
procedure TMainForm.GetCurList;
var
 i: integer;
 xCount: integer;
 temp_table: TSQLiteTable;
begin
 // Очистка сетки
 CurGrid.RowCount:=1;
 CurGrid.ColCount:=5;

 // Выборка из таблицы
 temp_table:=SQL_db.GetTable('SELECT * FROM valut');
 xCount:=temp_table.Count;

 // Проход по списку
 if xCount>0 then
 for i:=0 to xCount-1 do
  with CurGrid do
   begin
    // Если нужно - добавляем строку
    if (i<>xCount-1) then RowCount:=RowCount+1;
    Cells[0, i]:=temp_table.FieldAsString('id');     // ID
    Cells[1, i]:=temp_table.FieldAsString('name');   // Название
    Cells[2, i]:=temp_table.FieldAsString('abbr');   // Сокращение
    Cells[3, i]:=CurrToStr(RoundEx(StrToCurr(temp_table.FieldAsString('kurs')),2));   // Курс
    temp_table.Next;
   end;

 SetHeaderWidths(CurGrid);
 OutputBalans;
end;

// Построение списка пользователей
procedure TMainForm.GetUserList;
var
 i: integer;
 xCount: integer;
 temp_table: TSQLiteTable;
begin
 // Очистка сетки
 UserGrid.RowCount:=1;
 UserGrid.ColCount:=4;

 // Выборка из таблицы
 temp_table:=SQL_db.GetTable('SELECT * FROM users');
 xCount:=temp_table.Count;

 // Проход по списку пользователей
 if xCount>0 then
 for i:=0 to xCount-1 do with UserGrid do
  begin
   // Если нужно - добавляем строку
   if (i<>xCount-1) then RowCount:=RowCount+1;
   Cells[0, i]:=temp_table.FieldAsString('id');     // ID
   Cells[1, i]:=temp_table.FieldAsString('name');   // Имя
   Cells[2, i]:=temp_table.FieldAsString('pass');   // Пароль
   Cells[3, i]:=UserAddForm.StatusComboBox.Items[temp_table.FieldAsInteger('type')];   // Статус
   temp_table.Next;
  end;

  SetHeaderWidths(UserGrid);
end;

// Построение списка счетов
procedure TMainForm.GetBillList;
var
 i: integer;
 xCount: integer;
 temp_table: TSQLiteTable;
 SQL_table_2: TSQLiteTable;
begin
 // Очистка сетки
 BillGrid.RowCount:=1;
 BillGrid.ColCount:=7;

 if mode=amChlen
  then temp_table:=SQL_db.GetTable('SELECT * FROM bill WHERE user='+IntToStr(user_id))
  else temp_table:=SQL_db.GetTable('SELECT * FROM bill');
 xCount:=temp_table.Count;

 // Проход по списку
 if xCount<>0 then
 begin
  EditBillButton.Enabled:=true;
  DelBillButton.Enabled:=true;

  for i:=0 to xCount-1 do
  with BillGrid do
   begin
    // Если нужно - добавляем строку
    if (i<>xCount-1) then RowCount:=RowCount+1;
    Cells[0, i]:=temp_table.FieldAsString('id');    // ID
    Cells[1, i]:=temp_table.FieldAsString('name');  // Название

    SQL_table_2:=SQL_db.GetTable('SELECT * FROM type_bill WHERE id='+temp_table.FieldAsString('type'));
    Cells[2, i]:=SQL_table_2.FieldAsString('name'); // Тип

    SQL_table_2:=SQL_db.GetTable('SELECT * FROM users WHERE id='+temp_table.FieldAsString('user')+' LIMIT 1;');
    SQL_table_2.First;
    Cells[3, i]:=SQL_table_2.FieldAsString('name'); // Пользователь

    SQL_table_2:=SQL_db.GetTable('SELECT * FROM valut WHERE id='+temp_table.FieldAsString('valut')+' LIMIT 1;');
    SQL_table_2.First;
    Cells[4, i]:=SQL_table_2.FieldAsString('abbr'); // Валюта

    Cells[5, i]:=CurrToStr(RoundEx(StrToCurr(temp_table.FieldAsString('balans')),2));  // Баланс
    Cells[6, i]:=temp_table.FieldAsString('memo');  // Комментарий
    temp_table.Next;
   end;
 end
 else
 begin
  EditBillButton.Enabled:=false;
  DelBillButton.Enabled:=false;
 end;

  SetHeaderWidths(BillGrid);
  OutputBalans;
end;

// Построение деревьев категорий доходов и расходов
procedure TMainForm.GetDohList(TreeCat: TTreeView; Table: string);
var
 i, j: integer;
 TmpNode, TmpTwoNode: TTreeNode;
 SQL_table, SQL_table_2: TSQLiteTable;
begin
 // Очистка сетки
 TreeCat.Items.Clear;

 // Выборка из таблицы родительских категорий (1 уровень)
 if Table='cat_ras'
 then SQL_table:=SQL_db.GetTable('SELECT * FROM '+Table+' WHERE (parent=-1) and (id!=0) and (id!=1)')
 else SQL_table:=SQL_db.GetTable('SELECT * FROM '+Table+' WHERE (parent=-1) and (id!=0)');
 SQL_table.First;

 // Проход по списку
 if SQL_table.Count<>0 then
 for i:=0 to SQL_table.Count-1 do
 begin
  TmpNode:=TTreeNode.Create(TreeCat.Items);
  TmpNode:=TreeCat.Items.AddChild(nil, SQL_table.FieldAsString('name'));
  TmpNode.Data:=Pointer(SQL_table.FieldAsInteger('id'));

  // Выборка из таблицы дочерних категорий (2 уровень)
  SQL_table_2:=SQL_db.GetTable('SELECT * FROM '+Table+' WHERE parent='+SQL_table.FieldAsString('id'));
  SQL_table_2.First;

   if SQL_table_2.Count<>0 then
   for j:=0 to SQL_table_2.Count-1 do
    begin
    TmpTwoNode:=TTreeNode.Create(TreeCat.Items);
    TmpTwoNode:=TreeCat.Items.AddChild(TmpNode, SQL_table_2.FieldAsString('name'));
    TmpTwoNode.Data:=Pointer(SQL_table_2.FieldAsInteger('id'));
    SQL_table_2.Next;
    end;

  SQL_table.Next;
 end;
end;

// Выборка данных из БД для таблицы доходов/расходов
function TMainForm.GetDataForMainTable(table_name: string): TSQLiteTable;
var
 bill_ID: string = '';
 period: string = '';
 SQL_query: string;
 CurDateTime: TDateTime;
begin
 CurDateTime:=Date+Time;
 // формируем базовую часть SQL-запроса на выборку данных
 SQL_query:='SELECT * FROM '+table_name+' WHERE date<='+IntToStr(DateTimeToUnixTime(CurDateTime));

 // временной отрезок
 if GridPeriodSelect.ItemIndex<>4 then period:=' date>='+IntToStr(tb_date);
 // счета, доступные пользователю
 if mode=amChlen then bill_ID:=ReturnBillId(user_id)
 else
  if GridUsersSelect.ItemIndex<>0
    then bill_ID:=ReturnBillId(Integer(GridUsersSelect.Items.Objects[GridUsersSelect.ItemIndex]));
 // формируем полный SQL-запрос
 if Length(period)>0 then SQL_query:=SQL_query+' AND '+period;
 if Length(bill_ID)>0 then SQL_query:=SQL_query+' AND '+bill_ID;

 // Выборка из таблицы и возврат результата
 result:=SQL_db.GetTable(SQL_query);
end;

// Построение общей таблицы доходов/расходов
procedure TMainForm.GetMainTable;
var
 i,k: integer;
 doh_table, ras_table, temp_table, basket_table: TSQLiteTable;
 dohCount: integer = 0;
 rasCount: integer = 0;
 num: currency = 0;
 price: currency = 0;
 sum: currency;
 basket, doh_row: integer;
 xName: string;
 temp: integer = 0;
 basket_list: TIntegerList;
 ItemType: TMyItemType;
 xID: integer;
begin
 // Очистка сетки
 MainGrid.RowCount:=1;
 MainGrid.ColCount:=8;
 //
 basket_list:=TIntegerList.Create;
 basket_list.Sorted:=true;
 basket_list.Duplicates:=dupIgnore;

 // Выборка данных о доходах
 if (GridTypeSelect.ItemIndex=0) or (GridTypeSelect.ItemIndex=2) then
  begin
   doh_table:=GetDataForMainTable('dohod');
   dohCount:=doh_table.Count;
  end;

 // Выборка данных о расходах
 if (GridTypeSelect.ItemIndex=0) or (GridTypeSelect.ItemIndex=1) then
  begin
   ras_table:=GetDataForMainTable('rashod');
   rasCount:=ras_table.Count;
  end;

 SetHeaderWidths(MainGrid);

 // Проход по списку
 if dohCount>0 then
  for i:=0 to dohCount-1 do with MainGrid do
   begin
    // Если нужно - добавляем строку
    if (i<>dohCount-1) then RowCount:=RowCount+1;

    // Дата и тип
    Cells[0, i]:=doh_table.FieldAsString('date');
    // служебные данные (ID, тип)
    Objects[0, i]:=TItemData.Create(doh_table.FieldAsInteger('id'), itDohod);
    // Подкатегория
    temp_table:=SQL_db.GetTable('SELECT * FROM cat_doh WHERE id='+doh_table.FieldAsString('cat')+' LIMIT 1;');
    Cells[1, i]:=temp_table.FieldAsString('name');
    // Сумма
    Cells[2, i]:=CurrToStr(RoundEx(DrawValut(doh_table.FieldAsInteger('bill'), 0, StrToCurr(doh_table.FieldAsString('sum'))),2)); // Сумма
    Objects[2, i]:=TObject(1);
    // Примечание
    Cells[3, i]:=doh_table.FieldAsString('memo');
    //
    doh_table.Next;
  end;

 // Проход по списку
 doh_row:=dohCount-1;
 if rasCount>0 then
  for i:=0 to rasCount-1 do with MainGrid do
   begin
    // Если нужно отрисовать корзину
    basket:=ras_table.FieldAsInteger('basket');
    if basket_list.Find(basket, temp) then
     begin
      //skeeped_num:=skeeped_num+1;
      ras_table.Next;
      Continue;
     end;

    // Подготовка данных
    if basket>=0 then
     begin
      // вычисляем сумму для корзины
      basket_table:=SQL_db.GetTable('SELECT * FROM rashod WHERE basket='+IntToStr(basket));
      sum:=0;
      if basket_table.Count>0 then
       for k:=0 to basket_table.Count-1 do
        begin
         num:=StrToCurr(basket_table.FieldAsString('num'));
         price:=StrToCurr(basket_table.FieldAsString('price'));
         sum:=sum+num*price;
         basket_table.Next;
        end;
      basket_list.Add(basket);
      // заголовок для корзины
      xName:='Корзина №'+IntToStr(basket+1);
      xID:=basket;
     end
    else
     begin
      // ID
      xID:=ras_table.FieldAsInteger('id');
      // вычисление суммы для одичночной записи
      num:=StrToCurr(ras_table.FieldAsString('num'));
      price:=StrToCurr(ras_table.FieldAsString('price'));
      sum:=num*price;
      // заголовок для одиночной записи (категория)
      temp_table:=SQL_db.GetTable('SELECT * FROM cat_ras WHERE id='+ras_table.FieldAsString('cat')+' LIMIT 1;');
      xName:=temp_table.FieldAsString('name');
      ItemType:=itRashod;
     end;

    // Добавляем строку в сетку
    RowCount:=RowCount+1;
    doh_row:=doh_row+1;

    // Дата и тип
    Cells[0, doh_row]:=ras_table.FieldAsString('date');
    // служебные данные (ID, тип)
    Objects[0, doh_row]:= TItemData.Create(xID, ItemType);
    // Заголовок (категория или название корзины)
    Cells[1, doh_row]:=xName;
    // Сумма
    Cells[2, doh_row]:=CurrToStr(RoundEx(DrawValut(ras_table.FieldAsInteger('bill'), 0, sum), 2)); // Сумма
    if (basket)>0
     then Objects[2, doh_row]:=TObject(basket_table.Count-1) // количество расходов в корзине
     else Objects[2, doh_row]:=TObject(1);
    // Примечание
    Cells[3, doh_row]:=ras_table.FieldAsString('memo');
    //
    ras_table.Next;
  end;

  if (dohCount=0) and (rasCount<>0) then MainGrid.RowCount:=MainGrid.RowCount-1;

  // Сортируем единую сетку
  MainGrid.SortOrder:=soDescending;
  MainGrid.SortColRow(true, 0);

  SetHeaderWidths(MainGrid);

  //EditDohButton.Enabled:=boolean(dohCount+rasCount>0);
  //DelDohButton.Enabled:=boolean(dohCount+rasCount>0);
  MainGrid.Enabled:=boolean(dohCount+rasCount>0);

  OutputBalans;
end;

function TMainForm.DrawValut(bill_ID, con_valut: integer; sum: real): real;
var
 temp_table: TSQLiteTable;
 valut_ID: integer;
 kurs_in, kurs_out: real;
begin
  // Загрузка данных
  temp_table:=SQL_db.GetTable('SELECT valut FROM bill WHERE id='+IntToStr(bill_ID));
  valut_ID:=temp_table.FieldAsInteger('valut');

  if valut_ID=con_valut then
  begin
   result:=sum;
   exit;
  end;

  temp_table:=SQL_db.GetTable('SELECT kurs FROM valut WHERE id='+IntToStr(valut_ID));
  kurs_in:=StrToCurr(temp_table.FieldAsString('kurs'));

  temp_table:=SQL_db.GetTable('SELECT kurs FROM valut WHERE id='+IntToStr(con_valut));
  kurs_out:=StrToCurr(temp_table.FieldAsString('kurs'));

  result:=kurs_in/kurs_out*sum;
end;

// Округление с заданной точностью
function TMainForm.RoundEx(sum: currency; prec: integer): currency;
var
 factor: double;
begin
 factor:=Exp(prec*Ln(10));
 Result:=Trunc(sum*factor+0.5)/factor;
end;

function TMainForm.ReturnBillId (user: integer): string;
var
 i: integer;
 tmp_table: TSQLiteTable;
begin
 result:='';

 // формируем результирующий запрос
 tmp_table:=SQL_db.GetTable('SELECT id FROM bill WHERE user='+IntToStr(user));

 if tmp_table.Count<>0 then
  for i:=0 to tmp_table.Count-1 do
   begin
    if i=0
     then Result:=' (bill='+tmp_table.FieldAsString('id')
     else Result:=Result+' OR bill='+tmp_table.FieldAsString('id');
    tmp_table.Next;
   end;
 Result:=Result+')';

end;

procedure TMainForm.DrawChart;
begin
 Chart1PieSeries1.Clear;

 if RasRadioButton.Checked=true
  then SelectDataInChart('cat_ras', 'rashod')
  else SelectDataInChart('cat_doh', 'dohod');
end;

//
procedure TMainForm.SelectDataInChart(table_cat, table: string);
var
 sum, sum_other, num, price: currency;
 temp_table: TSQLiteTable;
 i, j, color: integer;
 bill_ID, cat_ID: String;
 list_colors: TStringList;
 sum_cat: array [0..50] of Currency;
 SectorCaption: string;
 main_table: TSQLiteTable;
begin
 list_colors:=TStringList.Create;
 list_colors.LoadFromFile(DataDir+PathDelim+'colors.lst');

 color:=0;
 sum:=0;

 // заполнение диаграммы
 if CatBox.ItemIndex=0
 then main_table:=SQL_db.GetTable('SELECT id, name FROM '+table_cat+' WHERE parent=-1')
 else main_table:=SQL_db.GetTable('SELECT id, name FROM '+table_cat+' WHERE parent='+IntToStr(Integer(CatBox.Items.Objects[CatBox.ItemIndex])));

 // если выборка пуста - выходим без отрисовки
 if main_table.Count=0 then exit;

 for i:=0 to main_table.Count-1 do
  begin
   // пропускаем служебные категории
   if main_table.FieldAsInteger('id')=0 then
    begin
     main_table.Next;
     Continue;
    end;

   // сумма
   sum_cat[i]:=0;

   // ID текущей категории
   cat_ID:=main_table.FieldAsString('id');

   // выбираем уровень прав пользователя
   if mode=amChlen then
    begin
     bill_ID:=ReturnBillId(user_id);
     if bill_ID<>'' then
      begin
       if PeriodBox.ItemIndex<>4
        then temp_table:=SQL_db.GetTable('SELECT * FROM '+table+' WHERE '+bill_ID+' AND (cat='+cat_ID+' '+ReturnCatId(cat_ID, table_cat)+') AND (date>='+IntToStr(dr_date)+')')
        else temp_table:=SQL_db.GetTable('SELECT * FROM '+table+' WHERE '+bill_ID+' AND (cat='+cat_ID+' '+ReturnCatId(cat_ID, table_cat)+')')
      end
     else exit;
    end
   else
    if UserComboBox.ItemIndex=0 then
     begin
      if PeriodBox.ItemIndex<>4
       then temp_table:=SQL_db.GetTable('SELECT * FROM '+table+' WHERE (cat='+cat_ID+' '+ReturnCatId(cat_ID, table_cat)+') AND (date>='+IntToStr(dr_date)+')')
       else temp_table:=SQL_db.GetTable('SELECT * FROM '+table+' WHERE cat='+cat_ID+' '+ReturnCatId(cat_ID, table_cat))
     end
    else
     begin
      bill_ID:=ReturnBillId(Integer(UserComboBox.Items.Objects[UserComboBox.ItemIndex]));
      if bill_ID<>'' then
       begin
        if PeriodBox.ItemIndex<>4
         then temp_table:=SQL_db.GetTable('SELECT * FROM '+table+' WHERE '+bill_ID+' AND (cat='+cat_ID+' '+ReturnCatId(cat_ID, table_cat)+') AND (date>='+IntToStr(dr_date)+')')
         else temp_table:=SQL_db.GetTable('SELECT * FROM '+table+' WHERE '+bill_ID+' AND (cat='+cat_ID+' '+ReturnCatId(cat_ID, table_cat)+')')
       end
      else exit;
     end;

   if temp_table.Count<>0 then
    begin
     temp_table.First;
     for j:=0 to temp_table.Count-1 do
      begin
       if table='rashod' then
        begin
         num:=StrToCurr(temp_table.FieldAsString('num'));
         price:=StrToCurr(temp_table.FieldAsString('price'));
         sum_cat[i]:=sum_cat[i]+DrawValut(temp_table.FieldAsInteger('bill'), 0, num*price);
        end
       else sum_cat[i]:=sum_cat[i]+DrawValut(temp_table.FieldAsInteger('bill'), 0, StrToCurr(temp_table.FieldAsString('sum')));

       temp_table.Next;
      end; // for j
    end;

    sum:=sum+sum_cat[i];
    main_table.Next;
   end;

  if sum=0 then exit;
  sum_other:=0;

  main_table.First;

  for i:=0 to main_table.Count-1 do
   begin
   if main_table.FieldAsInteger('id')=0 then
    begin
     main_table.Next;
     Continue;
    end;

    if sum_cat[i]/sum>=0.05 then
     begin
      // Выбор формата отображения подписи
      if TypeCharGroup.ItemIndex=0
       then SectorCaption:=main_table.FieldAsString('name')+' - '+CurrToStr(RoundEx(sum_cat[i]/sum*100,1))+'%'
       else SectorCaption:=main_table.FieldAsString('name')+' - '+IntToStr(Round(sum_cat[i]))+' руб.';

      // добавление сектора на диаграмму
      Chart1PieSeries1.AddPie(RoundEx(sum_cat[i],1), SectorCaption, HexToInt(list_colors[color]));

      // закольцовывание списка цветов
      if color=16
       then color:=0
       else color:=color+1;
      end
     else sum_other:=sum_other+sum_cat[i];

    main_table.Next;
   end;

   if sum_other>0 then
    begin
     // выбор формата подписи
     if TypeCharGroup.ItemIndex=0
      then SectorCaption:='Прочее - '+CurrToStr(RoundEx(sum_other/sum*100,1))+'%'
      else SectorCaption:='Прочее - '+IntToStr(Round(sum_other))+' руб.';
      // добавление сектора на диаграмму
      Chart1PieSeries1.AddPie(RoundEx(sum_other,1), SectorCaption, HexToInt(list_colors[color]))
    end;
end;

function TMainForm.ReturnCatId (xParent, table: string): string;
var
 i: integer;
 tmp_table: TSQLiteTable;
begin
   tmp_table:=SQL_db.GetTable('SELECT id FROM '+table+' WHERE parent='+xParent);
   Result:='';

   if tmp_table.Count<>0 then
   begin
   tmp_table.First;
   for i:=0 to tmp_table.Count-1 do
   begin
    if i=0
    then Result:=' OR (cat='+tmp_table.FieldAsString('id')
    else Result:=Result+' OR cat='+tmp_table.FieldAsString('id');
    tmp_table.Next;
   end;
   Result:=Result+')';
   end;
end;

// Суммарный баланс (сумма доходов - сумма расходов) за указанный день
function TMainForm.GetSumForDate(UnixDate: integer): currency;
var
  sum_ras, sum_doh, num, price: real;
  bill_ID: string;
  ras_table, doh_table: TSQLiteTable;
  i: integer;
begin
 // Выборка для пользователя
 if mode=amChlen then
  begin
   bill_ID:=ReturnBillId(user_id);
   // выборка только по счетам заданного пользователя (если счетов нет - ничего не делаем)
   if bill_ID<>'' then
    begin
     ras_table:=SQL_db.GetTable('SELECT num, price, bill FROM rashod WHERE '+bill_ID+' AND (date>='+IntToStr(UnixDate)+') AND (date<'+IntToStr(UnixDate+86400)+')');
     doh_table:=SQL_db.GetTable('SELECT sum, bill FROM dohod WHERE '+bill_ID+' AND (date>='+IntToStr(UnixDate)+') AND (date<'+IntToStr(UnixDate+86400)+')');
    end
   else exit;
  // Админ
  end
   else
    // если пользователь не выбран - выборка по всем доступным счетам
    if UserComboBox.ItemIndex=0 then
     begin
      ras_table:=SQL_db.GetTable('SELECT num, price, bill FROM rashod WHERE (date>='+IntToStr(UnixDate)+') AND (date<'+IntToStr(UnixDate+86400)+')');
      doh_table:=SQL_db.GetTable('SELECT sum, bill FROM dohod WHERE (date>='+IntToStr(UnixDate)+') AND (date<'+IntToStr(UnixDate+86400)+')');
     end
    // иначе - по счетам выбранного пользователя
    else
     begin
      bill_ID:=ReturnBillId(Integer(UserComboBox.Items.Objects[UserComboBox.ItemIndex]));
      // если у пользователя есть счета
      if bill_ID<>'' then
       begin
        ras_table:=SQL_db.GetTable('SELECT num, price, bill FROM rashod WHERE '+bill_ID+' AND (date>='+IntToStr(UnixDate)+') AND (date<'+IntToStr(UnixDate+86400)+')');
        doh_table:=SQL_db.GetTable('SELECT sum, bill FROM dohod WHERE '+bill_ID+' AND (date>='+IntToStr(UnixDate)+') AND (date<'+IntToStr(UnixDate+86400)+')');
       end
      else exit;
     end;

  // Сумма расходов
  sum_ras:=0;
  if ras_table.Count<>0 then
   for i:=0 to ras_table.Count-1 do
    begin
     num:=StrToCurr(ras_table.FieldAsString('num'));
     price:=StrToCurr(ras_table.FieldAsString('price'));
     sum_ras:=sum_ras+DrawValut(ras_table.FieldAsInteger('bill'), 0, num*price);
     ras_table.Next;
    end;

  // Сумма доходов
  sum_doh:=0;
  if doh_table.Count<>0 then
   for i:=0 to doh_table.Count-1 do
    begin
     sum_doh:=sum_doh+DrawValut(doh_table.FieldAsInteger('bill'), 0, StrToCurr(doh_table.FieldAsString('sum')));
     doh_table.Next;
    end;

  // Результат
  result:=sum_doh-sum_ras;
  //sum_balans:=sum_balans+res;

end;

// Построение графика динамики расходов/доходов за последний месяц
procedure TMainForm.DrawDiagram;
var
 i: integer;
 temp_date: LONG;
 day_sum, sum_balans: currency;
 res_str, balans_str: string;
 barColor: TColor;
begin
 // Очищаем поле диаграммы
 Chart2BarSeries1.Clear;
 Chart2LineSeries1.Clear;
 temp_date:=DateTimeToUnixTime(Date);
 // инициализация переменных
 sum_balans:=0;
 day_sum:=0;

 for i:=0 to 30 do
  begin
   // Баланс (доходы-расходы) за 1 день
   day_sum:=GetSumForDate(temp_date);

   // сумма балансов за указанный период
   sum_balans:=sum_balans+day_sum;

   // подпись
   if day_sum=0
    then res_str:=''
    else res_str:=CurrToStr(Round(day_sum));

   // цвет столбца
   if day_sum<0
    then barColor:=HexToInt('#D5542B')
    else barColor:=HexToInt('#35B634');

   // Добавляем столбец на диаграмму
   Chart2BarSeries1.AddXY(i, RoundEx(day_sum,1), res_str, barColor);
//     Chart2BarSeries1.Add(RoundEx(day_sum,1), res_str, barColor);

   // уходим на предыдущий день
   temp_date:=temp_date-86400;
 end; // for i:=

 // Выбираем цвет для графика среднего баланса
 if sum_balans<0
  then Chart2LineSeries1.SeriesColor:=HexToInt('#D5542B')
  else Chart2LineSeries1.SeriesColor:=HexToInt('#35B634');

 // Строим график среднего баланса
 balans_str:='    '+CurrToStr(sum_balans);
 Chart2LineSeries1.AddXY(0, RoundEx(sum_balans,1), '', 0);
 Chart2LineSeries1.AddXY(30, RoundEx(sum_balans,1), balans_str, 0);
end;


function Translate(Name,Value: AnsiString; Hash: Longint; arg:pointer): AnsiString;
begin
  case StringCase(Value,['&Yes','&No','Cancel']) of
   0: Result:='&Да';
   1: Result:='&Нет';
   2: Result:='Отмена';
   else Result:=Value;
  end;
end;

{ TItemData }

constructor TItemData.Create(newID: integer; newType: TMyItemType);
begin
 ID:=newID;
 xType:=newType;
end;

initialization SetResourceStrings(@Translate,nil);
end.
