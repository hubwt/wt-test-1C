#Область ПрограммныйИнтерфейс
// Выполняет движения регистра накопления РегистрНакопления1
//
Процедура ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицыДляСписания = Новый Массив();
	ТаблицыДляСписания.Добавить("ТаблицаСписанныеТовары");
	ТаблицыДляСписания.Добавить("ТаблицаТовары");
	ТаблицыДляСписания.Добавить("ТаблицаМатериалы");
	ТаблицыДляСписания.Добавить("ТаблицаТоварыНаКомиссии");
	
	
	ТаблицаДвижения = Неопределено;
	
	Для каждого ИмяТаблицы Из ТаблицыДляСписания Цикл
	
		Если ПараметрыПроведения.Свойство(ИмяТаблицы) Тогда
			
			Если ТаблицаДвижения = Неопределено Тогда
				ТаблицаДвижения = ПараметрыПроведения[ИмяТаблицы].Скопировать();
			Иначе
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПараметрыПроведения[ИмяТаблицы], ТаблицаДвижения);
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
	Если Отказ
	 ИЛИ ТаблицаДвижения = Неопределено 
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.РегистрНакопления1;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры


// Выполняет движения регистра накопления РегистрНакопления1
//
Процедура ОтразитьДвиженияТоварыВТранзитнойЗоне(ПараметрыПроведения, Движения, Отказ) Экспорт
	
	ТаблицаДвижения = ПараметрыПроведения.ТаблицаТоварыВТранзитнойЗоне;
	Если Отказ
	 ИЛИ ТаблицаДвижения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	ДвиженияНабор = Движения.ТоварыВТранзитнойЗоне;
	ДвиженияНабор.Записывать = Истина;
	ДвиженияНабор.Загрузить(ТаблицаДвижения);
	
КонецПроцедуры

// Готовит к записи наборы записей документа (только по регистрам, входящих в подсистему)
//
Процедура ПодготовитьНаборыЗаписей(СтруктураОбъект) Экспорт
	
	РегистрыПодсистемы = Новый Массив;
	РегистрыПодсистемы.Добавить("РегистрНакопления1");
	
	Для каждого Регистр Из РегистрыПодсистемы Цикл
	
		НаборЗаписей = СтруктураОбъект.Движения.Найти(Регистр);
		
		Если НаборЗаписей <> Неопределено Тогда
			Если НЕ НаборЗаписей.ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
				
				НаборЗаписей.ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
				
			КонецЕсли;
			
			Если НЕ НаборЗаписей.ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
				
				НаборЗаписей.ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", СтруктураОбъект.ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы);
				
			КонецЕсли;
			
			//РегистрыНакопления[Регистр].СоздатьПустуюВременнуюТаблицуИзменение(СтруктураОбъект.ДополнительныеСвойства);
		
		КонецЕсли;
	
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТранзитныйСклад(ДокументОбъект) Экспорт
	
	СкладТранзитный = Неопределено;
	
	Если ЗначениеЗаполнено(ДокументОбъект.Склад) Тогда
		
		Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ЗаявкаНаСборку")
			И ДокументОбъект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаявокНаСборку.ВозвратОтКлиента")
			И  НЕ ДокументОбъект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаявокНаСборку.СборкаСоСклада") Тогда
				
			//СкладТранзитный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект.Склад, "ЗонаПриемкиВозвратов");
			
		Иначе
			СкладТранзитный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект.Склад, "ЗонаСборки");
		КонецЕсли;
		
	КонецЕсли;
	
	ДокументОбъект.СкладТранзитный = СкладТранзитный;
	
КонецПроцедуры

Функция ДатаНачалаИспользованияЗаявокНаСборку() Экспорт
	Возврат '20220516';
КонецФункции
#КонецОбласти

#Область Формы
Процедура ЗаполнитьПартииПоОстаткамНаСервере(Объект, ИмяТабличнойЧасти, ИмяРеквизитаСклад, МоментВремени, МВТ) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МИНИМУМ(ВТ_Источник.НомерСтроки) КАК НомерСтроки,
		|	ВТ_Источник.Номенклатура КАК Номенклатура,
		|	СУММА(ВТ_Источник.Количество) КАК Количество,
		|	ВЫБОР
		|		КОГДА ВТ_Источник.Склад = &ПустойСклад
		|			ТОГДА &Склад
		|		ИНАЧЕ ВТ_Источник.Склад
		|	КОНЕЦ КАК Склад,
		|	ВТ_Источник.Автомобиль КАК Автомобиль
		|ПОМЕСТИТЬ ВТ_Таблица
		|ИЗ
		|	ВТ_Источник КАК ВТ_Источник
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Источник.Номенклатура,
		|	ВЫБОР
		|		КОГДА ВТ_Источник.Склад = &ПустойСклад
		|			ТОГДА &Склад
		|		ИНАЧЕ ВТ_Источник.Склад
		|	КОНЕЦ,
		|	ВТ_Источник.Автомобиль
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТ_Источник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Таблица.НомерСтроки КАК НомерСтроки,
		|	ВТ_Таблица.Номенклатура КАК Номенклатура,
		|	ВТ_Таблица.Количество КАК Количество,
		|	ВТ_Таблица.Склад КАК Склад,
		|	ЕСТЬNULL(Остатки.КолвоОстаток, 0) КАК КоличествоОстаток,
		|	Остатки.индкод КАК Партия,
		|	Остатки.машина КАК Автомобиль
		|ИЗ
		|	ВТ_Таблица КАК ВТ_Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки(
		|				&МоментВремени,
		|				Склад В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_Таблица.Склад
		|					ИЗ
		|						ВТ_Таблица)) КАК Остатки
		|		ПО ВТ_Таблица.Склад = Остатки.Склад
		|			И ВТ_Таблица.Номенклатура = Остатки.Товар
		|			И ВТ_Таблица.Автомобиль = Остатки.машина
		|ГДЕ
		|	ЕСТЬNULL(Остатки.КолвоОстаток, 0) >= 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки,
		|	Остатки.индкод.ДатаПоступления
		|ИТОГИ
		|	МАКСИМУМ(Количество),
		|	СУММА(КоличествоОстаток)
		|ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени);
	Запрос.УстановитьПараметр("ПустойСклад", Справочники.Склады.ПустаяСсылка());
	Запрос.УстановитьПараметр("Склад", Объект[ИмяРеквизитаСклад]);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаНомерСтроки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНомерСтроки.Следующий() Цикл
		
		Нехватка = ВыборкаНомерСтроки.Количество - ВыборкаНомерСтроки.КоличествоОстаток;
		СтрокаИсточник =  Объект[ИмяТабличнойЧасти][ВыборкаНомерСтроки.НомерСтроки - 1];
		Если Нехватка > 0 Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабличнойЧасти, ВыборкаНомерСтроки.НомерСтроки, "Количество");
			ТекстСообщения = СтрШаблон(
				"Строка %1: Количество %2 %3 превышает остаток по складу. Нехватка: %4", 
				ВыборкаНомерСтроки.НомерСтроки, 
				?(ИмяТабличнойЧасти = "Материалы", "материала", "товара"),
				СтрокаИсточник.Номенклатура,
				//Выборка.КоличествоИзменение, 
				Нехватка);
			
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "Объект");
			Продолжить;	
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи = ВыборкаНомерСтроки.Выбрать();
	    Индекс = 0;
		
		ОсталосьСписать = СтрокаИсточник.Количество;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если Индекс = 0 Тогда
				СтрокаТаблицы = СтрокаИсточник;
			Иначе
				СтрокаТаблицы = Объект[ИмяТабличнойЧасти].Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаИсточник);
			КонецЕсли;
			
			КоличествоКСписанию = Мин(ВыборкаДетальныеЗаписи.КоличествоОстаток, ОсталосьСписать);
			СтрокаТаблицы.Партия = ВыборкаДетальныеЗаписи.Партия;
			СтрокаТаблицы.Количество = КоличествоКСписанию;
			СтрокаТаблицы.Автомобиль = ВыборкаДетальныеЗаписи.Автомобиль;
			
			дт_АвтосервисКлиентСервер.ОбработкаИзмененияСтроки(Объект, ИмяТабличнойЧасти, СтрокаТаблицы, "Количество");
			
			ОсталосьСписать = ОсталосьСписать - КоличествоКСписанию;
			
			Если ОсталосьСписать <= 0 Тогда
				Прервать
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЦикла;
	КонецЦикла;
	
	

КонецПроцедуры // ЗаполнитьПартииПоОстаткамНаСервере()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти