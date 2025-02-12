#Область СлужебныеПроцедурыИФункции

// Функция получает цвет стиля по имени элемента стиля.
//
// Параметры:
// ИмяЦветаСтиля - Строка -  Имя элемента стиля.
//
// Возвращаемое значение:
// Цвет.
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияВызовСервера.ЦветСтиля(ИмяЦветаСтиля);
	
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля.
//
// Параметры:
// ИмяШрифтаСтиля - Строка - Имя шрифта стиля.
//
// Возвращаемое значение:
// Шрифт.
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияВызовСервера.ШрифтСтиля(ИмяШрифтаСтиля);
	
КонецФункции

// См. ОбщегоНазначенияКлиентСервер.ЭтоВебКлиентПодMacOS().
Функция ЭтоВебКлиентПодMacOS() Экспорт
	
#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	Возврат Ложь;  // Только в веб клиенте этот код работает.
#КонецЕсли
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СтрНайти(СистемнаяИнфо.ИнформацияПрограммыПросмотра, "Macintosh") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// См. ОбщегоНазначенияКлиент.ТипПлатформыКлиента().
Функция ТипПлатформыКлиента() Экспорт
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Возврат СистемнаяИнфо.ТипПлатформы;
КонецФункции

#КонецОбласти
