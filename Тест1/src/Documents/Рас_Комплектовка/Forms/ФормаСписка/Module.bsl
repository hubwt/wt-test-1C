
&НаКлиенте
Процедура РаботыПоПроданнымДеталямВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	///+ГомзМА 15.08.2023
	ТекСтрока = Элементы.РаботыПоПроданнымДеталям.ТекущиеДанные;
	Если Поле = Элементы.РаботыПоПроданнымДеталямДокумент Тогда
		
		СсылкаДляОткрытия    = ТекСтрока.Документ;
		ПараметрыФормы       = Новый Структура("Ключ", СсылкаДляОткрытия);
		
		ФормаДокумента 		 = ПолучитьФорму("Документ.Рас_Комплектовка.ФормаОбъекта", ПараметрыФормы);
		ФормаДокумента.Открыть();
	КонецЕсли;
	///+ГомзМА 15.08.2023
	
КонецПроцедуры
