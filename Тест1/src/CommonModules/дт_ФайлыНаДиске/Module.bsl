//
//  https://nov-soft.ru
//

#Область ПрограммныйИнтерфейс

Процедура ОбновитьПризнакНаличияФото() Экспорт
	
	//КаталогКартинок = Константы.дт_КаталогКартинокТМЦ.Получить();
	//Если Не ЗначениеЗаполнено(КаталогКартинок) Тогда
	//	Возврат
	//КонецЕсли;
	//
	////Запрос = Новый Запрос;
	////Запрос.Текст =
	////	"ВЫБРАТЬ
	////	|	Инвентарь.Ссылка,
	////	|	Инвентарь.Код,
	////	|	ЕСТЬNULL(дт_НаличиеФайлов.ЕстьФайлы, ЛОЖЬ) КАК ЕстьФайлы
	////	|ИЗ
	////	|	Справочник.Инвентарь КАК Инвентарь
	////	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_НаличиеФайлов КАК дт_НаличиеФайлов
	////	|		ПО дт_НаличиеФайлов.ОбъектСФайлами = Инвентарь.Ссылка";
	//
	////Запрос = Новый Запрос;
	////Запрос.Текст =
	////	"ВЫБРАТЬ
	////	|	ИнвентарныеНомера.Ссылка КАК Ссылка,
	////	|	ИнвентарныеНомера.Наименование КАК Наименование,
	////	|	ЕСТЬNULL(дт_НаличиеФайлов.ЕстьФайлы, ЛОЖЬ) КАК ЕстьФайлы
	////	|ИЗ
	////	|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
	////	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_НаличиеФайлов КАК дт_НаличиеФайлов
	////	|		ПО (дт_НаличиеФайлов.ОбъектСФайлами = ИнвентарныеНомера.Ссылка)";
	//
	//	Запрос = Новый Запрос;
	//	Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	ИнвентарныеНомера.Ссылка КАК Ссылка,
	//	|	ИнвентарныеНомера.Наименование КАК Наименование,
	//	|	ЕСТЬNULL(дт_НаличиеФайлов.ЕстьФайлы, ЛОЖЬ) КАК ЕстьФайлы,
	//	|	СкладСнабжение.Ссылка КАК СсылкаСкладСнабжение,
	//	|	СкладСнабжение.Код КАК КодСкладСнабжение,
	//	|	СкладСнабжение.НазначатьИнвентарныеНомера КАК НазначатьИнвентарныеНомера
	//	|ИЗ
	//	|	Справочник.СкладСнабжение КАК СкладСнабжение
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
	//	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_НаличиеФайлов КАК дт_НаличиеФайлов
	//	|			ПО (дт_НаличиеФайлов.ОбъектСФайлами = ИнвентарныеНомера.Ссылка)
	//	|		ПО СкладСнабжение.Ссылка = ИнвентарныеНомера.Владелец";

	//
	//УстановитьПривилегированныйРежим(Истина);
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//Если РезультатЗапроса.Пустой() Тогда
	//	Возврат
	//КонецЕсли;
	//
	//
	//Если НЕ СтрЗаканчиваетсяНа(КаталогКартинок, "\") Тогда
	//	КаталогКартинок = КаталогКартинок + "\";
	//КонецЕслИ;	
	//
	//РасширенияКартинок = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьРасширенияКартинок();
	//
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	
	//	Если ВыборкаДетальныеЗаписи.НазначатьИнвентарныеНомера = Истина Тогда
	//		НаименованиеОбъекта = СокрЛП(ВыборкаДетальныеЗаписи.Наименование);
	//		ИмяКаталога = КаталогКартинок + НаименованиеОбъекта;
	//		Картинки = ПолучитьСписокКартинок(ИмяКаталога, НаименованиеОбъекта, РасширенияКартинок);
	//	Иначе
	//		КодОбъекта = СокрЛП(ВыборкаДетальныеЗаписи.КодСкладСнабжение);
	//		ИмяКаталога = КаталогКартинок + КодОбъекта;
	//		Картинки = ПолучитьСписокКартинок(ИмяКаталога, КодОбъекта, РасширенияКартинок);
	//	КонецЕсли;
	//	
	//	//Картинки = ПолучитьСписокКартинок(ИмяКаталога, НаименованиеОбъекта, РасширенияКартинок);
	//	ЕстьКартинка = Картинки.Количество() <> 0;
	//	
	//	Если ВыборкаДетальныеЗаписи.ЕстьФайлы <> ЕстьКартинка Тогда
	//		Если ВыборкаДетальныеЗаписи.НазначатьИнвентарныеНомера = Истина Тогда	
	//			Запись = РегистрыСведений.дт_НаличиеФайлов.СоздатьМенеджерЗаписи();
	//			Запись.ОбъектСФайлами = ВыборкаДетальныеЗаписи.Ссылка;
	//			Запись.ЕстьФайлы = ЕстьКартинка;
	//			Запись.ИдентификаторОбъекта = НаименованиеОбъекта;
	//			Запись.Записать();
	//		Иначе	
	//			Запись = РегистрыСведений.дт_НаличиеФайлов.СоздатьМенеджерЗаписи();
	//			Запись.ОбъектСФайлами = ВыборкаДетальныеЗаписи.СсылкаСкладСнабжение;
	//			Запись.ЕстьФайлы = ЕстьКартинка;
	//			Запись.ИдентификаторОбъекта = КодОбъекта;
	//			Запись.Записать();
	//		КонецЕсли;
	//	КонецЕсли; 
	//	
	//КонецЦикла;
	
	///+ГомзМА 18.04.2023
	КаталогКартинок = Константы.дт_КаталогКартинокТМЦ.Получить();
	Если Не ЗначениеЗаполнено(КаталогКартинок) Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнвентарныеНомера.Ссылка КАК Ссылка,
	|	ИнвентарныеНомера.Наименование КАК Наименование,
	|	ЕСТЬNULL(дт_НаличиеФайлов.ЕстьФайлы, ЛОЖЬ) КАК ЕстьФайлы
	|ИЗ
	|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_НаличиеФайлов КАК дт_НаличиеФайлов
	|		ПО (дт_НаличиеФайлов.ОбъектСФайлами = ИнвентарныеНомера.Ссылка)";
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗапросСкладСнабжение = Новый Запрос;
	ЗапросСкладСнабжение.Текст =
	"ВЫБРАТЬ
	|	СкладСнабжение.Ссылка КАК Ссылка,
	|	СкладСнабжение.Код КАК Код,
	|	ЕСТЬNULL(дт_НаличиеФайлов.ЕстьФайлы, ЛОЖЬ) КАК ЕстьФайлы
	|ИЗ
	|	Справочник.СкладСнабжение КАК СкладСнабжение
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_НаличиеФайлов КАК дт_НаличиеФайлов
	|		ПО (дт_НаличиеФайлов.ОбъектСФайлами = СкладСнабжение.Ссылка)
	|ГДЕ
	|	СкладСнабжение.НазначатьИнвентарныеНомера = ЛОЖЬ";
	
	РезультатЗапросаСкладСнабжение = ЗапросСкладСнабжение.Выполнить();
	
	Если РезультатЗапроса.Пустой() И РезультатЗапросаСкладСнабжение.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ СтрЗаканчиваетсяНа(КаталогКартинок, "\") Тогда
		КаталогКартинок = КаталогКартинок + "\";
	КонецЕслИ;	
	
	РасширенияКартинок = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьРасширенияКартинок();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаименованиеОбъекта = СокрЛП(ВыборкаДетальныеЗаписи.Наименование);
		ИмяКаталога = КаталогКартинок + НаименованиеОбъекта;
		Картинки = ПолучитьСписокКартинок(ИмяКаталога, НаименованиеОбъекта, РасширенияКартинок);
		
		ЕстьКартинка = Картинки.Количество() <> 0;
		
		Если ВыборкаДетальныеЗаписи.ЕстьФайлы <> ЕстьКартинка Тогда
			Запись = РегистрыСведений.дт_НаличиеФайлов.СоздатьМенеджерЗаписи();
			Запись.ОбъектСФайлами = ВыборкаДетальныеЗаписи.Ссылка;
			Запись.ЕстьФайлы = ЕстьКартинка;
			Запись.ИдентификаторОбъекта = НаименованиеОбъекта;
			Запись.Записать();
		КонецЕсли; 
	КонецЦикла;
	
	ВыборкаРезультатЗапросаСкладСнабжение = РезультатЗапросаСкладСнабжение.Выбрать();
	
	Пока ВыборкаРезультатЗапросаСкладСнабжение.Следующий() Цикл
		КодОбъекта = СокрЛП(ВыборкаРезультатЗапросаСкладСнабжение.Код);
		ИмяКаталога = КаталогКартинок + КодОбъекта;
		Картинки = ПолучитьСписокКартинок(ИмяКаталога, КодОбъекта, РасширенияКартинок);
		ЕстьКартинка = Картинки.Количество() <> 0;
		
		Если ВыборкаРезультатЗапросаСкладСнабжение.ЕстьФайлы <> ЕстьКартинка Тогда
			Запись = РегистрыСведений.дт_НаличиеФайлов.СоздатьМенеджерЗаписи();
			Запись.ОбъектСФайлами = ВыборкаРезультатЗапросаСкладСнабжение.Ссылка;
			Запись.ЕстьФайлы = ЕстьКартинка;
			Запись.ИдентификаторОбъекта = КодОбъекта;
			Запись.Записать();
		КонецЕсли;
	КонецЦикла;
	///-ГомзМА 18.04.2023
	
КонецПроцедуры




Функция ПолучитьСписокКартинок(ИмяКаталога, КодОбъекта, Расширения = Неопределено) Экспорт
	
	Если Расширения = Неопределено Тогда
		Расширения = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьРасширенияКартинок();
	КонецЕсли;
	
	Результат = Новый Массив();
	
	Для каждого Расширение Из Расширения Цикл
		Файлы = НайтиФайлы(ИмяКаталога, "*." + Расширение);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, Файлы);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти