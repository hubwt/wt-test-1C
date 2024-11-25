
&НаКлиенте
Процедура СоздатьДокументЗакупка(Команда)
/// Комлев АА 25/11/24 +++
	ОткрытьФорму("Документ.ЗакупкаТовара.ФормаСписка");
	ЗакупкаДок = СоздатьДокументЗакупкаНаСервере();
	ПараметрыФормы = Новый Структура("Ключ", ЗакупкаДок);
	ОткрытьФорму("Документ.ЗакупкаТовара.Форма.ФормаДокумента", ПараметрыФормы);
/// Комлев АА 25/11/24 ---
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьДокументЗакупкаНаСервере()
/// Комлев АА 25/11/24 +++
	Закупка = Документы.ЗакупкаТовара.СоздатьДокумент();
	Закупка.Дата = ТекущаяДата();
	Закупка.СтатусЗакупки = Перечисления.СтатусЗакупкиТовара.ОжидаемПоступление;
	Закупка.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	Закупка.Записать();
	Возврат Закупка.Ссылка;
/// Комлев АА 25/11/24 ---
КонецФункции