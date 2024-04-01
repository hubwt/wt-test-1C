#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение
Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	НомераТаблиц = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	НомераТаблиц = Новый Структура;

	Запрос.Текст =
		ТекстЗапросаПоказанияОдометра(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		Таблица =  Результат[НомерТаблицы.Значение].Выгрузить();
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Таблица);
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции


Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Состояние КАК Состояние,
	|	Реквизиты.Автомобиль КАК Автомобиль,
	|	Реквизиты.Ответственный КАК Ответственный,
	|	Реквизиты.ПоказанияОдометраНачало КАК ПоказанияОдометраНачало
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ЗаявкаНаОбслуживание КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Ответственный КАК Ответственный,
	|	Реквизиты.Состояние КАК Состояние,
	|	Реквизиты.Автомобиль КАК Автомобиль,
	|	Реквизиты.ПоказанияОдометраНачало КАК ПоказанияОдометраНачало
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + дт_ОбщегоНазначенияВызовСервераПовтИсп.ТекстРазделителяЗапросовПакета();
	

КонецФункции // ТекстЗапросаРеквизиты()



Функция ТекстЗапросаПоказанияОдометра(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаПоказанияОдометра", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Автомобиль КАК Автомобиль,
	|	Реквизиты.ПоказанияОдометраНачало КАК Показание
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|ГДЕ
	|	Реквизиты.ПоказанияОдометраНачало <> 0
	|";
	

	Возврат ТекстЗапроса + дт_ОбщегоНазначенияВызовСервераПовтИсп.ТекстРазделителяЗапросовПакета();
	

КонецФункции // ТекстЗапросаРеквизиты()



#КонецОбласти 




#Область Печать
// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаказНаряд") Тогда
	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЗаказНаряд", "Перемещение товаров", 
	//		ПечатьЗаказНаряд(МассивОбъектов, ОбъектыПечати),,"Документ.ЗаказНаряд.ПФ_MXL_ЗаказНаряд");
	//КонецЕсли;
	
	//ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов,
	//	КоллекцияПечатныхФорм,
	//	ОбъектыПечати,
	//	ПараметрыВывода);
	
КонецПроцедуры



#КонецОбласти 



#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли