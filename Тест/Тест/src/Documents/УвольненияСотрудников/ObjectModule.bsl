#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
 



#КонецОбласти

#Область ОбработчикиСобытий


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не ЗначениеЗаполнено(НомерИсходящий) Тогда
		НомерИсходящий = дт_Нумерация.СвободныйНомерДокумента(
				Метаданные().Имя, 
				Дата, 
				дт_ОбщегоНазначения.ПрефиксОрганизации(Организация),
				"НомерИсходящий",
				Ссылка
		);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОтключитьПользователей(Отказ);
	КонецЕсли;
	
	// ++ Мазин 21-05-24 
	
	
	// -- Мазин 21-05-24 	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
	ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	
	ПараметрыПроведения = Документы.УвольненияСотрудников.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	// Формирование движений
	дт_Зарплата.ОтразитьДолжностиСотрудников(ПараметрыПроведения, Движения, Отказ);
	
КонецПроцедуры




#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтключитьПользователей(Отказ = Ложь)

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.Сотрудник,
		|	Сотрудники.Дата
		|ПОМЕСТИТЬ втСотрудники
		|ИЗ
		|	&Сотрудники КАК Сотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сотрудники.Пользователь,
		|	втСотрудники.Дата
		|ПОМЕСТИТЬ втПользователи
		|ИЗ
		|	втСотрудники КАК втСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО Сотрудники.Ссылка = втСотрудники.Сотрудник
		|		И НЕ Сотрудники.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втПользователи.Пользователь
		|ИЗ
		|	втПользователи КАК втПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО втПользователи.Пользователь = Пользователи.Ссылка
		|		И ВЫБОР
		|			КОГДА втПользователи.Дата = ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА &ДатаДокумента
		|			ИНАЧЕ втПользователи.Дата
		|		КОНЕЦ <= &ТекущаяДата
		|		И НЕ Пользователи.Недействителен";
	
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники.Выгрузить());
	Запрос.УстановитьПараметр("ДатаДокумента", НачалоДня(Дата));
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДата()));
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	НачатьТранзакцию();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ПользовательОбъект = ВыборкаДетальныеЗаписи.Пользователь.ПолучитьОбъект();
		
		Если ПользовательОбъект = Неопределено Тогда
			Продолжить
		КонецЕсли;
		 
		ПользовательОбъект.Недействителен = Истина;
		
		Попытка
			ПользовательОбъект.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон("Не удалось отключить пользователя %1. %2",
					ПользовательОбъект,
					ОписаниеОшибки()),
				,
				,
				,
				Отказ
			);
			
		КонецПопытки;
	КонецЦикла;
	
	Если ТранзакцияАктивна() Тогда
		Если Отказ Тогда 
			ОтменитьТранзакцию();
		Иначе
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли





