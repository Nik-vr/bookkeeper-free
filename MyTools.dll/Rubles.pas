unit Rubles;
{ Пропись © Близнец Антон '99 http:\\anton-bl.chat.ru\delphi\1001.htm }
{ 1000011.01->'Один миллион одинадцать рублей 01 копейка'               }
interface

function RealToRouble(c: Currency): string;

implementation

uses SysUtils, math;

const
  Max000 = 6; {Кол-во триплетов - 000}
  MaxPosition = Max000 * 3; {Кол-во знаков в числе }
  // Аналог IIF в Dbase есть в proc.pas для основных типов,
  // частично объявлена тут для независимости

function IIF(i: Boolean; s1, s2: Char): Char; overload;
begin
  if i then
    result := s1
  else
    result := s2
end;

function IIF(i: Boolean; s1, s2: string): string; overload;
begin
  if i then
    result := s1
  else
    result := s2
end;

function NumToStr(s: string): string; {Возвращает число прописью}
const
  c1000: array[0..Max000] of string = ('', 'тысяч', 'миллион', 'миллиард',
    'триллион', 'квадраллион', 'квинтиллион');

  c1000w: array[0..Max000] of Boolean = (False, True, False, False, False,
    False, False);
  w: array[False..True, '0'..'9'] of string = (('ов ', ' ', 'а ', 'а ', 'а ',
    'ов ', 'ов ', 'ов ', 'ов ', 'ов '),
    (' ', 'а ', 'и ', 'и ', 'и ', ' ', ' ', ' ', ' ', ' '));
  function Num000toStr(S: string; woman: Boolean): string;
    {Num000toStr возвращает число для триплета}
  const
    c100: array['0'..'9'] of string = ('', 'сто ', 'двести ', 'триста ',
      'четыреста ', 'пятьсот ', 'шестьсот ', 'семьсот ', 'восемьсот ',
      'девятьсот ');
    c10: array['0'..'9'] of string = ('', 'десять ', 'двадцать ', 'тридцать ',
      'сорок ', 'пятьдесят ', 'шестьдесят ', 'семьдесят ', 'восемьдесят ',
      'девяносто ');
    c11: array['0'..'9'] of string = ('', 'один', 'две', 'три', 'четыр', 'пят',
      'шест', 'сем', 'восем', 'девят');
    c1: array[False..True, '0'..'9'] of string = (('', 'один ', 'два ', 'три ',
      'четыре ', 'пять ', 'шесть ', 'семь ', 'восемь ', 'девять '),
      ('', 'одна ', 'две ', 'три ', 'четыре ', 'пять ', 'шесть ', 'семь ',
        'восемь ', 'девять '));
  begin {Num000toStr}
    Result := c100[s[1]] + iif((s[2] = '1') and (s[3] > '0'), c11[s[3]] +
      'надцать ', c10[s[2]] + c1[woman, s[3]]);
  end; {Num000toStr}

var
  s000: string;

  isw, isMinus: Boolean;
  i: integer; //Счётчик триплетов
begin

  Result := '';
  i := 0;
  isMinus := (s <> '') and (s[1] = '-');
  if isMinus then
    s := Copy(s, 2, Length(s) - 1);
  while not ((i >= Ceil(Length(s) / 3)) or (i >= Max000)) do
  begin
    s000 := Copy('00' + s, Length(s) - i * 3, 3);
    isw := c1000w[i];
    if (i > 0) and (s000 <> '000') then //тысячи и т.д.
      Result := c1000[i] + w[Isw, iif(s000[2] = '1', '0', s000[3])] + Result;
    Result := Num000toStr(s000, isw) + Result;
    Inc(i)
  end;
  if Result = '' then
    Result := 'ноль';
  if isMinus then
    Result := 'минус ' + Result;
end; {NumToStr}

function RealToRouble(c: Currency): string;

const
  ruble: array['0'..'9'] of string = ('ей', 'ь', 'я', 'я', 'я', 'ей', 'ей',
    'ей', 'ей', 'ей');
  Kopeek: array['0'..'9'] of string = ('ек', 'йка', 'йки', 'йки', 'йки', 'ек',
    'ек', 'ек', 'ек', 'ек');

  function ending(const s: string): Char;
  var
    l: Integer; //С l на 8 байт коротче $50->$48->$3F
  begin //Возвращает индекс окончания
    l := Length(s);
    Result := iif((l > 1) and (s[l - 1] = '1'), '0', s[l]);
  end;

var
  rub: string[MaxPosition + 3];
  kop: string[2];
begin {Возвращает число прописью с рублями и копейками}

  Str(c: MaxPosition + 3: 2, Result);
  if Pos('E', Result) = 0 then //Если число можно представить в строке <>1E+99
  begin
    rub := TrimLeft(Copy(Result, 1, Length(Result) - 3));
    kop := Copy(Result, Length(Result) - 1, 2);
    Result := NumToStr(rub) + ' рубл' + ruble[ending(rub)]
      + ' ' + kop + ' копе' + Kopeek[ending(kop)];
//    Result := AnsiUpperCase(Result[1]) + Copy(Result, 2, Length(Result) - 1);
//    Result := AnsiUpperCase(Result[1]) + Copy(Result, 2, Length(Result) - 1);
  end;
end;

end.
