// ==========================================================================
// Данный файл содежит функции и профедуры, упрощающие работу с архивами zLib
//
// Содержимое этого файла подпадает под действие лицензией Mozilla Public
// License версии 1.1 (далее - "Лицензия"); вы не может использовать данный
// файл без ссылки на Лицензию. Вы можете получить полную копию Лицензии на
// http://www.mozilla.org/MPL/MPL-1.1.html
//
// Программное обеспечение, распространяемое под Лицензией, распространяется
// по принципу "КАК ЕСТЬ", без каких-либо гарантий со стороны авторов.
// Подробности см. в Лицензии.
//
// Оригинальный код: JvZlibMultiple.PAS, от 2001-02-28.
//
// Первым разработчиком оригинального кода является SИbastien Buysse
// [sbuysse@buypin.com]
// Отдельные фрагменты написаны SИbastien Buysse
// Авторские права (C) 2001 SИbastien Buysse. Все права защищены.
//
// Модификация для совместимости с zLibEx.pas версии 1.2.1, а также отделение
// от библиотеки JEDI выполнена Петроченко Н.Ю. [15.09.2004]
//
// Последние изменения: 2004-09-15
//
// Вы может получить последнюю версию оригинального файла на странице проекта
// JEDI JVCL, по адреcу http://jvcl.sourceforge.net
//
// ==========================================================================

//{$I jvcl.inc}

unit ZlibMultiple;

interface

uses SysUtils, Classes, Controls, ZLibEx;

    procedure AddFile(FileName, Directory, FilePath: string; DestStream: TStream);
    // compresses a list of files (can contain wildcards)
    // NOTE: caller must free returned stream!
    function CompressFiles(Files: TStrings): TStream; overload;
    // compresses a list of files (can contain wildcards)
    // and saves the compressed result to FileName
    procedure CompressFiles(Files: TStrings; FileName: string); overload;
    // compresses a Directory (recursing if Recursive is true)
    // NOTE: caller must free returned stream!
    function CompressDirectory(Directory: string; Recursive: Boolean): TStream; overload;
    // compresses a Directory (recursing if Recursive is true)
    // and saves the compressed result to FileName
    procedure CompressDirectory(Directory: string; Recursive: Boolean; FileName: string); overload;
    // decompresses FileName into Directory. If Overwrite is true, overwrites any existing files with
    // the same name as those in the compressed archive
    procedure DecompressFile(FileName, Directory: string; Overwrite: Boolean);
    // decompresses Stream into Directory optionally overwriting any existing files
    procedure DecompressStream(Stream: TStream; Directory: string; Overwrite: Boolean);


implementation

{$IFNDEF COMPILER6_UP}
uses
  FileCtrl;
{$ENDIF COMPILER6_UP}

{*******************************************************}
{  Format of the File:                                  }
{   File Header                                         }
{    1 Byte    Size of the directory variable           }
{    x bytes   Directory of the file                    }
{    1 Byte    Size of the filename                     }
{    x bytes   Filename                                 }
{    4 bytes   Size of the file (uncompressed)          }
{    4 bytes   Size of the file (compressed)            }
{   Data chunk                                          }
{    x bytes   the compressed chunk                     }
{*******************************************************}

function CompressDirectory(Directory: string; Recursive: Boolean): TStream;

  procedure SearchDirectory(SDirectory: string);
  var
    SearchRec: TSearchRec;
    Res: Integer;
  begin
    // (rom) this may not work for network drives and compressed files
    // (rom) because of faAnyFile
    Res := FindFirst(Directory + SDirectory + '*.*', faAnyFile, SearchRec);
    try
      while Res = 0 do
      begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if (SearchRec.Attr and faDirectory) = 0 then
            AddFile(SearchRec.Name, SDirectory, Directory + SDirectory + SearchRec.Name, Result)
          else
          if Recursive then
            SearchDirectory(SDirectory + SearchRec.Name + PathDelim);
        end;
        Res := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec);
    end;
  end;

begin
  { (RB) Letting this function create a stream is not a good idea;
         see other CompressDirectory function that causes a memory leak }
  Result := TMemoryStream.Create;
  if (Length(Directory) > 0) and (Directory[Length(Directory)] <> PathDelim) then
    Directory := Directory + PathDelim;
  SearchDirectory('');
  Result.Position := 0;
end;

procedure AddFile(FileName, Directory, FilePath: string; DestStream: TStream);
var
  Stream: TStream;
  FileStream: TFileStream;
  ZStream: TZCompressionStream;
  Buffer: array [0..1023] of Byte;
  Count: Integer;

  procedure WriteFileRecord(Directory, FileName: string; FileSize: Integer;
    CompressedSize: Integer);
  var
    B: Byte;
    Tab: array [1..256] of Char;
  begin
    { (RB) Can be improved }
    for B := 1 to Length(Directory) do
      Tab[B] := Directory[B];
    B := Length(Directory);
    DestStream.Write(B, SizeOf(B));
    DestStream.Write(Tab, B);

    { (RB) Can be improved }
    for B := 1 to Length(FileName) do
      Tab[B] := FileName[B];
    B := Length(FileName);
    DestStream.Write(B, SizeOf(B));
    DestStream.Write(Tab, B);

    DestStream.Write(FileSize, SizeOf(FileSize));
    DestStream.Write(CompressedSize, SizeOf(CompressedSize));
  end;

begin
  Stream := TMemoryStream.Create;
  FileStream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyWrite);
  try
    ZStream := TZCompressionStream.Create(Stream, zcDefault);
    try
      { (RB) ZStream has an OnProgress event, thus CopyFrom can be used }
      repeat
        Count := FileStream.Read(Buffer, SizeOf(Buffer));
        ZStream.Write(Buffer, Count);
      until Count = 0;
    finally
      ZStream.Free;
    end;

    WriteFileRecord(Directory, FileName, FileStream.Size, Stream.Size);
    DestStream.CopyFrom(Stream, 0);
  finally
    FileStream.Free;
    Stream.Free;
  end;
end;

procedure CompressDirectory(Directory: string; Recursive: Boolean; FileName: string);
var
  MemStream: TMemoryStream;
  TmpStream: TStream;
begin
  // don't create file until we save it so we don't accidentally
  // try to compress ourselves!
  if FileExists(FileName) then
    DeleteFile(FileName); // make sure we don't compress a previous archive into ourselves
  MemStream := TMemoryStream.Create;
  try
    { (RB) This causes a memory leak }
    // (p3) should be fixed now...
    TmpStream := CompressDirectory(Directory, Recursive);
    try
      MemStream.CopyFrom(TmpStream, 0);
      MemStream.SaveToFile(FileName);
    finally
      TmpStream.Free;
    end;
  finally
    MemStream.Free;
  end;
end;

function CompressFiles(Files: TStrings): TStream;
var
  I: Integer;
  S1, S2, Common: string;
begin
  { (RB) Letting this function create a stream is not a good idea;
         see other CompressFiles function that causes a memory leak }
  Result := TMemoryStream.Create;
  if Files.Count = 0 then
    Exit;

  //Find the biggest Common part of all files
  S1 := UpperCase(Files[0]);
  for I := 1 to Files.Count - 1 do
  begin
    S2 := Files[I];
    while (Pos(S1, S2) = 0) and (S1 <> '') do
      S1 := Copy(S1, 1, Length(S1) - 1);
  end;
  { (RB) This should be Common := S1 (?) }
  Common := S2;

  //Add the files to the stream
  for I := 0 to Files.Count - 1 do
  begin
    S1 := ExtractFileName(Files[I]);
    S2 := ExtractFilePath(Files[I]);
    S2 := Copy(S2, 1, Length(Common));
    AddFile(S1, S2, Files[I], Result);
  end;

  Result.Position := 0;
end;

procedure CompressFiles(Files: TStrings; FileName: string);
var
  MemStream: TMemoryStream;
  TmpStream: TStream;
begin
  MemStream := TMemoryStream.Create;
  try
    { (RB) This causes a memory leak }
    // (p3) should be fixed now...
    TmpStream := CompressFiles(Files);
    try
      MemStream.CopyFrom(TmpStream, 0);
      MemStream.SaveToFile(FileName);
    finally
      TmpStream.Free;
    end;
  finally
    MemStream.Free;
  end;
end;

procedure DecompressStream(Stream: TStream; Directory: string; Overwrite: Boolean);
var
  FileStream: TFileStream;
  ZStream: TZDecompressionStream;
  CStream: TMemoryStream;
  B: Byte;
  Tab: array [1..256] of Char;
  S: string;
  Count, FileSize, I: Integer;
  Buffer: array [0..1023] of Byte;
begin
  if (Length(Directory) > 0) and (Directory[Length(Directory)] <> PathDelim) then
    Directory := Directory + PathDelim;

  while Stream.Position < Stream.Size do
  begin
    //Read and force the directory
    Stream.Read(B, SizeOf(B));
    { (RB) Can be improved }
    Stream.Read(Tab, B);
    S := '';
    for I := 1 to B do
      S := S + Tab[I];
    ForceDirectories(Directory + S);
    if (Length(S) > 0) and (S[Length(S)] <> PathDelim) then
      S := S + PathDelim;

    //Read filename
    Stream.Read(B, SizeOf(B));
    { (RB) Can be improved }
    Stream.Read(Tab, B);
    for I := 1 to B do
      S := S + Tab[I];

    Stream.Read(FileSize, SizeOf(FileSize));
    Stream.Read(I, SizeOf(I));
    CStream := TMemoryStream.Create;
    try
      CStream.CopyFrom(Stream, I);
      CStream.Position := 0;

      //Decompress the file
      S := Directory + S;
      if Overwrite or not FileExists(S) then
      begin
        FileStream := TFileStream.Create(S, fmCreate or fmShareExclusive);
        ZStream := TZDecompressionStream.Create(CStream);
        try

          { (RB) ZStream has an OnProgress event, thus copyfrom can be used }
          repeat
            Count := ZStream.Read(Buffer, SizeOf(Buffer));
            FileStream.Write(Buffer, Count);
          until Count = 0;

        finally
          FileStream.Free;
          ZStream.Free;
        end;
      end;
    finally
      CStream.Free;
    end;
  end;
end;

procedure DecompressFile(FileName, Directory: string; Overwrite: Boolean);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.Position := 0;
    DecompressStream(Stream, Directory, Overwrite);
  finally
    Stream.Free;
  end;
end;

end.

