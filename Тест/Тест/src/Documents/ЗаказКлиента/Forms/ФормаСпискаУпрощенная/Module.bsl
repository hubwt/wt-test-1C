
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	СсылкаДляОткрытия    = ТекСтрока.Ссылка;
	ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
	ОткрытьФорму("Документ.ЗаказКлиента.Форма.ФормаДокументаУпрощенная", ПараметрыФормы);
КонецПроцедуры
