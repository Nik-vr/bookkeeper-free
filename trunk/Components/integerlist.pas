{===============================================================================
   TIntegerList
   Based on FPC RTL TList and TStringList
   License: Modified LGPL (same as FPC RTL)
===============================================================================}

unit IntegerList;

{$MODE DELPHI}

{$DEFINE UseRTLMessages}

interface

uses
  Classes, SysUtils {$IFDEF UseRTLMessages}, RtlConsts{$ENDIF};

//--------------------------- Integer List -------------------------------------

type
  TIntListItem = Integer;
  PIntList = ^TIntList;
  TIntList = array[0..MaxListSize - 1] of TIntListItem;
  TIntListSortCompare = function (Item1, Item2: TIntListItem): Integer;

const
  IntItemEmptyValue = 0;
  IntItemWordRatio = SizeOf(TIntListItem) div SizeOf(Word);

type
  TIntegerList = class(TObject)
  private
    FList: PIntList;
    FCount: Integer;
    FCapacity: Integer;
    FDuplicates: TDuplicates;
    FSorted: Boolean;
    procedure CopyMove (AList: TIntegerList);
    procedure MergeMove (AList: TIntegerList);
    procedure DoCopy(ListA, ListB: TIntegerList);
    procedure DoSrcUnique(ListA, ListB: TIntegerList);
    procedure DoAnd(ListA, ListB: TIntegerList);
    procedure DoDestUnique(ListA, ListB: TIntegerList);
    procedure DoOr(ListA, ListB: TIntegerList);
    procedure DoXOr(ListA, ListB: TIntegerList);
    procedure QuickSort(FList: PIntList; L, R : Longint;
      Compare: TIntListSortCompare);
    procedure SetSorted(const Value: Boolean);
  protected
    function Get(Index: Integer): TIntListItem;
    procedure Put(Index: Integer; Item: TIntListItem);
    procedure SetCapacity(NewCapacity: Integer);
    function GetCapacity: Integer;
    procedure SetCount(NewCount: Integer);
    function GetCount: Integer;
    function GetList: PIntList;
    procedure InsertItem(Index: Integer; Item: TIntListItem);
  public
    procedure AddList(AList: TIntegerList);
    function Add(Item: TIntListItem): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    class procedure Error(const Msg: string; Data: PtrInt); virtual;
    procedure Exchange(Index1, Index2: Integer);
    function Expand: TIntegerList;
    function Extract(Item: TIntListItem): TIntListItem;
    function First: TIntListItem;
    function Find(const Item: TIntListItem; var Index: Integer): Boolean; virtual;
    function IndexOf(Item: TIntListItem): Integer;
    procedure Insert(Index: Integer; Item: TIntListItem);
    function Last: TIntListItem;
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Assign (ListA: TIntegerList; AOperator: TListAssignOp = laCopy;
      ListB: TIntegerList = nil);
    function Remove(Item: TIntListItem): Integer;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TIntListSortCompare);
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: TIntListItem read Get write Put; default;
    property List: PIntList read GetList;
  end;

implementation

const
  {$IFNDEF UseRTLMessages}
  SListIndexError    = 'List index (%d) out of bounds';
  SListCapacityError = 'List capacity (%d) exceeded';
  SListCountError    = 'List count (%d) out of bounds';
  SSortedListError   = 'Operation not allowed on sorted list';
  {$ENDIF}
  SDuplicateItem     = 'List does not allow duplicates';

function IntListCompare(Item1, Item2: TIntListItem): Integer;
begin
  if Item1 > Item2 then Exit(1) else
  if Item1 = Item2 then Exit(0) else
  Result := -1;
end;

{ TIntegerList }

procedure TIntegerList.CopyMove(AList: TIntegerList);
var
  I: Integer;
begin
  Clear;
  for I := 0 to AList.Count - 1 do
    Add(AList[I]);
end;

procedure TIntegerList.MergeMove(AList: TIntegerList);
var
  I: Integer;
begin
  for I := 0 to AList.Count - 1 do
    if IndexOf(AList[I]) < 0 then
      Add(AList[I]);
end;

procedure TIntegerList.DoCopy(ListA, ListB: TIntegerList);
begin
  if Assigned(ListB) then
    CopyMove(ListB)
  else
    CopyMove(ListA);
end;

procedure TIntegerList.DoSrcUnique(ListA, ListB: TIntegerList);
var
  I: Integer;
begin
  if Assigned(ListB) then
  begin
    Clear;
    for I := 0 to ListA.Count-1 do
      if ListB.IndexOf(ListA[I]) < 0 then
        Add(ListA[I]);
  end else
  begin
    for I := Count-1 downto 0 do
      if ListA.IndexOf(Self[I]) >= 0 then
        Delete(I);
  end;
end;

procedure TIntegerList.DoAnd(ListA, ListB: TIntegerList);
var
  I: Integer;
begin
  if Assigned (ListB) then
  begin
    Clear;
    for I := 0 to ListA.Count-1 do
      if ListB.IndexOf (ListA[I]) >= 0 then
        Add(ListA[I]);
  end else
  begin
    for I := Count - 1 downto 0 do
      if ListA.IndexOf(Self[I]) < 0 then
        Delete(I);
  end;
end;

procedure TIntegerList.DoDestUnique(ListA, ListB: TIntegerList);

  procedure MoveElements (Src, Dest : TIntegerList);
  var
    I: Integer;
  begin
    Clear;
    for I := 0 to Src.Count-1 do
      if Dest.IndexOf(Src[I]) < 0 then
        Add(Src[I]);
  end;

var
  Dest : TIntegerList;
begin
  if Assigned (ListB) then
    MoveElements (ListB, ListA)
  else
    try
      Dest := TIntegerList.Create;
      Dest.CopyMove(Self);
      MoveElements(ListA, Dest)
    finally
      FreeAndNil(Dest);
    end;
end;

procedure TIntegerList.DoOr(ListA, ListB: TIntegerList);
begin
  if Assigned(ListB) then
  begin
    CopyMove(ListA);
    MergeMove(ListB);
  end else
    MergeMove(ListA);
end;

procedure TIntegerList.DoXOr(ListA, ListB: TIntegerList);
var I: Integer;
    List: TIntegerList;
begin
  if assigned (ListB) then
  begin
    Clear;
    for I := 0 to ListA.Count - 1 do
      if ListB.IndexOf(ListA[I]) < 0 then
        Add(ListA[I]);
    for I := 0 to ListB.Count - 1 do
      if ListA.IndexOf(ListB[I]) < 0 then
        Add(ListB[I]);
  end else
    try
      List := TIntegerList.Create;
      List.CopyMove(Self);
      for I := Count - 1 downto 0 do
        if listA.IndexOf(Self[I]) >= 0 then
          Delete(I);
      for I := 0 to ListA.Count - 1 do
        if List.IndexOf(ListA[I]) < 0 then
          Add(ListA[I]);
    finally
      List.Free;
    end;
end;

procedure TIntegerList.QuickSort(FList: PIntList; L, R: Longint;
  Compare: TIntListSortCompare);
var
  I, J: Longint;
  P, Q: TIntListItem;
begin
 repeat
   I := L;
   J := R;
   P := FList^[ (L + R) div 2 ];
   repeat
     while Compare(P, FList^[i]) > 0 do
       I := I + 1;
     while Compare(P, FList^[J]) < 0 do
       J := J - 1;
     If I <= J then
     begin
       Q := FList^[I];
       FList^[I] := FList^[J];
       FList^[J] := Q;
       I := I + 1;
       J := J - 1;
     end;
   until I > J;
   if L < J then
     QuickSort(FList, L, J, Compare);
   L := I;
 until I >= R;
end;

procedure TIntegerList.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

function TIntegerList.Get(Index: Integer): TIntListItem;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Result := FList^[Index];
end;

procedure TIntegerList.Put(Index: Integer; Item: TIntListItem);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  FList^[Index] := Item;
end;

procedure TIntegerList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
     Error(SListCapacityError, NewCapacity);
  if NewCapacity = FCapacity then
    Exit;
  ReallocMem(FList, SizeOf(TIntListItem) * NewCapacity);
  FCapacity := NewCapacity;
end;

function TIntegerList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

procedure TIntegerList.SetCount(NewCount: Integer);
begin
  if NewCount < FCount then
  begin
    while NewCount < FCount do
      Delete(FCount - 1)
  end else
  begin
    if (NewCount < 0) or (NewCount > MaxListSize)then
      Error(SListCountError, NewCount);
    if NewCount > FCount then
    begin
      if NewCount > FCapacity then
        SetCapacity(NewCount);
      if FCount < NewCount then
        FillWord(FList^[FCount], (NewCount-FCount) *  IntItemWordRatio, 0);
    end;
    FCount := Newcount;
  end;
end;

function TIntegerList.GetCount: Integer;
begin
  Result := FCount;
end;

function TIntegerList.GetList: PIntList;
begin
  Result := FList;
end;

procedure TIntegerList.AddList(AList: TIntegerList);
var
  I: Integer;
begin
  if (Capacity < Count + AList.Count) then
    Capacity := Count + AList.Count;
  for I := 0 to AList.Count - 1 do
    Add(AList[I]);
end;

function TIntegerList.Add(Item: TIntListItem): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(Item, Result) then
    case Duplicates of
      DupIgnore : Exit;
      DupError : Error(SDuplicateItem, 0);
    end;
  InsertItem(Result, Item);
end;

procedure TIntegerList.Clear;
begin
  while (Count > 0) do
    Delete(Count-1);
end;

procedure TIntegerList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  FCount := FCount-1;
  System.Move(FList^[Index+1], FList^[Index], (FCount - Index) * SizeOf(Pointer));
  // Shrink the list if appropriate
  if (FCapacity > 256) and (FCount < FCapacity shr 2) then
  begin
    FCapacity := FCapacity shr 1;
    ReallocMem(FList, SizeOf(Pointer) * FCapacity);
  end;
end;

class procedure TIntegerList.Error(const Msg: string; Data: PtrInt);
begin
  raise EListError.CreateFmt(Msg,[Data]) at get_caller_addr(get_frame);
end;

procedure TIntegerList.Exchange(Index1, Index2: Integer);
var
  Temp: TIntListItem;
begin
  if ((Index1 >= FCount) or (Index1 < 0)) then
    Error(SListIndexError, Index1);
  if ((Index2 >= FCount) or (Index2 < 0)) then
    Error(SListIndexError, Index2);
  Temp := FList^[Index1];
  FList^[Index1] := FList^[Index2];
  FList^[Index2] := Temp;
end;

function TIntegerList.Expand: TIntegerList;
var
  IncSize: Integer;
begin
  if FCount < FCapacity then exit;
  IncSize := 4;
  if FCapacity > 3 then IncSize := IncSize + 4;
  if FCapacity > 8 then IncSize := IncSize+8;
  if FCapacity > 127 then Inc(IncSize, FCapacity shr 2);
  SetCapacity(FCapacity + IncSize);
  Result := Self;
end;

function TIntegerList.Extract(Item: TIntListItem): TIntListItem;
var
  I: Integer;
begin
  I := IndexOf(Item);
  if I >= 0 then
  begin
    Result := Item;
    Delete(I);
  end else
    Result := IntItemEmptyValue;
end;

function TIntegerList.First: TIntListItem;
begin
  if FCount = 0 then
    Result := IntItemEmptyValue
  else
    Result := Items[0];
end;

function TIntegerList.Find(const Item: TIntListItem; var Index: Integer): Boolean;
var
  L, R, I: Integer;
  CompareRes: Integer;
begin
  Result := false;
  // Use binary search.
  L := 0;
  R := Count - 1;
  while (L <= R) do
  begin
    I := L + (R - L) div 2;
    CompareRes := IntListCompare(Item, FList^[I]);
    if (CompareRes > 0) then
      L := I + 1
    else
    begin
      R := I - 1;
      if (CompareRes = 0) then
      begin
        Result := true;
        if (Duplicates <> dupAccept) then
          L := I; // forces end of while loop
      end;
    end;
  end;
  Index := L;
end;

function TIntegerList.IndexOf(Item: TIntListItem): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Item) do
    Result := Result + 1;
  if Result = FCount then
    Result := -1;
end;

procedure TIntegerList.Insert(Index: Integer; Item: TIntListItem);
begin
  if Sorted then
    Error(SSortedListError,0)
  else
    if (Index < 0) or (Index > FCount) then
      Error(SListIndexError, Index)
    else
      InsertItem(Index, Item);
end;

procedure TIntegerList.InsertItem(Index: Integer; Item: TIntListItem);
begin
  if FCount = FCapacity then
    Self.Expand;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index+1], (FCount - Index) * SizeOf(TIntListItem));
  FList^[Index] := Item;
  Inc(FCount);
end;

function TIntegerList.Last: TIntListItem;
begin
  if FCount = 0 then
    Result := IntItemEmptyValue
  else
    Result := Items[FCount - 1];
end;

procedure TIntegerList.Move(CurIndex, NewIndex: Integer);
var
  Temp: TIntListItem;
begin
  if ((CurIndex < 0) or (CurIndex > Count - 1)) then
    Error(SListIndexError, CurIndex);
  if ((NewIndex < 0) or (NewIndex > Count -1)) then
    Error(SlistIndexError, NewIndex);
  Temp := FList^[CurIndex];
  FList^[CurIndex] := IntItemEmptyValue;
  Self.Delete(CurIndex);
  Self.InsertItem(NewIndex, IntItemEmptyValue);
  FList^[NewIndex] := Temp;
end;

procedure TIntegerList.Assign(ListA: TIntegerList; AOperator: TListAssignOp; ListB: TIntegerList);
begin
  case AOperator of
    laCopy : DoCopy (ListA, ListB);             // replace dest with src
    laSrcUnique : DoSrcUnique (ListA, ListB);   // replace dest with src that are not in dest
    laAnd : DoAnd (ListA, ListB);               // remove from dest that are not in src
    laDestUnique : DoDestUnique (ListA, ListB); // remove from dest that are in src
    laOr : DoOr (ListA, ListB);                 // add to dest from src and not in dest
    laXOr : DoXOr (ListA, ListB);               // add to dest from src and not in dest, remove from dest that are in src
  end;
end;

function TIntegerList.Remove(Item: TIntListItem): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then
    Delete(Result);
end;

procedure TIntegerList.Sort;
begin
  CustomSort(IntListCompare);
end;

procedure TIntegerList.CustomSort(Compare: TIntListSortCompare);
begin
  if not Assigned(FList) or (FCount < 2) then Exit;
  QuickSort(FList, 0, FCount-1, Compare);
end;

end.
