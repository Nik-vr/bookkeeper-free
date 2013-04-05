library MyTools;

{$mode objfpc}
{$H+}

uses Classes, SysUtils, Rubles, httpsend;

// Получение курсов валют с сайта ЦБ РФ
function GetCurFromWeb(Cur: string): Currency;
var
 Values: TStringList;
 CurDate, temp: string;
 kurs, nominal: Currency;
 i: integer;
begin
 result:=-1;
 // Форматируем дату для запроса
 CurDate:=DateToStr(Date);
 CurDate[3]:='/'; CurDate[6]:='/'; // Формат даты: '07/02/2009'
 // Получение XML-потока с данными
 with THTTPSend.Create do
  begin
   if HTTPMethod('GET', 'http://www.cbr.ru/scripts/XML_daily.asp?date_req='+CurDate) then
    try
     Values:=TStringList.Create;      // создаём временный объект
     Values.LoadFromStream(Document); // загрузка XML из потока
     Values.Text:=UTF8Encode(Values.Text);
    except
     // В случае ошибки выходим (функция вернёт -1)
     exit;
    end
   // В случае, если загрузить данные не удалось, выходим (функция вернёт -1)
   else exit;
   Free;
  end;

 // Разбор XML
 for i:=0 to Values.Count-1 do
  begin
   // Если в текущей строке XML найден код валюты
   // берём строку, стоящую на 5 позиций выше (в ней содержится значение курса)
   temp:=Copy(Values[i], 12, 3);
   if LowerCase(temp)=LowerCase(Cur) then
    begin
     // Вычленяем из строки числовое значение курса и номинал
     temp:=Copy(Values[i+3], 9, Length(Values[i+3])-16);
     kurs:=StrToCurr(temp);
     temp:=Copy(Values[i+1], 11, Length(Values[i+1])-20);
     nominal:=StrToCurr(temp);
     // Вычисляем стоимость 1 единицы указанной валюты в рублях
     result:=kurs/nominal;
    end;
  end;

 // освобождение памяти
 Values.Free;
end;


// Экспорт функций
exports
 GetCurFromWeb,
 RealToRouble;

//{$R *.res}

{$R *.res}

begin
  //
end.

