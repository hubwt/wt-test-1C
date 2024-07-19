#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий


Процедура ПередЗаписью(Отказ)
	
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку")
		И НЕ ЗначениеЗаполнено(ЭтотОбъект.Состояние) Тогда
		
		Состояние = Перечисления.Состояние.Новый; 
		
	КонецЕсли;
	
	ЗаполнитьНомерЗамен();
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	
	ДатаСоздания = '00010101';
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат
	КонецЕсли;
	
	
	// проверим уникальность городов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СвойстваПоГородам.Город КАК Город,
		|	СвойстваПоГородам.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_СвойстваПоГородам
		|ИЗ
		|	&СвойстваПоГородам КАК СвойстваПоГородам
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Город
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СвойстваПоГородам.Город КАК Город,
		|	МИНИМУМ(ВТ_СвойстваПоГородам.НомерСтроки) КАК НомерСтроки
		|ИЗ
		|	ВТ_СвойстваПоГородам КАК ВТ_СвойстваПоГородам
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_СвойстваПоГородам.Город
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(ВТ_СвойстваПоГородам.НомерСтроки) > 1
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("СвойстваПоГородам", СвойстваПоГородам.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("СвойстваПоГородам", ВыборкаДетальныеЗаписи.НомерСтроки, "Город");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Строка %1. Неоднозначно определены свойства для города %2",
				ВыборкаДетальныеЗаписи.НомерСтроки,
				ВыборкаДетальныеЗаписи.Город),
			ЭтотОбъект,
			Поле,
			"Объект",
			Отказ
		);
				
	КонецЦикла;
	

	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНомерЗамен() Экспорт

	НомерЗаменИндекс = "";
	
	Если НомераЗамен.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из НомераЗамен Цикл
	
		НомерЗаменИндекс = НомерЗаменИндекс + СтрокаТаблицы.НомерЗамены + ", ";	
	
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(НомерЗаменИндекс, 2);

КонецПроцедуры



Процедура ПриЗаписи(Отказ)
	//ПроверкаЦены();
КонецПроцедуры

Процедура КорректировкаЦены()
 ЗапросИнкода = новый Запрос;
 ЗапросИнкода.текст = "ВЫБРАТЬ
 |	РегистрНакопления1Остатки.Товар КАК Товар,
 |	РегистрНакопления1Остатки.индкод КАК индкод,
 |	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток,
 |	РегистрНакопления1Остатки.Склад КАК Склад,
 |	ИндНомер.Цена КАК Цена
 |ИЗ
 |	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
 |		ПО РегистрНакопления1Остатки.индкод = ИндНомер.индкод
 |ГДЕ
 |	РегистрНакопления1Остатки.Товар = &Товар";
 ЗапросИнкода.УстановитьПараметр("Товар",Ссылка);
 
 Выборка  = ЗапросИнкода.Выполнить().Выбрать();
 
 Если Выборка.Количество() > 0 Тогда
	 Пока Выборка.Следующий() Цикл 
		 
	 КонецЦикла;
 КонецЕсли;
 	 
КонецПроцедуры



#КонецОбласти

#КонецЕсли